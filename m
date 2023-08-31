Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E54FC83F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Aug 2023 05:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjHaFx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Aug 2023 01:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjHaFx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Aug 2023 01:53:27 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537AE1B0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:53:24 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-1a28de15c8aso217185fac.2
        for <linux-scsi@vger.kernel.org>; Wed, 30 Aug 2023 22:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693461203; x=1694066003; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMh3VyeNu3uiJvJou94GeQzJln+WG8dlIX+Kz52julQ=;
        b=CWqaAPv8Wtsek5yq2VAcnZbpSN1KL8xyTTxO36uFCJogvel4b65ZSSTc13qwscN2f7
         yI5VhGigrtK+282uax7jOo4USNYJi7VVcvuvwsiZs4OPJ/+oCa9mtDDcFQicL51S+BQQ
         hGccL3fuay0nPYqi7MJVG2C+P23A5r94jonqvQWCkWtTwa51MNcdqYNwfMPBEVs6cc11
         IJczn25NAX5rhhSMI75TV5TDvush6yTNb4/gn2XXFxFb6BWadoo8XZ3S59ohGwsU+bOX
         CMhaOSWvnPtqktoEASRT/eJ5T91ge6Yp7T/0gTHsGiUkkR/txR1OtPi7Yfrd8NyYP3CW
         IqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693461203; x=1694066003;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMh3VyeNu3uiJvJou94GeQzJln+WG8dlIX+Kz52julQ=;
        b=kxVdEYBt7ghbQ4quVGxapO4xksgFIStuQGqXT9azNMqbir0TVwnqLb+1/CgV60HGd8
         COP0Ct29InWzmBew6rl6pXMMdmweknYXoUpK1V5W/81Z9ad9iuguLWdBHy77m5T0EN7Q
         5VNpt8GHdRuacY1QvfkFifit3UuvHHTJkTgaF550KLeR6yYnv+J/G/iSw+W3NQWUpB2j
         olhnzbnj8qamLSHI2cmQUgS3vj6OmY53QqnwK1mWoJmB7qZgEMrW5EtyFcy6jmL+kd8X
         g/S2BFAeVgupD1xY5Pp44jy2jkBz0EB1gYA1D5zbdod8LxusWAZKlQZYHYQzveGeaFxM
         bdaw==
X-Gm-Message-State: AOJu0Yz8XYveg+O6qFKRU8v7nQFkv9pw2NhdPK6ghK/bNgELU/OdFUip
        vEo0pAZ3zgXJOYGtkMX5c8Kq7h5Ty5dLlCfovtRgFaOu
X-Google-Smtp-Source: AGHT+IED+yhPXsVqbbVHOjxyqFkEiY7J9f3hbf3NWctBwXNb4f1h7oQyIyv+vhuVqGt8PGVvBXJX2XoCAp+meS+6KxU=
X-Received: by 2002:a05:6871:71f:b0:1bf:62d:6ea3 with SMTP id
 f31-20020a056871071f00b001bf062d6ea3mr5659316oap.20.1693461202877; Wed, 30
 Aug 2023 22:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230807155856.362864-1-alexhenrie24@gmail.com> <20230807155856.362864-2-alexhenrie24@gmail.com>
In-Reply-To: <20230807155856.362864-2-alexhenrie24@gmail.com>
From:   Alex Henrie <alexhenrie24@gmail.com>
Date:   Wed, 30 Aug 2023 23:52:46 -0600
Message-ID: <CAMMLpeQ4F50bxY8kcOQx5W1t4PYRNrd-JNm3vP2_OcjosDqO9A@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: ppa: Add a module parameter for the transfer mode
To:     linux-scsi@vger.kernel.org, linux-parport@lists.infradead.org,
        martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 7, 2023 at 9:59=E2=80=AFAM Alex Henrie <alexhenrie24@gmail.com>=
 wrote:

> Add a new parameter /sys/module/ppa/mode to set the transfer mode before
> initializing the drive.

Just noticed another typo: The file is /sys/module/ppa/parameters/mode
(I left out the parameters directory). Hopefully that doesn't confuse
anyone too much.

-Alex
