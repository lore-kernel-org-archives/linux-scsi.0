From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi LLD implementation question
Date: Fri, 25 Feb 2011 14:34:40 -0500
Message-ID: <1298662480.2459.63.camel@mulgrave.site>
References: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com>
	 <1298641025.8617.63.camel@mulgrave.site>
	 <AANLkTikZqXCzJcRL3cL16w1O+MoDecy4N9XK14yzKd3D@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab1BYTeo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:34:44 -0500
In-Reply-To: <AANLkTikZqXCzJcRL3cL16w1O+MoDecy4N9XK14yzKd3D@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: va stg2010 <va.storage2010@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-02-25 at 11:19 -0800, va stg2010 wrote:
> Thanks !
> There is a 32-bit tag  to refer back  the queue(for pending commands)
> when responses are posted back by HBA.   Suppose the HBA is  receiving
> commands from multiple initiators because the host has virtualized
> initiator environment, now in this case  one single large queue is
> good enough or there should be pending-commands-queue per virtual
> initiator or pending-command-queue per disks.

It doesn't have to be virtualised; this is the normal situation on a
SAN.  For a pending queue, the question is merely how to do efficient
lookup.  Some drivers use a fixed offset list (with the offset in the
completion tag) ... I suppose a radix tree would be a good way to go for
particularly large pending queues.

> Just want to minimize the  locking contentions  and  maximize
> parallelism in  SCSI  I/O to multiple disks from multiple virtual
> initiators via my HBA.

To be honest, fixes offset lists are best then ... they can operated
locklessly.

James


