Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E6DC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F13E020702
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 20:04:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QMaFma6G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbgGFUEa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 16:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFUEa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 16:04:30 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A7BC061755
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 13:04:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u64so29547413ybf.13
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2020 13:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mLrV267krfnG4UahJTU8+79Ss2BiwzpfkO5ANm3FUGU=;
        b=QMaFma6GRnMj0tav11JHovVYSRbXwyujxKE6b5rE/zyoZJ+ZtWGHTtXQxJ3LkybR5z
         97TnSQDP0+mVNjOx7bExDt7CKTwPcXKMrtwLwoSqN8F+KIwz/Miqxd+Rwzld0VqVY/U5
         wAh+yj0rv3HmhePSUfQopJBevoJicKkNVi6pi+dztFcuDzfKn5XTMtQdFjaUvscWtiAH
         zlqPpXVqqtGwjXEIAL5XN3Ys/DDvc63UieX+XqnmKdN2kcz7gihvWfvMhfQqWyoIDasT
         k0zTZj8p3xlW9cwb6qLajnS/OrsHguRza/NxaVZaJ52yOw54Wx4fuZ+v+gsiSWngqaZa
         opJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mLrV267krfnG4UahJTU8+79Ss2BiwzpfkO5ANm3FUGU=;
        b=QyBovihNEDOt+nHYSaPtVUf8YyPWK1NmlPJ8e3ePDipH/tiUVZhDsz47gAYThaBx+u
         k+WW2k7uqjj50zToGSweB8vCWr+XLtl1GGR1zmjNxkXXRoXUTcc+aJQY9514obmLQ7Wv
         pZPh6Xap1SHD693VZGURCvUc/SQgHTBfD4UMUOyIo8eXeQieSQu6wvKXW+LPmIyRzd+9
         aNsKX9UgeSQGxwHINuyEDGa/JMm8eH2uITVJ0stHdJTbY7Kqwth0SLt85arRBaLXjbPD
         SpClG7Z7zYcei7cqsXHK/F/sIngALoyyXs8eQlFZ99AkSCh09Bl/PsnB3ak272zPY//6
         YN0w==
X-Gm-Message-State: AOAM5309is/o162htGNsxBZfJPEneV4J2QjI3zNIaB+4vu9k9Q3axyms
        ozoYDmnm29CNdcbNz1CGEAbY+e1pM5EBPX77CGEs3uzUV4T2lAgvU1i6plaZiLZKPGMlGRrTT+b
        FqSS+IDbwWwo8eabjy7qs8MkbgqeGubhFfTiIa08t4voyMnRWEhdhpQmKH9FQS8GC3rA=
X-Google-Smtp-Source: ABdhPJzi5CzrqEkbwqBkBs8DsXeQAi2j1QzYScnWsRXeDKvzBntpOX6o69o6ndWTtz2kCm8l6sotdm/T47Q=
X-Received: by 2002:a25:908d:: with SMTP id t13mr78397769ybl.450.1594065869459;
 Mon, 06 Jul 2020 13:04:29 -0700 (PDT)
Date:   Mon,  6 Jul 2020 20:04:11 +0000
Message-Id: <20200706200414.2027450-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH v4 0/3] Inline Encryption Support for UFS
From:   Satya Tangirala <satyat@google.com>
To:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds support for inline encryption to UFS using
the inline encryption support in the block layer. It follows the JEDEC
UFSHCI v2.1 specification, which defines inline encryption for UFS.

This patch series previously went through a number of iterations as
part of the "Inline Encryption Support" patchset (last version was v13:
https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).
This patch series is rebased on v5.8-rc4.

Patch 1 introduces the crypto registers and struct definitions defined
in the UFSHCI v2.1 spec.

Patch 2 introduces functions to manipulate the UFS inline encryption
hardware (again in line with the UFSHCI v2.1 spec) via the block
layer keyslot manager. Device specific drivers must set the
UFSHCD_CAP_CRYPTO in hba->caps before ufshcd_hba_init_crypto is called
to opt-in to inline encryption support.

Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.

This patch series has been tested on some Qualcomm chipsets (on the
db845c, sm8150-mtp and sm8250-mtp) using some additional patches at
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
and on some Mediatek chipsets using the additional patch in
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/.
These additional patches are required because these chipsets need certain
additional behaviour not specified within the UFSHCI v2.1 spec.

Thanks a lot to all the folks who tested this out!

Changes v3 => v4:
 - fix incorrect patch folding
 - some cleanups from Eric

Changes v2 => v3:
 - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slightly
 - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabilities
   and ufshcd_init_crypto. The first function is called from
   ufshcd_hba_capabilities, and only reads crypto capabilities from device
   registers and sets up appropriate crypto structures. The second function
   is called from ufshcd_init, and actually initializes the inline crypto
   hardware.

Changes v1 => v2
 - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status

Satya Tangirala (3):
  scsi: ufs: UFS driver v2.1 spec crypto additions
  scsi: ufs: UFS crypto API
  scsi: ufs: Add inline encryption support to UFS

 drivers/scsi/ufs/Kconfig         |   9 ++
 drivers/scsi/ufs/Makefile        |   1 +
 drivers/scsi/ufs/ufshcd-crypto.c | 238 +++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-crypto.h |  77 ++++++++++
 drivers/scsi/ufs/ufshcd.c        |  49 ++++++-
 drivers/scsi/ufs/ufshcd.h        |  24 ++++
 drivers/scsi/ufs/ufshci.h        |  67 ++++++++-
 7 files changed, 456 insertions(+), 9 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

-- 
2.27.0.212.ge8ba1cc988-goog

