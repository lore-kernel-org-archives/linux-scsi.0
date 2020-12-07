Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15376C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:15:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B690623340
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 11:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgLGLOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 06:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbgLGLOu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 06:14:50 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DD8C0613D0;
        Mon,  7 Dec 2020 03:14:09 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id lt17so18949811ejb.3;
        Mon, 07 Dec 2020 03:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UXP8pGOs6I07RubMzh9UPSoGrdmJCXDEzrlECyPatEc=;
        b=g+O7K38plSkmPFpEJKYh66kin5NbJPRgVGhwQAldpmJSmOd2tPJBHtktR+U9RjKXN5
         w1/66nEj3xB5+tbtbGsNbfjwTLmsE7eYHRTi5AqZVowIY8q6YEhxCGOsUIb6HZ6PbQnb
         8fT6l3mRvBhrS+z4tsA40pH922LNmZdHABA3U7alQX9e21jrKmoMcunZSDdXPY2gJc5U
         JrtvNcN95XiuhAh8He5lxo2kYPUcSSXK4LUWuLAdtGCF9Ghk0FY17ZdTQhEbH9BlIPJI
         RgIAaRfuTAX+kLFyUva7YXFU5K9x2O8nU+flbPQ/vsY2Dl6QEgjSbcv42mUtdvQgU8hr
         Aokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UXP8pGOs6I07RubMzh9UPSoGrdmJCXDEzrlECyPatEc=;
        b=C1Qv7OrKdDgGVShIj/28I4oLtheAUVuuTbtp8S5tyf45RdGlInakTKQQsMxSGf5fx9
         MqcfZ/FFA5NbytHlCgBg5uS9y7UVHzDLFuzRTuZSIteTfCa0jLjNANRmjNEImZG6NZzY
         kBCEH5l0Z9gJ35p5j5oWvfa4YFIEHwxPbdIWDvXI8BlEbyS1KHorw1pFPFhsE02iffAF
         mr4nbiGjTrfrZ647GPed6k5dGTU6jt0Uf3vr3+RUojlt8kzg0Zfm1H08WNJXeRbo4vS6
         yi4FaaFrUSl+iAqyLeytmt7E2o46yrkeH/4tkHHdIRRdfwB+klbQiCTyKTNo7injPqs8
         TT+Q==
X-Gm-Message-State: AOAM532+omUMPCh7IuqpUZM7dmx9WXiuicZvRxMwqiAyM+EQTw18fKRd
        c1K9efc0+uu7xj3f8FPVUjg=
X-Google-Smtp-Source: ABdhPJxF8cgKuhmNchC2AHpvcVS8hxxEz/nExEi3EGXRnP5GyAKE2BcmBiXCb/EvxDeU0sokkLP0tQ==
X-Received: by 2002:a17:906:31d2:: with SMTP id f18mr18266080ejf.407.1607339648377;
        Mon, 07 Dec 2020 03:14:08 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id q25sm7906732eds.85.2020.12.07.03.14.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 07 Dec 2020 03:14:07 -0800 (PST)
Message-ID: <c4333f6ad6172d991f6afdaea3698c75fb0f7c36.camel@gmail.com>
Subject: Re: [PATCH v1 3/3] scsi: ufs: Make UPIU trace easier differentiate
 among CDB, OSF, and TM
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
Date:   Mon, 07 Dec 2020 12:14:06 +0100
In-Reply-To: <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201206164226.6595-1-huobean@gmail.com>
         <20201206164226.6595-4-huobean@gmail.com>
         <DM6PR04MB6575197B8626D3F91C9231C4FCCE0@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-07 at 07:57 +0000, Avri Altman wrote:
> >          TP_printk(
> > -               "%s: %s: HDR:%s, CDB:%s",
> > +               "%s: %s: HDR:%s, %s:%s",
> >                  __get_str(str), __get_str(dev_name),
> >                  __print_hex(__entry->hdr, sizeof(__entry->hdr)),
> > +               __get_str(tsf_type),
> 
> This breaks what current parsers expects.
> Why str is not enough to distinguish between the command?
> 
> Thanks,
> Avri

Hi Avri
Tt donesn't break original CDB parser. for the CDB, it is still the
same as before. Here just make Transaction Specific Fields in the UPIU
package much clearer.

I mentioned in the commits message: 

Transaction Specific Fields (TSF) in the UPIU package could be CDB
(SCSI/UFS Command Descriptor Block), OSF (Opcode Specific Field), and
TM I/O parameter (Task Management Input/Output Parameter). But we
didn't differenciate them. we take all of these as CDB. This is wrong.

I want to make it clearer and make UPIU trace in line with the Spec.
what's more,  how do you filter OSF, TM parameters with current UPIU
trace? you take all of them as CDB? if so, I think, it's better to
change parser.

Thanks,
Bean






