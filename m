Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7142C2BA1A
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71D8720747
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 13:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="plaYZYxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgDHN0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 09:26:30 -0400
Received: from mail1.bemta26.messagelabs.com ([85.158.142.3]:46217 "EHLO
        mail1.bemta26.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727815AbgDHN03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 09:26:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1586352387; i=@ts.fujitsu.com;
        bh=93ZfEJS04jwBgFKo1w/rvNzIHYLnCOqCuQQV27pOb/Y=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        b=plaYZYxFDhiAY/rvRCvGsGhG0XkALzaWaU1hO6QxGoj0ca6UdT+tE+Ie/ojKjvPhM
         AhwVUKkHbyQLiWPwgYT8Ramc98GxF7Swev4bSvUZ3d5eIMqZIXigdwEV53eDxIzTAh
         e7mCYDBiWPOWgKzWFY3gMADpcNx7lRiCAh4X7P5U+PsaB5MlMrZ/XahVpya0MmuAsN
         FTQMOBDl8qP303ZHIV/FR+bRQCH78A1ceWzeUndyYCOag947dIcUH2VRjd4RjiVM23
         VPb9QlpPjCmec/H1Tfo6RImWLLo5QeeFuU9Yhw2p31SrHMtud3ipf0fUpqW+BqUnRC
         zOC2+t/iyJD3g==
Received: from [100.113.3.6] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-3.bemta.az-a.eu-central-1.aws.symcld.net id 45/6A-36550-301DD8E5; Wed, 08 Apr 2020 13:26:27 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRWlGSWpSXmKPExsViZ8MxRZfpYm+
  cwepeM4vu6zvYLJYf/8dksf7IBkaL1qVvmRxYPD4+vcXi8X7fVTaPz5vkApijWDPzkvIrElgz
  nu9ewV6wir1iya1ZzA2M09m6GLk4hAQmMUocn9TI0sXICeRMZ5T491oTxGYTMJBYMek+WFxEw
  Eai7/BSJhCbWSBdYuP6NmYQW1jAVaLh2DJWEJtFQFVizatXYDW8AnYSh2duBYtLCMhLdByYDD
  aHU8Be4vyVL2wQu+wkVi6/wTaBkXsBI8MqRoukosz0jJLcxMwcXUMDA11DQ2NdY10LC73EKt1
  EvdRS3eTUvJKiRKCkXmJ5sV5xZW5yTopeXmrJJkZguKQUMkfsYLy29r3eIUZJDiYlUd6/J3vj
  hPiS8lMqMxKLM+KLSnNSiw8xynBwKEnwzrwAlBMsSk1PrUjLzAGGLkxagoNHSYRXHKSVt7ggM
  bc4Mx0idYpRUUqcdw1InwBIIqM0D64NFi+XGGWlhHkZGRgYhHgKUotyM0tQ5V8xinMwKgnznj
  gLNIUnM68EbvoroMVMQIuvJXWDLC5JREhJNTAJ+ciVeD7YpSDVZ55k9dXEm/3q3Tv/g16kyTX
  t5nj1USjl5B5zI/uTb38WPd+d+Up0v56H0qEPrffcS1o+ccSqVlvdPVRT0nKO78u3L0FRX/fZ
  fr1dVZVxlFf7p6LoqUmTJL413S/tuKM7+9bXa3aM8v2KwQtWcV+e++iOzg7v6+5zb7AflQjSk
  n9nf4312RJ5cbaXhcFrBDYVuWoXLzu+ialkW9Tjbc5NRS87Qz4s8L3+8tP1qttdt8Xtsp9/Lo
  5ayLxSate5/raYB9v/JS113B3jbp10cvvnGes2nmuc8ukbd+DruveiWWdcT8cpWOVPnP1qytw
  FnrWztSOMgv/Il5x6cGQWU+2d52eOuZwqVGIpzkg01GIuKk4EAMwr1OoSAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-14.tower-226.messagelabs.com!1586352386!1439703!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 2519 invoked from network); 8 Apr 2020 13:26:26 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-14.tower-226.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 8 Apr 2020 13:26:26 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 038DQH4l025845;
        Wed, 8 Apr 2020 14:26:17 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 8911C20671;
        Wed,  8 Apr 2020 15:26:13 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, martin.petersen@oracle.com,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [PATCH 1/2] target: Write NULL to *port_nexus_ptr if no ISID
Date:   Wed,  8 Apr 2020 15:26:09 +0200
Message-Id: <20200408132610.14623-2-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
References: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes a minor flaw that could be triggered by
a PR OUT RESERVE on iSCSI, if TRANSPORT IDs with and without ISID
are used in the same command.
In case an ISCSI Transport ID has no ISID, port_nexus_ptr was not
used to write NULL, so value from previous call might persist.
I don't know, if that ever could happen, but with the change the
code is cleaner, I think.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_fabric_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6b4b354c88aa..f5f673e128ef 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -341,7 +341,8 @@ static char *iscsi_parse_pr_out_transport_id(
 			*p = tolower(*p);
 			p++;
 		}
-	}
+	} else
+		*port_nexus_ptr = NULL;
 
 	return &buf[4];
 }
-- 
2.12.3

