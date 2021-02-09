Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA17C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DC0364E66
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 14:23:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbhBIOWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 09:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhBIOWj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 09:22:39 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E029DC061788;
        Tue,  9 Feb 2021 06:21:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id i8so31745068ejc.7;
        Tue, 09 Feb 2021 06:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brgJv2EchyVIEKNKk5HxXUBqBIU3Gr2PeID6N0UcVkA=;
        b=sYTaaclLFx/vzFMOvKLEYlhKmz+f5o1FlaTuUBISjsdXv0BlOWVrG/0cjnn4+ldYhj
         GmY2jsuBAhk1O6sfoJw1a1PkE6qMehwoV3QLBN1Oi8V0yw4F+q5ccBSJp5sRHmpwrFm1
         P0JGWr5fsIBjQhIP3DH4BY4SDgKz+h+A+YCfV5UCRPFh1GcEjUJSjIOkXn1nzBQAmkHv
         H9YArTja/CcjDZkhdxhQtmEt/uVyqMDWglrjbrQrtfLP/Ov08vhlOu0ixxLkH5YSaFH5
         PLR6ZRZscIC49rdNilSmr/4lulPYTNxFgmQ53BUurvEEy0NP/fAszQqGAXLzVIxY6gTb
         GYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brgJv2EchyVIEKNKk5HxXUBqBIU3Gr2PeID6N0UcVkA=;
        b=H8gDFe/sDyk+pAjbPXq2PbKbqPf/gsBYPkYV4I8KpRuimtwhPUn4qS19VkjzUfNihY
         P0E5VBUk+MvXnYqbSHRHsUB71OWVqdR4VFGZ//UJZHtGXXuCY/rklIHyMYq281aRcWVf
         TaJjsYyQsnRagQt1+/n5F0YGr2zJn91HYz78VyxvEW3tw/TZAersIJycutPw7/ug+IBm
         p+7RXC9dn8jsWrD3kANXf12spWUciMK4aGGhvv/uBoS2/dUa4fIcWQGbiV36y9+kivYp
         IyBRz+HmcDQYSFmSFQqHjVee/3iGyABWpZA+9H9vIfWd1joboRZB+/0Ifpvc47ErhOZw
         h9NQ==
X-Gm-Message-State: AOAM5316oEnV9F2vLoH++X0Mr/DdqNLPEsnLXnhj/y7051T358bvL20n
        /ykwxR4wT6Xm4jj0WYORP4Y=
X-Google-Smtp-Source: ABdhPJxyGxW6bKt3B7gb8lEq6uSUKByPv5T4mzGZdoKbd/z+Ms/SFYrzL93t9fTKW7mUJqp2SFT+9Q==
X-Received: by 2002:a17:906:6057:: with SMTP id p23mr22834572ejj.281.1612880517548;
        Tue, 09 Feb 2021 06:21:57 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id i4sm10551588eje.90.2021.02.09.06.21.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Feb 2021 06:21:56 -0800 (PST)
Message-ID: <4355a1ebffea1da290389c57eb2b42df75990c6e.camel@gmail.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
From:   Bean Huo <huobean@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Tue, 09 Feb 2021 15:21:54 +0100
In-Reply-To: <DM6PR04MB6575C8C5BEE5BCDA7EBE786BFC8E9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
         <b6a8652c00411e3f71d33e7a6322f49eb5701039.camel@gmail.com>
         <DM6PR04MB657522B94AB436CF096460F6FCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
         <DM6PR04MB6575C8C5BEE5BCDA7EBE786BFC8E9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-02-09 at 13:25 +0000, Avri Altman wrote:
> > 
> > 
> > > > > +     put_unaligned_be64(ppn, &cdb[6]);
> > > > 
> > > > You are assuming the HPB entries read out by "HPB Read Buffer"
> > > > cmd
> > > > are
> > > > in Little
> > > > Endian, which is why you are using put_unaligned_be64 here.
> > > > However,
> > > > this assumption
> > > > is not right for all the other flash vendors - HPB entries read
> > > > out
> > > > by
> > > > "HPB Read Buffer"
> > > > cmd may come in Big Endian, if so, their random read
> > > > performance are
> > > > screwed.
> > > 
> > > For this question, it is very hard to make a correct format since
> > > the
> > > Spec doesn't give a clear definition. Should we have a default
> > > format,
> > > if there is conflict, and then add quirk or add a vendor-specific
> > > table?
> > > 
> > > Hi Avri
> > > Do you have a good idea?
> > 
> > I don't know.  Better let Daejun answer this.
> > This was working for me for both Galaxy S20 (Exynos) as well as
> > Xiaomi Mi10
> > (8250).
> 
> As for the endianity issue - 
> I don't think that any fix is needed in the hpb driver.
> It is readily seen that the ppn from get_ppn, and the one in the upiu
> cdb (upiu trace) are identical.
> Therefore, if an issue exist, it is IMHO a device issue.
> 
> kworker/u16:10-315   [001] d..2    62.283264: ufshpb_get_ppn: Avri
> ppn 480d2f8244c21abd
>   kworker/u16:10-315   [001] d..2    62.283336: ufshcd_upiu: v:1.10
> send: T:62283314922, HDR:014000000000000000000000,
> CDB:8800002ddaac480d2f8244c21abd0100, D:
> 
> Again, verified on both gs20 (exynos) and mi10 (8250).
> Thanks,
> Avri


Hi Avri,
Your testing method is no problem, the current problem is in function
ufshpb_get_ppn().


+static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
+                         struct ufshpb_map_ctx *mctx, int pos, int
*error)
+{
+       u64 *ppn_table; 
+       struct page *page;
+       int index, offset;
+
+       index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
+       offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
+
+       page = mctx->m_page[index];
+       if (unlikely(!page)) {
+               *error = -ENOMEM;
+               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+                       "error. cannot find page in mctx\n");
+               return 0;
+       }
+
+       ppn_table = page_address(page);
+       if (unlikely(!ppn_table)) {
+               *error = -ENOMEM;
+               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+                       "error. cannot get ppn_table\n");
+               return 0;
+       }
+
+       return ppn_table[offset];
+}


Say, the UFS device outputs the L2P entry in big-endian, which means
the most significant byte of an L2P entry will be output firstly, then
the less significant byte..., let's take an example of one L2P entry:

0x 12 34 56 78 90 12 34 56

0x12 is the most significant byte, will be store in the lowest address
in the L2P cache.

eg,

F0000008: 1234 5678 9012 3456

In the ARM based system, If we use "return ppn_table[offset]",
the original L2P entry 0x1234 5678 9012 3456, will be converted to
0x5634 1290 7856 3412. then use put_unaligned_be64(), UFS receive
unexpected L2P entry(L2P entry miss).

If the UFS output L2P entry in the big-endian, this is a problem.


For the UFS outputs L2P entry in little-endian, no problem,

Because of the L2P entry in the memory:

F0000008: 5634 1290 7856 3412

After return ppn_table[offset], L2P entry will be correct L2P entry:

0x1234567890123456. then use put_unaligned_be64(), UFS can receive
expected L2P etnry(L2P entry hit).


we need to figure out which way is the JEDEC recommended L2P entry
output endianness. otherwise, two methods co-exist in HPB driver, there
will confuse customer.
If you have a look at the JEDEC HPB 2.0, seems the big-endian is
correct way. This need you and Daejun to double check inside your
company.

thanks,
Bean

