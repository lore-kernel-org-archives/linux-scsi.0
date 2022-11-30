Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F311C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 10:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiK3KDc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 05:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiK3KDa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 05:03:30 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6628424097
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 02:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669802609; x=1701338609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CVCaz+LE01GrO2QsP780tetHV2YcJPD70p0zXbtn9B4=;
  b=bke18m/ytjRaRDyCXvIX0tbwty5PwGM5O69JgfpQcQuUzmtYw4JTekNp
   sEd3WCl7DLmxJmfHJqU89w2DJfD2Y6r99bKwbvRpipbPU0+zmQ8Amso+H
   obapv2odW65leWwQaNA/iv1mx2yQxT5BTqkJheVg9xNddwFbijDI6ym0z
   peowtKVRO8OYyM+heFW8h9DJR1iCJGKSapQATme6bNl8t2AC5H9s1c4sS
   Xtb5C7b72wyO4jeRdXlRW5vGcIQTFzvalaIiegcmJhuNT+uY/udaJ1lZn
   56PKBY+3uP/WR5KxX+SF2weZT8BveExuv6InuAjJPSgi3Pw9E/JJ/U3Pv
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="217827587"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 18:03:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X2+s4SPwwRAEqk8cYOLReZoZxMEjS+L7MPTqNe0kwa6JFE6zCE/S1lbvBSnA7JLP1iIkeOGo72MhQ6bk4WOmH8gILhrI8Ra8I0ne3nKoznBiP2C5lYSqWOJ3BjAOQLqJ+cmtAMHJZcHI8SGpncg0j/MPnaBZCZpNAbVC3PC/Rr/fiZbEwJ4QkFTiivvs8DqgG5Zb+k9GyrxLPLlHkgCUXQx3K2UOmwcJ1l270I0HHX8PMZjv5PgEplya6TtrRUHe3FNLGEdayItaRuHJHf7f9fzfHVltt4BGLUdEi5JAgWcLQwQav5JOmqZ2n/q5NYNPecDEqNNGDwrZ+EbQIAOQog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVCaz+LE01GrO2QsP780tetHV2YcJPD70p0zXbtn9B4=;
 b=IiuLePs2HVt9MqeIuV+ZoAX/v34OtXOTT03Y3MjO458JgqfF6ux6mm7JqeAGDXFod/aQiHopriHT2DGdFKYkxiJw4/y7UI6GvgrH11nadQOcjAqGHDcFW2aU3ijkCAZNDIv1kaEIS9uk6cN/iiP9JyvnMwoQkWpdPvBgxcQmXLcRBi20i3L6O2j7nfhJV2KhlwzHyXpyvceMjF1L9ahoZGDigfqch+rjc7BPefisn59fH9VnXKFjxTv45wjoyhpc8BWXHN5XTEp7/+eByVtVvJMEeoWVTmddA+6Ewz0PkwFitONnlSKQYrKl5Fvv4HmCDc3Ou+fkEZrLwNa5RWnqLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVCaz+LE01GrO2QsP780tetHV2YcJPD70p0zXbtn9B4=;
 b=UsiIuix4imTywJYC7sS3nvwT/yGevxlEqFoUgFrp1J2k0nf6ZmuHlgGoRxnXVFiQDf2IQgt+uRKaoI0bb6RCNVPV8oVAQkg3EGtxKhmna1NMEEjgEn7O4eIjutSsPzJgIjspUG3qnuALRO6qq8ehfqbqQ4Qm7gX+wvdW0Skz/1E=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB8243.namprd04.prod.outlook.com (2603:10b6:510:109::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Wed, 30 Nov
 2022 10:03:27 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::81b2:90e4:d6ec:d0c6%4]) with mapi id 15.20.5857.023; Wed, 30 Nov 2022
 10:03:27 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "hch@infradead.org" <hch@infradead.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Topic: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Thread-Index: AQHZBJdIwi0ipPRZEki0DoidGKrtk65XPJ+AgAAALAA=
Date:   Wed, 30 Nov 2022 10:03:27 +0000
Message-ID: <c02865e2-1dc1-343a-d5cb-f5dbbbf287c1@wdc.com>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
 <Y4cqSUo7wcnzLLcj@infradead.org>
In-Reply-To: <Y4cqSUo7wcnzLLcj@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH0PR04MB8243:EE_
x-ms-office365-filtering-correlation-id: c38ce0b1-84cf-4db6-e4b9-08dad2ba2027
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xDMlsK0scMOn0LugMWivZAPXQJtp+R5fBM6t56grwpAmIulS//mskE12DA48j/CmTzffeIe+QdblcCyj7ksxwDQSaJW6fXHRdvmlLj6KiH3bj3MYT5PQ6VSq7be0RKVVqE5rSOkvCYHUUYIGjzbdIZRmypi0CC7W19TMOdVo+HhTIrSMfjssuGXsrORRJIRqLJSiuTnuDb+rC8gRhZotWkDdeOPXHZbyjc1Sfw/japVDzFNpIbClq7ILCneG5+uUkpnm3ujKfUa23WPR7O723ecUJLnpiigbogvBD8y6M0hasO283Ped6ARcvRAVdTRIJn3lqEJTVU9xtrLPJYEF3KG65DPfR0Jp/ssQvarpA5kvdZ43pf1nfW5S4m4zSvXC1MVq1l4nJCLo82ZJI/nfruDMhZXEzUPMEgvs3wPR4w913ilnq1Gvm6e4H1OXwA0IvN7nXtjs3xlX4xvIbw7S6fGM1nWRTfGhLpAjmjvlVUSMFRa7jARtSmH5xTsI5F0uIC96fYget0C4dcU7TQZO3QMtMQX7WZPlFR9KlwnVIhN2GM2tTiHKXXIrqg75jS11BpRpvnyYgnGF0tM8FvFz5yoGQRl1C0FCii3UKqxJ/kpECgfdf0VfdY/5v7ig0m00OVdX3xhp0CsEzNRVyjFvUtNJ/0/z9+FcHZCykNbL0wopiVUhiIL4iAcluE8kzUMag0ILMa0oSXZ1gleiW5Ht97v47zwLrkYi5AisknGmL0RMiniCzI7ILhtPwtP2Fd0znDIjHy6y+ENI2vzm3irWRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(451199015)(66476007)(558084003)(38070700005)(6506007)(41300700001)(86362001)(8676002)(66446008)(186003)(66556008)(478600001)(91956017)(26005)(76116006)(6512007)(71200400001)(2616005)(4326008)(64756008)(31696002)(6486002)(66946007)(316002)(82960400001)(122000001)(38100700002)(5660300002)(54906003)(2906002)(53546011)(31686004)(6916009)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0VhL2lQc3RJbGdnKzJwRzErWFdSNHI2Z3ZFWklDUllJMjQrQWtVdFVJS21U?=
 =?utf-8?B?WW15VHk1U0NiZW4wVlhwN2wyaWF1UnAzcG00c21qNGh4WlJnSFJLUGcvWlZL?=
 =?utf-8?B?emg1c1dmek9adXdwRmhiK2NrMWlhMWZLRHhiV3hwQWw4cmtwbnNhS0tzRVZ0?=
 =?utf-8?B?cE1wU0xQZHZBT3pWZklsMld0TDNhSHBOT2ZlMkZCbEhPdE1mY1JYNUtMaHpl?=
 =?utf-8?B?emlWT3BSQTh3WXVXMUI5Vjl2NzJkNUpncGJJRWVzOCtoUG9Jd2xkVkNIUXJp?=
 =?utf-8?B?cGVpMm9nLzAwcnZlWnEvdkVhUmlCYUlyTmJRQTYwRGZha1puOUE4YXFhNXlZ?=
 =?utf-8?B?bDc3Z0xWMHdUWEhZa3hMdERkVy9LSUQyeVY3dC96N2s1bFRVUWNOR1hHbndH?=
 =?utf-8?B?eGh2OUNkWkhRQ1VHSmloS2g2NUlyRHdBV2xwc2cxdXlZTHlPYXdlNzRYbjlX?=
 =?utf-8?B?STVDMGdTa2IyWDdMVUZzUzdBMytDWlFYMjBpU2I2MncybEx1ZEIxZHhCZk13?=
 =?utf-8?B?bzRCK05LZWhoZjNYTWdUeUE0dForS0RsTmhDNnRYQXlmY1hjc0Q2dW9mRk1w?=
 =?utf-8?B?c2lmc3dKN3dXcHpqaFpONlVzbktpTFA0N2U4KzdncWg5RERpV2ZvVEdDdHds?=
 =?utf-8?B?SnpZZmtiamJjUkgzWVh6c2Z6bThXYlZERk5WK2dvS2Y4cGxvclFPdVRmbjhK?=
 =?utf-8?B?cWdpSDBoWkRRd0RETjRrOG9vYVJ3NG1sZGdSbDdFN2x1TVIyUHBuNTlia3k1?=
 =?utf-8?B?L3NKQ05IVG5QRUMvR3VTdW5nMys0RkFRS0NQNVlQYVlVZDQ5cEppcUZtSm9z?=
 =?utf-8?B?dGMxeUJvK3ZPYWRxT1J3am1BREt3bi8vb2hkdFhtMEhRdURBeHUzSGFCMTJs?=
 =?utf-8?B?Q2U0TUd3ejQvUzhEbjIxSmdYcFRvYmVGY3RkNXl2Tk5NbHQ1VXI1czZaaTFv?=
 =?utf-8?B?V0pXNEMxa2lWTTYyM0pFTmcxRTFHS3hZenlheWhxMGNaclhZbnFNd282c1U4?=
 =?utf-8?B?c055dUZDQlYxdlhzM1V4d3liNE16bG1xWXNqdmNlT3VWSUlYcmxUQVcxTjNM?=
 =?utf-8?B?dHJmQW04Y244WmZqMTU3aEowV1ZPazRHV1UyQzdpeHNwZE8rNmplVXN0OHVn?=
 =?utf-8?B?QllQRkFWRFVjU1N1K2NIYkJjR0NoMHRyNVZHRWtUTTFrV0J4RHFWVml5R2tK?=
 =?utf-8?B?SHdBSGp3ejZXZFNzcE00MW4veXE1aWUzU3Ivd0NpdnkxMndYQURDd2VicmI4?=
 =?utf-8?B?U1plN0d3ajVobTVyRG52bWljUlBBMTNnbExTTm9kMnZBdUZMOStQMDVYK0hW?=
 =?utf-8?B?WVFiL2pUQVEvc2QrbS9BL0hjSTJqY1NSWmFwZitXdFRzU2o1NFc2eC9VblYz?=
 =?utf-8?B?Uk8vQzF5dGdGVFVOODVKall3b2hWbjVraCtyT0Y4Ri9sMkJMNFRLaVRmc0du?=
 =?utf-8?B?OWRnalhXMWprRi8wTDYzRXBmRzNITHVZdDlpakFTaEpvblRDT3MyZFpSL0or?=
 =?utf-8?B?VUNMbmNXZVU3Wk9EdjAxWFlxUlMvb3hhWWZTUDFKSG16U1Q1aERDVkU5dkVN?=
 =?utf-8?B?MzdpK3UyNTU3M2NrU2t2Sm9iRC9oOEI1RVQxRkM0SjFMMG4vUEM2c3k0c2VX?=
 =?utf-8?B?QldiWTZXaXpKU3c1NmJnVU8wUUpoa1BRcWFINExoVys5MkZUNitzcFdmclVR?=
 =?utf-8?B?cUdPZWIwL0d1Y2tEWFJuYmJ2d2JzajQ5d21BN3BSMnBQUUs5SGw4QUdRazFQ?=
 =?utf-8?B?eFlKdldCSU55MTRmb1puQVpORkgzRktvZmVTT3Jyb1EzS0pZTG5JdDJGcGZj?=
 =?utf-8?B?YTA0RWdTVHpiVU5UNy9zWGluRCtmMTNrTTQwcXFKK2JxNHJSd05Jd0ZKUU02?=
 =?utf-8?B?OXpiOFlsS21oUjdFL0hiRURwdDg0Z3QyYTB4TEN1U2lNd1R0Z3RrbkhJUWdq?=
 =?utf-8?B?TFlqMDVtT2pSa1lKS2g5bGVqRWVWbWtoWWRianEzZnJKbWdGaUkwREl1YTJs?=
 =?utf-8?B?ZksxU2FQUVN4NkVhdGJYVVZabzc5TUxUd0ljNEZqdEJCQXFwU3ZVSVJUNDRG?=
 =?utf-8?B?Vjc4Um42cGVZQUV5c0E0MFlxSWZ4S3pDQWtpL3FiNVhnUHFDbGsrbGpiSHdy?=
 =?utf-8?B?QWJqbk1BY29HU2NCOTZiUG5UbWlNUnBCVzdSalZHeUVLeGhxb2hrRzN2WEdS?=
 =?utf-8?Q?6ZNJDdmD+prEMzRPhfDviDk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10A66CE717C725428836E8AE7710FAD3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: N+bseC/OTj4Ta6MkYqUmxgpK1J0KlcmpLyjJKctGqEjqhjsx0PQsi4AtlFiVsi7lWpimppMV+DKVh4FS5GZI4wyu5u6TXTR6AMvANA4AiTi+7z6QlCTN60vumTkyXib4NqNTujOkLv36xLaTiirsX2Mi5FsorO7s2grkL8JQxaERw33d8rBssUhcDFSSswHPj1ctF9YSzMyb718DSE6DIpPVVOK4d8j5TRF87pbPZCAPhh/sqjzfx2EvpEHQCjDj8ZXOlQMMZ1gsXAyB92BAwpVekULSxYuTdy9PIaPsRBcrm+grHYab1YbC/lpjP4EIuAMFOQcBrr9NUGSoqlzegNP/RVA/EAHkCOcoBMZVlb8VJUkbWC08qp9Sl12D/lPXUJnM3Hp84gT04kYFxQkTYQc2Vj4WQb52UqYL0LXJMKRNjqXZG4Kr0h6/S/IUlubmaXyyu5H/B0VsGdj4t6i/Yhct3/EclWc/5gC+qapCBnHmU9zzHFaw7ei86RrDLjILaAUrqXmOTX/V7fkTJqnL/2ptXiw5Kn+I1PNfP6Os9+AKx2UJkW/w1Wb5LfulxUGdzo+yL8VlLHzFMMtsxCryLb7+LpVeWRUM/7Stzx0sW2JfUx3yjphXQh07POGRoKWhsbftBBsilnF2bJBLNi3iluBugNmp2ObI5RswVQGywjIbpGwnQi4Q2RlmLQymiOTgI3xr7vHkztV9ZiwT/kvVzPWBev6ifPbOBEeHq+79do/PzSa/lPqZWTJvtS0iHwZ85u7Z2ZCezO4Snt6hbkJReedPgxo34X2DCm4NM/x6KyNIdOeVBXdWXOLIHyyV6hYakog3HhujfBwPs+t9SIjFVl+2RuGpYFvG9G8Y/9FTNpIe8ez2f6UsmvZbrDdRktZr
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38ce0b1-84cf-4db6-e4b9-08dad2ba2027
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 10:03:27.1425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ofTFroDXic86s1bImVwD1h4AKB7Y5lqb9cwfjq40lHqsq1qGJTxHd3xvSYxW6JTq8a8KuSln3j8XgEvLyaRjd6vIfisbt9GooCst1SwHMU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB8243
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMzAuMTEuMjIgMTE6MDIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBPbiBXZWQsIE5v
diAzMCwgMjAyMiBhdCAxMjozOToyMUFNIC0wODAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6
DQo+PiArRVhQT1JUX1NZTUJPTChzY3NpX3RyYWNlX3BhcnNlX2NkYik7DQo+IA0KPiBVbmxlc3Mg
SSdtIG1pc3Npbmcgc29tZXRoaW5nIHlvdSBkb24ndCBhY3R1YWxseSB1c2UgdGhpcyBhbnl3aGVy
ZS4NCj4gDQoNCkdhaCBjb3JyZWN0LCB0aGF0J3MgYSBsZWZ0b3ZlciB0aGF0IGlzbid0IHVzZWQu
DQo=
