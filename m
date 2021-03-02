Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CAEC43331
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F421864F21
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378991AbhCBSya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:54:30 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11610 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446132AbhCBNRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691022; x=1646227022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vA4AayVRFIfxMZaMUpJhuegGMU+hZL1fvxmqIxsy/Tc=;
  b=pRrXiXrirIPVZ25UT8UZgkAjKKheezLathsihp+c68rqWi1iNmFKwRf6
   iZK5Uf3Un8usoGP4BfIqNC+wzYtUwi5KLmczZac2CowuF/G9/Ojwgrb/c
   F62vuKcwycdVVjxe+VVcmcCsTgpEkii14XoCki+vv6nPPnMql2LgceLgo
   WXEisSgXBH7+syUMTYbDDieOZaEQ9jYt3+Bm8fSy0bwrQGhQzutDFGz+w
   qfQsxGoU55gKG69NHvxmvcOLovu7O4itGCeBvb33fVVlS1XtW9zQ1bKyP
   l+XlO5dxU+Tx3J8cVJzmxsC1E4naaOmlDWg8AnYEJ09qauOi8gGOqB5Fu
   Q==;
IronPort-SDR: ZlhgvdxUE3HcpxLZD72yqNkjTdVLw6sYKLtTAxynTpajANbLqstT+6jHaDy2TsmZ45toQvIi+t
 CM5x1A7Td7caI+2/LNVllWSVx3mWyPSeWSzJVcBYFcmHfrwZLxvQ3SrT3pbubpOboLlfU3nNO6
 /0ZUDmh5murPdOr03pviDTssZDWiUV8LA1JQ6UAXeBlqsfmLev2ccf6mu5+ob4Cm7ZOqujdtH1
 T1ulj3/5u7XuspqgFNZGYV5/BhUJwVsn5jJM/SBNnz3OhSy3POarD2sy++wWOmIPAl7NeM04O6
 OS0=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="271766516"
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:15:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbdLk7gq3PhMb4M8ubxE/wv/NP8f8Kyy2fNBY4NnXKnaEW2zVcIh3k4Bx8D5sYHsyHr2T7yXM+/40GLUaMg2PKpl25hvZ5FQkPtUw24cPqjSQ1t3qBc5JBlnOnmvxtoUqI8ct+z6RkyUPbIiIxklik3V5xPBST+LLyvubjx4fsphNpzQV+ZA4ZSDG++MvznKeX0dVyhARv3HBXv+YDkaZahs+ZOZ3RHLfspC/04srL6BcP1NINee1+REWOjVAzKCNqo8LnHAPo0vJ4+EM5Ycqwmh6HfBE5MIXnD0Hl021OR/otK4spXyxFa2qaA3+ZEnzKn6+XYJinX+M+O8qNmvbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA4AayVRFIfxMZaMUpJhuegGMU+hZL1fvxmqIxsy/Tc=;
 b=MA+gGMX3JylH9bOVbpDp3ZmZUiQrWsEnBOD84nNBszF7cbVNilD0+kKgJjrP7UqBJ0X9pvrgY6J8yHjoI1kLRr6yx7NDb/6IgfKiXQ5MbWqFTdjIEQZliaJvlIUGlktXfAI+TJopQZk68r3MKYXHoOtIIUHJJE1UL8KYOrvJCZ3AD/gkbebix4vCT2C4IX88DiFsh711ao24B+wlFkP6eSj4Q0snwGzESwrYRuENU9eHDzxwSMa7XVkmALFAj0ggQLGsWBK3V963MWzse0Hb2ds4es4vhygIB8xy+30PI9lLY/mHEI0memwDZ0/hV2hp6BFCOzK/NaDLh0RfCuTLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vA4AayVRFIfxMZaMUpJhuegGMU+hZL1fvxmqIxsy/Tc=;
 b=E3YazclAscVXlsxinWqjO/W57Vn7ooBNZ5ryHbMArObaCGFNlI3tXA+8dGve5GxfGRY3O+adM6es01q5R8Tpy4H5NQvh78Dfej+rSuVE+qLSNTW6S8oHCSbBn14WGVNjsEKgOCPvVX9VcYLSmjvAtmfjZtejcemLuZ66tXw6CV4=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5820.namprd04.prod.outlook.com (2603:10b6:5:167::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3890.23; Tue, 2 Mar 2021 13:15:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.030; Tue, 2 Mar 2021
 13:15:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v25 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXDBH4G1OrcdmEk0eAR/HZ2R8FHapwrOmAgAAGwqA=
Date:   Tue, 2 Mar 2021 13:15:15 +0000
Message-ID: <DM6PR04MB6575372560ACA643845C891CFC999@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p8>
         <CGME20210226073233epcms2p80fca2dffabea03143a9414838f757633@epcms2p5>
         <20210226073525epcms2p5e7ddd6e92b2f76b2b3dcded49f8ff256@epcms2p5>
 <fb70bf48fab65474bf2f15a436852ccf9a3db026.camel@gmail.com>
In-Reply-To: <fb70bf48fab65474bf2f15a436852ccf9a3db026.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5c4812a-7fb5-406b-05ed-08d8dd7d381b
x-ms-traffictypediagnostic: DM6PR04MB5820:
x-microsoft-antispam-prvs: <DM6PR04MB5820BB82B2648F421BEE0F50FC999@DM6PR04MB5820.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+fVBspPvOklfSEMtqQQBGEg/0/QFNdnRE7XsWH4bYOVAnjUKlW5aK287KeEZKyKyM3zV4PBr7zfP+DhqvzOn3YvxWXnBNK+842wIhULbLAbGjST5G8ZUytGmLmMOlXPHS7FTNR/ZVUTm0TTmjo4iVyWZ4UqG+KosytwAJBcBRDO1L+mPKeFwWYkif9eRiO7wRzmAG+wR0720vU8eGgdgF57JsSNTWb1W+8S1XE92xxYrL1KgHVq+E3Dq8sgqFGCQ1QIqGXjjeuH/jqSPU5Uo3j9FdxEMyq2HBH8XS2uSDY7RwAbzBiu0K5FaLRFTeFKKzyRUz/KDYdGI5aBYqouSD9R9PLvmgithq43oruxiIerM3r0r0r9W4ph0vb6hG7rvDjopkexh5T47zRPLnJdHvlN5UkZdmvIle0WFr2OBP9czZTuEGVZto/NsDqVjCtFWPfowo/Y2UWxnDkaLPUdv7S820AbFNchAI4HMkeFNjthzXxeAnq+feWX021MpqrvidjbjrhyeR8uyaH1JI8V+bDI8z7OsENTmHWRzGUNsBbksdUbihvU4ORU1Elya1+9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(71200400001)(7696005)(186003)(921005)(2906002)(6506007)(9686003)(26005)(8936002)(86362001)(52536014)(5660300002)(66446008)(110136005)(7416002)(76116006)(33656002)(54906003)(64756008)(316002)(66946007)(55016002)(4744005)(478600001)(4326008)(66476007)(8676002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QXJGLzYxdFFSS0J4RUpnWSs0U0RrNGF0Vm9JY2ZCWWxOL3ZoeHlXOTJCUWlE?=
 =?utf-8?B?RGlINHVPbDZQZHB1YXdNeXNWMGxsdEMxS2ZKV2JiMDVyMjVRcHdPU0ZiZUFZ?=
 =?utf-8?B?T1hudTdoY1VMOXR3Y2V4ODRHTmxFK3lNbksrSmQwQnJ1T3dqbUpvRzREZEVr?=
 =?utf-8?B?QWczbjNMWEM2ck1tSGc0VWNoNWVsaHV0U1pmZ0wvRFBGcWJsZG1uSVpreUIx?=
 =?utf-8?B?cThVOTRENHNkNU14NnFuU2ZxRWJwNmxObExLaWk2aWpVSmw1MWNPS2Z2QmNK?=
 =?utf-8?B?ZmVYSUt0a3BraXVhc0c0d09IaTlRMWZ6Y2tSNkp2c0E4OUt2MkUxV3Ixd3o2?=
 =?utf-8?B?M1ozc2lRcUhzZkZnRzJJdy8wUGVHTEF5RmJFVUVCWnM5b2luOXY4Zm1UVDh6?=
 =?utf-8?B?MXVNWXBIOENjZnkzSlVwcTZrYWZJVnd6MndSNFpRVjl1OUx5MWYweVVwQlhh?=
 =?utf-8?B?aXhBSWdGMTRTWUtMZWFUSE5KV2pQTHhSWjNqejJmSGhFdm5NVnVCQ0NGN0Fq?=
 =?utf-8?B?S2c3QXlBZlFJUUNBa1JmVzJNY2NKMzAzM0h6UStWYzV6NUtFTmJoRWtzSkJG?=
 =?utf-8?B?MjJtNzYxcHM4VXh3WFVXSEw2WFAvd0E2T2hlcTVTM2dIMkxjSDNjK04rRFFL?=
 =?utf-8?B?SjNwa05YQWEydlhXKzNJODVXL0ZNc09EZzBJWGIyVFlSZGZNR2JkQVZCSFgv?=
 =?utf-8?B?Q2tHcTFWWEg3YzcyZmJDcTRTWUNiME5qd3AzMnljV21yU3ZGcklneVZMRHYx?=
 =?utf-8?B?M0hNeU03Um5iUlFSMGh4d3M5VVRrTTIvNnZ5VFFVQW84N0hoWkxqT3RETWxh?=
 =?utf-8?B?SHoySjlmVTJMcnVRSytPbWtCV2F6VXFkN0NpWUtpV0ZaUkpqcHpzaTU4RXky?=
 =?utf-8?B?c29BNFlvZGllRkMwaS9hYmRXZlhaWkRhV3RSWFovQThPZnVIb1JtbS9PeW54?=
 =?utf-8?B?dmZacFYxNEhKdjNidERhMDFkZVRmZmpic2VndSs0M2ZWd0VuakFIQk5ZZnFr?=
 =?utf-8?B?Zm5SVkhiUk9nSGc0dC84L3dQYnhvZ29kTGxaZ0V4YWFCUkZHVVRGanBYMHlo?=
 =?utf-8?B?UDhHSWZhNlc1dFNLOUp3c1pLWGkyemhEUmJoRUNhazBGdWpmTlJBWjhreU9y?=
 =?utf-8?B?T1pjcXkvUUc5bVpIZUp3Z3pyVmk2dGdXckFpTE9FM09LSG1hWmlOQ2R3QXB5?=
 =?utf-8?B?SDVmRzJHd0lzZmtsSEJUVVBiVVYzNkVuM0FBU0xvdmkxQ0QzMVNCNTFBS21y?=
 =?utf-8?B?b0VtZUZqRm1URktvWHVUSDFlNWE5eFhnUEFoNTBTZmRjYU9LVkRlK25uRVNY?=
 =?utf-8?B?dHlvZjh0YjlDekkxTzBRRWtoRWJHM0xCTTlpT3UwNE9BRmdwVU9GdTZ1N2cv?=
 =?utf-8?B?S1JTZzBQdFduZ3A5ZXQyQUpQRnJ5aHZ0OHRQcGhxSC95bTdtUThSYXZMdGdk?=
 =?utf-8?B?cHpjQytDaEFQOFF6NUYyT1NZRnVETmlIZnFFWEgwdTRYRjJhTXRNemlCaVJj?=
 =?utf-8?B?cmlJQ2Uxc3FvMGVHbTlPelpxVTlCTW5pMXV5SHBIVkVvV2kxUkh2Mm8reXl1?=
 =?utf-8?B?bmVGY0hTY21EeG1jN3BsU28wdmpOdUV5eitNTU55TmNRZ282TUl6YVRyS2x1?=
 =?utf-8?B?cG5qUko2dlZKTm1UenZBVHVOdkJCT01wOS9zSHlaUXI1SmRvLzY1cVdGaytD?=
 =?utf-8?B?ZWtNQ1hVZm1PS21iZmw3SVMyU21HNTRiaE9ReCtnRzZ4TTN0YkRERnJLS0Z1?=
 =?utf-8?Q?XGDRJLw9wwBdgMES9k7d+zRpo66Lyo6Ai4eVVum?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5c4812a-7fb5-406b-05ed-08d8dd7d381b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 13:15:15.4293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YtMti3ozOlqznBsZNFpyKtWwuKL4zMP3XqfCdfJv7XuY5dllAL75U4orN9Xc9TxtDfI1ZTr4bBIcaDjj2fqaug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5820
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IE9uIEZyaSwgMjAyMS0wMi0yNiBhdCAxNjozNSArMDkwMCwgRGFlanVuIFBhcmsg
d3JvdGU6DQo+ID4gK3N0YXRpYyB2b2lkIHVmc2hwYl9zZXRfdW5tYXBfY21kKHVuc2lnbmVkIGNo
YXIgKmNkYiwgc3RydWN0DQo+ID4gdWZzaHBiX3JlZ2lvbiAqcmduKQ0KPiA+ICt7DQo+ID4gKyAg
ICAgICBjZGJbMF0gPSBVRlNIUEJfV1JJVEVfQlVGRkVSOw0KPiA+ICsgICAgICAgY2RiWzFdID0g
cmduID8gVUZTSFBCX1dSSVRFX0JVRkZFUl9JTkFDVF9TSU5HTEVfSUQgOg0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgVUZTSFBCX1dSSVRFX0JVRkZFUl9JTkFDVF9BTExfSUQ7DQo+IA0K
PiBIZXJlIGlzIHdyb25nLA0KPiBWYWxpZCBIUEIgUmVnaW9uIGlzICgwIH4gKENlaWxpbmcoIFJl
Z2lvbiBzaXplIGNhbGN1bGF0ZWQgYnkNCj4gYkhQQlJlZ2lvblNpemUgKS0gMSkgKS4gaG93IGRv
IHlvdSBrbm93IHRoZSByZWdpb249PTAgaXMgbm90DQo+IGEgc2luZ2xlIG5vcm1hbCByZWdpb24/
DQpQbGVhc2Ugbm90ZSB0aGF0IHJnbiAgaGVyZSBpcyBhIHVmc2hwYl9yZWdpb24gKnJnbg0KDQpU
aGFua3MsDQpBdnJpDQoNCj4gDQo+IEJlYW4NCj4gDQo+IA0KPiA+ICsgICAgICAgaWYgKHJnbikN
Cj4gPiArICAgICAgICAgICAgICAgcHV0X3VuYWxpZ25lZF9iZTE2KHJnbi0+cmduX2lkeCwgJmNk
YlsyXSk7DQo+ID4gKyAgICAgICBjZGJbOV0gPSAweDAwOw0KPiA+ICt9DQo+IA0KPiANCg0K
