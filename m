Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F4ACAB323
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB9206B9
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:18:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ULRN1DjF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgD0OSp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:18:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57920 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727898AbgD0OSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:18:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RDwkY6122830;
        Mon, 27 Apr 2020 14:18:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JjYp7PeSPHNCWLP4uWQtFx7EtcOTAgn1c+dOX2T84Jw=;
 b=ULRN1DjF9rkuLuAGkWC6yg5AqMzUku7KRURbxFBwKuvUEOLCPArkPN0hNeMw96Pgwa4H
 FLha/ghQOFqiUZhnvqYloardBNItM8KFULFbi/saaHT3IQ779jGJybZVbqOZJ3OhlvnA
 x7zSX6UldNFgZTGfZ20YxY9Fkolvxt5tNI4aHP7XyeaawZlgU2HewhpkcujyOLN0lNjp
 hF40sz373TAoJLnvqd9LvVrYes/DtOxqNEvFY0C+RGREgnhN2DWidU+YtQmC/0YnYZ+c
 ha8OPX/EH0K5Esp9ZpYwcyTr1jIIZEfCBgw2LC31SDYYgKkcZ0gmNkx3SDBgDE+dI1Y7 zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucfsurq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:18:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03REGoGB171379;
        Mon, 27 Apr 2020 14:18:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30mxpdbehd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:18:31 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03REITOP011833;
        Mon, 27 Apr 2020 14:18:29 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:18:29 -0700
Subject: Re: [PATCH v4 04/11] qla2xxx: Add more BUILD_BUG_ON() statements
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-5-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <31c4a6dd-812c-cf41-2e4a-142ae2858e8a@oracle.com>
Date:   Mon, 27 Apr 2020 09:18:24 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-5-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270119
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
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
>   drivers/scsi/qla2xxx/qla_os.c      | 59 ++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 14 +++++++
>   2 files changed, 73 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 497544413aa0..2dd9c2a39cd5 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7815,13 +7815,19 @@ qla2x00_module_init(void)
>   {
>   	int ret = 0;
>   
> +	BUILD_BUG_ON(sizeof(cmd_a64_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(cmd_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(cont_a64_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(cont_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(init_cb_t) != 96);
> +	BUILD_BUG_ON(sizeof(mrk_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(ms_iocb_entry_t) != 64);
>   	BUILD_BUG_ON(sizeof(request_t) != 64);
> +	BUILD_BUG_ON(sizeof(struct abort_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct abort_iocb_entry_fx00) != 64);
> +	BUILD_BUG_ON(sizeof(struct abts_entry_24xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct access_chip_84xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct access_chip_rsp_84xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct cmd_bidir) != 64);
>   	BUILD_BUG_ON(sizeof(struct cmd_nvme) != 64);
>   	BUILD_BUG_ON(sizeof(struct cmd_type_6) != 64);
> @@ -7829,17 +7835,70 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
>   	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
>   	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2344);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi_hba_attr) != 260);
> +	BUILD_BUG_ON(sizeof(struct ct_fdmi_port_attr) != 260);
> +	BUILD_BUG_ON(sizeof(struct ct_rsp_hdr) != 16);
> +	BUILD_BUG_ON(sizeof(struct ct_sns_req) != 4460);
>   	BUILD_BUG_ON(sizeof(struct ctio_crc2_to_fw) != 64);
> +	BUILD_BUG_ON(sizeof(struct device_reg_24xx) != 256);
> +	BUILD_BUG_ON(sizeof(struct device_reg_25xxmq) != 24);
> +	BUILD_BUG_ON(sizeof(struct device_reg_2xxx) != 256);
> +	BUILD_BUG_ON(sizeof(struct device_reg_82xx) != 1288);
> +	BUILD_BUG_ON(sizeof(struct device_reg_fx00) != 216);
>   	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
> +	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
>   	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
>   	BUILD_BUG_ON(sizeof(struct init_cb_81xx) != 128);
> +	BUILD_BUG_ON(sizeof(struct logio_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct mbx_entry) != 64);
> +	BUILD_BUG_ON(sizeof(struct mid_init_cb_24xx) != 5252);
> +	BUILD_BUG_ON(sizeof(struct mrk_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct nvram_24xx) != 512);
> +	BUILD_BUG_ON(sizeof(struct nvram_81xx) != 512);
>   	BUILD_BUG_ON(sizeof(struct pt_ls4_request) != 64);
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
>   	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
>   	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
> +	BUILD_BUG_ON(sizeof(struct qla_npiv_entry) != 24);
> +	BUILD_BUG_ON(sizeof(struct qla_npiv_header) != 16);
> +	BUILD_BUG_ON(sizeof(struct rdp_rsp_payload) != 336);
>   	BUILD_BUG_ON(sizeof(struct sns_cmd_pkt) != 2064);
> +	BUILD_BUG_ON(sizeof(struct sts_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry) != 64);
> +	BUILD_BUG_ON(sizeof(struct tsk_mgmt_entry_fx00) != 64);
>   	BUILD_BUG_ON(sizeof(struct verify_chip_entry_84xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
>   	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
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
>   	/* Allocate cache for SRBs. */
>   	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 1f0a185b2a95..92e1a5d3928b 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -1958,6 +1958,20 @@ static int __init tcm_qla2xxx_init(void)
>   {
>   	int ret;
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
>   	ret = tcm_qla2xxx_register_configfs();
>   	if (ret < 0)
>   		return ret;
> 

Looks fine.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
