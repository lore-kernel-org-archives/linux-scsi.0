From: santosh prasad nayak <santoshprasadnayak@gmail.com>
Subject: Re: [PATCH] [SCSI] bfa: Fix endian bug in bfad_iocmd_debug_fw_core().
Date: Fri, 9 Mar 2012 19:41:49 +0530
Message-ID: <CAOD=uF6X-m_7ZExq6apKvS1B6dbmuGKGQOru2ySKDjYKntYeJw@mail.gmail.com>
References: <1331053619-7211-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62439 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2CIOLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Mar 2012 09:11:50 -0500
Received: by dajr28 with SMTP id r28so1513313daj.19
        for <linux-scsi@vger.kernel.org>; Fri, 09 Mar 2012 06:11:49 -0800 (PST)
In-Reply-To: <1331053619-7211-1-git-send-email-santoshprasadnayak@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: huangj@brocade.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org

Can you please review it ?


regards
Santosh

On Tue, Mar 6, 2012 at 10:36 PM, santosh nayak
<santoshprasadnayak@gmail.com> wrote:
> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>
> Casting pointer from native data type to other type is
> endian-sensitive.
>
> "iocmd->offset" =A0is 64 bit but we use only first 32 bit.
> It works in little-endian system but in big-endian system
> it will break.
>
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> ---
> =A0drivers/scsi/bfa/bfad_bsg.c | =A0 =A05 ++++-
> =A01 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.=
c
> index 530de2b..c4edc63 100644
> --- a/drivers/scsi/bfa/bfad_bsg.c
> +++ b/drivers/scsi/bfa/bfad_bsg.c
> @@ -1918,6 +1918,7 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, v=
oid *cmd,
> =A0 =A0 =A0 =A0struct bfa_bsg_debug_s *iocmd =3D (struct bfa_bsg_debu=
g_s *)cmd;
> =A0 =A0 =A0 =A0void =A0 =A0*iocmd_bufptr;
> =A0 =A0 =A0 =A0unsigned long =A0 flags;
> + =A0 =A0 =A0 u32 offset;
>
> =A0 =A0 =A0 =A0if (bfad_chk_iocmd_sz(payload_len, sizeof(struct bfa_b=
sg_debug_s),
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BFA_DEBUG_FW_CORE_CHUN=
K_SZ) !=3D BFA_STATUS_OK) {
> @@ -1935,8 +1936,10 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, =
void *cmd,
>
> =A0 =A0 =A0 =A0iocmd_bufptr =3D (char *)iocmd + sizeof(struct bfa_bsg=
_debug_s);
> =A0 =A0 =A0 =A0spin_lock_irqsave(&bfad->bfad_lock, flags);
> + =A0 =A0 =A0 offset =3D iocmd->offset;
> =A0 =A0 =A0 =A0iocmd->status =3D bfa_ioc_debug_fwcore(&bfad->bfa.ioc,=
 iocmd_bufptr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (u32 *)=
&iocmd->offset, &iocmd->bufsz);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &offset=
, &iocmd->bufsz);
> + =A0 =A0 =A0 iocmd->offset =3D offset;
> =A0 =A0 =A0 =A0spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> =A0out:
> =A0 =A0 =A0 =A0return 0;
> --
> 1.7.4.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
