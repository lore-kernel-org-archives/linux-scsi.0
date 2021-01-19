Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEFCC169C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C196422D2A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbhASQgJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 11:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730158AbhASQc3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:32:29 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB9DC061757;
        Tue, 19 Jan 2021 08:31:49 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d22so11260190edy.1;
        Tue, 19 Jan 2021 08:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C+NDxqcVq/gZ4wgLmYCGjXjhQkRMK4EGpwM/xyan4pU=;
        b=IXa3p/V0Pkgy7Fe4C9/I4iR2+SgQ/8eNXSJ/7q50BxaE2M5vfhY/0ZrSSlWPOOZy1b
         Nm+bBTdfXzvS5MlYpL3qgp6bv5vel8al9W7CU3hSIdOlbfaWlgZR3M0nNTAqVtEv4v5o
         TlHIfnFhQ6vB8dbyALLF10syipIIpfd654oY2nvNoLvJNq6UcUZPggoM2aluiU2i6vWX
         j5EvwJfTRzcsAG5vBlRPbSwpTOSswqUz6TN06leM6rpxLEOGzGdJEf5JFKsR/lhTK0BN
         +Xd9tQdDb6HSsYKeMKeUO+lyKEcZFmE1zzaz6KBkRbUYTRtHvM/kkYkkJuigdBXAL3c9
         syfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C+NDxqcVq/gZ4wgLmYCGjXjhQkRMK4EGpwM/xyan4pU=;
        b=SQ1/iDWka0wL+sQ2nWqfoDccKNKBVhB9qkU20LVQPLFqt7qLexR8FZ8wC8n5JTpQbB
         sqUACb7mo/fwBLpSDYXg9ArFtLZkI20ctCMexVCozzibaC3z/AeV7HM8CcE7yMc9+HDM
         OcBYFXd7jRuJ0cRResh/zq8IuO/ziCoohuoETo60ahfC7UDbJG2xvj51wlYsDmssAN6m
         E3EPtHnkH0sA1kf1asr/CtIhW1+2auvIQ4CQ0vmdIDITSZcE9hIFO1f+PydWBCGzrMvW
         CuIIxw+orHd8pvB/CGpwWEe14uoyhrNJ6+lNh1f5i5IX/iZw9Ajbmqwyy112OR7H1Ley
         LDQA==
X-Gm-Message-State: AOAM530YGdJPvrzzEbTxSVa1v8JtaTC5nyN8DKFcSpE7bd1kEnQoEp0m
        CoaxXWBqhcyIg5zCP4+jJzI=
X-Google-Smtp-Source: ABdhPJyM6KC3U2jokYgi070SBgfotc8Gz+xI1KCaXMZBzwekdDp/4y3A11D/gRr1ImosHL7SYKfGSg==
X-Received: by 2002:a50:8004:: with SMTP id 4mr4041262eda.155.1611073908036;
        Tue, 19 Jan 2021 08:31:48 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id h12sm11297196ejx.81.2021.01.19.08.31.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Jan 2021 08:31:47 -0800 (PST)
Message-ID: <0fb16957375cc5916b61aa6ea2c13c64455f1d35.camel@gmail.com>
Subject: Re: [PATCH v6 1/6] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
From:   Bean Huo <huobean@gmail.com>
To:     Adrian Hunter <adrian.hunter@intel.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 19 Jan 2021 17:31:45 +0100
In-Reply-To: <9ad2cf1a-68df-47ef-9fe7-01954d2d6181@intel.com>
References: <20210118201039.2398-1-huobean@gmail.com>
         <20210118201039.2398-2-huobean@gmail.com>
         <0a9971aa-e508-2aaa-1379-fb898471a252@intel.com>
         <fabf0e83387f6155efea521a15b00bb1225d35a4.camel@gmail.com>
         <9ad2cf1a-68df-47ef-9fe7-01954d2d6181@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-19 at 12:00 +0200, Adrian Hunter wrote:
> > > Is it so, that after a full reset, WB is always enabled again? 
> > > Is
> > > that
> > > intended?
> > 
> > Hello Adrian
> > Good questions. yes, after a full reset, the UFS device side by
> > default
> > is wb disabled,  then WB will be always enabled agaion in
> > ufshcd_wb_config(hba). but, for the platform which
> > supports UFSHCD_CAP_CLK_SCALING, wb will be disabled again while
> > clk
> > scaling down and enabled while clk scaling up.
> > 
> > Regarding the last question, I think OEM wants to do that. maybe
> > they
> > suppose there will be a lot of writing after reset?? From the UFS
> > device's point of view, the control of WB is up to the user.
> 
> If it is by design enabled after reset, then perhaps it should be
> mentioned
> in the sysfs documentation.

ok, will add it in the next version.

thanks,
Bean

