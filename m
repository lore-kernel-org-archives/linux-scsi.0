Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A830C388D4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B7D922D70
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpiiAAVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgHFJxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 05:53:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgHFJxb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 05:53:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE48EC061757;
        Thu,  6 Aug 2020 02:52:41 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id qc22so34819056ejb.4;
        Thu, 06 Aug 2020 02:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GFHE6B9er+V6kO04ZtSKBTS+EAvO4hcEEjI2b6b0D+I=;
        b=DpiiAAVKzREL5OIZYC1Tfs4DJZFD6nzKoG13wu4Nt0dWX+8kk4k3cZevbPBL64y8Vw
         lrhZXXyNy+HskoRhtaKDyhXOas+wvBInhS/fbae17b1eLLawO4fWquqnWAGatKARIiPP
         Y6V+t6xvkF6YR15kqF3ZdrLoLW6S+J8x4ZINWIvmyzefelkBN15pl+wMFEvR5SidrFbO
         SbmmlBSenVaOSkm8k2M5HxJAGdICqM8Zwd9PZQRxw+j57hvz9Hv6BHNv17vvTiY0NVW+
         Ggo1OlWDcX4kuxrlL/5/oD+FoM94SQpar46jbmQOtgjFnjPb/GMuKXEZATILtZwLoTK6
         vXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GFHE6B9er+V6kO04ZtSKBTS+EAvO4hcEEjI2b6b0D+I=;
        b=QllogKA4sD5RwdaBcf8+4FccCGxIAXdNBNl5HYTAWUH6fy/nXqb8LynPuJe0nAg1yy
         WtYfWpgQB62BpN+ct7JL02UOgnzJ5C4dTrHVX92xJSGLBZsIh1OfLlNEW+BMN8Cqa+T+
         YSn+/D6yk2enL9Exla9RZdQbFr+e/mE3yBsWgpMxC+8cE/ARDG4jjiaSa3W/9cvTA5ar
         OwcDV+8v3AKmSmroq27YHKVj7M81Qxc6jUeWSZQ1weq27mKAWoa07gu3mgM0QITszQSA
         Fvrm+OIRl1LfWabypev44vMRQ2UObmKYpxxC0jFJ9c2qkYsFpEnGYPU0i8lQSrT5/YZh
         6RPA==
X-Gm-Message-State: AOAM533Rw7Nx5itZD7NrxKZnH/zOJewk0k+FFjIgjDc4fcYaWEP1Mvy3
        iVty1b+sFaZeuV8LtuEL0q0=
X-Google-Smtp-Source: ABdhPJywEah00tll5sMrzN/RAV2Vc8AayWtESH8W9br3szTn+TauF7Rm/eXWZ1VoY4uwqq5LRMzycQ==
X-Received: by 2002:a17:906:e46:: with SMTP id q6mr3486285eji.234.1596707560708;
        Thu, 06 Aug 2020 02:52:40 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b906:f0c9:15b9:533b:62ba:b5b3])
        by smtp.googlemail.com with ESMTPSA id g9sm3393498ejf.101.2020.08.06.02.52.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 02:52:39 -0700 (PDT)
Message-ID: <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
Subject: Re: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
From:   Bean Huo <huobean@gmail.com>
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Date:   Thu, 06 Aug 2020 11:52:32 +0200
In-Reply-To: <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
References: <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
         <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
Content-Type: text/plain
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri
what is your plan for this series patchset?

Bean

