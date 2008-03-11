From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [BUG 1/3] bsg queue oops with iscsi logout
Date: Tue, 11 Mar 2008 00:36:51 -0500
Message-ID: <47D61A73.3000803@cs.wisc.edu>
References: <20080309165359.GA24388@osc.edu> <47D5766C.3020206@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050401070702050006030203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36360 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbYCKFhI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Mar 2008 01:37:08 -0400
In-Reply-To: <47D5766C.3020206@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, Erez Zilber <erezz@voltaire.com>

This is a multi-part message in MIME format.
--------------050401070702050006030203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Christie wrote:
> Pete Wyckoff wrote:
>> I think this used not to happen; not sure.  But I changed two things
> 
> This most likely did not happen before 2.6.25-rc* or it broke in 
> slightly different ways, because iscsi used to try and do
> 
> echo 1 > /sys/block/sdX/device/delete
> 
> from userspace instead of calling scsi_remove_target from the kernel.
> 
> As you know around 2.6.21, the behavior of doing the echo to the delete 
> file changed due to a driver model and scsi change and that broke the 
> iscsi tools. The iscsi tools userspace removal was sort of hack in the 
> first place and was racey, so we switched to removing devices/target 
> like the FC class.
> 
> 
>> lately.  2.6.25-rc1 to -rc4 and fedora 8 iscsi-initiator-utils (865) to
>> fedora devel (868).  Bidi and varlen patches always too.
>>
>> I'll follow with some more variations on this theme.  Looks like bsg
>> needs to protect more carefully against the device going away.  Any
>> ideas how best to do this?  What was the approach in sg?
>>
> 
> I think sg is broken in similar ways. The iser guys have some tests 
> cases that have broken sg while IO is outstanding. I am ccing Erez.

Actually one of the problems looks a little different than some of the 
problems hit with sg and are caused because we remove the bsg device too 
soon. I think we want to wait until all the references from the 
commands/requests are released. The attached patch (untested) moves the 
bsg unreg call to the scsi device release fn.

--------------050401070702050006030203
Content-Type: text/x-patch;
 name="delay-bsg-unreg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="delay-bsg-unreg.patch"

Delay bsg unregistration, because we want to wait until all the request/cmds
have released their reference.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ed83cdb..b9b09a7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -294,6 +294,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	}
 
 	if (sdev->request_queue) {
+		bsg_unregister_queue(sdev->request_queue);
 		sdev->request_queue->queuedata = NULL;
 		/* user context needed to free queue */
 		scsi_free_queue(sdev->request_queue);
@@ -857,7 +858,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
-	bsg_unregister_queue(sdev->request_queue);
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);

--------------050401070702050006030203--
