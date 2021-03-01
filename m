Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46323C433E6
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 00:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15A5364E74
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 00:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhCAAHu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 19:07:50 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:19654 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhCAAHt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2021 19:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614557269; x=1646093269;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=QHpClTWF4ZAtZKCLjZOiIH1Z9fK1lPjcCwYrjEOKICw=;
  b=rF1WrcsqXJXjvBjQuR5wrYq1qJflKfybFWBP4ikwT0G1pLSEoWuJrZih
   /U83nBofrJeXPR7UCZUWcUiz3uYY+pgsTjXGKUO9uTDlE7e2Y9wWfK3z0
   yBOFTwYACr8gi23RN0If3+aIrlrn64Bhbcpctg0fHQcI/jv1bSDGXAo0D
   CNwit4DGO9owZQFHuVVJ9EU6hCEUg1zZ/6A5Da2cyzLtcjeen1uhTA8Cl
   yVMLe2R3txAkGTenoQ/CgB2btKDiDHdoXN4WO+spHHWzBMTvSpnrGrWi2
   UYccQowg06bK3myNCOUXIbP4++caRmmgbQ5XpgCbmZQgqFDTMb/DE5pTQ
   w==;
IronPort-SDR: oEIrsYGLTj/SvSOf0ebO54g28gIkptBbSbNWdGFBIcJFxT3DabbnnUJhgPcD2MAqHjEBN4QvpO
 kE1S9BIz4a3prgr0xR87+izpNVF6cm0t/JNLRiCWybDbVI6kenRn81tV1r4sqJS/52QBlleVaM
 QWiZVf2uoSUSqI2MoXa2v7UCXd3tBsmdhGHmpZfIybv7LhCRf74VCDdonkOrVapTL1Sr1mmsKh
 1ippABaqfFR3KHtsPVaZPs48sVnbJ7PyZaIX5J7TJc/dNggUG6O9uP4tywRo5G9u2rH14EMZaK
 hW0=
X-IronPort-AV: E=Sophos;i="5.81,214,1610380800"; 
   d="scan'208";a="162184804"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 08:06:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXOFzdOLyLajENcjVCDHeYpmFlalRP3sM5Xx19BtNrO+3UPxv4tMS/1YM4JilKUJhgopPSIuvMo6nCymiNOl6SYS9MNJv65Ks227Sseu+kco/oYzsjXjY53WMif9ZYRs2VPD9p+9JN7b+G+sNb9HhMxfDUyQC6cSivbqPUdwkZW2ArlVxcu4Deyfb49yfwP5XyVTqoMOeeNTiNOjmG15WVQrobUc33UWy4mf3Y2XZmiVN59rW0kTUlVIyII9a/V+LLpJ0Ud/3H57jLKeQP/ry2+Iy+RciDgVELAd911IjY9DqH1NrvkpE0BuCqfzhJToY900WqxbvmrDypDWTcGyWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHpClTWF4ZAtZKCLjZOiIH1Z9fK1lPjcCwYrjEOKICw=;
 b=JlvmHkQZXz7Pwepj8HlrMhIdDL/T72r33GeEO1yBBiVMeqVnvQJJzU6UFJXVAuldT6RZUk0mVaodiDfL1XFFxUKW9KTODx6hUS4frmsgoZu1SswsSARf0epMCqJ/6XD8sAxQRGphotZG4KgR5LNlJabpPBI5LzFPfhJ9GQBQ7PNqCUqnRAddmUi/BgZ4GGZ2+bNUobIZTsq0n/LfYxbI946LGucc23CEy5OJLlejFKtPFeLKGTeIcLNF12fOd9EVsGKZ2EY75XAHR2KpDEMYZKXWpTl3pEi0K1ugKYZATk+So8xFTkaI3qgf5OMOXV3zBpYhJOIshCnjpAplMzlP6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHpClTWF4ZAtZKCLjZOiIH1Z9fK1lPjcCwYrjEOKICw=;
 b=oY8ikWdBluEfy03ABLopFCyOn4N6IVau5wdzocSAaTBuc3KXUYCahp2q2sEgjKjbXy5AIeKu4BFMt7NKh+xN4qeiDG34+dqE/SBR8b+wlLBeLXpF9JXfFa4NiTmnJRT62bjD66AEjcZNGKafvDSpb5R2+X+NDL4p6tDjnZQUeOY=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5032.namprd04.prod.outlook.com (2603:10b6:a03:44::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 00:06:41 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 00:06:41 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 00/23] target: code cleanup
Thread-Topic: [PATCH 00/23] target: code cleanup
Thread-Index: AQHXDZaFrqqcc3FAg0CITiO3Md3Z3g==
Date:   Mon, 1 Mar 2021 00:06:40 +0000
Message-ID: <BYAPR04MB4965C9F7803B7045FA058FCC869A9@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <9c0901fe-5955-5bf2-77e9-b12a0d2c4f59@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd28ef2b-e62d-4aae-410f-08d8dc45e41e
x-ms-traffictypediagnostic: BYAPR04MB5032:
x-microsoft-antispam-prvs: <BYAPR04MB503283AE9B937E71EC0823EF869A9@BYAPR04MB5032.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FhHr/CQgn2qrtIAbp1Xji/1CqFUK+2hzHYUnlIuGPmVrPNDxyuO8ed2w+wPUxqJbU8+mxwb5sPszADb2UIIei7ID/4DQjHomkw4PRBlcxfBN+4J7JlR1Nkb/GGUC/ZVEZOKaiobLiUFY9MKf8FvzBSyl/j0z5v650fYysY5VHescYZ/ebpNRFP4zxJQPNShICP+ru3CtGlUME0b5/cwfqbj9SHQrdlFlg+6bYqMWtxIQQDx4JFMIRoKP3XsuszqG2P04O5wYyweE1Gt0F2G51wYYk/FdXlZXgIKhPB0taOrcbrf/Gi9hVIUZDLXuHXWemVRzIsekwZtFisIBPRBa22ul1KMED9qLJlqV9Vn2fRuBiFaCsfEK88AiY10WlUSVpjIANgUSXi0N93NJeZejzgT7yeIbJcx38DUioc7CPR+z6CSlbTF0Y7qWX2paFmWph4mZlUaVoQBVWuo56oRah4Pcc183KfYlM1omgTpcTy1ydXEv97fFwv6zFMhg6lTH9tBQ5jdcQgvUXjHOXzV75Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39860400002)(86362001)(2906002)(558084003)(83380400001)(478600001)(9686003)(66946007)(76116006)(66476007)(91956017)(4326008)(52536014)(71200400001)(55016002)(64756008)(66446008)(66556008)(54906003)(8936002)(5660300002)(26005)(110136005)(8676002)(33656002)(316002)(186003)(7696005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lq4jJT5oKBptW45Quhf46daX0gy4GgVM9mHgYb6o2HU4iJgsoNl7OW0pVQHC?=
 =?us-ascii?Q?Hsr/TdRK1p433dpbJAbwmoe8/FN+L4kLEAGYKNPetkG+lgoQzbjsARn/RUyA?=
 =?us-ascii?Q?pksqUM4+o9+jfqdeT+57PjLXLN8WqOE19ZVvwF+S3UajvR1YdjxeFe33ySJQ?=
 =?us-ascii?Q?3c2ou2rfSyTNeQmTonEGNH2aJDCY+rYaErRGUhNMJypWH86QI2P3q9qdSA9V?=
 =?us-ascii?Q?vQ7mcJP9pEvYa3xRFu43m8j0MPlrho1bvYyld9Tcxj3WBqc4SAvGYrxy77s/?=
 =?us-ascii?Q?cxZho2w9l/JVQfKjrRssv6qzWGa4sALpJ9iTrPpFKdeClzU0C5o+tbJ1uxGM?=
 =?us-ascii?Q?MmWzLbTooooL2mhzg21PO0zqrhMzdsNqvTw/u+mhv/LSuACZdsugBlF7vjgg?=
 =?us-ascii?Q?FIKbtobWcSIwUKYbJ2rNdqzg7hWNAZ42uc5jknDac2D57MZOL8y73jrOCyW7?=
 =?us-ascii?Q?kou6gs3fWRkUj0l/hMiOZ9Aw4PmN5Di6row4mSUh5yEhbFf3MTIDK5ZCCa9e?=
 =?us-ascii?Q?t/bciD60/xruTsHTPQI5x4GjffSBEUetYSTYmSYRaze1sAiUCduatwNZ64R3?=
 =?us-ascii?Q?sRM0m9a2PA+YPLA9X1LDEEPfslRb5nBK/sGQ87bGgiLawW4hQo+O0G4m1Jpt?=
 =?us-ascii?Q?vLRh4GjLsXrlAhg2on7CzsEcxIAmMr7OVq7/rYjAwqf3FsVVJSdgTOrVr7WI?=
 =?us-ascii?Q?zW5owSerNKmZEE74lRWSxKv45P5WoApKltAPZWj8A4SQ6xkn7gRfDYVV/b8y?=
 =?us-ascii?Q?K39jZYQPr6VNNUetAzWqYU0ql9j/LnLh+8WK/VJpZctqS2+3nQu94xAiEMq6?=
 =?us-ascii?Q?hnf+IORGnZP2di6nCUMlv7yNXbgI/6nAVE2Rt5OHcJkebX6YY+iG61kI7BsP?=
 =?us-ascii?Q?/MmmMf+3jJlKQ4V1hI5CJoCnSDA7kQ+tgY32NoDCmxNQw4xwneH89fVMnrOb?=
 =?us-ascii?Q?C7zSpBQvXkx5bABlknwKL8G8U5kuTrFQFeIUoamRB+yiEXexbUvDf90hj0/w?=
 =?us-ascii?Q?JIVCtKysyVAq53bH7CWylTztUVXaChVOLQqAnEm+b59i4qbDoT1/7YNVkFdG?=
 =?us-ascii?Q?JU28ufXMsV2N5Wd6+OZ/Y688S+e1iAB2sowcWXfk3gRsfS6sHs0YcV5AdqIf?=
 =?us-ascii?Q?QFCCAFJIbEMZlSaUSmahRfXntFaLYtSdboAIb0Fte8jZFuiRN6I8UsRYXIL0?=
 =?us-ascii?Q?GGXP+y/RLampPau42Jg+9quSneiq3FY/TmwLhEj9dCx3Bhg+53c1CMLqkgqC?=
 =?us-ascii?Q?tG2e572AXMmr8DlPIizUUzgtbp2PbPKOC67pCfprP5WbeObCRj8cDR0QWyQ9?=
 =?us-ascii?Q?FuBR0KUsDZ0xSpOJxnQPVS1g?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd28ef2b-e62d-4aae-410f-08d8dc45e41e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 00:06:40.9887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ilTp7vo5LaemoiJdSkF9wksok2aNoYw/su1STp9hQBmeML3kbIOIfV4/9iYh79bfWk1ONDk5kYgy0dGhNvQriZGQTGY73fnFiqu/TBhon2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/21 12:14, michael.christie@oracle.com wrote:=0A=
> On 2/27/21 11:56 PM, Chaitanya Kulkarni wrote:=0A=
>> Any feedback is welcome.=0A=
>>=0A=
>> This is generated on today's linux-block for-next.=0A=
>>=0A=
> The patches look ok to me.=0A=
>=0A=
> Reviewed-by: Mike Christie <michael.christie@oracle.com>=0A=
>=0A=
Thanks for the review tag Mike.=0A=
