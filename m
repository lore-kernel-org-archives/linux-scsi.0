Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13FEC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 01:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiE3Bns (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 May 2022 21:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiE3Bnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 May 2022 21:43:46 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EEADEB2
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653875025; x=1685411025;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WGDF8pTgROvIz7CZgLQAsZl4nvuWWS5NNaqv5feSwTk=;
  b=IRi5755NGYV3eh0YC5zW86P4CBRSqlgfaAtgHwxerxOvHit0Y5cjrn9X
   /zzvRHO70hB2aqP5hxsAvJ0/y0bFsUj9MROHTfSyLW+cSrOtZ0ymHvv9G
   B+JR4uZhCHm2TuXy54mIStNLsWufQQi1gBGrunIozowjQY2yetkmZhbXO
   sapmSY92GJg5XbDxnoUkySjgZodOfn8QLlzksDDslgXWRsmXQ784Jy9xc
   vGN2tepHtDt0lvLvBgUC+CGjfqHZEdTHxd6mYreT+vsLL2P2g10ooUZD3
   MWBc0S7OKf9trwN63JlkkJyAPbdvg+VavmsxBHnUsjnVJ8uJZdWpCBIET
   A==;
X-IronPort-AV: E=Sophos;i="5.91,261,1647273600"; 
   d="scan'208";a="313773995"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 09:43:44 +0800
IronPort-SDR: pTYv0c+mBjbHLNi2+QzyqkM8+HtpYxqajykVyaIvTqdvV/Z9zshMhbwCAlPMHwQ87IMZmgAHw2
 oj3EyAMck93rGIsjalyfjOIeFFAZfPtXQG+rh74o4d6OoVWJPn2Ra7JTXj80rAkJOo4QBDftUK
 sMEBK97bWifnA5tFLVF9siIj10r1G8kCyPzUFeNb7eTT/11Eq7IkW2llngj3WbT5k8JKdQPyE/
 kz6+KlkgenIPMRgfgOhtGkJ6z1I1t1TiprxVRCIBAPuJ+8tkXi6GtwwNWOm5Tov3no8N3Q2BXd
 cJ32JEDHPN2290BBXHUw7t26
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:03:10 -0700
IronPort-SDR: vcQR27NAUUotB0DodqXuji6SoMZCQJ2fjkgJglhT4QHXw9ViK4AMSAfePJG9EWb2C6TwzI5+kL
 1DWalDQYEzFpKQYz6PRlRTYkIuLQ67JShYgWd4exK/kRGVsixXbH0Y5O4gkk8u4UQue2JKUlmg
 lYxnD4Qo4j/2BQ8MpM0he335whE7HBp0lhpIyuWbfpazSOTFLhT/DIHZ62OXOdBZ+7kihzm6ta
 IEM+MulUMCbaesrK/BK2yPh12U15O+n8Z6kQ06DCL41XCpHvo6FgCT9XyYZ/1Bebu7/N/9WYkR
 y/8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 May 2022 18:43:45 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBJ8w2MZhz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 29 May 2022 18:43:44 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1653875024;
         x=1656467025; bh=WGDF8pTgROvIz7CZgLQAsZl4nvuWWS5NNaqv5feSwTk=; b=
        qQluK83achYXUhRke5TlE/AamJKJnWL73odGxB+qC5Nqfl8uUM1KbY/3yqvQzufl
        Seys8NNXRErwAAzv1oXTDsECAusgDkm47iGAn0R4fMavKjpBfRRPuRnNDsoT9IhW
        OfVmyYt4n4cnPwm5nGyfiNji+BaKVr2jV0b/RZqUMLGyB0hiCj3rOGdG1qtnp0sI
        UvUn05ba1vDymojGXblQe6vJo5JpM1yK4yrg2cO3otxJnhHD6fHcQJzHbtNOlvE2
        uLn2C4z2BYxIicASsK6xckd0+V38kmIZcz0/GdTMlpmoGQWQMBFNiaKje4G5lIj7
        nw1qQbTiAQF6hWOvWyuMlA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Kr2G8RS_AZBF for <linux-scsi@vger.kernel.org>;
        Sun, 29 May 2022 18:43:44 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBJ8v2c1cz1Rvlc;
        Sun, 29 May 2022 18:43:43 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH 0/2] sd_zbc fixes
Date:   Mon, 30 May 2022 10:43:39 +0900
Message-Id: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of patches to fix 2 issues with the zbc code:
* A potential NULL pointer dereference in sd_is_zoned(), if that
  function is called when sdkp->device is not yet set (e.g. if an error
  happen early in sd_probe()).
* Make sure that sdkp zone information memory is never leaked.

Damien Le Moal (2):
  scsi: sd: Fix potential NULL pointer dereference
  scsi: sd_zbc: prevent zone information memory leak

 drivers/scsi/sd.h     |  3 ++-
 drivers/scsi/sd_zbc.c | 15 ++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

--=20
2.36.1

