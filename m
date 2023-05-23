Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85033C7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 09:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbjEWJV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 05:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbjEWJV0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 05:21:26 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B025A94;
        Tue, 23 May 2023 02:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1684833685; x=1716369685;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=mAEd53dzkfCsOxcDkGRk7dj4kU4eptfauaIkFduroln63mwOoYLnDYGb
   Fg+adkSu90Wokdnyca/GJ/zC0s+S9e9KbRiDDR9jKDPPdAc+RfQYOfKTB
   MXza+wFMPIr1ss52rdOf9NMEDO6+hebHj0lph2cAe/LTYD5x0Ot1Oohy7
   lA03bqFdrCLBtaZv4gvwsg8H9tZcrDswEBeCyxT11GRRY1PIc48RznoAb
   sesQ1LYKPJC2J1RudzTOaITcPnOByXcItBC8zI/2m/v2ys+nyI/DZlAGF
   CZg90jrNd6UO39oJNf4NwaQwotDwHq8LQRr541VqvWqCsgG2U1QzYcAOd
   A==;
X-IronPort-AV: E=Sophos;i="6.00,185,1681142400"; 
   d="scan'208";a="229598744"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2023 17:21:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yc3/9uhnugbs2A6O7AhxWcmYAqwwc9LP49ZiplC2LY9zxvueO+yPEzNrGe4+15B8nc0Ug4aOrJPU7vl3XmJc7+KE+3mdeBS+vLJi6P0pbRRtIbJqKiGERqGQcNea+1EBNBwrtfrhk+bKWgZL6ntyyzbZYwGTe2dqa6MJxvtZRFENV/Z694DCDXqKlNB9ERzUafQJ5lDGo0KnQgZvNuRsIx6UC0/ePkH1jwVDr9X7m4MPnZEKCfxnjbbos8yTyWZaww6V/mDQQvCCk6Tg6WpggV1Ar08CdWgQ2ElVdgfEvQSoFiQgHRxVVt1areTzAe/mpf6FHCq1Pn9Lpx8jiTTYaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=bVcVfKhF+sR1BUGldpir2D4m53E1accrBln4821sv6If4KcDMQuf4proEE2PC/oGESfmdGdNzNswaLzoXvg4lKkHn5CvCQ9pQYIKTJcyN+DlI0PGZN9u5wXHzkzIBPJiDBhbuWuDb6zKZEjv0GkdZA/Qw2Eo4J4j7eYXHf9CqIM0d+SK+WtI8idM674bFyEN0MN1VrX57izFLfjn8RNpoAxyZ7q/E7iZ9m7iqOsPP+yx0MIadFASnY+UOsJJCmLNC3XMzKabO6w+T0LfneJz74GYayL8n1gz2fPYg5TeiQT3sUTBnDkTRGxWUUyg0sqKOccBMGGpPaGIEAEvtqrJjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=bQAPT1XmfRvtPFVCep6saJu8myxxLSIHirfnVwb0vpN9d8J2Wdf0FMpGDefbV2ULtDPXmkmJjWHxKtbyZh982i+1Tl7IVrdGzVKDaZZoShn8KgohiF3+4dFExXGR6hvtprOrcSWh8uz5LJo39QmnG4MtT1LteaBRvJJOBRrAgyA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7853.namprd04.prod.outlook.com (2603:10b6:a03:37e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 09:21:21 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8c4d:6283:7b41:ed6f%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 09:21:21 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH blktests v2 3/6] common/scsi_debug: factor out
 _setup_scsi_debug_vars
Thread-Topic: [PATCH blktests v2 3/6] common/scsi_debug: factor out
 _setup_scsi_debug_vars
Thread-Index: AQHZd2vneO1wClbnWkaSUlUirmjqe69nwQeA
Date:   Tue, 23 May 2023 09:21:21 +0000
Message-ID: <73845a64-8774-f42e-6ab5-32f6e26ab093@wdc.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
 <20230425114745.376322-4-shinichiro@fastmail.com>
In-Reply-To: <20230425114745.376322-4-shinichiro@fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7853:EE_
x-ms-office365-filtering-correlation-id: 40e8b3be-21a0-4aee-1dbf-08db5b6f12c7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nrm6BXugAhqp0ztgGV0gA7VOpBmJ25MZ++rJPJCzM/YaM45xAGKgJIpFNyp33P12emteB0Mwgtwnh/BE0sjq7An58KPIG1ulPS76gY3Q9HWKUepYbyeNp718QuReUT89ze2QhKcPwM0rA+iTpy0ajvKDvIsQtuxCRvMwUFEkSRg4Y2yUlNQtGsF53C2ItzWp+oEQ73zIdUUlJUyeiZReR3/7VeE3ySz7bPM5onXBYOtrSIYt1uX3qLOqSBpEwyoi9CxFnJMknTOt3HO5tGZcZTScLC6ShVkwV9+G14vVbpAFpUS9pjEKouC3qe4AD3Mh+1lS4P4lpgS6G0vA7Jl95dvV+5KHUr/b/+r2Jq/KS4MyK8vJKb0xv0bBBtNOwr2RXyFFpQheIqJhjaGZNHL0L3SZZNiWjz/gq4z6DJFvvhJyoT7ObuZBvfXRB4HYlKBVhPoGYlj9DEtcewL/qSWbrNsn3Rmt0mIr6HtTQXRkNOz2Ob2bMYhbnqAM0ZoXcqw9KrxVDsj0HpoCVg8yINkqFjAA2PNVZGYGTWhnmZXELbmIDaHP0F0BSoNg7n0QmcxO0okaJCjdGrqgodIzzGIEWePCWfPX1rgaJW3gJ6Dz2c/X3JW/qOucOwIxkUJU3d0KzNtFfxypFOvc2IbS48YDHLNN1YrsfyWL47UcjRg83ZarymfNNu9+iDZvTrzNIJ5c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(451199021)(8936002)(110136005)(54906003)(38100700002)(38070700005)(31686004)(122000001)(64756008)(76116006)(66946007)(66556008)(66476007)(66446008)(478600001)(86362001)(31696002)(91956017)(4326008)(316002)(558084003)(71200400001)(82960400001)(6486002)(41300700001)(2616005)(19618925003)(36756003)(186003)(2906002)(4270600006)(6512007)(6506007)(5660300002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d29QWmpwdHVKc2tsQmplWmpGYVl3WEhYRFlXYTloZlRScUNBK3RPL0FjWkpT?=
 =?utf-8?B?eVhoVGg1YW5kZ2lycThoVXF0OGR6ZHNtOEt4RlRFQ1UwYW1CUjh1RStzT3c3?=
 =?utf-8?B?ejdBWm1sU2VoM0F4YjlDbHZmTFpicFRkR3d4S1ZiWUYxd2pIRUYzcFhDNzdC?=
 =?utf-8?B?UzQxT0pFdHNLVGhVWkMyMmt4NWZuS29vU1Jzd0s1R3RKTkl1VEhxMVJaMEJI?=
 =?utf-8?B?d1BwYzVudmZHWjE2ZFgycHYxMmhzVzArMC9IRkdZcnJNV09QTUh0VHJTOHB5?=
 =?utf-8?B?NmpCWURtOHF6cUt6WGFBWlBaK0VDdnZsYmdNc3FHSGZkTlRlTHhYc2J3bnVC?=
 =?utf-8?B?NlRyRWRiSTI2S3k2REJ6UlpiaDA5dTFxeXo4TVVJNDAyWWREaUdsSzFNamQv?=
 =?utf-8?B?cURHNlJkK2dERGs3bW9adnFjVGxvWk0vZ2hHdEFqV2IvdElhNWhkbmR1VW1x?=
 =?utf-8?B?TzExOTVobmw1eXRiWWxPRU45ZWYvemtma1dTdEJSSE9rSTVHYXI5UDZKQzV4?=
 =?utf-8?B?Unp3clFYNDNBNHVadHc1NGZJaEFsSDJKczRXdGVRcEZkNEs2VjFnWFVwMml4?=
 =?utf-8?B?cVJEQlJtRTlQVG1JaGVPcThML1BURGFyazBaSlNNY3ljQjNWWm5hMmtKTkpT?=
 =?utf-8?B?QWhOQnFpa2tXb2Yrd2wyY0R0bVk2RnB4V1EwazhpREZqQ29MREVJZzZZMDFs?=
 =?utf-8?B?Sk1JTzJJSHZXbzJmVEdVSFJBYmhvMjgzRFMvNDhYSzhwK3p0VDRrUUcweTlZ?=
 =?utf-8?B?Mitya3NPTmg0VDZlKzFOajhYVDh0TGVraEYzTHduYWJiQ0EzUmh4QVcwUjJG?=
 =?utf-8?B?NXl4akhvbmlpVEFUeTF1VVlmM1ZZa1BCeDQ3anRCM2V2a1BmR1p0ZXYvZXNQ?=
 =?utf-8?B?MnZMVlRUNVhVS3VaMXh2cUpDVjZXTXZGSlBEOXRLaWhlR1BMaEEyMWpLdzR0?=
 =?utf-8?B?eGpjQmJGZXdOQnBiSHlDSE1HWFcrRkdXQzlYaEhmbkduS0JKK1ZialFMbG5q?=
 =?utf-8?B?cjJRNnpzL3hqclAwT3gwck5xTnUwTEZwaVhHL0dMeE1SejhUWTRxREdjNnYw?=
 =?utf-8?B?enFRK2x2N202WmJVSnluN2Y5a3dodXFFc3FSTjFzNEpmUU1NM1JNWkxQTkJC?=
 =?utf-8?B?Vll3UnNPVTZ4VGpqVGpjbE1MMTJXRENzNUY1VXJISzJZeFg4QU9IKzcreUVj?=
 =?utf-8?B?dW5aZHZGWXpNeCtzeVFqNmNYeVFEbWhuNTEzdG5KVmMyRUlhWUdCK3RFV3pp?=
 =?utf-8?B?ZHpZRVE5cGw1czJpNWZzUUNlUEZhVExGYVNMMEt3Q0tBNkpYMWY2NStKdmN3?=
 =?utf-8?B?WG5LeGR2dDY2d3craHBuNXFFVFZLeWIxakJVM0JwRU4vemRrVmVhMzBNaGVu?=
 =?utf-8?B?elJ6ektxRHo2Z2JHSEYvRmkyNU1DNGhRQzVoc21oQ2cxdEdmSkFnMG9MUUZ5?=
 =?utf-8?B?SUh1dzB2dFVHZjYram53OUthYUdWUjhpOU5zLzVjUUZjMitxdGp0MkxzMG1x?=
 =?utf-8?B?NFNwRFl2aGo3QWVvWUZydTcxUFg5N0d2S1hvNjE2WUpZZWRjRlBEM1puK08z?=
 =?utf-8?B?RzJSY2cyZ1RJUFZ3Rk9iYmFXcHdrZzA1VFRiVXJ6OVg1dnhwcVJOb0w5RFVD?=
 =?utf-8?B?dERVSkRwaEdsQVJqNytlaUkwVjJBTjlXRSthM20vVjdpbTZadEFJRUlYODdK?=
 =?utf-8?B?RW5HSlhyL0FMbG5teXdEQTRLdVhLM3czanhPdERZc0xYcWo4UUdJQVBERmZu?=
 =?utf-8?B?VkJVMHNQMkcvWmUzY1dBNHI5MjRBeCtvL0I3MU9xTm5QVXRoelRsVnJKVlJ4?=
 =?utf-8?B?c1h3STB1bFd2Vlcxak51aHF0NTMxWVE3ZjJ1VUNkZVVPck91Ylg1QjQ1UldP?=
 =?utf-8?B?aE1SMFBCbDdBRFhGc3FGY01kMVl5RHFyN3Qvb2tRRS80KzgrYXU1RkhjWXAz?=
 =?utf-8?B?QndidE0rb3YrWEJ3OUxWK2J5L1FhQ0xTcURSMzdRMjc3L2RVODdpUHQ5bTBx?=
 =?utf-8?B?RTdVZVZpVU41dXVYTjlmb293RVA0WU1kK1FWTGZUbzVnQTN4UUhHRkdtN1hM?=
 =?utf-8?B?bDBjRHlzNG0relZ4MEdMSUF5Qm5yNS85eDd3OWFhTEdacVhIRVJaVFRiMzY4?=
 =?utf-8?B?bTdsQWhCcmtiREpONjE1R0RvRUd0S0dVd2hORnA1NkxMVjR5bGN2SjM1WFBx?=
 =?utf-8?B?d2g1a2pIdisrOEN2c3hCQTBnaDBVUGp6Y3NRamVqajRubmZ0SlpxbHloZ2FQ?=
 =?utf-8?B?YjNWK0RKTFU2WFZwN096enU0NmJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BC2B2305FECEE499EF76F8450302710@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +YxA19Sy7Or53YL1suflAzk6OU24pSRUdIlLuwtPmUD+vRjPv5uvS20IFqT8L46/S1Ou4lr2ouNFOnV9mPtqbJZm/t/A47NsDvT5bIn6pWPNNDgS+U6HmKgDpgLp5rRs8axUBs0pcN2ZA+iBQQl7Y1wkhNFXHeoFSLksjKE5g/wVtmXM0BE1eOmIYd/qMvKm5JPj2ob67N2ET3eu5ah0bdSZlvyKToJODa84D+I8iL29zrtOMt0bszEZINLRmN+riK9HtF0xQ80gF35bu8eOUGQAH2iaC1JQrQq+SGdtUo7rACAXQl8aTLxCUMpxDGq5akKgnltMoxEAlXUo291g9STFIB7CAYg20+q43KVNqibaAfLtC2oE1IpsDNYE5nkarEo7XZFlqQqPwCV9EhNVFnGlsqzDwsP5TyJheAWffXQVlFyqAP7/X+n7tB40YZqeeg9D+NRxD1hgvglx7dbTkLd3KCKGIu11DT9GQyonvAZvXOei5hivNx/+QzJo33Ww8a30U1LWGDGi5Q1R8Nw2fTlIzOeWi9R/7oA0iVE8S9rQ7BkORNbaZhgK0FZjRn7X2Ax+6jLbUJRDVXYWluvhZlSWCdLs1W1JxmJEswJ+UAh5MMRZCj+hXiIyq8yuaKGAEGG0jkziW+mcp9zSjBeCnYF+nTAgRgpQpwMbo4T0+DBkLYQKEuvubSEAZ5VN5wTMdbWv3YKZVzuCeXG+Dejz89tIq6wlfp2T9sYf8MGsLv+QWId6n6H6hx6RbIwwLGECfpS3i74MVeWjtYKb9wlaq8sa8RwMccNGnAIJJ81xni+Kxt4iqNp1nq942tV93095H6asOi5eXqX0RpRCcOPZ1Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e8b3be-21a0-4aee-1dbf-08db5b6f12c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 09:21:21.7398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8cK17l9p6caMj9yaxzpA6JIrTQshS8t+T/u/rRA72Diz0DcqVLEjU/buiy6XH5H+uKTkKgRYFCBSQM0lxz7kylUAl/YyNiM44LaW9KhkMBA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7853
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
