Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44272C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083B564ECA
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 21:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhBTViB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 16:38:01 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:14596 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTViA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 16:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1613857080; x=1645393080;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ximxbd4So5TBxiG6d7kSZxe1HGelbfcoEPLBr5LT/FE=;
  b=Q2Ymn3eermu8PJ0d45BWHJbWlHnAgEBjpyX6Ky0M657WVh3W24unWfRy
   CR7sExF890K+bu4jQPGAoB8rdFRKO9eTjrt0sB+C5CHjTb8kfWaAIcbhY
   OsMved9ugpkeySnrxq09TFIC4qFMmpvu/gyiKoes3KaGErWOgwDFnWCp2
   0SamXYnPLHZRSc9JmZSwNgHfV1yGaBiOVC+5lo+6t/+EUC7JRepcwXMxq
   hk7r/1I0CakAuqE/Osc2RiT8zxU6peAwy9gSTSWYQsFmXxM2Yy30UZuSK
   vX3+915EqYTJcWfaclJgglh18pNVd65GoLH8mk0GM2OpxesHs5P6Ivqru
   A==;
IronPort-SDR: xZuaM93h5XPffR60/Qr+vVj8MorefZ5fZIbKgjyCmW4ZwNTmZPoCR8HzU4t8rGDGW+/wmciivC
 JE6GRLR+QcihHfAFhCB62GBH8/Y9adrTfC3QY+YSEJ7w1bh47BAqYXIwXJwqRj4rcNJkXNnC8v
 i4M5tGMhS3w4l0bgA4oaH75YoRB5vEjsizU2JKVcg/fPc3G/ABqhKCV5ugspkseB55xjulhZoJ
 e5hHM3ISIkrXTuR2R2knvw9PL4fSC3CjAuhtO41N8n6GRYGpCgZ+09PpYVN7ReogXbNyiz15lz
 d6c=
X-IronPort-AV: E=Sophos;i="5.81,193,1610380800"; 
   d="scan'208";a="161591256"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2021 05:36:54 +0800
IronPort-SDR: KiLq/GV+IASuiafKIp/Rs7ebgO3WY4OZ6PEOHok9aVkJgFGqcYjtGXXzedje0wbFdGfV3UaNBr
 FFktpxarjfiC3wjgnlwFJ+uOhuiTmOCBExMrsavOiJJ91L/5w0QC8BEktU/dE2sTx/2vjE1hV4
 CPK3y8ebE55GgJNFNF0mXkkV+7tdlSby3HQV0z+Mc2lOFto4S7RG02bCliS40dpcmXzKsOeF4x
 Rz1vMMdXLTLviikPu7R3E9nKR1rJEZU1Yo71Gq1VZprL0R8RLYB5+lzbVRB6uKnH4VxkLWnCFb
 gr3AZvkw+WNlRgRdCkjqCyhT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2021 13:18:28 -0800
IronPort-SDR: F3tB+vcxXTKbgYUz+ZG7zYUKsXG3rZxguGcMRmmVXMRf2oRr3w5VdkW79SBblBTxB3oevQtxxV
 vzKZ9MOLvy9b9JUf9ZfDdXMb7bbfnWe4OhunW45ki1hiC4e9JPhqgnEXROLI3I4fqHlxHMF97R
 DPqSZXlF7oTHeVtD2RH+bAwBjCtZyonMjyl94nocWaW9axszYXHzomkUFxE2oZC8e+uzGDIoxz
 omEj5FK8wNuOiqCwcltSFXlSDtNdhzbAyr+8iF0cfLgwkvpgc0LYr5//W+pxFZiVKmlmOtKwYa
 fVs=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Feb 2021 13:36:54 -0800
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [RFC PATCH 00/24] target: code cleanup 
Date:   Sat, 20 Feb 2021 13:36:52 -0800
Message-Id: <20210220213652.6290-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.22.1.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

This removes unused macros, various memsets, extra variable
in the target/iblock for bio get and fixes some type mismatch for the
same with fix for smatch warnings.

Marking it as RFC as I don't know if these cleanups are acceptable or
not.

I've geterated this on the linux-block, we decided to move forward wicth
this then I'll send series based on right repo.

-ck

Chaitanya Kulkarni (24):
  target/iblock: remove an extra argument
  target/iblock: trim down line longer than 80 char
  target/iblock: fix the type of the logs_per_phys
  targe/pscsi: fix the warning in pscsi_complete_cmd
  target/sbc: get rid of the warning in cmp & write
  target/pscsi: remove unsed macro ISPRINT
  target/stat: remove unsed macro ISPRINT
  target/stat: remove unsed macro NONE
  target/stat: remove unsed macro
  target/iscsi: remove unsed macro TEXT_LEN
  target/iscsi: remove unsed macro PRINT_BUF
  target/iscsi: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/configfs: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/pr: remove the memset with declare-init
  target/core: don't duplicate memset 0xff
  target: mark __rcu to avoid warning

 drivers/target/iscsi/iscsi_target_configfs.c |  3 +-
 drivers/target/iscsi/iscsi_target_nego.c     |  1 -
 drivers/target/iscsi/iscsi_target_stat.c     |  1 -
 drivers/target/iscsi/iscsi_target_util.c     | 17 ---------
 drivers/target/target_core_configfs.c        | 25 ++++---------
 drivers/target/target_core_file.c            |  3 +-
 drivers/target/target_core_iblock.c          | 37 ++++++++++----------
 drivers/target/target_core_pr.c              | 36 +++++++------------
 drivers/target/target_core_pscsi.c           |  5 ++-
 drivers/target/target_core_sbc.c             |  4 +--
 drivers/target/target_core_stat.c            |  3 --
 include/scsi/libfc.h                         |  2 +-
 12 files changed, 46 insertions(+), 91 deletions(-)

-- 
2.22.1

