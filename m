Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F46C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7057723431
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfICOs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:48:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfICOs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 10:48:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1F804904;
        Tue,  3 Sep 2019 14:48:27 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FD025DD6D;
        Tue,  3 Sep 2019 14:48:27 +0000 (UTC)
Message-ID: <135ea288fca9d11146e661798afefb92ef968649.camel@redhat.com>
Subject: Re: [PATCH 2/6] qla2xxx: Fix flash read for Qlogic ISPs
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 03 Sep 2019 10:48:26 -0400
In-Reply-To: <20190830222402.23688-3-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
         <20190830222402.23688-3-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 03 Sep 2019 14:48:27 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-08-30 at 15:23 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Use adapter specific callback to read flash instead of ISP
> adapter specific.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 4 ++--
>  drivers/scsi/qla2xxx/qla_nx.c   | 1 +
>  drivers/scsi/qla2xxx/qla_sup.c  | 8 ++++----
>  3 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 632130b6165d..8161f08f3a4d 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -8229,7 +8229,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>  		    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
>  		    "primary" : "secondary");
>  	}
> -	qla24xx_read_flash_data(vha, ha->vpd, faddr, ha->vpd_size >> 2);
> +	ha->isp_ops->read_optrom(vha, ha->vpd, faddr << 2, ha->vpd_size);
>  
>  	/* Get NVRAM data into cache and calculate checksum. */
>  	faddr = ha->flt_region_nvram;
> @@ -8241,7 +8241,7 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>  	    "Loading %s nvram image.\n",
>  	    active_regions.aux.vpd_nvram == QLA27XX_PRIMARY_IMAGE ?
>  	    "primary" : "secondary");
> -	qla24xx_read_flash_data(vha, ha->nvram, faddr, ha->nvram_size >> 2);
> +	ha->isp_ops->read_optrom(vha, ha->nvram, faddr << 2, ha->nvram_size);
>  
>  	dptr = (uint32_t *)nv;
>  	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++, dptr++)
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index 65a675906188..a79f8da38abe 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -2288,6 +2288,7 @@ qla82xx_disable_intrs(struct qla_hw_data *ha)
>  	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
>  
>  	qla82xx_mbx_intr_disable(vha);
> +
>  	spin_lock_irq(&ha->hardware_lock);
>  	if (IS_QLA8044(ha))
>  		qla8044_wr_reg(ha, LEG_INTR_MASK_OFFSET, 1);
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
> index 764e1bb0f695..f2d5115b2d8d 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -682,8 +682,8 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
>  
>  	ha->flt_region_flt = flt_addr;
>  	wptr = (uint16_t *)ha->flt;
> -	qla24xx_read_flash_data(vha, (void *)flt, flt_addr,
> -	    (sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE) >> 2);
> +	ha->isp_ops->read_optrom(vha, (void *)flt, flt_addr << 2,
> +	    (sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE));
>  
>  	if (le16_to_cpu(*wptr) == 0xffff)
>  		goto no_flash_data;
> @@ -950,11 +950,11 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
>  	struct req_que *req = ha->req_q_map[0];
>  	uint16_t cnt, chksum;
>  	uint16_t *wptr = (void *)req->ring;
> -	struct qla_fdt_layout *fdt = (void *)req->ring;
> +	struct qla_fdt_layout *fdt = (struct qla_fdt_layout *)req->ring;
>  	uint8_t	man_id, flash_id;
>  	uint16_t mid = 0, fid = 0;
>  
> -	qla24xx_read_flash_data(vha, (void *)fdt, ha->flt_region_fdt,
> +	ha->isp_ops->read_optrom(vha, fdt, ha->flt_region_fdt << 2,
>  	    OPTROM_BURST_DWORDS);
>  	if (le16_to_cpu(*wptr) == 0xffff)
>  		goto no_flash_data;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

