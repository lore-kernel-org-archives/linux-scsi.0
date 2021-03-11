Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB96CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 13:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9059C64F9F
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 13:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbhCKNq0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 08:46:26 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:1059 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbhCKNp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 08:45:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615470357; x=1647006357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JdF0jH0CSf3/2ojjLGSUhIQ2RNBbDUPGbfc43HCxcb0=;
  b=gABa33k+a9nQfwXrER4567DAXWSyTcKKFFfLBW5DnY6oF+DYO3R58zJ4
   LHZgcGpRwQ8Yl347RqFmBFy3JooGi5lnWrR0/EsJrBD6uwywyqrbc25xH
   Cj9xwFMKll7dQqONYLM6g0O/wH1DzPbUQ42hD3UvUXketSCJDp8CcwYbx
   UT+FjvX7J2UWaVgnyTAhVZdIqPoY7I+nCX1blg9aNcHl6y4WbfJEqQwrY
   4xHxzvtxWhlIvQfJy2bI07obJc9dwWoFrRZ26PywE37ZPzTmA9RHhLuYU
   SVhek2nE1gV+nfvAC6I/EizWCpoZ83+vwaXffO/xDkX6nFL7q0+V2Q2in
   w==;
IronPort-SDR: uqYa+PN4I1OzKgQLFTyQpBKdifCuaOTNIPqhLFdRuIfoUB8164G/K8RrS+l/vy3iFdVNDWsWL5
 AoyQq3suWGJGdhWAipKCTXIwHYTGpzYMBiGE9Jxq02hA+ZQzC4BBsrXTE8c9XjLrbWn8TdkEdG
 HRUloaC3+mCEGoWNqQmeq2gKW4H6hHiRwmIxD3QfFZOIiCc+d0qF0++3pADKowcjeRp1+Eelbi
 /fitMHMEOwncMypw0cwva64eBn+e6BL8DUAKBLM38P8gqLeIBR6m9szcdSnrcqr5ikH2HdSQ2t
 QAc=
X-IronPort-AV: E=Sophos;i="5.81,240,1610380800"; 
   d="scan'208";a="272601913"
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hgst.iphmx.com with ESMTP; 11 Mar 2021 21:45:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd0+/YkuijJqXnaePk8P3YZXPxSHKoCnUp0MkmTJMfLN7Ep3qikkhi5pCMNBAFSfs5Hag9bdYIa1hz8hkvly+FBZCyloSqFL0iEbtFGiIy2V4wetLL6fwOVdbui75V5HmSLh6xshYUSrDq1wJm5NNpX7GAS1uwFe5eDuVap0riSJYWvScVWSK4osSAHJnEnXkv4hheT18YlIAo2Y7tKlsldbkBsIGyYrV2VV1M9jNX6VJiBP5QsBmOLIdEtarPpRacooZZAOC98nOUIsy+9f7uybyaKLwCYqo+mhcOQe19NxiEuZ0pA+Il9Qu/U3HOr73MTJkc1yeDmn97MZIGC7bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdF0jH0CSf3/2ojjLGSUhIQ2RNBbDUPGbfc43HCxcb0=;
 b=BbEKBYHGbwxcTDuZ6AkPK22bU00Bint6JWICtLfNcSOqCz16qPBsDZ7adkg/yJi3oYmOWqDY+NU7HHxDnC+sJ7SKeqWV48TwDFFr3XJAnLmX+0BEbrXt6xKB+k2wX7nPgvLvITktbJK4XUVVR0TTR8SxSazTLFavg14JzaSgYWRdgXmq1Y/xWrgKS6A1Qmd/QCaADVHqPdxr9MrQ2uvIaSleFcvhcj8KSwYtbaei5zAAI082ZusiMFeTHW8KueTxSlR7L+CU0m8KLGWOJ6FC8SrSbvgeHU9xo+StW/AfQrzkcHs6mDx9DJnbRHANzWWA5RdDrElE0viQP2OmI46nIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JdF0jH0CSf3/2ojjLGSUhIQ2RNBbDUPGbfc43HCxcb0=;
 b=CK4sYBNeL+xp84M/N/HUGV8fd3xLi3LNJ+LIePeEKdhlZfSJ10GpaYBi0Ve+jSIJ8zlxHw3sJ9Ft6Tm5uiBVFaATUoq1dXA2XkFIWmFUghWBTxW7h81WbT6tms1qsZurD2LD88yLMaaG+qoalxpB4gzb0ioBZH6CsLSyMzLiH8w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1098.namprd04.prod.outlook.com (2603:10b6:4:45::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.26; Thu, 11 Mar 2021 13:45:55 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3890.039; Thu, 11 Mar 2021
 13:45:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
CC:     "Matti.Moell@opensynergy.com" <Matti.Moell@opensynergy.com>,
        "arnd@linaro.org" <arnd@linaro.org>,
        "bing.zhu@intel.com" <bing.zhu@intel.com>,
        "hmo@opensynergy.com" <hmo@opensynergy.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "joakim.bech@linaro.org" <joakim.bech@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-nvme@vger.kernel.org" <linux-nvme@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "maxim.uvarov@linaro.org" <maxim.uvarov@linaro.org>,
        "ruchika.gupta@linaro.org" <ruchika.gupta@linaro.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "yang.huang@intel.com" <yang.huang@intel.com>
Subject: RE: [RFC PATCH  0/5] RPMB internal and user-space API + WIP
 virtio-rpmb frontend
Thread-Topic: [RFC PATCH  0/5] RPMB internal and user-space API + WIP
 virtio-rpmb frontend
Thread-Index: AQHXFOgXozqLqh2hkkmaNhl81BLME6p9Sa6AgAGCHyA=
Date:   Thu, 11 Mar 2021 13:45:55 +0000
Message-ID: <DM6PR04MB6575FFFC4897119A0F8234D1FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
 <20210309132725.638205-1-avri.altman@wdc.com> <87y2ev6pkw.fsf@linaro.org>
In-Reply-To: <87y2ev6pkw.fsf@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45f930f5-7fde-4bf8-0f1b-08d8e493feb7
x-ms-traffictypediagnostic: DM5PR04MB1098:
x-microsoft-antispam-prvs: <DM5PR04MB1098C95BBB6B7C0D37CC472CFC909@DM5PR04MB1098.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MLQpPaNXrMbdP/JvrwWnuw0Gef/V6TK4G9huSk0rMRd9yd6XgtnbygPmNrRjxtgarbislmGamE0c9YeoK/CUxIj2abCIJ4LzejrXPRESdr+ygfQxIa7Fp91gDjqzr+JHD8pTIMLQRpexPef5SDEX80n7m6fKGXrkHZuPhnTqq4bS1yfNYHqVcdb3SW7UCnKeEhLcR2WeUjNLC14gvEqawnBoXtlNc0bQ3fq/ro7+PMOz4OjCd0/YuM7VO+iHUrfGWD0vcJaTaHS2b2JjYpsnh6klFl5kGhkmQ+AxjMTR+38V4ylPN+Hbvum+zSCfD0xkIB8Y51ibyNo7qqcsbB+f86vAe6oxXb8LjnIOZRYmgna8xBRWL4QPYSeO8DRQgCANDGn/3gTp10plVnPNLM4TZOAffO8I5IaCRMhTpKEYSQB4nfpYc6QM4tanxj+0+aTGlYrp82z/NrHAjMGdEgQhiW45Iausyh0R9XGNtF7eAkNuGNsoPIc2/+x20UGdd57gE19KsRAWASyJ8/zVPIk5qQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(186003)(9686003)(2906002)(76116006)(55016002)(54906003)(83380400001)(316002)(33656002)(66446008)(66476007)(64756008)(66946007)(7416002)(66556008)(71200400001)(478600001)(26005)(6506007)(52536014)(5660300002)(6916009)(8676002)(7696005)(4326008)(8936002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZlhhVzlJZkxZZVlyeVVaYVk2MmdwSWdrbkRkUWZQZFJtNDIyQmpOMStEL1NE?=
 =?utf-8?B?N3RvNXZEWWdvenJlcjJjaExYa2QzdzRnV1o2OUdMbWVKVzBIMFFic0FMNWsy?=
 =?utf-8?B?VmNqY2ZWb2gxU3BVU1dUR0Rqenk0Q1dqaG9Fejlua0c2M2VEYkRKcGM5ZUFh?=
 =?utf-8?B?TytwU0FvOTk5VlExdXJHYkJvVVo3a3Rjd3NvOFkxWUZUR2x5VnB3dUJnZ3hw?=
 =?utf-8?B?UGhhd2R2SC9tS0VLMTVyLzdQcitZSE85cC9oT2Q0Qnc4R2x3UVE5d3czWmRC?=
 =?utf-8?B?NzFSa3dycG9iM0JsVUhidEZiZWt1R2U0TXZYUm1LUWNMY2EvMWtVbXhsVUkv?=
 =?utf-8?B?ZHN5UDNDVDFyWi9sWGpjUjltTmZadjVsTTMrYVJXL2V1M09nZEVTR0xwbUs1?=
 =?utf-8?B?WjkrRDlScWwvQWY4citsZkRhWnNpdGpNMHdld0FhOHJJYWtKcFdPK3I0UU1X?=
 =?utf-8?B?RmthaGFzY25idkFITk5XVE44dWpCU1ZCQzUzTGx6N3F2bktWd2p1eHNzYVdC?=
 =?utf-8?B?MC9GSS9pYlhZeng1ZlVNVDE4cC9HN1QrQ2pJVkZWbkRDN2x0SG42QlcyS2Ra?=
 =?utf-8?B?UjVEWkwydDJGcXdiT0dzU1Faei9PM2dRL2xUa2Z3VWcrNTZXc1NjQVhvbEpG?=
 =?utf-8?B?bUR5V1dhQm1WK2U5VGlaSS9oOExJZUEvVUJhcVJaRlBVbjlFTlRqYzdveEZM?=
 =?utf-8?B?eGpxWDhXZzAzVjhyMHdlNzE4K3loVUtsdmdzN2hzeTJ4YSs1aTJEMHlHM1Ru?=
 =?utf-8?B?MXZRaVlQSm5yb3dTUVh6eEVHMXRpWDMwZ1Q5YXpkOXlwMVlxL3lmdGhqSklu?=
 =?utf-8?B?VlZ6YnFSeXBGaTllVEdRT29FQkgvS0hmUUREUnllSVpXWDdreWJvRjlhSk5R?=
 =?utf-8?B?K0NXVFk4Z2RzVUJqUUk4TTlkSE9MckZHaUVtYVFJVWYySUFRazY0cTdpMmJR?=
 =?utf-8?B?L3Z6MEdRSkd1ZU13YnFCcStaZG1ob214NGJFaW5tRmpxeXB0Rm94czNqY1Ji?=
 =?utf-8?B?dFFEMGJqMkFMRmVlZ2xlZ2IyakUyT3VRN3RHaWpwb2o4cDdRZHFqT1ZIR2dR?=
 =?utf-8?B?V0lSQ1h4bzJYejU1cHJuSEpydzVoUFRUOEJPZXZtYzJZSWxnVDZjVmVHbncz?=
 =?utf-8?B?bWp3Y3dBd3dBNTV2bWtUYWhzcFFjdU5tczVtbE9zUTk0V0NXM2x6blYxcmtD?=
 =?utf-8?B?dFZrVUZYOUNzSS9vYUltdkk1UFZqN1Q1VVFiTTV6dms4dzBNVkdhODJQQk5B?=
 =?utf-8?B?bEwzUXl6UllCSU1vbFh2K2U2V20vQk1JZkFOWVFpTEJnNVJMMFZpeXBZSVRj?=
 =?utf-8?B?RFoyMlZxQk5qclFDdXJnNWgrdU9kcThJNUNUTzNMc2psS0ZqUncvMW9BZlZl?=
 =?utf-8?B?a3IrakM5UTJuRldMa2ZjdzFiQncrVzBPc005dkRPUjNQYzFjWnE0TERnWXI0?=
 =?utf-8?B?eWtYUEM4QUIrZDBzeWhKWkMyWFlmYWdOODVHUEk4SWZvSnEza2tvbnUvb3Zk?=
 =?utf-8?B?YURoR280dXl0OU02R1oxK0l4SjNYdGpGbEhicnNHdHM4YTFPVGtmemtMcWs2?=
 =?utf-8?B?bFNCc0JESFlWMnovMXpDQTJJcXVkeUhRTnlmTm1Ka2FtMTVKaEQrSVN5U0FN?=
 =?utf-8?B?SDBBZ1g2SmdWZ2paK21XWGFobm4xa0hMNzFMYUNTd1pYb0R1WGZFanR0djdN?=
 =?utf-8?B?dGx1ZnlzVVZ5TXAwTVhmVE9vek4rdnpSVWFQUEdRYmJQU0dqcGRrbk44SFVM?=
 =?utf-8?Q?LTd/snKD4UmnX0tFpUbNiPymNLaVzY3wCcmNtlx?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f930f5-7fde-4bf8-0f1b-08d8e493feb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 13:45:55.6664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvOBalFuFHPuw/XmnjxYrNqy2MrVYKq3I8QLCfe4e6HBAjEolCN3qz60Q1t5Vh3FCSaQRvXUZNb7QF/6EqqqmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1098
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBBdnJpIEFsdG1hbiA8YXZyaS5hbHRtYW5Ad2RjLmNvbT4gd3JpdGVzOg0KPiANCj4gPiBUaGUg
bW1jIGRyaXZlciBoYXMgc29tZSBob29rcyB0byBzdXBwb3J0IHJwbWIgYWNjZXNzLCBidXQgYWNj
ZXNzIGlzDQo+ID4gbWFpbmx5IGZhY2lsaXRhdGVkIGZyb20gdXNlciBzcGFjZSwgZS5nLiBtbWMt
dXRpbHMuDQo+ID4NCj4gPiBUaGUgdWZzIGRyaXZlciBoYXMgbm8gY29uY2VwdCBvZiBycG1iIGFj
Y2VzcyAtIGl0IGlzIGZhY2lsaXRhdGVkIHZpYQ0KPiA+IHVzZXIgc3BhY2UsIGUuZy4gdWZzLXV0
aWxzIGFuZCBzaW1pbGFyLg0KPiA+DQo+ID4gQm90aCBmb3IgdWZzIGFuZCBtbWMsIHJwbWIgYWNj
ZXNzIGlzIGRlZmluZWQgaW4gdGhlaXIgYXBwbGljYWJsZSBqZWRlYw0KPiA+IHNwZWNzLiBUaGlz
IGlzIHRoZSBjYXNlIGZvciBmZXcgeWVhcnMgbm93IC0gQUZBSUsgTm8gbmV3IHJwbWItcmVsYXRl
ZA0KPiA+IHN0dWZmIGlzIGV4cGVjdGVkIHRvIGJlIGludHJvZHVjZWQgaW4gdGhlIG5lYXIgZnV0
dXJlLg0KPiA+DQo+ID4gV2hhdCBwcm9ibGVtcywgYXMgZmFyIGFzIG1tYyBhbmQgdWZzLCBhcmUg
eW91IHRyeWluZyB0byBzb2x2ZSBieSB0aGlzDQo+ID4gbmV3IHN1YnN5c3RlbT8NCj4gDQo+IFdl
bGwgaW4gbXkgY2FzZSB0aGUgYWRkaXRpb24gb2YgdmlydGlvLXJwbWIuIEFzIHlldCBhbm90aGVy
IFJQTUIgZGV2aWNlDQo+IHdoaWNoIG9ubHkgc3VwcG9ydHMgUlBNQiB0cmFuc2FjdGlvbnMgYW5k
IGlzbid0IHBhcnQgb2YgYSB3aWRlciBibG9jaw0KPiBkZXZpY2UuIFRoZSBBUEkgZGlzc29uYW5j
ZSBjb21lcyBpbnRvIHBsYXkgd2hlbiBsb29raW5nIHRvIGltcGxlbWVudCBpdA0KPiBhcyBwYXJ0
IG9mIHdpZGVyIGJsb2NrIGRldmljZSBzdGFja3MgYW5kIHRoZW4gaGF2aW5nIHRvIGRvIHRoaW5n
cyBsaWtlDQo+IGZha2UgMCBsZW5ndGggZU1NQyBkZXZpY2VzIHdpdGgganVzdCBhbiBSUE1CIHBh
cnRpdGlvbiB0byB1c2UgZXhpc3RpbmcNCj4gdG9vbHMuDQo+IA0KPiBJIGd1ZXNzIHRoYXQgd2Fz
IHRoZSBvcmlnaW5hbCBhdHRyYWN0aW9uIG9mIGhhdmluZyBhIGNvbW1vbiBrZXJuZWwNCj4gc3Vi
c3lzdGVtIHRvIGludGVyYWN0IHdpdGggUlBNQiBmdW5jdGlvbmFsaXR5IHJlZ2FyZGxlc3Mgb2Yg
dGhlDQo+IHVuZGVybHlpbmcgSFcuIEhvd2V2ZXIgZnJvbSB0aGUgb3RoZXIgY29tbWVudHMgaXQg
c2VlbXMgdGhlIHByZWZlcmVuY2UNCj4gaXMganVzdCB0byBsZWF2ZSBpdCB0byB1c2VyLXNwYWNl
IGFuZCBkb21haW4gc3BlY2lmaWMgdG9vbHMgZm9yIGVhY2gNCj4gZGV2aWNlIHR5cGUuDQpZZXMu
ICBJdCB0b29rIHVzIGEgd2hpbGUgdG8gY2xlYW4gdGhvc2UgdG9vbHMgdG8gcGVyZm9ybSBieS1z
cGVjIHJwbWIgYWNjZXNzLg0KDQpBbnl3YXksIEkgZG8gc2VlIHZhbHVlIGluIFRvbWFzJ3MveW91
ciBhcHByb2FjaCwgDQp0aGF0IHdpbGwgcmVmcmFpbiBmcm9tIHRoZSBuZWVkIHRvIHJlZ2lzdGVy
IGEgZGVzaWduYXRlZCBibG9jayBkZXZpY2UuDQpQcm92aWRlZCB0aGF0IGVhY2ggaG9zdCBpcyBh
bGxvd2VkIHRvIHJlZ2lzdGVyIGl0cyBvd24gb3BzLg0KVGhvc2Ugb3BzIGNhbiBiZSBhIHN1cGVy
LXNldCBvZiB0aGUgdmFyaW91cyBkZXZpY2UgdHlwZXMuDQpGb3IgdWZzIGFuZCBtbWMgcnBtYiBv
cHMgY29udGFpbnMgNyBvcGVyYXRpb25zLg0KDQpUaGFua3MsDQpBdnJpDQo=
