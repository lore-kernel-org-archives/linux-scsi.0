From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 12/15] be2iscsi: Fix IOPOLL implementation
Date: Fri, 18 Dec 2015 10:04:50 +0100
Message-ID: <5673CC32.7020204@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-13-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966266AbbLRJEv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:04:51 -0500
In-Reply-To: <1450194906-12925-13-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:55 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> OS not responding when running 2 port traffic on 72 CPUs system.
>
> be2iscsi IRQs gets affined to CPU0 when irqbalancer is disabled.
> be_iopoll processing completions in BLOCK_IOPOLL_SOFTIRQ hogged CPU0.
>
> 1. Use budget to exit the polling loop. beiscsi_process_cq didn't hon=
our it.
> 2. Rearming of EQ is done only after iopoll completes.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c  |    2 +-
>   drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
>   drivers/scsi/be2iscsi/be_main.c  |   91 +++++++++++++++++++++------=
-----------
>   drivers/scsi/be2iscsi/be_main.h  |    5 +-
>   4 files changed, 56 insertions(+), 44 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
