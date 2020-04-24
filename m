Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8EC2C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 22:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9946C20706
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 22:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rRlwzi4l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDXWXl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 18:23:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58318 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgDXWXl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 18:23:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OMJBcj111441;
        Fri, 24 Apr 2020 22:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=4burvc8rRyQM6v4gBy1cG+9OCDe7C9ocHkSwXVo8RKg=;
 b=rRlwzi4lL4gkbydgSn/Gv3CfCf9yMhD3eEhQab8tuJ8DBI3FJAd2LvJ8HVhwv7CBtVZY
 lpcuruXNifmtOBR65yjA1JRcqhQPI4C2kuwXh5nDqRMYZjv2Na72CIxEVqR8voxUlHDQ
 G8kB8uau4Q57xmbyO9d/Zrzx5nsk4hZ475rF5L1//XuVNR20tnOZsMjNFPbXWXnHZr+i
 vZBs4mziTqwEFP6aJEb8GtZl0hfmCLA8nYjHfyJ1HPYPJ5xBZaH1eDh48++/zw4Qbn/u
 LM0HU7Qdes2upnvJYDaI5KXGVTt22oXFy/JNBIUAwseNOCmEq4KYTLcN6frUQdo77VhC 1A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30k7qe9819-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 22:23:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03OMIQ88001213;
        Fri, 24 Apr 2020 22:23:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30gb1qq4en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 22:23:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03OMNSG9028406;
        Fri, 24 Apr 2020 22:23:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 15:23:28 -0700
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: aacraid: Use memdup_user() as a cleanup
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1587524232-118733-1-git-send-email-zou_wei@huawei.com>
Date:   Fri, 24 Apr 2020 18:23:26 -0400
In-Reply-To: <1587524232-118733-1-git-send-email-zou_wei@huawei.com> (Zou
        Wei's message of "Wed, 22 Apr 2020 10:57:12 +0800")
Message-ID: <yq1wo64bk0x.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9601 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240167
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zou,

> diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
> index ffe41bc..1ce1620 100644
> --- a/drivers/scsi/aacraid/commctrl.c
> +++ b/drivers/scsi/aacraid/commctrl.c
> @@ -513,17 +513,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
>  		goto cleanup;
>  	}
>  
> -	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
> -	if (!user_srbcmd) {
> -		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
> -		rcode = -ENOMEM;
> -		goto cleanup;
> -	}
> -	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
> -		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
> -		rcode = -EFAULT;
> -		goto cleanup;
> -	}
> +	user_srbcmd = memdup_user(user_srb, fibsize);
> +	if (IS_ERR(user_srbcmd))
> +		return PTR_ERR(user_srbcmd);
>  
>  	flags = user_srbcmd->flags; /* from user in cpu order */
>  	switch (flags & (SRB_DataIn | SRB_DataOut)) {

This is not equivalent, is it? The original code does a goto cleanup;
whereas your patch returns on error.

-- 
Martin K. Petersen	Oracle Linux Engineering
