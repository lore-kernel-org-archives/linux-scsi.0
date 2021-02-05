Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CB8C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 08:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B7964F9E
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 08:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhBEISs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 03:18:48 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59202 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhBEISb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 03:18:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612514188; x=1644050188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=270XHXRUHscnnm7MbZFxZcej5tUda/akwpNsLVZzbik=;
  b=LCuVGrHVMrCxSl4GiGbd2C9cFKyg8cfWMgJ8N7tLZ5FXe522S3k73GIH
   FB6heIqToFIqWETbXOJKEaLHSC+a4m/f5KiLd0U9yoUlzU8zR6kK85XjF
   6My4mjBGXfprlutiBZ6vtNBqFQEesH3HBBzPx0ctzOVnlg+55aqT0c8yD
   Kf8eU5RTd+tdS0Ykq2/d75ohOEopkfr48jS0CF4F1D99b79zbpyoOINsw
   gR4X1LekREAy/IKhz5gKH4zcDd7tG0tv9rWQWG0dlUl1lel+huQmv7Td4
   Al8VcO+9H5aZne15mQ6OhwHiFCzBVhX1MIZGuXdMi5JW4Iik1kgWtnZTa
   Q==;
IronPort-SDR: XnNIWhMjrT1nNr2dziq6lkRMcBUEJBQON3yu0Zf4Rgc1g7dFFZiQZ1OhrOFK8HKyQdwJ6YcGbN
 jiyvtGcA+mUkZk/M2MbaOZJATVZalvYIoqiCdCPAArhftbc+YgVNR/MlJ2KBmPfxu/czNu2TcG
 lyfffUWtP64eAJpabzeAC+0doIGMHKN2XoNMJ9+PwQg9YfJccS/7UbyB73SHD3tcMafkX5fyJe
 XXivwsDXJT5oj7VMEDyKoAL5WQ8NcYuxgtw2iEhaNVL3mQiA7uxiVjSKEud6ZM8hD0eI3AGtv1
 7Og=
X-IronPort-AV: E=Sophos;i="5.81,154,1610380800"; 
   d="scan'208";a="263319025"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 16:34:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLNFyTBEUcD8i/T2NcH8ydwmeD+dOpsjBrOSwxc9TCo1Ky2YXYMMftpjfZdPBtlY8vCuIt+JGE6+CnGngbF8P6bfW9hPfw7d3XJ6Yw7ahJ+sSVtwsCZSFhgyfb1m7LbDu0YvCvdqrLp3sWYYRw5x+xeA4E3L4RK+3ImRuRwbEH59QlOERBNMJbYmf7ixLSQy2UZnQK06yiCZDD8uUxyjrdyhswGzX8WpNvZoQzPJklrMXDVR8mfVpaADHPXRzWc9NGkgaVtM7KdfXoQaMJnTw0cbONyGP0E2EmTGLTf6J582F7MGX40XQnHxv8lolCPN/+TTJWbTxxZkKtkxS1Tjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=270XHXRUHscnnm7MbZFxZcej5tUda/akwpNsLVZzbik=;
 b=AejcZweh56NkF0x5OudG3ubhDcvv8ipohXkQRka2QWSlRAen/ZDY+WJMYLOuyi6x6QY01gr+IRwGAwr4nYfFvbOCcuWCVHCkhq8BccAniYgAHpocwI4Rj7n4aD/ruloYal7KeON5nt2CtxOy/NkmEtVM+yz/nR2ESIWWmB0m18uUm1zx1Oe/rGtrDHkmlqkCBdDbMUTfsVuXBuFSyvR9h4aslZ7rm7esb9OIsliFTlFoxf30fWkOzLnAs9KIcViB0HCKCjWU2or14PX5Jq6hyOk0D6p8b6d7q4ACCp+D4+I2qZk2g2fOh+2lmn839YrPCzLu1dt2lWEgzjguQ3wifw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=270XHXRUHscnnm7MbZFxZcej5tUda/akwpNsLVZzbik=;
 b=sTDdLW99OXlqEtz6HaEjwNXJNzZDHiZXh3i+3OWXpM7r5+nrvJxJZc/+urgI4gKrGWLS4akaLs9qZHjZsRXz88fTVPCRdYRxV1DdmUs8d8mMkBvSrX0AfEymWRHt9wFvPgR8XzlRjXTdjfwyXVIR6q2RJqNY+746uIFSi085cnk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1261.namprd04.prod.outlook.com (2603:10b6:4:3f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.17; Fri, 5 Feb 2021 08:17:13 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Fri, 5 Feb 2021
 08:17:13 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     DooHyun Hwang <dh0421.hwang@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "satyat@google.com" <satyat@google.com>
CC:     "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "jt77.jang@samsung.com" <jt77.jang@samsung.com>,
        "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
        "jangsub.yi@samsung.com" <jangsub.yi@samsung.com>,
        "sh043.lee@samsung.com" <sh043.lee@samsung.com>,
        "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
        "sh8267.baek@samsung.com" <sh8267.baek@samsung.com>,
        "wkon.kim@samsung.com" <wkon.kim@samsung.com>
Subject: RE: [PATCH] scsi: ufs: print the counter of each event history
Thread-Topic: [PATCH] scsi: ufs: print the counter of each event history
Thread-Index: AQHW+hdAOBbwovC8rUKIHUCd9fyF8qpJOfdw
Date:   Fri, 5 Feb 2021 08:17:13 +0000
Message-ID: <DM6PR04MB6575691082B0379B9B238B4EFCB29@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210203102752epcas1p16713d977a1a679cf641894144d8f299d@epcas1p1.samsung.com>
 <20210203101443.28934-1-dh0421.hwang@samsung.com>
In-Reply-To: <20210203101443.28934-1-dh0421.hwang@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 386167f8-89f1-4982-58e7-08d8c9ae7174
x-ms-traffictypediagnostic: DM5PR04MB1261:
x-microsoft-antispam-prvs: <DM5PR04MB1261E20DB5E5C68676BB1A93FCB29@DM5PR04MB1261.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2ylcIeBat00dQQBEwR9+iSHH5vbBIDbHw5MLNVZpvHlJkE2CAZK0jM+QkCGhwxE/MMKPhY7UOUq+so5II6LXgkuPDs9O6ZYZFce+cZMEvHZKx1IErWdAqudvx7txaerNbPOvo1yV0gaDeRmw8mRByOrn3loZKEaVZUDEyjOMlmgsEIw2045zT31gb8M9Yf9uACBkOmqD7vLyoSVKIEuesVoMgdgw7wcS/LpJGFbgNMUSz6ehJTkCBCH28/Wl6wkS/h/S3k3KQxiysE5ZPoWFnU6KvQD5nlohMtMi6fPhl9ScU7h8/4TweBhvXll5KHAfWgTBYR5TP/UHQugt+xOqD+Ufkw+04DJljoNjwF8oG426ODA2bkpOj+HsMLenHa/RezAw4uByRaDAipzrKLozsJJ7KTNc+0i6H0XJzgZW3GGXn8bxTszTc2uQVYKDIErH766zxVX19fn0VvE/raZcVODFayCSoJxk6kMa95hfJPP/yx8lfPpFqmtGa5r92wK/UE401jlgcy8JNl2AxeK11gnFaH6nFEyNyIXFvMr0BdWfOoAe5UhqOgQydNVGzZj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(316002)(7416002)(64756008)(71200400001)(33656002)(52536014)(4326008)(2906002)(8936002)(9686003)(83380400001)(110136005)(7696005)(55016002)(26005)(66946007)(86362001)(6506007)(66476007)(186003)(558084003)(8676002)(478600001)(66446008)(66556008)(54906003)(921005)(76116006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bWdrSVBidmZBeXVxUkFEMjVPRlJCdnNDa2ZQK2Y2cGZWQnI2TmxNTStkWTl4?=
 =?utf-8?B?NkJTNHBXUGpSVEZ5a0FDeEMvcUEzZTB5b2NSMXFqV2Y1Q0FkTEQwZmdCamFY?=
 =?utf-8?B?UWEraTh1a1Y2U3I2S0U1aEhOdUdlV0xEM2ZYaGsycXBXcWxuRGU3ZlZCNy96?=
 =?utf-8?B?cHJTL3BjT0hJT0oxL2c2U3pzSmtKcFp6NE9KeVVhT2xVVy9tdGlmSUFNeTJv?=
 =?utf-8?B?STEvb1ppR0NnOUtjRVZMVHlxZVg2WW1LRytnNkEwa3l5djJxT1RaRnJHcWNt?=
 =?utf-8?B?M01La3pPM3lRRVNBREdlTkcxUElYMUtCTmxOeW1yc1pOWllNZlhpRm1GcUwy?=
 =?utf-8?B?c21UelZxVUxxQnJTa21CamtrR05NdkRFeUZhWDBCcWZXaVUvRjRmcXRaQXps?=
 =?utf-8?B?MXh3Zm5Zb1IwS0FPL25WVXNLWndkWmNheEozak5NU1IweHp5UWladGJqR2Jm?=
 =?utf-8?B?TlBNbEhwelB0ZTVhZ2YxRFk4Z0x6NmFLMWd6cUQrNk1yRllrQnJBTHhSalBW?=
 =?utf-8?B?eXo2Z3Z2QW1YTUFOT2ozdWk0SkhBYlVyU1JBUmMwbDNXSW9uVFRMR0dDSzhi?=
 =?utf-8?B?RXl3Z0lPZ1cxNmVONFBjR0dIdWlQdWNxV0x6dncxSE51OHMvWGpFM2VJOE9x?=
 =?utf-8?B?bjRGV0xqTVd3UDRiWGhVM1g3bk9UNGpjZDlZWFEvUjlERTNFd0RWenFlb1V5?=
 =?utf-8?B?eDIybGRxK2NtRGl5UDVMeEk1dytoM2tIS29reUltT1VDSEdBeU03aUxrWDdT?=
 =?utf-8?B?OE11cy9zYkVtbjZsSU9PSUVRcXVYMEVnMDEycm16bjJYYjA1d0hYOTZCaDM2?=
 =?utf-8?B?L3pUVXlWdXZrTEp6SE91RUlra0VmUWplZzVybmhITjZLdHltWkt6aVR4OHRU?=
 =?utf-8?B?NkRuNUxFb09xaVJWMncrazV6R1B3cUJQakxNRjViMkxaaUFXZUpUSEphamM0?=
 =?utf-8?B?Vlh4MThKRjlyaXRqcnZoMWp0OFRYcjNaRWxCUnJXSFlhMkpkaDZ0TWhHdzlO?=
 =?utf-8?B?M29rRU5qWm0xVEtSWjM5d05rcXdUWDdmQTQvU3ZqYXMvdFJOdjVMSk9OQ002?=
 =?utf-8?B?YXlCV1gzOW80WG5XTjQzb1IrWVRGUUtadjl3S3o1L041VGQ4MFBoZUJRMEhi?=
 =?utf-8?B?VEY1WWw0UTdtMlJZLzdlb0o4Zm1KalRXSDJIMDhSWE1RNG94eisydGRYc0Zq?=
 =?utf-8?B?S0M4cVo2a1gyT0ZqUGlvQVUzd2tnTVBKMnpkU0s5NGtPSHRTVGpvRjZ0MmRF?=
 =?utf-8?B?N2NrRXYxVmN0N0kxSC9HbTdPY1dWUHI3Z05MUFA2dThDeG1FQU5qU1dFekxO?=
 =?utf-8?B?K0hDWnZLUlkxbXZHaE9VYjhHd2JyekcySjZwYm1pcXAvaFR4TkpveGRZdWZ4?=
 =?utf-8?B?emxGOTE3ZURTUC8rVzZROGNVS1ExM2krY3BxbmNSdmpXbmhydGsxOWFDMlpQ?=
 =?utf-8?B?VXZjaHlIN21WRHRqY3kvV2l4TFljUmN4YVg0RzFRWUMyS0dac2R4c0M2cSt1?=
 =?utf-8?B?d1VoL3d4bHNlQzNMNFpQUkdkRzlNR2Nib2tqSVNET3RRZkpNY3lyWnhNUGZI?=
 =?utf-8?B?TE1VYnlZRVhIaVVIWUJDd0pSY0pEZys2QThzSlFBQzJrN1pFYUpYWmFVSmlk?=
 =?utf-8?B?c0x3YVA1RjAwblA3SEFYRGhUMi9jeEp2TytJRGpVd0p5bjdpblVLS05zUFc2?=
 =?utf-8?B?UUh3SEpiVzA1b1FpMzZYeng0VG4xYTNZWm42ZEJxT0pnMnJDMUxCbWFBNExl?=
 =?utf-8?Q?HG+JXQxOFS7svrMKQO9nPTIjPg2+PhaRQAQVOEa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386167f8-89f1-4982-58e7-08d8c9ae7174
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 08:17:13.6703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UZ2h+ctGYge070+9zMxSdm0NccEn+PD6zppLWHVIaWB8d7U0xYM3gmY/KNNXDOxVMcaowOaA4fGzZj4/KnJs0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1261
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gDQo+IFNpbmNlIG9ubHkgcHJpbnQgdGhlIHJlY29yZGVkIGV2ZW50IGhpc3RvcnkgbGlz
dCwNCj4gYWRkIHRvIHByaW50IHRoZSBjb3VudGVyIHZhbHVlLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogRG9vSHl1biBId2FuZyA8ZGgwNDIxLmh3YW5nQHNhbXN1bmcuY29tPg0KUmV2aWV3ZWQtYnk6
IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KDQpCdHcsIFlvdSBoYXZlIHRoZSBj
b3VudGVyIG5vdyBpbiB1ZnMtZGVidWdmcyBhcyB3ZWxsLg0KDQpUaGFua3MsDQpBdnJpDQo=
