From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to reduce
 lock contention
Date: Wed, 20 Aug 2014 18:16:13 +0530
Message-ID: <b889d6a5c6f6ad9ae41d81c0c92b65fc@mail.gmail.com>
References: <201408191819.s7JIIx12019025@palmhbs0.lsi.com> <53F47CF8.3080708@acm.org>
 <7932bf422121b7f7d23545abdc0065c8@mail.gmail.com> <20140820124115.GA15231@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:33078 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaHTMqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 08:46:16 -0400
Received: by mail-lb0-f172.google.com with SMTP id z11so6756318lbi.17
        for <linux-scsi@vger.kernel.org>; Wed, 20 Aug 2014 05:46:14 -0700 (PDT)
In-Reply-To: <20140820124115.GA15231@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org, aacraid@adaptec.com, Elliott@hp.com, jbottomley@parallels.com

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Wednesday, August 20, 2014 6:11 PM
> To: Kashyap Desai
> Cc: Bart Van Assche; linux-scsi@vger.kernel.org; aacraid@adaptec.com;
> Elliott@hp.com; jbottomley@parallels.com; hch@infradead.org
> Subject: Re: [PATCH] scsi.mq:Added enable_cmd_list flags in hostt to
reduce
> lock contention
>
> On Wed, Aug 20, 2014 at 06:08:37PM +0530, Kashyap Desai wrote:
> > > This code is in the hot path which means that caching
"enable_cmd_list"
> > > in struct Scsi_Host (as is done for many other SCSI host parameters)
> > > probably will (slightly) improve performance further. Otherwise this
> > > patch looks fine to me.
> > I will send updated patch which will cache host template field
> > "enable_cmd_list" for faster access in Scsi Host.
>
> Thanks.  It might be worth to only set in in the host in fact.

Fine. I will remove host template entry and add code in aacraid and
dpt_i2o drivers to set that value directly in "Scsi Host"

>
> Also please just remove the code about lock contention in
scsi_mq_prep_fn
> - the XXX really doesn't apply anymore and I think the code should be
self-
> explaining enough to not need a comment.

I will do this.

>
> Otherwise the patch looks good to me.
