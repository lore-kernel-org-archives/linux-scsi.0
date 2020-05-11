Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25944C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F8C2075E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:31:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="Zzg6hZMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgEKHbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:31:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:6520 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbgEKHbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:31:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7V5wh008782;
        Mon, 11 May 2020 00:31:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=wwOcjlyIrxCg4COuthpXlLVFd0hfOfc+aheCcwsUwfs=;
 b=Zzg6hZMwG8hS29UWnXa9I0q037yEWTriVMNHAx/j+itjAHa+zqrmXK58kxeENO6fsFr/
 eNgKneRFCcK0aAl6PgKTIHETSH3tUOw3xWw7fvZ630VP4vH9r+jRJKG2r5BpCbyEclJ6
 zqoodX57QjGZRIkVxVCHdbwddQEQynUUKNE+KJnOfzlqRqjs08bSLcEwEgf0QuEE+YpK
 tNSODPuQ7BCA+N8H5PkBPyS9Km9SAar+/8ruyCDK469rH8fCJZRGVDLLENDDuf1JYIFk
 uxhcrxtr9/Psijj3T9lO8NPrsSVWVVL+BG/R/29kMXYcyPF+4tupsADZ4X526Vz3i5uH JQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdw50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:31:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:31:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:31:25 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 871AE3F703F;
        Mon, 11 May 2020 00:31:25 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7VOnA020516;
        Mon, 11 May 2020 00:31:24 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:31:24 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>,
        "Nilesh Javali" <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        "Daniel Wagner" <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v4 01/11] qla2xxx: Fix spelling of a variable name
In-Reply-To: <20200427030310.19687-2-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110030180.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-2-bvanassche@acm.org>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_02:2020-05-11,2020-05-11 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:

> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_fw.h   | 2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index f9bad5bd7198..b364a497e33d 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -1292,7 +1292,7 @@ struct device_reg_24xx {
>  };
>  /* RISC-RISC semaphore register PCI offet */
>  #define RISC_REGISTER_BASE_OFFSET	0x7010
> -#define RISC_REGISTER_WINDOW_OFFET	0x6
> +#define RISC_REGISTER_WINDOW_OFFSET	0x6
>  
>  /* RISC-RISC semaphore/flag register (risc address 0x7016) */
>  
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 80390d3f3236..b94429504d30 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2861,7 +2861,7 @@ qla25xx_read_risc_sema_reg(scsi_qla_host_t *vha, uint32_t *data)
>  	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>  
>  	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET);
> +	*data = RD_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET);
>  
>  }
>  
> @@ -2871,7 +2871,7 @@ qla25xx_write_risc_sema_reg(scsi_qla_host_t *vha, uint32_t data)
>  	struct device_reg_24xx __iomem *reg = &vha->hw->iobase->isp24;
>  
>  	WRT_REG_DWORD(&reg->iobase_addr, RISC_REGISTER_BASE_OFFSET);
> -	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFET, data);
> +	WRT_REG_DWORD(&reg->iobase_window + RISC_REGISTER_WINDOW_OFFSET, data);
>  }
>  
>  static void
> 

Thank you for the patch.

Reviewed-by: Arun Easi <aeasi@marvell.com>
