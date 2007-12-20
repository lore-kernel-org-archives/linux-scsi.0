From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] SMP request handlers need to update resid
Date: Thu, 20 Dec 2007 12:20:08 +0900
Message-ID: <20071220122008T.fujita.tomonori@lab.ntt.co.jp>
References: <20071220114436Z.fujita.tomonori@lab.ntt.co.jp>
	<646765f40712191913m6b98b024jdfeb58191a01f63d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:49593 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbXLTDUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Dec 2007 22:20:33 -0500
In-Reply-To: <646765f40712191913m6b98b024jdfeb58191a01f63d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julian.calaby@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@hansenpartnership.com, dougg@torque.net, Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Thu, 20 Dec 2007 14:13:15 +1100
"Julian Calaby" <julian.calaby@gmail.com> wrote:

> On Dec 20, 2007 1:44 PM, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > --- a/drivers/message/fusion/mptsas.c
> > +++ b/drivers/message/fusion/mptsas.c
> > @@ -1343,6 +1343,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
> >                 smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> >                 memcpy(req->sense, smprep, sizeof(*smprep));
> >                 req->sense_len = sizeof(*smprep);
> > +               req->data_len = 0;
> > +               rsp->data_len -= smprep->ResponseDataLength;
> 
> Would
> 
> +               rsp->data_len = -smprep->ResponseDataLength;
> 
> not work?

The definition of resid is:

	__s32 dout_resid;	/* [o] dout_xfer_len - actual_dout_xfer_len */

We need to have:

rsp->data_len = rsp->data_len - smprep->ResponseDataLength;


Then block/bsg.c sets up dout_resid in the following way:

hdr->dout_resid = rq->data_len;

