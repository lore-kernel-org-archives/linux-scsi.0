Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF890C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350849AbiAaLqZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:46:25 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56231 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379045AbiAaLnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:43:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643629420; x=1675165420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=GfqFvvF8N4MQqyTVTrwsX9HVykB7zLN0SfgMVgJkEzYqE8xJ/Bz6G9Y3
   tSIIGJ3vWy5F0URuXdsh8tMfFX7kJPQPnRehKnl72MKb0XAP+74dLU1Yp
   CgvXlgQtR/fvevi1UcwW8fE/1taD1QmOZ8dFZj+f44YFSIG6Y85N7c7zp
   vClb1qXh1N1e+3HgU5hGJO/Qy1dWi0yy4AA6K+GqlBXJNMmJfKHrLV7eQ
   0tCPB+Tjjffn0SuAbpGWRohY+rcLXCzZsCa9IkA6Kwt3IT3SajJwzShaQ
   imcfDERS2dvk+pxzjh52WCt6n5tXkwmNgoHy762rsSiEIa3mFpWgfPn4r
   A==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="192790225"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:43:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPnnR1WLK2PgLHeEs8vDSmk77pt+daUJUKQzVhx3QByYtYk9qmVhWeUojKSVxLcQdHUbzV72K/6BulqW0c4SUIU+rn8z8cK9TuiihrEl+n+eWVvTeU0nWjeeKqFOgL+A7AOjflcwES+S/R3VyvmDj1V2VqYsjJoa394nkBJs8JHGNG2JB9pC30+qQLnGOlDdENJJyN4k4UzQnEs53t/rLOXSFYG2qxY9kipuM2FvHJsPJWYdeuLbSHe4BwBKGOVyC1pFDrGZ3LxH/PS2sEI11dfHrvgTuRHtE6GDbBVnxym8b5HrT6Rrz6NybiCMFqmkvkN5Gu/XB2IA0rRzEZoVQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=cfgx5x++SD5BOXGHUeBVoeli7a6qgLGJtgu6v/xZy7Vg89Nclq3DNbSJfvYF5yPak4bWEAJ2mBg8ns9GfcMJUTUK/zgUxSYGfQvtK57DRrVmcPAdqdgIYHe8hBfphS20mYNYA06Tx/NQPMD9YXoH7n883cVGJwnVQAdqfNR/SsYfDa2F9VG1ZEXsh1Pwu6liTD3CG2dUyJ3t1JgKMH+PcyucCVWxuDdyMH3G+HsGmgMHPnLOa9KBym4cgtaGQqS2d9MkHYR9O42rjlHlRziggl2esixHRaXyZgdkP3QpxBDuvVAUiee1SE/slEd9idfOc0iK7aTw43kRvKoEJmJs7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=NRUfMvwYJ38UiwN/LxjDK9ApHcFaVcJer/I5Wg+giRx/kL/Ic/Ebmv58N6bBKJEXeybstz1K4Wmp7M+9GZ5rNtNpRdoC8V8U8eDMOWuPqo750tANER3k67h7aByvZTUx9eTXNUParTsRezMiCPXSMDGBOxXxJIUw27J8w3Zdudw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN4PR0401MB3629.namprd04.prod.outlook.com (2603:10b6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:43:36 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:43:36 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 40/44] scsi: usb: Stop using the SCSI pointer
Thread-Topic: [PATCH 40/44] scsi: usb: Stop using the SCSI pointer
Thread-Index: AQHYFJWOZdxkuCr330Kjtyf3CUzUCax9BmOA
Date:   Mon, 31 Jan 2022 11:43:36 +0000
Message-ID: <a2046677a5be3258a55786b3636efc3d09d3690a.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-41-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-41-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdda9d3c-f056-4dd8-cebc-08d9e4aeeac6
x-ms-traffictypediagnostic: SN4PR0401MB3629:EE_
x-microsoft-antispam-prvs: <SN4PR0401MB3629F729BC14F379BED836F19B259@SN4PR0401MB3629.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IJJvdPTxo0id3ecgEzaN8igLBX5WaTHe7YxsOoURUoMerSXD1/ulnXiRwUjQKgoiTGehmEBjjoKup1mmlXaecnCwoXwe8w4kTYkcG/PXSUqHQ/QPE3ImEPLKGuvN3oJaQlHZVEi+CL+zcBIQHrexsFYnPeSt+N021zDaf98f4zsf4gs35SD5b3ZD07K55/5JDYMIx0hZCdtanggz6DkTLXArQWWvldjxG/jllnJAtw4/L0sIBGJv9JAVKEzjgFb+wRmtwTkKxNkPKdv4Yv8VXDZcgrklJR0/vM8vym5WNF+ynKEU1lewJxgKOYQNaCsI7ihOzEIDDiaXRJ4jwGl6VD103N2qnEModNblQlXGzYk4U1gKaZYU61UCwmM83Z3oM1aEbIju+ztTOc3GPif3E7FOa/iO+NIW4e6CijHKJnFu/Ykxd8U/gtyOU3EAUHCbShN7rgVGYXNKIW7+AeXXRyd6nI1fuhlxLxJ7mE9L3Y4tdMO5WhWRjYot9P8WNFB20JAZM11pZD+9BZL1sa+fxzsFw8wZ1cFi7C8FmAMcJ0qocH/PLy8UXy6SZBMukOB8BHkwO4c/QsJFz+YlytINGlxnHreBP+acvj+8rWoYsw6LsHTjsxmUFEBFLPldwjaxnrKfmkAU/878mJQtKU25jixIOLqKnSilFhtlJRNJb6eKFlJ+2GePq1Ei54dVFrO+7rERx1Lv49Hl82mmGDaZoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(4270600006)(6512007)(5660300002)(6506007)(2616005)(71200400001)(2906002)(26005)(186003)(19618925003)(86362001)(64756008)(66946007)(66556008)(66476007)(122000001)(66446008)(8936002)(8676002)(6486002)(4326008)(38070700005)(508600001)(54906003)(110136005)(82960400001)(316002)(38100700002)(76116006)(91956017)(558084003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rmo2VGxVdmRkTkszWDZva3Q2NHg5cEs2TzVzQk1jbFQvaXBHSTRXNU0ySlh6?=
 =?utf-8?B?S285T3k5cGxjMk5aQzFmbE4vRXJzelUzVnowVFpZTlpMQVJBdEtja1VuMG9j?=
 =?utf-8?B?NU55THJXNHFOcTAzOFJvOXpPZWZWcU9JQVR4NlRxeldiV1lmWnB0akFzbFJq?=
 =?utf-8?B?UFlNRVJuU2VtMDV6WmI0RXpOZlRGVW0zMklYQUg4TVBEQXQ4M0d0aE1ySXdw?=
 =?utf-8?B?czBPM1pmMk5TRzlxQko5MklrSXNmaS9kQUd1SDZmMnBvNXRJZUZQSnBSbERX?=
 =?utf-8?B?QXhXN1dWMk1ZSXBObW5BMklZZnpFRFJ2MExrNHVOSGUrRk5TZEF1NHF4dHJo?=
 =?utf-8?B?V3RDbC9ndVlOd0MyRFk0dDRZU3NsU29UTVVTUUlOSTYramRnL0hkbC83K0tK?=
 =?utf-8?B?OHM0aHZ2bmVuUnRjWCtSUUJHMlRqK3pTWW83Um5XYWdoQ1puc05WSWEwK01o?=
 =?utf-8?B?MVVBblpyUWxySVR3cmlhdDVpNHEwN21FQlBTQ09YYTBTVFV3QSs1RS9BSFZL?=
 =?utf-8?B?akU1RndpckdtRGJIalFrVnpYS25lRDhZYWZxSllDbStuK3QvMjh1TFdyNkpz?=
 =?utf-8?B?d2FNWHRUYURoMXRsVDZkdW4vVFZSMjZBNjRicGJNNnZTeHhpeTZEVjRmeHF0?=
 =?utf-8?B?d3pPTGdqcDh2RFMranc4VTJ1NmJzc09OYWJJajdsVlg4OHJ5TVRIcERoQzBQ?=
 =?utf-8?B?Zzg3cFpHUzk2SE9NWDZCazJjOEg2SnptR3dUcTcrQW45ZWlPTmRXanQ2Tmp0?=
 =?utf-8?B?RjI1UXJKM0I4eDcrb0E5TXdMRHh4RUh5alU4QThmL2x0SGxvOXBhNTRNZDRp?=
 =?utf-8?B?ZkdMVWNKSGJ1bmE2QzRGWHNIYW14ZWozSWovSnNSTkF2VEN1SzgzdG5YK3Rk?=
 =?utf-8?B?eXczQzNDYTRSbEg1L3EyVnZ6NkVkUkdMUkRBNURDd3ExV3NEeWdFRjdUckNV?=
 =?utf-8?B?ai85OGI5RnQ5VUxvSVBJNURpcUd1eTh3QjYxNlBFMDVkWHR6ZEpnaDcvYzFE?=
 =?utf-8?B?TGZOeDVHRHBXNTcyMzBBcGRwQy9WbXlBR004anRvUVRvQ0ZOc2lXQkhESDZ1?=
 =?utf-8?B?U0U0Q0RraW1Uek5lQ2h4dFlJT08zRmxQVWdHSEhSSnllZjhXa2NsanByNnJL?=
 =?utf-8?B?cWo5NXFpTDJLRFVzb0IwUUtDNXAzby95YmJvcC9xeTlOaFhIeDVyb3VCbEpr?=
 =?utf-8?B?eUNnajBCdEhyQ2htS2Z6ZGZLRjNPRjFPNHp1SkI1QW55a1pXYXROVStuZDlP?=
 =?utf-8?B?ZnYwTjVRL2NWanRWM1B5SkRHOEU4ajA1USs4Qm9QNVRuSzFpUjYybFpZMmJq?=
 =?utf-8?B?OWpXODBJS1dWdTR5bitwUHhpc0tOT0gyWDE3d0w2RU52ODVVQm1pcUVsd1ND?=
 =?utf-8?B?anlqY2tQUS9Ec1l1SzFTYm1kdVBmU0dxOEZUNFhXR1o3YmxqaEJ1bHM1bVpa?=
 =?utf-8?B?aUpZUWVxN25CVi9MZXJ4VVltSk9EWEoxcDJhdnNlbDZ2SjZXZDhBYW5TckhL?=
 =?utf-8?B?eTloZ2FqcG5wSkdvRE9WaE1aSXQ3ZDNKUndMSmVBUGtiNkhiZEFpTWVabDhr?=
 =?utf-8?B?a3lqMnZhc3ZKeUJzNlc5NFJEbWxoL01tN2JTcGVtQ3k0OE9OaGJjWFlCZTdP?=
 =?utf-8?B?RVVmc1BxTzA1UHB0aERiZGNYSFZiZ09haXl0YXh1S1VsQjJSZW1TV1NLb1Nh?=
 =?utf-8?B?V0dnMDRqM3NxbG03dktlTVNENjl0VmZ4RXI1ellsb2ZZZDlmT2U3d3pORFY1?=
 =?utf-8?B?N29lKys5bnUzZURrS0ZUT3pQZVc2WEZkVmg4RXpGMmRVZnpIMm9QTlVnN2Mw?=
 =?utf-8?B?bmEyS1ZjUGV3Wk1GLzZJY3VCWmRZZmxtcDhHUm1JZ0kxTWxmWHFzczRlOU8z?=
 =?utf-8?B?UWN2SUlNeldaSnZTUTZIa1ZOZWNPZUd0b3dxMk5CbjdFYlVUK3pSLzhHRHlj?=
 =?utf-8?B?YTlaSnhpRWl3REdsY0pBQUJJTm81SDB5YlU2djFSY1pnbVp0aDFaZW90eXo5?=
 =?utf-8?B?NmFKOXAzLytJeXk1L1hXRnJicURBRXRWMkxRVmVtQ3I4NjJKd0dBbHdEMFlU?=
 =?utf-8?B?aWJoUjFBOGVWeUhZTjlMTXAxL2dRNW94TWJuQTJuZ0NtSUo2U2JnRFhKUVRp?=
 =?utf-8?B?NWhjWXNLRFFVRllKS2VDRkNmUWprUjNmeFpOa3hSNmEzdnQ3eXhVbTB3OFVL?=
 =?utf-8?B?L0ZWVU9vNlMwL1liZGxCaTNNbFdVWHBhNDhLVDk0Kzkrcmg1L1NvVkR3akJN?=
 =?utf-8?Q?1nWGTJAQ1G9996fSzDiTM4Fb9yhdaKQ6X5N1arzXto=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA8AE03FE902A64DA72B5714D68DBE3B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdda9d3c-f056-4dd8-cebc-08d9e4aeeac6
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:43:36.2881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2LbJbBxsQTOtWnNfRoBqKcSXX/ubmXtfbYtQjyy0OBVHR8RKNKDYnbj72gWaDj3ohfDq5PNGeOQGxmZDvQ287DxgmjJeqI8vrsvbSx5Z8PQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3629
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
