From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Sat, 28 Oct 2006 11:41:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610281133100.2757-100000@netrider.rowland.org>
References: <454283F2.3090809@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.rowland.org ([192.131.102.7]:3848 "HELO mx2.rowland.org")
	by vger.kernel.org with SMTP id S1750898AbWJ1Plf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Oct 2006 11:41:35 -0400
In-Reply-To: <454283F2.3090809@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Oct 2006, Douglas Gilbert wrote:

> Some more information on this subject: LLDs (including
> pseudo ones like usb-storage) really should set the
> Scsi_Cmnd::resid field to show, in the case of an
> INQUIRY, when 36 bytes were requested, less bytes
> were returned.

Indeed.  usb-storage does do this.  However the devices addressed by this
patch do send 36 bytes of data, all apparently plausible, just as you 
say directly-attached ATA disks do.  So checking the residue wouldn't 
help.

> That OS from Redmond may have a hand here as well.
> Directly attached ATA disks are found in SCSI scans and
> respond to SCSI INQUIRY commands with plausible vendor,
> model and revision strings but the additional length
> field (byte 4 in the response) is set to 0. So code
> could use that as a hint to stop sending further SCSI
> commands and start sending ATA commands. ATA disks
> behind USB and IEEE 1394 don't appear in SCSI scans
> but do appear as "Physical Drives" and do respond
> to SCSI INQUIRY commands properly.

I don't understand this.  What do you mean, they don't appear in SCSI 
scans?  They _are_ detected by scsi_probe_lun().  But they probably don't 
show any special ATA signature in the INQUIRY data, since that data is 
generally determined by the firmware in the USB/1394 interface.

>  Then there are
> ATA disks behind a SATL and they respond to SCSI
> INQUIRY commands (and most others) properly; the
> easiest way to spot them is that the vendor is "ATA     ".
> 
> Doug Gilbert

Alan Stern

