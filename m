Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AA4C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 07:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DAFB61407
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 07:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhKSHlU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 02:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhKSHlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 02:41:20 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284F4C06173E
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2021 23:38:19 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so38833320edd.9
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2021 23:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=fcOZftOIPB4r0uAJLe+Pg56VAFmuAH5o7kKJUEtxQ7w=;
        b=JrNP4f4EnHLdrKVwg4tmxvvKYQHOn+W8wogoY+K374sXI2UA0H899+88MFvCem8aJ5
         X3MrqgM+dlqbmvqHyfByhX4BPhJUGbFxxxg7Y91x9i3u2ZV3oLNe86Qa1q4UT5KXfi/3
         By9jJPX1PAfMLLB8OafLnZjRjt16+piRlgH5MW2GlYjZThxLlMs0DSx0yCUbSaCA/7Fr
         srcGbzV9mFszfv2dTzCpcZkj6ZdaFEsY8jI1LEDVOfCHayH0hhz60Af2U0/kTKBR3PFq
         QJzF48P9S+CPgQLheMDNy+jxnzosadzBbkON9Q8J10nQixrb8JFTEDOFUHnsjp8sKwp8
         nMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=fcOZftOIPB4r0uAJLe+Pg56VAFmuAH5o7kKJUEtxQ7w=;
        b=lhAk4QPJBKejFLA9lr48hLNZSl3w9Ap1CEwnH7lpg7qVQdIkC87QZR2PwTBD7wy+C1
         6BdbuD212xbLHt4f9fQ5nzJQsdu8zgf4qqBdwXyafnsCPHAfLcu08zJjcnHiz0VUH4sU
         H16olhx7CanxjBvULuyXJ8+r+3ukVUwcBDOoolzJK6Z5xrdwRf5vsGT/Ockwjm686lJC
         5K4KhuoWjV8IKiH5yJ85iQ2ofvooEzjV/axPLVFhneorvnpcBwK/p2WUuBpJ4co5leiA
         Zg5ar5giFxecMRytyBbLp4CUpEeBB0ydX6MJOnuhwQQ5cp5u6UiQglhxepwXF/KNyH30
         brXg==
X-Gm-Message-State: AOAM532bP+YwodLz+EP6r+f1V+HM0wemB6sIVOvr/LqqJcGTviVCj5nV
        /GWZneN5Js7jBOk+SIZTY3P26w==
X-Google-Smtp-Source: ABdhPJzl3e3tr3wqllyN2JYawuC7z5WZOElioUzFElEVQo3rNUU9jKhLOL1ITRd1APloUJ9qojdtJA==
X-Received: by 2002:a17:906:fa87:: with SMTP id lt7mr5190544ejb.426.1637307497317;
        Thu, 18 Nov 2021 23:38:17 -0800 (PST)
Received: from smtpclient.apple (5.186.126.13.cgn.fibianet.dk. [5.186.126.13])
        by smtp.gmail.com with ESMTPSA id nd36sm823788ejc.17.2021.11.18.23.38.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 23:38:16 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Date:   Fri, 19 Nov 2021 08:38:16 +0100
Message-Id: <28961370-9842-41B7-8814-DBB20CEEE1E2@javigon.com>
References: <553c2a78-1902-aa10-6cc6-a76cbd14364c@acm.org>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, dm-devel@redhat.com,
        lsf-pc@lists.linux-foundation.org, axboe@kernel.dk,
        msnitzer@redhat.com, martin.petersen@oracle.com,
        roland@purestorage.com, mpatocka@redhat.com, hare@suse.de,
        kbusch@kernel.org, rwheeler@redhat.com, hch@lst.de,
        Frederick.Knight@netapp.com, zach.brown@ni.com, osandov@fb.com,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>
In-Reply-To: <553c2a78-1902-aa10-6cc6-a76cbd14364c@acm.org>
To:     Bart Van Assche <bvanassche@acm.org>
X-Mailer: iPhone Mail (19A404)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 17 Nov 2021, at 16.52, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> =EF=BB=BFOn 11/17/21 04:53, Javier Gonz=C3=A1lez wrote:
>> Thanks for sharing this. We will make sure that DM / MD are supported
>> and then we can cover examples. Hopefully, you guys can help with the
>> bits for dm-crypt to make the decision to offload when it make sense.
>=20
> Will ask around to learn who should work on this.

Great. Thanks.=20
>=20
>> I will update the notes to keep them alive. Maybe we can have them open
>> in your github page?
>=20
> Feel free to submit a pull request.

Will do.

Javier=20
