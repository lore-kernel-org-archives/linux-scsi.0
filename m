From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Thu, 17 May 2012 09:46:17 -0400
Message-ID: <20120517134617.GA2841@redhat.com>
References: <4FB39D78.9020300@itwm.fraunhofer.de>
 <4FB4C065.7070804@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760684Ab2EQNq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 09:46:28 -0400
Content-Disposition: inline
In-Reply-To: <4FB4C065.7070804@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Thu, May 17 2012 at  5:09am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> Hi,
> 
> On 05/16/12 21:28, Bernd Schubert wrote:
> > Looking through the call chain, I see the underlying problem seems to be in scsi_host_is_busy().
> > 
> >> static inline int scsi_host_is_busy(struct Scsi_Host *shost)
> >> {
> >>     if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> >>         shost->host_blocked || shost->host_self_blocked)
> >>         return 1;
> >>
> >>     return 0;
> >> }
> 
> multipath_busy() was introduced because, without that,
> a request would be prematurely sent down to SCSI,
> lose the chance of additional merges and result in
> bad performance.
> 
> However, when it is target/host that is busy, I think dm should
> send the request down and let SCSI, which has better knowledge
> about the shared resource, do appropriate starvation control.
> 
> Could you try the attached patch?
> 
> ---
> Jun'ichi Nomura, NEC Corporation
> 
> If sdev is not busy but starget and/or host is busy,
> it is better to accept a request from stacking driver.
> Otherwise, the stacking device could be starved by other device
> sharing the same target/host.

Great suggestion.

It should be noted that DM mpath is the only caller of blk_lld_busy (and
scsi_lld_busy).  So even though this patch may _seem_ like the tail
(mpath) wagging the dog (SCSI), it is reasonable to change SCSI's
definition of a LLD being "busy" if it benefits multipath.
