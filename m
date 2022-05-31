Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC75C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 17:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346693AbiEaRwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 13:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346696AbiEaRwj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 13:52:39 -0400
Received: from esa.hc4959-67.iphmx.com (esa.hc4959-67.iphmx.com [216.71.153.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5063505;
        Tue, 31 May 2022 10:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=seagate.com; i=@seagate.com; q=dns/txt; s=stxiport;
  t=1654019557; x=1685555557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=apvAm9cdEzHrOqB6wduo8MjCfAVwoTdoxPRQfEeWumI=;
  b=iOA77rETzeIN14orv0A1g4P8NXvHYjSfMpxi4CJqcbQevpxDhaqd+xAM
   Ak5yGQCLs3uzivom6uCTkIt4H3KTJh13Phkd+/XTdLJ8CdKXvJR2u/KEZ
   5RJ4P7I7OxveufDZunqf/N0UDgYjYZlMLFmLtJKPuQo0Fp8uCSkiJp4BT
   E=;
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hc4959-67.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2022 10:51:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PTW7HE5gnMMgk3R+/JS95upaOWdRanWytb//cb2kdp8AJWOlWl8uwC6qYjpQ1V3WQmRRusWAkyl0bOJ1N4BKYDAZ7gwAd4qWUVdWcXkXxYriYlDaHUrDiavX3HvzcIeDBd4GjofOMRJf+zyUbCv9UFj82NXpvlXvl0VkZhV9OS6vvsFkFrE4JRJUbK8sjpoVwWKGtP1esEfDXI44hzfp8B9kJixJMsOSIzpUeM52h483IeFa+5MkiuBSksjNE574ja3GPiqxHfsdR4L37I31ppwmRKKXaVFm2ORi7RvXX+SmqaC0esLGZhUL6Zwb7co9ExctGIX3AwGEi9aR7LvXqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOcYzUr5gTPWkcPCIzwMQc8UsXUwkDKxAR+DIiWwSh0=;
 b=OWsVWD6O8JsaHGOduKzeG+dmHw/8lGIEmKu2NFgK5rJGz7Kcn2HQdJ/lOcdCMltDX1uSAEpIH6cpy33XKr93kzRw+zm4wHPfGIlJGqe0yojdsOe33Tm/qq7Y0Kugzaay3GeYqTPGj91cURmQuceX5uY6SL9uupotoxbVq+xwHA8Oznhgc81m6vOH+qu9IKrg5glwaP3FnN/R6UZPie7CE8xOIx53AMwdsufamHn6Mkr1W+yJJsbFBdfDKFdIcKwn4JW9OOkUqsI+GgGc4rSKrEzoSr+cPpZiOQsgppSf+3ntzm7BzxtmEsovQU5mTsiR120SF9jnrhEvvEazZjp7Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 192.55.16.50) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=seagate.com;
 dmarc=fail (p=reject sp=reject pct=100) action=oreject
 header.from=seagate.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seagate.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOcYzUr5gTPWkcPCIzwMQc8UsXUwkDKxAR+DIiWwSh0=;
 b=RqrUJsQjvwmWsdV9fk/BvjXbES1+x1nysGGbC7aYn4pKeQiqVr6ewRxZocf5FilfGUSDJ3rSLw/6unt/G383rg7aJnpighD+bgmjKSi9ufBUt4i6OIcqFORRNmM76MClZnrqAwPYM4G0d9XKjuZVPhju6zDjLeVo2Fuk9HnXODw=
Received: from CO2PR04CA0142.namprd04.prod.outlook.com (2603:10b6:104::20) by
 MN2PR20MB3432.namprd20.prod.outlook.com (2603:10b6:208:262::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 31 May
 2022 17:51:29 +0000
Received: from MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
 (2603:10b6:104:0:cafe::79) by CO2PR04CA0142.outlook.office365.com
 (2603:10b6:104::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13 via Frontend
 Transport; Tue, 31 May 2022 17:51:29 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is 192.55.16.50)
 smtp.mailfrom=seagate.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=oreject header.from=seagate.com;
Received: from sgspzesaa001.seagate.com (192.55.16.50) by
 MW2NAM10FT050.mail.protection.outlook.com (10.13.155.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12 via Frontend Transport; Tue, 31 May 2022 17:51:28 +0000
Received: from sgspiesaa001.seagate.com ([10.4.144.52])
  by sgspzesaa001.seagate.com with ESMTP; 31 May 2022 10:51:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,266,1647327600"; 
   d="scan'208";a="63170337"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
STX-Internal-Mailhost: TRUE
Received: from unknown (HELO COL-U500816L003.ad.seagate.com) ([10.4.50.11])
  by sgspiesaa001.seagate.com with ESMTP; 31 May 2022 10:44:23 -0700
From:   Tyler Erickson <tyler.erickson@seagate.com>
To:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com, tyler.erickson@seagate.com,
        Tyler Erickson <tyler.j.erickson@seagate.com>,
        Michael English <michael.english@seagate.com>
Subject: [PATCH 1/2] [PATCH v1 1/2] libata: fix reading concurrent positioning ranges log
Date:   Tue, 31 May 2022 11:50:08 -0600
Message-Id: <20220531175009.850-2-tyler.erickson@seagate.com>
X-Mailer: git-send-email 2.36.0.windows.1
In-Reply-To: <20220531175009.850-1-tyler.erickson@seagate.com>
References: <20220531175009.850-1-tyler.erickson@seagate.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: e2f936d3-5b08-4692-ba34-08da432e30b8
X-MS-TrafficTypeDiagnostic: MN2PR20MB3432:EE_
X-Microsoft-Antispam-PRVS: <MN2PR20MB343287231B2F4E6BEF8F6CF689DC9@MN2PR20MB3432.namprd20.prod.outlook.com>
STX-Hosted-IronPort-Oubound: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OvXaElhWgQ1sW7wibiYWnsCyahAFpfr0X9k66h/RTJ3SymIZhGdr5LcfJ80ua5DEDX9CEW9Rw6ywTRTxXnh5EQXM2dq8/VD6ILqoNpgmBzBIxUiHzvxrZXlCpJKJJ/3F0NiainNzMPGdVeMUkwzbujR6hronyQH93Qv4qlZ1arI036RtBCP4LUpCNSXjtlHmZpbdqkko4PuXcuUmfF94GrhNNH9M0GeN43wLDdXPgsum0ogPAQRzuyQGJDVpe1gfFXVaZaiWZKdUI6TPLTRHu8t5ogRrGfu5iufonMN7LHtHDYwhLcO4iWrXtnBDQy+z/i/2GxjN795IGNBvTHuLNkvNR62YlC31hiFauj5fzqN0ktXErei4dNvSbJFoseJVWzGjoWzxGx9a/rz10uwjI47m+UESbKBgA/v2fFwV+35Za1HhBqf3FAMNLfJpwY/4kKo157XLNJ1nAECFkrSErpe3k3oju45pThE/hw0RlU+NHH8miUhVIZZiItAUw4cEs2Ag5QVhIl8eTPlwbnOPDwZ4GGWPUgTciwP2kz8YHTGHRq3A3vtmNzqL4LDP2QYrAYBhTH4lTu+cNJJ+nYqK4p5zIVcysrY3w+NDuWu6/CvhQeJLuzEO8Koc5oTDF0en0YD4HGB+RSEm5I+9xN8Wa1gKRWpih/fdlYQYESDbMer8W2JQQqVt6TwZf7Ziru3G2tNbUtX/G3oJf/qVmYNorg==
X-Forefront-Antispam-Report: CIP:192.55.16.50;CTRY:SG;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sgspzesaa001.seagate.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(36840700001)(46966006)(40470700004)(47076005)(36756003)(1076003)(7696005)(6666004)(2906002)(508600001)(8936002)(107886003)(36860700001)(81166007)(450100002)(316002)(8676002)(186003)(70586007)(356005)(70206006)(40460700003)(44832011)(82310400005)(336012)(4326008)(54906003)(26005)(5660300002)(426003)(2616005)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: seagate.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 17:51:28.3191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f936d3-5b08-4692-ba34-08da432e30b8
X-MS-Exchange-CrossTenant-Id: d466216a-c643-434a-9c2e-057448c17cbe
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d466216a-c643-434a-9c2e-057448c17cbe;Ip=[192.55.16.50];Helo=[sgspzesaa001.seagate.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM10FT050.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR20MB3432
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tyler Erickson <tyler.j.erickson@seagate.com>

The concurrent positioning ranges log is not a fixed size and may depend
on how many ranges are supported by the device. This patch uses the size
reported in the GPL directory to determine the number of pages supported
by the device before attempting to read this log page.

Also fixing the page length in the SCSI translation for the concurrent
positioning ranges VPD page.

This resolves this error from the dmesg output:
    ata6.00: Read log 0x47 page 0x00 failed, Emask 0x1

Signed-off-by: Tyler Erickson <tyler.j.erickson@seagate.com>
Reviewed-by: Muhammad Ahmad <muhammad.ahmad@seagate.com>
Tested-by: Michael English <michael.english@seagate.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ca64837641be..3d57fa84e2be 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2003,16 +2003,16 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 	return err_mask;
 }
 
-static bool ata_log_supported(struct ata_device *dev, u8 log)
+static int ata_log_supported(struct ata_device *dev, u8 log)
 {
 	struct ata_port *ap = dev->link->ap;
 
 	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
-		return false;
+		return 0;
 
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
-		return false;
-	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
+		return 0;
+	return get_unaligned_le16(&ap->sector_buf[log * 2]);
 }
 
 static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
@@ -2448,15 +2448,20 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (ata_id_major_version(dev->id) < 11 ||
-	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11)
+		goto out;
+
+	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
+	if (buf_len == 0)
 		goto out;
 
 	/*
 	 * Read the concurrent positioning ranges log (0x47). We can have at
-	 * most 255 32B range descriptors plus a 64B header.
+	 * most 255 32B range descriptors plus a 64B header. This log varies in
+	 * size, so use the size reported in the GPL directory. Reading beyond
+	 * the supported length will result in an error.
 	 */
-	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf_len <<= 9;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 06c9d90238d9..0ea9c3115529 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2101,7 +2101,7 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
 	rbuf[1] = 0xb9;
-	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
+	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
 
 	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
 		desc[0] = cpr_log->cpr[i].num;
-- 
2.25.1

