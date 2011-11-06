From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] ib_srpt: Make srpt_srq_size module parameter use
 S_IRUGO|S_IWUSR
Date: Sun, 06 Nov 2011 04:02:39 -0800
Message-ID: <1320580959.5859.441.camel@haakon2.linux-iscsi.org>
References: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
	 <1320578141-27048-2-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-pvgAkCxU=+sSXRLGjBU-bsC=q8-O9qHTQJg9L8P=W_9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52456 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab1KFMCl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Nov 2011 07:02:41 -0500
In-Reply-To: <CAO+b5-pvgAkCxU=+sSXRLGjBU-bsC=q8-O9qHTQJg9L8P=W_9g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

On Sun, 2011-11-06 at 12:40 +0100, Bart Van Assche wrote:
> On Sun, Nov 6, 2011 at 12:15 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This patch converts the srpt_srq_size module parameter to R/W access
> > so that it's accessable when built as CONFIG_INFINIBAND_SRPT=y.  This
> > parameter is only referenced within srpt_add_one() directly to set
> > srpt_device->srq_size.
> >
> > Reported-by: Bart Van Assche <bvanassche@acm.org>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Roland Dreier <roland@purestorage.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index 94e6aff..43a17e3 100644
> > --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -84,7 +84,7 @@ MODULE_PARM_DESC(srp_max_req_size,
> >                 "Maximum size of SRP request messages in bytes.");
> >
> >  static int srpt_srq_size = DEFAULT_SRPT_SRQ_SIZE;
> > -module_param(srpt_srq_size, int, 0444);
> > +module_param(srpt_srq_size, int, S_IRUGO|S_IWUSR);
> >  MODULE_PARM_DESC(srpt_srq_size,
> >                 "Shared receive queue (SRQ) size.");
> 
> This patch makes it possible to set srpt_srq_size to values that are
> so low that communication becomes impossible. Attempts to set
> srpt_srq_size below MIN_SRPT_SRQ_SIZE should either be blocked or the
> modification shown should be added to the above patch:
> 
> -sdev->srq_size = min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
> +sdev->srq_size = min(max(srpt_srq_size, MIN_SRPT_SRQ_SIZE),
> sdev->dev_attr.max_srq_wr);

Fixed.

Thanks,

--nab

