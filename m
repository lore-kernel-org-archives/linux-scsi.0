Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D677C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 07:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiBVHUr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:20:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiBVHUr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 02:20:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48137DE2E3;
        Mon, 21 Feb 2022 23:20:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD7FCB8187E;
        Tue, 22 Feb 2022 07:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F384DC340E8;
        Tue, 22 Feb 2022 07:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645514419;
        bh=OQSsfI/rYiou2N7ZTh0DUG0l24IHBrN7xdfpMv6qtaQ=;
        h=Date:From:To:Cc:Subject:From;
        b=SsVuZTBJoj5wKuFAawkg2OU5yO5c6sWFaeqD08ZWWIis0gyYFsK7gsHnP4qRbzPFJ
         oandL0a/3muIDKbW38SIMYynY6N0zGI2TJU6oKe+d/QSUiWWHus6W/ybyXa//2PbVL
         1Kp7bIQPYYi1LEoKIq203KJMvrEsBfU7SUwtRRhCKuCu4ksjYDpyTzR+6XkTGlHAW3
         9GaIIKHI4pQ+a4G/wuwpjgjF83rPzK7nWLB8ypxV53iQPTcrK8S+pa8hf/sEn5OR3g
         9OiG+Ddwc2RwcRXaI0wpbjtbBlO0VX6CzOcEHOGjGAugBIF1yAr4DrYqrcNqny5ivi
         Rme5pryUm7hgQ==
Date:   Tue, 22 Feb 2022 01:28:12 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 0/8] scsi: aacraid: Replace one-element arrays with
 flexible-array members
Message-ID: <cover.1645513670.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series aims to replace one-element arrays with flexible-array
members in multiple structures in drivers/scsi/aacraid/aacraid.h.

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

These issues were found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79

Gustavo A. R. Silva (8):
  scsi: aacraid: Replace one-element array with flexible-array member
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmap
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmap
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmap64
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmap64
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmapraw
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmapraw
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct aac_aifcmd

 drivers/scsi/aacraid/aachba.c   | 76 +++++++++++----------------------
 drivers/scsi/aacraid/aacraid.h  | 16 +++----
 drivers/scsi/aacraid/commctrl.c |  5 +--
 drivers/scsi/aacraid/comminit.c |  3 +-
 4 files changed, 37 insertions(+), 63 deletions(-)

-- 
2.27.0

