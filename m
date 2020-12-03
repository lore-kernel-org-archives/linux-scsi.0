Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6687C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 09:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6BA20872
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 09:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388639AbgLCJlP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 04:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387782AbgLCJlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 04:41:15 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A34C7C061A4D;
        Thu,  3 Dec 2020 01:40:34 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id x16so2461983ejj.7;
        Thu, 03 Dec 2020 01:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VnJR4zvxLaYxaLIi7m7JIB9O5uK8FoHDelrZFzVzmI0=;
        b=Eu54DIQUEZly4iruNoc5w4/RdW3QRPdwSP9inV/oTmJGr41KwLQXfr4MRUgaNV+4Me
         nSAxINR9fWr/k+VtUtPeKbLbBmFIeFXD5I5qdBvSQGqNa9bJ1UaFvvLEMGkQJgjo2Q9a
         uXVjhYpC8krcRlobmeyoMBK5r5i3Ep5z/ovF6qkoi8p62dpiKD6TCVuvBzi8jfl3vW7p
         d1ImNLJf/Q/JZd5feVZ+jq+QVj8AMLqw+4Neqk/qI7qNLzleFfq1SKM9470MmvsX8+cx
         Nrb+bnFHULTqfjsh8Mn0narznctkjjIspcDD+2OQic6inKsBmM1q3Kd5ofHx2yiXoSTY
         5D/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VnJR4zvxLaYxaLIi7m7JIB9O5uK8FoHDelrZFzVzmI0=;
        b=NIlGxl6S+s+6teucROobbcqxdOvnzenab6k7rl3XYE/FL+e6bZE8i+1RL7Eo8OcEPm
         DccOJ7z5qE6YvVn+Q9H3jHJJuO5PTI48ccJQVFdrBkZppPmd3jWTymiJIAERbcduv/fF
         +YuN33nm0euFDxi0M1S1M8vZiS5WQhMZOZLepUSll77ydZxE8TqfQ0JYGwIKMIU20vUY
         q8tdmNEeRuH97GkB/ozE2edQaoIJcUSL6y6W7EzgTO4KLkaPgEOK0VGiJtiVsrgnUZ9P
         n+EFSr27ChHwmfnqK/XvV+3ZwsQgiEFOz7MPVEJyIkOlElPsQ8SBjJMmpdbSfiSzhx5K
         qKpg==
X-Gm-Message-State: AOAM531WmlbiS7PL3QdLkYpXcRd+7I1qZcHG2Q/uF09BhjJrBaWRmBRc
        NA581lLbrXfEdrmHUvOHj/M=
X-Google-Smtp-Source: ABdhPJwGJ9pPFbYF4BWoB553PT4T4LgJH8IHJmJUErAxvv8iBybvVyQNbVF4VCLrXzoCsYxN0GTVEQ==
X-Received: by 2002:a17:906:add7:: with SMTP id lb23mr1831288ejb.352.1606988433419;
        Thu, 03 Dec 2020 01:40:33 -0800 (PST)
Received: from ubuntu-laptop ([2a01:598:b905:79de:6c3d:3b27:f281:55d5])
        by smtp.googlemail.com with ESMTPSA id ci20sm427075ejc.26.2020.12.03.01.40.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Dec 2020 01:40:32 -0800 (PST)
Message-ID: <2dafb87ff450776c0406311bb7e235e9816f6ecf.camel@gmail.com>
Subject: Re: [PATCH 2/3] scsi: ufs: Keep device power on only
 fWriteBoosterBufferFlushDuringHibernate == 1
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Thu, 03 Dec 2020 10:40:30 +0100
In-Reply-To: <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201130181143.5739-1-huobean@gmail.com>
         <20201130181143.5739-3-huobean@gmail.com>
         <BY5PR04MB6599826730BD3FB0E547E60587F30@BY5PR04MB6599.namprd04.prod.outlook.com>
         <DM6PR04MB6575B7ECCEA7335B2CFC2AC4FCF20@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-03 at 07:27 +0000, Avri Altman wrote:
> > 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Keep device power mode as active power mode and VCC supply only if
> > fWriteBoosterBufferFlushDuringHibernate setting 1 is successful.

Hi Avri
Thanks so much taking time reiew.

> Why would it fail?

During the reliability testing in harsh environments, such as:
EMS testing, in the high/low-temperature environment. The system would
reboot itself, there will be programming failure very likely.
If we assume failure will never hit, why we capture its result
following with dev_err(). If you keep using your phone in a harsh
environment, you will see this print message.

Of course, in a normal environment, the chance of failure likes you to
win a lottery, but the possibility still exists.

  
> Since UFSHCD_CAP_WB_EN is toggled off on ufshcd_wb_probe If the
> device doesn't support wb,
> The check ufshcd_is_wb_allowed should suffice, isn't it?
> 

No, UFSHCD_CAP_WB_EN only tells us if the platform supports WB,
doesn't tell us fWriteBoosterBufferFlushDuringHibernate status.

Thanks,
Bean


