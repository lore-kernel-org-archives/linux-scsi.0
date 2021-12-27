Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA7E4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Dec 2021 13:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbhL0N1G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Dec 2021 08:27:06 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:25002 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbhL0N1F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2021 08:27:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640611625; x=1672147625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UDNbpmEW5mJpX9sCqumMZJhsNTwaskgM3rOKaQzJ3z4=;
  b=Rf95b4H7oszBxZm7wRpWmuCyEDTui1KOwncQhrxf+xkVtP8Bz4G6R4ss
   TVYQzRWi9upKlNWS00qw1sOnjnkRYDmNXFr7mCqliyMre7r9JBVuugtuM
   9hAcBia2jHQ7SiZqNS4IG3bkTwhpDABm5ungOJPcZV8ttLfnjkCQXjWyz
   hbBKX/Kkuik/DxEAseV1Vxi3mAlr+wvRcUi06SJa0Xx+uU75JMYb8rO5i
   a9QhfalXxA04q+mO/Kg81XKW4lMTfrLgKYh6589j+GZb+m1tpQaMMd2MV
   vlX1WMy8Wp/qK/Z26Chhis3y6coZWlcscCDh0UGvKNdZXyHwUBLO/VoKp
   Q==;
IronPort-SDR: ZTGZvbLhJDRVoLObWw9Z2Xn0Y+CLaSe3iVA3Y+c3xjxjuK1MKJu1iaKwa7N1QTLXmomQ4uNe2W
 42b6V4BbPxSgJTE0YGE38NQeGc9wLfkFZKHmq2AZGstZd6NXvT3ea5r74PgdWH/eyzH4k8/0uG
 cAuheRBMXYuhtI/na9eoXwy/Z36jJkdEzEYRoQBDBpBSgaWFRCMVXiNOvuHcM4Fi+geAEmZGm7
 2BueJU2+v0TJDUXdKXt4IYCpiF7kPUbneLYYd61AVQWjryqJQ0SETLE8+2GZd1wE2ydLv+ns6b
 n+H/KYDkH3itQoLa6/tsNneM
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="148440924"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Dec 2021 06:27:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Dec 2021 06:27:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 27 Dec 2021 06:27:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXfa4vO2bEurUI6XP2nkNMrB1A56ZZbYBYiOXZl/FzY2H3NpId+2Q4Pp/7mhodLVyknL9yqCaS8L/hRzTfVkifiw6Qn6wRIJIi6gjySPxQghmCGr7XlajOkfCZlG7+zx21wcgcxZpkoyM6nHQHYj59/eF7fD33UbiYaJnLu58iWC0Hu+InXvHWEeXuSxkwZbwKe+WSzqUK3bCFe9frObPFUAUd996FFJGLdrnClYT5bIDM9/Rgx1xtTfUfTNwh8h0MsB+zMSMeRsJTHK4tWClcV84vAdoYdUO2PuzTA5+J9OJG7g9PlDBjqP6/X8DudO/i/ZnMlY5Ope4gKtU3zo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDNbpmEW5mJpX9sCqumMZJhsNTwaskgM3rOKaQzJ3z4=;
 b=IWBP6ptwawtJ9pOYaTCc017aj4s8GNshzC7xwuJxSFgAC0Q/Um9Sdi/bF0BLKZkFukBnit0rYOEw17i47i8Fk54ukI/Hqpe5knQ2oHQXr4FlHyQZaoG9oU0mih+ye6eXlOhya7ju5wex/H/yCSpsiWNqNDzijbV17QDdPBJutPrKYX7WW1dwOkE6Mzbwks+g97ktX2YXUFoqD9vaRydmEDycZxAtdC7MnUdzzi2/Id4Jq2Ifyu8jVNwgeqIlwaMXrK290BwURh3iNEfxgagUhWC5RxT2tT+1dG8/sxgq1jVywow2ybrJ4b2+XscnD7ZJuSK/gRtOfAu1usc98S7fSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDNbpmEW5mJpX9sCqumMZJhsNTwaskgM3rOKaQzJ3z4=;
 b=PAmvb9/styKVksh0nCZ41yf7ZyCeW5YUCoRBOPL7vjLA4zJKSNFcOQDqqFDBmJrp6InY7KEq/2Q6f8jQg4AET7n9WsKICs0Pi19l0Z1wpks+sQUE0rsb4YuNuxA7eljcoH22xcHolwjfN8E1XbZuQhPpsgJDOI1CM7TTEbCbfsk=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by PH0PR11MB4982.namprd11.prod.outlook.com (2603:10b6:510:37::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Mon, 27 Dec
 2021 13:27:00 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::ec81:740d:c5cf:5ad0%5]) with mapi id 15.20.4823.023; Mon, 27 Dec 2021
 13:27:00 +0000
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
Thread-Index: AQHX+KUJaMkhjLzSFEiHPF663Zk+AqxBieQAgATH0tA=
Date:   Mon, 27 Dec 2021 13:26:59 +0000
Message-ID: <PH0PR11MB5112EBE80F9A4AD199866CA7EC429@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <894f766f-74b7-62b1-f6d2-82ac85b6478f@huawei.com>
 <CAMGffEkvrAxhrsL=azkVzQHHyDczZwJ3uiNWydSA6o2K+Xh_Jw@mail.gmail.com>
 <00505633-c8c0-8213-8909-482bf43661cd@huawei.com>
 <1cc92b2d-3670-7843-d68a-06fe68521d24@huawei.com>
 <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
In-Reply-To: <fd0eafc6-9443-fe5e-2c2f-91d6bbe8b174@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b841582-28e4-48ac-0be3-08d9c93c900d
x-ms-traffictypediagnostic: PH0PR11MB4982:EE_
x-microsoft-antispam-prvs: <PH0PR11MB4982244C1AB0C169216715E3EC429@PH0PR11MB4982.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UgBDkLYsj96EeL/BCqE7CRVTT3LdI8FN4P5kydsgkRmCUjb7H97lJiJ5lnh6KZp6A1iKRKZwhXF4/b9zMqBLKgGRqwB8ynXzp8h529ALI4bpUUSs+ywoYmjXfiiik66sTOnGd6B9khO0pYqGaNjq4K7Z41K4nGFx4iEBBsOFTDIZz6KjxM0yfZy7Uvc+hdyusIGavgysZpriSaXoic8xc62jf9yR6KFMbqaBBMG6vaDyxXBeoNT90ciivHlRinQml+tdLDkRIeUoEHW6EPmzXR6XdhbvwGKuDvksqP94NLysR7ABaW6aexryU0GBsIDd4b3CQ14GXI4wZ0LcDIHd1n/6Y+S4U+1oCkH8+MhWHBColvEizvzl9Pr5yQVHIpGC4ZOOZ7pCUXFQe79sHBb3TACnyq9GW9/gKWLNRwODaHqkEoEjaGmDHEtMhfSHJkJ0/vm0zFA0vJTNrjb/rJ5FGvnR/FHeC1o0RrNucmXhmDKyfwTqeGlKyRE2hyKRStWtF3Xu8l38lrUh8cxG9aPTwK6tz29tBNBDQzjoOX3W/H/0YAMU1CqEmImsgeZ1Kd5kadVnKf0EvN7PUwKxmWciNR/esDy6uayloHWw/DuEA1sq64rp2OWInsAPCk4n7ttkisp4g0KhO6h1DS1ubqpmgDbZQUabtwLVPmQd/OKBjI8exPpkArrL1xJEX1QFtVXErohX3cBiIB9mRN2vNI8xCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6636002)(55016003)(52536014)(38070700005)(186003)(110136005)(38100700002)(71200400001)(8936002)(316002)(8676002)(53546011)(54906003)(2906002)(26005)(76116006)(64756008)(66946007)(66446008)(66556008)(7696005)(4326008)(508600001)(6506007)(83380400001)(66476007)(5660300002)(33656002)(107886003)(9686003)(122000001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Vm8yampCcElmZlJ3SUZ5c3A2cFFZNThKZHY3NmkwY0VaVGJ5cTlRbFFtb2lN?=
 =?utf-8?B?OWNLTUszTE5UU2krZGN1NGQ3eENmeW5Xa2RZaEdsVXhmLy9KMXV1NTRnOWlY?=
 =?utf-8?B?UC9Va1pSMUlLeG12ZStjUmZYMUFBd3VBbmVxdU51NmRndmQyNVhrekc2NVpT?=
 =?utf-8?B?MWtDVTRJS0RQUXF0YUxua0hKVUFrZWwvN3QzSHk3WUZlR3YrSW0wZkxVdVRs?=
 =?utf-8?B?Vno2OEZDMDdkSGtvcGNIVWZWTExMVEZteHZPdjlJVkhoRWJ0Mk1wSGo3NDQx?=
 =?utf-8?B?VkNTSEFVeVhvTGM0ZW00WjBtUU5NZytCUHhNNjcwY0dJMWFOdHVrcDFtSm1t?=
 =?utf-8?B?WGtnVU40NkM2QkcvUyszN3NCRDlKVkFJdjNXcHEwM0lVTzd0SXZlUjZibURL?=
 =?utf-8?B?ekNxZFUwem5CK2JnMEJIbTZEV1k4cktiUVNtMDVLMTcrWnY3UklaTmdHRkdZ?=
 =?utf-8?B?Umd0TC92VFBjbVNzYk5jOUJWcGRsb2xPeDZCYUFycDlCOFdhc0plVEZyQmY4?=
 =?utf-8?B?eThKL0lST2NuTit2WXYvNXRxWlc3dGhCUi83UFFNendPWXV6QnBIWXh4K05G?=
 =?utf-8?B?WEtjS0NGVzV3YU1WNXp5NzlEb2Z1RzdzVVk2VmxjMjRrdGFscmwwWHZUdzcr?=
 =?utf-8?B?dW5nNXJTTGNFT3RjNVY3MVlPcGtTTzkvejNWRmFheW5lUUExMTVYUFJOYTRj?=
 =?utf-8?B?bWR0bS85QWdMdnhBbTgyRFptVWRMeVRIeUtZWHMwdXU3WkVzcjE3TU0vY1Nh?=
 =?utf-8?B?SW14akZTd1JYVUJUUFB2cWduWHFUdWI5SjFqeGlTbmF6ZmNuN2kyYTNmcU5q?=
 =?utf-8?B?Umo1YVNnZUIyTWRSajErVytQZWNibGVRV0RQRlJoRXhXeCtsV0xpa1VYQ1Iz?=
 =?utf-8?B?TjNSSzZJdHAwcVNWRDQyWEhWOXlHV0ZpRm9pbHYzVmZzVnJRODB3YmZuOFIz?=
 =?utf-8?B?bjdyR0ZuSndBdUE2cCtwWGszWlJpRzdhbHd0eWNYUUErdlYvQ29DTHRldEF3?=
 =?utf-8?B?bkdBVW1FMTIxczhOZ3FmMzZ6UnJuT2FTM1pUd3VKNW10Q1Q5eTRaQ1FCMXA1?=
 =?utf-8?B?SEJiSVo5NWFrWVBzTTRyWlA2TGxEa2FmSTFKc09HQlNNMWNJRzl5eUFPSFZk?=
 =?utf-8?B?K2FyVkRJbnk3N3prb0lSTUtQT0l0eE1vek1wbGFxRDFlb1l4eGtobS9GYjhB?=
 =?utf-8?B?T1JibmRkdlJ5QjJDTnZ1STQ1djhsNk54R0hWSUFqQzI1K0VpOWRFVVd2WDBm?=
 =?utf-8?B?VVZBa3ZWNlBZRGNFSUIwcHZZMWFOSDduWlFVNnVpd3hacHNodU95V3BVVVhu?=
 =?utf-8?B?eWo4RzBsTURQczV4WjR1R2h2dWJxeVZ5aU9BWjRVN2pKdGpYU1lLSWtwSUVx?=
 =?utf-8?B?VDhNU2dQZ2hJUEdZVmpQY3JCR0g1YVRZTk12cW0yQ2xzcWltalFXZlMrZjBz?=
 =?utf-8?B?NXQ3VXdMRjNkUFpKdmc4Q1M1ZU9zSGRjMlNJZm1BaDVwN082ZGJjaHpVNkEy?=
 =?utf-8?B?RUY1S3R5bjNzTWtDSCtZTEl1SllXUjhZL01xRU1CWEtBbnZWWDB5NW5yOWti?=
 =?utf-8?B?U0x6YWRBRDUyRUpwVnl0ZUZRTTZRN0FlU01lamxBMHYrSis2Rjdqc05nK3FH?=
 =?utf-8?B?L01aU29kT0ZCdENrdGtHVytyWDVIdTNQM0hGbGZDdWt3MXZmWEk5YU9PeGpj?=
 =?utf-8?B?U0dtV3JWQ0luSHRKczJyU2hHTWdnYTVxZjBVdG0xSUxTTG5reUpOS05iZjhh?=
 =?utf-8?B?YkE2UHhjS21RenZ4TlJqdXU3cTJBNU5uMkNGQXdUajZyVXpCZjN0WnF4K0Zo?=
 =?utf-8?B?TVNQWUFKbTRYZ3hyVnoyTkdDLys4a09YZ3JzbElhSlhsSGlISnNIMEVjRkhM?=
 =?utf-8?B?VW1RdE5QM1FWajZJdGJnQzdEVlUzcDlqR1ZWOWRHVTRHL255UG52Z1lMZG0r?=
 =?utf-8?B?czRzdTVYbGJ1aHo5ODZWQTBIQ2doSG9EM2dzSWZJUkdsNUZMWEhtZytOcHRV?=
 =?utf-8?B?Uk80SkVyb3dnckFiR3dMLzNERmNaNWtkR0N6V3NvZkw5K0xDQ1Q2SzJ6S2hO?=
 =?utf-8?B?Z2Z0R0kzNThiUzhwYmhCVkwrbWY4YjcrV2REQmI1Yi8wOVU3TjkweElCa2dl?=
 =?utf-8?B?WUdUK1JIQUxVS2duTXVTSk50a2JHbXNHMGtFdk5aOXBQQWVHTVFrVllnSk9w?=
 =?utf-8?B?OFJQQVlaODRXMjZPSmZpRUpSdjNhak50c1FkUVp6K1NseHNrS01WTWgwMVE5?=
 =?utf-8?B?Qm5iMldaSGY1Zm5ldzJKeld6QkhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b841582-28e4-48ac-0be3-08d9c93c900d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2021 13:27:00.0057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iu1P38DyOQe4TEnlWN1LrKpEzhM9U4soUprO0AwDtaeOKegJKnKHJjft/c/PeC61g50KIni0pPWyTMJ/neV4CBPFm4d6ILP/kHUGTBwW5Vk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4982
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgSm9obiwNCg0KUmVnYXJkaW5nIG1heGNwdXM9MSBpc3N1ZSwgd2lsbCBjaGVjayBhbmQgdHJ5
IHRvIHJlcHJvZHVjZSB0aGUNCnNhbWUgb24geDg2IHNlcnZlci4NCg0KQW5kIGZvciBBUk0gaXNz
dWVzLCBuZWVkIHRvIGNoZWNrIGludGVybmFsbHkgYXMgaXQgd2FzIG5ldmVyDQp0ZXN0ZWQgZm9y
IHRoZSBzYW1lLg0KDQpUaGFua3MsDQpBamlzaA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KRnJvbTogSm9obiBHYXJyeSA8am9obi5nYXJyeUBodWF3ZWkuY29tPiANClNlbnQ6IEZyaWRh
eSwgRGVjZW1iZXIgMjQsIDIwMjEgMDU6MjkgUE0NClRvOiBKaW5wdSBXYW5nIDxqaW5wdS53YW5n
QGlvbm9zLmNvbT47IFZpc3dhcyBHIC0gSTMwNjY3IDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPjsg
QWppc2ggS29zaHkgLSBJMzA5MjMgPEFqaXNoLktvc2h5QG1pY3JvY2hpcC5jb20+DQpDYzogbGlu
dXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7IHZpc2hha2hhdmNAZ29vZ2xlLmNvbTsgaXB5bHlwaXZA
Z29vZ2xlLmNvbTsgUnVrc2FyLmRldmFkaUBtaWNyb2NoaXAuY29tOyBEYW1pZW4gTGUgTW9hbCA8
ZGFtaWVuLmxlbW9hbEBvcGVuc291cmNlLndkYy5jb20+DQpTdWJqZWN0OiBSZTogW2lzc3VlIHJl
cG9ydF0gcG04MDAxIGlzc3VlcyAod2FzIGRyaXZlciBjcmFzaGVzIHdpdGggSU9NTVUgZW5hYmxl
ZCkNCg0KRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQoNCk9uIDI0LzEyLzIwMjEg
MDk6MDIsIEpvaG4gR2Fycnkgd3JvdGU6DQo+ICsgc29tZSByZWNlbnQgY29udHJpYnV0b3JzDQo+
DQo+IEhpIG1pY3JvY2hpcCBndXlzLA0KPg0KPiBEbyB5b3UgaGF2ZSBhbnkgaWRlYSBvbiB0aGUg
Mnggb3V0c3RhbmRpbmcgaXNzdWVzIEkgcmVwb3J0ZWQgZm9yIHRoZQ0KPiBwbTgwMDEgZHJpdmVy
Og0KPiBhLiBteSBhcm0gc3lzdGVtIGdvZXMgaW50byBhIGNvbnRpbnVvdXMgY3ljbGUgb2YgU0NT
SSBlcnJvciBoYW5kbGluZyANCj4gZm9yIHRoaXMgc2NzaSBob3N0IGIuIG1heGNwdXM9MSBvbiBj
b21tYW5kbGluZSBjcmFzaGVzIGR1cmluZyBib290dXAgDQo+IG9uIG15IGFybSBzeXN0ZW0gLSBJ
IGFzc3VtZSB0aGF0IHg4NiBpcyBzYW1lIGFsc28NCg0KY29tbWl0IDA1YzZjMDI5YTQ0ZCAoInNj
c2k6IHBtODB4eDogSW5jcmVhc2UgbnVtYmVyIG9mIHN1cHBvcnRlZCBxdWV1ZXMNCiIpIGxvb2tz
IHRvIGNhdXNlIHRoaXMgaXNzdWUuDQoNClByb2JsZW0gYS4gc3RpbGwgZXhpc3RzIHByaW9yIHRv
IHRoaXMuDQoNClRoYW5rcywNCkpvaG4NCg==
