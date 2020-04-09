Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB8EC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 15:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2066C206E9
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 15:29:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c1Q/Eq2x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgDIP3w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 11:29:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728020AbgDIP3v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2020 11:29:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586446191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHR+7wyWWQMKIj4iUOLklaqH1aeuxWR6fSfkpRk+srU=;
        b=c1Q/Eq2xBFU0kuAZ8qu8R++TsNaPfX0i273oYuNhQhnz60O/6Ogz+kqCn1WFx0DfNk6ABQ
        WV6S51kP6HseTPrz4MD1dUWAujhvKuAlu78QkWTTehESI6c01DxTKJbiVqfQn6ZR/by5+2
        u7RdqkK+jYEhPDxAhUrEaSexIOhJ+QU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-rA33jaIwMYiXjkqrHk8zvA-1; Thu, 09 Apr 2020 11:29:49 -0400
X-MC-Unique: rA33jaIwMYiXjkqrHk8zvA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 490B5107ACCC;
        Thu,  9 Apr 2020 15:29:48 +0000 (UTC)
Received: from [10.10.117.7] (ovpn-117-7.rdu2.redhat.com [10.10.117.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4ACB272CC;
        Thu,  9 Apr 2020 15:29:47 +0000 (UTC)
Subject: Re: [PATCH] target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
Cc:     martin.petersen@oracle.com
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5E8F3F6B.3020408@redhat.com>
Date:   Thu, 9 Apr 2020 10:29:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/09/2020 05:10 AM, Bodo Stroesser wrote:
> In case command ring buffer becomes inconsistent, tcmu
> sets device flag TCMU_DEV_BIT_BROKEN.
> If the bit is set, tcmu rejects new commands from lio core
> with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer
> processes completions from the ring.
> The reset_ring attribute can be used to completely clean up
> the command ring, so after reset_ring the ring no longer is
> inconsistent.
> 
> Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN
> to allow normal processing.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_user.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 0b9dfa6b17bc..f769bb1e3735 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2073,6 +2073,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  	mb->cmd_tail = 0;
>  	mb->cmd_head = 0;
>  	tcmu_flush_dcache_range(mb, sizeof(*mb));
> +	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
>  
>  	del_timer(&udev->cmd_timer);
>  
> 

Acked-by: Mike Christie <mchristi@redhat.com>

