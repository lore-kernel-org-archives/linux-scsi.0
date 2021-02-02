Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12F2C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7481E64E4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhBBLXD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:23:03 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:41304 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhBBLW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612264979; x=1643800979;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mzipae+K8NfFVwGY9B1jkoL0dibma5f434A+VO8jZcE=;
  b=oKFXqLKy3s4GeQkPNqyuSarsEbkGbs1LUNKHHuFFwZuqI3SzKXv/cJOc
   C3EpmLdvyNucncWjzlkRraf86KOz2M1AzYJnE08VVLExgfxygAOWuUUEn
   bF0w1EaeHaEL1gIFd9bA/BBC1ohNJhpea2685qcXF7WqtK+hGpwMWCCsa
   f89XFiIiX4KYBw8C3/PTM2+pW/DCz6LoEVaRCZcBwGAn6BnMPRuJd+FV0
   0v5xGcPr4voePTkIc4x85a87WPY2pYG1fpC1aLFJ1EH4usyIcvML2S6V8
   oeRwNPObWJnsT01jSsIBQbTMpcFz9kzik0Crlh3a8NjlXpoUguWSg868+
   A==;
IronPort-SDR: cBOnkj3sSK3+YExhHDBGXnwIZq8YcqsjXoQrZVj2lWeipSOcqT8C0S0N4nsmVTki2zdXmrDls9
 uUtXQWbYHB7qisi+odQ3Xm2yBvqqES4vHROJ99nHPqxKuWjt/VJBXpASJDFexOBKUGZ1Hv+CRJ
 3azbJ9siA/o8UuOXwWAAmoXnQuRO88niRq0vqXLyqTdMSAc5w882z3n4XzP+MWK2J1oZqI3x39
 viXHtViGoLkpN6HKYmZAwyudF9ddwLIVx3c4ri0Zv/JUskmYK+0a6r9s/8IejPrrIgXSjU4RN2
 4Ro=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="269330125"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:21:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOne6PVnWeg/EwH9qxT7jxwsjtlxUwM9brIfpHlg03/40rwD9HMIGm1A+oi+hA7C7Wk4OCeOXNO5ynywbOSZHxuxaicFoYGS1QfCIKZmGdPNJYGAuSNYC2Xh+61w05Qcz/g+Frbrk8Hud4dFqSBqTsNL3bZr0s4WXPDzUosBK+NrYqmTNTsB4R/NTI7waN6QQSQgMu6YNJuPB5tFJXdf+mb5vCpl6hmX9sZ16cU20UarfCkVveE9iLWzl9ktpV9Jzy+T218aL9xP0qUZVoCAVxkaQ/FSw1grR01ouOb+zh0W26kXgNtoWSa/6z/v8mAJ/SqyG1OAWnvR5jhKA+pxAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzipae+K8NfFVwGY9B1jkoL0dibma5f434A+VO8jZcE=;
 b=WGdk7h5BJfHjlA2f/a73DlsjfNQViHvELQj5DfF0HXlzyXcNvqHZFDDPLM1nGtb2Zv3zO04IJkODGWirsG8JQ2dhFTH0S5uam5x9SulSAwLnPUpwblZ+lqqbTZugHTsIMKQqVHnB5J3x35Gy4JXC1EASK+hdOiosl7ofQj3rE+x/XqGQwqOScb3u/2j2XrjphRn2fQluAsOFAGbKbsA5y1QcmAXINTiBL4+IpxsW0kTAxvxJNwLsemA6FCyz/L6+I6EcCfVMn0YOm2EdbjOT7SN4ws6t2BaO5VHmCPxMbPOOO7aYDxABq9Tv2fo88ZZrLNAutpwEG02lnryik4E25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzipae+K8NfFVwGY9B1jkoL0dibma5f434A+VO8jZcE=;
 b=x5Eph0mdQ1hv56QkZHyKjISE471H9UQsPZwMxsGBj9MmmvbnwwUlev+zBltSL4pR0F2eXM45gjKTvFHfmC3j2wwatp8X1D4tB+xYl+vtt1+pQ+BynCFFKfj4D4W3b0nexVJwS2yCuyjR3DFbuZc3j4Zidhffte476udkgTHPEro=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 11:21:51 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:21:51 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Topic: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Index: AQHW+T3hFFjX8Zgjx0+EZ0J0IzMsLqpEt2aAgAABFtA=
Date:   Tue, 2 Feb 2021 11:21:51 +0000
Message-ID: <DM6PR04MB65754E2E4FBC24CD6AC5F17CFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-10-avri.altman@wdc.com> <YBk0s1Y4DOXuup+q@kroah.com>
In-Reply-To: <YBk0s1Y4DOXuup+q@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 573eaea3-8441-4607-f5e7-08d8c76cbced
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB026677B37270F783208BAA34FCB59@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: or189OI1Hy6PKMh9CHjdNccAemOzj+947qu0RYO7MGH2GQ8AT08aUXTgbD51aq9ZqnZzaJKUicn+KB4SmuexCMdwvQ5BTLrc/MU9RbYH1yGoz0BOnKyHEE54SVDy5DFRXW+OZYsMJ6ZzEnGodfA+L0YVt2TzJ2Q+AusTkWVml55Esk9S9n7GCqOvhEizXBsssatFDR6XaFFORPlAIO01LDUubvp06V/+58jdxjsjIKsJquypVmSoQlhFUcFnSFSudQVGCRz4Oj8hZwRNLC569g4Ed9h1V7UY/jNSHScEgBX6EL+mkFeJZ8t5BA6Dg+ETaD22gdepDpDj2rfiDTKNS4bEe1XeHuCI/dQUjfEtw8f4j52KIqGPiYgEpl96b+wLYwq1cxv30neLYDFDUB0agB55kWUOa/Lke57fEIwHB/5kojemG6s/wccpP3xxw9Sa7dBIvHh9XqOqQtJH4DD8X0C598cJb1lRXbO4zrAPQIWnZ7uvguItOrtxBX2tji6+JAishetrd+QgO+jyCy7WXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(8676002)(4326008)(66446008)(6506007)(186003)(64756008)(66476007)(26005)(7416002)(33656002)(66556008)(8936002)(66946007)(7696005)(2906002)(54906003)(86362001)(55016002)(71200400001)(316002)(6916009)(9686003)(5660300002)(478600001)(76116006)(4744005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b3BXUCt2S0hLSkVhT2VaUUJFQWlDSHAwejFUelZaZTF2TURDMEYwQlpxZndV?=
 =?utf-8?B?YnBHaXdZOThiSThhK3RPSnpKWDA2TGpPMlBlTnBkSDR2KzZwTFJuaEM4MHcx?=
 =?utf-8?B?dThQMld2VDEyQ1dmZStFV0hYdFloMjB6UVRoMDJwNVVrS1FkZ05jcXV1bkVR?=
 =?utf-8?B?YW1rTDd2SHRFUFJYeWlpbmZ5SEJHckVPeDJrMnZoOWd5OWpFU0pzcGtmU1BH?=
 =?utf-8?B?VzZPVjY4ZC9ESDRBckxGSXo2SUZ5MzZGbkZORDJOZ2JYb1l1dll0eEFmYWVY?=
 =?utf-8?B?ZUo4L0RPQVN3NWc2dzJtL0ZPL2ZJeERHN3RyMldqY3ZNMzNIdG1CL2hKUkwz?=
 =?utf-8?B?cit3YjZtRlZqbGFiVUp4L1MyUkFBYWpBdTFGdGFJanZiWS9wUXpkRDFXc3U3?=
 =?utf-8?B?MHN1S3ZnOWk1S0pnTjJxR2phN3E3dnY0WWlSL2w5TVNLc1JuUCtNRWZlSlh4?=
 =?utf-8?B?OFBPL29sOEdOaE9WT2lEYWsyUWVpcThTUWNjWk1xa3hySklOWEhGcHMvZXBM?=
 =?utf-8?B?ZUowZ3lORC9vaGhJMDRwNDErS09rU2s4QXAxdnlqSElSeG4wanZodGxvbWcv?=
 =?utf-8?B?bEk1ZE9GeTRmS3FzU3ozT0hFRUhscFMvMWU5YjlXb3Z1cDh2ZkFQc2wrWmpv?=
 =?utf-8?B?RDlKVllVYkQwTDl6MVhnQ1loZVlFRE5XVWJTMVRvYUQ2VXlxRFlOUVdzYWxG?=
 =?utf-8?B?T3piUHFTLzVyZHhBZmJ6M0JGbzQ4TVhjZzduTmtjYVlBQ3BtbFNpUk9GOGVo?=
 =?utf-8?B?TEl5M1ZMaGpPWHBQdE8wTnFmVWE5TnhEbC9RdENTSG5rY2U2SFc4SCt6UVc1?=
 =?utf-8?B?NGIyWUdnQzBKUXZCUDhBYWQ4UENMSUxYMHc1R0c3cEpYay80T29rZ1VGOTho?=
 =?utf-8?B?QjE4Rm9YQm9CNDdBbDRENFRidmJvdVJTMFZDOURJWC9tdkVod3lnZG42eVRO?=
 =?utf-8?B?WjUvdmFsVFF6M1g1MjBlQkV5Q3M1YWFlaHNDU0R0VFBZbk43MDdCNXFnblQ4?=
 =?utf-8?B?aFJzOUZoYk1kTC9NYUQ5dUxZVUFFUlFQMVhsdDhsMEl6K2hWRVpvZmhacW14?=
 =?utf-8?B?VHpTUnE2S0Eyc1RYVUlybmFGdDBrSnFKZTNiSHNUVnNFd0pSTU9CcUxCbFp2?=
 =?utf-8?B?VDlPb0VpRHB4Z1o0QktsaHlYR2NUWDJDTzFhaHhmSE1tTjlJampTZHI3Z1dI?=
 =?utf-8?B?RzNSQStSalEydHd0bWhpZ1VkZ2ExcEJLT1ArVHhlSHdBOUZMZzBhQUxBckU3?=
 =?utf-8?B?U25FVTFrZmJqWGRuekxlNjVKOTQza1dldUxwUU1WbGV0VnZWOUVXZnFUM2cw?=
 =?utf-8?B?dlRxR0ZmVi9mTVpNbzdRQ3VkelprcnpiQTRydDVEYUR2bExCbzFPaXVUT0RX?=
 =?utf-8?B?OVJJUHFBQVl0QzRoOWVGUVQzb1pJakR3ZndRak1wcUdoOGVoaXpxL0VPZU4z?=
 =?utf-8?Q?xamWEuE6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 573eaea3-8441-4607-f5e7-08d8c76cbced
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:21:51.2225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ErINDEY/D8jyG89HOha8DLIeB3Zw5gvH/g0nLB9d6ArFGKe1pqpM4DGPqg2GblZ+k1rLAZSUw3v/9BbAY0JAew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+ID4NCj4gPiAtIHRpbWVvdXRfcG9sbGluZ19pbnRlcnZhbF9tcyAtIHRoZSBmcmVxdWVuY3kg
aW4gd2hpY2ggdGhlIGRlbGF5ZWQNCj4gPiAgICAgd29ya2VyIHRoYXQgY2hlY2tzIHRoZSByZWFk
X3RpbWVvdXRzIGlzIGF3YWtlbi4NCj4gDQo+IFlvdSBjcmVhdGUgbmV3IHN5c2ZzIGZpbGVzLCBi
dXQgZmFpbCB0byBkb2N1bWVudCB0aGVtIGluDQo+IERvY3VtZW50YXRpb24vQUJJLyB3aGljaCBp
cyB3aGVyZSB0aGUgYWJvdmUgaW5mb3JtYXRpb24gbmVlZHMgdG8gZ28gOigNCkRvbmUuDQpXaWxs
IHdhaXQgdG8gc2VlIHdoZXJlIERhZWp1biBjaG9vc2VzIHRvIGRvY3VtZW50IHRoZSBzdGF0cyBl
bnRyaWVzLCBhbmQgZm9sbG93Lg0K
