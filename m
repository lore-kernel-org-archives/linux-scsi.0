From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Transport Attributes -- attempt#4
Date: Tue, 20 Jan 2004 15:48:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120154801.B25713@beaverton.ibm.com>
References: <20040120215645.GG15871@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:54502 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263937AbUATXsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 18:48:23 -0500
Content-Disposition: inline
In-Reply-To: <20040120215645.GG15871@localhost>; from mort@wildopensource.com on Tue, Jan 20, 2004 at 04:56:45PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Martin Hicks <mort@wildopensource.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Jan 20, 2004 at 04:56:45PM -0500, Martin Hicks wrote:
> 
> Hi again,
> 
> Updated patches against Linus' bk tree from earlier today.  The patch
> that fixes up the scsi_sysfs.c error path, that was sent out by me on
> Jan 16, is required for the core patch to apply cleanly.
> 
> I think I've addressed all the comments from the last round with the
> exception of doing Lazy registration of the transport classes.  I'm
> still not totally convinced that this is really required.

It's certainly are not required, but makes it easier to add other
transports, and is in line with allocating resources as needed. Making
them modules means the code is only loaded when required by an adapter, it
is not always loaded with scsi core.

We could potentially have iSCSI and maybe others per SCSI standards. Then
we have USB, ieee1394, and raid cards that might want to add their own bus
and attributes, though these ones might more easily add them via scsi_host
attributes.

-- Patrick Mansfield
