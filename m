From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
Date: Fri, 29 Jan 2016 13:26:55 -0600
Message-ID: <56ABBCFF.9060003@cs.wisc.edu>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
 <56AAC605.1080707@cs.wisc.edu>
 <9cf7d536fcc44d9d8f35d81503543497@XCH-ALN-006.cisco.com>
 <36266784-E570-406E-8C3A-56D0F728768B@cs.wisc.edu>
 <a331d83963b64d7da77352b01c1d10da@XCH-ALN-006.cisco.com>
 <01C3BBA0-3D1A-461A-9EEF-512A57707325@cs.wisc.edu>
 <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070406030407050909050406"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53552 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756713AbcA2T1E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 14:27:04 -0500
In-Reply-To: <4c4653b259cd4f1887505dfc61d500a8@XCH-ALN-006.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc: "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070406030407050909050406
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit



On 01/29/2016 01:11 PM, Serguei Bezverkhi (sbezverk) wrote:
> If you send me the diff for your patch, I will build new kernel myself.
> 

Bugzilla must be messing something up. I attached to one of the previous
mails. Attaching it here again.

Email me offlist and without bugzilla if you do not get it here.

The patch will fix the syfs bug ons you are hitting.

I am not sure if it will fix the genhd one. We can deal with that one
next if it is a different issue.


> Serguei
> 
> 
> Serguei Bezverkhi,
> TECHNICAL LEADER.SERVICES
> Global SP Services
> sbezverk@cisco.com
> Phone: +1 416 306 7312
> Mobile: +1 514 234 7374
> 
> CCIE (R&S,SP,Sec) - #9527
> 
> Cisco.com
> 
> 
> 
>  Think before you print.
> This email may contain confidential and privileged material for the sole use of the intended recipient. Any review, use, distribution or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive for the recipient), please contact the sender by reply email and delete all copies of this message.
> Please click here for Company Registration Information.
> 
> 
> 
> 
> -----Original Message-----
> From: Michael Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Friday, January 29, 2016 2:09 PM
> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
> 
> 
>> On Jan 29, 2016, at 6:04 AM, Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com> wrote:
>>
>> Actually this server uses both cases: Local taregts (since it is OpenStack server) and remote targets as it tries to mount 4 remotefile systems.  
>>
>> You are correct, I always use the same box I just change the kernel it is using to boot. No other changes to the environment. I do not mind to load a test kernel without that suspected patch, just get me the RPM.
>>
> 
> I do not know what you mean. I think the patch I sent will fix the sysfs errors caused due to alua not being setup properly on your system and scsi_dh_alua failing to attach. That patch should be applied to the 4.4 upstream kernel. Are you saying you want me to make you a kernel rpm?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


--------------070406030407050909050406
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
 

--------------070406030407050909050406--
