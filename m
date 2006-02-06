From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: [PATCH] scsi core: fix uninitialized variable error
Date: Mon, 06 Feb 2006 09:42:53 +0100
Message-ID: <43E70C0D.3060301@shadowconnect.com>
References: <20060205150133.GC16090@parisc-linux.org> <Pine.LNX.4.44L0.0602051107120.16521-100000@netrider.rowland.org> <20060205213049.GG16090@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s0006.shadowconnect.net ([213.202.216.60]:703 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S1750793AbWBFImc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 03:42:32 -0500
In-Reply-To: <20060205213049.GG16090@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hello,

Matthew Wilcox wrote:
> On Sun, Feb 05, 2006 at 11:11:24AM -0500, Alan Stern wrote:
>>> -	if (scsi_host_scan_allowed(shost)) {
>>> -		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
>>> -					     hostdata);
>>> -		if (res != SCSI_SCAN_LUN_PRESENT)
>>> -			sdev = ERR_PTR(-ENODEV);
>>> -	}
>>> +	if (scsi_host_scan_allowed(shost))
>>> +		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
>>>  	mutex_unlock(&shost->scan_mutex);
>> This assumes that scsi_probe_and_add_lun doesn't assign anything to the 
>> &sdev pointer if it returns anything other than SCSI_SCAN_LUN_PRESENT.  
>> Since that assumption is true for the current code, this version of the 
>> patch will work as well as mine.
> 
> Perhaps the better way to think about this usage of
> scsi_probe_and_add_lun() is "If it finds an sdev, then we should return
> it".  Right now, we're assuming that returning SCSI_SCAN_LUN_PRESENT is
> equivalent to having found an sdev.
> 
> The real problem is that scsi_probe_and_add_lun() has an enormously
> complicated interface.  The good news is that it's static, so we can see
> all its callers.  The bad news is that the kernel-doc comment is out of
> date and not terribly helpful.
> 
> Its callers are:
> 
> scsi_sequential_lun_scan()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(!= SCSI_SCAN_LUN_PRESENT)
> scsi_report_lun_scan()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(== SCSI_SCAN_NO_RESPONSE)
> __scsi_add_device()
> 	scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata)
> 		(== SCSI_SCAN_LUN_PRESENT in current, unused in my patch)
> __scsi_scan_target()
> 	scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL)
> 		(unused)
> 	scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL)
> 		(== SCSI_SCAN_LUN_PRESENT or SCSI_SCAN_TARGET_PRESENT)
> 
> I can see some ways to simplify this interface.  As noted in a comment:
> 
>                  * XXX add a bflags to scsi_device, and replace the
>                  * corresponding bit fields in scsi_device, so bflags
>                  * need not be passed as an argument.
> 
> I *think* we can get rid of the hostdata parameter.  The only non-NULL
> caller is __scsi_add_device().  The only caller of __scsi_add_device()
> which specifies hostdata is i2o_scsi.  I don't see why it can't use a
> ->slave_alloc in the host template to set hostdata rather than passing
> it in.

Please don't remove the hostdata parameter. It's the only way to get the 
mapping between I2O device and SCSI devices.


Thank you very much.



Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
