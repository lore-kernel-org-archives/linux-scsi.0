Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B67BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jan 2022 12:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbiAKMkS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:40:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:41787 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiAKMkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jan 2022 07:40:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641904817; x=1673440817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZAGYc3iM3MCehqkjKnCR9gzdnAnsFfcR4jD9i2vOlo8=;
  b=PVkkz33760S+t6sbYFSBGIU3sFyf1PPEHvYX/2CMie/I47iA/LZvcq31
   luQoJPA2cd6W3oQePAVnBvyOJqGXwIZ+XirLuOS9XeyTxhfDSfYst8NsI
   v9qB+LpvGsU/DNR8iYWH9DQYov0BLP1jvy/UiCiOQ5LrjlrrD3TlG32ul
   Kw1D0wUp6O31vDv9Zc8SWvR6lIJS7JOATVt/o2BTnq3KvP47Lh6U3gID6
   KJpv6kSuH+UpTV7GtfyF03B60MMDa8l+mqySz4KI2RqLZF0lirvjDoRlf
   bUl96GLh9VSxrOcbq58NqGNAjc+6HBKhUZKZp8quH1t1k79kNovcaxqja
   Q==;
IronPort-SDR: httd+Mo4TCjV+pGq1oEPM+a0VYvuophG/QcS8gNQnqzXIm4x7dNRXLFQoqha0mvCaege7Yftty
 DMD3PMiWj9E6NoF1Vrht0QFRW0Lglfrl7N/0/Fj8EEv0l8e1+2hnBPNVu2zx8jIzcqtgm6glZz
 3sJvyxkxy1wU606ijYeRaBnMogGKkb5ehYte+Vx6M6qD3rmgxTVCO5LVPWx3hLTfISV7ORvNrz
 l18Dn//Slcx5m3oDmrNB2g2vmhe6Z1XAeyvFyjIpL9RQVw4TUvGCiejljpJk9cXDQuNO1fp2TS
 pUGaSpJ1EAYmcb1vo9+cKm64
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="82114040"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2022 05:40:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 11 Jan 2022 05:40:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 11 Jan 2022 05:40:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCQMNQ3eUY8RBcZEaRzc223YL83f6pIQM+QPASRgksTbHsjbVHgPzUuI6RPaZdlNZrI3zBVmll/78cVdd8o70PT2m0stK01KxFSSlELzv55b6kaHdXPm3+axUdnLu+ucPOpV6LgUBLnoRfz5WJFMFAeFsUzdMXdOye6VS4AvRDY2ojrGEK7rY1bvwu0KqGZqSrlPgKNYKa912b6AtLOkfldAKFojOdXZH3I1sWqrDUORWUzzv/uhT8sWS/ltAEu4GdAjOQ5uKqA1vCncemqVSLoCkdt/iUSa8aekCHm4LEO2Z8ZWthqGg9+FAXXkp/805rLPMLYdCwajjfrSCvLSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAGYc3iM3MCehqkjKnCR9gzdnAnsFfcR4jD9i2vOlo8=;
 b=B4rf3GmFMa5N1U6rM80xAaln3JfoEVofmizu3Bod+95e0BQ+5uom5rwsRl6cY8pBUmz7M32Jl0orptzVK9kMsdlK6Z8aPi/eFrAVKlbOMSLT5O1xask69yU6e4FoqFTREIyPm//7s/taUplIooR4ewztFvp/S4cSRHCRMbO2IuxDVycbZvYKHi9SNq3v+ousH8pHHD2ze7UwhTuTX+J0Snb4GNOelWY4LMFsof0KwoxwjtMWEKJL3xpqb8LAMK9nvSre+GjxcELnc8CS9xip12gNmiXJb30IWHrq7HbvQW5jIG8tCK1q5p7qCOetYntFDLdK86G0x6ryCGxJDr47Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAGYc3iM3MCehqkjKnCR9gzdnAnsFfcR4jD9i2vOlo8=;
 b=O29/58GkgpvwfqfQ1zei/kmUJ1wJWl1bpq0tj+IkTt/WnAtNNTmOhWba0CqH9bwOLh1SGCi1VC7cIArkJfMaWkqwa/ZZLFlzMK/ACEOdvztB0xtVqMUXllp9D853UCf6vHxJXv8+VAQZnsoSgeIfDqaVuQCIgqAmyfzgfVAkzI8=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by BYAPR11MB2678.namprd11.prod.outlook.com (2603:10b6:a02:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Tue, 11 Jan
 2022 12:40:15 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0%4]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 12:40:14 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <john.garry@huawei.com>, <jinpu.wang@ionos.com>,
        <Viswas.G@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <vishakhavc@google.com>,
        <ipylypiv@google.com>, <Ruksar.devadi@microchip.com>,
        <damien.lemoal@opensource.wdc.com>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>
Subject: RE: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Topic: [issue report] pm8001 issues (was driver crashes with IOMMU
 enabled)
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tCAD+byAIABQ17ggAVR6YCAAQpd0A==
Date:   Tue, 11 Jan 2022 12:40:14 +0000
Message-ID: <PH0PR11MB511238B8FF7B44C375DDDFADEC519@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
 <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
 <0cc0c435-b4f2-9c76-258d-865ba50a29dd@huawei.com>
 <PH0PR11MB5112F2D4A506B0FE6DC5B01BEC4D9@PH0PR11MB5112.namprd11.prod.outlook.com>
 <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
In-Reply-To: <34319d65-104d-55a0-175d-96cf3f0aea89@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87cb3c21-8abf-4e5d-b82c-08d9d4ff840d
x-ms-traffictypediagnostic: BYAPR11MB2678:EE_
x-microsoft-antispam-prvs: <BYAPR11MB26789AB202818456FCD91285EC519@BYAPR11MB2678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NRgOVtxDTcZXUxPEnY0rXaod9YOvN0tIdQ1RBDk//UjUZyNYzcIS1vkZcY9bwom6OzZ6qwW9f/xTcGPRBH0XkQBcaSUtQg/NziJm7/zIW43s6hncivmXKhOKS4Z25206XSPPBuUTu9NGD5Jod0Wr1qobM1H7V5EN+aF8dzxnuinFj8oCf/TXrr5pC0EdtUzWHs2CNQPU2iC6qeWD8Q6HKSlQrH7v0I9J5qtuMBUHuPbIP4bz4T/K3kcU5sU+IgraPLO4oLA97KNGu3/NMJBincKXWB5HMC7HPDeFo5CW/qTwl4Ho8ucvjJPtDebAfMISji+c5uFK2aOTZcUQnxBfGg1f6oI8G9CAiEuzCPyPz568cs8EUhhzm3MBXZ0ks7ro32CaVYzg5+Cd6tXV8EFQrjRWF05MdD+HMTZ3FEl4INtjpGZSA4Jr1rV8oX6Xp9B/Th12KMt4Tpdd2DCYFjAHF9DmWtT+nQ7+5e5rLWxKuWHlI7pWU4p9zvjT4LUDa9c2aKohalJlmyuqW7gBA11QbwHukshdh2LLLlP1VxyWtBw0E1NWDjkIDKdhAK9ARdb2nIbMUC9vT4DKPJrKer6OsxS3OICGPcshje35+c9H7A1PxL21SF8AnJnSrIVrlf15DuVl64WxQ2ZT8mr0w/7acySm6ezorCFymm/F16IgFWP9vuLHCrz+lCFUqqpmQVlvqLD8EWCmwLaHdpKHz8lxCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(110136005)(6506007)(4326008)(186003)(122000001)(83380400001)(55016003)(71200400001)(38100700002)(508600001)(7696005)(38070700005)(76116006)(66446008)(64756008)(54906003)(8676002)(8936002)(5660300002)(52536014)(2906002)(107886003)(86362001)(66946007)(66476007)(66556008)(33656002)(9686003)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDhMRCtSOTl1N2V5ZmUzcHIyb0x5OTVPbzJreFduNVpMZlR0cjI0RVRqc09w?=
 =?utf-8?B?UXd0RkVTTzUyNEp5Nk9FdHBkL1UwamZvWHpDK0s1SVVBRmRNL3Z0OHhiVGJt?=
 =?utf-8?B?T3Erc3FENFdSeHJYZ2ZEZUNoTVpJY0I5aStzeTlUekROUHE0WENmamkzdjZa?=
 =?utf-8?B?QVNuR2JIL3c0Z2Q5Y0h4RkF2VHhiNU5idXRQbi9WSlpsMS9PTEMrMmhIaVB2?=
 =?utf-8?B?eWhJa1VhMFJmak5nZVdTT3grTW02WGQ5bU54MUkySWxnVHNjMEhtZk13enBv?=
 =?utf-8?B?aEFnOXVJRTNWd2t2SUR1KytOdGxTcXRJN2ZKRFZoWXU4VkpieGcxTkw4L0ZV?=
 =?utf-8?B?RjFoVHlsZHZvem1pWCs5Ny9LdUlNK2ZTZlRFYnk1LzRlNjVDd0t6b3NaVjZj?=
 =?utf-8?B?VjlOTEJhQ2FtWGJVM21FTW40QXJuaW5pZE1GUVVlZUV3aXR3UW5CbGdYWmJJ?=
 =?utf-8?B?UlNKcjBHUGYwdGhpYkROdW94Ti9remN0REZWaWlvODlUS041UEJhN2IrcTNK?=
 =?utf-8?B?UDBjMTNUU0c1ei9TQjBBd3Z3Y1cvT0lnYWY3U3V2dXduZFVZZDR4Q25Id2hk?=
 =?utf-8?B?Slg4YU9LaEdUdTRGQzEzbDZMV3lsVE1EZkY4ZXZWbWtJd3lhaytnaWM0Zllw?=
 =?utf-8?B?NVM1QlZJbW9Wa2FiTTA0WnRNeVEzajA1eVM2QzFKeFczc0RlWXh4dmU1VUdp?=
 =?utf-8?B?TW91K1dZZVpzM0oyQjkzWjBIUGRHY0RocXV1MVR2RXJHaGdKWU8wS3FheEVK?=
 =?utf-8?B?ZVo0REExL1AvcE9rZG5LbmlFT0VlUitMcERod041Zzl3K004T0U0dlVHU3V3?=
 =?utf-8?B?czdBdUtZc29uaFFCdHlxSlB2c0tZcVFkelZmVTF6U2kyclVSc1dvNUdlOUlP?=
 =?utf-8?B?Uy9zZnBUcGV0UWxiS1puTXBEZ2FGaHYydHBUeEN0REk1ZU1qWFUvb3l0dndo?=
 =?utf-8?B?eFlpM011VTdidkxzbWJpcmNsSHJnVEJkYkVoK1JURzRtYnlHNUdKVk1EQ1RD?=
 =?utf-8?B?emg4N21zVzRtbkNkM0JCN3dualFyK1VtM0ZsdFNkWTlpRUJRaHlLNy9qbU8r?=
 =?utf-8?B?UmNOVWJGQXoyOGN5Z24zL2tZUFVwNXFWZjhmUGpzRllQeVBjeDQ1V1ZTb29y?=
 =?utf-8?B?UGh5QnBqclVOekZnSFM5czRSTEg4Rm9VQWRyQTlQTCtjckJRRDhRQzJ4RnhJ?=
 =?utf-8?B?aEJPaUxBNDFSU3FTRVhNVDJEZGkyYWdTMlR6TXhmR0dIT2FRaWk0QXk3ZWk1?=
 =?utf-8?B?MXFyMFZjd1pwMWFXSDF4Nk02SEhYVVdzQ0k5UDkwUm45Wm4rUE5mUzEzMzg2?=
 =?utf-8?B?eGVGTk9SNjBWc1U5U20xMzdyOUdienltNW1qUXhkbTNELzhjSGVtc2Vsdnhk?=
 =?utf-8?B?M3gyRjlxNmFUakFxblQxUUUvNExmUWFReGVDZkJzbE1LK1VGV0lVWVE1cUpB?=
 =?utf-8?B?azFMR2VKUnJUTFp2a296M25UNWs1YUpHcGJUMCs3bGFaemFUUFFwck15Vjhk?=
 =?utf-8?B?UEFISXd3Zzl1SGM5bi9hR251R3psNnRlMzdTVGhEeWdPaU44WkJGdzRFZ2Rq?=
 =?utf-8?B?clY2RzlpYmFYRzVvbHZMeURWOUpmV1RKT3hsbExzMHI1bEVXUDB1OUtDUTZN?=
 =?utf-8?B?SnJTa2FsZUlsSm5lcW1vRnFmc0JwRm5PakFvTHpiK21BN1BYNWozV09yUndR?=
 =?utf-8?B?QWhGNlRUVmZ5NU1wMXRwTEQvaTN4MUlMMzhtOS9lZGNXZEhWd0xkdzVPbGdQ?=
 =?utf-8?B?WGxGaDhzWHhmWlNheHNnajRXdHhQYjRZR0pWckVJQ3dIYXVVMno5ZzFjYi96?=
 =?utf-8?B?OFIvdzBKY3hreWhGSnJtb3c3M0h2cGpjR01TK0E0NzJ3dUVJeDRqS1laR3JS?=
 =?utf-8?B?bnJENEhyWVlwa0ZXTGpLdlRZYnRZVzlqUTNsdDhtUHdPZ1BYbWRiUWlqVlVC?=
 =?utf-8?B?cHhYa3dsMmt6RFJ4QThnSlZIUzFJVlFMRTd6ZUtvTTRBU3Q1NVJCZjRUQmdB?=
 =?utf-8?B?OFd4SEYya1RrYXhXenphaGlrck4yM0lQdnlKa3ROMGlGS2pXNUlwSjMyaVNy?=
 =?utf-8?B?NkhSZzJnY3FYem5PeHJ1YWRKTE9kQzlmUmdBblR4U3RJc2hKZSs1b0FsZEc4?=
 =?utf-8?B?bGRrYnBNQjQ4OE5ORGFwcHFvQ3BOekphU3VRbktKZHFTeFgwMmhOTDN4WW14?=
 =?utf-8?B?bkJHNEVDNC9QbkJKcS9LNkVwMi9JMGt2YTh2MW5VNU9raVJFNW80cXpwa3BK?=
 =?utf-8?B?U2lvQVdacXJoS3FKZjBISlR4cHB3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cb3c21-8abf-4e5d-b82c-08d9d4ff840d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 12:40:14.5064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0+/cqx8tqn41FvJ2gRdudCuFWxmWjcxyHtS50xXPnpoVoWaMgFHsdf/ThsdikPwR5b2zRLObpacc8xCQvcs/12zrTxocBVzxZkBm3VP4Co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2678
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCg0KPiA+PiBPbmNlIHRoZSB0YXNrIGlzIGRpc3BhdGNoZWQgdG8gSFcgYXQgKioq
KiwgaXQgaXMgY29tcGxldGVkIGFzeW5jLCBpLmUuDQo+ID4+IGl0IG1heSBiZSBjb21wbGV0ZWQg
YW5kIGZyZWVkIGF0IGFueSBwb2ludCwgZXZlbiBiZWZvcmUgdGhlIGRpc3BhdGNoDQo+ID4+IGZ1
bmN0aW9uIHJldHVybnMuIFNvIGl0IGlzIGlsbGVnYWwgdG8gdG91Y2ggdGhlIHRhc2sgYXQgdGhp
cyBwb2ludA0KPiA+PiBhbmQgdGhlIHRhc2sgc3RhdGUgbXVzdCBiZSB1cGRhdGVkIGJlZm9yZSBm
aW5hbCBkaXNwYXRjaCB0byB0aGUgSFcuDQo+ID4+IElmIHlvdSBlbmFibGUgS0FTQU4geW91IHdp
bGwgcHJvYiBzZWUgaXQgeWVsbCBsaWtlIEkgc2F3Lg0KPiA+Pg0KPiA+IEkgdG9vIGhhdmUgc2lt
aWxhciB0aG91Z2h0IGhlcmUuIEFmdGVyIGRpc3BhdGNoIHRvIEhXLCBubyBwb2ludCB0bw0KPiA+
IHRvdWNoIHRoZSB0YXNrIHN0YXRlLiBCdXQgc2luY2UgdGhlIGNvZGUgaXMgaW4gSU8gcGF0aCwg
bWF5IG5lZWQgZnVydGhlcg0KPiB0ZXN0aW5nLg0KPiA+DQo+IA0KPiBIaSwNCj4gDQo+IEhhdmUg
eW91IG1hZGUgYW55IHByb2dyZXNzIG9uIHRoZSBoYW5nIHdoaWNoIEkgc2VlIG9uIG15IGFybTY0
IHN5c3RlbT8NCg0KTm90IHBsYW5uZWQgZm9yIEFSTSBzZXJ2ZXIuDQoNCj4gDQo+IEkgdGhpbmsg
dGhhdCB5b3Ugc2FpZCB0aGF0IHlvdSBjYW4gYWxzbyBzZWUgaXQgb24gYW4gYXJtNjQgc3lzdGVt
IC0gd291bGQgdGhhdA0KPiBiZSB3aXRoIGEgc2ltaWxhciBjYXJkIHRvIG1pbmU/IEkgdGhpbmsg
bWluZSBpcyA4MDA4LzkNCg0KVGhhdCB3YXMgc2ltaWxhciBjYXJkIGkuZS4gODA3Ni4NCg0KPiAN
Cj4gSSBoYXZlIHRlc3RlZCBzb21lIG9sZGVyIGtlcm5lbHMgYW5kIHY0LjExIHNlZW1zIG11Y2gg
YmV0dGVyLg0KPiANCj4gVGhhbmtzLA0KPiBKb2huDQoNCkp1c3QgdG8gZ2V0IG1vcmUgY2xhcmlm
aWNhdGlvbiwgaW4gdGhlIHNhbWUgdGhyZWFkIA0KZm9sbG93aW5nIGlzc3VlcyB3ZXJlIG1lbnRp
b25lZC4gUmlnaHQgbm93DQpJIGFtIG9uIHg4NiBzZXJ2ZXIuIERvbid0IGhhdmUgODAwOC84MDA5
IGNvbnRyb2xsZXINCndpdGggbWUgaGVyZS4gDQpJc3N1ZXM6DQoxLiBEcml2ZXIgY3Jhc2hlcyB3
aGVuIElPTU1VIGlzIGVuYWJsZWQuIFBhdGNoIGFscmVhZHkNCnN1Ym1pdHRlZC4NCiAgIC0gSXNz
dWUgd2FzIHNlZW4gb24geDg2IHNlcnZlciB0b28uDQoyLiBPYnNlcnZlZCB0cmlnZ2VyaW5nIG9m
IHNjc2kgZXJyb3IgaGFuZGxlciBvbg0KICAgQVJNIHNlcnZlci4NCiAgIC0gSXNzdWUgbm90IG9i
c2VydmVkIG9uIHg4NiBzZXJ2ZXINCjMuIG1heGNwdXM9MSBvbiBjb21tYW5kbGluZSBjcmFzaGVz
IGR1cmluZyBib290dXAuIA0KICAgSXNzdWUgd2l0aCA4MDA4LzgwMDkgY29udHJvbGxlci4gUGF0
Y2ggY3JlYXRlZC4NCiAgIC0gSXNzdWUgaW1wYWN0cyB4ODYgdG9vIGJhc2VkIG9uIHRoZSBjb2Rl
Lg0KNC4gIkkgaGF2ZSBmb3VuZCBhbm90aGVyIGlzc3VlLiBUaGVyZSBpcyBhIHBvdGVudGlhbA0K
ICAgdXNlLWFmdGVyLWZyZWUgaW4gcG04MDAxX3Rhc2tfZXhlYygpOiIsIHdoZXJlIHdlDQogICBt
b2RpZnkgdGFzayBzdGF0ZSBwb3N0IHRhc2sgZGlzcGF0Y2ggdG8gaGFyZHdhcmUNCiAgIC0gR2Vu
ZXJpYyBjb2RlLiBJbXBhY3Qgb24gYWxsIHBsYXRmb3JtIHg4NiBhbmQgQVJNLg0KICAgDQpMZXQg
dXMga25vdyBpZiBhbnkgb3RoZXIgaXNzdWUgbWlzc2VkIG91dCB0bw0KbWVudGlvbiBoZXJlIG9y
IGlzc3VlcyB0aGF0IGltcGFjdHMgeDg2IHRvby4NCg0KVGhhbmtzLA0KQWppc2gNCg==
