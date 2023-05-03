Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5A22C77B75
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 15:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjECPIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 11:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjECPIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 11:08:30 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CF05263
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 08:08:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 2adb3069b0e04-4eca9c8dd57so1039838e87.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 08:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683126504; x=1685718504;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1FOOYbd4dNFDyiEsaPE2X+b61t9SVPlgw+HWMJw8nPQ=;
        b=KXLTOaI+nreEIJyqlVxzqqz1h5Ox8lWjYXZc31tDwbsybHfkUrrg/slA+OPYnxOcjn
         uEhGMEwN8tAMOfrn10GIIJwYAZY1dZiHDh0DnxpB3yfZlyDyL9bt3ABozRrjW0bt1+Uu
         whYejy7SYn1wrnbqzKlz+ys4IcXn5JHo9yoC3cMfzBeFueyVrSE0kHNnT+lh/ZLak0AR
         u0J/0g/8y/z0DafITHcIK+a3YPRJE1gOJl9Cxaj7sQiYrfa5/kdWyEb3HlITD094yfLM
         Y53Wc1afBsKgaZmJqatgS/JzelRaOb7tqsuVji4slbxiigcli1qdFVbA7wcPUjkTJa4u
         VPiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683126504; x=1685718504;
        h=content-transfer-encoding:subject:to:from:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1FOOYbd4dNFDyiEsaPE2X+b61t9SVPlgw+HWMJw8nPQ=;
        b=Ake39ebp/nu84Jf5JIhtVaQ013vhfi25pzFTyM/msPwhn2MrO4TsCVz0bVT4XJjVoj
         u+t6EAkIzpPDQkTwwlMEgipuys1TzEIgBAzc1h7DPCpYJ3Fu5EMzz0jVmC4lhfCXQ4Xe
         lg0I+Kf/AD9Mjf9gzB9VaTtj8JQRdbLH9ibb+yZ8LE0r7DhNdB3m3ih+ccAgSW3vGClA
         ocFlCvHViH/mJcuvpYddJjFO39wXmel2rkOAGqCtjn6SHOR8jI6/soMb3Ul/suQ5ctMk
         BZ1WWyHhXKk0EfvRVCN0fJlwFB1YiRBdTfo4yUZAnX9QCZW5qq0L21GGgYwNaZ+r5FRx
         SKeQ==
X-Gm-Message-State: AC+VfDzj7bTN5qaO+Gqb65Lz9q9Um/TmqfzSpPEbBh5ulqnXpb4e9lIS
        0h0zjBypCrdQqTlXNxSFEOQ+VrFbCg0=
X-Google-Smtp-Source: ACHHUZ4FMwsn7u3HE5rJWU5KStIUUX/gsdmAD+wuScdWol35atuROSobOh7441ISFg8OR7qCi4+xYg==
X-Received: by 2002:a05:6512:4cb:b0:4f1:3d76:d1a2 with SMTP id w11-20020a05651204cb00b004f13d76d1a2mr310274lfq.0.1683126503734;
        Wed, 03 May 2023 08:08:23 -0700 (PDT)
Received: from DESKTOP-BKF2J9E ([203.109.40.79])
        by smtp.gmail.com with ESMTPSA id z12-20020a056512376c00b004eb4357122bsm6052199lft.259.2023.05.03.08.08.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 03 May 2023 08:08:23 -0700 (PDT)
Message-ID: <645278e7.050a0220.2da38.1197@mx.google.com>
Date:   Wed, 03 May 2023 08:08:23 -0700 (PDT)
X-Google-Original-Date: 3 May 2023 20:08:23 +0500
MIME-Version: 1.0
From:   erwinshrader438@gmail.com
To:     linux-scsi@vger.kernel.org
Subject: Estimating Services
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=0D=0AHi,=0D=0A=0D=0AWe are an estimating firm and offer our serv=
ices to GC's, Sub Contractors and Architects. We perform commerci=
al and residential estimates & takeoffs.=0D=0A=0D=0AIf you have a=
ny job for estimating or designing just send over the project pla=
ns/details after reviewing the drawings, We will give you 85% off=
 market price. You may also ask us for samples of our recent work=
.=0D=0A=0D=0AThanks.=0D=0ARegards,=0D=0AErwin Shrader=0D=0AMarket=
ing Manager=0D=0ACrown Estimation, LLC

