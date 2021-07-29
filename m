Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4ACC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C28C61054
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:05:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhG2IFJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbhG2IEc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2021 04:04:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E92C061757
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:03:58 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id b128so3108619wmb.4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ORak2jPPspmIKNt/Iq+PZt7iiPn3UMvDGcZJaEhAWp8=;
        b=PKgigtTQWzq/FEMNIKVGlyWq0R7PhVAkfRQ0gQyun84YFGSkpTL85C9UTPIPkulkG2
         AZmQpG0xmUzrfYBC8xGDx6wKQ2KnskekCF6k91sTAndeAaU+vStkHgf9tQzI37EPSRU2
         D8XC42EwkoAwqdd9XwmqcKQ1y5fT0Mc/ldI5CSn/KDTjb2IfRFphe1JDstIVEoQk7ssY
         7VJ51HCIdgEPH63dNS4VefV3cHbNjBOGm33QYdu4QSaUnxiZJiWRuFWZY1KeLta0V/9N
         qABdpUG9WfuE+ObxqgVYfIIgPFgTz6lB58/+BJRYCdk3/bz7EgGx9lAAatbi2E6AzOnJ
         YJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ORak2jPPspmIKNt/Iq+PZt7iiPn3UMvDGcZJaEhAWp8=;
        b=c9tNRqW8AFZiFMlBV9/99+osDiJTnxG71KxAD2caSE91dmCwV0Hj7uBgd2BOU0wU+V
         jMQNKMqQzOhaAYoyyEPu7Iwd3+e3XB9ks3OHNNE33Lu8Y4IThqdjPNiy5ZFqb47/acIT
         4kukpAe0Di+wcafJdrvpaQS7IXHPax6y/Wvt0U0jcVH5MMxPvZ+5lZMXTGDbfikUAWPV
         rwsm9RqUr/leoh7URktk2ca19MpTGw8LIurRdQHLDLHbKU89eKuWrHBOGgc/U42yZSQf
         8r0yxW1zJwtkY+XJKXL0hOKz5sjGJfgN8rh7fVZFDh/dRi+ugTB58AyivXGKisI63pM1
         EqnQ==
X-Gm-Message-State: AOAM532W6Ju7v1ZuN4inQsWauqQGsEnl3+BIuVUW9waVFY3RCWH6CkcQ
        +BYoBfxXP+hZZzro6wIS+WU=
X-Google-Smtp-Source: ABdhPJyy03+UyykHKpnJVeVL8u+E5UKvMM3qRCrqm6olwug9VtBJpmhwMcatzWqfa79HYkMVKT1jcQ==
X-Received: by 2002:a1c:9814:: with SMTP id a20mr3334433wme.158.1627545836891;
        Thu, 29 Jul 2021 01:03:56 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id b14sm2608592wrm.43.2021.07.29.01.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 01:03:56 -0700 (PDT)
Message-ID: <d15377870057a6ff956a18910b2d0695b145d889.camel@gmail.com>
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request
 List Completion Notification Register"
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date:   Thu, 29 Jul 2021 10:03:54 +0200
In-Reply-To: <20210722033439.26550-12-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-12-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Using the UTRLCNR register involves two MMIO accesses in the hot path
> while
> 
> using the doorbell register only involves a single MMIO access. Since
> MMIO
> 
> accesses take time, do not use the UTRLCNR register. The spinlock
> contention
> 
> on the SCSI host lock that is reintroduced by this patch will be
> addressed
> 
> by a later patch.
> 
> 
> 
> This reverts commit 6f7151729647e58ac7c522081255fd0c07b38105.

Bart, 
This commit is the key change in "Optimize host lock on TR send/compl
paths and utilize UTRLCNR"
https://patchwork.kernel.org/project/linux-scsi/cover/1621845419-14194-1-git-send-email-cang@codeaurora.org/.

How did you compare the performance gain/loss after reverting this
commit?

Kind regards,
Bean

