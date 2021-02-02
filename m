Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B04EC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 20:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C485E64E4B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 20:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240396AbhBBUGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:06:13 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25353 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbhBBUF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 15:05:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612296328; x=1643832328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CwSIvwD14lEjMWbmquY+xhqY1vwf6ipg/Gsks0dWvUA=;
  b=zggUvPzBsgRNTfXJ0G8HOXp2LTrCN5sQU8qDSjAW+2/qlWTzhy9bCg/V
   waXp6TuAfgFrNd1agMuy9Wvz9MIRG04+d3XsUqxZu4u+Q7K03mmRw0CM2
   HlD24xQJx2rgmbwAwKUwEDL0bTQxWeuz1EuPXaC+xXU3q8NJ0TBgG+Ty9
   OZOrWDz5ZVkh1+lgbwifSwuyV7WXRXuJ3uvD2uHFbwq4nqBZLd+/eP4fS
   1O5bF+yglTd9ogsMUNvFQd7MbVsofZnBjP1ootzxPMed+VoM/y5VcV512
   iWAtz8aqJKFQ2IDuybG996XBpD7c47Dw3/DhB/cVr7RQDBpWGqKV7uxyr
   A==;
IronPort-SDR: MSqKF2ZZ3/2p4PyPeURpC2efqGkrd1/QvLGhu2gkk7OKaJ69Desm8QujyfPRA0lHpa+R3uuSY2
 Ai8A8/ZPt7fNDDdZCsWrSD+dHmLt2iYfYBcNpEeOwNaIuomZKbIld3bYUCEAzmnGNsNyhDK2Y6
 T6LH5gNclCn3MBHXHj8wGfXfi4zJf/KLIvor5NhHNNrDwVFh/gs4RnxSN4r6enM6SFzdmSQUtK
 TsLDQWZvT5MKBC7Zd4LCRPZhL+n/YS4euaO+DKRkaF2mTRw7ve3TmnQU0N5ThPDaqndDCIsF9p
 aeM=
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="102338966"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2021 13:04:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Feb 2021 13:04:06 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 2 Feb 2021 13:04:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl3te85HEyERKHTx3+IizBB9SwmPfkWKAr86hl7ML62gqItCRvORsW3M7fIWKggt9g9be593is+SKYjN9a2I/7lGJCAQRnt85j1dWBDKnbYgWYAFXhbTbAYRKd/Z/tR72mAIAy/8YXnakuYCVBan6ztomLrgSZhw8liwC61ENYIqFfyjg9a3LVrggy5f7FIkkQ9nFF/S2a9EFGJQQq6RAklHH0fudpdg4mdHNyQ8V08jy4GsYI7GA8BarHLHEgiCAmnbYCydjLmKVXz7lGQVzTSMMy1dIgIwXiuvEUEmNJYyKEATFJAKWcTLierRRgknC7tfpN2uMzoDa9w+bY9gKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwSIvwD14lEjMWbmquY+xhqY1vwf6ipg/Gsks0dWvUA=;
 b=Qk/8dUBMOACx312baCsuFmfvKJXsLEvATGbBthohG99oay7ZXncwALjuS27nEShENo0Lccz9VMz+TmTxR7gR79hFqMDrebf0BEHy3119u2o0DqXcYlfS1FUCBkbZcgY+qRZyKV2xs1SahMIlkn8/0LdjlMEQuRB6VZ7MiTu0ZlhaJ0ySgCOxW+Pn0tMpndOTt65o2uhF6HQ2nduPLJGfNrYPF4wUtSWuvor/s9/+C5P9KEsCRkHUZHrrji9Z4j5uRzctgVLPw7pDKaXQ2dswN0hWO6Cfp0UMkazIOTlYkE/6ZTQ00wGIP/XP8HBtyEe8VfAjrA3wUgZfEUvz4k16IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwSIvwD14lEjMWbmquY+xhqY1vwf6ipg/Gsks0dWvUA=;
 b=XJ7y6LV8I2YKaT+x8/NU+GjLQ1sU9WndZTb+bQEdTCWStzsNBwNCFVIvsPkl9hfcQQ0ol0uGeOYqd3SdCQ/DLsakA+M468vaAQCHAAskSTV+aXSn2/cdXH+fIHuEuevecdBb2+MmjJsTBQUEEfnm4eDc4dZCkEyWCLE+IU/gYgU=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB2590.namprd11.prod.outlook.com (2603:10b6:805:54::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 2 Feb
 2021 20:04:05 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 20:04:05 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <buczek@molgen.mpg.de>, <mwilck@suse.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <mwilck@suse.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>,
        <pmenzel@molgen.mpg.de>, <hare@suse.com>
Subject: RE: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Topic: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Index: AQHW71yKurA1STNSk0C6miEuXSSEDaow9juAgAEFWACAAAlxAIAAAq6AgAAFxoCAE1AKoA==
Date:   Tue, 2 Feb 2021 20:04:05 +0000
Message-ID: <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
In-Reply-To: <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 483103d5-8cd9-45e9-3c8b-08d8c7b5b191
x-ms-traffictypediagnostic: SN6PR11MB2590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB25902D0BB877BE3B1878DDE6E1B59@SN6PR11MB2590.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3IPoze36+gFSgMDlDby9PziJ/amEozxnrv2HNFxEKToxjpVVu17GrjltSxDSr8QTR9837o/4Ovj+nEn0T4lULHA7l8KyHH+q5yU1W0Cib+PRMA6AQp5LoW+cKTB29v0jsoEqGSYLmsbl8HzyJpB99rBf8dcXK5zEZsiYrNONXojqHWGDAWIVYDA977a+MjqDjwXOxrTD421VulRvIHt6jlalE5XmIPMGRBe5D3wglsa9VSq/8a+a7pbQao1btFHb7z3OjuNDdpoPzoAhExNZWf3gWGvFZoB7XbPEFda57bky7P2XcSj44Ts+bZiMFarJE1GvpHDfUOIDtSekuEV0V/qX4HT2DdxABqKenkMzkb/Z7MJnUjVJVOlRIJ2cFt+YL0N4fGvgIOLpE2Lvk2nH+ObpDw8pY0dOHvAAvq4CiIBNP6CWlN0bxqbWLqe2g3Wev/8uikVyeLgQPQsWDWMVEKERO0k46ndhq/yGZVWeNUH3/4n7OX2QmTL2MmfZH9TIS14dWdqQ8oNITdrr1fjNZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(366004)(376002)(136003)(4326008)(26005)(6506007)(4744005)(33656002)(186003)(86362001)(66946007)(54906003)(66446008)(5660300002)(66476007)(8676002)(316002)(110136005)(66556008)(64756008)(7416002)(9686003)(76116006)(478600001)(52536014)(8936002)(83380400001)(71200400001)(2906002)(55016002)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZFR2U00zbFJ3Vmg1eko4NTBwK3JJUm1XYVNVOUk4MjdSdEVYSFVrYjIyUElH?=
 =?utf-8?B?dTJZcU41djBpdkhsdWIxY3VmbGlkZXBQNjUxRHJ2d0RzQjhSNGdNZFB0dm51?=
 =?utf-8?B?aTY5ajJnNXlYTEtpcGY5V1FYOEd5dnZUSndRVWh2akpQWDhnUU9ucXN4eE9R?=
 =?utf-8?B?SSs4YnRsTjM5RGJ6Qkx4RFU4QVNrazZWcXlvZzVDUWw1NU11STY1ZTNvb1oz?=
 =?utf-8?B?TlhSaU9DakJZUW5lMTE1anRIMktucjI5aUJZVm1uUlRiSWdhVktmTkwzYW43?=
 =?utf-8?B?VDZFY0N3d3Z5RURzdGNmQjZLbmYzT1BxZTMwaWJqLys2SzB2dmJ0US9WWXgz?=
 =?utf-8?B?VkFDWXhPRVBTV1grN1k2Q3dMTGdGR3JkeDRxdTY0RVlIZVcrdGlxM2ZZOWpu?=
 =?utf-8?B?cWdHUktkMklZSXNCd0FkM3NtL2xac0hxK0pyV3pFRWt0YW42SUk5d3E1U0FV?=
 =?utf-8?B?N3M3UkpJbHZIRGRXOGE3ZnhWVXprSlRKMndoZ3U4cXJkQVhKTXQ2VFErWHZB?=
 =?utf-8?B?K21kbXJUMGVyWGd4bnYyYVh3WFFPeWNsa3hHV2xlWk44TWNNd2gxZ1grdC9o?=
 =?utf-8?B?amF6ZGdKWVNka0QwM01lV3RZeHQ0YUV6VXcyOThHbEFDK3c0Z2ZJZkplcXU5?=
 =?utf-8?B?Nk5vaW9zSEcvY0dYanU3SGFpYnA4bmlsQjdpSXdDVmgxVFpZWGNFNlBPbmhK?=
 =?utf-8?B?WFRsVGdNNjRNMU9yVGpuc29SMEdoV0M3Tk1vakhXNG53SDR0WWIvL3dlTVdL?=
 =?utf-8?B?ZVllT0JvZ1BOQUdDMWNNU3JHUXNZcFR4cllzWVExR1ZkWWJHeXhMb2kzamJG?=
 =?utf-8?B?WVFtbTNzcml0cnBnTkVNSkdUanpVYVRWbjBNem9rR1hOYUN5OG5IRGxNRnRh?=
 =?utf-8?B?WU5FL2Z5SDhDZkZoYXo0eUFWcVBRMU9OcTg0elJmT2s5VHFERlZBUUVONE05?=
 =?utf-8?B?RE9lMUw2bzhIeWFPTm1vd3FwalBDc2JHaERrWnEvU3NHWGpENVpMUHpsemFj?=
 =?utf-8?B?K3RJbDBoVmpPSXpVOHVXREk0c2ZqSk95K1FpL055QXJmQjZNamc3elF4M2o5?=
 =?utf-8?B?L2RmYy94NmtvQmg5L3NRWUw4WE9FU1gxN0s2TFhjeGNlSFlOUzY3Ykp0dy9W?=
 =?utf-8?B?U2hOQzhlVjd0WjBaYmJnMHB1bGlHTFZTdG02OTlvYWdjTFYrV2lPS3lkclRG?=
 =?utf-8?B?R1F3Q0xBYWlJUmh3Ykh3U0JkWDgyRUpOZWVxbldrRVFDZ1hFN2thOG9rUW43?=
 =?utf-8?B?RGZCQUp2Vzd3NUxFV3JBV3M4R2VsQ2ZlY2J2czdHYUpBREhKVFVrYmsvemlC?=
 =?utf-8?B?dkhlOVBtU2NvNkJpdmxaRTJOelVGSTMwRm5ESk12WmljS2ZNOWN5UWROTjVW?=
 =?utf-8?B?blhiTUZyUDkyTi9zSlNRNXg5S0xrN1kvV240dlNrS1FVUzdidDdmajJyb0lt?=
 =?utf-8?Q?TDfs+Fhi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483103d5-8cd9-45e9-3c8b-08d8c7b5b191
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 20:04:05.4289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZwXcN/91VBqpBeL5x3x0nCpvWgzW13dCeraoF2X9K3+vwkiDB59C/NydMgtDG0SynBj9FyxIT0/YoPOHZcMrEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2590
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEpvaG4gR2FycnkgW21haWx0bzpqb2hu
LmdhcnJ5QGh1YXdlaS5jb21dIA0KU3ViamVjdDogUmU6IFtQQVRDSF0gc2NzaTogc2NzaV9ob3N0
X3F1ZXVlX3JlYWR5OiBpbmNyZWFzZSBidXN5IGNvdW50IGVhcmx5DQoNCg0KQ29uZmlybWVkIG15
IHN1c3BpY2lvbnMgLSBpdCBsb29rcyBsaWtlIHRoZSBob3N0IGlzIHNlbnQgbW9yZSBjb21tYW5k
cyB0aGFuIGl0IGNhbiBoYW5kbGUuIFdlIHdvdWxkIG5lZWQgbWFueSBkaXNrcyB0byBzZWUgdGhp
cyBpc3N1ZSB0aG91Z2gsIHdoaWNoIHlvdSBoYXZlLg0KDQpTbyBmb3Igc3RhYmxlIGtlcm5lbHMs
IDZlYjA0NWUwOTJlZiBpcyBub3QgaW4gNS40IC4gTmV4dCBpcyA1LjEwLCBhbmQgSSBzdXBwb3Nl
IGl0IGNvdWxkIGJlIHNpbXBseSBmaXhlZCBieSBzZXR0aW5nIC5ob3N0X3RhZ3NldCBpbiBzY3Np
IGhvc3QgdGVtcGxhdGUgdGhlcmUuDQoNClRoYW5rcywNCkpvaG4NCi0tDQpEb246IEV2ZW4gdGhv
dWdoIHRoaXMgd29ya3MgZm9yIGN1cnJlbnQga2VybmVscywgd2hhdCB3b3VsZCBjaGFuY2VzIG9m
IHRoaXMgZ2V0dGluZyBiYWNrLXBvcnRlZCB0byA1Ljkgb3IgZXZlbiBmdXJ0aGVyPw0KDQpPdGhl
cndpc2UgdGhlIG9yaWdpbmFsIHBhdGNoIHNtYXJ0cHFpX2ZpeF9ob3N0X3FkZXB0aF9saW1pdCB3
b3VsZCBjb3JyZWN0IHRoaXMgaXNzdWUgZm9yIG9sZGVyIGtlcm5lbHMuDQoNClRoYW5rcywNCkRv
biBCcmFjZSANCg==
