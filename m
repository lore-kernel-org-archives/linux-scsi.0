Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA2EC47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFFC2075E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 07:34:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="xCGv0pSR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgEKHei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 03:34:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29140 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728014AbgEKHei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 03:34:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B7VBer008795;
        Mon, 11 May 2020 00:34:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=RdD9kG+LLixqdkurrd0CDcA24s342CeomVIoM8gBT+E=;
 b=xCGv0pSROG1skrFLaFIw6Lx83DWr7Wp41EgURhVwqkCCzQfLTsb7U68INHJvwbHClvlH
 UflR2k4iBCdaPkxnvXnjGt78kHFWHKsV4GRGWP1Yw+9HtVgyZNqvP6Jf8J4BWkNeurIV
 sYNcpP0LV2OTj2PtedM1DFGyNVR7k1ATRViR5L8mEmGjZpzAQUO5R1TFKuRb1PckeX4W
 TVDCOwRDehjm/9LojatNG8exfAjc3W0kby/ksUxLfKwsFHw9lNLCh4Vb0SqFJF9lRF0U
 eG0WWHtMgUjwIRFohioe88+K9awMRb7mIlg+MgMgypsX0vETllA/a02Tmc06ys+Ifkws Vg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 30wsvqdwdd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 00:34:27 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 May
 2020 00:34:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 May 2020 00:34:25 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 9264C3F7040;
        Mon, 11 May 2020 00:34:25 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 04B7YP6r024252;
        Mon, 11 May 2020 00:34:25 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Mon, 11 May 2020 00:34:25 -0700
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
Subject: Re: [PATCH v4 04/11] qla2xxx: Add more BUILD_BUG_ON() statements
In-Reply-To: <20200427030310.19687-5-bvanassche@acm.org>
Message-ID: <alpine.LRH.2.21.9999.2005110032540.23618@irv1user01.caveonetworks.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-5-bvanassche@acm.org>
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
>
> Before fixing the endianness annotations in data structures, make the
> compiler verify the size of FC protocol and firmware data structures.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_os.c      | 59 ++++++++++++++++++++++++++++++
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 +++++++
>  2 files changed, 73 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 497544413aa0..2dd9c2a39cd5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7815,13 +7815,19 @@ qla2x00_module_init(void)
>  {
>  	int ret = 0;
>  
> +	BUILD_BUG_ON(sizeof(cmd_a64_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(cmd_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(cont_a64_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(cont_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(init_cb_t) != 96);
> +	BUILD_BUG_ON(sizeof(mrk_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
>  	BUILD_BUG_ON(sizeof(request_t) != 64);
> +	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct abort_iocb_entry_fx00) != 64);
> +	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
>  	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
>  	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
>  	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
>  	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
> @@ -7829,17 +7835,70 @@ qla2x00_module_init(void)
>  	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
>  	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
>  	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2344);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi_hba_attr) != 260);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi_port_attr) != 260);
> +	BUILD_BUG_ON(sizeof(struct ct_rsp_hdr) != 16);
> +	BUILD_BUG_ON(sizeof(struct ct_sns_req) != 4460);
>  	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
> +	BUILD_BUG_ON(sizeof(struct device_reg_24xx) != 256);
> +	BUILD_BUG_ON(sizeof(struct device_reg_25xxmq) != 24);
> +	BUILD_BUG_ON(sizeof(struct device_reg_2xxx) != 256);
> +	BUILD_BUG_ON(sizeof(struct device_reg_82xx) != 1288);
> +	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
>  	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
>  	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
> +	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
>  	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
>  	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
> +	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
> +	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
> +	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
> +	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
>  	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
> +	BUILD_BUG_ON(sizeof(struct pt_ls4_rx_unsol) != 64);
> +	BUILD_BUG_ON(sizeof(struct purex_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct qla2100_fw_dump) != 123634);
> +	BUILD_BUG_ON(sizeof(struct qla2300_fw_dump) != 136100);
> +	BUILD_BUG_ON(sizeof(struct qla24xx_fw_dump) != 37976);
> +	BUILD_BUG_ON(sizeof(struct qla25xx_fw_dump) != 39228);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_fce_chain) != 52);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_fw_dump) != 136172);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_mq_chain) != 524);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_chain) != 8);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_mqueue_header) != 12);
> +	BUILD_BUG_ON(sizeof(struct qla2xxx_offld_chain) != 24);
> +	BUILD_BUG_ON(sizeof(struct qla81xx_fw_dump) != 39420);
> +	BUILD_BUG_ON(sizeof(struct qla82xx_uri_data_desc) != 28);
> +	BUILD_BUG_ON(sizeof(struct qla82xx_uri_table_desc) != 32);
> +	BUILD_BUG_ON(sizeof(struct qla83xx_fw_dump) != 51196);
> +	BUILD_BUG_ON(sizeof(struct qla_fdt_layout) != 128);
>  	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>  	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> +	BUILD_BUG_ON(sizeof(struct qla_npiv_entry) != 24);
> +	BUILD_BUG_ON(sizeof(struct qla_npiv_header) != 16);
> +	BUILD_BUG_ON(sizeof(struct rdp_rsp_payload) != 336);
>  	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
> +	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
> +	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
>  	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
>  	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
> +	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(sts21_entry_t) != 64);
> +	BUILD_BUG_ON(sizeof(sts22_entry_t) != 64);
> +	BUILD_BUG_ON(sizeof(sts_cont_entry_t) != 64);
> +	BUILD_BUG_ON(sizeof(sts_entry_t) != 64);
> +	BUILD_BUG_ON(sizeof(sw_info_t) != 32);
> +	BUILD_BUG_ON(sizeof(target_id_t) != 2);
>  
>  	/* Allocate cache for SRBs. */
>  	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 1f0a185b2a95..92e1a5d3928b 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1958,6 +1958,20 @@ static int __init tcm_qla2xxx_init(void)
>  {
>  	int ret;
>  
> +	BUILD_BUG_ON(sizeof(struct abts_recv_from_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct abts_resp_from_24xx_fw) != 64);
> +	BUILD_BUG_ON(sizeof(struct atio7_fcp_cmnd) != 32);
> +	BUILD_BUG_ON(sizeof(struct atio_from_isp) != 64);
> +	BUILD_BUG_ON(sizeof(struct ba_acc_le) != 12);
> +	BUILD_BUG_ON(sizeof(struct ba_rjt_le) != 4);
> +	BUILD_BUG_ON(sizeof(struct ctio7_from_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct ctio7_to_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
> +	BUILD_BUG_ON(sizeof(struct ctio_crc_from_fw) != 64);
> +	BUILD_BUG_ON(sizeof(struct ctio_to_2xxx) != 64);
> +	BUILD_BUG_ON(sizeof(struct fcp_hdr_le) != 24);
> +	BUILD_BUG_ON(sizeof(struct nack_to_isp) != 64);
> +
>  	ret = tcm_qla2xxx_register_configfs();
>  	if (ret < 0)
>  		return ret;

How did you pick the list of structures for this one? IOCB
structures make sense, but why "ct_sns_req", for e.g.? Adding
support for a different request may alter the structure size.

Wondering what made you add all these checks? Anything tripped
while making some changes?
