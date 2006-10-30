From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Mon, 30 Oct 2006 11:40:42 -0500
Message-ID: <45462B0A.3070909@torque.net>
References: <Pine.LNX.4.44L0.0610281133100.2757-100000@netrider.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14541 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030546AbWJ3Qkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Oct 2006 11:40:47 -0500
In-Reply-To: <Pine.LNX.4.44L0.0610281133100.2757-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Fri, 27 Oct 2006, Douglas Gilbert wrote:
> 
>> Some more information on this subject: LLDs (including
>> pseudo ones like usb-storage) really should set the
>> Scsi_Cmnd::resid field to show, in the case of an
>> INQUIRY, when 36 bytes were requested, less bytes
>> were returned.
> 
> Indeed.  usb-storage does do this.  However the devices addressed by this
> patch do send 36 bytes of data, all apparently plausible, just as you 
> say directly-attached ATA disks do.  So checking the residue wouldn't 
> help.
> 
>> That OS from Redmond may have a hand here as well.
>> Directly attached ATA disks are found in SCSI scans and
>> respond to SCSI INQUIRY commands with plausible vendor,
>> model and revision strings but the additional length
>> field (byte 4 in the response) is set to 0. So code
>> could use that as a hint to stop sending further SCSI
>> commands and start sending ATA commands. ATA disks
>> behind USB and IEEE 1394 don't appear in SCSI scans
>> but do appear as "Physical Drives" and do respond
>> to SCSI INQUIRY commands properly.
> 
> I don't understand this.  What do you mean, they don't appear in SCSI 
> scans?  They _are_ detected by scsi_probe_lun().  But they probably don't 
> show any special ATA signature in the INQUIRY data, since that data is 
> generally determined by the firmware in the USB/1394 interface.

I'm not talking about linux!
For a code example look at sg_scan.c in sg3_utils version
1.22 in the sg_do_wscan() function, particularly the setting
of the 'dubious_scsi' field.

We have seen this before, especially with INQUIRY responses:
the quirks of that OS go some way to explaining why we see
some devices react they way they do.

36 byte INQUIRY responses (or greater) have been mandatory
since SCSI-2 (1992) and that means the additional length
field must be >= 31 . These devices don't give a hoot about
formal standards, only one informal one counts.

Doug Gilbert
