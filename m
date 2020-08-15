Return-Path: <SRS0=WC2B=BZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C18C433E5
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Aug 2020 22:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6AD20639
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Aug 2020 22:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQ+fWqby"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgHOWC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 Aug 2020 18:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbgHOVvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Aug 2020 17:51:24 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088F6C08E81D;
        Sat, 15 Aug 2020 03:37:40 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id i26so8661301edv.4;
        Sat, 15 Aug 2020 03:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1LVSuI1NRkF6KqZNtOw+yQ3crRfQObWywAHMmVLnk0=;
        b=ZQ+fWqby9a1jtQGefwywyLe6v64QaA7Bdf4daPmvgWiGIbLp4eAxPcMCGyPipoBSvi
         98ARS860VviTcWZfz1fuvKORtuKGa7Trz86INHn6BwleJla9nBjquiag8JY6Q8w78RPK
         mVBhNeT9fEN1B791N8ZajEOvHDvvbdmrCA0qHxRBEaSpG7CH84FatLNY9iWd0e3qKvVp
         vhTxji+jL1iW2BhkpIcJn1M7Xwdvcu8JGrjsbv+9b+hvuTtJ0OMMU48zjsGEHdwUDUy7
         LXPp5ma4cqJclP4ULeVjuX7X+7/5jEt29i/sqxWtBjVrWGo+OZGpTV2hwkX3ucxPiHIR
         Pdlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1LVSuI1NRkF6KqZNtOw+yQ3crRfQObWywAHMmVLnk0=;
        b=GrfZaAf0yiyd/5I8xv/848CFIlHAGwrnUKMaoN0uns3qrw28VJgIx2ilEi2H2TRUs0
         ROMP5o9lX7zeUwOd03j7V3tnkOr6xsH7h1SkKLUqEm2FYfw6tyNUN9FFtNg2IN5CpDhj
         +SRSh8v4PfmeKbu9J7+efPpkW69tWZt+XMwe/U26oUE8ZJVg1wU1+IT+pV09CnIl9+2K
         FHoX6pV8tEU/7Y27TN2RMuCnpIxzzrssp3d7xKHo2i6jBV/Cr+RR+PdI/Nr1GhJxkN5R
         U+QlHFRDX0ebxwuJrcACbRLC/CcY5omiRE5BOkPa4e38oMUtwCEnrUs8o7gQnT26AHre
         5q5Q==
X-Gm-Message-State: AOAM531tTpIdGGaC/X+50DUw7MKqXamBdW7looxZXywsb6ylE2oCCDuc
        qSDFD5OM1dWCVhogn/lHgY8=
X-Google-Smtp-Source: ABdhPJyIebA9WqJ8aRwewHzlOukQLt+yRO56TMQId/Kwsz908PUmzImqZLLYwU6/QpBnZ3Al5OHy/A==
X-Received: by 2002:a50:fc0a:: with SMTP id i10mr6465263edr.5.1597487859618;
        Sat, 15 Aug 2020 03:37:39 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bee32.dynamic.kabel-deutschland.de. [95.91.238.50])
        by smtp.googlemail.com with ESMTPSA id g11sm8288715edv.95.2020.08.15.03.37.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 15 Aug 2020 03:37:39 -0700 (PDT)
Message-ID: <b1081d95d115848d657bd48ca05f27ab0db01c7e.camel@gmail.com>
Subject: Re: [PATCH v3 1/2] scsi: ufs: change ufshcd_comp_devman_upiu() to
 ufshcd_compose_devman_upiu()
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 15 Aug 2020 12:37:37 +0200
In-Reply-To: <ca175083f887ab0204f63002b5e2c4c7@codeaurora.org>
References: <20200814095034.20709-1-huobean@gmail.com>
         <20200814095034.20709-2-huobean@gmail.com>
         <ca175083f887ab0204f63002b5e2c4c7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2020-08-15 at 09:52 +0800, Can Guo wrote:
> Hi Bean,
> 
> On 2020-08-14 17:50, Bean Huo wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > ufshcd_comp_devman_upiu() alwasy make me confuse that it is a
> > request
> > completion calling function. Change it to
> > ufshcd_compose_devman_upiu().
> > 
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > Acked-by: Avri Altman <avri.altman@wdc.com>
> 
> I gave my reviewed by tag in previous version, you missed it. Here it
> is
> 
> Reviewed-by: Can Guo <cang@codeaurora.org>

Can

nice, thanks.

Bean

