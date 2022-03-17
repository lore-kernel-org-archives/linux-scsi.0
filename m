Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F226C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 16:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiCQQM6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbiCQQM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 12:12:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB4214F94
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 09:11:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so5923073pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 09:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=wywg4x91ht1wDsZE8LDgwKs/937jDdBiI3aoJq8Icig=;
        b=EcRFu47wdTKbqMSAq17bN6l3fW68je9I7sz6dNGS5tKD2WRbtx22XzizUZtR0qkyAQ
         QWP1OHwCDN5A0Nw0t3Q7qmd76Q7jNga+edrTyslT2xibkPds1nD37wWbuAnO8SwFuhrO
         gsVcYZtwJfnoFR7QpeZ53g8ha9BP7vQeAQagIeRfmuB8NZSh871Oy/O22T8GKZQsso7+
         GAqKZ5LuYXbJaI8VOrspWlTrq9NYT2zp8TS48/UvpIibmW0S8anvsp+TLqAO1q5KW6Bh
         lxRLQvTEz/3EMFmPsbBbDBLIo1E7GTCaZssTwBenfG227MP1XIuXr1IbCZbQ1ApUnFqh
         aueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=wywg4x91ht1wDsZE8LDgwKs/937jDdBiI3aoJq8Icig=;
        b=Y7zoj32oMUmC1+HCnTwQ8DKjAT/8fBmD5t9MIgVNuhYadWA6HCeOM7FAq72gq5SkiZ
         7/WNcPKiMwn/AnTlDdEISPn1lSmGHpBp0G1+B+Jf4Oyd/OaUWAFn4pvLbLtvZ0lM+Jvn
         91E2iMUMn03zSR4D0/GB3ZOi8hJackjk+571xnLGh2wW1e1NaBV+YrNDq/OBmnHc+Nwc
         5olHplSW01VmNZJYe3vGVfnS0iGfiTSXtjz1RK/7tcX4UwE9WopELYTO53wRJOADdxsY
         hHu686NxI0tplnk7lZ4NEtDO3lHG45B69ly8S6nL0I9tJlZUhRVYZbm5TtjjfXuwOAcg
         4/qQ==
X-Gm-Message-State: AOAM5326BbTITu8dkoawrSebPgGRytOJaBl7huNacaPZgio7Npwk8Nz3
        emnhvPWwPpZSieAKIKFQg54otQ==
X-Google-Smtp-Source: ABdhPJzujChC6izQDJEHNAPYk2A2y6Fs/ty0Hxcz37xAtsWb7B2FaolAnh/R0gH50blU6B7YVSPE4w==
X-Received: by 2002:a17:902:7613:b0:151:6e1c:c49c with SMTP id k19-20020a170902761300b001516e1cc49cmr5906213pll.109.1647533499805;
        Thu, 17 Mar 2022 09:11:39 -0700 (PDT)
Received: from [127.0.1.1] ([2620:10d:c090:400::5:d2fd])
        by smtp.gmail.com with ESMTPSA id q10-20020a056a00088a00b004f7ceff389esm7702590pfj.152.2022.03.17.09.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 09:11:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Igor Kotrasinski <i.kotrasinsk@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Karol Herbst <karolherbst@gmail.com>,
        Eli Cohen <eli@mellanox.com>,
        Pekka Paalanen <ppaalanen@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, x86@kernel.org,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Amit Shah <amit@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-block@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        linux-usb@vger.kernel.org, coreteam@netfilter.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        nouveau@lists.freedesktop.org, Jason Wang <jasowang@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        virtualization@lists.linux-foundation.org,
        Leon Romanovsky <leon@kernel.org>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-rdma@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Fritschi <jfritschi@freenet.de>
In-Reply-To: <20220316192010.19001-1-rdunlap@infradead.org>
References: <20220316192010.19001-1-rdunlap@infradead.org>
Subject: Re: (subset) [PATCH 0/9] treewide: eliminate anonymous module_init & module_exit
Message-Id: <164753349550.89091.10994175450707575992.b4-ty@kernel.dk>
Date:   Thu, 17 Mar 2022 10:11:35 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 16 Mar 2022 12:20:01 -0700, Randy Dunlap wrote:
> There are a number of drivers that use "module_init(init)" and
> "module_exit(exit)", which are anonymous names and can lead to
> confusion or ambiguity when reading System.map, crashes/oops/bugs,
> or an initcall_debug log.
> 
> Give each of these init and exit functions unique driver-specific
> names to eliminate the anonymous names.
> 
> [...]

Applied, thanks!

[1/9] virtio_blk: eliminate anonymous module_init & module_exit
      commit: bcfe9b6cbb4438b8c1cc4bd475221652c8f9301b

Best regards,
-- 
Jens Axboe


