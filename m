From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/9] be2iscsi: Fix soft lockup in mgmt_get_all_if_id path
 using bmbx
Date: Mon, 14 Dec 2015 16:04:12 +0100
Message-ID: <566EDA6C.8030901@suse.de>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-2-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbbLNPEO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 10:04:14 -0500
In-Reply-To: <1450073466-21077-2-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/14/2015 07:10 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> We are taking mbox_lock spinlock which disables pre-emption before we=
 poll
> for mbox completion. Waiting there with spinlock held in excess of 20=
s will
> cause soft lockup.
>
> Actual fix is to change mbox_lock to mutex.
Really? I didn't find that in the patch ...

> The changes are done in phases. This is the first part.
> 1. Changed mgmt_get_all_if_id to use MCC instead of BMBX.
> 2. Changed be_mbox_db_ready_wait to busy wait for 12s max and removed
> wait_event_timeout. Added error handling code for IO reads.
> OPCODE_COMMON_QUERY_FIRMWARE_CONFIG mbox command takes 8s time when
> unreachable boot targets are configured.
>
Why did you modify be_mbox_db_ready_wait(), seeing that you're not=20
using the mailbox interface anymore after this change?

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
