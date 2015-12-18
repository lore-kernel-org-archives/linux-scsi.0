From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] be2iscsi: Fix soft lockup in mgmt_get_all_if_id
 path using bmbx
Date: Fri, 18 Dec 2015 09:58:06 +0100
Message-ID: <5673CA9E.5010501@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-2-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933081AbbLRI6J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 03:58:09 -0500
In-Reply-To: <1450194906-12925-2-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> We are taking mbox_lock spinlock which disables pre-emption before we=
 poll
> for mbox completion. Waiting there with spinlock held in excess of 20=
s will
> cause soft lockup.
>
> Actual fix is to change mbox_lock to mutex.
> The changes are done in phases. This is the first part.
> 1. Changed mgmt_get_all_if_id to use MCC where after posting lock is =
released.
> 2. Changed be_mbox_db_ready_wait to busy wait for 12s max and removed
> wait_event_timeout. Added error handling code for IO reads.
> OPCODE_COMMON_QUERY_FIRMWARE_CONFIG mbox command takes 8s time when u=
nreachable
> boot targets configured.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_cmds.c |   60 +++++++++++++++++++---------=
-----------
>   drivers/scsi/be2iscsi/be_mgmt.c |   32 ++++++++++++++------
>   2 files changed, 51 insertions(+), 41 deletions(-)
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
