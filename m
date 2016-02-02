From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Tue, 02 Feb 2016 14:12:00 -0600
Message-ID: <56B10D90.2010506@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/> <56AAC605.1080707@cs.wisc.edu> <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com> <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu> <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com> <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu> <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com> <56ABBCFF.9060003@cs.wisc.edu> <26376c0ade5645cfac5cc248a97528ba@XCH-ALN-006.cisco.com> <56ABF6A6.8070506@cs.wisc.edu> <20160202180956.GB13880@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010900070203030205000805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56095 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbcBBUMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 15:12:39 -0500
In-Reply-To: <20160202180956.GB13880@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>, "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

This is a multi-part message in MIME format.
--------------010900070203030205000805
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 02/02/2016 12:09 PM, Christoph Hellwig wrote:
> On Fri, Jan 29, 2016 at 05:32:54PM -0600, Mike Christie wrote:
>> Hey Christoph and Hannes,
>>
>> The dh/alua changes that added this:
>>
>>         error = scsi_dh_add_device(sdev);
>>         if (error) {
>>                 sdev_printk(KERN_INFO, sdev,
>>                                 "failed to add device handler: %d\n",
>> error);
>>                 return error;
>>         }
>>
>> to scsi_sysfs_add_sdev are adding a regression.
>>
>> 1. If that fails, then we forget to do device_del before doing the
>> return. My patch in this thread added that back, so we do not see the
>> sysfs oopses anymore. But.....
> 
> Ok.
> 
>> 2. It looks like in older kernels, we would allow misconfigured targets
>> like this one to still setup devices. Do we want that old behavior back?
>> Should we just ignore the return value from scsi_dh_add_device above?
>> Note that in this case, it is LIO so it can be easily fixed on the
>> target side by just setting it up properly. I do not think other targets
>> would hit this type of issue.
> 
> Be liberal in what you accept..  I guess we need to continue allowing
> to connect to these broken targets, but a warning would be useful.
> 
> Can you send a patch?

Serguei, can you try the attached patch? Drop the other one I sent.

--------------010900070203030205000805
Content-Type: text/x-patch;
 name="scsi-allow-attach-failures.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi-allow-attach-failures.patch"

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 21930c9..7dcc4bf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1059,9 +1059,12 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	error = scsi_dh_add_device(sdev);
 	if (error) {
+		/*
+		 * Allow device setup to succeed. Attachment can be retried
+		 * from userpsace or device can be still used in degraded mode.
+		 */
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device handler: %d\n", error);
-		return error;
 	}
 
 	device_enable_async_suspend(&sdev->sdev_dev);

--------------010900070203030205000805--
