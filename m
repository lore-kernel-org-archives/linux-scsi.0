From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] yet more struct scsi_lun
Date: Sun, 23 Oct 2005 13:53:10 +0200
Message-ID: <1130068390.2775.6.camel@laptopd505.fenrus.org>
References: <20051023043301.GA22615@havoc.gtf.org>
	 <20051023070011.GA26569@havoc.gtf.org>  <435B6A62.8070306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5316 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751328AbVJWLxT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 07:53:19 -0400
In-Reply-To: <435B6A62.8070306@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>


> Which in turn makes me think of applying the same idea
> to max_sectors
> 
>         shost->max_sectors = MAX_512B_SECTORS_UNLIMITED;
> 
> which would be the default unless the HBA (RAID controller
> or whatever) really does have a (practical) limit. If a
> device beyond the target has a limit, then that is not the
> LLD's concern.

this is a bit of a problem since we don't know all the limits. We do
know that Microsoft Windows at least used to have a 64Kb limit, and that
that limit is "safe" in the sense that all hw was tested/designed for
that. So setting the default safe, and overriding it per driver sounds
best. It only really matters for a handful of drivers anyway, and those
either already set something or ought to.


