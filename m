From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: RE: [PATCH 1/9] be2iscsi: Fix soft lockup in mgmt_get_all_if_id path
 using bmbx
Date: Tue, 15 Dec 2015 09:33:13 +0530
Message-ID: <4f2e369895ed4be8f460972fd509289e@mail.gmail.com>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-2-git-send-email-jitendra.bhivare@avagotech.com> <566EDA6C.8030901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36504 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbbLOEDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 23:03:16 -0500
Received: by qkht125 with SMTP id t125so169448922qkh.3
        for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2015 20:03:14 -0800 (PST)
In-Reply-To: <566EDA6C.8030901@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

be_mbox_db_ready_wait was changed to remove wait_event_timeout done und=
er
spinlock held for port initialization FW commands.
The timeout change and unrecoverable error check inside the wait loop w=
ere
needed to be addressed too.
Though spinlock was replaced with mutex in patch 2/9.

-----Original Message-----
=46rom: Hannes Reinecke [mailto:hare@suse.de]
Sent: Monday, December 14, 2015 8:34 PM
To: Jitendra Bhivare; linux-scsi@vger.kernel.org; michaelc@cs.wisc.edu
Subject: Re: [PATCH 1/9] be2iscsi: Fix soft lockup in mgmt_get_all_if_i=
d
path using bmbx

On 12/14/2015 07:10 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> We are taking mbox_lock spinlock which disables pre-emption before we
> poll for mbox completion. Waiting there with spinlock held in excess
> of 20s will cause soft lockup.
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
Why did you modify be_mbox_db_ready_wait(), seeing that you're not usin=
g
the mailbox interface anymore after this change?

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
