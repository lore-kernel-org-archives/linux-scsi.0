Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73C1C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2072081A
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 02:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vswMekIm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgF1CRa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 22:17:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgF1CRa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 22:17:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05S2DBM1051212;
        Sun, 28 Jun 2020 02:17:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=tpAihePks7JcNo+eU/DgGVchBEZlzSbSMix8/s3viuE=;
 b=vswMekImfpxaV8loDmCVi7P3v6mr+NVKguononsNom5NQEKEuVr9lv1yusjJQ+7+Lucx
 060EAtcG9rPH7Fal+sjNC552wziX4LQ4eQdfgE+LWadkqemiGG7RsyCgVSUwHINXgIwU
 5mqYRLvBX8UnWII6e1fgssCvAN/cbr5p5awQDjhBbq/1ZBIW9spQI3j7MZ4sVdZFwzQp
 2TOcqafKWImq4yrnIwtnAG2brhSkN3Zw3Apfnqdx3wUQqiAGd4fBkQvWVnzsjyojHkq3
 oQjc3LM2ibc7XLQW8/VCn1RlvAb09lbwZOKftEXUuBRvBUOH15lqP1+LfNjaNVL1FGCg iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31wxrmsujs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 28 Jun 2020 02:17:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05S2ENBl172461;
        Sun, 28 Jun 2020 02:17:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvp3erd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 28 Jun 2020 02:17:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05S2HINw016862;
        Sun, 28 Jun 2020 02:17:18 GMT
Received: from [20.15.0.2] (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 28 Jun 2020 02:17:16 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd
 completion
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>,
        Henry Willard <henry.willard@oracle.com>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <cc5cc3d3-3895-9850-8f7e-b911a6bf22c0@oracle.com>
Date:   Sat, 27 Jun 2020 21:17:14 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9665 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9665 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006280015
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/24/20 3:53 AM, Bodo Stroesser wrote:
> If tcmu_handle_completions() has to process a padding shorter
> than sizeof(struct tcmu_cmd_entry), the current call to
> tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as
> length param is wrong and causes crashes on e.g. ARM, because
> tcmu_flush_dcache_range() in this case calls
> 	flush_dcache_page(vmalloc_to_page(start));
> with start being an invalid address above the end of the
> vmalloc'ed area.
> 
> The fix is to use the maximum of remaining ring space and
> sizeof(struct tcmu_cmd_entry) as the length param.
> 
> The patch was tested on kernel 4.19.118.
> 
> See https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=208045*c10__;Iw!!GqivPVa7Brio!Kxr99oE0H1b9Ily4SE23nDN7ElSf8Tclo1RILfNSXb6iPh6DA5cSgtBQQsLMBKdrLsmT$ 
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Tested-by: JiangYu <lnsyyj@hotmail.com>
> ---
>  drivers/target/target_core_user.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 3885ca532f8f..82e476d48194 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1221,7 +1221,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
>  
>  		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
>  
> -		tcmu_flush_dcache_range(entry, sizeof(*entry));
> +		/*
> +		 * Flush max. up to end of cmd ring, since current entry might
> +		 * be a padding that is shorter than sizeof(*entry)
> +		 */
> +		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
> +					       udev->cmdr_size);
> +		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
> +					ring_left : sizeof(*entry));
>  
>  		if (tcmu_hdr_get_op(entry->hdr.len_op) == TCMU_OP_PAD) {
>  			UPDATE_HEAD(udev->cmdr_last_cleaned,
> 

Thanks again.

Acked-by: Mike Christie <michael.christie@oracle.com>
