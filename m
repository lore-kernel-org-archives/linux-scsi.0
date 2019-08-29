Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A10C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C56F72166E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:50:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mF6BZy/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfH2PuC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:50:02 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:37952 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbfH2PuC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 11:50:02 -0400
Received: by mail-io1-f45.google.com with SMTP id p12so7890684iog.5
        for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2019 08:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=D12yczZaTC/S+CJHiRlFxphGcTx9y5WZVxMU7TOeq34=;
        b=mF6BZy/No7+e7a5YFiwDmKmdhriTUeHTGN7xgi4ruqgm6H1b80AqknMPolQgbCfRVN
         YZFqqGRaP5BCBiqSvPK7jhJr2oS69E5+uDwjbeDDuzUQcU1+InqeU0XN17zmsAzLlTQ2
         7MH5ykWVYzVl3Ub0fWl3wh6an0cMb2f+n74uX1OC5NiCelF8v15Ks9H7m+n0o5IH0JOj
         XVHKaP7OmJkGWD3Cp+MSSGP2FXBeHbpeCW65HVl9Wllz1N6s5FySlFBvAa8v98d0K8y6
         6NFBuTalFn/N3lT8Rvu8Fdycvm9oXSQJoa1VvZq3tnLJmvKPY2E6lA2nNXdLrVD8r4Wq
         hCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=D12yczZaTC/S+CJHiRlFxphGcTx9y5WZVxMU7TOeq34=;
        b=WwkGYurtY0BN6kCpkO5huYIJhkw1oXeixbtcT273V98kEecKMfXGZwHQ1WZcGgcZS0
         ypMdrjy2fzZtrNqj3dJZb0GKajOQONCBoQf545UzRJPZYxOsvdQn+1uUzjkqxODPFZiD
         /ERqfEhcZAPRIN2BOxmuVGCxdqgSYSNiroxZVceQ15A47U7ruYWOBR1a6vMkz5Pi2P8d
         lWeZoDGV8ZUQDnE7epdppzhq+wYiARtKbgxTZfSze9Ga6tZbineiJZ04oCyJyVKvqGjb
         4B8Ns9bRkYtf4Fk1sVtT7G5TI07oV9iIXLsJG/J721+jW8+JoBCun7Sp+kaaLNrDjes3
         02+Q==
X-Gm-Message-State: APjAAAV0VR9ryJ2YgBb8e4nZtcyhnlfxjrR6YAfQeyC7cvCfCZb1vPsx
        PLPAggrsYVk7aOv1rfuf5z0NsCsVEjD2aWjqpmJSyw5gsJI=
X-Google-Smtp-Source: APXvYqzVvMXzwLKYrNkOys87A8/EO/qlqa+jTpjhcnlPbT3NV6iAlTS4O4ru56P5dELFesIT6frIa8HvK4DZbjMmTf8=
X-Received: by 2002:a5d:8e15:: with SMTP id e21mr5668402iod.296.1567093801506;
 Thu, 29 Aug 2019 08:50:01 -0700 (PDT)
MIME-Version: 1.0
From:   Andrey Melnikov <temnota.am@gmail.com>
Date:   Thu, 29 Aug 2019 18:49:48 +0300
Message-ID: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
Subject: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to SCSI_SCAN_TARGET_PRESENT
To:     Li Zhong <lizhongfs@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello.

This patch break exposing individual RAID disks from adaptec raid
controller. I need access to this disc's for S.M.A.R.T monitoring.

Please find other way to workaround bugs in IBM/2145 controller.
