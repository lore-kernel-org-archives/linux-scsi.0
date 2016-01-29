From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 02:25:43 -0600
Message-ID: <56AB2207.3060607@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/> <56AAC605.1080707@cs.wisc.edu> <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com> <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070802040700060300020509"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53300 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbcA2IZw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 03:25:52 -0500
In-Reply-To: <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070802040700060300020509
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 01/29/2016 02:01 AM, Michael Christie wrote:
> Can you send me your lio config?
> 

Not sure what I was thinking. Don't send me anything. Could you just try
the attached patch?

--------------070802040700060300020509
Content-Type: text/x-patch;
 name="fix-add-dev-alua-attach-fail-regression.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix-add-dev-alua-attach-fail-regression.patch"

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 21930c9..4269cbc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1061,6 +1061,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
 				"failed to add device handler: %d\n", error);
+		device_del(&sdev->sdev_gendev);
 		return error;
 	}
 

--------------070802040700060300020509--
