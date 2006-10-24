From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/4] aic79xx: Fixup external device reset
Date: Tue, 24 Oct 2006 16:37:31 -0700
Message-ID: <1161733051.7104.37.camel@mulgrave.il.steeleye.com>
References: <453CC21D.5030201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14258 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422830AbWJXXhl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 19:37:41 -0400
In-Reply-To: <453CC21D.5030201@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2006-10-23 at 15:22 +0200, Hannes Reinecke wrote:
> +                       /* Hand-craft TUR command */
> +                       ahd_outb(ahd, SCB_CDB_STORE, 0);
> +                       ahd_outb(ahd, SCB_CDB_STORE+1, 0);
> +                       ahd_outb(ahd, SCB_CDB_STORE+2, 0);
> +                       ahd_outb(ahd, SCB_CDB_STORE+3, 0);
> +                       ahd_outb(ahd, SCB_CDB_STORE+4, 0);
> +                       ahd_outb(ahd, SCB_CDB_STORE+5, 0);
> +                       ahd_outb(ahd, SCB_CDB_LEN, 6);
> +                       scb->hscb->control &= ~(TAG_ENB|SCB_TAG_TYPE);
> +                       scb->hscb->control |= MK_MESSAGE;
> +                       ahd_outb(ahd, SCB_CONTROL, scb->hscb->control);
> +                       ahd_outb(ahd, MSG_OUT, HOST_MSG);
> +                       ahd_outb(ahd, SAVED_SCSIID, scb->hscb->scsiid);

What's the reason for having to have this hand crafted test unit ready?

James


