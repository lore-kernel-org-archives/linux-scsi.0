Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40499C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15604205ED
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 15:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbfH2P7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 11:59:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59701 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfH2P7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Aug 2019 11:59:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A4111256C5;
        Thu, 29 Aug 2019 15:59:34 +0000 (UTC)
Received: from manaslu.redhat.com (unknown [10.35.206.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 926A15D712;
        Thu, 29 Aug 2019 15:59:31 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     cleech@redhat.com
Cc:     mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and SHA3-256
Date:   Thu, 29 Aug 2019 17:59:25 +0200
Message-Id: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 29 Aug 2019 15:59:34 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS compliant.
This is due to the fact that CHAP currently uses MD5 as the only supported
digest algorithm and MD5 is not allowed by FIPS.

When FIPS mode is enabled on the target server, the CHAP authentication
won't work because the target driver will be prevented from using the MD5 module.

Given that CHAP is agnostic regarding the algorithm it uses, this
patchset introduce support for two new alternatives: SHA1 and SHA3-256.

SHA1 has already its own assigned value for its use in CHAP, as reported by IANA:
https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-numbers-9
On the other hand the use of SHA1 on FIPS-enabled systems has been deprecated
and therefore it's not a vialable long term option.

We could consider introducing a more modern hash algorithm like SHA3-256, as
this patchset does.

A pull request for the open-iscsi initiator side implementation has been
submitted here:
https://github.com/open-iscsi/open-iscsi/pull/170

Maurizio Lombardi (4):
  target-iscsi: CHAP: add support to SHA1 and SHA3-256 hash functions
  target-iscsi: remove unneeded function
  target-iscsi: tie the challenge length to the hash digest size
  target-iscsi: rename some variables to avoid confusion.

 drivers/target/iscsi/iscsi_target_auth.c | 218 ++++++++++++++---------
 drivers/target/iscsi/iscsi_target_auth.h |  13 +-
 2 files changed, 147 insertions(+), 84 deletions(-)

-- 
Maurizio Lombardi

