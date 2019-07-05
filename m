From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] scsi_host: add support for request batching
Date: Fri, 5 Jul 2019 09:00:58 +0800
Message-ID: <CACVXFVNuFLMOmX_KuvQG-+-zasAxcbrL+sbXEGaKa8C1K3mxKQ@mail.gmail.com>
References: <20190530112811.3066-1-pbonzini@redhat.com> <20190530112811.3066-2-pbonzini@redhat.com>
 <CACVXFVP-B7uKUGn75rZdu0e4QxUOsSqv8FL0vY2ubmuucvxqjQ@mail.gmail.com> <bd7fa062-6c71-13a2-5bbf-0dea859ae75f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <bd7fa062-6c71-13a2-5bbf-0dea859ae75f@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, KVM General <kvm@vger.kernel.org>, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 3, 2019 at 4:16 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 31/05/19 05:27, Ming Lei wrote:
> > It should be fine to implement scsi_commit_rqs() as:
> >
> >  if (shost->hostt->commit_rqs)
> >        shost->hostt->commit_rqs(shost, hctx->queue_num);
> >
> > then scsi_mq_ops_no_commit can be saved.
> >
> > Because .commit_rqs() is only called when BLK_STS_*_RESOURCE is
> > returned from scsi_queue_rq(), at that time shost->hostt->commit_rqs should
> > have been hit from cache given .queuecommand is called via
> > host->hostt->queuecommand.
>
> This is not about d-cache, it's about preserving the heuristics that
> blk-mq applies depending on whether commit_rqs is there or not.

Fair enough, at least difference would be made by the check in
blk_mq_make_request() if scsi_commit_rqs is provided unconditionally,
so looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming Lei
