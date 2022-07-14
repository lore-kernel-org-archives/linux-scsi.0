Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD12EC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 01:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbiGNBm5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 21:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiGNBm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 21:42:56 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CAF2250D;
        Wed, 13 Jul 2022 18:42:55 -0700 (PDT)
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AD7F140D7B;
        Thu, 14 Jul 2022 01:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657762975; bh=PoO9uKCveZNHfYo0VhihvIoA0p7kY46QMFkkQM7I/xQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=GV8hhEfyhiMs0oGwy1Khr2SMNwybQDu4CzYt1hem0FHffyX9AKoEKq/Gij2UjLUlj
         vt+D7naCAZnPIKdEzd/9qCKIYZN7+eYRPHUgu+olLBkTen8BQ1lO2xrgTG+bbyxmAy
         9oh2mGUZgtQkr7WUnoNwul2DFapIUkKEW5acaGL4wwDi+m5KEvphUydLHgA8cIJwUR
         3Y2mJuSZT654dYnv1MobcLUqh53UpD3aY1uw51lFdS5Y0MVu78xGEOpE0ktD4t+2pl
         OvCei30g9ByyPi3LO8vOoIitJErmCft5McGETsBOJeVtiujDhIDCie6Jd9KE+d9PZo
         qdKQ1QdjQhl6g==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id EBE29A0099;
        Thu, 14 Jul 2022 01:42:53 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2043.outbound.protection.outlook.com [104.47.51.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3FF3E8010C;
        Thu, 14 Jul 2022 01:42:53 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="EL1RpCed";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YFoYqAe3FamB3ZUJLRnsM3P64jAWpAuVwzd0B8W6yvEf7GCIU7waVZTESCZ6azHrXtUrhhMosWjVSxjPCrd/epRHzZFGpWzPZ5YGiKhwzQ73uysLl6td6ikJvUlRAwh3NSMGKDQT04IB6bwNGkgvimbs3u/1No0puAjwB42OJMOua6LUgjs+SDU6aCCH19AKUaI5D9iQcxAw3ZLp2JpirwiF9Jbi3qlHcFz1YdsyOWKP5kkc58Hwm/J1OgYNMirbJavJmJ/P0uvW86kKT0lU8rUX+mLe0ARRJlkj+80qR3fC09cpfqLNIl0nrQpEmlzT3keNwtIx8wi9Flzpt1uIHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoO9uKCveZNHfYo0VhihvIoA0p7kY46QMFkkQM7I/xQ=;
 b=B4MX6RXtJgBg+i4mA9PYTiBfMtrtB78ktjTLLC813X1RtxWPftA5CNt9XsvrwPZQ4ebwB823Zza2V8cefmhzKB+tmK9kI2l9+3hP3B7EvURb+60xdz1mSWifun5qdZevHMZbBtDFRIsx77MCctdUtvpGDS1PY2Crjs6p6Y6sifWVyBMFzLU+SRC4lljJ8wVrFN2xfmyOrqH7Gu0YiGez3/d+DJ5VEY9BQHx1DpK7V4YB9vgeJD9VIXmZsgfX82VdPZOgXMZF6YZQZ62M+REEPnpQeNSBCcm+L/1YD6cA0ZnExs2+59p1kZTDJZks/Hx2sfSascLerhO6OvNwMPVJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoO9uKCveZNHfYo0VhihvIoA0p7kY46QMFkkQM7I/xQ=;
 b=EL1RpCed9+1deoG3dSQ1zguMhcnLUwfndr58ZDeS7zGfaMtcish2LzEdrxdcBOBCfv1isf5lAMn1gkyQIirFQS7KpB45vNPRDijA2bdy7UTXqUQFjjfv+jFx5Vw8MWWKTtlUWA/0OzM6S/CjDR9uv3VJpsH4FHhWrEZCc+5t30o=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB3373.namprd12.prod.outlook.com (2603:10b6:208:c8::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 01:42:49 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.026; Thu, 14 Jul 2022
 01:42:49 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 15/36] target: Include INQUIRY length
Thread-Topic: [PATCH 15/36] target: Include INQUIRY length
Thread-Index: AQHYkZEm3MKQSWOIz0GTEZ73TmyiZa1ysMmAgApyIIA=
Date:   Thu, 14 Jul 2022 01:42:49 +0000
Message-ID: <75635826-be80-36a3-e0e4-357084afb4fd@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <2557ef61dddba5056b9d89d73248bf4140e92f19.1657149962.git.Thinh.Nguyen@synopsys.com>
 <YsaxYW6Q661qoaar@yadro.com>
In-Reply-To: <YsaxYW6Q661qoaar@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e07d6f4-9898-4332-1e5a-08da653a28fe
x-ms-traffictypediagnostic: MN2PR12MB3373:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fbX6mteWGZN5zlIHsTP8WS1yyib/ayhDOnP0VJqr0ZucHpQHbh6+buMOdx8izHzmfoKq83yKl9jU8ffYKTxkf+oVx20QW1Mil/DVhD360xt3kcrxe7ccTwps3ElJAlZfecuYaCMd1Rp/ydKunIAG8QzWBNO04psv4p+9qGrAB0DFTq03gEfyVP1R45v5OdYIcrrYNVdaZTUXG18m7g7NHPuk6uQDM1O2MkdxWMdbR44IX26AW0WtCSMICt59Z4HdlzrzmENsyvdaJ7B2m0Q/E0OI9B+IjvGeAn3ZdXic7DoqggXfWJ4bgBW61NigqKHjBa8Uue6LvjoplymwVkr5c0TzBAclvB6jW8BLU6c72ezKTvrpq21mJqgmICjj7YKdhnQGVPZugjS/JzzquD/8cmTMCXySKk6UGprEPYvArMW7yD32nvAe/5VRguxPv26IeD/rjBlj+Aq3Iqg0K5yhDyqKER0bF0I7xSlJkRX/9eoedW1ZA5DhEMKdwBIdWN4LTa297oa6yjyakf5kKzVwjfEHh3RQJLYhVHRoGLKAWNiAFMUZqpiN1IODWXYcLwnO6H1EwwWXBK5IPkiOECKsGAIcik8PMjXW4vYRS0Z8ACn5j6oWToYsDI4TwPd386qGOUWbBAASMKs4P1eSo8JMF0vmUdjNQJew3N/gOp+9XRoF0NotUpdlbFcqu5kJ2oMmX1cO8vZTYCxrq+kifsUdnkzNnYha7cPgkDCh3czjEFJeIUORoMx+4K5w+TGZUTcL8380Ny/CGtN1RTwfRgxyaZUx6dtFGD0kayi6qVZb6jtk4xMvJyNK9MO2yrVlH0oAoqpsI66gTDl/P3poF7zmmKXA3JH6Gs6fSTdql9gt6nJDlNKrV52/L5irWKNG2tba
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(346002)(39860400002)(376002)(26005)(2906002)(41300700001)(6506007)(6512007)(122000001)(83380400001)(38070700005)(316002)(38100700002)(31686004)(64756008)(66946007)(478600001)(54906003)(5660300002)(8676002)(186003)(4326008)(66446008)(86362001)(36756003)(8936002)(31696002)(71200400001)(2616005)(66476007)(110136005)(66556008)(76116006)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk5vTkJwNkNnSUUwQlRVOE5ucG5sKzU0RWZZemlZalAyOS92U0Rtb3N0MnJp?=
 =?utf-8?B?eTJOMmpBb2IvSWNVdzZlQThxWnV2V3lTNElaREZoUmJTV3d0Y3FIRENRV0J4?=
 =?utf-8?B?bUNueWlsUktiS3pvaktERnZsRFFFdzU3YUdET29GcW8xVlhSaWRTcWVWdHlP?=
 =?utf-8?B?Zk1yeEdibG9YQ09MKzhlTG5DQlZUU2swYzFBQ1FKQVc0cUt6U3lLbHUxOWox?=
 =?utf-8?B?aXpRb3RBazVrQkI1Y0lFV1YyR2dQUmRWbmNXM3U1UTdFVTFDc0ZiWVlma1k3?=
 =?utf-8?B?ZUU0RDZvWmJnNTVFTllERGZHSk9wSjVUbk1teGR0TlJ6bWI0cWhQNmRVVDlm?=
 =?utf-8?B?VzFIZFRBOW5YK0tyMEJXWFd4a25xeUNpZWEwR1Z3MnVyb2ZQWEJJNWRIbDhJ?=
 =?utf-8?B?TzNpeUpqbk0rTmdMMUdRWkxMU29jbC9najVJYmd0RnBXaUZnN2N3dEZKWWdT?=
 =?utf-8?B?UTNPVTdGa3lRUnlTMnJwSHhCbURUZ3VoSzF6S0VUaHR3YjZtRWhPWFo3SDAy?=
 =?utf-8?B?cUg4TGFJcVVWc29HdTRWYytlNjNEcEwyRzZEZG1LRFNtNXRtUEhnWWwwNkFv?=
 =?utf-8?B?QkxLVFJZWG1sYlhZU2ZBVGJQR1c1aEQya3FGSzhCRGdJWko1Uytpd3ZpLzg1?=
 =?utf-8?B?U2dIcTgyUlNhemtFYWw1bkR2TmZYRk9OdzRuTXRVd0ZkSEpENG4zencyKzhs?=
 =?utf-8?B?Zmg4MVRnN2VJZTdWMWszTkZIVVoyZnpnV1RNcnRoY24vRTRoRVJnUStRZnRu?=
 =?utf-8?B?WXdoSVRleVU5WkZ1eXlKVzNydlBrS0Z1d1pCNlVaRjZIR0NSM0pub2pnQTRW?=
 =?utf-8?B?NjVWTTBzRXNHcEQwK0s0S0Q5YnlGNzVUMXVqWEdiUHhybXdJNnRTWmgzVHgv?=
 =?utf-8?B?bm9SWkQxaFd0ZC9oakZ0QldOSEFxTG5DbUJyY2laVEpUeUkzZEl0TU8yZnFw?=
 =?utf-8?B?ZVhlNngyKzN3amM0R0FqQ1IwaEczbXpwNXp0cndwVHN1R3NtUEwrcC9FTVFL?=
 =?utf-8?B?NGpiK1A3dlIwRGR2bmMvQm5OVnl2OUFMUDVYRmU5ampiZ0lZeVdqUHA0eEVi?=
 =?utf-8?B?VFY1dSs0L29sL3dYeUlKZEt0UHEyQWgzUWs0VlZQYUZrTkJXbzllNlYzaHBx?=
 =?utf-8?B?bDByOVJZUGdlVS9IWm1QY0RMbTFSSU84RnhMeVE3SU9XaUUwZER5YXlaYmxH?=
 =?utf-8?B?VC90NmpHNTRldWhwMkFDRGdyNGVkNTFDMEpmYmtWY3g1NERCMW9zQnJmYkM3?=
 =?utf-8?B?bDBGTjhFN3Z2YWJ1QWdhbDNNNWFMRHNsZnZmRTI3ZHJCMjd1U0J0a1RZb2ti?=
 =?utf-8?B?bDI4dHh5Y3NmNGZ3TG85V2E3YmhxbzFGS0pYVTNUTjNieTZGSjE1TWROb1lY?=
 =?utf-8?B?MlBNcFVhVE1HNnExWktTckJTNmR6ODZXTUV3TU5NMGxINVpQVUZ4RzRYWHZz?=
 =?utf-8?B?eGtBZGVoSS8yclp3ZENnVTA1YUlmM2djTjB3SDhiT3VvT0R1YWF3VS9UZVNM?=
 =?utf-8?B?T0JOZnBKY3hiZFJFUHl1aVlEQmNzRDdXUTNxaHhKTW5TbHNpWHJvbDlKMFlT?=
 =?utf-8?B?WDB6czhsQkNNVDd5UDEveklkSlo0U3dNdlA5a1g0T3ZNeVpxNU5WanZsbVov?=
 =?utf-8?B?MDkySk1VeWJWL0JWSmptMk5SRy9ncDdFZHBIWFN2YVJlUnoyRU16NGpFMUtD?=
 =?utf-8?B?QWFCanVaR3d3MkE0MStvNldacDAwUURRaUs2Qk55WWpzYVM3L0tlcFdRVm03?=
 =?utf-8?B?ZUVxMEhadVZaRENtTDFKcjA0TVp3clBhVGhBTStiVzZucDVOQjF2WllKaXBG?=
 =?utf-8?B?RWNWTUlZblI4aUpjeDJ0cExPcWhSVzJWNDRtK0Z3U2lxbE1wOGtiMGNRS0ty?=
 =?utf-8?B?cktORWhVcENxKzRuMEoxUnB6dENLcyt3YnJlMTBaS3VlWXkrdmFtL2xFeXhM?=
 =?utf-8?B?Qjgxei9pZkpkRkJpN1E5bS9jc0hodk11WGVQRUJUSzBFejlpeDQzUjBEQnMw?=
 =?utf-8?B?UThSWTFzQkFjYXpzVFE5Sm43bmhGQ2dSNnFzMmQ5RCtVUlBVR0cyVE1sME81?=
 =?utf-8?B?VkdmRnpzWFMyazU0aEZkZnI5TXc2Mks3T0xzejlvRVpDLzdQMlNOcXYwTXVG?=
 =?utf-8?Q?4CVM5y5a4ZSAuRLPdFMbDveyN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <20243C1AE2D4C4409B0E1896E6C4CB0D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e07d6f4-9898-4332-1e5a-08da653a28fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 01:42:49.6441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VVxo2dsk5t3WrFg+qfD2UMRSgTT0pOxxPAhJvaSDSBh/P/scRkDNvTAgjh6ycO+t1zJXQ1ZM/JWBqz1x5k82vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3373
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIEtvbnN0YW50aW4gU2hlbGVraGluIHdyb3RlOg0KPiBPbiBXZWQsIEp1bCAw
NiwgMjAyMiBhdCAwNDozNTo1N1BNIC0wNzAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiDCq9CS
0L3QuNC80LDQvdC40LUhINCU0LDQvdC90L7QtSDQv9C40YHRjNC80L4g0L7RgiDQstC90LXRiNC9
0LXQs9C+INCw0LTRgNC10YHQsNGC0LAhwrsNCj4+DQo+PiBUaGUgSU5RVUlSWSBkYXRhIGxlbmd0
aCBpcyBtaW5pbXVtIDM2IGJ5dGVzIHBsdXMgYWRkaXRpb25hbCBsZW5ndGgNCj4+IGppbmRpY2F0
ZWQgaW4gdGhlIGRlc2NyaXB0b3IuIFNlZSBTUEM0LXIzNyBzZWN0aW9uIDYuNi4yLiBUaGUgImxl
biIgaGVyZQ0KPj4gaXMgdGhlIHRvdGFsIGxlbmd0aCBvZiB0aGUgSU5RVUlSWSBkYXRhLiBNYWtl
IHN1cmUgdG8gaW5jbHVkZSB0aGUgMzYNCj4+IGluaXRpYWwgYnl0ZXMuDQo+IEkgdGhpbmsgeW91
J3JlIHdyb25nLCBiZWNhdXNlIFN0YW5kYXJkIElOUVVJUlkgZGF0YSBmb3JtYXQgY2xlYXJseQ0K
PiBkZWZpbmVzIEFERElUSU9OQUwgTEVOR1RIIGFzIChuIC0gNCksIHdoZXJlIG4gaXMgdGhlIHRv
dGFsIGxlbmd0aCBvZiB0aGUNCj4gSU5RVUlSWSBkYXRhIGluY2x1ZGluZyB0aGUgdGhlIG1hbmRh
dG9yeSBieXRlcy4NCj4gICANCg0KTG9va3MgbGlrZSB5b3UncmUgcmlnaHQuIEkgbWl4ZWQgaXQg
dXAgd2l0aCBTZW5zZSBkYXRhIEFERElUSU9OQUwgTEVOR1RILg0KDQpUaGFua3MsDQpUaGluaA0K
DQo+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5j
b20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy90YXJnZXQvdGFyZ2V0X2NvcmVfc3BjLmMgfCAyICst
DQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9zcGMuYyBiL2RyaXZl
cnMvdGFyZ2V0L3RhcmdldF9jb3JlX3NwYy5jDQo+PiBpbmRleCBkZDc5OTE1ODYwOWQuLjE4MDFl
MTBjZDU3NSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3NwYy5j
DQo+PiArKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV9zcGMuYw0KPj4gQEAgLTc1Niw3
ICs3NTYsNyBAQCBzcGNfZW11bGF0ZV9pbnF1aXJ5KHN0cnVjdCBzZV9jbWQgKmNtZCkNCj4+ICAg
ICAgICAgICAgICAgICAgfQ0KPj4NCj4+ICAgICAgICAgICAgICAgICAgcmV0ID0gc3BjX2VtdWxh
dGVfaW5xdWlyeV9zdGQoY21kLCBidWYpOw0KPj4gLSAgICAgICAgICAgICAgIGxlbiA9IGJ1Zls0
XSArIDU7DQo+PiArICAgICAgICAgICAgICAgbGVuID0gYnVmWzRdICsgNSArIElOUVVJUllfTEVO
Ow0KPj4gICAgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4+ICAgICAgICAgIH0NCj4+DQo+PiAt
LQ0KPj4gMi4yOC4wDQo+Pg0KDQo=
