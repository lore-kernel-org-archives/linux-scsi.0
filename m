Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D0CC2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 18:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0938924656
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 18:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YXYL1i2Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgAUSnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:43:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33906 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgAUSnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 13:43:19 -0500
Received: by mail-pl1-f196.google.com with SMTP id c9so1719305plo.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jan 2020 10:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VyNyygHT0l+kavkO9RtMQ33c7cwt2wna2HwrRhI5FxM=;
        b=YXYL1i2Zu+Kmd+DM6BsyfSf0A0TRgIpvmoa77QHgXaGEdkKOo2X8DmDZS6ccgM7zwV
         VhzZ0RxnhAkdvD4TswbyBm+EKAXR2a9HN+9zLZsOJmhmlb4IeJXNU53+/3U/ywXAn7K/
         JPy2t79RZ+AV69zBi8Sn5Z/cNfUoR6tisDgaEAewshgtsK0fcQBQlaMSiUSijpdJObPA
         uTU1GUBinLJqD+PQyyJ3x+fMUaKnuSjDq40/jvzCNI0JQs5tGIEnBOzv8ld7KXjpmLl7
         9psdC7GxXDBcBCyc++2VST6uzjliowiSEIfG07MrJ+bYhLUZWCgzos64iCWEfmRrd+Zy
         PXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VyNyygHT0l+kavkO9RtMQ33c7cwt2wna2HwrRhI5FxM=;
        b=stJlbtdisg7AOiwWydyhEixaMmKWBx7Z89PcLuxnq1pYx92jw2gHky3eDNDUD2gabp
         RGxs9gFNvVdv9BmSychsZ4I8dHJ3S/piHSWvajLQ1ZoxPr7IfwLSx57BFq43BJOon6hE
         Gpa0Y4VvLqc4Sp8rBm3HvkG6jToDLzyT51MAFscCU8t7LrQG2Hm3fiRTiPgiXbZpDkOh
         tDuwTYxw4aPQ2VWis2Y4Q5OMyYfJmK0GqMYTQIjobE3xO1vZA2LPX1uGHFQPnpI021E3
         sN+gjxl18x84YeKw9OD+TucArA9P11As1RFZUf7l39ZEBWxL4vhjwavzIKOQTlGtVqxJ
         lSJQ==
X-Gm-Message-State: APjAAAWw+8peNcXLzQRBGvuGJnlCdtx8+VH6S5pdVOUxkSaju+CPuyCp
        PQ8WF38mtBBkpzRzBWCdIJEzRgEzc73Yt+VO1oo8ng==
X-Google-Smtp-Source: APXvYqwiZkriIgCJLYOs6RDGkJ/is8QK3xA7WBM0igc/p+n+EzZmnn720fWnjNl9Sx+ncWxStz1rCejOnnVrvyu4CX0=
X-Received: by 2002:a17:902:6948:: with SMTP id k8mr6664939plt.223.1579632198484;
 Tue, 21 Jan 2020 10:43:18 -0800 (PST)
MIME-Version: 1.0
References: <20200120190021.26460-1-natechancellor@gmail.com>
In-Reply-To: <20200120190021.26460-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 21 Jan 2020 10:43:06 -0800
Message-ID: <CAKwvOd=30bpBXqrT6LfwDb+YrTcGtTg5NL34dpc3Vkfe11KvFQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla1280: Fix a use of QLA_64BIT_PTR
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 20, 2020 at 11:00 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> ../drivers/scsi/qla1280.c:1702:5: warning: 'QLA_64BIT_PTR' is not
> defined, evaluates to 0 [-Wundef]
> if QLA_64BIT_PTR
>     ^
> 1 warning generated.
>
> The rest of this driver uses #ifdef QLA_64BIT_PTR, do the same thing at
> this site to remove this warning.
>
> Fixes: ba304e5b4498 ("scsi: qla1280: Fix dma firmware download, if dma address is 64bit")

^ The above SHA is valid only in linux-next. Won't it change when
merged into mainline?

> Link: https://github.com/ClangBuiltLinux/linux/issues/843
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/scsi/qla1280.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 607cbddcdd14..3337cd341d21 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -1699,7 +1699,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
>         return err;
>  }
>
> -#if QLA_64BIT_PTR
> +#ifdef QLA_64BIT_PTR

Thomas should test this, as it implies the previous patch was NEVER
using the "true case" values, making it in effect a
no-functional-change (NFC).

>  #define LOAD_CMD       MBC_LOAD_RAM_A64_ROM
>  #define DUMP_CMD       MBC_DUMP_RAM_A64_ROM
>  #define CMD_ARGS       (BIT_7 | BIT_6 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0)
> --
-- 
Thanks,
~Nick Desaulniers
