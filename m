Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82465C2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CE4D2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 17:18:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z2rYjlyj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732645AbgDMRS2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 13:18:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732636AbgDMRSY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 13:18:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DHBQ6s139021;
        Mon, 13 Apr 2020 17:18:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4INfLetwrjK41w33w/BAJrhEDhsJqI5xMpRCI8OWlD0=;
 b=Z2rYjlyjFBQLM2pVxhwtpDz5cnq7UxnCWSLijE9RGqrsdZYcy6WVaXa6f5EqVDw3kXAB
 iTqSoIETwmxMSMa3lPQcveKUB0Q9e/Ah9CcZNau8Tou/SMg/smzDUfXbbZCkpOMK18OD
 PIy2Ot9y8S/vxVQ1lGRpPkog9BSD7yfLg8+mnlX9kvAI4XaSn7LPbdXKv0UNMTjEqWnn
 9isAt4TC9LREqZKyoZwDKqoml3sxbx//ku4oVKkshQg8qRSyxYxVdgWazlSZmxvRHjkX
 1IYbKP+GlRM+F4FjGvGraHusc1CSuVd9lZBa/4qXGLHO+YZe9TMDoKkaPkEqDPxwOl59 QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30b5aqytq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:18:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DH74SM020166;
        Mon, 13 Apr 2020 17:18:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30bqkxtfak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 17:18:13 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DHIB1t030854;
        Mon, 13 Apr 2020 17:18:12 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 10:18:11 -0700
Subject: Re: [PATCH] qla2xxx: Use ARRAY_SIZE() instead of open-coding it
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200413021359.21725-1-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <0d6c4d76-afe1-d69b-6f32-ad62e925c6ab@oracle.com>
Date:   Mon, 13 Apr 2020 12:18:09 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200413021359.21725-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130132
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 9:13 PM, Bart Van Assche wrote:
> This patch does not change any functionality.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c | 36 +++++++++++++++++-----------------
>   1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index f301a8048b2f..8b7d0e476773 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -778,16 +778,16 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	if (rval == QLA_SUCCESS) {
>   		dmp_reg = &reg->flash_address;
> -		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->pbiu_reg); cnt++, dmp_reg++)
>   			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
>   		dmp_reg = &reg->u.isp2300.req_q_in;
> -		for (cnt = 0; cnt < sizeof(fw->risc_host_reg) / 2;
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_host_reg);
>   		    cnt++, dmp_reg++)
>   			fw->risc_host_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
>   		dmp_reg = &reg->u.isp2300.mailbox0;
> -		for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2;
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg);
>   		    cnt++, dmp_reg++)
>   			fw->mailbox_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
> @@ -799,7 +799,7 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   		WRT_REG_WORD(&reg->ctrl_status, 0x00);
>   		dmp_reg = &reg->risc_hw;
> -		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2;
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_hdw_reg);
>   		    cnt++, dmp_reg++)
>   			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
> @@ -860,12 +860,12 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   	/* Get RISC SRAM. */
>   	if (rval == QLA_SUCCESS)
>   		rval = qla2xxx_dump_ram(ha, 0x800, fw->risc_ram,
> -		    sizeof(fw->risc_ram) / 2, &nxt);
> +					ARRAY_SIZE(fw->risc_ram), &nxt);
>   
>   	/* Get stack SRAM. */
>   	if (rval == QLA_SUCCESS)
>   		rval = qla2xxx_dump_ram(ha, 0x10000, fw->stack_ram,
> -		    sizeof(fw->stack_ram) / 2, &nxt);
> +					ARRAY_SIZE(fw->stack_ram), &nxt);
>   
>   	/* Get data SRAM. */
>   	if (rval == QLA_SUCCESS)
> @@ -944,7 +944,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   	}
>   	if (rval == QLA_SUCCESS) {
>   		dmp_reg = &reg->flash_address;
> -		for (cnt = 0; cnt < sizeof(fw->pbiu_reg) / 2; cnt++, dmp_reg++)
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->pbiu_reg); cnt++, dmp_reg++)
>   			fw->pbiu_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
>   		dmp_reg = &reg->u.isp2100.mailbox0;
> @@ -956,12 +956,12 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   		}
>   
>   		dmp_reg = &reg->u.isp2100.unused_2[0];
> -		for (cnt = 0; cnt < sizeof(fw->dma_reg) / 2; cnt++, dmp_reg++)
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->dma_reg); cnt++, dmp_reg++)
>   			fw->dma_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
>   		WRT_REG_WORD(&reg->ctrl_status, 0x00);
>   		dmp_reg = &reg->risc_hw;
> -		for (cnt = 0; cnt < sizeof(fw->risc_hdw_reg) / 2; cnt++, dmp_reg++)
> +		for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_hdw_reg); cnt++, dmp_reg++)
>   			fw->risc_hdw_reg[cnt] = htons(RD_REG_WORD(dmp_reg));
>   
>   		WRT_REG_WORD(&reg->pcr, 0x2000);
> @@ -1041,7 +1041,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>    		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_WORD);
>   		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
>   	}
> -	for (cnt = 0; cnt < sizeof(fw->risc_ram) / 2 && rval == QLA_SUCCESS;
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_ram) && rval == QLA_SUCCESS;
>   	    cnt++, risc_address++) {
>    		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
>   		WRT_REG_WORD(&reg->hccr, HCCR_SET_HOST_INT);
> @@ -1145,7 +1145,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Host interface registers. */
>   	dmp_reg = &reg->flash_addr;
> -	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
>   		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
>   
>   	/* Disable interrupts. */
> @@ -1178,7 +1178,7 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Mailbox registers. */
>   	mbx_reg = &reg->mailbox0;
> -	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
>   		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
>   
>   	/* Transfer sequence registers. */
> @@ -1421,7 +1421,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Host interface registers. */
>   	dmp_reg = &reg->flash_addr;
> -	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
>   		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
>   
>   	/* Disable interrupts. */
> @@ -1470,7 +1470,7 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Mailbox registers. */
>   	mbx_reg = &reg->mailbox0;
> -	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
>   		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
>   
>   	/* Transfer sequence registers. */
> @@ -1745,7 +1745,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Host interface registers. */
>   	dmp_reg = &reg->flash_addr;
> -	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
>   		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
>   
>   	/* Disable interrupts. */
> @@ -1794,7 +1794,7 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Mailbox registers. */
>   	mbx_reg = &reg->mailbox0;
> -	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
>   		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
>   
>   	/* Transfer sequence registers. */
> @@ -2093,7 +2093,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Host interface registers. */
>   	dmp_reg = &reg->flash_addr;
> -	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++, dmp_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->host_reg); cnt++, dmp_reg++)
>   		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg));
>   
>   	/* Disable interrupts. */
> @@ -2142,7 +2142,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
>   
>   	/* Mailbox registers. */
>   	mbx_reg = &reg->mailbox0;
> -	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++, mbx_reg++)
> +	for (cnt = 0; cnt < ARRAY_SIZE(fw->mailbox_reg); cnt++, mbx_reg++)
>   		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg));
>   
>   	/* Transfer sequence registers. */
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>


