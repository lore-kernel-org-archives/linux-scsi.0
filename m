From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 12 May 2010 14:48:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1005121444450.1353-100000@iolanthe.rowland.org>
References: <1273678767.2808.17.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52461 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755671Ab0ELSsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2010 14:48:07 -0400
In-Reply-To: <1273678767.2808.17.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mark Lord <mlord@pobox.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 12 May 2010, James Bottomley wrote:

> > This sounds like it is a bug in the SCSI midlayer, not in usb-storage.  
> 
> I don't think so ... we'll return sense if sense is present (i.e. the
> device returned CHECK CONDITION).

> Sense data is never returned in the absence of CHECK CONDITION.  This is
> what SAT says has to happen if you set CK_COND in ATA(12/16):
> 
>         The CK_COND (Check Condition) bit may be used to request the
>         SATL to
>         return a copy of ATA register information in the sense data upon
>         command completion. If the CK_COND bit is set to one the SATL
>         shall
>         return a status of CHECK CONDITION when the ATA command
>         completes,
>         even if the command completes successfully, and return the ATA
>         Normal Output fields (see ATA8-ACS) in the sense data using the
>         ATA Return descriptor (see 12.2.6). If the CK_COND bit is set to
>         zero, then the SATL shall terminate the command with CHECK
>         CONDITION status only if an error occurs in processing the
>         command. See clause 11 for a description of ATA error
>         conditions.

That's right.  Since the command in question did have CK_COND set, the 
device should have returned CHECK CONDITION status instead of GOOD 
status.

Therefore this indicates a bug in the device, not in the kernel.  
hdparm could work around it here by issuing an explicit REQUEST SENSE
command, but in general it will cause trouble.

Alan Stern

