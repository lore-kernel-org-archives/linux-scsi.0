From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] scsi_host regression: fix scsi host leak
Date: Fri, 13 Jun 2008 19:50:48 -0500
Message-ID: <485315E8.1090005@cs.wisc.edu>
References: <1213230060-11388-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020709020403050804070103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32868 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755354AbYFNBX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2008 21:23:29 -0400
Received: from [20.15.0.7] (c-75-73-66-60.hsd1.mn.comcast.net [75.73.66.60])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id m5E0or2k029019
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2008 19:50:54 -0500
In-Reply-To: <1213230060-11388-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020709020403050804070103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> In 2.6.25 we started using class_find_child instead of implementing
> our own loop and lookup. The problem is that class_find_child would get a
> reference to the host's device, then scsi_host_lookup would get an extra
> reference to it when it called scsi_host_get().
> 
> In 2.6.26 we started using class_find_device, and this function also
> gets a reference to the device, so we end up with an extra ref
> and the host will not get released.
> 
> This patch is made against scsi-rc-fixes and adds a put_device to
> balance the class_find_device() get. I kept the scsi_host_get in
> scsi_host_lookup, because the target layer is using scsi_host_lookup
> and it looks like it needs the SHOST_DEL check.
> 
> For 2.6.25 we need a similar patch, but instead of calling
> put_device we have to call class_device_put() due to the differences
> in the the driver model device/class_device between 2.6.25 and
> 2.6.26. I can send a patch for 2.6.25 in a seperate mail.
> 

Attached is a patch for 2.6.25. Sorry it is late and attached instead of 
inlined. I can send it in a new thread if you want too. I just want to 
make sure people know it is slightly different from the scsi-rc-fixes 
patch because of the driver model changes.

--------------020709020403050804070103
Content-Type: text/plain;
 name="fix-host-refcount.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-host-refcount.patch"

In 2.6.25 we started using class_find_child instead of implementing
our own loop and lookup. The problem is that class_find_child would get a
reference to the host's device, then scsi_host_lookup would get an extra
reference to it when it called scsi_host_get(). This patch drops the
ref from class_find_child because scsi_host_get gets a ref if the host
is not being removed.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

--- linux-2.6.25.2/drivers/scsi/hosts.c	2008-05-06 18:21:32.000000000 -0500
+++ linux-2.6.25.2.work/drivers/scsi/hosts.c	2008-06-13 19:43:15.000000000 -0500
@@ -455,9 +455,10 @@ struct Scsi_Host *scsi_host_lookup(unsig
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO);
 
 	cdev = class_find_child(&shost_class, &hostnum, __scsi_host_match);
-	if (cdev)
+	if (cdev) {
 		shost = scsi_host_get(class_to_shost(cdev));
-
+		class_device_put(cdev);
+	}
 	return shost;
 }
 EXPORT_SYMBOL(scsi_host_lookup);

--------------020709020403050804070103--
