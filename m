Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CB9EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 17:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjF1Rwy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjF1Rwx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 13:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463A1D8;
        Wed, 28 Jun 2023 10:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D06856141D;
        Wed, 28 Jun 2023 17:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630D1C433C0;
        Wed, 28 Jun 2023 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687974771;
        bh=WHH0gFQMkPph60tANmhSTj+mN360nHRsNJom4Ty2xHE=;
        h=Date:From:To:Cc:Subject:From;
        b=bARS9dA+p26lSNodIZlHUDFp8apSwmr2GmyMrs/EHADL3SphnlhZXr2D02aoUyg7D
         l0EMwuRwMMOxODqvPH1QW/eqvo0qggWzfTDzkbSVrLjegS07/KSRMxpFC7suVZmK/R
         thieWf4myTK8qR2YqhO5Xn7AyRr1zk73jqWR1ZMpdu3/GDQA1Zqqyk4SRJXSk9u1Vr
         tQg2z284osfJ5h4V/5iEHK4OGNbmveou/sljllSZFdBYDjPzPvW0c3i4E/cDbhE5iM
         tOWLqaGDMftlk6zJvgD0LPEQAtUQ2BBLJQbL/7srqfzXg2D/G1nvkIDIo7x+RU2PQP
         H+Ot87EbSGdIA==
Date:   Wed, 28 Jun 2023 11:53:45 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 00/10][next] scsi: aacraid: Replace one-element arrays with
 flexible-array members
Message-ID: <cover.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series aims to replace one-element arrays with flexible-array
members in multiple structures in drivers/scsi/aacraid/aacraid.h.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

These issues were found with the help of Coccinelle and audited and fixed,
manually.

Link: https://github.com/KSPP/linux/issues/79

Gustavo A. R. Silva (10):
  scsi: aacraid: Replace one-element array with flexible-array member
  scsi: aacraid: Use struct_size() helper in aac_get_safw_ciss_luns()
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct aac_aifcmd
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmapraw
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmapraw
  scsi: aacraid: Use struct_size() helper in code related to struct
    sgmapraw
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmap64
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmap
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct sgmap64
  scsi: aacraid: Replace one-element array with flexible-array member in
    struct user_sgmap

 drivers/scsi/aacraid/aachba.c   | 42 +++++++++++++--------------------
 drivers/scsi/aacraid/aacraid.h  | 16 ++++++-------
 drivers/scsi/aacraid/commctrl.c |  6 ++---
 drivers/scsi/aacraid/comminit.c |  3 +--
 4 files changed, 28 insertions(+), 39 deletions(-)

-- 
2.34.1

