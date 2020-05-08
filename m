Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FBBC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19AF420A8B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 10:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvTMdDAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEHKPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 06:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgEHKPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 06:15:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809EBC05BD43;
        Fri,  8 May 2020 03:15:36 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id v12so1193800wrp.12;
        Fri, 08 May 2020 03:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZUm2suw4OY2BIRy5wpJmf520J8k3gbc0vjFtMWtuxfs=;
        b=MvTMdDAFxbDyvYVx5VRjIBxreQb8aX397RtlFK9VBWhc3dsdf4M5VtfX0zwqByeibt
         LhlYoRPrZohURqJM2+pS3Pdw35ZJVbvBxeceJ+CsoQevMU2k18DKhElK8YQhQT37A/2O
         AyEve/6VXlVyTbJ2OP3KIU6+KY0xeXg6pAQStisPhvFMVozbrJOCCgIrZGUoVbydvWc1
         3wHy/0JTmUo1Kdjr5nwTQZqLTpS3HkbWrBWQnOmSF3mKKqxtPKEH5Hz5l+6rKKMPAeta
         BPWgXvhCze/sa3PZDUXC0udj1ji7JH2oNxmLYiSiEhS6cv+rk48DyNOP9flwtzNXR3jJ
         nKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZUm2suw4OY2BIRy5wpJmf520J8k3gbc0vjFtMWtuxfs=;
        b=oKPG6YogITUJTXrP7jbxnjqeykc/68Az9bEBWKQ/PykXLg75tmjL2436zAtNDEbWSV
         pD7XPiOebm6vDNkl4WyguxNiT0V+hEhKNesThWsEKeCaVAe6acw8Yvg0ntDbNKrVQuS0
         wD5LdyKMZqM++wC2NnpA1T9dmaIOs4HDxy/6+j6ktOBbx6DdGI3b/vOI5Ao0XZviDMuW
         VfGCYgxzOpfW/pRf+yZlCYM8pjWWlVQVVTlOk0hdmDjMLXzoZ2ntnmpMXgYCyyZYK8WO
         v5ydZb2aTuXS2KwlWPwG8/etubb19zB6p4c7dzN2E2SnBmIkHfpLd4VOQRJ1REz22aG9
         5sng==
X-Gm-Message-State: AGi0PubuwGYvRNjC6jc+2O+3qAFEqvXLpT3DTDeL+ag2EiSviVBinmMb
        jir8IlJ7kajcrQE+ICizXMo=
X-Google-Smtp-Source: APiQypLaFxeiGjZFDeGwF7zlFiRtmbyR5wOSfmGz+AEv3j4l9MdebP48En0A4n4KApYgOOgG7H/gPw==
X-Received: by 2002:adf:f102:: with SMTP id r2mr2029018wro.376.1588932935318;
        Fri, 08 May 2020 03:15:35 -0700 (PDT)
Received: from ubuntu-G3 (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.googlemail.com with ESMTPSA id q8sm12179922wmg.22.2020.05.08.03.15.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 May 2020 03:15:34 -0700 (PDT)
Message-ID: <464f674a9a439bbfd563b5360e3a8fbbf6c41de1.camel@gmail.com>
Subject: Re: [RESENT PATCH RFC v3 4/5] scsi: ufs: add unit and geometry
 parameters for HPB
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org,
        rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Date:   Fri, 08 May 2020 12:15:33 +0200
In-Reply-To: <c398bc0c-c87c-3260-471d-85f0d10cf917@acm.org>
References: <20200504142032.16619-1-beanhuo@micron.com>
         <20200504142032.16619-5-beanhuo@micron.com>
         <c398bc0c-c87c-3260-471d-85f0d10cf917@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-07 at 18:04 -0700, Bart Van Assche wrote:
> > +     GEOMETRY_DESC_PARAM_HPB_REGION_SIZE     = 0x48,
> > +     GEOMETRY_DESC_PARAM_HPB_NUMBER_LU       = 0x49,
> > +     GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE  = 0x4A,
> > +     GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS = 0x4B,
> >   };
> 
> How about adding the names from the spec as a comment above the new
> constants, e.g. as follows?
> 
>         /* wHPBPinnedRegionStartIdx */
>         UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET = 0x25,
> 
> Thanks,
> 
> Bart.

Bart
I will add in the next version.

thanks,

Bean

