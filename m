Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDDBCDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 21:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjJQV4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 17:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjJQV4u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 17:56:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D2C4
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 14:56:49 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-536ef8a7dcdso2027a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 14:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697579807; x=1698184607; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x6SecveUSZbKWLbjiW04X4UH95hRKYmyzqJ3SXHAuOw=;
        b=XibKjnOlZ5UN+m2meVnEjGK9m3/4nXPq8SuLH0d3JwOvXMIurzEXFDdlQSzhd+z+N6
         S1pMM8qsu8XkLT7vC/2UdpejID+of8zyWV3Hsk48+jJF2ID24bcJIso3HsXDnY+Gts0T
         qjpnRGIwiCWE0x+X8PWR7UhAXZrjz/V2yNtdVjSt9GKA2oc7OoYMhrumA7lSoUkDdoGx
         PcmNC1iSaJz2sBdqGENMSJ1+SG9KST4deVamdX4qJ1K74Q/fPPUsgmMXhC83hgtzVzU2
         AWcj2cxQhzw7uknH5jfn4E35nPwfWou0pFpzx59r50sHmud4unhq7dTNwmZB5kbqxrYX
         uJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697579807; x=1698184607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6SecveUSZbKWLbjiW04X4UH95hRKYmyzqJ3SXHAuOw=;
        b=g3TDDrrV0yVRCwoQJbaSHX73NkHrCLbRrw8xUjar8knKvcZ7axm9QQLkGoQj2/P4XQ
         sLxlsWtsAAR4xRRUJqhVZMAn42THoqVRwkft6kaFWYRjioCGqzKUiBLh3QacGjXervak
         eW7UA3b1D+eb33b4kwKm4PwkoLw6lVHfYvYK4SiAA+dc+CA2XblEgikE3mto82bU9Td2
         NyVmvZvKag6/JOZrnZtpQUpBSQ0HfjvobTSgH8QQmTLgvJS+cf8R8WprONx6Zstf8NxC
         BhohRS34enAjrRyjNxGyeX59fnXF2angGEVdbU4PUc5CGRyZE6dsAY5ZtpItAk3usD16
         qgRg==
X-Gm-Message-State: AOJu0YzoABBL6cWNkrWI3EndrtEGVd53J64OdvaLQlrHfsBPA4jPq3rn
        Kv0pSgpHiOLxa6SwngQhpy7z1sZoeIOod9gCm4QQXLdFiJS6kgmnBuJ1Cw==
X-Google-Smtp-Source: AGHT+IFeNB7FV7GubzleZU617rN/G/xjqDvjL6DLVrnWjcz/iKRbu0lAMqNk3YpZxQbGcqm0l6q3ZvoAaaFRp6ONXrE=
X-Received: by 2002:a50:a6d9:0:b0:53e:7ad7:6d47 with SMTP id
 f25-20020a50a6d9000000b0053e7ad76d47mr19944edc.5.1697579807512; Tue, 17 Oct
 2023 14:56:47 -0700 (PDT)
MIME-Version: 1.0
References: <20231017182026.2141163-1-danielmentz@google.com>
 <DM6PR04MB6575C45CF299649DF41FD963FCD6A@DM6PR04MB6575.namprd04.prod.outlook.com>
 <52a248fc-465e-4050-8692-5105b6aaa764@acm.org>
In-Reply-To: <52a248fc-465e-4050-8692-5105b6aaa764@acm.org>
From:   Daniel Mentz <danielmentz@google.com>
Date:   Tue, 17 Oct 2023 14:56:33 -0700
Message-ID: <CAE2F3rCcEC=fMd+_gxwksTW=07ZzAt-vA5SO3w8AdAXGy1OVDg@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: Leave space for '\0' in utf8 desc string
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mars Cheng <marscheng@google.com>,
        Yen-lin Lai <yenlinlai@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 17, 2023 at 12:33=E2=80=AFPM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> On 10/17/23 12:20, Avri Altman wrote:
> >> Fixes: 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
> > I think this code goes back to commit b573d484e4ff (scsi: ufs: add supp=
ort to read device and string descriptors)
>
> Hmm ... it seems to me that there was no buffer overflow in commit
> b573d484e4ff but that the buffer overflow was introduced by commit
> 4b828fe156a6?

Thank you for the review Avri.

To me, it appears as if those two commits had different issues:

commit b573d484e4ff ("scsi: ufs: add support to read device and string
descriptors") failed to reliably NULL terminate the output string (in
the case where ascii_len =3D=3D size - QUERY_DESC_HDR_SIZE).

commit 4b828fe156a6 ("scsi: ufs: revamp string descriptor reading")
potentially performs an out-of-bounds array access while NULL
terminating the output string.

I would argue that the proposed fix wouldn't even fix the former and
older commit b573d484e4ff, because that commit might have required
more fixes like using kzalloc instead of kmalloc.
I find that the newer commit 4b828fe156a6 did enough of refactoring
for it to be considered the commit that needs this fix.
