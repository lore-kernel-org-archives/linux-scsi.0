Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25553C433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F409F2075D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 17:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uk8E7BLD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgGMRxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 13:53:53 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729826AbgGMRxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 13:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594662831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0XvTABMJSNC09lO5NyQLA0ucrlVh1ae0kKBVgF9YYZ0=;
        b=Uk8E7BLDo6jkIliA1vqtCtgXcCJMGYFvLvmLQfWQvJAL83woii2nG9/k9ccGTkoIiUzqz3
        JTjLtswpQsymiL0QFh/gtOVNeQKfVTjC0YYA5g8Tbd3l1t+xLq1CpN1OAHHgXHz37/lNsA
        8Ah2o+jdGD169IbFteOM/rWpogkeQAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-UJ3xn4ouMdK1Dg7aSPI-Ig-1; Mon, 13 Jul 2020 13:53:46 -0400
X-MC-Unique: UJ3xn4ouMdK1Dg7aSPI-Ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD3601091;
        Mon, 13 Jul 2020 17:53:38 +0000 (UTC)
Received: from ovpn-113-77.phx2.redhat.com (ovpn-113-77.phx2.redhat.com [10.3.113.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D14535C1BB;
        Mon, 13 Jul 2020 17:53:37 +0000 (UTC)
Message-ID: <d1fa9e60b559b6bf3a37ef5a6aef2bd7bd6e1681.camel@redhat.com>
Subject: Re: [PATCH v2] scsi: fcoe: add missed kfree() in an error path
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>, hare@suse.de,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        robert.w.love@intel.com, Neerav.Parikh@intel.com,
        Markus.Elfring@web.de
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 13 Jul 2020 13:53:37 -0400
In-Reply-To: <20200709120546.38453-1-jingxiangfeng@huawei.com>
References: <20200709120546.38453-1-jingxiangfeng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

See below.

On Thu, 2020-07-09 at 20:05 +0800, Jing Xiangfeng wrote:
> fcoe_fdmi_info() misses to call kfree() in an error path.
> Add a label 'free_fdmi' and jump to it.
> 
> Fixes: f07d46bbc9ba ("fcoe: Fix smatch warning in fcoe_fdmi_info
> function")
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>  drivers/scsi/fcoe/fcoe.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 25dae9f0b205..a63057a03772 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -830,7 +830,7 @@ static void fcoe_fdmi_info(struct fc_lport
> *lport, struct net_device *netdev)
>  		if (rc) {
>  			printk(KERN_INFO "fcoe: Failed to retrieve FDMI
> "
>  					"information from netdev.\n");
> -			return;
> +			goto free_fdmi;
>  		}
>  
>  		snprintf(fc_host_serial_number(lport->host),
> @@ -868,6 +868,7 @@ static void fcoe_fdmi_info(struct fc_lport
> *lport, struct net_device *netdev)
>  
>  		/* Enable FDMI lport states */
>  		lport->fdmi_enabled = 1;
> +free_fdmi:
>  		kfree(fdmi);
>  	} else {
>  		lport->fdmi_enabled = 0;

Normally I would like to see goto labels for error paths outside
conditionals and at the end of the function.  In this case it would
seem to be cleaner to put an else { } clause in the if (rc) above
around the snprintf() calls.

-Ewan 

