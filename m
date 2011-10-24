From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Mon, 24 Oct 2011 11:33:52 -0700
Message-ID: <1319481232.17450.11.camel@haakon2.linux-iscsi.org>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 18:45 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 7:57 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > This v2 patch adds the kernel module ib_srpt SCSI RDMA Protocol (SRP) target
> > implementation conforming to the SRP r16a specification for the mainline
> > drivers/target infrastructure.
> >
> > This driver was originally developed by Vu Pham and has been optimized by
> > Bart Van Assche and merged into upstream LIO based on his srpt-lio-4.1 branch.
> > This patch is made against the current pending target-core changes for
> > v3.2-rc1, the full tree is available here:
> 
> Maybe you remember that the reason why I developed this patch was to
> be able to run performance measurements ? The following changes are
> necessary to convert this patch into a robust kernel driver:
> - Handle the case where the last WQE event arrives before the
> corresponding queue pair is reset (r3870 in the SCST SVN repo).
> - Handle IB completion timeouts. Although the InfiniBand Architecture
> Manual specifies that a HCA must generate an error completion for each
> pending work item when a queue pair reset is issued, an important
> class of HCAs doesn't do this (that includes the HCA in your test
> setup). In the SCST version of this driver such timeouts are handled
> by the function srpt_pending_cmd_timeout().
> 
> Both issues mentioned above can lead to sessions not being cleaned up
> properly and hence all future logins from the initiator associated
> with that session to be blocked.
> 

It would have been nice if you bothered to mention these in any of the
pre merge window reviews, but given your delay responsed on these items
they will have to be something we'll fix post merge.

Thanks,

--nab

 
