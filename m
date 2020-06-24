Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D0A8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 09:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E87FB206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 09:08:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="m7GfDzeo";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KJWEOvMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbgFXJIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 05:08:32 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:17455 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387704AbgFXJIb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 05:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592989711; x=1624525711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JSDewt1Zka/shMDqKN8p7aBIXpkc2JNrBiaVBQxZU68=;
  b=m7GfDzeoW5ayUrfv1uxkY9JbUbCUNZGsk7vtoizyB49w8DE7hck+jay0
   LobmrY8hBb1iTrgbtKKOx1QYO7a82NSbTbtzx1LlhPvWdtFVwZQwGahYP
   DqDuaJg+dTyEGyrjvdKW0VPqiSyrBMdqzi0NfbjOk7FxkhhiOE/Rd4pID
   bifFyOjPL1JrxCThfHCSZsefyxPGa762R9tWKmV6QJAe7BlNwjB5HcaJs
   uPfvYIoV3jAItUtAKr+E0raiAe7xsoyDevQR2bMOqJd0Mp14dV//6e7wO
   jxS9rZXRwxOw9BfECkVfzjfId2evzrJX/sl9kDhhPJF5z9Zao3GebbOEA
   A==;
IronPort-SDR: IdHQa4QIjm7EWmi39iR+jODfFtJwY6kN7Hj3f4+YK9rvfNdhh6QPH58Aa2GaMRqInUEWcX04E8
 SHdFgNc+wpDnRFo16l3trGZn/FD4jtRiRSLHDbSIoFWoddNzygA9toc5rkpxEhf5f9vmmyerbt
 0h50/425z85Y+Alkxy4EjDY3vJr21263eywUfowEKRKOiZbKSQAqfKs21Y3SuzqLiKN1TdyncV
 iO5FoRADHF0VfAXFw/80k9dbYXGEm2xDgNldgJ3O+FzMhugGbD38Y1HHl/mzbMdrcZKmtj2W9D
 c1o=
X-IronPort-AV: E=Sophos;i="5.75,274,1589212800"; 
   d="scan'208";a="142156582"
Received: from mail-sn1nam02lp2059.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.59])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jun 2020 17:08:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVeMHV4gqZeei/WShDITBkWY1vzjvSJKXHdMc7m8LUtlxDYVcPU9BQZN/Y+NZivP+PZgMhSfZrpHqPas1rnHX5+Ti8xApp+p7S2vaX/st27yZKIwecXhjDjCw+Ld0JM9I3avsxczezqmQzQrkygc6mojrc72QjguIfVsIKBFdWs6TKUQ0rqs6xgMBnftgkRaQ/d3dZxF2bI9jr2d4d2z2dnD7drEbz8FBeTX9B7gxsVHZsbW0OmZAgG06JcAD6ooxOhcUPK5uXyhuPV1jHIaTAqmqK73mvX4wFEvB/VXFJ7rJnHUtkI6lXoq84YZcQO6UR0zgKcg1Bsr+CShyMD/vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSDewt1Zka/shMDqKN8p7aBIXpkc2JNrBiaVBQxZU68=;
 b=XRqP4avhaFZ/dPgz5Z9//nzVc0ejIyHnHzmYdDig4nPD1EJYCij1cz7VLFS8uyc0jCy+Q9/9lmwHNCW/abOOlJRyuOHrw42gjCZOLrewrfJbxkGPFeJkEljAnFiKJtRftsXS4EKbYTuk+gflg/685XO9FwbhWLPBFoJKYW4xJm0EmdJwNTFViJ33IEBmc5lbXRgUSB1ntFOt7GVa4c+IpHb49EnxC+ur6ndxMFJZBin0dSNi5h3YY5csZJfJNpKEgz/kH2yHKFLARCuL/OACahD1BwNiS3J4Y3aoJCL/3EBwRqU6crIM4dSAFVk/GC3peHgav1t0Aw+GazWEUaHKwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JSDewt1Zka/shMDqKN8p7aBIXpkc2JNrBiaVBQxZU68=;
 b=KJWEOvMpWKYDxuJqeAmCVOAKPfscq6FxTTUU5PhHF6rq6ouMLy5wIRf2lARds4PLg9EY82F28Cz4efYSepe4R9F0BJUHMRCFW8ZUaC1jqbZIdy+kOSUYxHxjpj13+CR+1CpIkQh94ai82TSuAJfw0U0wyRSNT/vb0EL3VSZ5ZhE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5310.namprd04.prod.outlook.com (2603:10b6:805:fb::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 24 Jun
 2020 09:08:27 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 09:08:27 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [RFC PATCH v3 4/5] scsi: ufs: L2P map management for HPB read
Thread-Topic: [RFC PATCH v3 4/5] scsi: ufs: L2P map management for HPB read
Thread-Index: AQHWSRYAtLICxV78c06ZBojfz00/1KjneyRw
Date:   Wed, 24 Jun 2020 09:08:27 +0000
Message-ID: <SN6PR04MB46409F94E8C0690B2E227B34FC950@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <231786897.01592884981694.JavaMail.epsvc@epcpadp2>
        <963815509.21592884502243.JavaMail.epsvc@epcpadp1>
        <231786897.01592884381695.JavaMail.epsvc@epcpadp2>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p7>
 <231786897.01592886181765.JavaMail.epsvc@epcpadp2>
In-Reply-To: <231786897.01592886181765.JavaMail.epsvc@epcpadp2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d1704705-2561-4c35-48e5-08d8181e2810
x-ms-traffictypediagnostic: SN6PR04MB5310:
x-microsoft-antispam-prvs: <SN6PR04MB53107839EF31C7BDA0BAD1AAFC950@SN6PR04MB5310.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Ip5MeIVIusnMzVH/TBpe/ko3edescWhOmmy14P96dabsD88rKZ3gzV/NFp3MHJ/HTxKPhZomiuo58+4UifjejRUaBnc6sBPdfFBCZaSP9gPi/0N/up88bFZ5WPoJzOaIFvHZ3kzFIkAqaExzWmSR5S8ozO09Me8axI6AIGVoZq2UetuZ+nl223sP48dzqIgHeYXhZGeWsLVzfgdYPr7dW4ouRCKxJ6rJ5m+izBds7julJ0yNEtGVKDcIp2taUltXCsE9g0cDiNsILV6Jcg1jMwJ77tzZvfJ/vTnuTVCn1sWwytVno3EpG3NkUpwis0v7l1FUVfvX4RoPpn49a4sIAdnmEjpRXqui1teFlcNU1cjSCJHGYYKjdfGbT8IiXFV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(33656002)(66446008)(64756008)(316002)(66476007)(7416002)(52536014)(5660300002)(9686003)(8676002)(55016002)(76116006)(86362001)(8936002)(54906003)(66946007)(4326008)(26005)(558084003)(71200400001)(66556008)(478600001)(186003)(110136005)(2906002)(7696005)(6506007)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dcxOR7Gn6wuTGhChDDUKWbxgdMnIJfbcHGCpasoTAyOkClKqlrkj+Lwh4Y1lYmbCywJLW2dTIo4HNePJJtvItt81pZP79SGoPLXm+NSYfxmaK7BGpVHHw1Bi/PhUjXBUAI2zUO7QSAcwHTJ782GLpSNhFbrSLQYbSe4fn+W0ETBoK/auxJ2kSqLtZ7h4fNRK+xY4jmdWhOXistc75TCGhj3RlZtQ/MELhCLCfF3azcvKzIA3XBc/ObearDAFOocw47ieXg29D4ivXZ+ka0RNfDx3+ss6Rw2r/6R5Uw/QQy7k8ajsr+2DzwTw3yGBxlaO/RT4Pxf40WArkmGiClY1vnNRDwG7Ola0f4TZnYiJ2XbeAJdmp6zWFN8Gdg+oQQDKF15NlKiZgSLWrkU2/6BNrwvRUhIQzFO/0e172qWu7qZ3ad0BNeCt5ICuLwqS6MC9fm9CZobqi6kT6rnPdmdxjzdkiEvbKv5Klb1kxpUamn0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1704705-2561-4c35-48e5-08d8181e2810
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 09:08:27.1057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cpQDg9T6V3+GGdtjKh0/haY+m0wOQPtZu4tEDv54WIgwEKmAkiM21GNqcP0fFV66f7upSmZUUua2YU84KI3vzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5310
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiAgc3RhdGljIHN0cnVjdCB1ZnNocGJfZHJpdmVyIHVmc2hwYl9kcnY7DQo+ICt1bnNpZ25lZCBp
bnQgdWZzaHBiX2hvc3RfbWFwX2tieXRlcyA9IDEgKiAxMDI0Ow0KSSB0aGluayB5b3UndmUgYWxy
ZWFkeSBkZWNsYXJlZCB0aGlzIGFzIGEgbW9kdWxlIHBhcmFtZXRlciBpbiAzLzUuDQoNCk5vIG5l
ZWQgdG8gZml4IHRoaXMgbm93LCB1bmxlc3MgdGhlcmUgd2lsbCBiZSBzb21lIG1vcmUgY29tbWVu
dHMsDQpBbmQgeW91J2xsIGlzc3VlIGEgdjQuDQoNClRoYW5rcywNCkF2cmkgDQo=
