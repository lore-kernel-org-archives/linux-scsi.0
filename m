From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH 6/9] be2iscsi: Fix IOPOLL implementation
Date: Tue, 15 Dec 2015 10:20:37 +0530
Message-ID: <ebc2ccd8865f41248c3aae95b287916f@mail.gmail.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-7-git-send-email-jitendra.bhivare@avagotech.com> <566EDF02.4050100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36246 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933098AbbLOEuj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 23:50:39 -0500
Received: by qkht125 with SMTP id t125so170564921qkh.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 20:50:38 -0800 (PST)
In-Reply-To: <566EDF02.4050100@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

The problem statement indicates affinity issue but IOPOLL implementatio=
n
had issues too.
1. IOPOLL budget passed in the callback is not being honored. This was =
the
root cause where
the driver kept polling in softirq.
2. The interrupts kept coming even when IOPOLL is scheduled. So we need=
ed
to fix EQ rearming.

I think, choosing CPU affinity internally by driver is not right thing =
to
do. For setting IRQ affinity
you need to have holistic view of the system and better done by externa=
l
entity which has heuristics
of all the varied workloads on the system.

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]
Sent: Monday, December 14, 2015 8:54 PM
To: Jitendra Bhivare; linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
Subject: Re: [PATCH 6/9] be2iscsi: Fix IOPOLL implementation

On 12/14/2015 07:11 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> OS not responding when running 2 port traffic on 72 CPUs system.
>
> be2iscsi IRQs gets affined to CPU0 when irqbalancer is disabled.
> be_iopoll processing completions in BLOCK_IOPOLL_SOFTIRQ hogged CPU0.
>
> 1. Use budget to exit the polling loop in beiscsi_process_cq.
> 2. Rearming of EQ is done only after iopoll completes.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c  |    2 +-
>   drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
>   drivers/scsi/be2iscsi/be_main.c  |   91
+++++++++++++++++++++-----------------
>   drivers/scsi/be2iscsi/be_main.h  |    5 +-
>   4 files changed, 56 insertions(+), 44 deletions(-)
>
Hmm. Not sure if I agree with this.
Doesn't the be2iscsi driver set the cpu affinity internally?
If not, wouldn't that be the better solution?

Cheers,

Hannes
--
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton H=
RB 21284
(AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
