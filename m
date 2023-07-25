Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C82C0015E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 16:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjGYQTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 12:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjGYQTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 12:19:34 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 25 Jul 2023 09:19:11 PDT
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57132129
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 09:19:11 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690301950; x=1690309150; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Subject: Cc: To: To: From: From: Sender: Sender;
 bh=WvsRPcat3uxMMRmKyeqCHUTRDfz2SfBv2BE/yxjT+xg=;
 b=hdJsnVCH9+iFqsDZtfWk2NAOMSrTIGKoky31Vc/28tLliX7XSf9DfYLrfL9SbbHhE76KPuPXaA88GWwB/r++5ejDjRVrqvI5hBR+Ah4FWHiHGO3eOLcIV53ZW5wmaAIRpaSVMbXNK81nf89iKpv2hszDPqEomsYTWuUnqKHqF2oQaIm/4bfZD4G7MdJFX1yJ9y4pyMGdeI8fGqVU2zb2hAYgIOEU2FQVOMnBEkQduRivoLwIzOEEx+Bymz0hurMYrJYeDqsE+5ikZ8sVyzmXOCHKxwZhqeZQHOCeX12kPDalbuYWUxzxp0R1L7TeK4Gi8ZUGkhAY2ozemnPRCNhaoQ==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by d53bb90da10c with SMTP id
 64bff4d113929ab6cbff2c7e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 25 Jul 2023 16:14:09 GMT
Sender: james@equiv.tech
From:   James Seo <james@equiv.tech>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     James Seo <james@equiv.tech>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] scsi: mpt3sas: Use flexible arrays and do a few cleanups
Date:   Tue, 25 Jul 2023 09:13:25 -0700
Message-Id: <20230725161331.27481-1-james@equiv.tech>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") has
resulted in the only arrays that UBSAN_BOUNDS considers unbounded
being trailing arrays declared with [] as the last member of a
struct.

Unbounded trailing arrays declared with [1] are common in mpt3sas,
which is causing spurious warnings to appear in some situations with
UBSAN array bounds checks enabled, e.g. when more than one physical
disk is connected:

  UBSAN: array-index-out-of-bounds in drivers/scsi/mpt3sas/mpt3sas_scsih.c:6810:36
  index 1 is out of range for type 'MPI2_SAS_IO_UNIT0_PHY_DATA [1]'

which relates to this unbounded array access:

  port_id = sas_iounit_pg0->PhyData[i].Port;

and is just one example of 10 currently occurring for me during boot.

This series converts most trailing arrays in mpt3sas into proper C99
flexible array members. Those that really are fixed-length arrays of
length >=1 are left alone.

I didn't find any conversions that required further source edits
besides changing [1] to [], and everything seems to work with my
SAS2008-based add-in card, but please look things over in case I
missed something subtle.

Rounding out the series are some opportunistic cleanups.

James Seo (6):
  scsi: mpt3sas: Use flexible arrays when obviously possible
  scsi: mpt3sas: Use flexible arrays when less obviously possible
  scsi: mpt3sas: Use struct_size() for struct size calculations
  scsi: mpt3sas: Fix an outdated comment
  scsi: mpt3sas: Fix typo of "TRIGGER"
  scsi: mpt3sas: Replace a dynamic allocation with a local variable

 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h         | 231 ++++++-------------
 drivers/scsi/mpt3sas/mpi/mpi2_image.h        |  32 +--
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h          |  27 +--
 drivers/scsi/mpt3sas/mpt3sas_base.c          |  28 +--
 drivers/scsi/mpt3sas/mpt3sas_config.c        |   6 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c         |  18 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c     |   9 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h |  44 ++--
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c     |   3 +-
 9 files changed, 135 insertions(+), 263 deletions(-)


base-commit: 7e9609d2daea0ebe4add444b26b76479ecfda504
-- 
2.39.2

