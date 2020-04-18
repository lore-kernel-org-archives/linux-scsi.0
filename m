Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF618C352BE
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 00:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE14C221EA
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 00:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="MHucO/Xc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgDRAmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 20:42:18 -0400
Received: from mail-bn8nam12on2105.outbound.protection.outlook.com ([40.107.237.105]:6401
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbgDRAmS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Apr 2020 20:42:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IE1YNnyhgG0dxPUBoWSG+dmaKLz0V0AA7U1r/01aC2DsE4tPakjhs/Evr/nco0b2vY9MLCf1Q/Ay/oTF8mMtExiT8G1jGwUQfjDbncroedFBn6xDGwWfmJZRlelPy9gNxTPbeOf5AzBpS9wK6j9WHGofzPsu1xZlU5g7L1qGls9s9UuxbunC7Lbv0FRESEqR9gaMw7X1TYR5dRxGhgs4/B6m5/OEQPiyDEM6KEwZXo1A0OWfyxGYB/HC2vpn2gpuHy1T235vGVFjt9iqsTARUPTb6ZKzwyX/GgfqJ+FT8JA/RlgOXZCvGMNXo4xCbyDj5PxJpYrn2qW2x1hL6b3tCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzvYdIMAkBClYgO5clNltn42BywmXqTIe68+GqgAP4k=;
 b=EjdG9UdhA9SFSWgpI8qJZhXYBwdxbUkhKEktiOfAkkOxMqSNXpBrgWJmSQcr5s0k3jXMEZzObZRrVhXWqb61Fl59sshGGCZq0mKNu+IYGxtYWzCLfRqXiyAMZSqtPMF5TWp8WsmWMj/GFMqTYKvOoPRB9G+ilDi5ND84tahBR61DyCqF47QploB50PqSO0NSTZXxrHMEYNd/ttry1agz2MAStpk7K9/Ym3ugWLtnPiPvhi9N8jcLLtskzudl9pW/XUmXIeMvsbyqBQkhPB6qpNzZ74mk5tpMiFO2CqXANaW+LjqBjcQ71PfmkVxDLvj21dXJVx1JUMgGaiDomitjjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzvYdIMAkBClYgO5clNltn42BywmXqTIe68+GqgAP4k=;
 b=MHucO/XcDZgwsiAn+1qcmXsuvEynhCxuyo/DZH+X+PIpbrq9f15bGR3CiMJtaI8fIMMCOHDJnIwqnEXj+pkof70pUmeKmZGlb+GjeCSLiTDMJIo55dszlVrYqS5lkot7l9UWsfvshUFeMe3COIsZ8DfxGOAXqH6sULJc2prwNqg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN8PR21MB1139.namprd21.prod.outlook.com (2603:10b6:408:72::10)
 by BN8PR21MB1156.namprd21.prod.outlook.com (2603:10b6:408:73::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.10; Sat, 18 Apr
 2020 00:42:15 +0000
Received: from BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581]) by BN8PR21MB1139.namprd21.prod.outlook.com
 ([fe80::b01b:e85:784d:4581%8]) with mapi id 15.20.2937.000; Sat, 18 Apr 2020
 00:42:15 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@lst.de, bvanassche@acm.org, hare@suse.de,
        mikelley@microsoft.com, longli@microsoft.com, ming.lei@redhat.com
Cc:     Dexuan Cui <decui@microsoft.com>
Subject: [PATCH] scsi: core: Allow the state change from SDEV_QUIESCE to SDEV_BLOCK
Date:   Fri, 17 Apr 2020 17:40:45 -0700
Message-Id: <1587170445-50013-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:907:1::18) To BN8PR21MB1139.namprd21.prod.outlook.com
 (2603:10b6:408:72::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MW2PR16CA0041.namprd16.prod.outlook.com (2603:10b6:907:1::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Sat, 18 Apr 2020 00:42:13 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 57bb415a-f2f4-4a31-c4fc-08d7e33156da
X-MS-TrafficTypeDiagnostic: BN8PR21MB1156:|BN8PR21MB1156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR21MB1156D5160E597019EFF9ED10BFD60@BN8PR21MB1156.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1139.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(4326008)(10290500003)(8936002)(66556008)(36756003)(6512007)(107886003)(66476007)(6486002)(478600001)(66946007)(316002)(6666004)(8676002)(82960400001)(2906002)(3450700001)(956004)(2616005)(86362001)(186003)(81156014)(5660300002)(26005)(6506007)(16526019)(52116002)(82950400001)(921003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbzYaRGIWME7SsF70pknn5umw8GswiinfsidFHjdVUjNO3TKLK9v0+cpfDq3irJE3+UrB3IKX4WhnEevrmrJ9mGes2BuPqIzVZ2SQpELRu3gG1KQyG3J8yuIQzcNghrXXkixJbLs7AWo6aQMRRmBTRlT/B9e8yMADvgvj+VlanQzL1F67bn6UayyZZbKVvFmliEcdIhMzockGdKnqor1KCTUKMxlCXCj7FahBmbqmGlYss/C2NPuSGk+efpSIs8B6G2eq9eCp6Y2euttxe9G25LtYTQ5X3Gy+HhwbpZ8NyXtrpKfDVcZKws25OXAiTiAYcCY8k3IfdvZktJenaytP2HoMXkpoiN5WR+6cbKp8jTOs9V3+bodJtC45bxfKbGRJ3czrw66+/VOq6oCCdh79+mrQ/dcgMWMMOvmY9fCC1SoAJCYeMIjhaURok0+Ntu+ZbO0/8TogCI4xOp6+Wwq05FTwJxXpdFDrVvT3tjHGBU=
X-MS-Exchange-AntiSpam-MessageData: Dy9vkuwJhCOiM36AA1IWPzxuOsM0JCSmdvwhqtCjz+O1We1egWdN3Y9H37dPhyOqBroJP78KCAOpN1D38jEQbBBsvoxvK8gPKh8R+4tShm5Q9psgW9EPVD8dOq4CiIIvov36DjqziUlwApBFXSRQuQbab80gRKp4JSFwAPjhnBkfe+SVn8yJ89xsa6AUZBQ23wjj8eJc2radgn1LpMGfnUaaKaoAvHCHXUKh7JmHCHTNQFC6Wu47I8SrGVZFiZ2A2nnYG3dN4HSC4kIyb+dR2U2RIBDqFdiCPCoBQy2xn7PNO7C9OMz0VFUKCUAi4naHg+rRZJgstLIkqKVk/S2Eo7yuBThA+gBt+5qab3NrYhycv2CejWf86t1p7YDMg/aAUZivIih4n0vBnKYSrHfGzV/4pOiqbambdY5piffajwq6QlaLDO8PmcNQWjIQDVFoienZgHRqp1PycRE4CuBnA7bNtw9xwGA9zz0QZE+YbH76ipoJSUbmz999r9qMzujxnkT2g0BO4AFFG7vspD/k+OY/rHJ7piaGf0xsCXFsypbAiJs2uBZ1Uw3tteDDCcLGUg+PZhome+pwYUOW/rgPOS6yBZWpQB87e27ixielfz542bKCOJq+vHGPBLzjBofzf6OlUK9SUmlLmBswFpk6aRo3c1aLRFgAK3piObNdgdrBwYTKjqVhv/y72aFrFyhx/JfpzB/n18ZpjOPvd3Mmpu1rju2/J6xUlY1S2XY7swawxQl2ewzqKIQG+0MrsmmKzIc/9Sl1z0gqM6oFNmFQUWqiyntlenPFmuDIlqNV21M=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bb415a-f2f4-4a31-c4fc-08d7e33156da
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2020 00:42:15.1202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teMvReK8se7Qe08QgEsPUhQN9/VpfGNtsMOj1NQtvoH9jabaK4cQdNL8kketPVkD402kzF8npCMo0pz9ZpNZsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR21MB1156
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The APIs scsi_host_block()/scsi_host_unblock() are recently added by:
2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
and so far the APIs are only used by:
3d3ca53b1639 ("scsi: aacraid: use scsi_host_(block,unblock) to block I/O")

However, from reading the code, I think the APIs don't really work for
aacraid, because, in the resume path of hibernation, when aac_suspend() ->
scsi_host_block() is called, scsi_device_quiesce() has set the state to
SDEV_QUIESCE, so aac_suspend() -> scsi_host_block() returns -EINVAL.

Fix the issue by allowing the state change.

Fixes: 2bb955840c1d ("scsi: core: add scsi_host_(block,unblock) helper function")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 47835c4b4ee0..06c260f6cdae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2284,6 +2284,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		switch (oldstate) {
 		case SDEV_RUNNING:
 		case SDEV_CREATED_BLOCK:
+		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 			break;
 		default:
-- 
2.19.1

