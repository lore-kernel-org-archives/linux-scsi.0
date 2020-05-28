Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F297C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C2D02071A
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 16:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G+8THdO2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404828AbgE1QEH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404688AbgE1QEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 12:04:05 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C63C08C5C6;
        Thu, 28 May 2020 09:04:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id n5so3846149wmd.0;
        Thu, 28 May 2020 09:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NYbB8W/sK5Tdd5BWIln6OVmuCc5eV8VaAbys7to+vVI=;
        b=G+8THdO2rsiizTUxp1RVKC1ojHNIsKa+XMTeB1jsw0ZZFO/JZvSjnoUz+HktWlNNbO
         wxvf7hiXp+S7sa/sJ+hRNU5hXGPFXBIRnQzZ5+sc7FpYgNrCux32RxyLzcXNm0do9L+r
         YfIwJKYv2iz9qFdcZt6P8QXqZ5alQjosBH1KAwcBFFUTdlGXduNarwx9zm3J6ePw/gXz
         fqpi5bqjMo7N/VGynABlW9dboVFH6U2pfjDpQ+r3fhScroFoanZp+XepdzJuD0MLZBjJ
         +whbTbCv0gqB67y4z2JRZtAZFL0E9T68JNGNQQ2SXQ9n8UlEEvvWyFuQXCwddo81jj+p
         Zl4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NYbB8W/sK5Tdd5BWIln6OVmuCc5eV8VaAbys7to+vVI=;
        b=lK51XxGsPybSZhQxJH/fi7uVj/AmGM/GrP+o61mm/sCQYPMV+ZQdoNRDiCFQBKGsy8
         /fldaL2X6XxaZ2jGSwWIEsEk+a4RsH3GCOhPrfrkmKih2F8vEcxTf7/f7uri4grF4EVS
         MlIc2vp4hyB6gk87GcyV4uzaWKlZRaehpIky2rifhNmI2PjOxQ4rZMoEwTLMWaEY94ny
         kXU42AMeGciUZKUtzYJx9DXyFknikwD6mQw+TZXt8lvhOC2124DYez93pXtbtNfwt7wf
         hcspwe0ZocCjOe2T8RgMCYF8nAUB/XAZgDmMPRHqDMijg1QNmbW28t5wqN9Z2SaulT9F
         nT5w==
X-Gm-Message-State: AOAM532AKao7fD1B1ll6zlJnT7nDzhUbb/1IH2LoU+CTNYP20PaUSLMm
        7rqnb7G2HXKSeGAzQhyNsFvDlLpdY70=
X-Google-Smtp-Source: ABdhPJyZZSHSZtIHHT+Tdfv7pN/bXF758biPQNWu8nQfqIglxDhEi9hnmuzR48z6wOp37ICI37Sodw==
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr4012429wma.158.1590681844011;
        Thu, 28 May 2020 09:04:04 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.googlemail.com with ESMTPSA id y66sm6577290wmy.24.2020.05.28.09.04.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 09:04:03 -0700 (PDT)
Message-ID: <f1e1e76ca6deb796c1ccd432d4d4dd695b812320.camel@gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: ufs: cleanup ufs initialization path
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
Date:   Thu, 28 May 2020 18:03:52 +0200
In-Reply-To: <SN6PR04MB4640F8F4B293E6D3980952D5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200528115616.9949-1-huobean@gmail.com>
         <20200528115616.9949-4-huobean@gmail.com>
         <SN6PR04MB4640F8F4B293E6D3980952D5FC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-05-28 at 14:58 +0000, Avri Altman wrote:
> Hi,
> 
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > At UFS initialization stage, to get the length of the descriptor,
> > ufshcd_read_desc_length() being called 6 times.
> 
> May I suggest one more clarifying sentence to your commit log:
> "Instead, we will capture the descriptor size the first time we'll
> read it."
> 
> > This patch is to
> > delete unnecessary reduntant code, remove ufshcd_read_desc_length()
> 
> typo: redundant

fixed.
> 
> > and boost UFS initialization.
> > 
> > Signed-off-by: Bean Huo <beanhuo@micron.com>
> > +       if (desc_id >= QUERY_DESC_IDN_MAX) {
> >                 *desc_len = 0;
> >                 return -EINVAL;
> >         }
> 
> if (desc_id == QUERY_DESC_IDN_RFU_0 || desc_id ==
> QUERY_DESC_IDN_RFU_1)
> 	*desc_len = 0;
> else
> > +
> > +       *desc_len = hba->desc_size[desc_id];
> >         return 0;
> >  }
> >  EXPORT_SYMBOL(ufshcd_map_desc_id_to_length);
> > 
> > +static void ufshcd_update_desc_length(struct ufs_hba *hba,
> > +                                     enum desc_idn desc_id, int
> > desc_len)
> 
> desc_len is at most 255 so maybe u8?
> 
Avri
thanks, it will be changed in next version.


Bean

