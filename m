Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26A89CA90AF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0644820746
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 16:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="iybkzUEt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgELQSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 12:18:17 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.4]:51314 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726287AbgELQSR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 12:18:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589300294; i=@ts.fujitsu.com;
        bh=KhpI/oTYPBwCSd5HBuPq6OYDwPV+G6NOvvgcPbitnik=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=iybkzUEtWGHRmN9d017HqfGltqS07475UxX2hq6HOVNetaZ6jOhXqzIqGM41ANn/c
         OMc+ModBbDFe7xvziZqrW5nEAKbAcy+sSj9Whggw3hGQCW3HYIT2QLbBfH/CSjdykS
         A+iNMY6Q6bnNoaXubVitGmN5RwNHhGnNuCZwQGlk9Ra29gKfwebjWrPFtlcF8DzJm0
         pZhslS0IrER04DQb4kEOT39mhhovRnD89YQwenlcvq/rzHbXtPEwSp5OrliMI3LYXz
         tK9pBvX89GRm5XHkVABUdn1eBc9WJZpc3vovnUFZiJcMaQ2IgRFYO9T41ehiwocOMe
         G9IbaXtgCkZmA==
Received: from [100.113.3.197] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-4.bemta.az-a.eu-central-1.aws.symcld.net id C0/AE-37389-04CCABE5; Tue, 12 May 2020 16:18:08 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRWlGSWpSXmKPExsViZ8MxRdf+zK4
  4g53ntC12Xv/IZDHtw09mi+7rO9gslh//x2TxddNGNovWpW+ZHNg8Ll/x9vj/bwqzx8ent1g8
  bp++wOTxeZNcAGsUa2ZeUn5FAmvG3peHGAum8FfcW32esYFxPW8XIxeHkMBkRokfLe1MEM50R
  ok9X1vYuhg5OdgEDCRWTLrPApIQEVjLKPHi4UMmkASzgJ7EtH/r2EFsYQFnic/n/oE1sAioSq
  zonQRm8wrYSTyaNR2sXkJAXqLjwGSWCYycCxgZVjFaJhVlpmeU5CZm5ugaGhjoGhoa6xoDWSZ
  6iVW6iXqppbrJqXklRYlAWb3E8mK94src5JwUvbzUkk2MwFBJKWTO2MF4de17vUOMkhxMSqK8
  LRN2xQnxJeWnVGYkFmfEF5XmpBYfYpTh4FCS4A07DZQTLEpNT61Iy8wBhi1MWoKDR0mE1+YUU
  Jq3uCAxtzgzHSJ1ilFRSpx3P0hCACSRUZoH1waLlUuMslLCvIwMDAxCPAWpRbmZJajyrxjFOR
  iVhHlngUzhycwrgZv+CmgxE9Dih8+3gSwuSURISTUwhVq6vNQtOaItZhsTyj+jdZ/Dtl7Wy6o
  S4a9PCSjb/v7kdCMpRcqk0vEb/+V/WrandyptcgkpXsa7036/n36DbIZt1bEclRjbTpEepe2q
  j6fHHWJet2j/1k/tqZPTCpS3i8wJuqK+3CNxTeqyuTtWhErGu9+JCm2Jr/7uu/zg2cvnn+XMr
  PZK/LZmT+iCzn8rnMVWvjrFIGl+aHNujpXaZY+FVVkKS/8+M53frdJZv19bXPXypfDCOdbV7I
  +yJI86pEimh9lOm7d+zx+5oEix56F//zdYfOV3+tVTJS81JWpLhuNasScLxEq4Ovff9vEp5eV
  9K/R8scmExdxxzNqrFvyWPNdZoDKDf7bRhjtKLMUZiYZazEXFiQDWLVuCEAMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-15.tower-226.messagelabs.com!1589300286!894377!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 5712 invoked from network); 12 May 2020 16:18:07 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-15.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 12 May 2020 16:18:07 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04CGI6p2006160;
        Tue, 12 May 2020 17:18:06 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 3AC9420708;
        Tue, 12 May 2020 18:18:03 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, bvanassche@acm.org,
        mchristi@readhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, bly@catalogicsoftware.com
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH] scsi: target: put lun_ref at end of tmr processing
Date:   Tue, 12 May 2020 18:17:53 +0200
Message-Id: <20200512161753.10625-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Testing with Loopback I found, that after a Loopback LUN
has executed a TMR, I can no longer unlink the LUN.
The rm command hangs in transport_clear_lun_ref() at
wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not
called at the end of target_tmr_work().

It seems, that in other fabrics this call happens implicitly
when the fabric drivers call transport_generic_free_cmd()
during their ->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the
se_cmd->se_lun pointer.
Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end
of target_tmr_work(), which was removed during commit
2c9fa49e100f962af988f1c0529231bf14905cda
"scsi: target/core: Make ABORT and LUN RESET handling synchronous"

For fabrics using transport_generic_free_cmd() in the usual way
the double call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does
not release lun_ref twice.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: Bryant G. Ly <bryangly@gmail.com>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..264a822c0bfa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3350,6 +3350,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
-- 
2.12.3

