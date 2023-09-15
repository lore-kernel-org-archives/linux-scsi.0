Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38443CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbjIOU6h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbjIOU6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:58:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B7A34223
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694811324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DdoKwP7HgnHWLqDfZabq1sIcd5gH5v4vEdMCEXt6Ly0=;
        b=Pysp7GVORvz8DRi9WpB3CP51CLLG8/FElBCz1L1Dd3BLHqGQFYvGMOo5Vksg44ixXiJsDs
        7PREdeH5WpYN/2L7fzkALo7e/5mbH+xLE70JGowskb82AKz5x5a+7hS3MMeGBmKjg6lWRv
        rVjTGDkKNDiudm2gpFbG/zv98+xjrIA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-pjdADCsYN4uONiW6jaUsAA-1; Fri, 15 Sep 2023 16:55:23 -0400
X-MC-Unique: pjdADCsYN4uONiW6jaUsAA-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-59c240e637aso9321177b3.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694811322; x=1695416122;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DdoKwP7HgnHWLqDfZabq1sIcd5gH5v4vEdMCEXt6Ly0=;
        b=ZX24yWIUWlqn2kal/zpRqwZsHzuZV6b5dmADWottvXItLer+8IHGWiYnwh3O/3bFzt
         LWw3B6opJqxEMRelWxnaVOWKAbSMmSObCJMOFZI0cpEZhzrNUtKSLXVf3bjA1aMh84Wy
         z5DBV0aqAgUg1o3vg0YnvjmcfhAyp59mqiXH9/OEsYBy3sJD9DVj4uhsy6Kzh8F1Cyk+
         hr0yPObb5taMQgEYJJ+gXsYRuOXicR7gTiqakVSERkjBVU6dhCHLekvZTszbMW1ZnwO0
         G+QS10ac3PgJJFtS/njmc8u4NWS0Zqyvo1GpqtTIxMi8CI8fkVCFG7EX/bZgqFuLkfNA
         3nmg==
X-Gm-Message-State: AOJu0YwiaGY3eSTzksNIbHfnzsTL24yjfQjQPCRV2+bfVT+izxh/PhY7
        3Rz7Lr+CqXIXEi/rCk0myQu3bSdMvh9eDhcluGPTabn84CINC90xdUg3Wxwop3QM+ImD/NYabZ8
        NPi6C2tzWNcDWm6Qtd4yhpg==
X-Received: by 2002:a0d:e941:0:b0:598:7836:aac1 with SMTP id s62-20020a0de941000000b005987836aac1mr3059524ywe.49.1694811322639;
        Fri, 15 Sep 2023 13:55:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIwQ0nhWnzno9U/kwLTYNXLsOsjYs8d+Bel98jkFFqWvusmdJqmKCr2zouP+J1fCiJojuDpQ==
X-Received: by 2002:a0d:e941:0:b0:598:7836:aac1 with SMTP id s62-20020a0de941000000b005987836aac1mr3059513ywe.49.1694811322367;
        Fri, 15 Sep 2023 13:55:22 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id n192-20020a0dcbc9000000b00592a0cad26esm1040201ywd.26.2023.09.15.13.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 13:55:21 -0700 (PDT)
Message-ID: <7611d95d0aada3814a5b140661b3b5188b8b86bb.camel@redhat.com>
Subject: Re: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to
 6.5
From:   Laurence Oberman <loberman@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>, bugzilla-daemon@kernel.org,
        linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Date:   Fri, 15 Sep 2023 16:55:21 -0400
In-Reply-To: <41689a20-af9d-420f-af4f-72e299a765b7@acm.org>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
         <41689a20-af9d-420f-af4f-72e299a765b7@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-09-15 at 13:42 -0700, Bart Van Assche wrote:
> On 9/15/23 12:33, bugzilla-daemon@kernel.org=C2=A0wrote:
> > The users loqs and leonshaw helped to narrow it down to this
> > commit:
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3D624885209f31eb9985bf51abe204ecbffe2fdeea
>=20
> Damien, can you please take a look?
>=20
> Thanks,
>=20
> Bart.
>=20
I had a quick look at this and its not making sense. The only calls I
see are in the scan when the devices is added and in the re-scan.
It should not be consuming the scsi_eh thread unless some type of udev
events keeps happening.

Would be good to get some
cat /proc/<PID>/stack of the scsi_eh threads if they are constantly
consuming CPUY

I will try reproduce and try figure out what is going on here.

Thanks
Laurence

