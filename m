Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCD7C2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 18:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 533CD2465B
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 18:58:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KS4/gjFX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgAUS6i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 13:58:38 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39915 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgAUS6h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jan 2020 13:58:37 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so3930647oty.6;
        Tue, 21 Jan 2020 10:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wImdtgcbSrkhoSK27g0eKsb6+1rafcjtO7KTRZ4V1r4=;
        b=KS4/gjFX8RLU8xw4Y4jb2dGqfyRzE2ih7bElbeuJuLfIBYj0cdvYQ2A62tLh22gkLj
         ZewJmJrScTrzwLNyDuu6CBbRVsFppVFTDiOjh3MtRKu3Yr/fY0nk8FV05Spuy9YSCUpF
         FlzKYGAA/jm+yPm1FihgD4gVwHDI4JZGseRtSQsmyAW5xRtWRvBEZqkKf7TTFlNr8xgi
         LSeZwTjHudUO/VemOFNN+3y8OnKKo4+BV/CdJ66rZPqddQ8bDFrZjT46NDOsXCkYsLlW
         3/HiTGDtU1uZFxeZQiPu8dnTQJLB6e7vfIPrQne8QYHksXd8H3ZUqPUsnUT18QARO3dn
         RtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wImdtgcbSrkhoSK27g0eKsb6+1rafcjtO7KTRZ4V1r4=;
        b=PjbKefEwzqfrhlkWJAoP+KW39I1HFGsFVPsW/XclwS+9BvokNo/p0qveni4sFkhYUm
         6jGb6ky/+dKuR1s2kXMQUGVi18+IUBC63l79nAMUmSSOWSEro2Hq233gWugHNsSBLEXK
         0vInxnrBBK8E0o2Q8bNl9evHj+B5N600ngvJxazsqP41QgTVT0dFSyQ2jZ2sJ1MY9B0/
         6l0nL0HCtjBeZB0sn00ZBh2nt9UAQtyWsNzf3F3ypztzp5HbTfZxB1hjE5ZEsxhphe7T
         lwJHU/7d008p2rApBjieM1enX32WYOEm3SDqNzViJjFIJ1BZP5aPw8QDXB5y8t8/WfZF
         jBsw==
X-Gm-Message-State: APjAAAWAk9eoq7ICuPM5kmhwYq90MgvXi/M5J4wEIKma6p42BOAXDUaJ
        V3pwKjkN90X93LliyG6Srsc=
X-Google-Smtp-Source: APXvYqxUL4vHfUywEsR6K6TIQFtq146ZLrDQHka57ywFVBZtGEG1vQCHfTH2ti0F01Kkd+dROS4QQg==
X-Received: by 2002:a05:6830:1e16:: with SMTP id s22mr4692577otr.340.1579633116712;
        Tue, 21 Jan 2020 10:58:36 -0800 (PST)
Received: from ubuntu-x2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id l82sm12233220oib.41.2020.01.21.10.58.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jan 2020 10:58:36 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:58:34 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] scsi: qla1280: Fix a use of QLA_64BIT_PTR
Message-ID: <20200121185834.GA3941@ubuntu-x2-xlarge-x86>
References: <20200120190021.26460-1-natechancellor@gmail.com>
 <CAKwvOd=30bpBXqrT6LfwDb+YrTcGtTg5NL34dpc3Vkfe11KvFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=30bpBXqrT6LfwDb+YrTcGtTg5NL34dpc3Vkfe11KvFQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 21, 2020 at 10:43:06AM -0800, Nick Desaulniers wrote:
> On Mon, Jan 20, 2020 at 11:00 AM Nathan Chancellor
> <natechancellor@gmail.com> wrote:
> >
> > Clang warns:
> >
> > ../drivers/scsi/qla1280.c:1702:5: warning: 'QLA_64BIT_PTR' is not
> > defined, evaluates to 0 [-Wundef]
> > if QLA_64BIT_PTR
> >     ^
> > 1 warning generated.
> >
> > The rest of this driver uses #ifdef QLA_64BIT_PTR, do the same thing at
> > this site to remove this warning.
> >
> > Fixes: ba304e5b4498 ("scsi: qla1280: Fix dma firmware download, if dma address is 64bit")
> 
> ^ The above SHA is valid only in linux-next. Won't it change when
> merged into mainline?

Not unless Martin rebases his tree (in which case, this patch should
just be folded into the original one).

> > Link: https://github.com/ClangBuiltLinux/linux/issues/843
> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> 
> Thanks for the patch.
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the review :)

> > ---
> >  drivers/scsi/qla1280.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> > index 607cbddcdd14..3337cd341d21 100644
> > --- a/drivers/scsi/qla1280.c
> > +++ b/drivers/scsi/qla1280.c
> > @@ -1699,7 +1699,7 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
> >         return err;
> >  }
> >
> > -#if QLA_64BIT_PTR
> > +#ifdef QLA_64BIT_PTR
> 
> Thomas should test this, as it implies the previous patch was NEVER
> using the "true case" values, making it in effect a
> no-functional-change (NFC).

QLA_64BIT_PTR is defined to 1 when CONFIG_ARCH_DMA_ADDR_T_64BIT is set
so the true should have always worked, unless I am misunderstanding what
you are saying. The false case should have also worked because it is
still evaluated to 0 but it throws the warning to make sure that was
intended (again, as I understand it).

> >  #define LOAD_CMD       MBC_LOAD_RAM_A64_ROM
> >  #define DUMP_CMD       MBC_DUMP_RAM_A64_ROM
> >  #define CMD_ARGS       (BIT_7 | BIT_6 | BIT_4 | BIT_3 | BIT_2 | BIT_1 | BIT_0)
> > --
> -- 
> Thanks,
> ~Nick Desaulniers
