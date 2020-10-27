Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF57AC56201
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843B520723
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 00:20:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b+CDkvHV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411152AbgJ0AUY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:20:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441044AbgJ0AUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 20:20:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0FLSB054161;
        Tue, 27 Oct 2020 00:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=V+I/6sQLct9nfQnP4AihgNQcO22fhvePKK+TiPFBnR4=;
 b=b+CDkvHVfeDDjP+Bt/FzgajCoF1EkwsSH2cljeV2NwA4YNTAa2e6y6KC2W093dLqxQIg
 jACNgvBF1tXHsTwhyHQlqzntVNNe0Bi1WnZcXej3dsBe5pjYgVWYyktsDfnWr5nFFTpy
 xGOOVyizZ7xDt7xDzRT1klw1I+fic7gUV8DZK1PDmogb6gJynW725Azl9rL5lsrCgTWR
 QNjRhh7kG6ny47qppM3S3uIl+k1mak9l2Bs6pUBWwrwhp9IEWUjr/ZbQKOXh+QnxXG06
 FeDDITS7rL0P+X5P7A5s3h5TQyXj8mqWPYPdEFg8Srlbp0oKQnlfFxGaMjo523AqMY11 wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kqavw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 00:20:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09R0GFId144725;
        Tue, 27 Oct 2020 00:20:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34cx1q38d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 00:20:08 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09R0K5Aj012950;
        Tue, 27 Oct 2020 00:20:05 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 17:20:04 -0700
To:     ching Huang <ching2048@areca.com.tw>
Cc:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] scsi: arcmsr: Configure the default SCSI device
 command timeout value
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18sbs7c83.fsf@ca-mkp.ca.oracle.com>
References: <06ee8b1a3c14f855c6dc2a2c0dc996d33ca41f50.camel@areca.com.tw>
Date:   Mon, 26 Oct 2020 20:20:02 -0400
In-Reply-To: <06ee8b1a3c14f855c6dc2a2c0dc996d33ca41f50.camel@areca.com.tw>
        (ching Huang's message of "Fri, 16 Oct 2020 03:24:22 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=5 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=5
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270000
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ching,

The following hunk doesn't appear to be related to the command timeout
changes:

> @@ -3156,10 +3162,12 @@ message_out:
>  
>  static struct CommandControlBlock *arcmsr_get_freeccb(struct AdapterControlBlock *acb)
>  {
> -	struct list_head *head = &acb->ccb_free_list;
> +	struct list_head *head;
>  	struct CommandControlBlock *ccb = NULL;
>  	unsigned long flags;
> +
>  	spin_lock_irqsave(&acb->ccblist_lock, flags);
> +	head = &acb->ccb_free_list;
>  	if (!list_empty(head)) {
>  		ccb = list_entry(head->next, struct CommandControlBlock, list);
>  		list_del_init(&ccb->list);

-- 
Martin K. Petersen	Oracle Linux Engineering
