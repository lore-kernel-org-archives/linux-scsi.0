Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BE5C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 01:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11B872312F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 01:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbhAMB3q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 20:29:46 -0500
Received: from rcdn-iport-2.cisco.com ([173.37.86.73]:9192 "EHLO
        rcdn-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbhAMB3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 20:29:44 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 20:29:43 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2113; q=dns/txt; s=iport;
  t=1610501383; x=1611710983;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=liDRHJhEuCmC/3R3RxdibIQxQsBvbLiex8atHktxkDs=;
  b=JmahVXQx+rkt5Uz3CUQA3vLQoFOw9qO6aUttQubY+J/W1O6IHnyUrkcm
   hADArVUxtW/kXn5xWCPnSHPoUfF0QWDVOH2GGhZYM8dB5FooJo1AytlVT
   QHJA6y35qoNZfOvx54ubGgF18vp5NT8G0LGgu1afSJA+SrKSVXscfMyYK
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3A2HdwaBS/qipjmqSkjDBVAqt9UNpsv++ubAcI9p?=
 =?us-ascii?q?oqja5Pea2//pPkeVbS/uhpkESQBNuJ+fBZzefarubrXz9I7ZWAtSUEd5pBH1?=
 =?us-ascii?q?8AhN4NlgMtSMiCFQXgLfHsYiB7eaYKVFJs83yhd0QAHsH4ag7AoGD04DIPXB?=
 =?us-ascii?q?75ZkJ5I+3vEdvUiMK6n+m555zUZVBOgzywKbN/JRm7t0PfrM4T1IBjMa02jB?=
 =?us-ascii?q?DOpyhF?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B0AAA9Sv5f/5FdJa1iDg4BAQEBAQE?=
 =?us-ascii?q?HAQESAQEEBAEBQIE8BgEBCwGBUlEHgVEvLogHA415lQ2EBYEugSUDVAsBAQE?=
 =?us-ascii?q?NAQEtAgQBAYRKAoFxAiU1CA4CAwEBCwEBBQEBAQIBBgRxhWEMhXMBAQEEJxM?=
 =?us-ascii?q?GAQE3AQsEAgEIEQQBAR8QMh0IAgQBDQUIhXQDLgGkOgKKJXSBATODBAEBBoU?=
 =?us-ascii?q?lGIIQCYE4AYJ0ijwmG4IAgVSCITU+hECDSoIsgkkBdhOBQ5QIpWAKgnecAaJ?=
 =?us-ascii?q?gLZNloUACBAIEBQIOAQEGgVgCNoFXcBWDJFAXAg2OIYNxihhAdDcCBgoBAQM?=
 =?us-ascii?q?JfIxfAQE?=
X-IronPort-AV: E=Sophos;i="5.79,343,1602547200"; 
   d="scan'208";a="853503215"
Received: from rcdn-core-9.cisco.com ([173.37.93.145])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 13 Jan 2021 01:19:51 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by rcdn-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 10D1JoLs014538
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 13 Jan 2021 01:19:51 GMT
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 19:19:11 -0600
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rcd-002.cisco.com
 (173.37.227.247) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 12 Jan
 2021 19:19:10 -0600
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 12 Jan 2021 20:19:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBnLFXndT5KP/9x6I454lupW4ln1U/PrOTN8bRIsW4caBvYNedKuaxoci18508/t4ReL4m7dycAOtfYYhZQKW+By8NRFsAPcA+c5eaqFZ/jio9zYGKookSgKl/Z7q43ge0bzxwRPO+xBJ7dM842qByOJCf5x8KruJON6iMSf9t2X6dZpB7PhjTO0sZOQ2H/la9ZoTlJyUmcA8P4q8hSmPHL63ogdxr7xDapzK36P384kMRuO2VNM8Tf1wiQ12xu+KIg5xigIzc0DDYf+C141sZXiIsQH/bYngbeIdysOu2XbOE6RTY4ohdiY+umeffNckZTbZIq9io4VDkCmxr3Xdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj98kflfcNE97l+TTZkBATWHWZiq8iqWNXDJXeHCvPI=;
 b=b8QVs5MTwJ0AAehN+/64pa77X9Q5AxT6JfBgMJCxsZdULUe53kiu8uBdwJAFbKIkFUmHab79p2n1sD2etczRs2hhllc1o+O/MF5BX39z2LQmrb4FiAm8pOajfdlrPDgFHBUOdPVZesLNVrrZLaPx8fp/ANDYRPXKRSw8sj2JazKb+aS3Qr7c7QVqsbDwFvVDLZHwP7oa6N6W7Ryno5vprBhh33PO2jKlZ67LdYyYa770Huw6MsXznoLHLZNvCiVr+LKbuUJ+5HjXQ9y2EaSIQESsmRgyCmvmzykHkquDEahU/Ryhrl2ZUSBGQxw2vOQ5Zv6AuKtM0+tM3UvwEuSuyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vj98kflfcNE97l+TTZkBATWHWZiq8iqWNXDJXeHCvPI=;
 b=h7rhVgyl/DkDRg0m+kja892Cbt/8RUVnOOVST11kqblmdoQSXFuzwPqvltr6gId2LHMIYR79+oqCYwSxl0BQn3j9LqGNr/LK1ElNI9Ax6MfUwUVtOBFfRGEBKXv42v7qfu9k2WrJ7x4B0/lrBWet01ESHDlvZo6I1m+Dkp7/R+s=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 01:19:09 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::54bd:ca95:6853:1e82]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::54bd:ca95:6853:1e82%5]) with mapi id 15.20.3763.010; Wed, 13 Jan 2021
 01:19:08 +0000
From:   "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>, "kjlu@umn.edu" <kjlu@umn.edu>
CC:     "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Thread-Topic: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
Thread-Index: AQHW2pjvBf2oIEv6jEKa3OP+PDE5c6ok3q6Q
Date:   Wed, 13 Jan 2021 01:19:08 +0000
Message-ID: <BY5PR11MB3863D5353446248321EE84E9C3A90@BY5PR11MB3863.namprd11.prod.outlook.com>
References: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20201225083520.22015-1-dinghao.liu@zju.edu.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: zju.edu.cn; dkim=none (message not signed)
 header.d=none;zju.edu.cn; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2600:1700:ce00:1710:8134:b3ad:f9c7:9112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c550753a-aea7-4db7-a5ec-08d8b7613a3d
x-ms-traffictypediagnostic: BY5PR11MB4165:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4165E5A03FC4A9EE36AC2BDAC3A90@BY5PR11MB4165.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KigN8m3aSIzWUNH/6CUv2jn9Os5mnxu/YlMvTIuioQUoZnwEjIRfJM/h8VQx6+bN0uQvefhJS5kOt2OcAeD0VeKgPnou4fcCn74/Ylx2ZOKpFUVb4coWE+bX3C1IlISFIL+D8LFDV0bzEdethDLfmQvQzOIYuiFFSwS/7b06xbdCBKRvnzzNB80+YWWI3XfbL4220erwvL+++vV52pQAv3sktgx24KAdQ3ziJMMP8YnMJNMqeeXK+cYuEmMRUigrWfrSXCGVWAvt8krn08rtSltUYpfSISPMOqm4TqjnSZb8IXe/z8a+d1hya0WzMbG19H15dupb9vH+xLpj3W1maAjMQp9qo5EB8ARxXoz5pl1Z4oGc4WAuMehGb8lTKLJBvDW5fFgC+XPX9XX3e3O1gA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(64756008)(66476007)(66556008)(53546011)(52536014)(8936002)(86362001)(9686003)(5660300002)(66946007)(33656002)(6506007)(316002)(66446008)(110136005)(186003)(8676002)(71200400001)(55016002)(76116006)(83380400001)(2906002)(4326008)(478600001)(7696005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vsDwU5Gi9m6sufjURaR1l22f3mhyu6OIA6GDdttJtmTc3glBYfB9PJSbOJgs?=
 =?us-ascii?Q?62Je6Kl6TLoXnPh02sCBY0mCZzdYXg85NrQN5XMJT9LVIv0eccKY5ds4GZNU?=
 =?us-ascii?Q?rng7DJzktqCiEjB8jO2XKTKN6SGnv2QoPz/yeKxdr4GKxlrRtm31nAi0gy/B?=
 =?us-ascii?Q?09n7XyCh5PTpXTX6DtpA59GpprDxmxyJNj3OGdoGnrCN8fOzcmb4akbPeh0f?=
 =?us-ascii?Q?/RpqOefNgJO99W2TXEJp46lKX2R+v26ng45sgzX13XZbl+x27CfLL4CsJTiN?=
 =?us-ascii?Q?RHEvE8kKxkerxbKaye32vTsbQfsnnUAelVwoKVkUOHDwXG2kdniy+1EtHgoT?=
 =?us-ascii?Q?kcP40DO/TrjFrmNvsRUEOi+apRyfgCs1LowMuYYzm0lXHyGhUg5AOQQtKIWb?=
 =?us-ascii?Q?PJ7eq/mupRscTTgJZ0KqzWvLEiOtAZQXLLu1+mQGvn8UDPW8bZF00WRxpNmO?=
 =?us-ascii?Q?B3imTEaKAYcwrUzCduWv9wJhzLf3SSe23nF8qLBvkXN33Gg4fcvI6E4B80to?=
 =?us-ascii?Q?tj+nccLq+RzD7xAK0PyeIq31THmxTOFuZ6eG2j8Ti3BXS32O6170dT8CGPTN?=
 =?us-ascii?Q?bPxI1TIKtNwWBKWY+M02crBK9AA1XzebcKyfmCYTTAoKulDQ+myb8T4BUi40?=
 =?us-ascii?Q?2Y7QFMSctPNvn/qI10Lpx3cZ20jkh0FCLg0FOcVk7tjJYGJKmcZCW5UV0Un6?=
 =?us-ascii?Q?0rZi37Pr1Auioc/hJ15/SxZZ63z6hmWf4jzKa1UEgaDHiyTvjiI3Wh5p+4dZ?=
 =?us-ascii?Q?6dwjeqWnnnqO7ApmbZwgYbr/xMADQn2HB6mVBhXa8rFM0Ebo8fT+cshfRQ6o?=
 =?us-ascii?Q?ZVkAHVHvMM7ElIiOm+F5EtdJtjcMdAnQJRUfzutcvkevhleNhSXX0Nxd5UjY?=
 =?us-ascii?Q?SPnYZCCjrib8TpHiG2lpG3HJfitahcpO1tkPDfkCg4sJzoqku3QGV324JvjC?=
 =?us-ascii?Q?4/JRyALUqkUBv9v0NWPdhDZI0rtX48vMRq/mRsXkZuMi3ed+4VR3BKnDPVUx?=
 =?us-ascii?Q?SgQY2XXvzlFrNFCjIVPmCu3HbKr7bU7VySS8Ug454YDZBaM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3863.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c550753a-aea7-4db7-a5ec-08d8b7613a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 01:19:08.8955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AISZOjldB2QhcxXFPBcL4dJ8JOsCiW4393moEdfnZjDOTciD/D9vCjLiCZdjS+M6UAwwY77pe+eY1YhBXvE49A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4165
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: rcdn-core-9.cisco.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acked-by: Karan Tilak Kumar <kartilak@cisco.com>

Regards,
Karan

-----Original Message-----
From: Dinghao Liu <dinghao.liu@zju.edu.cn>=20
Sent: Friday, December 25, 2020 12:35 AM
To: dinghao.liu@zju.edu.cn; kjlu@umn.edu
Cc: Satish Kharat (satishkh) <satishkh@cisco.com>; Sesidhar Baddela (sebadd=
el) <sebaddel@cisco.com>; Karan Tilak Kumar (kartilak) <kartilak@cisco.com>=
; James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen <martin.pet=
ersen@oracle.com>; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: fnic: Fix memleak in vnic_dev_init_devcmd2

When ioread32() returns 0xFFFFFFFF, we should execute cleanup functions lik=
e other error handling paths before returning.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/scsi/fnic/vnic_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c in=
dex a2beee6e09f0..5988c300cc82 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -444,7 +444,8 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	fetch_index =3D ioread32(&vdev->devcmd2->wq.ctrl->fetch_index);
 	if (fetch_index =3D=3D 0xFFFFFFFF) { /* check for hardware gone  */
 		pr_err("error in devcmd2 init");
-		return -ENODEV;
+		err =3D -ENODEV;
+		goto err_free_wq;
 	}
=20
 	/*
@@ -460,7 +461,7 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
 	err =3D vnic_dev_alloc_desc_ring(vdev, &vdev->devcmd2->results_ring,
 			DEVCMD2_RING_SIZE, DEVCMD2_DESC_SIZE);
 	if (err)
-		goto err_free_wq;
+		goto err_disable_wq;
=20
 	vdev->devcmd2->result =3D
 		(struct devcmd2_result *) vdev->devcmd2->results_ring.descs;
@@ -481,8 +482,9 @@ static int vnic_dev_init_devcmd2(struct vnic_dev *vdev)
=20
 err_free_desc_ring:
 	vnic_dev_free_desc_ring(vdev, &vdev->devcmd2->results_ring);
-err_free_wq:
+err_disable_wq:
 	vnic_wq_disable(&vdev->devcmd2->wq);
+err_free_wq:
 	vnic_wq_free(&vdev->devcmd2->wq);
 err_free_devcmd2:
 	kfree(vdev->devcmd2);
--
2.17.1

