From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 9/9] ib_srpt: Convert srpt_sq_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 11:39:47 -0700
Message-ID: <1319481587.17450.16.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-10-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-qZHTEy25E0uR9yzAjAdvOH-k2_+ga4J_CUNTdUFyihZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qZHTEy25E0uR9yzAjAdvOH-k2_+ga4J_CUNTdUFyihZQ@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 20:32 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > @@ -2144,11 +2140,11 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
> >                goto out;
> >
> >        ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
> > -                             ch->rq_size + srpt_sq_size, 0);
> > +                             ch->rq_size + sport->port_attrib.srp_sq_size, 0);
> >        if (IS_ERR(ch->cq)) {
> >                ret = PTR_ERR(ch->cq);
> >                printk(KERN_ERR "failed to create CQ cqe= %d ret= %d\n",
> > -                      ch->rq_size + srpt_sq_size, ret);
> > +                      ch->rq_size + sport->port_attrib.srp_sq_size, ret);
> >                goto out;
> >        }
> >
> > @@ -2160,7 +2156,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
> >        qp_init->srq = sdev->srq;
> >        qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
> >        qp_init->qp_type = IB_QPT_RC;
> > -       qp_init->cap.max_send_wr = srpt_sq_size;
> > +       qp_init->cap.max_send_wr = sport->port_attrib.srp_sq_size;
> >        qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
> 
> This patch introduces a race condition: if
> sport->port_attrib.srp_sq_size is modified from user space while an
> SRP login is ongoing then different values of that parameter can be
> used in each of the above statements that read that parameter while
> they all should use the same value.
> 

Fair point.  Fixing this up now.

Also, please stop dropping relevant list CC'ed from my patches.

Thanks, 

--nab
