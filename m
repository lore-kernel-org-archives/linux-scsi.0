Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8378C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 03:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 837C520767
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 03:10:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="blZfhzi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731185AbgFVDKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 23:10:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35978 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgFVDKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 23:10:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05M3AYL3156552;
        Mon, 22 Jun 2020 03:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Z5AWohSIQN/10LPAph7pzNm6ZxTToaAIJFczhN/Pa+E=;
 b=blZfhzi+2gWRAlKbpse8FO0ag3V/AcR4UdBHrU5YlLhO5C/XO2OqduP9jQNXaF/nQANB
 QhYYXSzWisWkmaQwYuhZJpTUeO7qQCqLPwKONcb2VCYBehtf7rirH/6omwkk2WLxmxdB
 liEKUtbxKkiTYku32AykzUnOhYaaKZy4gGkcDwNRCREiE9KqlAqEFXa5X7phbitGWLS2
 mFy7A7z53HD12eeHew+Zd0RUlZUkC6nzatu9YJfrY/CSrhf3nlKdDQSzDJg1mJurwS9w
 eyD+hdoEg1DB4DdjBTA3wjH6akNX0jrUfNbFQD7IsS9AIdWfvga86ImV2u11KcTFLAbL SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31sebbc1g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 22 Jun 2020 03:10:33 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05M37VPh088556;
        Mon, 22 Jun 2020 03:08:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31sv1k30hn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jun 2020 03:08:33 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05M38V6o019381;
        Mon, 22 Jun 2020 03:08:31 GMT
Received: from [192.168.0.110] (/183.246.145.120)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jun 2020 03:08:31 +0000
Subject: Re: [PATCH 1/2] workqueue: don't always set __WQ_ORDERED implicitly
To:     linux-kernel@vger.kernel.org
Cc:     tj@kernel.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        lduncan@suse.com, michael.christie@oracle.com
References: <20200611100717.27506-1-bob.liu@oracle.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <f926e5b0-b876-3dad-c1b2-33c250205452@oracle.com>
Date:   Mon, 22 Jun 2020 11:08:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200611100717.27506-1-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006220023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9659 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 suspectscore=1 clxscore=1015
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006220023
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ping..

On 6/11/20 6:07 PM, Bob Liu wrote:
> Current code always set 'Unbound && max_active == 1' workqueues to ordered
> implicitly, while this may be not an expected behaviour for some use cases.
> 
> E.g some scsi and iscsi workqueues(unbound && max_active = 1) want to be bind
> to different cpu so as to get better isolation, but their cpumask can't be
> changed because WQ_ORDERED is set implicitly.
> 
> This patch adds a flag __WQ_ORDERED_DISABLE and also
> create_singlethread_workqueue_noorder() to offer an new option.
> 
> Signed-off-by: Bob Liu <bob.liu@oracle.com>
> ---
>  include/linux/workqueue.h | 4 ++++
>  kernel/workqueue.c        | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
> index e48554e..4c86913 100644
> --- a/include/linux/workqueue.h
> +++ b/include/linux/workqueue.h
> @@ -344,6 +344,7 @@ enum {
>  	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
>  	__WQ_LEGACY		= 1 << 18, /* internal: create*_workqueue() */
>  	__WQ_ORDERED_EXPLICIT	= 1 << 19, /* internal: alloc_ordered_workqueue() */
> +	__WQ_ORDERED_DISABLE	= 1 << 20, /* internal: don't set __WQ_ORDERED implicitly */
>  
>  	WQ_MAX_ACTIVE		= 512,	  /* I like 512, better ideas? */
>  	WQ_MAX_UNBOUND_PER_CPU	= 4,	  /* 4 * #cpus for unbound wq */
> @@ -433,6 +434,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  #define create_singlethread_workqueue(name)				\
>  	alloc_ordered_workqueue("%s", __WQ_LEGACY | WQ_MEM_RECLAIM, name)
>  
> +#define create_singlethread_workqueue_noorder(name)			\
> +	alloc_workqueue("%s", WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | \
> +			WQ_UNBOUND | __WQ_ORDERED_DISABLE, 1, (name))
>  extern void destroy_workqueue(struct workqueue_struct *wq);
>  
>  struct workqueue_attrs *alloc_workqueue_attrs(void);
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 4e01c44..2167013 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4237,7 +4237,9 @@ struct workqueue_struct *alloc_workqueue(const char *fmt,
>  	 * on NUMA.
>  	 */
>  	if ((flags & WQ_UNBOUND) && max_active == 1)
> -		flags |= __WQ_ORDERED;
> +		/* the caller may don't want __WQ_ORDERED to be set implicitly. */
> +		if (!(flags & __WQ_ORDERED_DISABLE))
> +			flags |= __WQ_ORDERED;
>  
>  	/* see the comment above the definition of WQ_POWER_EFFICIENT */
>  	if ((flags & WQ_POWER_EFFICIENT) && wq_power_efficient)
> 
