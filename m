Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DACAC4363D
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 17:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F5F823119
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 17:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h2rfH82V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgIVR2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:28:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:49232 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgIVR2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 13:28:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MHNR4U173411;
        Tue, 22 Sep 2020 17:28:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=d5XPbf1w9/nBqSbHaQfQ7OJP6e9Jx2L+/PCc3taXVfw=;
 b=h2rfH82VkTNUcZaevHbnS6diCvdKzcYzPY3e2zOu9StR3r6WgOOF73NiH8nRiRRJQcvi
 9/Z0xM97Yi5VX8bt5qanCa2LtmdcqOQGK53C+E2vd4tmt/pbmmb+BQLIMdrTJE4bwJxi
 23B/VyQc9qdbM4HCEkSNtdhwDRJf+Qkoz5iscA2S8Vu8tXNiHkAHVButdrHVrfJyGVPQ
 yt6H9oqXMbKbvhgpZ1aN8eiI+PbvIqnxHvgNBU6+Kh9bbF4ck0iinB8uNqeTxSAUzinU
 DUv8vgy3/7TMZy5kwSbUdanL2IHN4Slxb/vaIUYFZa/gi9DtoslLob3iiamKrc2DY/Rj tA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcptu2j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 22 Sep 2020 17:28:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08MHPMBo069115;
        Tue, 22 Sep 2020 17:28:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 33nuwyqyhc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Sep 2020 17:28:16 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08MHSFTh029874;
        Tue, 22 Sep 2020 17:28:15 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Sep 2020 10:28:15 -0700
Subject: Re: [PATCH] scsi: target: Fix lun lookup for
 TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     ssudhakarp@gmail.com
References: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <f850f290-c2f9-6ed9-1d84-980e1ba26c99@oracle.com>
Date:   Tue, 22 Sep 2020 12:28:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220135
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9752 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1011 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009220135
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/16/20 6:54 PM, Sudhakar Panneerselvam wrote:
> transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
> for the lookup. Hence, update this field directly for the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
> 
> Fixes: a36840d80027 ("target: Initialize LUN in transport_init_se_cmd()")
> Reported-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 9fb0be0aa620..8dd289214dd8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
>  	 * out unpacked_lun for the original se_cmd.
>  	 */
>  	if (tm_type == TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
> -		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
> +		if (!target_lookup_lun_from_tag(se_sess, tag,
> +						&se_cmd->orig_fe_lun))
>  			goto failure;
>  	}
>  
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
