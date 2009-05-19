From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCHSET block#for-2.6.31] block: fix fallouts from recent
	cleanups, take#2
Date: Tue, 19 May 2009 11:39:35 +0200
Message-ID: <20090519093935.GV4140@kernel.dk>
References: <1242725586-13142-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:42930 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZESJje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2009 05:39:34 -0400
Content-Disposition: inline
In-Reply-To: <1242725586-13142-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, zaitcev@redhat.com, sshtylyov@ru.mvista.com, Eric.Moore@lsi.com, djwong@us.ibm.com

On Tue, May 19 2009, Tejun Heo wrote:
> Hello,
> 
> This is the second take of fix-fallouts patchset.  The first one[L]
> was posted without header message.  Changes from the last take are
> 
> * ub change updated per Pete Zitcev's comment
> 
> * resid_len init bug spotted by Boaz Harrosh fixed
> 
> This patchset contains the following three patches.
> 
>   0001-ub-use-__blk_end_request_all.patch
>   0002-block-set-rq-resid_len-to-blk_rq_bytes-on-issue.patch
>   0003-bio-always-copy-back-data-for-copied-kernel-request.patch
> 
> 0001 updates ub to use __blk_end_request_all() and 0002 restores the
> original residue count behavior.  0003 makes sure kernel pc buffer is
> bounced back even on request failure as user pc ones do.  This
> inconsistency was discovered during discussion over residue count
> semantics.
> 
> This patchset contains the following changes.

Applied!

> 
>  block/blk-core.c                         |    5 +++--
>  drivers/block/ub.c                       |   30 +++++++++++-------------------
>  drivers/ide/ide-cd.c                     |    4 ++--
>  drivers/ide/ide-tape.c                   |    2 +-
>  drivers/message/fusion/mptsas.c          |    3 ++-
>  drivers/scsi/libsas/sas_expander.c       |    4 ++++
>  drivers/scsi/libsas/sas_host_smp.c       |    3 ---
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
>  fs/bio.c                                 |    2 +-
>  9 files changed, 26 insertions(+), 31 deletions(-)
> 
> Thanks.
> 
> --
> tejun
> 
> [L] http://thread.gmane.org/gmane.linux.ide/40728

-- 
Jens Axboe

