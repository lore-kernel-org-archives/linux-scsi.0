Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B12D0C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 13:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA41216FD
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 13:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgLUNiP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 08:38:15 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:9969 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgLUNiO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 08:38:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608557893; x=1640093893;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=r5bpyezHSdC0EWTswToFhvoWdC0P83sSLu8/hW6/d9Y=;
  b=g7xDGlzAsiAnGaGj2C+HR8GnlP/2erS9d850fwcVziz5UWT14/ht5S/G
   qfKxjooSOamsdt2ISKC0aLoJIMOtQwqY2ekTS5q4Rz0AfamNo/a9aKSIU
   be2553s64D52/tbZdZvnblqpWKiPnYUxepcdMvJ91Li1FpfPy9sRIfLsS
   BRSFt5LVtIjK5WN8q4Aq6bsuDw7Kgp8mn1re0/y+9TiiH+2VV9fskzAj6
   Akr61+xH54GFcTmRIi9pzgRER+pBzahmhUSCv7n8G2apVUTRsiYPYznO6
   ys/XYcC0uNejyknm8u9hXbNfVerbyQiF3ndfxHS/UBCNekOi+wcm0FpEr
   Q==;
IronPort-SDR: 2nHg7UdC3s3ZzggMa+8bJfofOv1Z7l+uilNN26/oRBdpWjOhY7ULguSrMKTt/lA+PT5IYQiqY5
 QeQ66fhnpZks9zkOK+ctDNdBAUZ36qpnk133DeOa5ukRYHtO6YLLZnFFqtWa6mSA/+/MdjJZyt
 /7tzDEN3vXbIi+ERjKsgeKcRajanqbqxb2NnQzyZJlnIYWnY8Ej5ZeW1mDysNbP5mRSu4OzQSg
 bSyYOL5Zr9N28iNXDS+6HdVk1ed1s1hyeZ5u+nHOcxSx1BXx/wGQTcNUAMQ4HELRXKSJBTyul2
 9+4=
X-IronPort-AV: E=Sophos;i="5.78,436,1599494400"; 
   d="scan'208";a="265903671"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
  by ob1.hgst.iphmx.com with ESMTP; 21 Dec 2020 21:37:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8OZn2UkMQdbQ9jrk8tlcmwZia1dDhSLR4UH59SRXBxIpMMPTsnxhp+8Ew9lVNpvyT8pQ1X27gcrgrQOQMrALhx7+ZdjDId5O+p0F2BJHCMFEqfueGSaknbG3g0pCMdLf2d+qzmQAMx04p6DgnaFhVg7Krj9p8xinCmSI/9fOciQqSDCodasj0rwk/vmM//K8qvLDaxcYx0DRRiYEA/7iKD9m71SddAMHjfVLyqqbqCvGdUOINahVitLN1mmSBDs6PxU5k4ybSB7AglhJEr4EFAKsfi17iTmhyIaJW/PKzClhq7iB7QSGiu4GErEplJqSod9D1qfNsLcupYMbxv16w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5bpyezHSdC0EWTswToFhvoWdC0P83sSLu8/hW6/d9Y=;
 b=C3xFxZQY/33aLyv3nUi1hEcI6o2LJ7DJft1Je2YEg/fXntH+eCtKR5g9Ci1Crir5xuzSKI1wzXDkoLiRMPAngmcfLarpzATOTwpNuKjThO0TCldb//tTxmMW4Z+ywys6rRGhlA86HyLClYQvbiUFGUp8BxMKJ/FwkteXckSGW/3/BtVUtkfqax9IGY438jgU6CkiLnpgeJqQoquYr0m9VUR7GevplER4f8SfghEnyddIVpdo+uErbI1pHrx5aclzmcN4C4Wtv9E18a0SQziyKXGMxC6/k+rQGhNRQBJgFmTDlm+1qeuD+DFvREkkYzEWNjBlpkSx0VXTQHCsXc3hBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5bpyezHSdC0EWTswToFhvoWdC0P83sSLu8/hW6/d9Y=;
 b=nXljRSn+3k6Ahanp6auEnJwUpi524+xF6t2/fbv3aJiMSdIn4j72IOMkMIHMYWhk8Yw0M5e78QOBJmkCf1rCIipoCHc0uwAYNNDgv+cHtWzVuBuVgjVyNx2zqV7fXlysfF+PvMAMzvkCHjV5oAozmKj4G1ZfLBa1H9zQ2L7igGo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB3898.namprd04.prod.outlook.com (2603:10b6:5:b5::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.25; Mon, 21 Dec 2020 13:37:05 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 13:37:05 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [PATCH v3 0/2] permit vendor specific values of unipro timeouts
Thread-Topic: [PATCH v3 0/2] permit vendor specific values of unipro timeouts
Thread-Index: AQHW1zmZ6sJHQ5MEwUGQqHtlg38yhqoBjiaw
Date:   Mon, 21 Dec 2020 13:37:05 +0000
Message-ID: <DM6PR04MB6575A2EBD678C4AE803F0F76FCC00@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20201221013532epcas2p4cfd78329e4d56e3ac5317ae23c27bc8c@epcas2p4.samsung.com>
 <cover.1608513782.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608513782.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ff595ba-d6cb-405d-27c8-08d8a5b5817c
x-ms-traffictypediagnostic: DM6PR04MB3898:
x-microsoft-antispam-prvs: <DM6PR04MB3898385D9EAD79373A1833A1FCC00@DM6PR04MB3898.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bB9e/bD65KtkVAd/Om1gDdPbErzO9etBjfrjFbuLJ7mZjCKsemrDNle2EdaIFpYvIFn05DRBD76FLG32NE9jV8rljfF9MtXB/0/Q4LrDFtWIGFtkZQR81lvFOuT/K4KI/V3sqqInbu11dSgYduQm0UTX+cxzqRFtnmM96PlQeuJcHxp5JmLUH0NDNpKJCDhQYSSCTaoHtQ46U0cbnHmQpzXhDGOysgP3l1X0k98RV772g+erzS7l3Ttj5iJQ3SjieyrnKUpDFy4dorvgqZ+SJUl4+6kKoDPZ3OCyMjKEQ5ZXGkoauT/mYIeU6QLJiBeNWbfYfm4ZBx7lJ6dLEevmlXjRqgKNX02XUTb+I7WCYf9s9ouuO+I2fkve3KXuLEluNlx3GWGbvCpg7Kc5hv/GK/jkXTgGplohx4lYDi+2A/q4xeqoyQzr017PNsV6GlH7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(396003)(136003)(346002)(8936002)(478600001)(86362001)(66946007)(66556008)(66476007)(64756008)(66446008)(5660300002)(316002)(83380400001)(110136005)(4744005)(8676002)(71200400001)(52536014)(33656002)(7416002)(26005)(7696005)(9686003)(76116006)(55016002)(186003)(6506007)(921005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cGcrWVVYTUlkcmtUKzZmRDdGVnVBbEFHb3N4QWtOb1BWUEpQQTZrdUdzaVRZ?=
 =?utf-8?B?QUVpSXg5WlVMK2ZPRGphS3NQSEVVbzF6ekpYbWRJNzdwdTk2SzQ2SlJNdTNo?=
 =?utf-8?B?UDBCVG1QSXNPdCt6Z0tPNFl0VmtZaERBZSt3K3RhTGRJVzVMdlZwc0ZrejRX?=
 =?utf-8?B?WGdZRE4rcVVleEFCVjB2ZW5meVJDZzJ5cDloakxNL0I1ZWcyZndpSEl1TG5V?=
 =?utf-8?B?clpuOHVpRUpFMG1VREZhRUhueGxTMGwzZXhhNEI0UnZDbFBkSFczL1YyRmhy?=
 =?utf-8?B?cmxDTGVud1JHQWlmNmhiNzJGMzdKdDZ5NnpoaDlaaysvT2dkZk9Bd1Vwejcz?=
 =?utf-8?B?YmdmOVp5Z2IzcGxVZWdUcTJnRk9NMjAxMkMwYW1ESEZXQXFRWkNLSlU0R2dX?=
 =?utf-8?B?UlpIVjZyRVYvdU9hNDlsdE8rRVZzYWdMVWFSYzJ1M3Z5cGJJeWthd0tHZXc5?=
 =?utf-8?B?aHc5blRSNWJnRFIvaGhlMkNqblAyRTBTSjIwREVpa0NNYU1LMXpBSFp3ODA2?=
 =?utf-8?B?V0J5TzZoVXpLSkxJNlVObVduaEwvc0dPNXdSMFJiUzdONjJqdTZXVmgxM2o0?=
 =?utf-8?B?cFJybHlONHBYMUw4aGppai83czdscTZkUkQvUEs4UDdNVHhNRFZOeDFyRDVs?=
 =?utf-8?B?MDRHNjVjWG5oejExOGh0UnU3VE5xZ1d0NE1Bb0psU2hCcGt3eitXdFlnMHd2?=
 =?utf-8?B?allJeGNCSmg3eG1DZ2hKTlhBUnZCWFNzVTB4MWQ3VmU2NGdvVlM5Ry9XOWZT?=
 =?utf-8?B?UndrNm1CeXdJSi8xN2xQNkRqNk52V1U3Z1JPeEwyTndldWcwU0ZvOWIyeDNo?=
 =?utf-8?B?RW1MSURVeWhmcXY0Ynp1Wlhib0dPeDZ0d2N2WERTWWFvZzloNGd2VFVNTlRk?=
 =?utf-8?B?RDVZNmlRdFJ6M1hkcTNUWjBFZ1ZpdG5ycDF4N3ZhNExmZmZQRFJReTVCMGhU?=
 =?utf-8?B?N1R2QTBwcXNjbDMzTG5sZmI3UlJNN0NkYmtpcnRBLzcvWFV1RHpnaFJ6ZUd2?=
 =?utf-8?B?TXd1bUNyRzdNZFpzclF5cnVIRG4wR3lKSlNCWFpPOHVqS2ZPRVlHMFZHNHJM?=
 =?utf-8?B?dGpKOXIvU0NQdVZDR3NmRWJHamZZdnRveDhKVDI2T0wvWjA1S01PZUhhTW1U?=
 =?utf-8?B?a3Z1ZnpYR2VyNU03MkJpZW1yVHR5dEJXRlowZjNJdFQ1Y3FtTEhhMTZMQjEx?=
 =?utf-8?B?OTRVWmlhbXRuNVBQUnFEWCtvRG9nOTZXOTBrVUJQN29BUVI0OGlGZmVhYVI1?=
 =?utf-8?B?RzdnREx4eE1SQzYwUzdNUTJXb3hYdCtnQkZhUUJIV2s3TFFSK2gvZlZLZ212?=
 =?utf-8?Q?zeKRxL6tKBuVg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff595ba-d6cb-405d-27c8-08d8a5b5817c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 13:37:05.2199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HomUlzYlmLV8p8nPvx8B9WogNHrM1bBnz8CR/xRvu04G5oZPAMS3Ohn/6RxyO+eDIYUKzCI9qmqLyjx2bYYxBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3898
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCB0byBtZS4NCg0KVGhhbmtzLA0KQXZyaQ0KIA0KPiB2MiAtPiB2MzogcmVtb3Zl
IGNoYW5nZSBpZHMNCj4gdjEgLT4gdjI6IGNoYW5nZSBzb21lIGNvbW1lbnRzIGFuZCByZW5hbWUg
dGhlIHF1aXJrDQo+IA0KPiBUaGVyZSBhcmUgc29tZSBhdHRyaWJ1dGUgc2V0dGluZ3MgYmVmb3Jl
IHBvd2VyIG1vZGUgY2hhbmdlIGluIHVmc2hjZC5jDQo+IHRoYXQgc2hvdWxkIGhhdmUgYmVlbiB2
YXJpYW50IHBlciB2ZW5kb3IuDQo+IA0KPiBLaXdvb25nIEtpbSAoMik6DQo+ICAgdWZzOiBhZGQg
YSBxdWlyayBub3QgdG8gdXNlIGRlZmF1bHQgdW5pcHJvIHRpbWVvdXQgdmFsdWVzDQo+ICAgdWZz
OiB1ZnMtZXh5bm9zOiBhcHBseSB2ZW5kb3Igc3BlY2lmaWNzIGZvciB0aHJlZSB0aW1lb3V0cw0K
PiANCj4gIGRyaXZlcnMvc2NzaS91ZnMvdWZzLWV4eW5vcy5jIHwgIDggKysrKysrKy0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMgICAgIHwgNDAgKysrKysrKysrKysrKysrKysrKysrLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaCAgICAgfCAgNiAr
KysrKysNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMzQgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25z
KC0pDQo+IA0KPiAtLQ0KPiAyLjcuNA0KDQo=
