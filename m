Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CEAC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 08:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbiEaInZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 04:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240926AbiEaInW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 04:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49771712D4
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653986598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fPaBZDsV84kO0IEmLkMM+G7p0afLOtSjYZX9TssTp0=;
        b=KD2GEueMmD56jLsUlq+hXVpsGyTJKUavvPSr58Ip2Gn+frPlVKJ80idEnwFyF0umFIbjGF
        IxA38dqYg7KB24eEtgHcmyOM0sUYt8DJoQTi9ME6AsHvB6W7hxJhad/cblWdEcB6azJFDe
        GX9BraDjSAk2QBrYKQ+czESoXVcVggM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-490-XELSI_YDON6ymilGZE4qxA-1; Tue, 31 May 2022 04:43:12 -0400
X-MC-Unique: XELSI_YDON6ymilGZE4qxA-1
Received: by mail-wr1-f72.google.com with SMTP id c11-20020adffb4b000000b0020ff998391dso1885589wrs.8
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:43:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9fPaBZDsV84kO0IEmLkMM+G7p0afLOtSjYZX9TssTp0=;
        b=Y7VYxqf0EBJqwbUkNC0ZyGA8Xl3adOz0szQTi5gY3wy+qjqpu1sBXNTbIwIcRYyAYc
         eVJZ25IHLApsIBhvbhlVfvVxPYEGsKGYqSXxGjD4yJkOe6OQQknxpqbhdAn3/coJen3L
         VqNCJjbJ0h/a3lycuLF6b1dRhH8olc9hDMjxcu+dLbzhBxUFQzilyUkO2O6acs/qT5Z9
         Nfe/xHXtWDi4K0czY9UUC6efZ4pBk9IzUA7hMNWKRJf7VPWRPai70SqnLyoZjRG4q7MN
         8uuWB1TJ/PWwecJKzcc2bHZoEHKEuIFaEAm+La2+MzQLsG8Llr14gqvQ+szF45BqJq5g
         z+Xg==
X-Gm-Message-State: AOAM531zH4qJ22M2SmCAfNLuw0G1GDCrBJLz4ngtYSY+dswQNoa17S5l
        +h975NQfDwlTjadm5oLEvXTQLAPVXkaicDnpw/VJ1O8OO5lA04/aBiQ19QisrHcnSMJWi/l7NAE
        94cR+oHL7nw+yiLh2JXQhwQ==
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr22494782wms.3.1653986591069;
        Tue, 31 May 2022 01:43:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzfshR+I/hDPQmtoECOmlS+FrzrfxKwqTinLxQRa/ZAYNB2+FaUFLoMjB75XtGMJIFbhKjijA==
X-Received: by 2002:a05:600c:3b05:b0:397:54ce:896 with SMTP id m5-20020a05600c3b0500b0039754ce0896mr22494767wms.3.1653986590859;
        Tue, 31 May 2022 01:43:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b0039c17452732sm1554367wmq.19.2022.05.31.01.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 01:43:10 -0700 (PDT)
Message-ID: <e530dc2021d43a29b64f985d7365319eab0d5595.camel@redhat.com>
Subject: Re: [PATCH 1/6] netlink: fix missing destruction of rhash table in
 error case
From:   Paolo Abeni <pabeni@redhat.com>
To:     Chengguang Xu <cgxu519@mykernel.net>, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Date:   Tue, 31 May 2022 10:43:09 +0200
In-Reply-To: <20220529153456.4183738-2-cgxu519@mykernel.net>
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
         <20220529153456.4183738-2-cgxu519@mykernel.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Sun, 2022-05-29 at 23:34 +0800, Chengguang Xu wrote:
> Fix missing destruction(when '(--i) == 0') for error case in
> netlink_proto_init().
> 
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  net/netlink/af_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index 0cd91f813a3b..bd0b090a378b 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2887,7 +2887,7 @@ static int __init netlink_proto_init(void)
>  	for (i = 0; i < MAX_LINKS; i++) {
>  		if (rhashtable_init(&nl_table[i].hash,
>  				    &netlink_rhashtable_params) < 0) {
> -			while (--i > 0)
> +			while (--i >= 0)
>  				rhashtable_destroy(&nl_table[i].hash);
>  			kfree(nl_table);
>  			goto panic;

The patch looks correct to me, but it looks like each patch in this
series is targeting a different tree. I suggest to re-send, splitting
the series into individual patches, and sending each of them to the
appropriate tree. You can retain Dan's Review tag.

Thanks,

Paolo

