Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3736FC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 07:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE83320775
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 07:08:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="T/FBsq06";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="svwMBYm3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgF1HIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 03:08:21 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60472 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgF1HIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 03:08:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593328100; x=1624864100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UzmeeQ9QuGEzKYZ2WulIZxP1xwYA+r52lULPbW8Q/e8=;
  b=T/FBsq06tgKfORtVHP7OVrFeBVGdRqt/rQIgZronKDV9dfu9PfGF4MOv
   9F0Uy6NcbMkPJGTcIUAV3Uc7rW1Nu/dfMmPBwbk/u/u4DWKslmv0oWfG/
   j6gy1pNXTCt31+PImaRQ0qykbnIQWpwYEHV8xXP/ySn2cFhThcFZf47kF
   kXxjoEAqrFYBKLZFXAKiMbzLesuEOahK8FBejyJFitajJCvKjQH7l1m2o
   V5xxDLJtGri7ZTwkVdlv/K5GWlTvpL6byJbHlAd8IKlLGAvPTynHu4YCw
   ya38lzqIiXAsAj02Mp2OaAgnd710G3XHzp/emO+yHw8sAIlXtH6rp14Wn
   A==;
IronPort-SDR: hRrTYYG36ndI4DZRwYBaNPgIHthM0EDFj5gRmHTN79JXAUaFG1Rb94/FEQSWYn4cBP0j/dNkOZ
 GiQ0Xrnjz4Iz9OG9SSTYj4zCgU4Dlg77m4an0pzfk2ZsAkqPdjQ4vrho/hhhUCAxNYdVmzWMY5
 9T6+cOUehm2esm0UP18LC5wN2a5Y9C9I2EbKY5Qa8KiKXKGzYa2rdP77Kzo0teKaxGNJfCBB2K
 q8ghQpjOHIKRpJeUy6LFPO+2Fm9GQC5rbq6aK5kOTMQujZNTyUF6nm0iEsh7rtzdsPSz231iFi
 tBw=
X-IronPort-AV: E=Sophos;i="5.75,290,1589212800"; 
   d="scan'208";a="142458228"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jun 2020 15:08:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5q3pxAQHtvmDP4GsJL7S7o9dOnTk7O0IuqJ3BqpfJHc9V5bswAcII5Djxc9dtRGyRSBwghwQoS3NrIJbXd4fPcfEfLfZSTllRSDuScEI1cD+WwrLDrTXaBdiqQFRFCv0Mpf69zWW0ir5zewEoyjk1h7WkD8wxi7XDV2JvxrhbFQyJjKXhyg91fIDRY6HpJ4ukrjfiRs/WyZFw4nH2kjr57S1/zkg1u3iW6K8YPO2bxfuXlDUQqlqaPbf2a2DgChpjSAfs6t5PRtI00P9Vwf1UL9MzCqlgpPjlO5YgK8+PfxzxIH2lp48ixMknGV/tXEeNqZV1rRUccfBIUEaV990Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzmeeQ9QuGEzKYZ2WulIZxP1xwYA+r52lULPbW8Q/e8=;
 b=c5m8zq+z/dsX3ZYt4aZstm5YSsylOJOrCF/RrRdwaktpuSb78Ru20iTrhhq5QsG8pOTjJ9I9vdKkyKeOIDlR5m9ZAr0BmUgflpvp74R3KH91x4LlDbF9ggR3cpLOqI6voiPdTZoTa/PbalGST5Y1qAmzwYx2RRefsR8fMn0ioEDbh0tFKqMnGkzHDC/Qpw3fpAHrl9HBmvEdM6ILf5Kl3LQwg53tt722nH0HR7MvwDT3YhPXOVag+VRuTJKGifJsGE9wOFTlCampSUumQXYRE8oqQmgcXLwHqVHgVUSwUY5TZRFpQItr4cCaFJm+9GyTcAwPqPFAThogQNl7tcMtfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzmeeQ9QuGEzKYZ2WulIZxP1xwYA+r52lULPbW8Q/e8=;
 b=svwMBYm34OdXdXm3GXx0e5VDldfChZeKrNH17Ik/glu/RumKzzu0eO3nvnf/7oaLjapwUpBDNE/krWNFb+weBseIfCFh8awZDt97GbStp5Y3Z58MJKpQ64ZNOT/pAukXbN+aok7ddZHkeW/HQCVsT99waGCvIM8VqdbLQ1O5xJc=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5101.namprd04.prod.outlook.com (2603:10b6:805:9a::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sun, 28 Jun
 2020 07:08:18 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3131.026; Sun, 28 Jun 2020
 07:08:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Subject: RE: ufs-bsg node not created
Thread-Topic: ufs-bsg node not created
Thread-Index: AQHWSyMR+b0BjEJQCEixycLUsj0D6KjtnUbQ
Date:   Sun, 28 Jun 2020 07:08:17 +0000
Message-ID: <SN6PR04MB46402B987856A3A8472106A0FC910@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CAKR_QVKaRMshWKGEhLpRK40yix1UP1ZMaoDJPBHFBdazc7L0cA@mail.gmail.com>
In-Reply-To: <CAKR_QVKaRMshWKGEhLpRK40yix1UP1ZMaoDJPBHFBdazc7L0cA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a3a69a0f-8640-49a9-f245-08d81b320885
x-ms-traffictypediagnostic: SN6PR04MB5101:
x-microsoft-antispam-prvs: <SN6PR04MB5101518B666B62AC69C2C003FC910@SN6PR04MB5101.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0448A97BF2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UzZE/XxVOuiPXIijwIq9qs4f7qBlFIywPqNRF0hvdz4/tHS4TpZJxiPozb6O6/c6NS6eiNutKwy50PwAd1toYuKnO6DFCYhWz+EMoAwcOa4fyHHeCadvn/jVuodBvDXejA1Xwx8k5+JjlIyzzAlyFKnKakWb70pwYRSWLd5oLJmrJCMbMxXCmnze5g4gV1e3HQxqpsfwa7bAwBA4GBKOZvpMYakoibmPn5Avfeve1WR2+3BGt3RjwyNWtpv+iwOG+ZIlAUEuwxpC1QiE325S8tV5kokzYylqd8mNxBrzrNg5S1Ygi1Ej/oRgz+DKF3bg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39850400004)(346002)(376002)(7696005)(3480700007)(8676002)(4744005)(5660300002)(86362001)(478600001)(54906003)(6506007)(110136005)(71200400001)(8936002)(2906002)(33656002)(186003)(52536014)(9686003)(316002)(55016002)(76116006)(4326008)(66946007)(66476007)(64756008)(66556008)(66446008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: nSMZjIvkPEo8VPDF5UqP9Lgu1fMhNIP5AEA1HnndGcr0k9r27dI1W/qdYeKAgqSaciydc4cW2gtWuUI7BvDJjmK7VZoLlxwKc5PdTU/BE8n8R7tDe6vQeOEPMn6D4BMUpd2hnl1droiciWZiHl30MOWJPfCgO8/s4s7g6ffbHgx2WVfAJaEcFK5HlPVVCakUI7R6KgltCZ8hlMMoqlqyWrkRAc6acyrzm3wdhQ1gJl5iChJPSuTxtktUwwJfQVVlXXIdeI/F8DBpFuQEQPNbxSNj3Q+J2lPaombIiTccIcPx7KbcwVEILjTR1mA1jsvd387xRl6UowaWmqTQDB8Q4bRP3YMdIUpZWgVszz6sXjTL/dZHTj0o5Fu+voT3fjlR/jegbafA3+n9V+isSTXtv8wCz72OSehF4xk0B8yqdtJ/fVAj4m/18sf7jSyEwrjRF8cZfNG1Gn2cCJuYvXFnp3PK5wVBdo+8LqTrhLHojCI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a69a0f-8640-49a9-f245-08d81b320885
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2020 07:08:17.6976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVxoXHYu1mPfVm9itolDRPd8jrfqTILqSBzzBqF0ajfNINpwM3QcDQbtENs3x63q6hqTOqmXjmRFS1WLwP1yvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5101
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgVG9tLA0KIA0KPiANCj4gSGkNCj4gDQo+IEknbSB0cnlpbmcgdG8gdXNlIHRoZSB1ZnMtYnNn
IHRyYW5zcG9ydCBmb3IgU1NEIGRlYnVnIHRvb2wgYW5kIGZhY2luZw0KPiBhbiBpc3N1ZSB3aGVy
ZSB0aGVyZSBpcyBubyB1ZnMtYnNnIG5vZGUgY3JlYXRlZCBlaXRoZXIgaW4gL2RldiBvcg0KPiAv
ZGV2L2JzZy4NCnVmcy1ic2cgaXMgYSBic2cgbm9kZSBkZXNpZ25lZCB0byBjb21tdW5pY2F0ZSB3
aXRoIGEgdWZzIGRldmljZXMsDQp1c2luZyBub24tc2NzaSBjb21tYW5kcywgYnV0IGEgdWZzLXNw
ZWNpZmljIHByb3RvY29sLCB3aGljaCB5b3VyIHNzZCBkb2Vzbid0IHNwZWFrLg0KU28geW91IGNh
bid0IHVzZSBpdCB3aXRoIGFueSBub24tdWZzIGRldmljZXMuDQpUbyBjcmVhdGUgaXQgeW91IG5l
ZWQgdG8gb3BlbiBpdHMgY29uZmlnIHN3aXRjaCAtIENPTkZJR19TQ1NJX1VGU19CU0cuDQoNCk1h
eWJlIHRyeSB1c2luZyB0aGUgc2cgZHJpdmVyPw0KDQpUaGFua3MsDQpBdnJpDQoNCj4gDQo+IFRy
aWVkIG9uIGxpdmUgVWJ1bnR1IDIwLjA0LCBhbmQgVWJ1bnR1IDE2LjA0LjYgaW5zdGFsbGF0aW9u
IHdpdGgNCj4gY3VzdG9tIGJ1aWx0IGtlcm5lbCA1LjYuMTQuDQo+IEFkZGl0aW9uYWx5LCB0cmll
ZCByZWJ1aWxkaW5nIHdpdGggW1BBVENIIHYyIDAvM10gTW9kdWxpemUgdWZzLWJzZw0KPiBzZXJp
ZXMsIEkgY2FuIG1vZHByb2JlIHVmcy1ic2csIHVmcywgYnNnIG1vZHVsZXMsIHN0aWxsIG5vIHVm
cy1ic2cNCj4gbm9kZSBnZXRzIGNyZWF0ZWQuDQo+IA0KPiBJcyB0aGVyZSBzb21lIG90aGVyIG1v
ZHVsZSB0aGF0IG5lZWRzIHRvIGdldCBsb2FkZWQ/DQo+IA0KPiBUaGFua3MsIFRvbQ0K
