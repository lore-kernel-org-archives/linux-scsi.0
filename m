Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D44C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 18:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A432925222
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 18:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A7nsOScT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgFUSYn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 14:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbgFUSYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 14:24:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C716CC061794
        for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2020 11:24:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id h185so7283105pfg.2
        for <linux-scsi@vger.kernel.org>; Sun, 21 Jun 2020 11:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OIxGYRhKPPY2yRMcRvaBQdilviOAK3HHtRB/owNW9P8=;
        b=A7nsOScTlVGNwNdWeNMVcdbQdfhVoTPytKZBMn3rxp9GJ6xZByGWzVzGmVRI9abmqQ
         yxb0aWpD9rMwsubRAl0r3p/fem+wJcqhMw317p9DvLF2S1nqM1SFrWCHoivkeAZa0/IG
         MgdeJK0K0ZWJhN2VLIkiaTnKFmT06mlT9QyZUlgHJUqfhApVqtGU4X7cOOoIm81VoQvb
         sLDoviu5XQTvhnwFAQhk9CS3vLC8gBr/rN+zRpbA/xMme0yLtsWyDMrcNMFSApZuAlET
         AlAzJjKj2PEp0ItG7ZXKHkKmLVZg9Xk9cy1YQSWVEuX67RfPtI8ccWG2z3U3m7kYXyRT
         1RRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OIxGYRhKPPY2yRMcRvaBQdilviOAK3HHtRB/owNW9P8=;
        b=HbxmYDyxmGcJegUOmJ1z7xYzsGCV+PbET9HCAw3/RE76EDExtQ+6rRhextgASb7fRv
         rPNgEM3g6hxy0K9WMFzgWEHu99iPBsg93Fqihe0ZtURQ3+YMggBE4klQ3WtwvpAqZjpZ
         2ToxlplfDroyUtfyClGiyezeExDxpxVNv5bN0PMgHB7PkKZbqZ6M2wOh+3ldXt5atbCm
         VhGQ2787vHRerBPbN+PG+xBr4sHL78CmldfhtUhDQOrDUahpwVSD1a4IlTxak1ivrSXS
         byAtL8eOIb+UIpwVy/lXXM8qAZEmCZF97zW2mR4ISp6EKlaW1GMQxzQmFvJ8xeyhThYL
         EtdQ==
X-Gm-Message-State: AOAM5305Q4/JG3gxd87nk0jV6ULWu2R0mFyfkQeVYkT9OW8UZRAT6tmy
        6YeeYnGOIRfa0augMOaj1QsGOw==
X-Google-Smtp-Source: ABdhPJytDcXHJf1H1K398IPs9L8jmL975fPB4XUpt8RYzQ/RU5Bg99eKsXEQZa8Wv8rtYH0tU/QWFw==
X-Received: by 2002:a62:8782:: with SMTP id i124mr16953526pfe.267.1592763880962;
        Sun, 21 Jun 2020 11:24:40 -0700 (PDT)
Received: from google.com (124.190.199.35.bc.googleusercontent.com. [35.199.190.124])
        by smtp.gmail.com with ESMTPSA id n69sm12042058pjc.25.2020.06.21.11.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 11:24:40 -0700 (PDT)
Date:   Sun, 21 Jun 2020 18:24:36 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v2 0/3] Inline Encryption support for UFS
Message-ID: <20200621182436.GB1518@google.com>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
 <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jun 21, 2020 at 12:35:13PM +0000, Avri Altman wrote:
> +Alim & Asutosh
> 
> Hi Satya,
> 
> > 
> > Avri,
> > 
> > > This patch series adds support for inline encryption to UFS using
> > > the inline encryption support in the block layer. It follows the JEDEC
> > > UFSHCI v2.1 specification, which defines inline encryption for UFS.
> > 
> > I'd appreciate it if you could review this series.
> > 
> > Thanks!
> > 
> > --
> > Martin K. Petersen      Oracle Linux Engineering
> A quick question and a comment:
> 
> Does the IE infrastructure that you've added to the block layer invented for ufs?
It wasn't invented "just" for UFS, but it was guided by how UFS inline
crypto works. It is meant to be generic, and should be how we support
any arbitrary IE hardware in the kernel.

> Do you see other devices using it in the future?
> 
Certainly - at the very least, I think it's likely we'll add support
for eMMC inline crypto (although inline encryption support for eMMC was
only added in an unreleased/yet to be released spec). It's certainly my
hope that we add IE support for other classes of devices too.

> Today, chipset vendors are using a different scheme for their IE.
> Need their ack before reviewing your patches.
> 
Sure :). The Inline Encryption patches (the block layer, fscrypt, f2fs,
ext4 and these UFS patches) have been part of the Android common kernel
https://android.googlesource.com/kernel/common/
for quite a while now, and chipset vendors have been working with us
on ensuring that their UFS cards are supported by these patches (by adding
code similar to Eric's RFC: Inline crypto support on DragonBoard 845c at
https://www.spinics.net/lists/linux-scsi/msg141472.html
or Mediatek's "scsi: ufs-mediatek: add inline encryption support" at
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/
for their individual chipsets).
> Thanks,
> Avri
