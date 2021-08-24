Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004D9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 09:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5EF61361
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 09:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235600AbhHXJBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 05:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235455AbhHXJBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 05:01:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D9DC061757;
        Tue, 24 Aug 2021 02:00:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g135so2992396wme.5;
        Tue, 24 Aug 2021 02:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=XEO1yhzoLku7tvsHJMTQJTyi+WzZbv24MbIb7jQ6Mr0=;
        b=RUHn/d/SpyC44+/4IIqEbIY40hgcaGppDyxSK+z1+ya63SHAT+lf7Tn7w2uMg2p/6P
         t2ORZnL4GKxRdE1Hym/gqsgwfO//YPzhwJo6SjQbfPhaKoOni28xBazgaTJm870xQsIW
         D2UpZtTCX1EM6cLel6LOqnfBgyr5huV+N7Rxj0d/C7vqI/BZgbeo7ZHd6ykH94GPuSGT
         v6qf6Ma0wzBloY+UlRI5/VMDlfIakDE+KIrhfzDyZT9Pxbg/tZKBdJGAHJxrTGZySNb8
         MhEi6GYGEcIPQue66P/YPLM0zV2vD1nntPVpcBl0bEHo2L3Qy2F4it7eL8tAFH26ILNm
         O5fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=XEO1yhzoLku7tvsHJMTQJTyi+WzZbv24MbIb7jQ6Mr0=;
        b=NaVcjTP1/gVvM//P6/Sn/65nxzE8mooDJ18YsiLHWyYMWzkCCFjhtthiJpCugCwO17
         YyGqbw1wotunYxTYFlqZWJOu00qZRUUgwZbHOYFEWTbfVpTgIPkPguwIctln9N8OySFY
         AW+R9RdpQvtIhxsKUOsDSnPSsgPNT9mwAR/4In8mZE4DCCPtpLrsxm5F3QfvuL4+pSUs
         648ayEzE/IMWnlZLCZlSa3OCkM/1GVjhuhpH+CggORijP/9x5Axqyi+2FJyjTmhv0sRY
         L/weEbnUeMeFxbTa0cQIVhOn3/y9byxZZssRd0/+kRACD1oMQTpZQ5PtXNgvEgtToVow
         u0Mg==
X-Gm-Message-State: AOAM531vOPLITRc8tumUU/7vRVpSGLBOFQpOAUyNMZUIdYG8xoiRUXhj
        lGD5sG66CCWdi3N/B0PX+XU=
X-Google-Smtp-Source: ABdhPJwB8baGOGuKceNgOWOj063vsmN9XwVRGa3Vc8PFEmzNU7/TFr/bFLE33e0ul0Szs86r1Cp6oA==
X-Received: by 2002:a1c:4d04:: with SMTP id o4mr3095259wmh.82.1629795632876;
        Tue, 24 Aug 2021 02:00:32 -0700 (PDT)
Received: from blondie ([141.226.10.120])
        by smtp.gmail.com with ESMTPSA id y21sm1741639wmc.11.2021.08.24.02.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:00:32 -0700 (PDT)
Date:   Tue, 24 Aug 2021 12:00:28 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Matt Wang <wwentao@vmware.com>, Vishal Bhakta <vbhakta@vmware.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>
Cc:     VMware PV-Drivers <pv-drivers@vmware.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Subject: [BUG] scsi: vmw_pvscsi: Boot hangs during scsi under qemu, post
 commit e662502b3a78
Message-ID: <20210824120028.30d9c071@blondie>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Commit e662502b3a78 ("scsi: vmw_pvscsi: Set correct residual data length"),
and its backports to stable trees, makes kernel hang during boot, when
ran as a VM under qemu with following parameters:

  -drive file=$DISKFILE,if=none,id=sda
  -device pvscsi
  -device scsi-hd,bus=scsi.0,drive=sda

Diving deeper, commit e662502b3a78

  @@ -585,7 +585,13 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
   		case BTSTAT_SUCCESS:
  +			/*
  +			 * Commands like INQUIRY may transfer less data than
  +			 * requested by the initiator via bufflen. Set residual
  +			 * count to make upper layer aware of the actual amount
  +			 * of data returned.
  +			 */
  +			scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);

assumes 'e->dataLen' is properly armed with actual num of bytes
transferred; alas qemu's hw/scsi/vmw_pvscsi.c never arms the 'dataLen'
field of the completion descriptor (kept zero).

As a result, the residual count is set as the *entire* 'scsi_bufflen' of a
good transfer, which makes upper scsi layers repeatedly ignore this
valid transfer.

Not properly arming 'dataLen' seems as an oversight in qemu, which needs
to be fixed.

However, since kernels with commit e662502b3a78 (and backports) now fail
to boot under qemu's "-device pvscsi", a suggested workaround is to set
the residual count *only* if 'e->dataLen' is armed, e.g:

  @@ -588,7 +588,8 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
                           * count to make upper layer aware of the actual amount
                           * of data returned.
                           */
  -                       scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);
  +                       if (e->dataLen)
  +                               scsi_set_resid(cmd, scsi_bufflen(cmd) - e->dataLen);

in order to make kernels boot on old qemu binaries.

Best,
Shmulik
