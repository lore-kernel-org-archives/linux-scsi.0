Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CC6EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 21:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjGXVbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 17:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjGXVbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 17:31:02 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1754D8
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 14:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690234262; x=1721770262;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lJgn8pNQnKl6VGuCOyZD1k6LANmTtaxVcN8nW6+2t4c=;
  b=h2tCSR+hiru3bprW4eDsEgqM3r/nmvZ74msGmSi5L9w0+kIMniPPs26X
   0knRGdqi8tCtcKoMi+3mf3X2jsD2KuMvf6rJwe9bb0CYWzF+4RJma+Ug6
   bSvIZtsOSTkg3usmdfay0NEa0q9TMaAmHdBAgDCAgj4Lwyuis4Csv30ti
   N+P//qy3V1NhjiL9p4BeXNb+EEbi5eXLIniG7WnsPIeW3GYP9U1txRrZz
   h4RePzEzj95yXMUwltZcOP0VtnQ+uvXfie8IOluaZ4tnnJd6+7ZD0zjcG
   IDyUgltIvV7/6Rk5/wIJObBFqLNE+VSeMFN9JqdGUv3qmGruZy9CWI6bT
   A==;
X-IronPort-AV: E=Sophos;i="6.01,228,1684771200"; 
   d="scan'208";a="238756025"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2023 05:31:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3HElSX17DOjoKJNMVVKgC9aPgW6eWENPWsL8jKV78irzxTVo3cZeEoKgQZ+Jl4rwaxpjmdAel4e1loiYqSs30LvT+MaWwMx8nyjz5bA+adrYkoZ8LFr3dYYgjtXnniLsvz1+gVcvlymAlznqmqQKmgG9KiqlTR3cZXj+rDuhWzZu7TPNcmgziHPAO6jj9Vs3gUIpSQzfa6GwuGVuhpH58q9YnZz0t4sfBwM73pJJK0ERrpkza4mmRTOIsqc2qqAs8yXYz9Nzk0WN4UM5iEQ5VvgWInQF4+YJ4U4eU0uFb18LIE+9odjIjcD21IJGe3sRW9w0gEWnef6En9TKTsoPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJgn8pNQnKl6VGuCOyZD1k6LANmTtaxVcN8nW6+2t4c=;
 b=eHcC5EFnAR7ImYxVtbUMBN0GhEQ69JGSiOUK6NGb2v8+s+YoicmRqv1dNBFA3CdMW+fX6II6DhojwnKzfI95Nvc64PIb+1X/N9yrdfNlkfZZnsLYvTvwgwRYvt1FUr9ZFraYUMl3Q6iL7k72qxmNpK1ZcqEjYePy6P0UkcglKsVurDQ2w8Mih7hhtxGemYa+elDMjSMFXSVdnOnVR8JtgBRJm6JPqiXBzR3JGlxoZnhrjOHNGM+NDYcVscY7pUITNNmP+3xXiVilBHOYqJWz6nLqu9PicPNyIsHVDGi29mm3XCm62gggWUcAkPux6RHKa6qdBM7+4xhSwLICQKMVfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lJgn8pNQnKl6VGuCOyZD1k6LANmTtaxVcN8nW6+2t4c=;
 b=ehsjGrurjlWAuWjSPuYSb5mExcBwRtmkNNsFs33/9rj88+0xahtKPQt4NRIlEG6k5b5YLrBn6iSBck0QNBYMiI4VJMwX0Z7EleLBGfdByiR9b+hYnMTBTxRSn+uYUMP+NbLfcfD7XK6QBlUMka3bQ55MpoiVcwTCte++SkxU1Q8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7760.namprd04.prod.outlook.com (2603:10b6:a03:3bb::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.31; Mon, 24 Jul 2023 21:30:58 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 21:30:58 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: RE: [PATCH 04/12] scsi: ufs: Rename a function argument
Thread-Topic: [PATCH 04/12] scsi: ufs: Rename a function argument
Thread-Index: AQHZvm0yrtjEkt/+QESaHS235L2lbK/Jbz7w
Date:   Mon, 24 Jul 2023 21:30:58 +0000
Message-ID: <DM6PR04MB6575250799E3A1B30FCCCC1DFC02A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230724202024.3379114-1-bvanassche@acm.org>
 <20230724202024.3379114-5-bvanassche@acm.org>
In-Reply-To: <20230724202024.3379114-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB7760:EE_
x-ms-office365-filtering-correlation-id: 5244ffc1-5bb2-461f-b8f5-08db8c8d4572
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0DYqXorTZTZ7dt07zB6nlJccjemuYAOPdqQnGzmq+jsv3DdnHtU8r/ySJ0EsbyZr9V2n7cTFkNZi07mxuq+CclvdeNiYt8qASMbwofo4qCFUytmG+TiI0fmfJPDWILGuXG+549WSMi8AEbdiUg57ErH7s2t2sCqITBrMiD2Zfg9+V5kf+3hUagKTWUlHxt6nSsRKajx5sJ095bgu3ReocwDnHue2aaf8dnwDrWnSJO5Soz7/JQA43LPQLxEBr/Spmovkiw/BubjPbbLiH7hvnAVy8Im8ch8ANlpNGtK+DeDYD28WGDIkIKfkMN3j+ow2KjKeCHU6jTFjh7zW8h+QY8qAC2fOkfZKF2DhUTTtQGsMYCK9zK4ZDhzNulRg7FYKm/1h534t/k6Y3y7QZqhb/U559rMCyP+5YzdKSAqvrYJ2PTdiEUG+WBJSf8vDg3VfCygIhZZps+w1yZadArQuJELTwsmvlJ4kiSGJuLB17h0zoP8qPMhX1jKsZ06d+dYsAnE3sLDdHvyZ8N4axfwYHrlXrGEMGjdbZfFGZ6nkTNC5qbzaLbTDoM2NghqfqY13LOav5Y8e0KsDxI6RF2J4uxt+plu/0hKobvZqhum8f7s60UqE1DUv6VO4Br9J/dt+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(38100700002)(122000001)(55016003)(83380400001)(66476007)(8676002)(8936002)(5660300002)(52536014)(110136005)(64756008)(54906003)(478600001)(66556008)(4326008)(66446008)(316002)(76116006)(66946007)(558084003)(41300700001)(186003)(26005)(71200400001)(6506007)(2906002)(9686003)(7696005)(33656002)(38070700005)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZGRwLzR1VTlzcFlkbWVvdmQ0YllhMkVJTDd3VEppdi84QmNtTFp2UHg4YzFi?=
 =?utf-8?B?VVdYQVBRS1hybXkzMEl6UlY2enRWci9DQjJ5NkQ0STVRRC9INERHTVVnUlEy?=
 =?utf-8?B?OGRkeGRpWml0SjhVZkJsMlY1RFplN20zc0FQZlhWckdhc0VSMXBPSVExdjVs?=
 =?utf-8?B?MzlkSjR0c1dlYmQ1YWN0MTlod0p4Mm9OK1Ivak5nM0NpWWU1MUpJQXpYYzQ3?=
 =?utf-8?B?UnB5L1hhQmhjZ3VwQlltcUtKSDJpL2JnbTkvOHFLZDcwdCtsWHY2M3NvUHpr?=
 =?utf-8?B?akNoNGpYNG1GZEE5RHNEcnZvemV5M3Q3TVdpOURTZG9PK3JYVTFsdHp4SmJY?=
 =?utf-8?B?dGRUOHF4SnY1R0FheXJ1a2FsdzdOWVZ0UjVTR1h0YTh5QmprRHNBYTZQUUJV?=
 =?utf-8?B?TkQ0WGE4Qzl1dXA0RG9BZ0lYSXMxdGxlTVFYMklIS1pTMFAvWnhZdk5EbUZN?=
 =?utf-8?B?cS92bzBJbGJhOEJzR0JGRXM2Qitmb2N4ME5jeXFXaE9aOUZSS3Zpc1hFZmtP?=
 =?utf-8?B?ZXhQM1h3d1EzenZDSEJhSk5hRU1TWExzYXBFOUZZbVI5M0E3ejNQRVRwdEdu?=
 =?utf-8?B?Qit3eGYxY2lSK0FmeUpURkpVenVtcU1BdHRzcStwbTFCSndZTitjWTlFZHVw?=
 =?utf-8?B?d2FRazA0WUVEUnJ2VVIrdTRFS0ZkY21TcjR1Z3A4cDVXc2Z4SXp6eGltVCts?=
 =?utf-8?B?bU1rSXd0bUFlRFZtdGdSRkRnWTNpMUZZK3Fsa3VlVmNYSkdzOVUxZW5lNFov?=
 =?utf-8?B?cCtsQkZEdi9KcXd3bkNXdjd5NzJzVmppRlZLaHI4VXdZRllOTFZnSVM3Ylc2?=
 =?utf-8?B?RjlNSmFuNWJibHdPUEppQnJSMVRTUElSZGtLeGx0N3g0R01wNXVSc085YmxH?=
 =?utf-8?B?em5WVm1Pa1RDb0tqQndPMERhdGZUL0hsNnI5dUkxb2Jwc0p0dXh1V3lrbzF1?=
 =?utf-8?B?ZDZaaWRsTE9rUnZRc3pXZCtEY3ZHVjhjVUQraHNMQUh4eG8vWXhXbXp1OStE?=
 =?utf-8?B?c2FrN1Zpc2Z5L3AwT044VFc4TlFTRXNwWXZWNWFYWlNhbkY2TDJUSzlQZDR2?=
 =?utf-8?B?SVpZd0lEQlZVdGtWeXhCUnB0WVFDRVV6SWhiTmM5V1dHL3NMUVVSeDNVQkNP?=
 =?utf-8?B?dDEvTkF4cURIS0VKRFBMUEk2RFdwWjBzblpjRm45d05RQjlZMU5ISmhhcDZY?=
 =?utf-8?B?NjA0UDZESWV0a2NGVkd5V21Hbi9uYW5tK3pmbmdIRnZTTUsveS8xN2tUaWF2?=
 =?utf-8?B?Y2ZzZE8rTENWNHF0QVkxbEttYnU2ckFnQTNUdWN2K2pNK3NnL2c5M2xKL2xC?=
 =?utf-8?B?ZUlHMEJUMWkwQkpNNEpQd2FZY2o4RGRleWlNTjdGVFhvSkdUUEN5TEdJUnBn?=
 =?utf-8?B?WlI1MExTVzZ5aERrQ0x2L09lWTdYdlBsRlB4MlExeUlNZytRWW9oNTdBVUVQ?=
 =?utf-8?B?azJWZlVGbDJPc0NSYjBETHNxbzhQekpuVWk4N0dtQVBzcWh4VUZ4UldOMURN?=
 =?utf-8?B?bGdFL2lYVUp1Nk4vejVrZndzQ3lmSlJXNlhrWUNjbStYTlY4WUhRNEJUaG1R?=
 =?utf-8?B?a1g1dC95M2lVN2hRT3BGdlB4YVVqQ0pYTDJQWnRtdUhqWUlwUUo4Q0FabGZL?=
 =?utf-8?B?V0RWT0xjdjR0d2hTd29BTGFnd0xIWnJ4TUluMUtqdEpCdzgycVFMNGVqU011?=
 =?utf-8?B?NFdoWWEvS0ppaUlLeExQYXV6cHhqay8wRmd5NU5ZeE1aY05VR1IrZXFPK2hI?=
 =?utf-8?B?WGJvMEZtRXNrV0wxeEtUYy9hSEhBRkhyQ2MvTFRsdnVUM3JhTklzK0FNVjFx?=
 =?utf-8?B?aWxjQXk5WFBPQVo0NStERzNIUGdqcGhoOHg2K0FCSytOSmlCVFRmSklMdjE4?=
 =?utf-8?B?Q1ZncTh0Z2xQc3Z4QkVkTnFFR3dyMFllUFRLY1JIbWdmQ2tXSVd6Z0xWVnFV?=
 =?utf-8?B?OGZaaDdGNDEyTGhZbUsxWUhabWk4dEErS0U4Uk9wZGZWWjFZNCtVaFZySlMv?=
 =?utf-8?B?b0pKZXl1RFF4MGJ0RGZwaG9aeUtCSmd2ajE4NE80Z1lMekswSWZFc083ZXZO?=
 =?utf-8?B?RVFraEIwS2FyY1V0WDRQWjdGMzltZ0Z2WFJaU2VSOUJnTDljRk1EVGZ3eUFl?=
 =?utf-8?Q?FBqhr6vSVkjbaIhT5V3ObH5oz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Mjd5yUFGSIDosdhzXUgYVUa5o3+5uJefCk8L9Vc8UJ0dJ2Y+zM2vZp0lpdlw0zSn8xm7pD6O071cYyeg2aPBTl9GHfmwLYSy6rut7wZzsw5vFdhKHygA1QCg+pvDK1Ayd3qi2fYGgZSjWic1ndXAPc50omr7i5POtnOdBn01c39pi6frGh702KdMtgSqcrp+0FnXMWA3qXAeCh43diw+tPBXrlScIgANAdhRFevuDvilEQddkzaFrlLIGGQnQsRSxKJ6MDcObstcb7KedCl2edUmbyXd+SO5SNoyXshV5+VsEmWJxXhzimbWLJqjfWxBXMmrnhHttgqgajafQVyXF9mF6QhQP1TSaLRi9uMQVMQb2UqAcPLvj3XjmQcysORMer2HixJUA8VZS+GzFcsw1vSOnrfvOQg9BDuTZFRw/hzuRkgIofxazOkcPzKqBpgrSXyZYYCqMm+8hXAngAkJfhkyIf0N7QiexWJVJuoUzYbrSiiVlsFiQCHpbVzgtt+kW/8EUWyT2j3hDdU/5t/N2JDgFIBgV4FWkZeId2qFPpeefEjpsp3UsD11WMOMNmIxjg9huTr/clfifD4veqZafaHzKgiy75ZL3Q3hkicBhdxBJyqohse6suH5RY6PBUg0zqJS22OnA/xA7ERjuBi11l7Ys5UidYQabmjetl+uFgtXNelgU7yegCXnY0vXpXGmKevCKtKhAgHvUsvk9Ilm4kQQQ9Ryj51VxRbhZCKSWcl/NAfJp21cEP7gYdHVCkpf+GivlaVbHvLKcRODNzqR5yiXCmrRF6g6z13Pw5wzmeQmDFnn7FVCZ8fLu+E4nasRqVd1qjYE6Kli/FvbyNvQdqID0bGzI3Ouj+40Kdtsj1k/I1CEezM9HZj+agrvSBk8M493V4/p3uG0rDBGwkZa3WTOJETDoCyQLLGSALN3yEQ=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5244ffc1-5bb2-461f-b8f5-08db8c8d4572
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 21:30:58.5979
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6LSw8foHuI7rqHWX+AXqyhKLVGihQid/jmN2S74OZJx/72x4/rj31Dgkp/fTd3tQ1y/ReQFwz7t/CGu6tCssyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7760
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gVGhpcyBwYXRjaCBzdXBwcmVzc2VzIHRoZSBmb2xsb3dpbmcgVz0yIHdhcm5pbmc6DQo+
IA0KPiBkcml2ZXJzL3Vmcy9jb3JlL3Vmcy1od21vbi5jOjEzMDo0OTogd2FybmluZzogZGVjbGFy
YXRpb24gb2Yg4oCYX2RhdGHigJkNCj4gc2hhZG93cyBhIGdsb2JhbCBkZWNsYXJhdGlvbiBbLVdz
aGFkb3ddDQo+IA0KPiBDYzogQXZyaSBBbHRtYW4gPGF2cmkuYWx0bWFuQHdkYy5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KUmV2aWV3
ZWQtYnk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0K
