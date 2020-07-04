Return-Path: <SRS0=sV/3=AP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB70C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jul 2020 04:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF46207D4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jul 2020 04:00:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZCy6/gbx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgGDEAg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jul 2020 00:00:36 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52948 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725385AbgGDEAg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jul 2020 00:00:36 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0643uxX4176078;
        Sat, 4 Jul 2020 04:00:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=OOjSy24Hryk069xd6ZwNAjqh2akFvgCF592foBx50ZY=;
 b=ZCy6/gbxlPwCW361CtAYcifJPlmyRGpdxTg878CTWJajKu3k4LxvI8Iv5qRu3JAgjRsS
 oBhzmk7D7QqH/zeOSNbOVaIs2NrtFLXoC6LdwGy6OpY91U39MZ+lMED/25AK1a3mwRxM
 8aDccbmmYjZWtOCK45NH+sYWiohWs56wagbmDbFU5HIlkVWko9ciaULIyiiYPXuE9VXt
 up2FBHyhS8aA9W0LrpoL+Nk7+hsc5p8RLeYG6p96lF1hreUJwA6xR2bgAlbkT74qVu4r
 +att2WepgubsFx4qTL7+vdXUU/thus4h6punh1tXSzDgYH33tWjO/x/t0pFtVL7uY07y /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrnqkmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 04 Jul 2020 04:00:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0643qrli012465;
        Sat, 4 Jul 2020 04:00:08 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 322hjyk9rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Jul 2020 04:00:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0644066U017673;
        Sat, 4 Jul 2020 04:00:07 GMT
Received: from [20.15.0.202] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 04 Jul 2020 03:58:53 +0000
Subject: Re: [PATCH] scsi: iscsi: register sysfs for workqueue iscsi_destroy
To:     Bob Liu <bob.liu@oracle.com>, linux-scsi@vger.kernel.org
Cc:     open-iscsi@googlegroups.com, martin.petersen@oracle.com,
        lduncan@suse.com, cleech@redhat.com
References: <20200703051603.1473-1-bob.liu@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <a34c8886-a6dc-4ce0-5ffd-a09d913daa5d@oracle.com>
Date:   Fri, 3 Jul 2020 22:59:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200703051603.1473-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040027
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9671 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007040027
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/3/20 12:16 AM, Bob Liu wrote:
> Register sysfs for workqueue iscsi_destroy, so that users can set cpu affinity
> through "cpumask" for this workqueue to get better isolation in cloud
> multi-tenant scenario.
> 
> This patch unfolded create_singlethread_workqueue(), added WQ_SYSFS and drop
> __WQ_ORDERED_EXPLICIT since __WQ_ORDERED_EXPLICIT workqueue isn't allowed to
> change "cpumask".
> 
> Suggested-by: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 7ae5024..aa8d4a3 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -4766,7 +4766,9 @@ static __init int iscsi_transport_init(void)
>   		goto release_nls;
>   	}
>   
> -	iscsi_destroy_workq = create_singlethread_workqueue("iscsi_destroy");
> +	iscsi_destroy_workq = alloc_workqueue("%s",
> +			WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | WQ_UNBOUND,
> +			1, "iscsi_destroy");
>   	if (!iscsi_destroy_workq) {
>   		err = -ENOMEM;
>   		goto destroy_wq;
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
