Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27460C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB3A52226A
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 01:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAEBx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 20:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbhAEBx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 20:53:27 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A186BC061793
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 17:52:47 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id w1so590440pjc.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 17:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxace-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oFbLdoDKlV2DoBSMEKkI9BqNF/yDCzO5kaHKHUnEGzQ=;
        b=KE58ixwpUuhPmxfROBNwYruo1WekGVPqRDE1bGjz+LBJ5qswwR/TCNHivExdjPPowB
         z9AnzMBay4wVn2njzyCHUPGLcBGOl89iqClBW8XKxTn7imG+1/G1yBjQGDFhw/d7oBnC
         DlOCsXypkjP6IJ3Dxoxiq53ZPzRSWE1ok90auzesi0M7YuzhNH92pkzVSaiYeOTKSFpp
         prEDWH8IAq7HAbUBYTIg5AyrU6AXK+3liLiT5WO5RTU4jyv4qZc0ggI43GF9SFdXYNpn
         jY6skiUKyanoKLSutKvokdcO1h0RlHSb/FEwSUIgBShQHhyXebQptZ/uVFfJZpJEDzGE
         fk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oFbLdoDKlV2DoBSMEKkI9BqNF/yDCzO5kaHKHUnEGzQ=;
        b=ufhV6vVT/q+VcJ9tYwTYHXCRjrGwS4i5fbqEwszq3++2Xyty8ZiqiZsM1tFUHHm4dy
         EeNWKnlNpEZ+tNIujPLcV9f2fiQvjzlV4gQK7eB8qpvQAIFgESZGGSVq1ZvlKoNxQzP6
         ca2kt1+4i+kJe7Q1DdOIzRdFMa1s2LDFQfkNFi2syguy9gNB91uqch0kpXZ42vJ+fYKH
         RoBGr+eF92bhEBq+peDKRX21BrshRY7uvw7Oc23q0Ze0mwpCvjQr38kWf5oiD4fSvvy7
         stSGbFsaVgUR/og8pacRppYPwVmh+yL+CLxQedkB7+El2VFDr9sgweTz72moM0XHgkW8
         qemA==
X-Gm-Message-State: AOAM532yPbpkvUMaYKuHlIjigt1if5XuN2rR9L/B29eyhThwwkziIsBr
        J8FpMmouHNmlPJrLmS2Iz5Hezw==
X-Google-Smtp-Source: ABdhPJzNhhRd/XNM36hWGuOm/eZXsJCDr1fRicuouXS0NfpRKHnmdI2w86Kp1PIvabTXedqSZGD/AA==
X-Received: by 2002:a17:90b:4a81:: with SMTP id lp1mr1735742pjb.55.1609811567117;
        Mon, 04 Jan 2021 17:52:47 -0800 (PST)
Received: from home.linuxace.com (cpe-23-243-7-246.socal.res.rr.com. [23.243.7.246])
        by smtp.gmail.com with ESMTPSA id w6sm41423240pfq.208.2021.01.04.17.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:52:46 -0800 (PST)
Date:   Mon, 4 Jan 2021 17:52:43 -0800
From:   Phil Oester <kernel@linuxace.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Jason Yan <yanaijie@huawei.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression
Message-ID: <20210105015243.GA80882@home.linuxace.com>
References: <20210104234137.438275-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104234137.438275-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 05, 2021 at 12:41:04AM +0100, Arnd Bergmann wrote:
> Phil Oester reported that a fix for a possible buffer overrun that I
> sent caused a regression that manifests in this output:
> 
>  Event Message: A PCI parity error was detected on a component at bus 0 device 5 function 0.
>  Severity: Critical
>  Message ID: PCI1308
> 
> The original code tried to handle the sense data pointer differently
> when using 32-bit 64-bit DMA addressing, which would lead to a 32-bit
> dma_addr_t value of 0x11223344 to get stored
> 
> 32-bit kernel:       44 33 22 11 ?? ?? ?? ??
> 64-bit LE kernel:    44 33 22 11 00 00 00 00
> 64-bit BE kernel:    00 00 00 00 44 33 22 11
> 
> or a 64-bit dma_addr_t value of 0x1122334455667788 to get stored as
> 
> 32-bit kernel:       88 77 66 55 ?? ?? ?? ??
> 64-bit kernel:       88 77 66 55 44 33 22 11
> 
> In my patch, I tried to ensure that the same value is used on both
> 32-bit and 64-bit kernels, and picked what seemed to be the most sensible
> combination, storing 32-bit addresses in the first four bytes (as 32-bit
> kernels already did), and 64-bit addresses in eight consecutive bytes
> (as 64-bit kernels already did), but evidently this was incorrect.
> 
> Always storing the dma_addr_t pointer as 64-bit little-endian,
> i.e. initializing the second four bytes to zero in case of 32-bit
> addressing, apparently solved the problem for Phil, and is consistent
> with what all 64-bit little-endian machines did before.
> 
> I also checked in the history that in previous versions of the code,
> the pointer was always in the first four bytes without padding, and that
> previous attempts to fix 64-bit user space, big-endian architectures
> and 64-bit DMA were clearly flawed and seem to have introduced made
> this worse.
> 
> Reported-by: Phil Oester <kernel@linuxace.com>
> Fixes: 381d34e376e3 ("scsi: megaraid_sas: Check user-provided offsets")
> Fixes: 107a60dd71b5 ("scsi: megaraid_sas: Add support for 64bit consistent DMA")
> Fixes: 94cd65ddf4d7 ("[SCSI] megaraid_sas: addded support for big endian architecture")
> Fixes: 7b2519afa1ab ("[SCSI] megaraid_sas: fix 64 bit sense pointer truncation")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

This solves the issue on our Dell servers, thanks Arnd.

Phil
