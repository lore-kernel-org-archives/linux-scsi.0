Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A82C2BBCD
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 22:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37EC723A56
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 22:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732294AbgLQW62 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 17:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbgLQW62 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 17:58:28 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4933C061794;
        Thu, 17 Dec 2020 14:57:47 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id g24so392870edw.9;
        Thu, 17 Dec 2020 14:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UrAnooqpz/XiDtTxpipQwqwJFdvUo8ZMv3C6cGNI3ZA=;
        b=logRTKSZ/hzvgSk7JdSe4LJcP0fB++cmt5mqedJAqkraDfhuyoPIZW5OkW8/h4XRb7
         lDv5kz2zu+LgDzHLLW3zme+sZoxsj8Sw9CvtE8KVXJU6p6e3VRtQNtP//U9qX4hrx7Y4
         vOLgLfYeeqcqp1b1f+IkeSAoCg35MvNpYHcxtY37ezvBt+JSCyG+kYzRqV/GH6oW5bDF
         xDoRPxdGQxsZQi/bTEPnvz9d6h/tb0R+hDI7xlNv9EqJlGrDnYMkRY+6RyGoobAdc3cu
         OEhMAgWNxcXd9ZdZALAXoAKXU1DaFZpYt7nBI+4nS/dUVXvADxm+wPkhjlD9cJUIuagD
         oYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UrAnooqpz/XiDtTxpipQwqwJFdvUo8ZMv3C6cGNI3ZA=;
        b=c+3I+UmF36Fg2JYUBFGopGKtLREHz6NriKxsOGCDgT16vSwnThi23umtpyMqzh1VQj
         lymO4v8TPgLC3Meoripeszv0sljwzKgjirJC/Bvw+wOxyMLieZ0SXdNp1Nn0JlP1kuEh
         HDs5tyWN4B2VfJBfZcl3D+LGeng/fA4aiDyjmK0sxLTDnkzUM/l6rgfdOandRkQNRS7/
         3r5r6dqrdCMu5KvDrSrgistR8Lmq+3Ce8KpKN23zYvkwZ/4834LclIrxx+XL/OvxQt8f
         izY2gl3uJWw7a5np2oz82l8RuJfMRQQm8S6Rqb2t0gTTfLpN2AAXoTojEyR/VenEiIXf
         bDLA==
X-Gm-Message-State: AOAM533rrWhXq977fS82Pfos9utB1Ob1PUH3BnU9q4wauo4ynZKC+G9+
        1B4W31BjyuAFCMQkE4jXwSE=
X-Google-Smtp-Source: ABdhPJxCYj6F5aGktG6RiD8QJxhSwnqDUJeTo47Q4OqGsWS66fVzRFgFMdRnbgXRYd2jcgJ+l84PZQ==
X-Received: by 2002:a50:e80c:: with SMTP id e12mr1643558edn.288.1608245864965;
        Thu, 17 Dec 2020 14:57:44 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id u16sm25026385eds.10.2020.12.17.14.57.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Dec 2020 14:57:44 -0800 (PST)
Message-ID: <fbb752c30a921f251b7df130c942e20548ca0997.camel@gmail.com>
Subject: Re: [PATCH V2] scsi: ufs-debugfs: Add error counters
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Date:   Thu, 17 Dec 2020 23:57:43 +0100
In-Reply-To: <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
References: <20201216185145.25800-1-adrian.hunter@intel.com>
         <920b01c29525ff1cf894a2cf9c809750533ddc13.camel@gmail.com>
         <750889b4-19b7-3c0b-c614-a8dddc2dcab2@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-17 at 11:49 +0200, Adrian Hunter wrote:
> > 
> > The purpose of patch is acceptable, but I don't know why you choose
> > using ufshcd_core_* here. 
> 
> Do you mean you would like a different function name?  'ufshcd_init'
> is used
> already.  The module is called ufshcd-core, so ufshcd_core_* seems
> appropriate.
> 
> > Also. I don't know if module_init()  is a proper way here.
> 
> Can you be more specific?  It is normal to do module initialization
> in
> module_init().

Hi Adrian
My concern that ufs_debugfs_init() is called in module_init(), but your
another debugfs initialization function ufs_debugfs_hba_init(hba)
called in the UFS host probe path. 

If these two (module_init() and module_platform_driver())
initializaiton sequence always as your expectation: ufs_debugfs_init()-
->ufs_debugfs_hba_init(), that is fine, otherwise, it is better just
group them, make it simpler.


Thanks,
Bean
 

