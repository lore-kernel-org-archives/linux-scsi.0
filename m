Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A96C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10BE822B42
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 21:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgGaV6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 17:58:39 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:40068 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726391AbgGaV6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 31 Jul 2020 17:58:39 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 9E9D8180A7FEE;
        Fri, 31 Jul 2020 21:58:38 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: chalk56_561320126f87
X-Filterd-Recvd-Size: 1949
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 31 Jul 2020 21:58:37 +0000 (UTC)
Message-ID: <33d943d2b83f17371df09b5962c856ea2d894954.camel@perches.com>
Subject: Re: [PATCH] scsi: libcxgbi: use kvzalloc instead of opencoded
 kzalloc/vzalloc
From:   Joe Perches <joe@perches.com>
To:     Denis Efremov <efremov@linux.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 31 Jul 2020 14:58:36 -0700
In-Reply-To: <20200731215524.14295-1-efremov@linux.com>
References: <20200731215524.14295-1-efremov@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-08-01 at 00:55 +0300, Denis Efremov wrote:
> Remove cxgbi_alloc_big_mem(), cxgbi_free_big_mem() functions
> and use kvzalloc/kvfree instead.

Sensible, thanks.

> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
[]
> @@ -77,9 +77,9 @@ int cxgbi_device_portmap_create(struct cxgbi_device *cdev, unsigned int base,
>  {
>  	struct cxgbi_ports_map *pmap = &cdev->pmap;
>  
> -	pmap->port_csk = cxgbi_alloc_big_mem(max_conn *
> -					     sizeof(struct cxgbi_sock *),
> -					     GFP_KERNEL);
> +	pmap->port_csk = kvzalloc(array_size(max_conn,
> +					     sizeof(struct cxgbi_sock *)),
> +				  GFP_KERNEL);

missing __GFP_NOWARN

> diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
[]
> @@ -537,22 +537,6 @@ struct cxgbi_task_data {
>  #define iscsi_task_cxgbi_data(task) \
>  	((task)->dd_data + sizeof(struct iscsi_tcp_task))
>  
> -static inline void *cxgbi_alloc_big_mem(unsigned int size,
> -					gfp_t gfp)
> -{
> -	void *p = kzalloc(size, gfp | __GFP_NOWARN);


