From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libsas: User mode app failed to send ioctl commands to
	SATA drive.
Date: Mon, 12 Jan 2009 09:33:46 -0600
Message-ID: <1231774426.3256.2.camel@localhost.localdomain>
References: <496B1B31.4050606@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59518 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752085AbZALPdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 10:33:52 -0500
In-Reply-To: <496B1B31.4050606@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kewei@marvell.com
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, djwong@us.ibm.com, Jason Chu <jasonchu@marvell.com>, Michael Wang <qswang@marvell.com>, Jacky Feng <jfeng@marvell.com>

On Mon, 2009-01-12 at 18:28 +0800, Ke Wei wrote:
> The context of scsi_host's hostdata points to a sas ha structure with libsas
> module, but the libata casts this pointer to a ata_port structure when ioctl
> sends HDIO_GET_IDENTITY.

This is a good find thanks.  I think there's a small problem in the way
the layering is done.

I think ata_scsi_ioctl needs to be expanded to pass the port in all the
time.   That way other implementors don't have to remember to special
case HDIO_GET_IDENTITY.

When you redo this, ipr will need altering as well (rather than also
having the identity exception added).

James


