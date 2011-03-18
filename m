From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [GIT] isci: fixes
Date: Fri, 18 Mar 2011 09:48:19 +0800
Message-ID: <E66D8E1A56E44A4F80B9148124A35919@usish.com.cn>
References: <1300379481.26377.21.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:35448 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab1CRBs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2011 21:48:28 -0400
In-Reply-To: <1300379481.26377.21.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Williams' <dan.j.williams@intel.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'Ed Nadolski' <edmund.nadolski@intel.com>, 'Dave Jiang' <dave.jiang@intel.com>, 'David Milburn' <dmilburn@redhat.com>, 'Ed Ciechanowski' <ed.ciechanowski@intel.com>, 'Jeff Skirvin' <jeffrey.d.skirvin@intel.com>, 'Jacek Danecki' <jacek.danecki@intel.com>, 'Jeff Garzik' <jeff@garzik.org>, 'James Bottomley' <James.Bottomley@suse.de>

> commit 0d17f0069cee7cf8b51a67d35130ebf35fe72522
> Author: Dan Williams <dan.j.williams@intel.com>
> Date:   Fri Mar 11 14:06:08 2011 -0800
> 
>     libsas: check dev->gone before submitting sata i/o
> 
>     Head off doomed-to-fail i/o in sas_queuecommand before sending it down
>     the ata path.
> 
>     Before:
>     sd 7:0:0:0: [sdd] Synchronizing SCSI cache
>     ata8: no sense translation for status: 0x00
>     ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
>     ata8.00: device reported invalid CHS sector 0
>     ata8: status=0x00 { }
>     ata8: no sense translation for status: 0x00
>     ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
>     ata8.00: device reported invalid CHS sector 0
>     ata8: status=0x00 { }
>     ata8: no sense translation for status: 0x00
>     ata8: translated ATA stat/err 0x00/00 to SCSI SK/ASC/ASCQ 0xb/00/00
>     ata8.00: device reported invalid CHS sector 0
>     ata8: status=0x00 { }
>     sd 7:0:0:0: [sdd]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>     sd 7:0:0:0: [sdd]  Sense Key : Aborted Command [current] [descriptor]
>     sd 7:0:0:0: [sdd]  Add. Sense: No additional sense information
>     sd 7:0:0:0: [sdd] Stopping disk
> 
>     After:
>     sd 9:0:0:0: [sdd] Synchronizing SCSI cache
>     sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
>     sd 9:0:0:0: [sdd] Stopping disk
>     sd 9:0:0:0: [sdd] START_STOP FAILED
>     sd 9:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
> 
>     This is a cosmetic change as sata i/o can still leak to a gone device,
>     but this addresses the nominal hotplug case when releasing the target.
> 
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
[Jack Wang] We also see this before, thanks for fix.

