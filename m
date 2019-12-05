Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D347C2BD09
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 14:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CBE2464F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 14:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=blockbridge-com.20150623.gappssmtp.com header.i=@blockbridge-com.20150623.gappssmtp.com header.b="CuuoiKed"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfLEOoW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Dec 2019 09:44:22 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:44366 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729187AbfLEOoW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Dec 2019 09:44:22 -0500
Received: by mail-ot1-f43.google.com with SMTP id x3so2742599oto.11
        for <linux-scsi@vger.kernel.org>; Thu, 05 Dec 2019 06:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blockbridge-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7s4JQTEdjPmFNYaI5B29BFTXVQs+UKOANRkCHolsJ14=;
        b=CuuoiKed4MEPD9+MqamEqAcFzgwxZsWo1rNXQ9lYrvqTdTUxiPXH9onz9z60JDj4V+
         8YRnpfO/Y1pCWtVlb/qbbcnZE0JDLqgONNLG3voHqdPbX8Nnl41ZM6Aq47rU2+0HKlN4
         JNXobe63xWFMHcW4e3sLN2LMqjAkMx//9WlADwmOWEXr2cvbEZQFQsCYxtKQ/OoKKxXo
         Mjkd/e1h33kSt8R8OLHm//0hyO/a1fiO4nV2t6r5Ug0dY7DS/6Z5tVL/5633HHVDNKjt
         BEl7U3afeGnk9NDWvlFcud+uNr3cth2Bo9dgBqsAq5dDYRP4eXO4gnAVvKfmS6eNgjGK
         8Sag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7s4JQTEdjPmFNYaI5B29BFTXVQs+UKOANRkCHolsJ14=;
        b=qzVBDEAWzGlQGq/f3IikgBZx+zrrvzJ5KqqMB8LQJh11lANw8yA1mIcla8LQe1TylJ
         XGL+coge1xI6fNjGVRRxd3BVGM9C/grbewhqULtd+izUJTkYVPVTdhzLtWLxcGza1hN/
         r03LDRe0Oyqg1u6x2NDySpxuL0ffGsipMIyLyArC4N2IUihnGRnHJ9MjVuA1KkCFVA9k
         qZt+jplTzgNggPEgSaASnsiCQLzo+7qUpIBoEUsBUVJ0Lqs4NXuyxYA9VoBZqbY1EsyU
         shl7y1E6QBSdbFart/tjNt/Zj2VKpfNpv+rX7IF9HMHnfKYz9dcusrgswvJpqgfM67Um
         /gDA==
X-Gm-Message-State: APjAAAUWeg31BXygYJRVTShspSWlN6JsiWxwRV73UhrkRo+49CLsVwjW
        V/wok9+9E0qFAO4MmYuK3eY03K0ebF0HSOSeZ4P3lw==
X-Google-Smtp-Source: APXvYqxexfBfOd8xUtRQNR5HIQ6mQugnieMgIjTub1FS+7nvU8GGRglLUM4azifsJW1OZMvCMRt2xHV4PhCOe1O+yOc=
X-Received: by 2002:a05:6830:1248:: with SMTP id s8mr6774044otp.202.1575557060619;
 Thu, 05 Dec 2019 06:44:20 -0800 (PST)
MIME-Version: 1.0
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p> <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p> <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
 <20191204230225.GA26189@ming.t460p> <683a4567-6b34-ac3b-93ff-74d788ac4242@acm.org>
In-Reply-To: <683a4567-6b34-ac3b-93ff-74d788ac4242@acm.org>
From:   Stephen Rust <srust@blockbridge.com>
Date:   Thu, 5 Dec 2019 09:44:09 -0500
Message-ID: <CAAFE1beNvij=QpqrmNgkm32QtRoXwGtR81YbS0ute5XBMN7d=w@mail.gmail.com>
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Rob Townley <rob.townley@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 4, 2019 at 7:16 PM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Do you need the iSER protocol? I think that the NVMeOF and SRP drivers
> also support RoCE and that these align data buffers on a 512 byte boundary.

Hi Bart,

In this case we do. But thank you for the other references. Those
might be options for us for other use cases.

Thanks,
Steve
