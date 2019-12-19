Return-Path: <SRS0=QEZ7=2J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55376C3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 20:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B0D24688
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Dec 2019 20:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cxx1pArM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbfLSUW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:22:27 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46022 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbfLSUWV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Dec 2019 15:22:21 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so3896869pfg.12
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2019 12:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PsW/j1Crrs313MkKDSnDNbKlrshzMf4od6PZBBKr95I=;
        b=Cxx1pArMA1dCG+vdMqR0CO3SVpBUWxpFIs3cuP3P27CupTI87usG38HorhvjALmrX6
         QyzgEyCgcDkramgZ7qIh+L+TKfuJPmdXxExRJpnjB7Zx0IP+0BOYdBXG2RJMUmTJD60v
         OjtsQQ6z3UTnMwyQJCuCHoYO9lqbg3DtrWnSkYk1vicghmJwdbzV4dRZz1qvfOZvDHwN
         zHHwcPJLSp9OU2JbBzjmbFZyY8iqt2XdlluHAPATqSBTWhu2J0HjuzAESm4mEfIT1lMp
         JnWNWeyi2tI6mJcfcYkKvW2v5gCkYlwkxYqP/mBow6aJ3NByA/sJPaQjT/u7Vy0fFFC/
         6sbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PsW/j1Crrs313MkKDSnDNbKlrshzMf4od6PZBBKr95I=;
        b=X26zIATBgtrbPt/tXqf3RarX4iWHB+WOVRk9ZBIlARzzSANzlos6Y62XCTry2usTjm
         B1s3YxfrLVlVcRdVw7QQveH5dY84YF/iF6bMwbxBvWLVMJZWbTzxjDylLYfLim7lM2as
         8JigKF1QtsG9/0zRAKS8wU6Y2V5eK1Iy3HTgVSjDsTR+q96xKEy7CLTISllAxuLjWWN3
         ENWOEAesTazcj75kUFqx12VJtT/YQqlxrLr8cBiGloiqSdS574QwouxCl6ui4UCyLEDb
         FMfEUqryeeodlLoUhqKLW3Nz/f6x4X6TasWYODkpM5PNyuN+TqfPZ5oXLkrDEkYQ3Luv
         rqug==
X-Gm-Message-State: APjAAAX2dehnO5ISrMycUHFRJUJ6cFEMltWNoJX5Wa/FDcTn2z5g/ilo
        Kb59kQovxF7PZ2zs+ZdH/80FhRZVdIMnQMUYdApLQ/tUkRU=
X-Google-Smtp-Source: APXvYqx7TULpvCuBBqKMKSSguT898fWlQzY/uebdX+PZW3Yo9Etjdi39QBGNAUnvO/GUVvsaElIAhNEYkDPFmQEqwbA=
X-Received: by 2002:a63:d249:: with SMTP id t9mr11165747pgi.263.1576786940683;
 Thu, 19 Dec 2019 12:22:20 -0800 (PST)
MIME-Version: 1.0
References: <20191218015252.20890-1-natechancellor@gmail.com>
In-Reply-To: <20191218015252.20890-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 19 Dec 2019 12:22:09 -0800
Message-ID: <CAKwvOdk_CqpdJdKLQ-a5AK8pci7yMic9pgJW5x-iFosYbk8CMw@mail.gmail.com>
Subject: Re: [PATCH] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     QLogic-Storage-Upstream@qlogic.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 17, 2019 at 5:52 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns:
>
> ../drivers/scsi/qla4xxx/ql4_os.c:4148:3: warning: misleading
> indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>          if (ha->fw_dump)
>          ^
> ../drivers/scsi/qla4xxx/ql4_os.c:4144:2: note: previous statement is
> here
>         if (ha->queues)
>         ^
> 1 warning generated.
>
> This warning occurs because there is a space after the tab on this line.
> Remove it so that the indentation is consistent with the Linux kernel
> coding style and clang no longer warns.
>
> Fixes: 068237c87c64 ("[SCSI] qla4xxx: Capture minidump for ISP82XX on firmware failure")
> Link: https://github.com/ClangBuiltLinux/linux/issues/819
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 2323432a0edb..5504ab11decc 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -4145,7 +4145,7 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
>                 dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
>                                   ha->queues_dma);
>
> -        if (ha->fw_dump)
> +       if (ha->fw_dump)
>                 vfree(ha->fw_dump);
>
>         ha->queues_len = 0;
> --

-- 
Thanks,
~Nick Desaulniers
