Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AECB4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 11:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiCALa4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiCALaz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 06:30:55 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD6B4617C
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646134215; x=1677670215;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rYHPmxNNBPQaE5nHsDwy/e0938DIH3dsLT9hiKPD7bk=;
  b=nGM4BV1xUqPPvWaggvPYkaeQ0zZ1uZQtZxufwN2wWqYso2UGaS86qaH/
   bhiQFEiLLSP1UygofDsP2mff0w7VqEaV7/wjI1CfdK+5q2ZQTl4UDeTXB
   CBKxXxICgO6nXMzgeu8hHZmgYuCTCUjJNItJhZG0bHmSKylu7mSL59kV6
   rRs1oo4jpXt01zr2KsdO7MFnLUmUbf5To5SYdHbQcAglXQ5t8nu006LVo
   LFsUhm3fCtbZlK3W9Mtd5weuCUye48hiWjuMspuqbm5TzvW0AH90Iseq7
   G5yu375pxEPXjDzvQaeWuy/Pk+PKKlESrycy9JVWJFw2wn4Vp98Pxj3B8
   A==;
X-IronPort-AV: E=Sophos;i="5.90,145,1643644800"; 
   d="scan'208";a="195162725"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 19:30:14 +0800
IronPort-SDR: xK/g4ykEc+br3I+F9N5KL29osZVc9DJTDnDcheQ3tEYsjOcAvYLpGACwn0VErRa0r8ToKCa7Lw
 /5tn9Ki5HGArPItGlg2mok+2jcp+Mj05OmFb2Ptu5iF8rY929T2d4IlbFTNug+GJ451vL580EA
 OXxKBgOlDOxSEDkFlRHlIFBJi4+DwhG1pWNx5SJgUkxWEqPi5WJupLuh6PX6KMzfvCkHiJL4m7
 mnq+6OoQC1ztroZKB3d42P7lT2BxJh3QwhfqIVpJrmFkDOR/4MjTZ/mMfde+SaesLAk+d+KJ63
 yPnaqgR1sGs4Nr8Dt8VqRTFR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:02:41 -0800
IronPort-SDR: ozE44z34V4PDzOs9opeYpLe7JqAItN9ckBZF/y/vd0x3aBKMBIU3zoPXw6R3CRVGS358QMfksc
 QXUw9GKsNago50nvVfAFsw/sDk7GFnfVAopD5br9JtYnGuRlEquge1D+Yc6w1U+Lloqn4E4Kqs
 qNHyiNsvRyNtDFjmw2kv+6E8m1k/iZKmQXGMHCRXuip1+aCnuB5dAXlNrM0uMXgtrax8JFDcR7
 Y2CHtSz8nuhBc/u1z/OLI9HDWGShx6cMcgWlaGqydI5sK7mbbakY9Z+pQ13p67lWfbivfgmx+B
 AzM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 03:30:14 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K7FR96VL2z1SVnx
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 03:30:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1646134213;
         x=1648726214; bh=rYHPmxNNBPQaE5nHsDwy/e0938DIH3dsLT9hiKPD7bk=; b=
        r2lsQWw1Zq8A99o/Vf3bRfpUE/Mc73o67Rge6RknUz67Ncg9ndXogns2h/an1hKg
        eQoeLrgI6TSRYmQ9vzfbygLi/cxafmfki59FZExGMyzJfKf7GLag3REm48a6DGB1
        P/SQ72b4jV2Jsebl6Zy3GRwhKpCPslH2qLRjBDzBrVW1QYAumCHHBBx+pcG1e0fA
        sxQrf3AwzytVZT6Wx7wWjy/dOaPlysTn6b6vt3X197+Gn4EL6h35x8kG/0XpDkrU
        NUVUajD0/JToX7el1RuWvAxHOJXzKB/DCa5wD4vF27j0p3CB45rDhrKiZKH1jHOH
        D6WR/AsfzueZE23Ebx2q6g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l4vikM9g2QAH for <linux-scsi@vger.kernel.org>;
        Tue,  1 Mar 2022 03:30:13 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K7FR872tLz1Rvlx;
        Tue,  1 Mar 2022 03:30:12 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 0/2] Fix sparse warnings in scsi_debug
Date:   Tue,  1 Mar 2022 20:30:07 +0900
Message-Id: <20220301113009.595857-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of patches to suppress sparse warnings in scsi_debug. No
functional changes.

Changes from v1:
* Added Acked-by tag to patch 1
* Fixed patch 2 (find_next_bit() call and break comment)

Damien Le Moal (2):
  scsi: scsi_debug: silence sparse unexpected unlock warnings
  scsi: scsi_debug: fix qc_lock use in sdebug_blk_mq_poll()

 drivers/scsi/scsi_debug.c | 84 ++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 33 deletions(-)

--=20
2.35.1

