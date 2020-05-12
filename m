Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EC3C54E8F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B48B20736
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 06:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgELGRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 02:17:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:52452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgELGRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 02:17:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28E19AD17;
        Tue, 12 May 2020 06:17:39 +0000 (UTC)
Subject: Re: [PATCH v5 10/15] qla2xxx: Fix the code that reads from mailbox
 registers
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200511200946.7675-1-bvanassche@acm.org>
 <20200511200946.7675-11-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3def1366-2e63-173e-2664-44229b6f79ec@suse.de>
Date:   Tue, 12 May 2020 08:17:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200511200946.7675-11-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/20 10:09 PM, Bart Van Assche wrote:
> Make the MMIO accessors strongly typed such that the compiler checks whether
> the accessor function is used that matches the register width. Fix those
> MMIO accesses where another number of bits was read or written than the size
> of the register.
> 
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 53 +++++++++++++++++++++++++++------
>   drivers/scsi/qla2xxx/qla_init.c |  6 ++--
>   drivers/scsi/qla2xxx/qla_iocb.c |  2 +-
>   drivers/scsi/qla2xxx/qla_isr.c  |  4 +--
>   drivers/scsi/qla2xxx/qla_mbx.c  |  2 +-
>   drivers/scsi/qla2xxx/qla_mr.c   | 26 ++++++++--------
>   drivers/scsi/qla2xxx/qla_nx.c   |  4 +--
>   drivers/scsi/qla2xxx/qla_os.c   |  2 +-
>   8 files changed, 67 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 5ca46b15ca3c..4b02b48af85d 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -128,15 +128,50 @@ static inline uint32_t make_handle(uint16_t x, uint16_t y)
>    * I/O register
>   */
>   
> -#define RD_REG_BYTE(addr)		readb(addr)
> -#define RD_REG_WORD(addr)		readw(addr)
> -#define RD_REG_DWORD(addr)		readl(addr)
> -#define RD_REG_BYTE_RELAXED(addr)	readb_relaxed(addr)
> -#define RD_REG_WORD_RELAXED(addr)	readw_relaxed(addr)
> -#define RD_REG_DWORD_RELAXED(addr)	readl_relaxed(addr)
> -#define WRT_REG_BYTE(addr, data)	writeb(data, addr)
> -#define WRT_REG_WORD(addr, data)	writew(data, addr)
> -#define WRT_REG_DWORD(addr, data)	writel(data, addr)
> +static inline u8 RD_REG_BYTE(const volatile u8 __iomem *addr)
> +{
> +	return readb(addr);
> +}
> +
> +static inline u16 RD_REG_WORD(const volatile __le16 __iomem *addr)
> +{
> +	return readw(addr);
> +}
> +
> +static inline u32 RD_REG_DWORD(const volatile __le32 __iomem *addr)
> +{
> +	return readl(addr);
> +}
> +
> +static inline u8 RD_REG_BYTE_RELAXED(const volatile u8 __iomem *addr)
> +{
> +	return readb_relaxed(addr);
> +}
> +
> +static inline u16 RD_REG_WORD_RELAXED(const volatile __le16 __iomem *addr)
> +{
> +	return readw_relaxed(addr);
> +}
> +
> +static inline u32 RD_REG_DWORD_RELAXED(const volatile __le32 __iomem *addr)
> +{
> +	return readl_relaxed(addr);
> +}
> +
> +static inline void WRT_REG_BYTE(volatile u8 __iomem *addr, u8 data)
> +{
> +	return writeb(data, addr);
> +}
> +
> +static inline void WRT_REG_WORD(volatile __le16 __iomem *addr, u16 data)
> +{
> +	return writew(data, addr);
> +}
> +
> +static inline void WRT_REG_DWORD(volatile __le32 __iomem *addr, u32 data)
> +{
> +	return writel(data, addr);
> +}
>   
>   /*
>    * ISP83XX specific remote register addresses
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index f8fe0334571f..a1018f5f53de 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2219,7 +2219,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
>   
>   	/* Check for secure flash support */
>   	if (IS_QLA28XX(ha)) {
> -		if (RD_REG_DWORD(&reg->mailbox12) & BIT_0)
> +		if (RD_REG_WORD(&reg->mailbox12) & BIT_0)
>   			ha->flags.secure_adapter = 1;
>   		ql_log(ql_log_info, vha, 0xffff, "Secure Adapter: %s\n",
>   		    (ha->flags.secure_adapter) ? "Yes" : "No");
> @@ -2780,7 +2780,7 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
>   	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x017f,
>   	    "HCCR: 0x%x, MailBox0 Status 0x%x\n",
>   	    RD_REG_DWORD(&reg->hccr),
> -	    RD_REG_DWORD(&reg->mailbox0));
> +	    RD_REG_WORD(&reg->mailbox0));
>   
>   	/* Wait for soft-reset to complete. */
>   	RD_REG_DWORD(&reg->ctrl_status);
> @@ -4098,7 +4098,7 @@ qla24xx_config_rings(struct scsi_qla_host *vha)
>   	}
>   
>   	/* PCI posting */
> -	RD_REG_DWORD(&ioreg->hccr);
> +	RD_REG_WORD(&ioreg->hccr);
>   }
>   
>   /**
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index 182bd68c79ac..4d8039fc02e7 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2268,7 +2268,7 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
>   		    IS_QLA28XX(ha))
>   			cnt = RD_REG_DWORD(&reg->isp25mq.req_q_out);
>   		else if (IS_P3P_TYPE(ha))
> -			cnt = RD_REG_DWORD(&reg->isp82.req_q_out);
> +			cnt = RD_REG_DWORD(reg->isp82.req_q_out);
>   		else if (IS_FWI2_CAPABLE(ha))
>   			cnt = RD_REG_DWORD(&reg->isp24.req_q_out);
>   		else if (IS_QLAFX00(ha))

WTF?
Is 'isp82.req_q_out' a pointer, but the others are not?
This really looks dodgy...


Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
