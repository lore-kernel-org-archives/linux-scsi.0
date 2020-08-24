Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89610C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E6DB206B5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 06:50:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j6Lh70ic";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="bpg9WDFh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHXGut (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 02:50:49 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39505 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgHXGus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2020 02:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598251849; x=1629787849;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=K93w3REcNro61n1Mh1jqdGFAY9seM2wI892phhKFkOo=;
  b=j6Lh70iclmUpohQTSnd0ijiV+2G/YGBUA2ksMTQVsD0Bu0IqQl9u9fHu
   l292YobqauzJSX2IjTmXpClKLRjZt9/fLi1owDAF2kqFTaVpUCf0FF2B+
   ZAeKU4N46jKQ7p8UFO96oCd1niHMFvlb6xIoKdCBpt1F66DZcpCdu8ZAR
   kC/lNgSAKUomBOgmK4MklBKXy0nI463uc5OFiljTI5YspKZTOD0vC+uLU
   VB2sbwPjsCDb0EXbhM7eEj6rdt7IUYRDNgKd8TCPxh/GQTsyRQqsh/hew
   Wv1ZGIrBIlAEwofaDTKNeApHBgWXkD84MFdIR5UdieWckY4/FnqLYi/Sd
   g==;
IronPort-SDR: OLZH15HNZNV6qhUmOeKScYblBJ99tYZ73jyYaR/kLHcQvXQRvf0fdVQCFK9DpuWSzR7yM1Txbi
 0aPaKvHOB+p99vfV3jLh5YX5PmvQFZFTYtMO8gVRTdR43LtLEJtbg2kqXBuzzh7+rsOMIYqmGb
 JkaVnxbWTnBtfiOdA9DNQ7lauVhMv3izJcJVWfrFOGEfkFEr5JsJNCZ0a2DWGGbwJmgg9dry7X
 3cZs875Oe22piTvyDWBsvsELVnOWOKW5O65Phgk1Li3i4dmJN6P3dOLdUZoB1Qvc7NyQCFx4Me
 LQU=
X-IronPort-AV: E=Sophos;i="5.76,347,1592841600"; 
   d="scan'208";a="248875096"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 24 Aug 2020 14:50:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/7edxSikgEGhOfHs4pM7A+02RnX8N6Pp4RAYuCqo8ReCsudwPB9ev0PPKfVqZxZgEe7kYjph60xuabMo+WEqamFc0GmOjPFO+1ZXJiUICY+dNd+Q3L3JTLBZpuW30I/eH4V4HEYiPys3zMVztK8wBVxHvDttjU+X2MTinAr8dCYuDuUUWHcrPQTOeACahyf2UwNFboYjuVftVkybLI1aurcwCCZcVPG9FXUAImjeQ4vH/lMnZjRRQSuPaCsaMpQ9+UOWcRLFosf8f5ZeIPwObXao+gDJxtd2T31xe89HFs2lh4H1r4A2z6bl+HO9T0UFgR/j7Z1ekiRL/CIVkNSfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K93w3REcNro61n1Mh1jqdGFAY9seM2wI892phhKFkOo=;
 b=oefwiWLmTYWH6IOFPxWHmklvX0VHugvdyydRioaxvhtsRVfV0fV1/wHqQxxVIcyMlU5pt36TYjv1eMUvde6hbBi81APewIEWlu9wG3GdVLuRXpY+wVlhEmTRcJ4Kqo55inm5Sebpqx1LfOU3NBKwmWIB1XAafVnuCHQW3IspiI+n8rKDzfzYrJrQh9aekF81H2ID7o+sVTP0oomManPCw00WnhzMEMOvBI29rovjmeI6YsSp+1g91HZzMoau2RFLbf6+v/0yHsfTWgK4P00o3PvvxamNx3W5rbFeTkLxjVfXLBderA5xnDZu3AHLU+gacozq+JFZC6zhJUvNjijQ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K93w3REcNro61n1Mh1jqdGFAY9seM2wI892phhKFkOo=;
 b=bpg9WDFhs4dBHxW+oc8WRbsecxHsfWRsOlKGm1rVHMMdINt0ex/YpUSdF7wXciYQbXWyWE5Va9jhwrWOHTQ0CLAGvXlOD+OY7+pDV3ymui7tPn71wVFMbfx7swAl7VfPwnOp/MGah+e2eE7CDWkjax+pyVhdBty/2sMC+WhT/DE=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6453.namprd04.prod.outlook.com (2603:10b6:a03:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Mon, 24 Aug
 2020 06:50:43 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::1083:4093:49fa:a3fd%2]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 06:50:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [PATCH v2 2/2] ufs: exynos: enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Thread-Topic: [PATCH v2 2/2] ufs: exynos: enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
Thread-Index: AQHWeb+jG7OIQLpJ5kyUE2Sjrq49NalG0hsA
Date:   Mon, 24 Aug 2020 06:50:42 +0000
Message-ID: <BY5PR04MB6705FCE2C74A31EF2CBF254BFC560@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <cover.1598236010.git.kwmad.kim@samsung.com>
        <CGME20200824023813epcas2p1ff02473d05b0c69815f779d350fb8d0b@epcas2p1.samsung.com>
 <93dc4a17520b92b1f990bd7d82523435f8ed6dd3.1598236010.git.kwmad.kim@samsung.com>
In-Reply-To: <93dc4a17520b92b1f990bd7d82523435f8ed6dd3.1598236010.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc486f70-cbcb-4860-c332-08d847fa055f
x-ms-traffictypediagnostic: BY5PR04MB6453:
x-microsoft-antispam-prvs: <BY5PR04MB6453C6D49EEFC2E295665E96FC560@BY5PR04MB6453.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rjh8mgxPtJCaK0qwGMSA8LYNttfrR28k+7a44p/T0GHCesdmwinBMuyp5O1Fnn88+7fI5Jqg8v9xhvDVuFCv/tQ7nuH72Vy3E4iRobWX616aY+jNSjlZUWHLh9vJA/WuMi8//QPM8KI7BZcYOcApMDs8+LIo3i7RtJmsU2ggW2bTZfWBQcEztJnelB2UFHEjW7pLgNpSta7J/jPgFQd6Vfv/rsHGcODMWdl36xdbUGOwlA6Ij4WKJ3/qWO7KIzzwMhbcpvLw+bviU0y2Pr7heM/iw1vKHyLz4C0kqyoRybX2OOHizuQODMZfAouNWkmZpb3U29aCofn5E5VC/MFw9LxYGRNrFqOJeZEjmeAsJ/1t3zkKUHlOqryP7bGaptaG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(7696005)(71200400001)(5660300002)(33656002)(7416002)(26005)(6506007)(8936002)(52536014)(186003)(558084003)(8676002)(64756008)(66446008)(66556008)(66476007)(86362001)(55016002)(2906002)(478600001)(66946007)(9686003)(76116006)(110136005)(316002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yJcU0trWs+wRYmAj9N4+lhmrSWNcC0ShZT10iPvibnQjHxwq1LuKd8jSvxHWlGSEBZFnMBVGe1FsW8aqVf8jyMIb98Yun9t4H/eJcPMEbLfvEgqCpDXPo2hsqXTkwS2kIgApS4fK0TwQ0U+iHcobC4572Yl/Y+55CiEbbCqfifV30iSlv099T9DH4Ce27QPw4k/vAqYOjlbjmSjNDzhddJ69lsGnnoaDaz76Zx7Xh4Wk8gi89yGqH5oe6ea4TqESuSd/Xid28TbXBwIOj1rJ9JOWjOyuBHEpk7w5dXOSZRjXoj93RkCvERHlurbDta1wik9+QThaAddtcuYsQeMVj34PnFir/OpfN1jf6NeO7wFdgGdjiwzLHg4FkhZQWcLOU89iGuAOWRGenoHP5NYwypfv/nWUrxAvNVM+WQuXCLxaA032GEetkHr8f6fc3aj2k8YxxfHP2LAiudro0x9F9C1vPcMdAK/3TRlqsfXrTe+5jIK6G+ATIa0gLhUUCOTIpMnHAxd5dbbdUpQcGT9rrCzXNmD3mnfotKNrWQTEc6J2DcJSg4U7JqrLmlKHEK+YGdg0MPfsdIiv4XsOB/2V0bCWjMZ0RNKDLvJAu4aWmBEbdC+LlyqXeN46dAMfwTlxUiQS+fXX2h3Wc/OkkFTSog==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc486f70-cbcb-4860-c332-08d847fa055f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 06:50:42.8551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r0Tj8RkMGIMs+yARRAqGC7KKe0P2AoYd+ymPUq1M0JAnUav3eTJoeXoW6Ghg2YyzJwDROiImMIuG3BTc6j9t8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6453
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gRm9yIEV4eW5vcywgb25seSBmbHVzaCBkdXJpbmcgaGliZXJuOCBpcyBlbm91Z2gg
Zm9yDQo+IHN1c3RhaW5pbmcgcGVyZm9ybWFuY2UgYW5kIEkgdGhpbmsgdGhhdCB0aGVyZSBpcw0K
PiBhIHBvc3NpYmxpdHkgb2YgcmFpc2luZyBjdXJyZW50IHRoYW5rcyB0byBhbiBpbmNyZWFzZQ0K
PiBvZiBpbnRlcm5hbCBvcGVyYXRpb25zIGZvciBtYW51YWwgZmx1c2guDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBLaXdvb25nIEtpbSA8a3dtYWQua2ltQHNhbXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6
IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
