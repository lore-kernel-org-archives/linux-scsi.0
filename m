Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6ADC07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 21:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B39161878
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 21:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhGHVU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 17:20:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:27066 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhGHVU5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 17:20:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625779094; x=1657315094;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CPlE9XEtZUM6FOGm1D0BhNgf/n4z4+R6/W72/AmNqJk=;
  b=dQic+Ad8oJhG0Qqu8YOJ+Cwk0x4BeJXCm+S1RvnLVMvD6f47fCrirIse
   9UEDeaSqE5SMomOnoGFw/xtbpBIyy+AzAoMcOhmtVhnblxSTsmBPOxWTk
   cL9xNu033uQFvpauNWwOQ/OR9Ioh9pmk6L3bsXDxPaebdnhch8RrWXiMO
   B43Ll63fi4d/DivfTBOU3PYRIRDElUJITvA6KvHRqjy8bXewnJ81e1VeL
   c0q4enTK9sLzBb84BwIH14n3/hOScFubJnltnb7Zck9h7hF+lX+bxHAqk
   Pi2q9KGQgyx86iq+qwK6ZGbqwiWh1x7XymkVBDIE2AVyIqkmkczpzZf1r
   Q==;
IronPort-SDR: q0kPMWffG/KK9eDhrpv5IRUe0cPOY/gRQA7FIqKr0Htcozn6ZJWamdhf2fod1oDoKDEjpovCDI
 TtlTLqp5sBIMAA8M1c6eWqkLX1Eflsx9/40ChatGRLCfMG4QuiHJJC/w1JQIwQ6/GK7lks9iIl
 p3yK0vx17rugTkXjbBcYQUqSWI0NDZ3D9btKmoSSllgi8l5Hh7jksbdhOv/ZcM7tC26X1F3SJu
 WxiPDmvs8yS26qK5WezNO5WMJKlDSeRtWPXo0sKeFbdQPUQDPDPNLXgMjmRYKCNTUUBkdIuVEo
 6mA=
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="121428190"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2021 14:18:14 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 8 Jul 2021 14:17:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 8 Jul 2021 14:17:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhWJcxw5V1kqT06EH9vYVpsQNDRWHwD5QA8x5/JveG4elJXTX8UjbPdJFerij5NQziSYv00c2r6U+eS5KFlgCc/YYYGKWAf/cpu8GR/Udv9/XTCra3KXi64+dgv75m6i4p2VcEADh9BTfxcAXHO6pLFqELZZhv+nEzvsS+0co/5Aso8/61HXhIl6+dJvlRFTsaYQyS0hYOic5TB6JHevyC37tyCQp1/zkHBsZMMKANREGMnyzAKM4lklU4+0pBuev5SY41qO3SL4/yDcx/2tJ/HXHfeVUW5Is+f5le9QA1zDS+63TNbKRGVB/4ioJCPnpCb2Y3nr08FkS8n7i1mYOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPlE9XEtZUM6FOGm1D0BhNgf/n4z4+R6/W72/AmNqJk=;
 b=DiHZevWSev3JohhijmPKK1/r0rdUOl8Z5TAJA4hhh0RNM2FKvUSdVEOb1I1M/eQ6ItAxVx/vHsj2jB4uGKoWx1ic60WLJ1kmfSd8/ygGhe5FF9AE2ADAj0ctRtP3usSuVElqdi6YuKS/0TFbooWZBVATtqzkPdP257xXYAGmMzHBLS6buBytWb1TmI6M4WdYwU5e1/HLg99itvI1lg7k+WiG6Z5rq9Muw29IqbyY8pXlGGlARrq6pnwi3JR1g0QBp3iHtt1RADwkTy8cnFEyuVL4GDGwZ1je+1sb567XXITVzjBhM9Qv19OgzDIRpGhIebF+Jj+Lw1tcC/6GDRpL4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPlE9XEtZUM6FOGm1D0BhNgf/n4z4+R6/W72/AmNqJk=;
 b=iXTO90CdFsmPeHKru9DUHEH78NdooRk8vp8pNp/iJ6ZhCpyXYxfB35GrgHzMohhsuShUCRE0m9AqUvTPL7YrpEVkizCn4Hp8yEFUy7qBFuAUE0c7gFvjjKealiRq8Z/Y6Xf59T89vNud7mwRtQxffTxYRNbOIsQIJ+GXJevPPao=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB5195.namprd11.prod.outlook.com (2603:10b6:806:11a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 21:17:53 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::e0af:535:1998:c7ac%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 21:17:53 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <Mike.McGowen@microchip.com>
CC:     <Kevin.Barnett@microchip.com>, <Scott.Teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <Scott.Benesh@microchip.com>,
        <Gerry.Morong@microchip.com>, <Mahesh.Rajashekhara@microchip.com>,
        <Murthy.Bhat@microchip.com>, <Balsundar.P@microchip.com>,
        <joseph.szczypek@hpe.com>, <jeff@canonical.com>,
        <POSWALD@suse.com>, <john.p.donnelly@oracle.com>,
        <mwilck@suse.com>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: RE: [smartpqi updates PATCH 8/9] smartpqi: fix isr accessing null
 structure member
Thread-Topic: [smartpqi updates PATCH 8/9] smartpqi: fix isr accessing null
 structure member
Thread-Index: AQHXcwR19cOb1mBLfUaIuK6YIkbO1as5le5A
Date:   Thu, 8 Jul 2021 21:17:53 +0000
Message-ID: <SN6PR11MB284815D78832CA5B5E4EA701E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-9-don.brace@microchip.com>
 <fa3b5d5a-fdd3-48c7-b8d5-1a732b09bf68@molgen.mpg.de>
In-Reply-To: <fa3b5d5a-fdd3-48c7-b8d5-1a732b09bf68@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 677f40e5-3cf0-42bf-bf50-08d94255d950
x-ms-traffictypediagnostic: SA2PR11MB5195:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5195BDA43B0AA55B021EE20BE1199@SA2PR11MB5195.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TuDsm7+V/jxb6EMwZxWvhTM+CTDHkt7me/ktgpA83EX+iZPo1+8Pip/Wr8I9zNKMMd0DFbpumaMF5ApRsK4f8uLx/FoJ78TvOjzGaWLaakB7zGkedL/Mp8u+9ynZ7m0qHOUdlRey3Io2kwd3Xyp1SPqI5rJJNIcXtPp1JpuLeEsSLnWLojSwWKgpk/tBxNGDmOsBA5Oq0Z6DW1w5pfNv/WtdiQPnHYEQxE8VbsfW3vHhVaAF7WI5e+0y0z/sPPfXyxDOZs6looq9ql4Iac818ojwmP03cMfVIm7zZYj0a4BVGbkTIcSwJxaIoqh2ko9huUjMUbGVeQt/RdUwE97bVsQtl/QAlXo+oh8n/IYYsOyvyGqIM8J1+DLZeMf1cCEkSF3f+2D8ySv7URihsLh7JiRGYhRABjQggehCxpzwPs+pAyT3ILwqT8907eHJ+kRehHz1tZYuCVt4V2d3+/WJbQusLjol/2l8fgJoH1zL8Rc4LVapJWRPuevtfz9AI0wpgX5jgjDW4pmmz7ZNFuInczhjm4Aqki8exPIN+TbF9tNiRe36QaJuSV81RuE0LHkNmwNKW9fx9eMElNFxbJ4avTwN4bLLRO8/nP+u8dBtiETwmTRcDLoUkdUAnZ2UX9slxXV3fAvYxztAeDQP08LWPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(122000001)(5660300002)(8936002)(8676002)(52536014)(76116006)(66946007)(6506007)(2906002)(66556008)(66476007)(64756008)(316002)(66446008)(7696005)(83380400001)(6636002)(55016002)(38100700002)(4744005)(54906003)(15650500001)(86362001)(71200400001)(33656002)(478600001)(26005)(7416002)(110136005)(9686003)(186003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzY1c1hnK0UvRk1xdmxmYUNNMXRWNnJiazhMNEE4RG5EM3FQcjgwVktBWEJr?=
 =?utf-8?B?MUdyNmxSWlN4dlgrTE40ZWJUMVFSUXVsRUl5b2RvR05HS2hoY0RIMCthVS9r?=
 =?utf-8?B?Zjk4aVlZMmlvTlZxTy9RUEttdXZqQ0lEcUNHZ0R3anpYcTFuY2ZmRmJJL2Zm?=
 =?utf-8?B?TisxYkZXbTFMQVZ5Z0FtOHpIK3NKS0J4Wk5BalRDdEpvS3dkNDlRNWtlaHBh?=
 =?utf-8?B?aUo3VUhqMGhMZnZ2ZmU2N1JWN3g4a3V2b3R2M083YjFrYkdjbXJvRVd2a3pJ?=
 =?utf-8?B?YXZEYWIxNXRhaVc5cDNQbWYzUmVhRzFCN1hIOStQRjZXVC85d0MwT0pJYmVw?=
 =?utf-8?B?Y0ZhbE1qeGoxcmNuLzJXd2hkckhReVRSWEFwR0dJRnhZVTZXRUhydzlaTnBN?=
 =?utf-8?B?bC8wMVZuckdTdzZwcER0Wnc5VHA3enExVzNJWnd6L1FYQW8wNzF5eGx4QUJI?=
 =?utf-8?B?b1dNeXR4cmF4RGt4cHBzdGNGakFaNXpTdWQ0MzRTYUF3aUs2dFYyVGxPRkZa?=
 =?utf-8?B?Y1ZWdytzNngrWWUvNFRWNjZINGFNRmc4TDRueG1udUZqeUt4TVQydzZibjNC?=
 =?utf-8?B?SThuZnBaTHI3c1NST3JnL3BBTmVsc0VhMmhHcElhNlpYamZlWTk5V0RzMWp5?=
 =?utf-8?B?T2JxTXUyb3g2V29nWFhKeXUrQjZrN3Z0eU5GbzJsZCtad1E0cFplYlJLaGl1?=
 =?utf-8?B?Nkt6eCtYeUpYdmxMcU0zQWU3UFhPVHZsNXI3eXBndHdwSnJVcWZzZGNrVXRM?=
 =?utf-8?B?aEdNSzhCKzAvTVhnRDBtYjZKNk8rWDRrZ1VKdkNPOGgwYVlyZHpTdllnaWts?=
 =?utf-8?B?ektxem9UVHZWY294SXNURnhtMVdONy9LWVNIblNuZndUZXFjOVdvZkJkZzMv?=
 =?utf-8?B?QWpYSFV4QWNYQVYwbHFNQjRRd0JnNS9JVVhacXVFNkkzNG9CTWJNUTRsc2ps?=
 =?utf-8?B?TVhCYkdSU3UrbE9RbHNQbHRoRVV6STFtT3NEeTVvVVNLc3B1TkZOY3Zjbkk3?=
 =?utf-8?B?dHRvbk1OZ1RhRWVEM25kNnduWHlGdytNZHVaVGV1NVpyQzRnU0tzTy9vQWFJ?=
 =?utf-8?B?a3VKbE5jVzhaSnNvM1pPUVdzR2VqZkVseXF0MlZya0tnQjYyNWhBWXJDRDdJ?=
 =?utf-8?B?ajJHZXphOUFDdldzZ3o0cHNZM1I0Kzk2aWlpZS9MLzFxRExkRFdMM0dZbEtw?=
 =?utf-8?B?UzZKVHpGbHJDSHc3dWVNK21EZ2RTdEc2aU5JVkxkTy9YNmovQllPbTF3S1Ur?=
 =?utf-8?B?ZmRjVjNVaTFLRStvaGthUTdyUiszZENVcXJybkQxcHd1NVUzeVpERTFXdWRI?=
 =?utf-8?B?d0xlaSt4Q2pmci9yVXlRZDVNbkxUdkJjSmI5Nlk2NzBOOCs0Wi91WGxDbU5L?=
 =?utf-8?B?bzZtcHkyVGlZR1ZPUHMyU1RCVklvd0t0ZmdtUnY4SnBtaWl6TDZJQjFrWGlv?=
 =?utf-8?B?Z0R6L0w2bFIzUEltYXdLWGQ4OHhzUlJqZUpJRURWMHBzQy8xdWlLZTVVdkhU?=
 =?utf-8?B?TnFyMnZldjhxUXIvUVBNdDkyaXEzQWFIVlRYdHo3WjhEa2NScmppcVg3aThD?=
 =?utf-8?B?WGdNRHVTNnQ5eWpJTjVtalBIanoreUYrS3ZNVzB1ZnRTN3hzZW9oUEZObjZu?=
 =?utf-8?B?Mng3YUVMMzJjbE9ubmpkV21RRjBoQ29pbG1tTTNGcUFzUFR2THVqSm1IZlJX?=
 =?utf-8?B?bW5Yam05WHE3bXpqNkxtSHdPRTZJQ21vZ2ZMblRDdGlZVkdoamlLNFpvVkRO?=
 =?utf-8?Q?I8jRAQZZMAl1I3UCeXmWem/j/rpS+TdAuhVnFyt?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 677f40e5-3cf0-42bf-bf50-08d94255d950
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 21:17:53.3697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B03yRiUh84bcSRMpQYujcshXTS6Br9H8GtMkQLEKYsW+rfHQalcCvh83+2WC+K23r8dtlK4OgCkTyF2Q3DFSxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5195
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RnJvbTogUGF1bCBNZW56ZWwgW21haWx0bzpwbWVuemVsQG1vbGdlbi5tcGcuZGVdIA0KU3ViamVj
dDogUmU6IFtzbWFydHBxaSB1cGRhdGVzIFBBVENIIDgvOV0gc21hcnRwcWk6IGZpeCBpc3IgYWNj
ZXNzaW5nIG51bGwgc3RydWN0dXJlIG1lbWJlcg0KDQpEZWFyIERvbiwgZGVhciBNaWtlLA0KDQoN
CkFtIDA2LjA3LjIxIHVtIDIwOjE2IHNjaHJpZWIgRG9uIEJyYWNlOg0KPiBGcm9tOiBNaWtlIE1j
R293ZW4gPG1pa2UubWNnb3dlbkBtaWNyb2NoaXAuY29tPg0KPg0KPiBDb3JyZWN0IGRyaXZlcidz
IElTUiBhY2Nlc3NpbmcgYSBkYXRhIHN0cnVjdHVyZSBtZW1iZXIgdGhhdCBoYXMgbm90IA0KPiBi
ZWVuIGZ1bGx5IGluaXRpYWxpemVkIGR1cmluZyBkcml2ZXIgaW5pdC4NCg0KRG9lcyB0aGF0IGNy
YXNoIHRoZSBMaW51eCBrZXJuZWw/DQpEb246IA0KTm8uIEkgdXBkYXRlZCB0aGUgdGl0bGUgYW5k
IGRlc2NyaXB0aW9uIHRvIHJlZmxlY3QgdGhpcy4gSXQgcmVzdWx0ZWQgaW4gc29tZSBicmllZiBh
Y2Nlc3MgdG8gdW5pbml0aWFsaXplZCBtZW1iZXJzLg0KVGhpcyB3YXMgZm91bmQgZHVyaW5nIHNv
bWUgaW50ZXJuYWwgdGVzdGluZywgbm8gYnVncyB3ZXJlIGV2ZXIgZmlsZWQgZm9yIHRoaXMgY2hh
bmdlLg0KIA0KVGhhbmtzIGZvciB5b3VyIHJldmlldy4NCg0KPiAgICAtIFRoZSBwcWkgcXVldWUg
Z3JvdXBzIGNhbiBiZSBudWxsIHdoZW4gYW4gaW50ZXJydXB0IGZpcmVzLg0KDQpJZiBpdCBmaXhl
cyBhIGNyYXNoKD8pLCBwbGVhc2UgYWRkIGEgRml4ZXM6IHRhZyBzbyBpdCBjYW4gYmUgYmFja3Bv
cnRlZCB0byB0aGUgc3RhYmxlIHNlcmllcy4NCg0KDQoNCktpbmQgcmVnYXJkcywNCg0KUGF1bA0K
