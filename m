From: Varun Prakash <varun@chelsio.com>
Subject: Re: [PATCH v2 08/16] iscsi-target: add void (*iscsit_get_r2t_ttt)()
Date: Wed, 13 Apr 2016 18:33:08 +0530
Message-ID: <20160413130307.GA1702@chelsio.com>
References: <cover.1460204441.git.varun@chelsio.com>
 <2f71b7720d07231faa12ffba830681f1d7ac07da.1460204441.git.varun@chelsio.com>
 <570A92B0.9000109@grimberg.me>
 <20160411180838.GB1758@chelsio.com>
 <570E16CB.8070708@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570E16CB.8070708@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 13, 2016 at 12:52:11PM +0300, Sagi Grimberg wrote:
> 
> >>>Add void (*iscsit_get_r2t_ttt)() to
> >>>struct iscsit_transport, iscsi-target
> >>>uses this callback to get
> >>>r2t->targ_xfer_tag.
> >>
> >>Your driver allocates ttt's? That looks like bad
> >>layering to me. This definitely deserves an explanation...
> >
> >cxgbit.ko allocates ttt only for r2t pdus to do Direct Data
> >Placement of Data Out pdus, adapter uses the ttt value in
> >Data Out pdus to place data directly in the host buffers.
> 
> How do you guarantee that the core doesn't conflict with
> your internal ttt's?

- iscsi-target does not make any decision based on  
  r2t->targ_xfer_tag.

- From iscsi RFC https://tools.ietf.org/html/rfc7143#section-11.8.5
  There is no protocol rule about the Target Transfer Tag
  except that the value 0xffffffff is reserved and MUST NOT
  be sent by a target in an R2T.

- T5 adapter checks ttt only for Data Out pdus, so even
  if it is same for other pdus it does not matter.
