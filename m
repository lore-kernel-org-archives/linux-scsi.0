Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08954C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 08:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiKWIPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 03:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiKWIPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 03:15:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A173EF1D86
        for <linux-scsi@vger.kernel.org>; Wed, 23 Nov 2022 00:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669191284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/cZO6BqqZk5h3pMcPNSrH00FRFbHJFSGQsjMEqcCLiw=;
        b=Iq8vqSDyq6vxSP5Gk8JF4a0/uhqBh2rLTzj6GbEMCZIvagGxky/RPHjmOe4yR8tH9cVvmG
        Y+ZTa6onUuxMEy2HDsaXRxvFHpPDQvssU9T58G5szcUDYX6l1349r/6QFpmgBgGdCVZhLD
        ll8qc81Qu/2TquVz2d7WsLGyW8Opsoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-552-o3eExf0wNzGzl2S-ENd0SA-1; Wed, 23 Nov 2022 03:14:38 -0500
X-MC-Unique: o3eExf0wNzGzl2S-ENd0SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF971833A09;
        Wed, 23 Nov 2022 08:14:37 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 66C1B2024CBE;
        Wed, 23 Nov 2022 08:14:31 +0000 (UTC)
Date:   Wed, 23 Nov 2022 16:14:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     don.brace@microchip.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, storagedev@microchip.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: Fix possible memory leak in hpsa_init_one()
Message-ID: <Y33WYvis1sHr29zU@T590>
References: <20221122015751.87284-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122015751.87284-1-yuancan@huawei.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 22, 2022 at 01:57:51AM +0000, Yuan Can wrote:
> The hpda_alloc_ctlr_info() allocates h and its field reply_map, however in
> hpsa_init_one(), if alloc_percpu() failed, the hpsa_init_one() jumps to
> clean1 directly, which frees h and leaks the h->reply_map.
> Fix by calling hpda_free_ctlr_info() to release h->replay_map and h
> instead free h directly.
> 
> Fixes: 8b834bff1b73 ("scsi: hpsa: fix selection of reply queue")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/scsi/hpsa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index f8e832b1bc46..e5cbc97a5ea4 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -8925,7 +8925,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		destroy_workqueue(h->monitor_ctlr_wq);
>  		h->monitor_ctlr_wq = NULL;
>  	}
> -	kfree(h);
> +	hpda_free_ctlr_info(h);

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

