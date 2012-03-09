From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH] [SCSI] bfa: Fix endian bug in
 bfad_iocmd_debug_fw_core().
Date: Fri, 9 Mar 2012 10:51:32 -0800
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86B3A6FB85CC@HQ1-EXCH01.corp.brocade.com>
References: <1331053619-7211-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1331053619-7211-1-git-send-email-santoshprasadnayak@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Krishna Gudipati <kgudipat@Brocade.com>
List-Id: linux-scsi@vger.kernel.org

Change looks good to me. Thanks

Acked-by: Jing Huang <huangj@brocade.com>


>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org]
>On Behalf Of santosh nayak
>Sent: Tuesday, March 06, 2012 9:07 AM
>To: Jing Huang
>Cc: JBottomley@parallels.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Santosh Nayak
>Subject: [PATCH] [SCSI] bfa: Fix endian bug in bfad_iocmd_debug_fw_core().
>
>From: Santosh Nayak <santoshprasadnayak@gmail.com>
>
>Casting pointer from native data type to other type is
>endian-sensitive.
>
>"iocmd->offset"  is 64 bit but we use only first 32 bit.
>It works in little-endian system but in big-endian system
>it will break.
>
>Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>---
> drivers/scsi/bfa/bfad_bsg.c |    5 ++++-
> 1 files changed, 4 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
>index 530de2b..c4edc63 100644
>--- a/drivers/scsi/bfa/bfad_bsg.c
>+++ b/drivers/scsi/bfa/bfad_bsg.c
>@@ -1918,6 +1918,7 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void
>*cmd,
> 	struct bfa_bsg_debug_s *iocmd = (struct bfa_bsg_debug_s *)cmd;
> 	void	*iocmd_bufptr;
> 	unsigned long	flags;
>+	u32 offset;
>
> 	if (bfad_chk_iocmd_sz(payload_len, sizeof(struct bfa_bsg_debug_s),
> 			BFA_DEBUG_FW_CORE_CHUNK_SZ) !=
>BFA_STATUS_OK) {
>@@ -1935,8 +1936,10 @@ bfad_iocmd_debug_fw_core(struct bfad_s *bfad, void
>*cmd,
>
> 	iocmd_bufptr = (char *)iocmd + sizeof(struct bfa_bsg_debug_s);
> 	spin_lock_irqsave(&bfad->bfad_lock, flags);
>+	offset = iocmd->offset;
> 	iocmd->status = bfa_ioc_debug_fwcore(&bfad->bfa.ioc, iocmd_bufptr,
>-				(u32 *)&iocmd->offset, &iocmd->bufsz);
>+				&offset, &iocmd->bufsz);
>+	iocmd->offset = offset;
> 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> out:
> 	return 0;
>--
>1.7.4.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
