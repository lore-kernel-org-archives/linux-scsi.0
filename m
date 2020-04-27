Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63916C54FCB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:34:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35831206BF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 14:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SIh4P6x8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgD0Oeq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 10:34:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727010AbgD0Oeq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 10:34:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RET98W127113;
        Mon, 27 Apr 2020 14:34:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=9u8Nj6JETuWM2WRSN/+ey2b2a0oPZULUwl73DFqXUqE=;
 b=SIh4P6x8NJ4e7YfKTMr6YurUpCCM2BuExlt2kE3+pxHliUz6SFrhKaYC7KdZqzke3xAz
 pFKAUUmlFRdumeP8/zEIywEa4E+HWnIHI5AxH5ap6L9P+LjyVjiliahIEta2IPe/plyi
 e6mTOOALZZNZN4/vhbC0SiWq5YwjTOUi2gRuoVV+JPJIW/hPRX/buYlpGxcU1bCmLZEA
 IpXxhMwcALoennluiySt+yDDY3GtPTgyiW+RYZa8JEAgobnP4IdBoFAjLXZp0axhQ4vf
 7QWAMAPxLp28NjCGJdy0rV+5QWc/n/NSzEWqWZ0ohEtSo09XVgVjApD3lfnXNPuGUpX+ TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30p01ngfyf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:34:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03REQrcG073166;
        Mon, 27 Apr 2020 14:34:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30my09k3qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 14:34:36 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03REYYrL005650;
        Mon, 27 Apr 2020 14:34:34 GMT
Received: from [10.154.123.249] (/10.154.123.249)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 07:34:34 -0700
Subject: Re: [PATCH v4 07/11] qla2xxx: Change two hardcoded constants into
 offsetof() / sizeof() expressions
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-8-bvanassche@acm.org>
From:   himanshu.madhani@oracle.com
Organization: Oracle Corporation
Message-ID: <58d56891-0087-80a7-eb5e-49c7336e24ca@oracle.com>
Date:   Mon, 27 Apr 2020 09:34:27 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427030310.19687-8-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9603 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270122
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 4/26/20 10:03 PM, Bart Van Assche wrote:
> This patch does not change any functionality.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h  | 3 +--
>   drivers/scsi/qla2xxx/qla_sup.c | 2 +-
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index 4fa34374f34f..f18d2d00d28c 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2216,9 +2216,8 @@ struct qla_fcp_prio_cfg {
>   #define FCP_PRIO_ATTR_ENABLE    0x1
>   #define FCP_PRIO_ATTR_PERSIST   0x2
>   	uint8_t  reserved;      /* Reserved for future use          */
> -#define FCP_PRIO_CFG_HDR_SIZE   0x10
> +#define FCP_PRIO_CFG_HDR_SIZE   offsetof(struct qla_fcp_prio_cfg, entry)
>   	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
> -#define FCP_PRIO_CFG_ENTRY_SIZE 0x20
>   	uint8_t  reserved2[16];
>   };
>   
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
> index 3da79ee1d88e..57ffbf9d7dbf 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -3617,7 +3617,7 @@ qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *vha)
>   
>   	/* read remaining FCP CMD config data from flash */
>   	fcp_prio_addr += (FCP_PRIO_CFG_HDR_SIZE >> 2);
> -	len = ha->fcp_prio_cfg->num_entries * FCP_PRIO_CFG_ENTRY_SIZE;
> +	len = ha->fcp_prio_cfg->num_entries * sizeof(struct qla_fcp_prio_entry);
>   	max_len = FCP_PRIO_CFG_SIZE - FCP_PRIO_CFG_HDR_SIZE;
>   
>   	ha->isp_ops->read_optrom(vha, &ha->fcp_prio_cfg->entry[0],
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani
Oracle Linux Engineering
