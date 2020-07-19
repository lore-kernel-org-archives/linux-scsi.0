Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFE0C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 07:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E751420734
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 07:15:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="f8W1i06/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rSTjx2ZX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgGSHPF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 03:15:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:57544 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgGSHPE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 03:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595142904; x=1626678904;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=J4zuZQqES3nBwqLApVYYzadlwzeuYM5jovaFbr2LLTI=;
  b=f8W1i06/kLz0O+HIPkybgXsPdQJ3b+StL9Stf4devVjb+6oa/vnI4/U+
   dq1wiJ056PlMKASV7fi6E1d/OZEuM+1udA6bXlGoxUbmDLZnYyyS+Bzo7
   Xfg7TiYrf06AK+Sg5QaEYBgUyqh42bNjx9f1ypHGe8I0wk8V6bi77ag5x
   BHOCIOhmhwx7UlTZt8+hjMvLRrnPT0t0DHy5gLKKQUEGqdc+hL0Hey4Aw
   NvpeX+GvU8V7AFv8miwpS3ZfNGJrKX1F8FGs5kPrl4yJTdeLsDlq604KG
   9T1D8anEc46MwlXLgc9hcOebpsBx6GD0wNzBR5Hq3S4E53St20OVuD4DJ
   Q==;
IronPort-SDR: 3WlpR+8p/g/3Pt72Z9044OsGhHjmlE0NCkug6ycK+XOlqi4I3YnWB7B5oKf9r751CxZTrO++z4
 EClrzGpcXRKn44CY2LGFvKuAzG0rTqwt8AKxza9M/cnWwOF4Tjric2CFu277A7Pmb8Jw10pa8E
 Lf1PcN2ta9cZk2Jwf57ohwoE9XP9bDdubFkpSClUWtQ+NCKLWqFIcdDsRMPu6aJFsGqpzPMKdG
 xImGjKPm767dwsy/7c1pHFw4XOEYKo2fsaG5t+ri4FQWuTJyR8SfzgFuk89AsDGu8h8Y7Y/nCW
 2Mk=
X-IronPort-AV: E=Sophos;i="5.75,370,1589212800"; 
   d="scan'208";a="147137692"
Received: from mail-mw2nam12lp2043.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.43])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 15:15:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFw1nG5IMzKktMt/r96Jaeo962VeFUNc7DdxIKs/mpBizig5W/m0BwNBspXFutsIbIBqOml4885dk1bJTLh+J82jM2BOc3MUrfKdqwJjQx8Tx3VWGXPU5pbxA4Nt7TPCCab+74K2rdgwzowLzUpAmb9OUtJZbgAv05ipZraY3FsQwkSLOsfQI1eXNDIZGusTCtaX9nwf3UAqCxXLMNXe0jx2pn/VmFurS9wPKm+C3nMcRpuXA2k64O/BJnW/2uhJZjAhfFZsKFpJOZ0wXlSq/lHpuONoKorVr9ZjHyOn/SuGT5jeZhqjaouQfZb6ufjUTID3kRgJwTKexSAWzs7ouw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4zuZQqES3nBwqLApVYYzadlwzeuYM5jovaFbr2LLTI=;
 b=cJCBNe5T9PG2L5WST/tzvt/GegkOBa+L81bTwLkwqRtdg1Dlxj/gJMk07pDJzEI6e5Vq9fRabpTeir2ijXhEgHSK+oPjtgKkBaRHB2lr907nlHysdBMmZlk4tejRMWfoxARMlbsf+t2CoKcqVW9C4FWLiFUuCq9V0w8g/7qVGPiMDUxbRi6RfBZbz/V+xPrV2P81lXelBk60pwYKzVvoQTyxwEZfurtUlYZ3JstcHopuxLR0T7D7c05AAsjvv7kulY4GHhhCmuS3ZzLrqlxlbYZREB+IvWSO2rju+VCCChuxiV/AA2Ph7yej2LBJrP+zi3uSq5BjjuhLFpMFqtrT9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4zuZQqES3nBwqLApVYYzadlwzeuYM5jovaFbr2LLTI=;
 b=rSTjx2ZXT2YUGCeP7gLHoIEVKuswY9Q7WhjCOnDfrxWfZ5Ay9ByBXqXhP/7i55JeP5GysTxe/RigEjAdo0aVr0O1gIlzkhlZ6u6PxpPhHv3g2fwA9OGwZw5FOtgta8mKQo3ZbxPoGQ3xkwO0Ohpwz/gNpkrUwfuG1krmpn3hge8=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5198.namprd04.prod.outlook.com (2603:10b6:805:f7::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Sun, 19 Jul
 2020 07:15:00 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 07:15:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Lee Sang Hyun <sh425.lee@samsung.com>,
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
        "kwmad.kim@samsung.com" <kwmad.kim@samsung.com>
Subject: RE: [RFC PATCH v2] scsi: ufs: set STATE_ERROR when ufshcd_probe_hba()
 failed
Thread-Topic: [RFC PATCH v2] scsi: ufs: set STATE_ERROR when
 ufshcd_probe_hba() failed
Thread-Index: AQHWXA14crj37LJFdUijCBnrDXMl4KkOgD2Q
Date:   Sun, 19 Jul 2020 07:14:59 +0000
Message-ID: <SN6PR04MB464062D0593EC2344CC790EDFC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <CGME20200717073950epcas2p3fe023138e3c04e706a1afb887998eb5c@epcas2p3.samsung.com>
 <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
In-Reply-To: <1594971107-37463-1-git-send-email-sh425.lee@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18e63371-bb7d-4e15-3ad7-08d82bb37312
x-ms-traffictypediagnostic: SN6PR04MB5198:
x-microsoft-antispam-prvs: <SN6PR04MB5198152A99A87DECEB94F544FC7A0@SN6PR04MB5198.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8WFClLOSXaDoIUyebMT2VnTpJoyMsQYy53eUemnGsCXXHfhZliClEAEl0lnEzjY4gvUTAqq1L2+LgttsjyeoZ7Ge2Ogzggz0gbWAivZv+IKg1XyseN0pZnVmaXKmkN2yuTufE9TsEw8CPFsqIaLKx9Z/SpXqmK78ecj4AjIIZAma0w1Bo3EGm1vzWfLWMM2N8/5uUTWIY+/G+aFkHt8ZhZuKoI1JFAK6BtxkLcETopBuwxWFn/DHu10k8y16zM/WUZswUb6GXqShBFhfGY3etxMOPJo2+Ak83RfH17cjnpidf5ATcbt1nVk9t+etNr32QKD9OglYUHH8AF4ZE8TBTuG+YhVgYBgrPba6Wcz0+/2NwMm2qh6m8U0Yzz2oYw6R
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(71200400001)(110136005)(316002)(9686003)(186003)(2906002)(26005)(66476007)(76116006)(66446008)(64756008)(66556008)(66946007)(52536014)(7696005)(558084003)(6506007)(83380400001)(33656002)(5660300002)(8676002)(478600001)(55016002)(86362001)(7416002)(8936002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NhtFqBzrpnFJuZ9uYy2nz9mtNYaMHDIfaXeixSy6U/hteqEGm6us6k48l7hu1CV6g1bqcnrB5/AF0hgUn9mv6eMWVJiPOtZh0vIraMtn/EAyv60vqt+5kyXODRrwmYgo5bde6uRWljVu+OEpTiOAYZaYYynE7/ubHrVyGv9KbBqKWJ1SZkNzHdXo6Is0vnsIyAi1GmiZ67D599NMqMyLci5b76T3fpYAq09xfAQ6csfIQIdjN/D9Ma6IExax5MArTTHVMsh3airI0+JR5dcqVR00KbT4R9wKILkIMf1jnTqVkFX8bJ2IAnuCJgIB4fKfs5QrGkT69V0OCObSY7mklzpP9gb9+IhGVHUQGwwHnYgeV/KQMV/s7zSA3eSUPZsgHIh9tD/bcZctqebzd3o97fuvjMjYtvPC4VtybrLI4+62+9JKwZcw1WYrkgwwgZccXllf35sw7TCI9i14DfGeBqtmPzSnotMXVTx3FPWKoWk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e63371-bb7d-4e15-3ad7-08d82bb37312
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 07:14:59.9511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XCLtAnX7IgPCrD64kIvVYDQE5kjzBdRQ9ot6ITpBx1z9f8GSvrny8InHs63hvtm2g49DFOhv2y/4HNfgbf7IkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5198
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gc2V0IFNUQVRFX0VSUiBsaWtlIGJlbG93IHRvIHByZXZlbnQgYSBsb2NrdXAoSU8g
c3R1Y2spDQo+IHdoZW4gdWZzaGNkX3Byb2JlX2hiYSgpIHJldHVybnMgZXJyb3IuDQo+IA0KPiBD
aGFuZ2UtSWQ6IEk2Yzg1ZmYyOTA1MDNjYzk0MTRkN2Y1ZmRkOTM0Mjk1NDk3Yjg1NGZmDQpObyBu
ZWVkIGZvciB0aGUgZ2Vycml0IGNoYW5nZSBpZA0KDQo+IFNpZ25lZC1vZmYtYnk6IExlZSBTYW5n
IEh5dW4gPHNoNDI1LmxlZUBzYW1zdW5nLmNvbT4NClJldmlld2VkLWJ5OiBBdnJpIEFsdG1hbiA8
YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCg==
