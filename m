Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70CB4ECAAA1
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Sep 2022 17:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiIORfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Sep 2022 13:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiIORfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Sep 2022 13:35:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F1E9E104
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 10:35:44 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l14so43770045eja.7
        for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2022 10:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Ytb5sWjKL3+g27ErgN7sjDIdqUlbBBDpqPefnf+kH1E=;
        b=Eu54bRulcguug8mnDPDgUIsyVQcmSZP/K0Q3dWC9hWl57yDEE1KceiSTLSiMALKT6x
         k5hWBUm22iW3FhWKd34R+OzKQ/5rLj85JlGDyiQ7Ejf29+cVIdjUXgBPBBQieHeerxfF
         BgfVC63BYe4HHPlYkcNFFIQ/xpReko8QIB2bc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Ytb5sWjKL3+g27ErgN7sjDIdqUlbBBDpqPefnf+kH1E=;
        b=giVMKaqK082a1QmKTZQgw3nQLo9rkteqg0TltrFl6Hiw9MKoovRfAqOR7G/46dPTYo
         +zw2onFgtILUtiaT3o4U1wIPf15h/AF9lDyhoROtLKRCGbJ9l1gUjnFuh9V7U8vmZxtl
         SYJZ1voQhF2YG2kkmU8R5LD9tcThxUd6CXf700GU5yvkqKibhe3PrCWuhgSkpmoJ36MT
         g1nW8wzy5SxOYnt2e628FZmlkXSq3Q59+czkkUkxngs1Ntmr0t6B3KE1XpQFyYQF08OD
         YLoii4GTMiR60/wwuUpT+QN2/Iw9ewNyqce/AAS9UO0HOkFp9IimxoxuBcfCz6g3u0TE
         mE4w==
X-Gm-Message-State: ACrzQf0NGdZ49cePHndYqK8vNdmlz2Q7SmUaKKTnRD9gxhOemagDCdd7
        UHkNP6mGOU/E7N5fsanRkH+x/kiSWuzbXA72xg0m8w==
X-Google-Smtp-Source: AMsMyM5H4wWolA60NuZlAi79ZZeLOsda4csn+/ETsaHsV4RJQI332zf3/aDwOqWRxHGWDmdV1b8D691pkvEIzobUe1Y=
X-Received: by 2002:a17:906:8a7b:b0:770:7d03:f9f2 with SMTP id
 hy27-20020a1709068a7b00b007707d03f9f2mr746772ejc.14.1663263342810; Thu, 15
 Sep 2022 10:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220804131226.16653-1-sreekanth.reddy@broadcom.com> <022389a4-eb7f-7b81-a6b2-0ef11faa0cfd@huawei.com>
In-Reply-To: <022389a4-eb7f-7b81-a6b2-0ef11faa0cfd@huawei.com>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Thu, 15 Sep 2022 23:05:16 +0530
Message-ID: <CAL2rwxrHj1+hyS-fxExR7onhgn-RqP2n6xsjcaK5YJcE1--5nQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/15] mpi3mr: Added Support for SAS Transport
To:     John Garry <john.garry@huawei.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 15, 2022 at 5:33 PM John Garry <john.garry@huawei.com> wrote:
>
> On 04/08/2022 14:12, Sreekanth Reddy wrote:
> > - Enhanced the driver to support SAS transport layer and
> >   expose SAS controller PHYs, ports, attached expander, expander PHYs,
> >   expander ports and SAS/SATA end devices to the kernel through
> >   SAS transport class.
> > - The driver also provides call back handlers for get_linkerrors,
> >   get_enclosure_identifier, get_bay_identifier, phy_reset, phy_enable,
> >   set_phy_speed and smp_handler to the kernel as defined by the
> >   SAS transport layer.
> > - The SAS transport layer support is enabled only when the
> >   controller multipath capability is not enabled.
> > - The NVMe devices, VDs, vSES and PCIe Managed SES devices
> >   are not exposed through SAS transport.
>
> Out of curiosity, are there any plans to add SCSI transport SAS support
> for megaraid sas?
No plan to add SAS transport support for megaraid_sas.

Thanks,
Sumit
>
> Thanks,
> John
