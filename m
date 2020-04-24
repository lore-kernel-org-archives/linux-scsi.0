Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF94C55186
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:34:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BC6020736
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 09:34:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="epZAmMF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgDXJeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 05:34:09 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52328 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgDXJeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 05:34:08 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03O9J4d2121993;
        Fri, 24 Apr 2020 09:32:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Z5fm0JlUDRMu7agDoEFMG3owVVjV6URZ8EE7qnBJ2eE=;
 b=epZAmMF6V4D2FskrkwWkcfWnF2ozrCC+JlTMQQBUKMnP9jge7KZ9xT4bNKD3OE4QDvYy
 OodamDtaASiWnrZ84mAFn8F4hQl9FLTpNRMSBQQoZIdUzg1Kkcfl0tPkW+88P8j1KkID
 KhSTm2nob601CeS3jK+gR1q60DzznBU9jm6jL5YLHH9s53++yiQH2fstbAcbttM+gN+a
 ExrGA5jpPrnHwI+xceh7U3UcaDP0vzYHI+FkzpWmbIwz4TND0McbIqzvsFSsEkmJW1eN
 OOtvsaBlVXvAqq9LYZAVYNdI4woKuopiQrvOPHmopNkTcv20vI/nPntdH9moc6qJJeJa rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30k7qe5vgd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 09:32:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03O9ChBP070984;
        Fri, 24 Apr 2020 09:30:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30gbbpncp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 09:30:40 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03O9UceG027159;
        Fri, 24 Apr 2020 09:30:38 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 24 Apr 2020 02:30:38 -0700
Date:   Fri, 24 Apr 2020 12:30:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: fnic: Use kmalloc instead of vmalloc for a small
 memory allocation
Message-ID: <20200424093030.GO2659@kadam>
References: <20200423204620.26395-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204620.26395-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240073
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9600 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 mlxscore=0 clxscore=1011 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240073
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 23, 2020 at 10:46:20PM +0200, Christophe JAILLET wrote:
> 'struct fc_trace_flag_type' is just a few bytes long. There is no need
> to allocate such a structure with vmalloc. Using kmalloc instead.
> 
> While at it, axe a useless test when freeing the memory.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/scsi/fnic/fnic_debugfs.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
> index 13f7d88d6e57..8d6ce3470594 100644
> --- a/drivers/scsi/fnic/fnic_debugfs.c
> +++ b/drivers/scsi/fnic/fnic_debugfs.c
> @@ -58,8 +58,7 @@ int fnic_debugfs_init(void)
>  						fnic_trace_debugfs_root);
>  
>  	/* Allocate memory to structure */
> -	fc_trc_flag = (struct fc_trace_flag_type *)
> -		vmalloc(sizeof(struct fc_trace_flag_type));
> +	fc_trc_flag = kmalloc(sizeof(*fc_trc_flag), GFP_KERNEL);
>  
>  	if (fc_trc_flag) {

I hate success handling... This test should be reversed so that we do
error handling. It should return -ENOMEM instead of 0 on allocation
failure, otherwise it leads to a NULL dereference down the road.
Although, of course in current kernel small size allocations like this
never fail in real life.

The other thing I wonder is if we should just replace the vmalloc()
implementation with kvmalloc().  IOW rename vmalloc() to __vmalloc() and
"#define vmalloc kvmalloc" (not literally).  That was allocations of
less than a page would always be done with kmalloc().

regards,
dan carpenter

