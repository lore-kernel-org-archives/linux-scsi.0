From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 12 May 2010 10:39:27 -0500
Message-ID: <1273678767.2808.17.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1005121056520.1962-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab0ELPjj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 May 2010 11:39:39 -0400
In-Reply-To: <Pine.LNX.4.44L0.1005121056520.1962-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Lord <mlord@pobox.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 2010-05-12 at 11:09 -0400, Alan Stern wrote:
> On Wed, 12 May 2010, Mark Lord wrote:
> 
> > The sticky part is that hdparm explicitly asked for sense data.
> > 
> > But the results were marked as "no sense data".  Many of the commands
> > sent by hdparm _require_ "sense data" (ATA register values) in order
> > to see the results.  The USB driver appears to ignore that request
> > when it sees good device status from the original command.  Bug.
> 
> This sounds like it is a bug in the SCSI midlayer, not in usb-storage.  

I don't think so ... we'll return sense if sense is present (i.e. the
device returned CHECK CONDITION).

> There is no mechanism for the midlayer to tell low-level drivers like
> usb-storage that sense data must be returned.  The documentation in
> include/scsi/scsi_cmnd.h merely states that the sense buffer should be
> filled when CHECK CONDITION is received for the original command.  
> Ditto for Documentation/scsi/scsi_mid_low_api.txt.  Hence if sense data
> is needed even in the absence of CHECK CONDITION, the midlayer must
> explicitly send a command to retrieve it.

Sense data is never returned in the absence of CHECK CONDITION.  This is
what SAT says has to happen if you set CK_COND in ATA(12/16):

        The CK_COND (Check Condition) bit may be used to request the
        SATL to
        return a copy of ATA register information in the sense data upon
        command completion. If the CK_COND bit is set to one the SATL
        shall
        return a status of CHECK CONDITION when the ATA command
        completes,
        even if the command completes successfully, and return the ATA
        Normal Output fields (see ATA8-ACS) in the sense data using the
        ATA Return descriptor (see 12.2.6). If the CK_COND bit is set to
        zero, then the SATL shall terminate the command with CHECK
        CONDITION status only if an error occurs in processing the
        command. See clause 11 for a description of ATA error
        conditions.
        
James

> What mechanism does hdparm use to submit its I/O requests, and how does 
> it indicate that it requires sense data?
> 
> Alan Stern
> 


