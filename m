Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D6C2BA2B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA13F2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="cHq0hHnC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgDHN02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 09:26:28 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.116]:34813 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727928AbgDHN00 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 09:26:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1586352382; i=@ts.fujitsu.com;
        bh=hj3KyWtrKww1tJ63UWW4tST618c2ILSBLf2oQGL2vxY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=cHq0hHnChdc7MauLVhuGn6Cs7oJEvWrlNBVE668DJLhXU9/m5sX1IO9cT3MySusP3
         VkffPBrUwwGCCQWx+8qiJJQX1upaExr+YgcjVnkqyFfZHHjD3CIEaN5DnRowtnrtpL
         M6OgXcZqTLpzVzWpuxiLN9mXD85hB0XO0aJKbIvOw8BpDPGKEissDay0B3fsFj8duv
         NDwKofBh/nxIe/fRmCKrDVI1OcWgk0/2nI5f+hKYs6ol9ST+D1UO03XUnkrIcrPwch
         0hH9IDw3TnjpkUUZuajIKQlN3Zvc2LtVWqpkJw64lGf+FLBiudMv10P7nFMzDr3dQL
         dBO1MiukV8XHw==
Received: from [100.113.5.217] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-central-1.aws.symcld.net id 15/ED-46447-EF0DD8E5; Wed, 08 Apr 2020 13:26:22 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRWlGSWpSXmKPExsViZ8MRovvvQm+
  cwYcDghbd13ewWSw//o/JYv2RDYwWrUvfMjmweHx8eovF4/2+q2wenzfJBTBHsWbmJeVXJLBm
  vP90na3gAXtFS9tGtgbGw2xdjFwcQgKTGCUOLJrIDuFMZ5R4OO84SxcjJwebgIHEikn3wWwRA
  RuJvsNLmUBsZoF0iY3r25hBbGEBB4nre6cDTeLgYBFQlbg9PRIkzCtgJ7H86kOwEgkBeYmOA5
  PBxnAK2Eucv/KFDcQWAqpZufwG2wRG7gWMDKsYLZKKMtMzSnITM3N0DQ0MdA0NjXVNdE0t9RK
  rdJP0Ukt1k1PzSooSgZJ6ieXFesWVuck5KXp5qSWbGIHhklLIYr2D8fLa93qHGCU5mJREef+e
  7I0T4kvKT6nMSCzOiC8qzUktPsQow8GhJME7ExiAQoJFqempFWmZOcDQhUlLcPAoifCKg7TyF
  hck5hZnpkOkTjEqSonzrgHpEwBJZJTmwbXB4uUSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJW
  HeE2eBpvBk5pXATX8FtJgJaPG1pG6QxSWJCCmpBibbWLPZh5/uce6tmuBzzIenMzxJwGRRzME
  PTqv2S90LXW7k+m31sxNN6ac0bs7f4rh230PRif66Pm7975WN3894OCFj8r99V+TMtxXUH55a
  PL/U5pkGR25/DfOCwxfz1rXOqMr20nkitdFg4oJn37RvOq29Uphgmqg5c1PXFmUeqUB5ybfvv
  GR6r6reSTnxdtLrWxPS/wgkGD+sqpsgv2yBl5vCGj69mu4L4hYV1t8y2HKyNd+f6Iv6v8jIz2
  CO2aO/NzJChA5/qPmwMH7lE7+URK32D8XcJxQavLZHaC/bWz3/enlU9AvpRScNC6RvvF9W+3Z
  FcuaaFaJf6ho5BWzfduwydq14mb7uvErGixIlluKMREMt5qLiRABLy3qDEgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-33.tower-238.messagelabs.com!1586352381!2417026!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 8387 invoked from network); 8 Apr 2020 13:26:22 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-33.tower-238.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Apr 2020 13:26:22 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 038DQFvf025515;
        Wed, 8 Apr 2020 14:26:15 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 511ED206B2;
        Wed,  8 Apr 2020 15:26:14 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 2/2] target: fix PR IN / READ FULL STATUS for FC
Date:   Wed,  8 Apr 2020 15:26:10 +0200
Message-Id: <20200408132610.14623-3-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
References: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Creation of the response to READ FULL STATUS fails for FC
based reservations. Reason is the too high loop limit (< 24)
in fc_get_pr_transport_id(). The string representation of FC
WWPN is 23 chars long only ("11:22:33:44:55:66:77:88"). So
when i is 23, the loop body is executed a last time for the
ending '\0' of the string and thus hex2bin() reports an error.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index f5f673e128ef..1e031d81e59e 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -63,7 +63,7 @@ static int fc_get_pr_transport_id(
 	 * encoded TransportID.
 	 */
 	ptr = &se_nacl->initiatorname[0];
-	for (i = 0; i < 24; ) {
+	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
-- 
2.12.3

