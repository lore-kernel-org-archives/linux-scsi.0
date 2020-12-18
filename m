Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02171C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 13:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B886723A62
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 13:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLRNe2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 08:34:28 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:18724 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgLRNe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 08:34:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608298466; x=1639834466;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=npUFNa9NwKLAbkNZpCogdpgD4sSLof8iDnzT2T5OrWY=;
  b=qr1TylHtSdGS3GZ1vslZXWf/Qiw2wmqroChIb8rY1XlmLBJ0ZgXv9HDj
   zeaQslqOgkLzZMpSn6YPiKVrbGmrAoCnmuZTIgJ7K+0Fu7CBgMvSZUrF0
   J7/Vxm3xuel+byVX2ATBpOU2qJO3v/srR6NXIsKDy6Cbh02AcMbuCYKX4
   X1NqvpFQhXdDboDDtf4lcflZv+vg6+ceweR+/7uEmV1OdRaY7Namjp2Ef
   EUuglfeuNeaOKnf36ZAB26o1lSFVyUr9srAJJeYTinUzUgSOuejIdBA96
   n0TwTV3wBhLR/bpjc+0SSz4qzxgNf5U+pDhWvJwvDjbRJGgW9ARhOuWA0
   g==;
IronPort-SDR: fgYMn9VTSA61KTrvDosUfNYU65g6ZTajym+op+p8jpZnoJ7Ftm9G3FPUP7gdcfNl0ShX2/exzu
 h+rX8srL/Y5Tm0I7xljgVezQK5a8pCPz8hc4k8hsZLH0qFEdaYUSv/mCoeW/tySUPQ/96UKJW0
 Hi0zP/3eJuaHRmfEVhCsbRaPspRFbUbAyHb+daquWtNCmYroEu7BngpusLo/0tflLqxaf9Eia3
 gUz1KqJqt5e9EkHr3y43ynIOIuef8HHA/3n8HnDSv1Q4nieGETCfcCljQQKgU4+hMGQWlKs8u1
 iAE=
X-IronPort-AV: E=Sophos;i="5.78,430,1599494400"; 
   d="scan'208";a="155507444"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 18 Dec 2020 21:33:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTRvDSkMfcJx/VVBJ8D/AtnGqmDPNZTMveCUJ0O/A6drAoVyk1xWr8xdG2SUePPKTyAKvTlO0lehce6655wItTmUF87Z1n5e1ZuKeDp+lVoTnx4J5FVxDrSU53ZE3BG8bq9wiKtwv8+WdjK4lGEowYpmYORj1EenroAPF7dblAsgfvxSobZfd7OUkONjUU71RaSuNXaxmjvoLbKDTVU7lNeBrvdAqZuwLCxiIsJ+FcrHrcxUCopRFZijErDm8m5CTv+WPYbAPtJedfesip20kYHRHWJz5IorD20qLkYL8+KvjyH1R/XKVEVGWXfAAZnRRZwOtYddGj6K0dzv7Mo9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npUFNa9NwKLAbkNZpCogdpgD4sSLof8iDnzT2T5OrWY=;
 b=odbfa4K5Uya6lUrTd80WQ6ApXctQu4Eg4Gm8qoT5LiDUPIiyi997EIfr5i6P+9kvyq1ybGHWo6+GPII138EdsdnrowK7LBKE3kZtQlWOmJaKQ8c29ftxEbhp7DOpGpNzV4y0Edhjg7AOOplHVdxhlHoci63U8lJbyj6RAKSR6nswo2caz3ReCshRcQFao40J+mm72+BugGhWljtJmfkquS8iwBaOmWYKNNjuZwjMjq3lsdtqPKiGnUSpP6/1XE5NhCXq7tpXXHXryeQP6JXctwM4ls+yCpTqTrAsUIk91Aiyo1HUPg+TziWs5aBKu1OHjbGivTO5E6j/6tpOFddoHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npUFNa9NwKLAbkNZpCogdpgD4sSLof8iDnzT2T5OrWY=;
 b=yWWF2c1Ex466DVddQHn+JiELuFt7p21XalxjqjB8uCcLBiRRECtM797Q3GGedykOTocbumJb0MoK83ii4C9lnZrHmq3L9/kXV/wqg73AFYGCwAyyuDSd6hjmgi+3IPacQDlECgmIxVOfvujI7Bqo01gDakfM88ipBuT3MPZq8gs=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR0401MB3653.namprd04.prod.outlook.com (2603:10b6:4:7b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.12; Fri, 18 Dec 2020 13:33:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 13:33:18 +0000
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
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [RFC PATCH v1 0/2] permit vendor specific timeouts for PMC
Thread-Topic: [RFC PATCH v1 0/2] permit vendor specific timeouts for PMC
Thread-Index: AQHW1RFFyXr2BdtWDUKHyL2GDiicF6n80nvA
Date:   Fri, 18 Dec 2020 13:33:18 +0000
Message-ID: <DM6PR04MB65754CF9B01B346840FF98A2FCC30@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20201218074142epcas2p4c5f276e54ff896b8e990303376a15154@epcas2p4.samsung.com>
 <cover.1608276380.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608276380.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3079d29a-0f27-4e6b-a15d-08d8a3597b2d
x-ms-traffictypediagnostic: DM5PR0401MB3653:
x-microsoft-antispam-prvs: <DM5PR0401MB36530065A4B1CB146AF2860DFCC30@DM5PR0401MB3653.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rcQDH1FL/1PHWx4R0v24aAVQ2HtmcPAY0GFmYQOUQBqZYtkewXylMK5bO0lXMw4Qa2acJNLljGYC72s3tdG0Ppia0MtfY6qO7lhOTy5u5qeDLNBx/GE/AvLdQj6T+MgwVqlMRyNs6axGwEywvZpVs4YTzbCfjlboMQMmxIhDVnfm4aS1KLEkrvWWseK4L7UT0+ANc8VaKmfr0mMscI9R59n3msI+dDkWtVUMhKbePcweSv6fVx7Y5V+mEJdgh8fFDqXOVQqMd6BLL1T7FAjjpab/n8L5zIPkH86n+wNK0VdRINjjqZovX9n9X6oxQo/acZNzfMqpatQ+moVkufRUTKSX6K45JKTVGVNAeTakJmJmQApspL1DKcHAcixbODvc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(110136005)(55016002)(66446008)(316002)(8936002)(52536014)(5660300002)(478600001)(66476007)(86362001)(186003)(26005)(64756008)(33656002)(2906002)(71200400001)(76116006)(7416002)(4744005)(66556008)(66946007)(921005)(83380400001)(9686003)(8676002)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RnhOc0E0MXkxU1BZUGJ2NExpRTE2S3QxMndpeFJFN3dNNkFVKzVqc2hSOEky?=
 =?utf-8?B?WDNRRklKWjIzN0hyenVpM1JNa2o5YzlvKy8rTVZYZi9PNDR4SW9SOWhmQ1ph?=
 =?utf-8?B?S09Oc3gzNVN5QUhpQ042ODJHMUNCR0VKazFkcExmMlpDZmw0NzBvS29zR21Y?=
 =?utf-8?B?eldjb3d1WHo4Wjk1ZE01VG94L1FMQVFDSVUvdDBrQmMxdCt2NWVrc3hmbVFW?=
 =?utf-8?B?MSt1Z0FIR0FNbjhqdGI3QmJQeXhoeHFGVVB3L200VHo3TVl6SGN0Q0NoY3Zz?=
 =?utf-8?B?R3ZWdlVrenhzN1B1YXVqZWRGdGh2b2pkTitlbUwxY0REYXZUSkZ2eWo3ZVd6?=
 =?utf-8?B?SlNoY3VBMzdzeWxDdUNZVUQ5Y2thTWtVU1hZVldDbXRYeWRqRmdYSXVkelRz?=
 =?utf-8?B?REdDRTh0WWpleDlOUWl4UU9OdUFsbHhyQnVvK29RaHZDN1ZmdGxnOFNiSkkw?=
 =?utf-8?B?dmZQTCtWK2RoaXNKZ2E3UExVWFIybVJheHY4OGh5T1dTTG1GNE5BdlNtSmJB?=
 =?utf-8?B?bDFoSmljNUhVWDdBSzBUTVdBVk5hNFkvYnBMaktmZFNsR1BtT1IzRlBwMHpZ?=
 =?utf-8?B?dU1VRWZtVGtlbWNFSVc4ZDBMQmw5cWFPd24xa1l0V0pEUnlTeWt1elZHSFAz?=
 =?utf-8?B?YU0zLzIzL042c3ZnYW9PV29naGFvOEk5RGROdmNTc3VKTzZaLzA1RFRnSlBF?=
 =?utf-8?B?dVhZTnd6VEd3WkxQeDNWbDFoejFYVmRTa2NmOGRVejdVWFFicUtYdVRndmpQ?=
 =?utf-8?B?d1J5OXVnWWE2MG5LNm94YzlBdXNvSjZPSE1aTzRnNUxaRVhZWENmRTJxenlU?=
 =?utf-8?B?bk1wK3AwQ0RETElZemhDN29saDFTYVVYejFlYlJQeDllY25aV3dHMFZFc3k4?=
 =?utf-8?B?TVRxWkppNjlndmg3am1ZQjFjVVBJMVd4YUZtK1N2WkFpZ1RpaEpob2dmVkF6?=
 =?utf-8?B?YmY4eFBPekpCcmR2YjA1NElqYXQxa0UwUHJtc01KYTVwc05rODZHcEFCK01I?=
 =?utf-8?B?cEJONlo4OVhlczJiSStnZzBadHViMUxLUmpPM1lkbi9MRVQ2VkwzSnZOVlho?=
 =?utf-8?B?UVRIbW9aY2FYQkdoRFJrOEJhcnRaeXJ1bHNUMXQzd040QjZsZHcrZ1FzR1Y1?=
 =?utf-8?B?V0k1ZGtMWXlyVmw0Y1NUMVYybm1YNWtEbUxpb29Ic1lJb09lRVVIc080M3Fv?=
 =?utf-8?B?UlZJZWU3dnA3MnNlOS92djlUaFpHY3dva3ZDWEovSjBzdElPUUU3N3R4dThH?=
 =?utf-8?B?YU5IY2dYLy9iT0dTVE5DdHdURFFPVlI0dGpCNnNGZTlIczI4dGdXQWlhckRo?=
 =?utf-8?Q?tYURGPZxeo3EI=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3079d29a-0f27-4e6b-a15d-08d8a3597b2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2020 13:33:18.5575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/M7Ki67umMTjcsveob8zpZSh+qULrbI77Q6azZZTczvLgibMa99UmoSZn2ylwBRym3rJENJNjEZliFOvw8qVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3653
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IFRoZXJlIGFyZSBzb21lIGF0dHJpYnV0ZSBzZXR0aW5ncyBiZWZvcmUgcG93ZXIg
bW9kZSBjaGFuZ2UgaW4gdWZzaGNkLmMNCj4gdGhhdCBzaG91bGQgYmUgdmFyaWFudCBwZXIgdmVu
ZG9yLg0KQnV0IHlvdSd2ZSBhZGRlZCBhIHF1aXJrLCB3aGljaCBpcyBub3Qgd2hhdCB5b3VyIGNv
bW1pdCBsb2cgc2F5Lg0KSWYgaW5kZWVkIHVuaXBybyBhbGxvd3MgdG8gc2tpcC9zZXQgdmFsdWVz
IG90aGVyIHRoYW4gZGVmYXVsdCAtIGFkZCB0aGUgYXBwcm9wcmlhdGUgdm9wLg0KT3RoZXJ3aXNl
LCBpZiBpdCdzIGp1c3QgYSBub24tc3RhbmRhcmQgYmVoYXZpb3Igb2YgZXh5bm9zIC0gdGhlbiB5
b3VyIHBhdGNoIGlzIGFwcHJvcHJpYXRlLA0KQnV0IHlvdSBuZWVkIHRvIHJld29yZCB5b3VyIGNv
bW1pdCBsb2c6IGJvdGggaGVyZSBhbmQgaW4geW91ciAxLzIgcGF0Y2guDQoNCkFsc28sIHlvdSBm
b3Jnb3QgdG8gcmVtb3ZlIHRoZSBnZXJyaXQgY2hhbmdlLWlkLg0KDQpUaGFua3MsDQpBdnJpDQoN
Cj4gDQo+IEtpd29vbmcgS2ltICgyKToNCj4gICB1ZnM6IGFkZCBhIHF1aXJrIGZvciB2ZW5kb3Ig
c3BlY2lmaWNzIGJlZm9yZSBwbWMNCj4gICB1ZnM6IHVmcy1leHlub3M6IGFwcGx5IHZlbmRvciBz
cGVjaWZpY3MgZm9yIHRocmVlIHRpbWVvdXRzDQo+IA0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnMt
ZXh5bm9zLmMgfCAgOCArKysrKysrLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyAgICAg
fCA0MCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hjZC5oICAgICB8ICA2ICsrKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAz
NCBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gDQo+IC0tDQo+IDIuNy40DQoNCg==
