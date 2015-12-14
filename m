From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/9] be2iscsi: Fix mbox synchronization replacing spinlock
 with mutex
Date: Mon, 14 Dec 2015 16:09:40 +0100
Message-ID: <566EDBB4.2090104@suse.de>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-3-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbbLNPJm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 10:09:42 -0500
In-Reply-To: <1450073466-21077-3-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/14/2015 07:10 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> This is second part of actual fix for soft lockup.
> All mbox cmds issued using BMBX and MCC are synchronized using mbox_l=
ock.
> alloc_mcc_tag/free_mcc_tag is done under mcc_lock and tag_state is
> accessed using atomic operations.
>
> Mailbox command time out is now set to 30s as per FW requirement.
>
And here is the change from spin_lock to mutex_lock.
You should put that into the description.

And I would recommend splitting this patch into three:
- Move spinlock to mutex
- tag state atomic operations
- mbox_lock/mcc_lock ordering changes

Also there are some fixes in here (change of msleep, checking of a=20
return value) which do not really belong here, and should be done in=20
a separate patch, too.

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
