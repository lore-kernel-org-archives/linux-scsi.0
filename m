Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876B1C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62EB120870
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:38:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1yzdnXP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgEHLie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 07:38:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHLid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 07:38:33 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048BbFf6123705;
        Fri, 8 May 2020 11:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=nCpGeHM35A978bmB4uW/3Av9gsC7OVEMsrZUl3IqP/8=;
 b=K1yzdnXPOPS56/bPlwQkg5H9OS6A8zMAyswmLTZZHdDqz3WMegBF9apR4iQTEadvOCKu
 OTgWLaf0oVi0Xqv4VFYoewsL/987fmuaFkACcRlIfKX7tqkBNbw7CAStI1EDQrWxBWt0
 N+I6OQpTPh8L4cOtYQhd7lpTv0D5C1gPOkQQdksqT90EAL+MVHEhk5y13MQIecmrR/oS
 voHozKw/1HDawBZmcCXLyM9+iLS2GoChtrjsvsx+HIghyswguq+WRtWwLnEOWU/pswI/
 QoFu1wmpRrX1Wxi4dtM/PLHXLYs9iB/Kj2TwAvH/ssaY0QAHzUZFw4JpNR//jmZq9/aH +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30vtepjg4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 11:38:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 048BZxCR131652;
        Fri, 8 May 2020 11:36:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30vtecayg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 11:36:30 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 048BaTUZ026150;
        Fri, 8 May 2020 11:36:29 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 08 May 2020 04:36:29 -0700
Date:   Fri, 8 May 2020 14:36:22 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Fix double free warnings
Message-ID: <20200508113622.GP1992@kadam>
References: <20200508091854.32748-1-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508091854.32748-1-suganath-prabu.subramani@broadcom.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 suspectscore=2
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=2 mlxscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005080102
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 08, 2020 at 05:18:54AM -0400, Suganath Prabu S wrote:
> Fix below warnings from Smatch static analyser:
> drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
> warn: 'ioc->hpr_lookup' double freed
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:5256 _base_allocate_memory_pools()
> warn: 'ioc->internal_lookup' double freed
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 7fa3bdb..a6dbc73 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -4898,8 +4898,14 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
>  		    ioc->config_page, ioc->config_page_dma);
>  	}
>  
> -	kfree(ioc->hpr_lookup);
> -	kfree(ioc->internal_lookup);
> +	if (ioc->hpr_lookup) {
> +		kfree(ioc->hpr_lookup);
> +		ioc->hpr_lookup = NULL;
> +	}
> +	if (ioc->internal_lookup) {
> +		kfree(ioc->internal_lookup);
> +		ioc->internal_lookup = NULL;
> +	}


We could remove the if statements because kfree()ing a NULL is a no-op.
I think the build bots will automatically send a patch suggesting to do
that when they see this patch.

Really there is no way that these massive free everything in every
situation functions will ever work 100%.  There is a simple and correct
method to do error handling which is the "Free the most recent
allocation" method.

1) Every function cleans up it's own allocations.
2) Every allocation function has a mirrored free function.
3) Always use clear label names like "goto free_variable_x;"
4) The goto should free the most recent allocation.

The results of rule number 4 are:
1) You never free things which haven't been allocated.
2) The error handling is in the reverse/mirror order from the allocation
3) The error handling is simple because you only need to remember the
   most recent allocation.  Easy to audit.  No leaks.  No bugs.

It looks like this in practice.

int my_func(void)
{
	a = alloc();
	if (!a)
		return -ENOMEM;

	b = alloc();
	if (!b) {
		ret = -ENOMEM:
		goto free_a;
	}

	c = alloc();
	if (!c) {
		ret = -ENOMEM;
		goto free_b;
	}

	return 0;

free_b:
	free(b);
free_a:
	free(a);
	return ret;
}

Then cut and paste and add a free(c); to create the free function.

void my_free_func(void)
{
	free(c);
	free(b);
	free(a);
}

This method removes all the if statements in the error handling path but
it uses more labels so the number of lines is basically the same.  There
is one more rule for unwinding from loops and this code has a lot of
looped allocations:  Release the partial iteration before breaking
from the loop.

	for (i = 0; i < count; i++) {
		array[i].a = alloc();
		if (!array[i].a) {
			ret = -ENOMEM;
			goto unwind;
		}

		array[i].b = alloc();
		if (!array[i].b) {
			free(array[i].a);
			ret = -ENOMEM;
			goto unwind;
		}
	}

	...

unwind:
	while (--i >= 0) {
		free(array[i].b);
		free(array[i].a);
	}

The style here with a big _base_release_memory_pools() function that has
to handle partially allocated resources will never work 100% correctly.
Fortunately the remaining bugs are minor leaks and not crashing bugs so
that's probably as good as we can hope for.

regards,
dan carpenter

