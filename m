From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How to write a transparent SCSI bridge?
Date: Wed, 30 Jul 2003 15:31:16 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307301522300.2990-100000@ida.rowland.org>
References: <20030730121310.C30339@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:28932 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S273385AbTG3TbR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 15:31:17 -0400
In-Reply-To: <20030730121310.C30339@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 30 Jul 2003, Matthew Dharm wrote:

> On Wed, Jul 30, 2003 at 10:38:38AM -0400, Alan Stern wrote:
> > What I have in mind is something that would receive CDBs and data over a 
> > USB link and would forward them to a standard SCSI device (or more 
> > accurately, a host adapter driver), and relay the replies back.
> 
> CDBs?  Just the command bytes, then?  Why not send more of the struct
> scsi_cmd?

I have in mind writing a USB Mass Storage gadget (i.e., slave device)
driver.  The gadget only receives the CDB, not the entire scsi_cmnd.  When 
acting as a transparent bridge, the gadget would somehow have to 
reconstitute a SCSI request and send it to the actual device driver.

> > 	3. I know very little about how the block layer works.  Somehow my 
> > driver would have to insert its requests into the appropriate queue.
> 
> The loopback driver does this -- you might want to see how it does it.

The loop driver forwards filesystem read/write requests to block drivers,
not SCSI commands to host adapter drivers.  But maybe a similar approach
would work; I'll have to check it out.

Alan Stern

