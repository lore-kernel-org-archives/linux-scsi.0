Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09187C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 10:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B92610A1
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 10:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbhJMKNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:13:09 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58721 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhJMKNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 06:13:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634119864; x=1665655864;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dm+ucHY97TzrArDFQoJi8t+Aypgzr5PjE7p4ZlbmwlA=;
  b=BMa0NEinHW+GsBSmiIWpZgXGoY6RiefPYMAkPH17CMZnfKV1OSzZ+Fki
   qwzDis1AO2zod9WI7pC37NfECJPlOS6ExwVmXnmvtXl55mPEEhTMN4L1G
   q+5dVEwe0gNsOayqagVQnqOPW5nvhy4kjzMnQpPTrHhoYfOIxCJNtp0AK
   T8npFvTKcHWMho7MKuVa1iLhyTY3J93ewy6P17BE0mOsr7fNx4KFs+B2m
   gpJuNvao3PrhvCdssupnCUbktqV/EHDsSEV6EBsuPu89MHdB82Hh0sj3T
   VFwpzabs5BKAcfn+uSh5MnfAVi31R4DJ9CDP8cOTPFTU8tLaCIGLzJwS1
   A==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="182720651"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 18:11:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff9htwrWD8BGVSTpAgPI+FVX2GUmafEbF5E55qEV8EkDTSQzMvEUKyGAW2iIZgqO1fhXBLqK2u7IZRQg/XEnCCfsnUED7eDL3JKQ8JUK9sU/BhphrNd+bep53c32GHwKhBZWXseua+jhdS41DdiBCRtZ3SJ1BJHQ25u6jL8JE6t9nDjTeGNSraNEIkXzEKHqSwetDiShqiykbnrfNPbD2bheEH4LG9Cey8yKFLJEheLCM/3vAgnw8+3C/y/GOpb8c1e7pJzm4u5e5W+LkivF6cWpeUuuGNP0aVJJIva9UUuMbtl9n8e9vhP6ANLkgA0FZcvSQ6uV1VFOjbwvGiGDIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dm+ucHY97TzrArDFQoJi8t+Aypgzr5PjE7p4ZlbmwlA=;
 b=byJPhcg+tftG/CDPj/K8r2/tx1T2uebFWgoJYrJRotVzhgmenGuytABXea6j+6Tf3MJS42tpEZBT4fOA5k/tLs2gzKyVB3RmIUwTwlb4jx+NpvMeVVB/luZxW1ZAPum03g3k81ejzwfcT3TgLlA12WOaWj1Rezs0EmSBcAo0X63uxlsi8dEPvc/Jb9wSn7F8x1fv0QAeBVJ8qxOB1qsflF8SgeWdxpY22KxHiLWaq0yhKVLmRN9m2AAYXhCK+0GvumZqI08AQ5EDVFfYKa924di2NTnoLDUFCedxyOk5d5n5EAoY+6AWyABRMo3NOLA1zp+xKra9qCkPugFdsdATxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dm+ucHY97TzrArDFQoJi8t+Aypgzr5PjE7p4ZlbmwlA=;
 b=Sfh+7VwA5RMnY0UbYjmOPB2nmIxb++fPrdeNVWOI7Kl6lvGyfjxX3szBq+HTrkGW76RQeJkIqnOnSvdCPp7pY1P8NDlAoutvGLA5YJfMhepw8NY4eClSk+flwbtCnAZvWTo1XE6zjYM3IZQICW7OOiPRfLCegXdzoHiap5V4GdM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4026.namprd04.prod.outlook.com (2603:10b6:5:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4608.15; Wed, 13 Oct 2021 10:11:02 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%4]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 10:11:02 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
Thread-Topic: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
Thread-Index: AQHXv7PZu+d5LPyFuUqmtLbXKt1PFqvQk+KAgAAhxPA=
Date:   Wed, 13 Oct 2021 10:11:02 +0000
Message-ID: <DM6PR04MB6575A82BE27A9147BA98380AFCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-6-bvanassche@acm.org>
 <cd4b5103-e0fd-feed-2663-b505bcf019d8@intel.com>
In-Reply-To: <cd4b5103-e0fd-feed-2663-b505bcf019d8@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e842795-ceaf-452a-ece3-08d98e31c314
x-ms-traffictypediagnostic: DM6PR04MB4026:
x-microsoft-antispam-prvs: <DM6PR04MB40264909F09BE8232A28BD74FCB79@DM6PR04MB4026.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: adbQw+69bCa4uHKdwIMByo9fRMqedeBx16gShOrI0QGNPfNTO3rZ7b6XFoSGueTsWxjj3/uKHR+7a6KtP+7SRtMXQcFaTko4bnHaa15b8t6eriyD11X0Ichq2FDCU/WhkOSNZ1BeMeSKJQEsQwG2HZYZYvnYpPZXceg8mBmVlToZeB2/37rs8DwGWDu8UTSpph/MsgNlgzVKiC8Qby4WmUSCNTBS0c0uKiLd9TPupQ5LagKOUCnQKgpPwcjxecB9LJIlx7ZITdq24MQB3iCiNqkIUjJ8PZm+ed4hshPFXVG7+MR0hP/YziDYE3d1wyYgdCsfLcwfoekVDDGDZh8We1xKl5rt24x0Q9/E0nc0NfRQvUS+/njH+PaZ3yqhD+GjPydEYl7vXbVQg2O5uYfsIijt1w7ZL/spIjF+nJDZThSugoLgNwEQZHpoFZuaaEPmi4WuQn3OeulNm2qwaLgO02PfynMaKC2k7uJGlimpAVMk/c00orJLN5jtlhL/nT1HYdkB6kokCPKsuV6xyfgAaJNojGNKoTlMfHCXYhb5T8Hx5aRm8zsxta6iRLEcZQK/0WTNSuKe7H+Rj14Id88Ii1eZO8yELvTjdDD2JpoP4MD8Kvyd/DpgiU6rFvO9lPq0wkSfpY+pLniwq08PsqtBUpBl3J6ZuAH2OlH+y0uS8kuneYzDq+9PEAC4jOTx1VJbdIV9Fp4ahDqkyFjeAcpX0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(33656002)(110136005)(38100700002)(86362001)(316002)(7416002)(186003)(8676002)(52536014)(83380400001)(38070700005)(508600001)(64756008)(76116006)(66446008)(2906002)(5660300002)(66946007)(6506007)(122000001)(4326008)(71200400001)(82960400001)(7696005)(8936002)(66476007)(66556008)(9686003)(26005)(55016002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDhuOWR6ZVVMcks1MG1EY3M0ZTJXT2FYSitPSzh5RWIyRFhEc2JXb2xRR3Q2?=
 =?utf-8?B?UGNnd3VIRzJjbVdoSlF1L2xaV2RZWHVjMm5QeVNSMWkyWUVXRnRaOCtXWU1C?=
 =?utf-8?B?UjNaeG1lempORTI0akJJTXJHQkcyZ0trNTdKSjh5RzhXMTJWSlBEWnZiNm5K?=
 =?utf-8?B?OGE5OVF1cDN6K2tVbllham5seWYzTXRtc24vclFYdzFrYS9CZnZjODhsL05V?=
 =?utf-8?B?TGNQdWo1cFlnZUZSUG02UEhzZk11N0g5UVROQVV4cTk5RGJDVkExTW9aMGRi?=
 =?utf-8?B?ay9YdGlpWERsTlMyTml1UWJVd2xJTnFOYUZvR3JJM21yV05yYnBOTE0wMjZx?=
 =?utf-8?B?QWd0OUdjOGhOZXNWYjdQNXZGZkVOdE5OckJvZFVXWlNIcHpqeWhoT3RYQkRK?=
 =?utf-8?B?aHdnVWtnRUhyRXFRTVlzNUt5ZkJTZkxlaEhFTVFnRG0yODNPT1ZxTUVwcFJu?=
 =?utf-8?B?cTdDNHFZWGRKQTlXTnNkMDlrNEtDeW5pZkUra3hrLzd0M0tISWhiajdZdHdY?=
 =?utf-8?B?TCtPUjhPNmRObkFnb3Nna0tnY3BOandWcUZQT2xadTVCVWFjRzQrVG5HOTVk?=
 =?utf-8?B?SGFkT2lGdWgvakovd1JEbVdWWEJSRUFuMGhrN2RUb1RoZ0JXbk93VFFnaVRY?=
 =?utf-8?B?cVRuTUQwWWtDM1VCQ3A0d3hIdnRWSnE0bUN2c3FxSFRzSDFPTFNBWWQ1cEd2?=
 =?utf-8?B?WlI1YzEwZ3N5VzhUc2RKL2M2SjV2OVBxMUczMHRzRGpkREdBd2dHT0dUemo1?=
 =?utf-8?B?UUdUL2llNlV4eWVFQkJDV0hhVTNmRjQ3UjJteC9VM0FQY0pwenVjVmJIVVhC?=
 =?utf-8?B?cVYrTmFkRUx1NE15aFFUTUhVRGxXalBpTUQxSkJnZmNLVnZUV0pFeldXV0E1?=
 =?utf-8?B?K1UrM3hmSXhkWXJYdlV3Wk5vc0I0ZU81U0tHeCtpbGdrdm96c0hTVVZ3bWkx?=
 =?utf-8?B?OC9ud2xjbDFyclFBKzJMSHlLajRwdlAyOURxbmplVGtHSWN2VUZEckxVTnNF?=
 =?utf-8?B?Q3I1eWhEdisxNFJQS3NURGZPK1I4V2hsWGxpK29rWlFXaWl5UFF2Y2RpNWhw?=
 =?utf-8?B?U3FFM3puM3dOSWJROEVIUDYzRVU4c3BGNCthUjhoU0F6dVc3US9yRkJzT1ZH?=
 =?utf-8?B?QmV3cXVMNmxrSTdhKzIxaUN6R0VXMzJWZVBSVW1vZTdkQ2h0RTJ6dVJnUngy?=
 =?utf-8?B?QkVQZ1EzdFV3RG9zTDNQMmFNQzB0bEszZCttTGs1WEswTUdIOFNGUzhhenRo?=
 =?utf-8?B?c0huOTh6Wnh0QytpQUtTZkVZemt6UFlwcFFZb2pEZXhiVkRKejJaNnI2cjk1?=
 =?utf-8?B?cjJWdkJHM1k0MEpwQ0hPa09Za1liZVBoQndocDBURDhPWGw1NGxvMk9BMnhT?=
 =?utf-8?B?b1FtdHhaWitoaDZIMC9UMnJkQWF0YkFmZWE2bXQweG1TcWRkanJDWnFFNVRX?=
 =?utf-8?B?NTBkWWw5REZJdkJqcmVxS0tjYSs1dVhjVmJDaVR2ZHBIUEM1ejhmbHJKNW95?=
 =?utf-8?B?dHRPWmlSZGc0azIvVldrbkJTQitMWXUzT3JjdlNjNTEvTGdoY29jS1o2blUr?=
 =?utf-8?B?TVg2dnUrdjJvOFdsOXpmalN6SnJjelFpSStyQy9WWHdIQ2dPaUNoZWJwWWlU?=
 =?utf-8?B?UkpaUGY5VjZpMVB6WnJORkEraWNySTZleVVhaVZlR2xaUTR2YVUrQUJGaHJD?=
 =?utf-8?B?ZkdKU09hKzRaa3hnNk9IWWNlaytmbzVxazFnZk90YUw1UzJrUEJEWVFxYnRN?=
 =?utf-8?Q?0gWKV0V26qxm6WfgfFPRFSXZpmp0LpUYA9rTd/P?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e842795-ceaf-452a-ece3-08d98e31c314
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 10:11:02.5393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQBMwvtuqGyzpbgHi1wfwdHFUqID9w6nbij1dyRmyLtsYCd9pQo3NFvT52vr4/+mjOxGl6GTS4xW7rMW0VOtLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gMTMvMTAvMjAyMSAwMDo1NCwgQmFydCBWYW4gQXNzY2hlIHdyb3RlOg0KPiA+IE1h
a2UgaXQgcG9zc2libGUgdG8gdGVzdCB0aGUgaW1wYWN0IG9mIHRoZSBVRlMgZXJyb3IgaGFuZGxl
ciBvbg0KPiA+IHNvZnR3YXJlIHRoYXQgc3VibWl0cyBTQ1NJIGNvbW1hbmRzIHRvIHRoZSBVRlMg
ZHJpdmVyLg0KPiANCj4gQXJlIHlvdSBzdXJlIHRoaXMgaXNuJ3QgYmV0dGVyIHN1aXRlZCB0byBk
ZWJ1Z2ZzPw0KV2FzIGp1c3QgdGhpbmtpbmcgdGhlIHZlcnkgc2FtZSB0aGluZy4NCg0KVGhhbmtz
LA0KQXZyaQ0KDQo+IA0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmFydCBWYW4gQXNzY2hlIDxi
dmFuYXNzY2hlQGFjbS5vcmc+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vQUJJL3Rlc3Rp
bmcvc3lzZnMtZHJpdmVyLXVmcyB8IDEwICsrKysrKw0KPiA+ICBkcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jICAgICAgICAgICAgICAgICAgfCAzNyArKysrKysrKysrKysrKysrKysrKysrDQo+ID4g
IDIgZmlsZXMgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBh
L0RvY3VtZW50YXRpb24vQUJJL3Rlc3Rpbmcvc3lzZnMtZHJpdmVyLXVmcw0KPiA+IGIvRG9jdW1l
bnRhdGlvbi9BQkkvdGVzdGluZy9zeXNmcy1kcml2ZXItdWZzDQo+ID4gaW5kZXggZWMzYTcxNDlj
ZWQ1Li4yYTQ2ZjkxZDNmMWIgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9BQkkvdGVz
dGluZy9zeXNmcy1kcml2ZXItdWZzDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9BQkkvdGVzdGlu
Zy9zeXNmcy1kcml2ZXItdWZzDQo+ID4gQEAgLTE1MzQsMyArMTUzNCwxMyBAQCBDb250YWN0OiAg
ICAgICBBdnJpIEFsdG1hbg0KPiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4NCj4gPiAgRGVzY3JpcHRp
b246IEluIGhvc3QgY29udHJvbCBtb2RlIHRoZSBob3N0IGlzIHRoZSBvcmlnaW5hdG9yIG9mIG1h
cA0KPiByZXF1ZXN0cy4NCj4gPiAgICAgICAgICAgICAgIFRvIGF2b2lkIGZsb29kaW5nIHRoZSBk
ZXZpY2Ugd2l0aCBtYXAgcmVxdWVzdHMsIHVzZSBhIHNpbXBsZQ0KPiB0aHJvdHRsaW5nDQo+ID4g
ICAgICAgICAgICAgICBtZWNoYW5pc20gdGhhdCBsaW1pdHMgdGhlIG51bWJlciBvZiBpbmZsaWdo
dCBtYXAgcmVxdWVzdHMuDQo+ID4gKw0KPiA+ICtXaGF0OiAgICAgICAgICAgICAgICAvc3lzL2Ns
YXNzL3Njc2lfaG9zdC8qL3RyaWdnZXJfZWgNCj4gPiArRGF0ZTogICAgICAgICAgICAgICAgT2N0
b2JlciAyMDIxDQo+ID4gK0NvbnRhY3Q6ICAgICBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVA
YWNtLm9yZz4NCj4gPiArRGVzY3JpcHRpb246IFdyaXRpbmcgaW50byB0aGlzIHN5c2ZzIGF0dHJp
YnV0ZSB0cmlnZ2VycyB0aGUgVUZTIGVycm9yDQo+ID4gKyAgICAgICAgICAgICBoYW5kbGVyLiBU
aGlzIGlzIHVzZWZ1bCBmb3IgdGVzdGluZyBob3cgdGhlIFVGUyBlcnJvciBoYW5kbGVyDQo+ID4g
KyAgICAgICAgICAgICBhZmZlY3RzIFNDU0kgY29tbWFuZCBwcm9jZXNzaW5nLiBUaGUgc3VwcG9y
dGVkIHZhbHVlcyBhcmUgYXMNCj4gPiArICAgICAgICAgICAgIGZvbGxvd3M6ICIxIiB0cmlnZ2Vy
cyB0aGUgZXJyb3IgaGFuZGxlciB3aXRob3V0IHJlc2V0dGluZyB0aGUNCj4gPiArICAgICAgICAg
ICAgIGhvc3QgY29udHJvbGxlciBhbmQgIjIiIHN0YXJ0cyB0aGUgZXJyb3IgaGFuZGxlciBhbmQg
bWFrZXMgaXQNCj4gPiArICAgICAgICAgICAgIHJlc2V0IHRoZSBob3N0IGludGVyZmFjZS4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMvc2NzaS91
ZnMvdWZzaGNkLmMNCj4gPiBpbmRleCBlY2ZlMWYxMjRmOGEuLjMwZmY5Mzk3OTg0MCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jDQo+ID4gKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYw0KPiA+IEBAIC04MTQ0LDYgKzgxNDQsNDIgQEAgc3RhdGljIHZvaWQg
dWZzaGNkX2FzeW5jX3NjYW4odm9pZCAqZGF0YSwNCj4gYXN5bmNfY29va2llX3QgY29va2llKQ0K
PiA+ICAgICAgIH0NCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBzc2l6ZV90IHRyaWdnZXJfZWhf
c3RvcmUoc3RydWN0IGRldmljZSAqZGV2LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHN0cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGNvdW50KSB7DQo+ID4gKyAgICAg
c3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7DQo+ID4gKyAgICAg
c3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0X3ByaXYoaG9zdCk7DQo+ID4gKw0KPiA+ICsgICAg
IC8qDQo+ID4gKyAgICAgICogVXNpbmcgbG9ja2luZyB3b3VsZCBiZSBhIGJldHRlciBzb2x1dGlv
bi4gSG93ZXZlciwgdGhpcyBpcyBhIGRlYnVnDQo+ID4gKyAgICAgICogYXR0cmlidXRlIHNvIHVm
c2hjZF9laF9pbl9wcm9ncmVzcygpIHNob3VsZCBiZSBnb29kIGVub3VnaC4NCj4gPiArICAgICAg
Ki8NCj4gPiArICAgICBpZiAodWZzaGNkX2VoX2luX3Byb2dyZXNzKGhiYSkpDQo+ID4gKyAgICAg
ICAgICAgICByZXR1cm4gLUVCVVNZOw0KPiANCj4gRG9lcyBpdCBtYXR0ZXIgaWYgdWZzaGNkX2Vo
X2luX3Byb2dyZXNzKCk/DQo+IA0KPiA+ICsNCj4gPiArICAgICBpZiAoc3lzZnNfc3RyZXEoYnVm
LCAiMSIpKSB7DQo+ID4gKyAgICAgICAgICAgICBoYmEtPnVmc2hjZF9zdGF0ZSA9IFVGU0hDRF9T
VEFURV9FSF9TQ0hFRFVMRURfTk9OX0ZBVEFMOw0KPiANCj4gU2hvdWxkbid0IG92ZXJ3cml0ZSBV
RlNIQ0RfU1RBVEVfRVJST1INCj4gDQo+ID4gKyAgICAgICAgICAgICBoYmEtPnNhdmVkX2VyciB8
PSBVSUNfRVJST1I7DQo+IA0KPiB1ZnNoY2RfZXJyX2hhbmRsZXIoKSBzdGlsbCBiZWhhdmVzIGRp
ZmZlcmVudGx5IGRlcGVuZGluZyBvbg0KPiBoYmEtPnNhdmVkX3VpY19lcnINCj4gDQo+ID4gKyAg
ICAgfSBlbHNlIGlmIChzeXNmc19zdHJlcShidWYsICIyIikpIHsNCj4gPiArICAgICAgICAgICAg
IGhiYS0+dWZzaGNkX3N0YXRlID0gVUZTSENEX1NUQVRFX0VIX1NDSEVEVUxFRF9GQVRBTDsNCj4g
PiArICAgICAgICAgICAgIGhiYS0+c2F2ZWRfZXJyIHw9IFVJQ19FUlJPUjsNCj4gDQo+IEluIGFk
ZGl0aW9uLCBhIGZhdGFsIGVycm9yIG11c3QgYmUgc2V0IHRvIGdldCBmYXRhbCBlcnJvciBiZWhh
dmlvdXIgZnJvbQ0KPiB1ZnNoY2RfZXJyX2hhbmRsZXIuDQo+IA0KPiA+ICsgICAgIH0gZWxzZSB7
DQo+ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsNCj4gPiArICAgICB9DQo+ID4gKw0K
PiA+ICsgICAgIHNjc2lfc2NoZWR1bGVfZWgoaGJhLT5ob3N0KTsNCj4gDQo+IFByb2JhYmx5IHNo
b3VsZCBiZToNCj4gDQo+ICAgICAgICAgcXVldWVfd29yayhoYmEtPmVoX3dxLCAmaGJhLT5laF93
b3JrKTsNCj4gDQo+IEhvd2V2ZXIsIGl0IG1pZ2h0IGJlIHNpbXBsZXIgdG8gcmVwbGFjZSBldmVy
eXRoaW5nIHdpdGg6DQo+IA0KPiAgICAgICAgIHNwaW5fbG9jayhoYmEtPmhvc3QtPmhvc3RfbG9j
ayk7DQo+ICAgICAgICAgaGJhLT5zYXZlZF9lcnIgfD0gPHNvbWV0aGluZz47DQo+ICAgICAgICAg
aGJhLT5zYXZlZF91aWNfZXJyIHw9IDxzb21ldGhpbmcgZWxzZT47DQo+ICAgICAgICAgdWZzaGNk
X3NjaGVkdWxlX2VoX3dvcmsoaGJhKTsNCj4gICAgICAgICBzcGluX3VubG9jayhoYmEtPmhvc3Qt
Pmhvc3RfbG9jayk7DQo+IA0KPiBQZXJoYXBzIGxldHRpbmcgdGhlIHVzZXIgc3BlY2lmeSB2YWx1
ZXMgdG8gZGV0ZXJtaW5lIDxzb21ldGhpbmc+IGFuZA0KPiA8c29tZXRoaW5nIGVsc2U+DQo+IA0K
PiA+ICsNCj4gPiArICAgICByZXR1cm4gY291bnQ7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRp
YyBERVZJQ0VfQVRUUl9XTyh0cmlnZ2VyX2VoKTsNCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3Qg
ZGV2aWNlX2F0dHJpYnV0ZSAqdWZzaGNkX3Nob3N0X2F0dHJzW10gPSB7DQo+ID4gKyAgICAgJmRl
dl9hdHRyX3RyaWdnZXJfZWgsDQo+ID4gKyAgICAgTlVMTA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAg
c3RhdGljIGNvbnN0IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgKnVmc2hjZF9kcml2ZXJfZ3JvdXBz
W10gPSB7DQo+ID4gICAgICAgJnVmc19zeXNmc191bml0X2Rlc2NyaXB0b3JfZ3JvdXAsDQo+ID4g
ICAgICAgJnVmc19zeXNmc19sdW5fYXR0cmlidXRlc19ncm91cCwgQEAgLTgxODMsNiArODIxOSw3
IEBAIHN0YXRpYw0KPiA+IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgdWZzaGNkX2RyaXZlcl90
ZW1wbGF0ZSA9IHsNCj4gPiAgICAgICAubWF4X3NlZ21lbnRfc2l6ZSAgICAgICA9IFBSRFRfREFU
QV9CWVRFX0NPVU5UX01BWCwNCj4gPiAgICAgICAubWF4X2hvc3RfYmxvY2tlZCAgICAgICA9IDEs
DQo+ID4gICAgICAgLnRyYWNrX3F1ZXVlX2RlcHRoICAgICAgPSAxLA0KPiA+ICsgICAgIC5zaG9z
dF9hdHRycyAgICAgICAgICAgID0gdWZzaGNkX3Nob3N0X2F0dHJzLA0KPiA+ICAgICAgIC5zZGV2
X2dyb3VwcyAgICAgICAgICAgID0gdWZzaGNkX2RyaXZlcl9ncm91cHMsDQo+ID4gICAgICAgLmRt
YV9ib3VuZGFyeSAgICAgICAgICAgPSBQQUdFX1NJWkUgLSAxLA0KPiA+ICAgICAgIC5ycG1fYXV0
b3N1c3BlbmRfZGVsYXkgID0gUlBNX0FVVE9TVVNQRU5EX0RFTEFZX01TLA0KPiA+DQoNCg==
