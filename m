From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v2 06/14] qla2xxx: Improve T10-DIF/PI handling in driver.
Date: Tue, 07 Feb 2017 20:13:17 -0800
Message-ID: <1486527197.13263.20.camel@haakon3.risingtidesystems.com>
References: <1486161655-2307-1-git-send-email-himanshu.madhani@cavium.com>
         <1486161655-2307-7-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55234 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdBHEPh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2017 23:15:37 -0500
In-Reply-To: <1486161655-2307-7-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>
Cc: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, hch@infradead.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On Fri, 2017-02-03 at 14:40 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> Add routines to support T10 DIF tag.
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_dbg.h     |   1 +
>  drivers/scsi/qla2xxx/qla_def.h     |  17 ++
>  drivers/scsi/qla2xxx/qla_target.c  | 598 +++++++++++++++++++++----------------
>  drivers/scsi/qla2xxx/qla_target.h  |  37 ++-
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  84 +++++-
>  5 files changed, 465 insertions(+), 272 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
> index e1fc4e6..c6bffe9 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -348,6 +348,7 @@ void __attribute__((format (printf, 4, 5)))
>  #define ql_dbg_tgt	0x00004000 /* Target mode */
>  #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
>  #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
> +#define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
>  
>  extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
>  	uint32_t, void **);
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 8bc1111..d6436fc 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -2189,6 +2189,23 @@ struct qlt_plogi_ack_t {
>  	void		*fcport;
>  };
>  
> +enum qla_tgt_prot_op {
> +	QLA_PROT_NORMAL  = 0,
> +	QLA_PROT_DIN_INSERT,
> +	QLA_PROT_DOUT_INSERT,
> +	QLA_PROT_DIN_STRIP,
> +	QLA_PROT_DOUT_STRIP,
> +	QLA_PROT_DIN_PASS,
> +	QLA_PROT_DOUT_PASS,
> +};
> +
> +enum qla_tgt_prot_type {
> +	QLA_TGT_PROT_TYPE0,
> +	QLA_TGT_PROT_TYPE1,
> +	QLA_TGT_PROT_TYPE2,
> +	QLA_TGT_PROT_TYPE3,
> +};
> +

I don't get it, why are you duplicating target_prot_op and
target_prot_type..?
