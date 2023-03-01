Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F83C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjCAXe1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCAXe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:34:26 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A9047406
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:34:19 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id cf14so16274880qtb.10
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aTFrKEj59EWRAdE7B9d0V6M6gJORe8geA2ShFDoI4rs=;
        b=n2TUG0mQCcusVAXCXwdjP0lPJTkG7TnYeftmG7wHkswuZ1JX2LUcveuyr82U1aw2YI
         mU751AejvD6JQT6U9SY8IJWU8zJD2LabJYeQRqT7bYFRcYp1S4reLEqCkt3eOHIHeA/a
         DrSQhx/YCZjb0XGS1rt87kwBIKgQEo1CNmDk4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aTFrKEj59EWRAdE7B9d0V6M6gJORe8geA2ShFDoI4rs=;
        b=BqJTJW1j1ypvDQJ87hcZNlw8XkumHJgFDhOrka7PR5qxu+clngBsNly12nVf8NBw7z
         ucOKwpFEo965z0PjtxQuoNHVwqXel5xTyRYZsbK3reoJ/6hY4tu6kiI57VIf50Mi+Bmt
         /xjhXRexNrmLfFyscjgHG99F+FlrUO973m+6onDTqJl8MXdz7U1gwZqRq4xXg9C/l+2E
         4Id51e5jngmhPET9a8fg7PL9/nzoxwNLlz6IAY+xJ/qUAJ+v15/FGrk8WpzbBz1oRQfg
         O1CIw8JUNrxt3XJStr/Nwt0F+68M2dITbLNA4hSsuhD8iHJwwRIpC0b8XKQBv7m5RTp+
         hfiA==
X-Gm-Message-State: AO0yUKX3wg9xWiT2YZ/U+5fZxA2s8bKyuIVKHcYQjb0axWI2LprHbqvc
        Vp7/br1346TIWcFTFM3lcaB+IsM4hePFvt6o
X-Google-Smtp-Source: AK7set/eWcGMvSd+w0SjyYcw8kJRcT4aYPCS1OuBhaEX/EZPay+BAzYEV7ok/aZzjlwawn0GPZTbYw==
X-Received: by 2002:ac8:5a07:0:b0:3ba:1f09:94ab with SMTP id n7-20020ac85a07000000b003ba1f0994abmr13029080qta.57.1677713657521;
        Wed, 01 Mar 2023 15:34:17 -0800 (PST)
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com. [209.85.222.170])
        by smtp.gmail.com with ESMTPSA id d5-20020ac86685000000b003bfaf01af24sm9215068qtp.46.2023.03.01.15.34.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:34:16 -0800 (PST)
Received: by mail-qk1-f170.google.com with SMTP id n8so5022498qkp.5
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:34:16 -0800 (PST)
X-Received: by 2002:a05:620a:7f8:b0:742:6fd1:3344 with SMTP id
 k24-20020a05620a07f800b007426fd13344mr2029252qkk.12.1677713655972; Wed, 01
 Mar 2023 15:34:15 -0800 (PST)
MIME-Version: 1.0
From:   Khazhy Kumykov <khazhy@chromium.org>
Date:   Wed, 1 Mar 2023 15:34:04 -0800
X-Gmail-Original-Message-ID: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
Message-ID: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
To:     lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HSMR HDDs are a type of SMR HDD that allow for a dynamic mixture of
CMR and SMR zones, allowing users to convert regions of the disk
between the two. The way this is implemented as specified by the SCSI
ZAC-2 specification is there=E2=80=99s a set of =E2=80=9CCMR=E2=80=9D regio=
ns and =E2=80=9CSMR=E2=80=9D
regions. These may be grouped into =E2=80=9Crealms=E2=80=9D that may, as a =
group, be
online or offline. Zone management can bring online a domain/zone and
offline any corresponding domains/zones.

I=E2=80=99d like to discuss what path makes sense for supporting these
devices, and also how to avoid potential issues specific to the =E2=80=9Cmi=
xed
CMR & SMR IO traffic=E2=80=9D use case - particularly around latency due to
potentially unneeded (from the perspective of an application) zone
management commands.

Points of Discussion
=3D=3D=3D=3D

 - There=E2=80=99s already support in the kernel for marking zones
online/offline and cmr/smr, but this is fixed, not dynamic. Would
there be hiccups with allowing zones to come online/offline while
running?

 - There may be multiple CMR =E2=80=9Czones=E2=80=9D that are contiguous in=
 LBA space.
A benefit of HSMR disks is, to a certain extent, software which is
designed for all-CMR disks can work similarly on a contiguous CMR area
of the HSMR disk (modulo handling =E2=80=9Cresizes=E2=80=9D). This may resu=
lt in IO
that can straddle two CMR =E2=80=9Czones=E2=80=9D. It=E2=80=99s not a probl=
em for writes to
span CMR zones, but it is for SMR zones, so this distinction is useful
to have in the block layer.

 - What makes sense as an interface for managing these types of
not-quite CMR and not quite SMR disks? Some of the featureset overlaps
with existing SMR support in blkdev_zone_mgmt_ioctl, so perhaps the
additional conversion commands could be added there?

 - mitigating & limiting tail latency effects due to report zones
commands / limiting =E2=80=9Cunnecessary=E2=80=9D zone management calls.

Thanks,
Khazhy
