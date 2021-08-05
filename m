Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45078C4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DEF61029
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhHEEOh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhHEEOh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Aug 2021 00:14:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5E8C60F58;
        Thu,  5 Aug 2021 04:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628136863;
        bh=ETz7x1TCNEB74qRJkAKDKXydid87xNuizYelSlLbLU0=;
        h=Date:From:To:Cc:Subject:From;
        b=ebffHHm6HSNaZ5cth5Xg+0RiR+wfns6E9Vd7mG1PDnY1P7z/MJyA/xwVen1Ohfssp
         XSuzkCNphVFRoqJL/3E2rH5n5uu3bitBkXnn3k/MBAGJ4hlUwmiBy3KMUD0CNPkqh1
         SSrCLC/LlH03q4vYv6P66Zt/nOfLRt4rM+OIcjlEv5sSNoa00cLfKSZzljwdiwzRau
         1wJvChD9Emi12sPf36rGlCpwTaQlpMLOswrkJgollcRuXwO/AF531t2UyrkaxjBzMK
         xayyO7W7XyoaklXNay0oBNL9AreCh4BVRyHV/WgyOK0gbRLojjRTRrFJTeYGPTRyxg
         r/9GIAEPFx+Rg==
Date:   Wed, 4 Aug 2021 23:17:04 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v2 0/4][next] scsi: megaraid_sas: Replace one-element arrays
 with flexible-array members
Message-ID: <cover.1628136510.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

This series aims to replace one-element arrays with flexible-array
members.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://en.wikipedia.org/wiki/Flexible_array_member
Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109

Thanks

Changes in v2:
 - Revert changes in struct MR_FW_RAID_MAP_ALL.

Gustavo A. R. Silva (4):
  scsi: megaraid_sas: Replace one-element array with flexible-array
    member in MR_FW_RAID_MAP
  scsi: megaraid_sas: Replace one-element array with flexible-array
    member in MR_FW_RAID_MAP_DYNAMIC
  scsi: megaraid_sas: Replace one-element array with flexible-array
    member in MR_DRV_RAID_MAP
  scsi: megaraid_sas: Replace one-element array with flexible-array
    member in MR_PD_CFG_SEQ_NUM_SYNC

 drivers/scsi/megaraid/megaraid_sas_base.c   | 20 ++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 12 ++++++------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  8 ++++----
 4 files changed, 21 insertions(+), 21 deletions(-)

-- 
2.27.0

