Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65EBC3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E9F22CF7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 15:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfIDPxO convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 11:53:14 -0400
Received: from m9a0003g.houston.softwaregrp.com ([15.124.64.68]:36427 "EHLO
        m9a0003g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731475AbfIDPxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 11:53:14 -0400
Received: FROM m9a0003g.houston.softwaregrp.com (15.121.0.190) BY m9a0003g.houston.softwaregrp.com WITH ESMTP;
 Wed,  4 Sep 2019 15:52:34 +0000
Received: from M9W0067.microfocus.com (2002:f79:be::f79:be) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 4 Sep 2019 15:52:32 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.72.13) by
 M9W0067.microfocus.com (15.121.0.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 4 Sep 2019 15:52:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZO+5Xe5RG9sb6Xbvp+whFlVsXHbM9tJN3lHelDrc/j4UvB+nk3eWMG5VyjpZpyn3DqP1rRau2rdH6JskFPc6ggwb09JTyolQihxa/PUQLIPb2PQXP8FPXgKBukEBmnJVZBOxTucK3nt3+9uZgEcBBQS2uY0sbXUdKmNm+n975MnEFeubY4xFWd+svlylAZ+kOMh/RlSQHbiCU+1Ns8J6FLH4+NDJiaI7g9PsBGRW/kj+kz3ywIZEeGkVkIJYkJx+xFGTwo03O3S1iqmXE+MwYXyGpuzq5anOFCvPKAbSP97OIpGU2FmE7FQv+BjJRJ2lmltoYMR4TTgSdVW3EEPTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3pQ9RriURGJEBLKJaZCpToiEQ8ySJHr4ultR6aqls4=;
 b=Nyfv4ngsH0DQD6GZHkAgEIUQbPRNGjhIKN31PN5AHC6/O10T2b2Sh06BrcNIzljvprX0xtminbIM76XIa9SyedT3aAmNAnp0FyHcEyUphfKTBshRTCNggANgpUsLcbQTUGIq8hUFQ+Xd9Q/SAkJDVcM8sc5D8YzfQnZxRAFMUzO19toG8jaxRlDE5TLTcECS0PW0nxEbjWjpUZ4cq1ShrFZtCl+dIph/VyALEkXWWcwtsFelNpeu2dtQ64OEC9rTra8OeFZnz5sVZNYNS7sa3Gy3FG5S2otRTOARDlLt7gPQMiG4LWwiw6noLX0+5ZaTRsEEWa483lKQtTPOmKmiMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BY5PR18MB3348.namprd18.prod.outlook.com (10.255.136.15) by
 BY5PR18MB3298.namprd18.prod.outlook.com (10.255.138.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Wed, 4 Sep 2019 15:52:30 +0000
Received: from BY5PR18MB3348.namprd18.prod.outlook.com
 ([fe80::6cf1:8de3:cfe2:8153]) by BY5PR18MB3348.namprd18.prod.outlook.com
 ([fe80::6cf1:8de3:cfe2:8153%3]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 15:52:29 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Ales Novak <alnovak@suse.cz>
Subject: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
Thread-Topic: [PATCH] scsi: scsi_dh_rdac: zero cdb in send_mode_select()
Thread-Index: AQHVYzjBAITGKtoVOE2kn4wGusRszg==
Date:   Wed, 4 Sep 2019 15:52:29 +0000
Message-ID: <20190904155205.1666-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0070.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::47) To BY5PR18MB3348.namprd18.prod.outlook.com
 (2603:10b6:a03:1a3::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.23.0
x-originating-ip: [90.186.0.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcc02bb4-c8d7-42c8-13b2-08d7314fe3b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR18MB3298;
x-ms-traffictypediagnostic: BY5PR18MB3298:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3298F35471E18ECF9C67F3DEFCB80@BY5PR18MB3298.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(366004)(136003)(39860400002)(376002)(199004)(189003)(1076003)(99286004)(14454004)(2906002)(5660300002)(6116002)(3846002)(486006)(110136005)(2616005)(476003)(478600001)(44832011)(6512007)(54906003)(66946007)(6436002)(66446008)(64756008)(66556008)(66476007)(6486002)(66066001)(52116002)(386003)(53936002)(6506007)(102836004)(25786009)(14444005)(256004)(86362001)(316002)(71190400001)(71200400001)(81166006)(81156014)(8676002)(4326008)(8936002)(36756003)(50226002)(305945005)(7736002)(186003)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3298;H:BY5PR18MB3348.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MjNzsUCJuD+RYk6tx7Ymo2Xrbdxi5W8r5kyqVC/75MF6GMDIdQi6pIR7rGw2kheGprsm8GRVJTfUTI6UfRPsFRHItmAnvCfc4K7JqCnGqEZyMEhYMvIt87EmayimfDfa/eBsQjEXOPLHEeLf6U7x2EUv3UTyj4W7SdUEPkJ1y9kvGKPSwPR/EZOTg7IS2LCSMJ3y75JtXstxnzdbrbTbDarXgvJZqrrio5v9u7m4wz4RmeJSaN/X0GAiVtioL6a5g8sEidpKEf10IDRnwvkTzWmYTjjRanmAqO3PnTmQoRlDwkDeQxzuRizw5Bkh3OTgJ0QF8zxVO5aek3eEjWDbioOxDVZUUE5GSDP16ML8ePMmDiXkdHwOztYohDKvOAJjdYCp7x4wV27bAKKWV+2mK4Y5R0XMQfuE8DlSDH0R/KA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bcc02bb4-c8d7-42c8-13b2-08d7314fe3b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 15:52:29.6783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XNnCOc3eYDGp0TsbM0Fn5On7PqKtq6Plb3jAfrSJ2BXhepWYm9c3vj/6CjTh6+O6CxVsEFm+misuMIqu34lP8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3298
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ales Novak <alnovak@suse.cz>

cdb in send_mode_select() is not zeroed and is only partially filled in
rdac_failover_get(), which leads to some random data getting to the
device. Users have reported storage responding to such commands with
INVALID FIELD IN CDB. Code before commit 327825574132 was not affected,
as it called blk_rq_set_block_pc().

Fix this by zeroing out the cdb first.

Identified & fix proposed by HPE.

Fixes: 327825574132 ("scsi_dh_rdac: switch to scsi_execute_req_flags()")
Acked-by: Ales Novak <alnovak@suse.cz>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: stable@vger.kernel.org
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 65f1fe3..5efc959 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -546,6 +546,8 @@ static void send_mode_select(struct work_struct *work)
 	spin_unlock(&ctlr->ms_lock);
 
  retry:
+	memset(cdb, 0, sizeof(cdb));
+
 	data_size = rdac_failover_get(ctlr, &list, cdb);
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-- 
2.23.0

