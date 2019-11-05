Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1730BCA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE0B7214E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 02:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p3FuO+pT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfKECN5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:13:57 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33557 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKECN5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 21:13:57 -0500
Received: by mail-oi1-f194.google.com with SMTP id m193so16125498oig.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 18:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PM1LvB3QEiIRBBqf7i9WTLpzEv2C9oLafyoN3RFaqow=;
        b=p3FuO+pTpMuctaHL6WQcx/AO5CVGHtmt8M7kNiQrOWRmvtRpBxxbVaXHij19K7KVxn
         tt8S7N0q3S13lDj46kbcrNjyYDeY8IRv32omsqXcR/Sat7tEq1gK2IuIjMtBm1XifeGy
         Skbb81MdU35GCrCpNZTq3oAA7xNs+1jJfbQSRu9o96OE/2wOZOTkQvks/PN+nFXOIVd3
         xReZ5a0nDvQcuFCqR6u8E5UJOofavkdnRwL80YoBKH7lkwh7TsO+TcziMJTqXnm6yEUe
         SZXyzw6ckopxfD8MVIlHOlXOOXsoOlNym/dvtNTR/cttV0s8ZpYTNw3AbbNx+/COIk1Z
         T6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PM1LvB3QEiIRBBqf7i9WTLpzEv2C9oLafyoN3RFaqow=;
        b=lyJvmxn3fSx2h9JL3pXggQGYEHylhWR8OFNcn2CY/uh0sy2x9mt9XWD5NcYwp3KL7C
         VpkN0FYbRM7xi9bsN8jVep6LAkad7p3UFgj1G5iLPnGIbyUwGmkN7X0Hj52BAgeDT9Dh
         NCQ1IILXr/aRknPaOx4Ns93NMYPqjHwDxUcLDYKXcX2MNYYM6MhZ4p3ORXB2utFpMmF4
         TnrYmezovS/gR65UDpn27i/Io1H5rrStWcn17LfkB5zzapD1eFkVhhYTlUvB4wbJApMV
         FY9TaTT3ecYDoQYMqMUDtxkpU97nWy4KmTasM5UVo56piBm/EkfCahz1eZLmH37RXEtY
         vLcg==
X-Gm-Message-State: APjAAAXyrYaCJGZ3rc2SftxRWi0yD3EELZNOI30twQV9+V+76d/J+G46
        vh/+n3s3QS1JuWB11/lDJ0Ycvy3nbVZbd+i0pFM=
X-Google-Smtp-Source: APXvYqzNV5FZOxDQXwTGGzx9zpNdjS2u/qO2O2ZD26NJxJ7xzMCHPnq6XpzJTyLfsh6Epl5zcjD7Hkxi6CbFyVAhmNI=
X-Received: by 2002:aca:5413:: with SMTP id i19mr1868234oib.121.1572920036184;
 Mon, 04 Nov 2019 18:13:56 -0800 (PST)
MIME-Version: 1.0
References: <20191104090151.129140-1-hare@suse.de> <20191104090151.129140-29-hare@suse.de>
 <68bfe205-f061-c64c-6205-2f89887719ab@acm.org>
In-Reply-To: <68bfe205-f061-c64c-6205-2f89887719ab@acm.org>
From:   adam radford <aradford@gmail.com>
Date:   Mon, 4 Nov 2019 18:13:45 -0800
Message-ID: <CAHtARFGkszxOsDEjmOq6BAK5H++r0EKqF3A411Xmi7RZw67egg@mail.gmail.com>
Subject: Re: [PATCH 28/52] 3w-xxxx: use scsi_build_sense()
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 4, 2019 at 9:52 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> > Use scsi_build_sense() to format the sense code.
>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>

Acked-by: Adam Radford <aradford@gmail.com>
