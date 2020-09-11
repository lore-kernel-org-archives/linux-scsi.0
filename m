Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA854C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 07:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ADBF2075A
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 07:23:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DoguvApy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725616AbgIKHXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 03:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgIKHXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 03:23:04 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5C2C061573
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 00:23:04 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id o6so7587465ota.2
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 00:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A0wpD5szTjzGb8YcqUxHpKzsKfekj7bcZ8PG6pq/zTQ=;
        b=DoguvApyUdxNRlLkUJWyRNmb8XJRAhZ+m5tUrdoL+VG3synCws5ToVAqE7glBmLTrQ
         s8qDLekcxcUASaE08XyV0ycRl8q1CaQsQFNJmIf8MF1bQ9M3oujpK1IkG6ArIJ35IE0A
         HgPSmju1kWkcg2M6XmuOnV+/8ij+ha0inZwYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A0wpD5szTjzGb8YcqUxHpKzsKfekj7bcZ8PG6pq/zTQ=;
        b=osAdkQFXoUzm7VpT+Mfp08XCI0MLrSfdFGta03St/DbxRZQKvrGILFPtumhQ1FB6Xr
         UOF8olxliuGjHsCziRacEWHk+7hyQpBOXYAwN1X26zfjrb/HLTcr+SPFPZZwA8vgAmGk
         cjBjX/7svBLOKzFi8BakpSAraF0bRqChS9yDg7ZfyBF1uu9409qWoLZ2gwGY8UXYmxil
         OFXZ6YpTyQ1ybD4aaTItD2GlUEPDdbGfDyWzGbb9woC1jiogXl0ci1iszBGdjWDszmPG
         nFkNmcMriaKAl8/LEX95i1YFnegV5sPtt5pNr8mGqzGe0CPQJSst2BBRAXGTq0X181OK
         LeCA==
X-Gm-Message-State: AOAM533FBKuXS8gvqszOYalBdAhiwg5o9CrucSoGWRaVQ650l9BQHYb7
        eubDrRSS2ah3C+rE3kLuH7iLWAOviC316z+n+v8p+g==
X-Google-Smtp-Source: ABdhPJyhpPOtiFAfGZJ923qC3kmyCoxlFYDg9Bp/3Y5GhNRatsLb/WwuVYw6bYVL8O79B7O1qCc4goy5nBr902QYb8s=
X-Received: by 2002:a9d:386:: with SMTP id f6mr383610otf.348.1599808982552;
 Fri, 11 Sep 2020 00:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200909164446.713025-1-helgaas@kernel.org>
In-Reply-To: <20200909164446.713025-1-helgaas@kernel.org>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Fri, 11 Sep 2020 12:52:36 +0530
Message-ID: <CAL2rwxokUbkHBsz0r-TqKonYpv8Ty+6qHetQqf=YiMmX6egCWg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Drop megaraidlinux.pdl@broadcom.com from
 MEGARAID SCSI/SAS DRIVERS
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 9, 2020 at 10:14 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> From: Bjorn Helgaas <bhelgaas@google.com>
>
> Every post to megaraidlinux.pdl@broadcom.com seems to generate a bounce, so
> I think the list is defunct.  Remove it from MAINTAINERS.
This PDL is active again. Please let me know if you face any issues.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index deaafb617361..a92d1517e865 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11042,7 +11042,6 @@ MEGARAID SCSI/SAS DRIVERS
>  M:     Kashyap Desai <kashyap.desai@broadcom.com>
>  M:     Sumit Saxena <sumit.saxena@broadcom.com>
>  M:     Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> -L:     megaraidlinux.pdl@broadcom.com
>  L:     linux-scsi@vger.kernel.org
>  S:     Maintained
>  W:     http://www.avagotech.com/support/
> --
> 2.25.1
>
