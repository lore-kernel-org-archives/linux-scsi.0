From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH] bfa: comparison with wrong msgtag in bfa_pport_isr()
Date: Thu, 21 Jan 2010 17:59:35 -0800
Message-ID: <04391A4E90BB2149B010D22452FA16875F0348DF@HQ-EXCH-6.corp.brocade.com>
References: <4B56136F.3070709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755763Ab0AVB7j@vger.kernel.org>
In-Reply-To: <4B56136F.3070709@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>
List-Id: linux-scsi@vger.kernel.org

> Was this maybe intended? otherwise in case BFI_PPORT_I2H_ENABLE_RSP:
> the same code is executed. Please review.

Making this change alone will break compilation since bfa_pport_disable_rsp_s is not defined. To fix this, we should also replace it with bfa_pport_generic_rsp_s in bfi_pport_i2h_msg_u.

But please keep this as it is for now since I am working on resubmitting 2.1.2.1 patch, and there are a lot of changes in this area.

Thanks

Jing

> 
> diff --git a/drivers/scsi/bfa/bfa_fcport.c b/drivers/scsi/bfa/bfa_fcport.c
> index aef648b..f00d07b 100644
> --- a/drivers/scsi/bfa/bfa_fcport.c
> +++ b/drivers/scsi/bfa/bfa_fcport.c
> @@ -918,7 +918,7 @@ bfa_pport_isr(struct bfa_s *bfa, struct bfi_msg_s
> *msg)
>  		break;
> 
>  	case BFI_PPORT_I2H_DISABLE_RSP:
> -		if (pport->msgtag == i2hmsg.enable_rsp->msgtag)
> +		if (pport->msgtag == i2hmsg.disable_rsp->msgtag)
>  			bfa_sm_send_event(pport, BFA_PPORT_SM_FWRSP);
>  		break;
> 
