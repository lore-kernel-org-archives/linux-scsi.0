From: Arne Redlich <arne.redlich@googlemail.com>
Subject: Re: [PATCH-v3 13/14] iscsi-target: Add misc utility and debug logic
Date: Fri, 13 May 2011 21:30:41 +0200
Message-ID: <BANLkTikMdAUjT=G+DHaJwDOXuh532uN8nw@mail.gmail.com>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
	<1305184041-32189-14-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50671 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab1EMTan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 15:30:43 -0400
In-Reply-To: <1305184041-32189-14-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>

2011/5/12 Nicholas A. Bellinger <nab@linux-iscsi.org>:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This file adds iscsi_target_util.[c,h] code containing a number
> of miscellaneous utility functions for iscsi_target_mod.
>
> It also contains iscsi_debug.h macros for CONFIG_ISCSI_TARGET_DEBUG
>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

<snip>

> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/targe=
t/iscsi/iscsi_target_util.c
> new file mode 100644
> index 0000000..af1c5c44
> --- /dev/null
> +++ b/drivers/target/iscsi/iscsi_target_util.c

<snip>

> +
> +struct iscsi_r2t *iscsit_get_r2t_for_eos(
> + =C2=A0 =C2=A0 =C2=A0 struct iscsi_cmd *cmd,
> + =C2=A0 =C2=A0 =C2=A0 u32 offset,
> + =C2=A0 =C2=A0 =C2=A0 u32 length)
> +{
> + =C2=A0 =C2=A0 =C2=A0 struct iscsi_r2t *r2t;
> +
> + =C2=A0 =C2=A0 =C2=A0 spin_lock_bh(&cmd->r2t_lock);
> + =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(r2t, &cmd->cmd_r2t_list, r=
2t_list) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((r2t->offset <=
=3D offset) &&
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (r2t=
->offset + r2t->xfer_len) >=3D (offset + length))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 break;
> + =C2=A0 =C2=A0 =C2=A0 }
> + =C2=A0 =C2=A0 =C2=A0 spin_unlock_bh(&cmd->r2t_lock);
> +
> + =C2=A0 =C2=A0 =C2=A0 if (!r2t) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printk(KERN_ERR "U=
nable to locate R2T for Offset: %u, Length:"
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 " %u\n", offset, length);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 }
> +
> + =C2=A0 =C2=A0 =C2=A0 return r2t;
> +}
> +

Nicholas,

This lookup pattern (repeated several times throughout the patch)
looks seriously flawed to me as r2t will never be NULL.

Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
