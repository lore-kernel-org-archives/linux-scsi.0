Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CDC8C54FCB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA82C206BF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 15:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="IuAhspuP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgD0PId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 11:08:33 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.113]:61000 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgD0PIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 11:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588000110; i=@ts.fujitsu.com;
        bh=kMG0yUaaspA//KQ9VSeFJDQKXrDiLpr0wGyQrmXds5g=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=IuAhspuPuBp/FEeqcbD/+FKqdSLwZY8cZysdADvUQsWxc5zbfJfjw8XaN3yMPYfcS
         fbh9p8XbLJSLzl96WUauPesfGTiQDdreBuH4WwIBTDcJaVxs5co97wg4Hfq30d4YBP
         BdVYtrcXff+tsypdLV/FJKWGVgqnICwHtoXIznoNlq26X1EwnKyRRmzghaMn+XGvgL
         LwkNso8GoVTYZAlvRqRGwi+OTEebCnDT8aU1UFDMflMaXXt2yKkc12ts1tn2tBl4ID
         kxd00j1YQh/OA6A4HYYk8WGgiyorp9e48ZoDf1DvigZWzKyskz79C1nssc7773Fojg
         R4JguR7+7Ajeg==
Received: from [100.113.6.103] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-b.eu-central-1.aws.symcld.net id 2F/E7-40482-D65F6AE5; Mon, 27 Apr 2020 15:08:29 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRWlGSWpSXmKPExsViZ8MRopv7dVm
  cwYpWHYuv/6ezWKxcfZTJovv6DjaL5cf/MVmsP7KB0aJ16VsmBzaP3Tcb2Dw+Pr3F4vF+31U2
  j82nqz0+b5ILYI1izcxLyq9IYM2YdXw6a8Fj9oqT7U2sDYwf2LoYuTiEBCYzShz+O5kRwpnOK
  HHjwRL2LkZODjYBA4kVk+6zgNgiAjYSfYeXMoEUMQs0MUrcerUeqJ2DQ1ggVOLRb3eQGhYBVY
  lTi86zgIR5BewkPpzKAglLCMhLdByYDDaGU8Be4szF62CdQkAlHx/oTWDkXsDIsIrRIqkoMz2
  jJDcxM0fX0MBA19DQWNdE18JcL7FKN0kvtVQ3OTWvpCgRKKmXWF6sV1yZm5yTopeXWrKJERhS
  KYUs4TsYdy5/r3eIUZKDSUmU9+TqZXFCfEn5KZUZicUZ8UWlOanFhxhlODiUJHinfgbKCRalp
  qdWpGXmAMMbJi3BwaMkwpvwBSjNW1yQmFucmQ6ROsVoz/Fm7ZJFzBxt9+4CyZkLDq5m5rjffm
  g1sxBLXn5eqpQ4rx1ImwBIW0ZpHtxQWDxeYpSVEuZlZGBgEOIpSC3KzSxBlX/FKM7BqCTMOwv
  kNp7MvBK43a+AzmICOqtKfjHIWSWJCCmpBqaDixecZZn9UOtw7Vq7bpnAlQ/6Tmiw/+marrJt
  0Q8z25x/XZcvnr+1U/RYvuDde4aTaz+LLvaTtVrE8PVo9nSjx8udlRWPLah5ynFa+0Wg37bl0
  9oE/nnIWkhm5m82j+djDuV7df57/2oR52UTVjqckD9dFpZwTTXI/2LytadsAULTq97zl/Wy7L
  eefO/yxsc2HdoXl/Lufn8ht6jygMLjnotqxzvrf3ed74uvSEzxqLmT+kTStP7+rLhbMW3sWyI
  2vrxZqca+Yd08y+uXU/Wu3SuMvi6694VAtu+f5gr511075S5wb/rSYtkc3x3WHPz1TeJyx3ru
  mewsL24GhG1dmOJ8/m+xQIX2r+JVctuVWIozEg21mIuKEwFkanI/QgMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-13.tower-245.messagelabs.com!1588000109!51129!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 15394 invoked from network); 27 Apr 2020 15:08:29 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-13.tower-245.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 27 Apr 2020 15:08:29 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 03RF8QuV031886;
        Mon, 27 Apr 2020 16:08:26 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id E863D20708;
        Mon, 27 Apr 2020 17:08:25 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, ddiss@suse.de, hch@lst.de,
        martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/4] target: add missing emulate_pr attribute to passthrough backends
Date:   Mon, 27 Apr 2020 17:08:20 +0200
Message-Id: <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute
emulate_pr was added.
passthrough_parse_cdb() uses the attribute's value to distinguish,
whether reservation commands should be rejected or not.
But the new attribute was not added to passthrough_attrib_attrs, so in
pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
is not available to change parser's behavior.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21fdcce..d8589bb39c53 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1203,6 +1203,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_hw_block_size,
 	&attr_hw_max_sectors,
 	&attr_hw_queue_depth,
+	&attr_emulate_pr,
 	&attr_alua_support,
 	&attr_pgr_support,
 	NULL,
-- 
2.12.3

