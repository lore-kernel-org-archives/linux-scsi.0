Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0AAC4CEC6
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 20:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED3920830
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 20:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfILUXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 16:23:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfILUXD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Sep 2019 16:23:03 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6C71F2A09AB
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 20:23:02 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id o133so30300269qke.4
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2019 13:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=owXO1RdgQk4OQWFleT/0A+5zfFDKV4OqBS5g3bM3UJ4=;
        b=a1UmraGTXIwXDmXWGgR0KWiv8WOCKqAraULDNula4/nAr6Ewh7sdB+YkeQuPGu2tWB
         1p83sm0LXYeaRyy4Df8wM3CkHm2JGRx43Fbl4MXg2B05BQICWN94IL+l6Rym3MTFQBk0
         ZxyBIjrbfk6F2bK5rHeNp0vh80hiitN1dlpxBkdIHqqNIeG24REa5CeS9dLayljkqPmZ
         uP7rl7PxjUa6wufrXpGz0pm/FPzae1vNwVeT1qt6sR5758bBVEa9USCpa+/Hh6/hsHqJ
         j/5Z7vp0fIyn8MBCixHlAiRDYH2FueHyOafM9ckh9hY1YWHBz4wrurvY145kkDKWiXV9
         AfEA==
X-Gm-Message-State: APjAAAWGK+kgHQC1BwY14ImeRccok0/GrFrxo/ENcpYWHTJNi38qczhR
        D4CCD1zN8Y4map69WnYJjA09p4in/5b0utUWviYlY3xF/FXeFOczBpM3mJ2QSULunzZEM+GDW+Q
        s84KGtPaiBhJuo+biPBT6RQ==
X-Received: by 2002:a0c:f7cc:: with SMTP id f12mr28110957qvo.189.1568319781249;
        Thu, 12 Sep 2019 13:23:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEldduHDcYvlJjYg2wwqMyqdTCKQIFJKKcSMWQsusfJ+56prH0sNgQYe75J1t6QAKox5niIA==
X-Received: by 2002:a0c:f7cc:: with SMTP id f12mr28110915qvo.189.1568319780514;
        Thu, 12 Sep 2019 13:23:00 -0700 (PDT)
Received: from dhcp-49-30.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w85sm12991444qkb.57.2019.09.12.13.22.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2019 13:23:00 -0700 (PDT)
Message-ID: <2704e2cf48808db58929ac75dcc3103227131d18.camel@redhat.com>
Subject: Re: [PATCH v2 12/14] qla2xxx: Capture FW dump on MPI heartbeat stop
 event
From:   Laurence Oberman <loberman@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 12 Sep 2019 16:22:59 -0400
In-Reply-To: <20190912180918.6436-13-hmadhani@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
         <20190912180918.6436-13-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-09-12 at 11:09 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> For MPI heartbeat stop Async Event, this patch would capture
> MPI FW dump and chip reset. FW will tell which function to
> capture FW dump for.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |  4 +++-
>  drivers/scsi/qla2xxx/qla_isr.c  | 31 ++++++++++++++++++++++++++-----
>  drivers/scsi/qla2xxx/qla_tmpl.c |  4 +++-
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 8b3015361428..d6b585d303b7 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -102,8 +102,10 @@ qla2x00_sysfs_write_fw_dump(struct file *filp,
> struct kobject *kobj,
>  			qla8044_idc_lock(ha);
>  			qla82xx_set_reset_owner(vha);
>  			qla8044_idc_unlock(ha);
> -		} else
> +		} else {
> +			ha->fw_dump_mpi = 1;
>  			qla2x00_system_error(vha);
> +		}
>  		break;
>  	case 4:
>  		if (IS_P3P_TYPE(ha)) {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c
> index 4c26630c1c3e..30fd2d355f3a 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1227,11 +1227,32 @@ qla2x00_async_event(scsi_qla_host_t *vha,
> struct rsp_que *rsp, uint16_t *mb)
>  		break;
>  
>  	case MBA_IDC_AEN:
> -		mb[4] = RD_REG_WORD(&reg24->mailbox4);
> -		mb[5] = RD_REG_WORD(&reg24->mailbox5);
> -		mb[6] = RD_REG_WORD(&reg24->mailbox6);
> -		mb[7] = RD_REG_WORD(&reg24->mailbox7);
> -		qla83xx_handle_8200_aen(vha, mb);
> +		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +			ha->flags.fw_init_done = 0;
> +			ql_log(ql_log_warn, vha, 0xffff,
> +			    "MPI Heartbeat stop. Chip reset needed.
> MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
> +			    mb[0], mb[1], mb[2], mb[3]);
> +
> +			if ((mb[1] & BIT_8) ||
> +			    (mb[2] & BIT_8)) {
> +				ql_log(ql_log_warn, vha, 0xd013,
> +				    "MPI Heartbeat stop. FW dump
> needed\n");
> +				ha->fw_dump_mpi = 1;
> +				ha->isp_ops->fw_dump(vha, 1);
> +			}
> +			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
> +			qla2xxx_wake_dpc(vha);
> +		} else if (IS_QLA83XX(ha)) {
> +			mb[4] = RD_REG_WORD(&reg24->mailbox4);
> +			mb[5] = RD_REG_WORD(&reg24->mailbox5);
> +			mb[6] = RD_REG_WORD(&reg24->mailbox6);
> +			mb[7] = RD_REG_WORD(&reg24->mailbox7);
> +			qla83xx_handle_8200_aen(vha, mb);
> +		} else {
> +			ql_dbg(ql_dbg_async, vha, 0x5052,
> +			    "skip Heartbeat processing mb0-3=[0x%04x]
> [0x%04x] [0x%04x] [0x%04x]\n",
> +			    mb[0], mb[1], mb[2], mb[3]);
> +		}
>  		break;
>  
>  	case MBA_DPORT_DIAGNOSTICS:
> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c
> b/drivers/scsi/qla2xxx/qla_tmpl.c
> index b948d94c8b3c..5b0c057def2b 100644
> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
> @@ -1017,8 +1017,9 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int
> hardware_locked)
>  		uint j;
>  		ulong len;
>  		void *buf = vha->hw->fw_dump;
> +		uint count = vha->hw->fw_dump_mpi ? 2 : 1;
>  
> -		for (j = 0; j < 2; j++, fwdt++, buf += len) {
> +		for (j = 0; j < count; j++, fwdt++, buf += len) {
>  			ql_log(ql_log_warn, vha, 0xd011,
>  			    "-> fwdt%u running...\n", j);
>  			if (!fwdt->template) {
> @@ -1046,6 +1047,7 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int
> hardware_locked)
>  	}
>  
>  bailout:
> +	vha->hw->fw_dump_mpi = 0;
>  #ifndef __CHECKER__
>  	if (!hardware_locked)
>  		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);

Being aware of this issue I reviewed it for sanity and code. I cant
speak to functions that interract with the firmware though.
Looks good otherwise

Reviewed-by: Laurence Oberman <loberman@redhat.com>

