Return-Path: <SRS0=wQ7u=5W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CEEC2BA19
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 14:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 584EA23109
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 14:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wIzsjJgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgDFOzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 10:55:17 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgDFOzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2020 10:55:17 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036Elg5L002425;
        Mon, 6 Apr 2020 14:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=MER3BEmFq/xOfB6kIYr8DVoPJGODRlwFWSm09txw+Hc=;
 b=wIzsjJglYz3ErrCofcAOtPHS1Tdadozco5Q0Sv/vbuG8yCI4hPLXISVfO1bXISUg9ibr
 y+/XPrhZfzxMEI23pWY/zrYgEmoKuGLMEb7RpwRDWqnYMQboc61y5yXCCVwiQLbxrpaz
 cc4v9rDPyXJGw8M68wyKcmMfyglm4bdi3mf7Oc7ClceprXTTgSx5vmW3hBqf4h0fcMIV
 SFljKwWjCVBJFdee5+20cgRAGJbvxhOaMITHVKidGJg23IcOVQRyTenRL7bXBCNzX9zI
 xvMlK3yyKvtumqHtERpDcctGMI8gsUX9RkcdrQMziARzPDwhiAQ+BOXvutTB0s+rcoQw ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 306j6m7bgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:54:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 036EmQeV048653;
        Mon, 6 Apr 2020 14:54:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30839q7y83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Apr 2020 14:54:19 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 036EsHUi029617;
        Mon, 6 Apr 2020 14:54:17 GMT
Received: from [192.168.1.24] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Apr 2020 07:54:17 -0700
Subject: Re: [PATCH] qla2xxx: Increase the size of struct qla_fcp_prio_cfg to
 FCP_PRIO_CFG_SIZE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200405231339.29612-1-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle Corporation
Message-ID: <db86fed4-e326-8d88-5b38-4ef723b7ebc6@oracle.com>
Date:   Mon, 6 Apr 2020 09:54:15 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200405231339.29612-1-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9582 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 phishscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004060123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/20 6:13 PM, Bart Van Assche wrote:
> This patch fixes the following Coverity complaint without changing any
> functionality:
> 
> CID 337793 (#1 of 1): Wrong size argument (SIZEOF_MISMATCH)
> suspicious_sizeof: Passing argument ha->fcp_prio_cfg of type
> struct qla_fcp_prio_cfg * and argument 32768UL to function memset is
> suspicious because a multiple of sizeof (struct qla_fcp_prio_cfg) /*48*/
> is expected.
> 
> memset(ha->fcp_prio_cfg, 0, FCP_PRIO_CFG_SIZE);
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Himanshu Madhani <hmadhani@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h | 3 ++-
>   drivers/scsi/qla2xxx/qla_os.c | 1 +
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
> index f9bad5bd7198..647e67c6ba5e 100644
> --- a/drivers/scsi/qla2xxx/qla_fw.h
> +++ b/drivers/scsi/qla2xxx/qla_fw.h
> @@ -2217,8 +2217,9 @@ struct qla_fcp_prio_cfg {
>   #define FCP_PRIO_ATTR_PERSIST   0x2
>   	uint8_t  reserved;      /* Reserved for future use          */
>   #define FCP_PRIO_CFG_HDR_SIZE   0x10
> -	struct qla_fcp_prio_entry entry[1];     /* fcp priority entries  */
> +	struct qla_fcp_prio_entry entry[1023]; /* fcp priority entries  */
>   #define FCP_PRIO_CFG_ENTRY_SIZE 0x20
> +	uint8_t  reserved2[16];
>   };
>   
>   #define FCP_PRIO_CFG_SIZE       (32*1024) /* fcp prio data per port*/
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d9072ea7c42b..784f3e553f15 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7840,6 +7840,7 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
>   	BUILD_BUG_ON(sizeof(struct qla_flt_region) != 16);
>   	BUILD_BUG_ON(sizeof(struct qla_flt_header) != 8);
> +	BUILD_BUG_ON(sizeof(struct qla_fcp_prio_cfg) != FCP_PRIO_CFG_SIZE);
>   
>   	/* Allocate cache for SRBs. */
>   	srb_cachep = kmem_cache_create("qla2xxx_srbs", sizeof(srb_t), 0,
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu
