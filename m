Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B94C4332F
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Mar 2022 12:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244999AbiCTMFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Mar 2022 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiCTMFi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Mar 2022 08:05:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3D34E37010
        for <linux-scsi@vger.kernel.org>; Sun, 20 Mar 2022 05:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647777854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9OfrrvJ+JSNxjBs8qAJPKPxz/pmLtZ2ITjpHEArPw5E=;
        b=RNM2hDPx/BuydcEGMaDPuIaI2BD33giuOYfEV6AIYnkPJcwIUzDFtdoLqcM196GMiiYXie
        fsR6ecLotW6stPnE40yLWRCsxB7cM4329NQ3ELfBZ8aegmWwpK/MHPjtLxIoZyzQfrKLEv
        OVS4dIDn/qxWT1EUxoErDFf8VqEPKc0=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-hYK50ARuPhu6U1qGyRPsVA-1; Sun, 20 Mar 2022 08:04:12 -0400
X-MC-Unique: hYK50ARuPhu6U1qGyRPsVA-1
Received: by mail-ej1-f70.google.com with SMTP id hy26-20020a1709068a7a00b006dfa034862cso3726242ejc.23
        for <linux-scsi@vger.kernel.org>; Sun, 20 Mar 2022 05:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OfrrvJ+JSNxjBs8qAJPKPxz/pmLtZ2ITjpHEArPw5E=;
        b=WEc3NncbfmktEGjjmQ7pCX1esaKo0kaZtxptXd30S1s6nnQ4zievkn+0/+98GyaM23
         lE2QnZMm5rzXXDwq7ArgzSFRbhMsi6/fPZn1NYrIOKGs/z6xY/KL5CHGKCKSA05+I3YY
         W3vAzcu7bFFH6kON2KIdpQZolVJqBX1jp7/GIoRphoamZlaV+tLEIfSNEqEH1ifskV6T
         2iFROLhIW3NxGw67xBdRNKxcaw/CD16DT46r8nlduRYPszeFztGePsQ8iJbp2ENyO8Gw
         F2pNIAyFoSf4fJv9deg89/jaQRn7gaOBON/+GkKXFxcoghbeQDg9880E1AUxrPbNu1Tt
         tmIw==
X-Gm-Message-State: AOAM532ofd8BDXw/bDeOQDifqejB90t2oPicwyL/HSnFgSYuHTAwc/tV
        IuRCMIA6WYtA4N3Y6Sf5ES5uLgVbeF+QtDN69wGv8K6ajdFubiAL78bbpB6w5w8ZNITDeHp6ji/
        q7dUcfyysutDUoKFgDEwZjA==
X-Received: by 2002:a17:907:7e88:b0:6db:ad88:2294 with SMTP id qb8-20020a1709077e8800b006dbad882294mr16017821ejc.371.1647777851519;
        Sun, 20 Mar 2022 05:04:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybuaY3RTwLFhNmn8ph3qfEMlXOeFvtOmTr+FUYne4h/XgSMGx9RwM3ZmeWDHdWHYLvNIiqSA==
X-Received: by 2002:a17:907:7e88:b0:6db:ad88:2294 with SMTP id qb8-20020a1709077e8800b006dbad882294mr16017754ejc.371.1647777851178;
        Sun, 20 Mar 2022 05:04:11 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id hb6-20020a170907160600b006dff6a979fdsm856220ejc.51.2022.03.20.05.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 05:04:10 -0700 (PDT)
Date:   Sun, 20 Mar 2022 08:04:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Amit Shah <amit@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Joachim Fritschi <jfritschi@freenet.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-usb@vger.kernel.org, nouveau@lists.freedesktop.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 1/9] virtio_blk: eliminate anonymous module_init &
 module_exit
Message-ID: <20220320080242-mutt-send-email-mst@kernel.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
 <20220316192010.19001-2-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316192010.19001-2-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 16, 2022 at 12:20:02PM -0700, Randy Dunlap wrote:
> Eliminate anonymous module_init() and module_exit(), which can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> Example 1: (System.map)
>  ffffffff832fc78c t init
>  ffffffff832fc79e t init
>  ffffffff832fc8f8 t init
> 
> Example 2: (initcall_debug log)
>  calling  init+0x0/0x12 @ 1
>  initcall init+0x0/0x12 returned 0 after 15 usecs
>  calling  init+0x0/0x60 @ 1
>  initcall init+0x0/0x60 returned 0 after 2 usecs
>  calling  init+0x0/0x9a @ 1
>  initcall init+0x0/0x9a returned 0 after 74 usecs
> 
> Fixes: e467cde23818 ("Block driver using virtio.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org


If this is done tree-wide, it's ok to do it for virtio too.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

No real opinion on whether it's a good idea.

> ---
>  drivers/block/virtio_blk.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- lnx-517-rc8.orig/drivers/block/virtio_blk.c
> +++ lnx-517-rc8/drivers/block/virtio_blk.c
> @@ -1058,7 +1058,7 @@ static struct virtio_driver virtio_blk =
>  #endif
>  };
>  
> -static int __init init(void)
> +static int __init virtio_blk_init(void)
>  {
>  	int error;
>  
> @@ -1084,14 +1084,14 @@ out_destroy_workqueue:
>  	return error;
>  }
>  
> -static void __exit fini(void)
> +static void __exit virtio_blk_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_blk);
>  	unregister_blkdev(major, "virtblk");
>  	destroy_workqueue(virtblk_wq);
>  }
> -module_init(init);
> -module_exit(fini);
> +module_init(virtio_blk_init);
> +module_exit(virtio_blk_fini);
>  
>  MODULE_DEVICE_TABLE(virtio, id_table);
>  MODULE_DESCRIPTION("Virtio block driver");

