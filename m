Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CFAC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E479F20650
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="e7y3ZrpI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKLAWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 19:22:03 -0500
Received: from mail-eopbgr750075.outbound.protection.outlook.com ([40.107.75.75]:30212
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726845AbfKLAWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 19:22:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnLGR1uSh28eVuvVgaA1wQA6eHSGIhGIqdfYpEm7fyHf/QrFM6VxoMdHojZ1bPmDfEPLfRHF9U4SE3Rx2rcSnwozSXi+ONEa7oTIw194WCEp6y/Irheolvvo3YcLc6ZHp+KoPFGjs2brDS2MhL4pxw3btqrXxZqNSMpSpNtVmITm+IV3m27xyC8qXluzYnEMv0eQhZBV07V3i92f8RcHU4vylv0oyrnu+qEKJWJyUrGRSP10dVlB4bVWpGVDGF0aK0FFZsaz1+0nyOfcGkoEpJ1+GtMUHKXwmX514+ZVKF+3hi7Mpqer2/LL5gFHxH8fBWwA8BO7nnLnFo2RBWlf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kntOEUr7kLV/frX8/eqwpDBq1lByo2/Bdle4qk1hjk=;
 b=Nbdi0Fyfkmx5EgQG0Ac1SbKqOV/ue+/pi3AebnOgJbr2ERWvyjdXKcISID9odKdgncvJ55qaOpU7ebHfvRO/sMlbM75MJ3hfkD2dnPDIEjohIYz4gWtj9wedLFe1YnDVtsm0b3U4ghyVbqveYDcjXOp1KX/BQHCzYmQTpzVsJuJYIu6UjU/3FNPzkh4x8l0nMrilNckhowwBTtrc1QZhAsd2S0hQSSmFofcTiIrc2v0choL+lP4g3DRgpdrssqaXL1I1dGsi0EEcJLvD/wm8IoWP+oFRoiUbK1hcKrTwIBVpvW2GWBgqdaixueXzSg2J3DlPVbR1az3cQ+lkx8dUjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kntOEUr7kLV/frX8/eqwpDBq1lByo2/Bdle4qk1hjk=;
 b=e7y3ZrpIszDxa5UZ3UEdlf3/KqAlX43shP6MkI2Kxnkpl83iB6G6fb7WqgnGwW0Aju8/fT/37IyWcz4VlO6owVAm9GLm+YpKKUdPVyhIKEzqw62P9NpKS4kizQMKtXsaGlVajhi7La3yX4VkdbdSnrY+XJDofkqRpft/M0BWfao=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5524.namprd08.prod.outlook.com (20.176.29.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 00:21:58 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:21:58 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v1 1/2] scsi: ufs: print helpful hint when response
 size exceed buffer size
Thread-Topic: [RESEND PATCH v1 1/2] scsi: ufs: print helpful hint when
 response size exceed buffer size
Thread-Index: AdWY7y7sg2hCLPw1TrObGC6krtjr7Q==
Date:   Tue, 12 Nov 2019 00:21:58 +0000
Message-ID: <BN7PR08MB5684BF6841527EB11A207F56DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTZlMzVlZGY2LTA0ZTItMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2ZTM1ZWRmNy0wNGUyLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE0MTYiIHQ9IjEzMjE3OTkxNzE1NzIxNjcwMSIgaD0iVHdTbFpka3gzVmYxYmQyeFpTRXBoU0QyRnZzPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7eccb47a-8ac9-463e-f7b5-08d767065485
x-ms-traffictypediagnostic: BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR08MB5524A124456F2C1F1F19298EDB770@BN7PR08MB5524.namprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:140;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(71190400001)(71200400001)(26005)(186003)(66066001)(6116002)(3846002)(2906002)(66476007)(476003)(9686003)(102836004)(52536014)(74316002)(7696005)(55236004)(486006)(45080400002)(6506007)(7416002)(33656002)(2201001)(4326008)(99286004)(55016002)(14454004)(478600001)(2501003)(86362001)(76116006)(66946007)(305945005)(8936002)(316002)(66446008)(8676002)(7736002)(6436002)(110136005)(54906003)(5660300002)(64756008)(66556008)(256004)(81166006)(81156014)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5524;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eG0rC3S9PBqB6eJXMfhzTFytbSfZfEctq5eHY3QCrRiT0TS1mwmgdkiK3v8Jbwxc0TdHY2wf9GrsMwyEq1CerX2EoVCsnuFlaPRNE9Z+/CavdssH+NV0T3uInI8AwQOdbv+nj9/6p2hBfJU1HponvOPPlJFcCUUTgcm5E3cqE2DkzJhjOEAnG00qnsTAXRn1W8PpuuDjAY2D2OUbqDmD6AhTEiPGrdVS/Ce+cmHtx1VF77lglUtELiQnEemzFDpL5IEqlQUkoj7YVNy/Kth4V7FvmUWoCtgzafPZ44vqgfJXFvycP/wahFRlUKoPnWnSKBxMrDg9HlX0MUYZwGNqdj80s6rZCCJgXKUlf7S/DBY7XOJbYBjZQsqHzILFvK28U+h7edNOItfeQBl28cnA1NeOcJjAAx9CVyIpb+EBgTRxllWrGkCAcXx1xkvMXr/z
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eccb47a-8ac9-463e-f7b5-08d767065485
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 00:21:58.0502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBW/5QHNr8loSY7IBq7T1YhjJuavUhSxR9k9bDuUIFaNBwBVW9OeQVi8neXAFBvv6w+7zUO5nL83iX5fI6opgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5524
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean Huo <beanhuo@micron.com>

Reset since ver.kernel.org rejected outlook.com.
Print out returned response size and buffer size, while the front one
is bigger than the back one.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 11a87f51c442..fdb4f5b7f4bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1935,8 +1935,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, s=
truct ufshcd_lrb *lrbp)
 			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
 		} else {
 			dev_warn(hba->dev,
-				"%s: Response size is bigger than buffer",
-				__func__);
+				 "%s: rsp size %d is bigger than buffer size %d",
+				 __func__, resp_len, buf_len);
 			return -EINVAL;
 		}
 	}
@@ -5856,7 +5856,9 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hb=
a *hba,
 			memcpy(desc_buff, descp, resp_len);
 			*buff_len =3D resp_len;
 		} else {
-			dev_warn(hba->dev, "rsp size is bigger than buffer");
+			dev_warn(hba->dev,
+				 "%s: rsp size %d is bigger than buffer size %d",
+				 __func__, resp_len, *buff_len);
 			*buff_len =3D 0;
 			err =3D -EINVAL;
 		}
--=20
2.7.4
