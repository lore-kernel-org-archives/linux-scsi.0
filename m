Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2BBC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 16:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AD664FC8
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 16:35:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbhCJQe7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 11:34:59 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:10764 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbhCJQeg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 11:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615394094; x=1646930094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WYxo34Uwhvfvg7JmsxlOAmOvW3kGPI2ZcrMyhgbuFYw=;
  b=W8oyz0Xc2GFuefekgsWflmRHD5h2W6TwOGCvLG/08eJvAOeXv1UonUuV
   +MekSe2wdloCXxO11Y8IFMZ+wS2V3tPuBg983UkXNposnA3/a8wi2HNr8
   ZNtnjQPOwkYn2gcKe2y/eQMZbRbDOVyS4adVbDUPfFeSvO+Uppxlnguij
   Fqgqz0NkA8INx5HxiQ0mGVbB1XF4IL1psUzTuOBu2B452ksQOe/F4l5kM
   SqGkOYo11eDwKj+gVem6SLRX98l9mRwDSLjDsKaSyh03oEyf1KQCtvu5D
   S7mnup6TeFfMQEgXNYLj/7fj2uPKI8urafo392BYos3vcEzKKt7aJOurj
   w==;
IronPort-SDR: 91/bNpor5l23thP010VYLpSAcNPVhrYTdoCDP4i9lbAkrRol3IcF3x4depR87EPEU6gy4ZYo/A
 QuRNsqvHhn/nfL+44+cjZcX3SoupjxhtDae4O2cLnoWpwmYHJqspRjwZIcyoQJGc3Darv84krS
 OI174MBjH/VNaF9YUnQGFDWHUGRKojXN4mZZGr5whOhJPX1eYEQgtwNhl0529nv88YbNCS70S/
 iiewrVG97WRclC7gVkMrxDaE/CfI5dB3L4FtWkEU91eVXjZ8hBkA7/hDFNWsFmd5gM9x8UobEL
 TC4=
X-IronPort-AV: E=Sophos;i="5.81,237,1610380800"; 
   d="scan'208";a="266173583"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 00:34:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WApdz0JbriGmoKE98dPLRDI0HwbnyM5+RK7pgc0ziY0IUHBgeoUicKlrLe1KHteWS9BfNsipy2SH1+hkhS69q5faaW00GR7f92UKKDSQzylZ6lv3AU2T4hwpoT/FU+myXX1lFSr8HWTYrAYiXgN5qeUvG1xC/56fmjRrWQXDGT66la4iSirntSF9lgeTE7VK7Jlqd6yCVMtbq4du+TXpaA0Rm145Xs+HJ8sC/BSu/vVkoESoNrtYQcUD54ulcYNbZ+Nrkx+2roGADcRq5z5EGN3SDlAQLgMkxiB/sLHupHXIYYwB3Dbz1wh6Mb9gExWFQXuUFbT4QKh3qSATZEQzOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYxo34Uwhvfvg7JmsxlOAmOvW3kGPI2ZcrMyhgbuFYw=;
 b=NChlgO+f7ySSxur8pKQ6GWui0oYcHnBxdBPtFE22YzG7z50FlY5nqVbaMVP72+ih6gperPOTPC7QYP1O7PkLVDYCswM0puBgdHeEWUVshrCscogezY1cx2fxUygb5o/cRzWy84LoTZUpZHKMMeTbFMTQabsN9NIpuwKH7KPWeWcpqtWIJ7dzOJ6CQE1Ykp9bmguLO/DW6ASPC7jfldl908vY6CGUwG9RhFqN7FSgqLT96VZr9pgxzcy53GXiAFfwbtqZr5rSUblWI1lVAUpzyd8vmDulerZMiHIBG2ivkKAtmO4FcUiez0QzD8oXW5YYXVo0USZrmkvHx8AyjG9knQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WYxo34Uwhvfvg7JmsxlOAmOvW3kGPI2ZcrMyhgbuFYw=;
 b=WPtyaBju3ACQ6Fd971GpidkbQRw8Dw4K0DyTcYbf9CLYlDL4EnhobE7md0Aa/pAW88kaxtcD7HcqDcmVsCLE4B8EHgjo4ZygkReX8dvIj1foIS1aD0JmLCO2dSjSz7FvyJowZRmDXugvHD5+nYB2EiPiZuAV6Yo9JgJ7KAbyzG4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0267.namprd04.prod.outlook.com (2603:10b6:3:6f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Wed, 10 Mar 2021 16:34:32 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Wed, 10 Mar 2021
 16:34:32 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Caleb Connolly <caleb@connolly.tech>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "ejb@linux.ibm.com" <ejb@linux.ibm.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [PATCH v3 1/3] scsi: ufshcd: use a function to calculate versions
Thread-Topic: [PATCH v3 1/3] scsi: ufshcd: use a function to calculate
 versions
Thread-Index: AQHXFcLILBOEKkzP8UyE0CzAmv03v6p9af6w
Date:   Wed, 10 Mar 2021 16:34:32 +0000
Message-ID: <DM6PR04MB65757AE022DFB7C1DA9B6D87FC919@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210310153215.371227-1-caleb@connolly.tech>
 <20210310153215.371227-2-caleb@connolly.tech>
In-Reply-To: <20210310153215.371227-2-caleb@connolly.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: connolly.tech; dkim=none (message not signed)
 header.d=none;connolly.tech; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 89967592-ad99-4646-a91f-08d8e3e26235
x-ms-traffictypediagnostic: DM5PR04MB0267:
x-microsoft-antispam-prvs: <DM5PR04MB026785CB121EC03C654F8A5EFC919@DM5PR04MB0267.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:626;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fkzle4Z5RmvAWXEJ1JsD8EWWWffFhR7lqa+KLxRVDiMoOo6wo5rtOPCxuhJKx/iAv14ThemaXxBwoqwVZ39uzJy3jEjpiHFI+ti3iidViH/5V7ZutQ8V0SlHvOSb3Yt5h599N+p5OjpaYOMfxD9GtcM5qkKQXzasCg+5Fc7O0jdhYqaQBMcENZeKVI//GNrsFiB8e/1chRcOzuFXdasf4d+rOU5wfUA9rIjOj0N51WId252nhbM4mZFSc5eTZ/kQEpNVDbLvuxZCXux/Wndp0EL9tY5UbFnxhuwm4D6Ghx4bIU8w+PG5Hi9vEINnTi9YqfxlZ9+hRIvz3N7UxlNidJJuCtOxRhH2bsJeroXLRi7ZlGZC0NMgQjWjrFkdL5WWcCI/Dr/qQA5xcGVjVbLEszQ6LI6k1OmdTODrfK+dYX00Oj/15xazvrS1EYKscr6UrPcPCXrROK8NQjqGQPVgQkcjxTALA/dOVI9QO51QIFaCqRlsPW1eMPPsGm/3wRQLGDTfxZRZ0SFWkA2LTvp/Mg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(5660300002)(86362001)(8676002)(83380400001)(66556008)(64756008)(66476007)(186003)(2906002)(55016002)(66446008)(4326008)(6506007)(478600001)(7416002)(66946007)(76116006)(110136005)(9686003)(26005)(33656002)(7696005)(316002)(4744005)(8936002)(71200400001)(52536014)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aEUxNXlnT1dBcFl0b3JZU1BjNUpmSEpYZDkzKzVwMFo1bjIxZTVuS05JaFJa?=
 =?utf-8?B?S20xaGJKZDlEOG5GVWMzcjFEN0kwR3YxZ1h5S2dXOWxCajllR3NjcVp5YWNG?=
 =?utf-8?B?QW9jQVRGczBoYnJmNlR1UVU1ZFIzaUhzcG05K3h4ZmVQQlJlS0ZEVHpzM0wy?=
 =?utf-8?B?TUxyRWpLdXZtaVk4TDl1TFlucnp1QlFuN0JacW5lNDlpendFMXpZcjRuTXZ3?=
 =?utf-8?B?NmdqUWw4bVpmT2VzWUNEL08xN05OMVFUL0VGbkdkMVhid0w0VzkzNnY5MUFk?=
 =?utf-8?B?cmdERUdDYzVyRUl6ZndQZ0l5ZE9BRDZKWkZaSmJUcGYwUm14NmdTYmpxbjhv?=
 =?utf-8?B?R1VHMldILzJ2NnFycWhuVlFjZk5NQkU0VGkzVHl2UDRZTzdlT3FRQlZHR2tq?=
 =?utf-8?B?NkdqQ1o0SHNHYm10LzVRL3lpT3RYd09uY3FQUHZoLzB2c24wSHA1Qk5JdTNE?=
 =?utf-8?B?U0NWRjJha0wyQi9yazFhMkRkMHZoWTV0S3VxaitnUE5sb1JoeVZ4OW5tbnln?=
 =?utf-8?B?STI4YXF5citkSTFPUllWNVJ6ajFidE9FZXREZEdrVVNSTkFmajRVL2Z3WVBX?=
 =?utf-8?B?RGtCc1NKa3VUUCsyRm1LTGlUaE15aWVVNVJZbVRxc1VFWmdCVDVQeDRnRkVz?=
 =?utf-8?B?YkRKRG90RHl1YzFaczBkRUNBUFd4SXVaeEJnTFJYT2RLU1pJMFZYVDN5ZkI0?=
 =?utf-8?B?OE9US2xzeERXZENKZlpTTDloMXlPZld6YlUwUW1wZE04NVEyTEtubUNUMUlV?=
 =?utf-8?B?MzhTMDAwVjlGR2wvVFlVZVhNSzRWaWdlY2JaSXh3WHBUMXQ5TlBRT2lRcHBI?=
 =?utf-8?B?N21OOWg2Y0UrZUV5d0NrTWFMWEpvQjJ5bzJQVW1rM1ZVdkZWc2x1aExrSG5m?=
 =?utf-8?B?N291Um03Z29jZGdqRUVsa011amM4UGI2SkExN1hBb1doakJIakg4UHh0bEMy?=
 =?utf-8?B?cVRzakJmUjkwaGI0N0w4ekJPYzZLM1dPQS9PUU51L3A1STVWa2kwTG1kVGc2?=
 =?utf-8?B?NGRUbXFJTERzZTBET2V4UVhXTUw0OTFTUTh4eFR5OUdaSG9Yc3R4TWhITU5n?=
 =?utf-8?B?K3BEcWo2ZWhORUE4WXNVRlJmb3hna3hWYTBKOFZ1MmNoUVB2OWJzVzI2dFgv?=
 =?utf-8?B?b01Pb0tjVkdCbHJrc25zWWk2ajNvRjJXajVmeklYazN4U29KbVFlRVprVUxE?=
 =?utf-8?B?WGhUa3J6Nlc1SmIzWlNMUWdVK1ErZFdvNmdYSmxndkFWYWVkLzlnaFIrYVlu?=
 =?utf-8?B?Y0MwaElpeitTM3FhVG1yL3RMck5NSFpJYlY1Wm8rUjZHZjgyL3ZxZFNaY3J3?=
 =?utf-8?B?Z2N3R2VLQkQrMFZ5MDN2a3Y1SG4xS0pzNENkaERkYUorYkFZc2FhOFhYbitn?=
 =?utf-8?B?cm9JZjNKemVNbm1kcm03RDNBVjgzVGp5NGs3bUhYVlVOSUMrUnJVSDRRUW1T?=
 =?utf-8?B?STdqemFHcFhGTDl3VWtFc1o0R0Z4TzRwSWpWSzNRS1RHek5pMyszcnNUT2h4?=
 =?utf-8?B?dUVENFhLRkhwWTlyaVdhZGhaVzIyeDBvcG5RdXJObStUeFQ2NG00NXVNOEE0?=
 =?utf-8?B?b2daaU54eFE2RG1NVDg0K3ZKL1FpZndiS1B5TTYrZjZINE9MUTlZalErMFhu?=
 =?utf-8?B?L3U4bzFnL3R0cDZjLy9ZK1l0cURwNFNGUTh3RGZUbm1nOWQ3U3ZMNjNTRWNi?=
 =?utf-8?B?WXlqdlNqMStoTmlnOWhmK2R2eFJDcmpPY0JDckM3Z3FpS1lUbS82Q0FGM3Zq?=
 =?utf-8?Q?rQhJEtQxio6L9EnLxg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89967592-ad99-4646-a91f-08d8e3e26235
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 16:34:32.1239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2GDLPEChqMsm6Vi2QghmOto39f+7UQ+P3FgQNkPegB7sPPFjkrQJlNKwqXX341fsdHITgx+XNiJo01MQaipVlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0267
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBAQCAtOTI5OCwxMCArOTI5MSw3IEBAIGludCB1ZnNoY2RfaW5pdChzdHJ1Y3QgdWZzX2hiYSAq
aGJhLCB2b2lkIF9faW9tZW0NCj4gKm1taW9fYmFzZSwgdW5zaWduZWQgaW50IGlycSkNCj4gICAg
ICAgICAvKiBHZXQgVUZTIHZlcnNpb24gc3VwcG9ydGVkIGJ5IHRoZSBjb250cm9sbGVyICovDQo+
ICAgICAgICAgaGJhLT51ZnNfdmVyc2lvbiA9IHVmc2hjZF9nZXRfdWZzX3ZlcnNpb24oaGJhKTsN
Cj4gDQo+IC0gICAgICAgaWYgKChoYmEtPnVmc192ZXJzaW9uICE9IFVGU0hDSV9WRVJTSU9OXzEw
KSAmJg0KPiAtICAgICAgICAgICAoaGJhLT51ZnNfdmVyc2lvbiAhPSBVRlNIQ0lfVkVSU0lPTl8x
MSkgJiYNCj4gLSAgICAgICAgICAgKGhiYS0+dWZzX3ZlcnNpb24gIT0gVUZTSENJX1ZFUlNJT05f
MjApICYmDQo+IC0gICAgICAgICAgIChoYmEtPnVmc192ZXJzaW9uICE9IFVGU0hDSV9WRVJTSU9O
XzIxKSkNCj4gKyAgICAgICBpZiAoaGJhLT51ZnNfdmVyc2lvbiA8IHVmc2hjaV92ZXJzaW9uKDEs
IDApKQ0KPiAgICAgICAgICAgICAgICAgZGV2X2VycihoYmEtPmRldiwgImludmFsaWQgVUZTIHZl
cnNpb24gMHgleFxuIiwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgaGJhLT51ZnNfdmVyc2lv
bik7DQpIZXJlIHlvdSByZXBsYWNlcyB0aGUgc3BlY2lmaWMgYWxsb3dhYmxlIHZhbHVlcywgd2l0
aCBhbiBleHByZXNzaW9uDQpUaGF0IGRvZXNuJ3QgcmVhbGx5IHJlZmxlY3RzIHRob3NlIHZhbHVl
cy4NCg==
