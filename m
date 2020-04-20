Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09EAC54FCC
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 06:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A436021473
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 06:55:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="NFQQrUKI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="s3/Qrro0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDTGzR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 02:55:17 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62356 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgDTGzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 02:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587365718; x=1618901718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8Zt3QVUcyB1nrYZUv4BLWy8FGBq+iMg8ScYQuxJgQyU=;
  b=NFQQrUKIy7s75Q4K1fJpCz/F7yiF4wcCf5OCi9cp2hTPViAUKDy9H9oR
   clfTEQUpcQfdYip7DuCQEVJJgxjaCt925PH2261dPZ++fuw2+UayaXzTD
   6QJSgtjB6X1RhQ+ogr6ZAjnyi5Lq31V1DUPrf56w9DlTlIAhHw0EROgl6
   OpkjKVMi9h8R/mUZr4K+7wLgpldUzZx7IAZDLK+WZMCsLOmkFX+8jFmcs
   TxGDiPxHOZEQ9x9Sv/5ZUYlti3fRtVpuk6NwCIBC3JRP/ZhCHBlRsfuZ8
   mbWR1b3drE35jtZiFBcioANzGEDhWwrPVPuafSqNiBsmivJamiDSY8XsD
   Q==;
IronPort-SDR: vwQk5ta2F2/V0LIciNJnejKf6mcvdcewU5RvInDKc7mk8uNwSaRAo5PeCLng5rc93xd6KhYHkc
 5fYhLUJ7gQ0vLK4zeNBT3yveclD3/y7aJPaJ6ibjAyeXUY+tVVaGQW8mjivQ4W7hlB9e9rInNU
 Y72sHGqTIvtbkKtvHv79hw/P+FH6825LM2W2+7PuXVuC5N2k0liP8M3CtJJyoSFlhJMUuhgCJ7
 fTHrqrJl+sidUbL+jDuH8KfUFz02/ue0UHN3yajt0hJNKW7DD40ohrLpGsjzcwcW3YSdym1qba
 nuo=
X-IronPort-AV: E=Sophos;i="5.72,406,1580745600"; 
   d="scan'208";a="140042628"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2020 14:55:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDgNdKq10Alv7EDXFm9ZRsOdMy2T4DDRSZSvvO7cyI4u07lS/yyrdijPCHAYlHCPYgr4hi5Dcgi3JtRHA6gn47gDmvWa0doQPdEcZXQU9C7gv+zf4eG03rdoSlq7P8WtMj8GFjJwijRERLgFSk04UBi/R04xovDrX+HPOEfZ3xJTnAMjczTRDSkI9neKISnuJiA+j8+Q+4PWRPU3nJGN+n0aH3svtcOYjmneCaBejD4HBikkVPU/lRlWLgljvIfBpccNnYQykVTqlAZ4nmjdEuL7HHHXNTji3mSPqqRHPSrAYhHlIPykm9gQl3Jk8HmwHjU2Mh0Kbq0TL+/nzs6how==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zt3QVUcyB1nrYZUv4BLWy8FGBq+iMg8ScYQuxJgQyU=;
 b=SZ+gpADZB/rfjJv0d0Cn3TKEtb1NGUI7ReeD+8hfwLc+FljhhFsAaqMdvjchgZKwXOcbVdTu/ylpuNzgMnsGcUZpS8jd4XNvCA7geqhD0pXyTeDI4Rkpg5IANI5LAxFDnAdIaLNXsdq+OrCQr45I7JKg2hq6h5fBzfTtws3KjgQLGnv0/3X/GRgQGB7Y7A9NpycFxW7/sbFF46StswjKO1sraA7C6/x/+JmB9MogUxftJS4NI3pNDS4bCiOPNG18KslA7aQCxMK+4KMCf80yTnHiKmOJdG+REkf41yi+JPsrjOPcyDmS9UDqkryAb5H1+NAkLniQQyX1DnkVTZy0xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Zt3QVUcyB1nrYZUv4BLWy8FGBq+iMg8ScYQuxJgQyU=;
 b=s3/Qrro0MHlVyhzP3Rls6kmIAJTkU81zpeUzYji7yt8PVqIDBDpBoILXCBx4Re8BpCPXEyEwKygbG6VOFEVBOYpbgxL4r0xa26KFymtiEXMuT2uAO8/46q02YYyfI9534lN9YCh12l4XFvm5B9IhhZx3gl3f9Es2eMlEF/ok4ZM=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4926.namprd04.prod.outlook.com (2603:10b6:805:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 06:55:14 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 06:55:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        "robh@kernel.org" <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Thread-Topic: [PATCH v6 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Thread-Index: AQHWFONzkBNCSjfmx0i9of86j86lQqiBlzoQ
Date:   Mon, 20 Apr 2020 06:55:14 +0000
Message-ID: <SN6PR04MB46405C636408D7676494828BFCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe@epcas5p4.samsung.com>
 <20200417175944.47189-2-alim.akhtar@samsung.com>
In-Reply-To: <20200417175944.47189-2-alim.akhtar@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6b97a8d-acd3-4a9a-0005-08d7e4f7c747
x-ms-traffictypediagnostic: SN6PR04MB4926:
x-microsoft-antispam-prvs: <SN6PR04MB492612391B1A7BCB43944BBFFCD40@SN6PR04MB4926.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(66946007)(8936002)(8676002)(7696005)(26005)(478600001)(81156014)(66446008)(186003)(76116006)(6506007)(64756008)(66556008)(66476007)(5660300002)(7416002)(52536014)(110136005)(55016002)(33656002)(71200400001)(9686003)(54906003)(2906002)(558084003)(316002)(4326008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OFWSgXNNPA4/22aPd0rwXtGST5Xm2jutJvP9bCNCtlX0QVKCFuehbSu+d6/kDFfeT/zTFCdQMbs98JhPhkEqDuhou2iktkgbK/GEsVA30GJ10E+af5kKW0N+hwaiHhqyUlhVRjuYn4Dv+M9dmnG03veRh8rr2BooxZLsphgtotbdqzyCYgCy5NSjqOGYTkww4dX0cWpnuFT3CgcBIoNOKWqJp2tIKjg8+p+hoNOG+A8ljROPDd6fygmkYtD4G+y9sYm/oUD5YsMin5COmo2gBrdXfYck4kzhhUugO6WUcB5NURg5dUKiwYnb7ySNwiHk6TrQyfftOMaPNEkhN+yLhp4r9Sbzc3ShoqFPrwlwg+YW9LwdvE3xyfiT5sSzS8ukCjaK5k3VkcQAeauXobwm3dxLyxyXblkkkRlMVlDZZ14F8CUrqci/+hXFw9P4cl8Y
x-ms-exchange-antispam-messagedata: whGFFmHOH0QhsHq4H4lMzcVlioYlpNWXiTH0DqVuVPqhBLeBu9mo+/Yp2vk4Wg9Ctq2f5jTfhEXanWdtgL4KzAACj5O9Ewg5XaAJMV8YmaHTaAsnjxs+hk6/TKCTh4n+o+8N7IqN4QEzbffLKqs4kg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b97a8d-acd3-4a9a-0005-08d7e4f7c747
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 06:55:14.6109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FJfnP3GNrC4JYfYK011Rs1KlgfKuWbb1W2OEJMlNHAPnz1d6S+SH1Lxo/LH5YE11B/wZK/N/ruRtT2KFIVPHSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4926
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gSW4gdGhlIHJpZ2h0IGJlaGF2aW9yLCBzZXR0aW5nIHRoZSBiaXQgdG8gJzAnIGluZGlj
YXRlcyBjbGVhciBhbmQgJzEnDQo+IGluZGljYXRlcyBubyBjaGFuZ2UuIElmIGhvc3QgY29udHJv
bGxlciBoYW5kbGVzIHRoaXMgdGhlIG90aGVyIHdheSwNCj4gVUZTSENJX1FVSVJLX0JST0tFTl9S
RVFfTElTVF9DTFIgY2FuIGJlIHVzZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZXVuZ3dvbiBK
ZW9uIDxlc3N1dWpAZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGltIEFraHRhciA8YWxp
bS5ha2h0YXJAc2Ftc3VuZy5jb20+DQpSZXZpZXdlZC1ieTogQXZyaSBBbHRtYW4gPGF2cmkuYWx0
bWFuQHdkYy5jb20+DQoNCg==
