From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 11:53:12 +0000
Message-ID: <20050104115311.GD26051@parcelfarce.linux.theplanet.co.uk>
References: <B51CDBDEB98C094BB6E1985861F53AF302DE46@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:49586 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261175AbVADLxP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 06:53:15 -0500
Content-Disposition: inline
In-Reply-To: <B51CDBDEB98C094BB6E1985861F53AF302DE46@nkse2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 04, 2005 at 11:57:33AM +0100, Leubner, Achim wrote:
> Yes, that's the problem. I have to pass a physical address of
> scp->sense_buffer to our controller firmware that the firmware can fill
> that space with DMA after I/O. But cmdp->u.{raw,raw64}.sense_data does
> not survive until we get to unmapping stuff in gdth_sync_event() because
> there is only one cmdp structure per controller and the controller can
> handle multiple commands. So I have to save the physical address
> anywhere in the Scsi_Cmnd structure.

Umm...   What about adding a new field to
    struct {
        Scsi_Cmnd       *cmnd;                  /* pending request */
        ushort          service;                /* service */
    } cmd_tab[GDTH_MAXCMDS];                    /* table of pend. reques
in gdth_ha_str?  It's not that we couldn't change size of that animal and
AFAICS anything that might be passed to gdth_sync_event() would have to
be extracted from ha->cmd_tab[] anyway...

BTW, what uses values stored in gdth_ctr_vtab[]?  It's static and gdth.[ch]
never read its elements, only set them...
