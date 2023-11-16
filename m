Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98875C2BB3F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 02:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344463AbjKPCwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:52:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344514AbjKPCwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 21:52:11 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D8E19F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 18:52:06 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2c83d37a492so3901021fa.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2023 18:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700103124; x=1700707924; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5aRkvCfZ5/Ryh8W2QZqJoEImQ16cBLBAJ0eonaFBJv8=;
        b=gJRErtQwsehhN1FNEKudVp+CUpvzTwaB3bihN/IwdD4XM/6KzJxYBuedBB7Xdca+0U
         AKm2PGYIa2WbndTOviFbUbnQXZHRUhDqPjjEzBZ0ABb2oLzG3y6kf/VHEt7zRfDNhyGu
         Vd/MK1rVW+BRw0WP+Oym2KznWQfODdWoaxmLTXTc7sBgnJ2EY8pqe03HGHJnZpyX2FPU
         KqiJyQKN0C0HZXBEq6TrHa9LYhyIABJFi/rB74d1u7zEHmXsZ5Kteiodh/H4tXmeeiXo
         iyGmPzkhRiLhj/rmsxPBkr6gyWKfMYC/JRfkGnpUNSeB7Y6cwLYlQucvyYW2lROHUemc
         s+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700103124; x=1700707924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5aRkvCfZ5/Ryh8W2QZqJoEImQ16cBLBAJ0eonaFBJv8=;
        b=daqblEq5NyaxPYxwL06mVfy1b7mpWe49oC7o7yd2ewnZUPT7WVrmdGdZrPSbR1HmUF
         qbgME6xoFNEEU8SAbcKhAV3lB072Bx2bXyKZzGFWJMMxBECQlQyt3Ukh+k2oWQsqPvwd
         W+VCcuyxbwOG0siZlAMQVcyIizeQdsZEk1gxcXMMysd74we27P+QAU1RxfjRlox1CXkO
         BzZuT4LdyeQFHlX8PdS0j9ZCb/0j70tmOEkd/m2nrcHmyvLCkMufWY6Z5e20EtWBhY0a
         TzSPhbAseCeDsPgWYeCI0DjkECs+wF8QXUC5IaldkwDeXTxdaYPQV3JclNON9OI5eKse
         3JYg==
X-Gm-Message-State: AOJu0Yw2WHieWlqcUaI5tEOAik4yWSIkECAROc5zSX/6BORTG5DqcqPE
        s22QuIXJVReahPFL0T7IfA2bascCIa538y7cTQ==
X-Google-Smtp-Source: AGHT+IHY9DZHz+C0W6+qIRg8MLNxJHg85rsBn+iyyJOHU8KW6vrjOm5xBNFzETGp3qvt5P4HThGOgST3nkp9PuO9RE0=
X-Received: by 2002:a2e:9246:0:b0:2c5:1f5f:ed96 with SMTP id
 v6-20020a2e9246000000b002c51f5fed96mr5283168ljg.3.1700103124063; Wed, 15 Nov
 2023 18:52:04 -0800 (PST)
MIME-Version: 1.0
References: <20231116020254.10590-1-chu.stanley@gmail.com> <663b4db6-6c8d-4948-80d0-a7bbf75a33b4@acm.org>
In-Reply-To: <663b4db6-6c8d-4948-80d0-a7bbf75a33b4@acm.org>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Thu, 16 Nov 2023 10:51:52 +0800
Message-ID: <CAGaU9a_PHq+QDSfZu=nBqH1DS4Sjj-oy5178jURjn-owW0-TiQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: ufs: mediatek: Fix the maintainer for MediaTek UFS hooks
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, peter.wang@gmail.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

I (Stanley) have left MediaTek, so the maintainer information needs to
be updated.

Given that MediaTek hooks are better maintained by MediaTek employees,
Peter is willing to take the maintainer role in the future, and I
would gladly take on the role of a Reviewer.

I will create a new patch for this change, and Peter, could you please
review it?

Thanks.
Stanley

On Thu, Nov 16, 2023 at 10:33=E2=80=AFAM Bart Van Assche <bvanassche@acm.or=
g> wrote:
>
> On 11/15/23 18:02, Stanley Jhu wrote:
> > Fix the maintainer for MediaTek UFS hooks since the origianl
> > email address is not available anymore.
>
> Why is the original email address no longer valid?
>
> How to verify that the old and the new email address are associated
> with the same person?
>
> Thanks,
>
> Bart.
>
