Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71115C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EAD322CBE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbhALHjd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:39:33 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:33333 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbhALHjd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 02:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610437172; x=1641973172;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=uhQlYWPLlud/05iICBqVrcDuXy83OVgWlU3/5Bjt158=;
  b=S8zxs3olTFNsi76gVTGBmxRQrVB1hHG6urflFW9Ft6PycIIagmzsRYhu
   WabcfYrlJhLdP/WNPYdPRe+riOeNIQy0DZck9HcFRdax91pwiLj/1iuJV
   RwKAWu0YG4ku/pXLVO58XD/kYwzie/YWkKwZ2pVW/7LYWS+nv9JMoMoRp
   8n0cqE8SYYmLfbf+yxg3x0Ozzc7+w2oYFECLaueuT8zCfeyq7sUI8v6U4
   b3GqXBXEoLhMX27wawrFwSpUCcLFSFqeqNMMtNPh2xdw5+oBz7mLCqjyy
   te/LlAXvfKJ4rRjpxk0CtTLZVyR+t7coL6FFk/g2RgwJCcGFFCxNvOpD3
   g==;
IronPort-SDR: TpqNrZHYsBv+f9Q3yljYBA4/yFnxf9PYKdDW10VmWNDhxiTfak4i9By7qwZBMwFdR4Zlpf6oOU
 tUrJTuoHmiPHJ7hZTpzFNyjRnI9mFFVdM1CZgHW89fQNh6cgVCcQbzGl2G1uOdlcVwH0OQLsWj
 PJR9SOxr0ptwUAfYgN0yHxtg9ALGLS6bm124RWEPriV6GI8KOCTjp/vjBxbykoZHFkW4mmQB66
 cLpOwmjblrGTgFVMj2oslGmckO8zmb3wviza3aPNUYAEeABWne5c/hm+/djWzIlpFt36tuqUb6
 5dw=
X-IronPort-AV: E=Sophos;i="5.79,340,1602518400"; 
   d="scan'208";a="267517468"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2021 15:38:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISbahKd4BxEo3K97BG7CpIV44DNw3vse+UNTkg8xFDSEncu1p7Tahz+RplyO0xnmW3bfaLJR3AKFVvOevTZ/ZpYWkQ1NT9aAjPy0ivLU3oYpgWY4HbhBY0dpXGM/AyoTObUb7Ma4EkWoMUP5g3FkBsZ9+0Xcjh10txo6hRglQ++SkDjwr1lasDOFYdeBc9ROtXt7LBGjuop0DSYfWAVMLjOP2w2ApTE/r5YslfMYeIpQVyn4sfgJFTlIKK1CJsKlOFyuaTweCUPxoB5ZW7ODlejkVNBNKXCsVn0X0Nh5CpemuAHuvEfyiF+WRBi/rzattL1mBS6WBAOnGPmSUZVMpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhQlYWPLlud/05iICBqVrcDuXy83OVgWlU3/5Bjt158=;
 b=kR5iuDu7LBIgqkMBs4lyPJtOevQU5K80grLGyjxm1DFuldutN7MlSc3nGQDkUoeIYUBL7y+OIWEqkany30sRjlkMbNHiQPEhBAHfzs4aOgLkfOlG5ZxIK5kMIbHxbZfPKMyUKz22rbkLL7526U3xT2z2urft9Kgr0lWiMb60FN0x5XSMYzHZfyj0fvKiMcjJo7Le0xolZhMrNqfM+VFStx96gUvMeKVZaln+Xqz5cgscKdiCQgsHknxH/pmy0KSMXXdLV2o80ZBIRqsbs7zW7XbBqw6HPCLe/tqZ2wcc4D4V4+8taW8ASqKT4h/uAZ0WlnNz3km+nDobNMNiEQubZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhQlYWPLlud/05iICBqVrcDuXy83OVgWlU3/5Bjt158=;
 b=NpaqECuXAeHVMRrMv2FcO7f29OcgMhorUBf9YMaS4RLOA6+atE4dSr9TCYn+VdKr4MfRNGlQfWxu4IiY5QmcManjCYiVlCsXCB3bwxoTdllvo8lAPUOoqRxWUsKoKKGuiFw5CSDx2LeIJd/3/GWwfGlcn8d5GM9EBr6ZvKNyR+A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5628.namprd04.prod.outlook.com (2603:10b6:5:163::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Tue, 12 Jan 2021 07:38:24 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%8]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 07:38:24 +0000
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
Subject: RE: [RESEND PATCH v3 0/2] permit vendor specific values of unipro
 timeouts
Thread-Topic: [RESEND PATCH v3 0/2] permit vendor specific values of unipro
 timeouts
Thread-Index: AQHW6I8B59V79t5of0eys0QIJ+TxkKojmnZg
Date:   Tue, 12 Jan 2021 07:38:23 +0000
Message-ID: <DM6PR04MB65753000A58B9C4A8BAB28E2FCAA0@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210112025940epcas2p2f27c4f5e84f7f745a64027bdba536227@epcas2p2.samsung.com>
 <cover.1610419672.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1610419672.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7e2838f1-b49e-4720-e957-08d8b6cd0ae6
x-ms-traffictypediagnostic: DM6PR04MB5628:
x-microsoft-antispam-prvs: <DM6PR04MB562837C16AA75E639B143D3AFCAA0@DM6PR04MB5628.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QHsJhW3WNtsWL1lW3/NYGg8Dr4r5rW6hTWpFyxP+zDtZF7RX+i4GdiD9/wK6SQmtCSR/Qobk6ojsGGSktaIzOMq/LYW2Sj2BRMVzTu4/CzQQ2TBfJWuBX43COEgCLivQ0v+IuDn/9LS6wbUb0zlYRHnUa0h3K2sbmtkV+z5qruNkezSmxQ4UVowySWpPvHpq5RcxjgAMuuZh5OL/4MisKyCOeXkncURbow1Aq7s5JvhzoEvHn2BwlIveWIDdfTZMPolQYEBfn2FB3OJAnfOw2KoxGU95tvcIiMQbuDpDu+cFe2CZOLJqt3+CpPehAIYt+QDHMIMYGQFTNHUpe2RuGmazTl0yshVzd7COul1Tj+SV06gPd5xMWd2WyRwDlb3xk+9bGTtJrpPVq7na5bdghcnM9Grqj9DdrHkq5dVLIjL92pbs6QODFsn9m7nZum8w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(478600001)(316002)(76116006)(5660300002)(7416002)(66556008)(6506007)(921005)(8676002)(71200400001)(66446008)(26005)(66476007)(110136005)(8936002)(33656002)(186003)(2906002)(7696005)(9686003)(83380400001)(4744005)(52536014)(86362001)(64756008)(66946007)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?aTU5Ty92QmROQ0lDWS80VzZvRGtudDVwSmVoanZER29yL1V1UjNjY2FPbVRl?=
 =?utf-8?B?aHpiUXpJQThNdmRPRXZKZklZMUlHOEU2MFJHbkJOL2svNkZ6U3NsakZYVXBS?=
 =?utf-8?B?azVCT3ptczZDMlgyWnh1amhiMGRCdk5POWRkOUtHSzd0U0FOdHcwRnhaNm9x?=
 =?utf-8?B?YmZKNW94TWpmOUgrVWJvdWRZYlpzVSt4Rk1zb3ZGcGhkVnhvaWU5TENqUTRa?=
 =?utf-8?B?UlRqRU5HYi9CZW1hM3kxcGgrSmlyQUJvNCtLYTJTak01QWxJaW1WNWNGZlZk?=
 =?utf-8?B?Ly9xR0FoOWNoelBSQndJWWhxclhla2svOVZUU242UXlJQk93RHc4UXhvNGJO?=
 =?utf-8?B?dkhpcytWN1dhb3ZyUHFaL0JxQWpwMDhDc3lZSFJIa0NmMis3Vnpwdk1zbVE2?=
 =?utf-8?B?TEZ3VGVLVDFpb3FGWG1ybXRPcnhIaXpraExDNHlUU3U4cWhneU1rZEU5VGFa?=
 =?utf-8?B?WXZaUGp2NGpFZmt6eXlwTjhMSUFYZ1JiLzh3eEJhNEdVTkxsaDBpSElyRWRx?=
 =?utf-8?B?TUMwOTdhUGtEZHJudThFT1JQbFFRTVUvTERrY0dhNnFDdVNldVdHWXRCWm1o?=
 =?utf-8?B?alFlMmpNN2dXeVRjNU9IYUFvaFdyNC9jWUZOUlR6UVVvSUdkejUzYll6L2Y2?=
 =?utf-8?B?YVIraDVteWFBZldreXhUNWF5RnZRQzE4Uno3WDVtRlhBVmRZUnV3N0NNRStX?=
 =?utf-8?B?SUlzdTViRmdVc3czdE5vOE5jdXY0bkxiNzQ3bmZ5ZkE0QWcwUG52N1RvZmEr?=
 =?utf-8?B?NUdwaTh1OWpwQ1RvVEs3R0dHNnBTTzdKaDZMdU5FZnlnb2FxTkpIQ0V6Y2ZI?=
 =?utf-8?B?aEV5RzBzV2NnWmZCWTBmWTVzZlpTOU82UGM2NnkremFEUUd0azdtREtnUEpq?=
 =?utf-8?B?Mk1SYXh6TzcwV2w0V1hDeEZlb0R6Q3ZSVkhvc3lJblBvRWZqQjdLT2lKZlE0?=
 =?utf-8?B?cmlnZDNFd1Ftcm5LemV1ZE11K0lrdmJkTis1K0JEa00wZ1RhVk02TW1LL2FG?=
 =?utf-8?B?RkJ2SFdQT2pkV2ptUGlDeWtYbEswVjkxN3FHUHViRUZUV1BUemNxQXV3NHpP?=
 =?utf-8?B?RFJrRktwRU5MRFRNS2loK20yRmxBSzRydHVNTXpnR0ltZGhpS3JQNHBvRjZv?=
 =?utf-8?B?NWpDdGk3SjdHSnl2YS82WllTS2M3SEFEVzJpdEFHWnJKTDFLbzRxUDlxeTFV?=
 =?utf-8?B?NUk1emd1L05zaGNXK0crazNod1lxZWZxTjVXNlNmNW5BQzhtUWlFNEZLMFh1?=
 =?utf-8?B?OUdFSktWbDB3VDI3eHR1RDJEclhFY3MreGllbXJZbnNMck1BanlLUVFhcFNn?=
 =?utf-8?Q?bPcXGNtNsLvaM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2838f1-b49e-4720-e957-08d8b6cd0ae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 07:38:23.9654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BMPKkpYDoqs8k/qLP7pTH4DFhkLZwg6d72mbP2ZFQeZ6vcfJIyeIiA5XGRP/S4KSmKv6Bi6SdVrLdpnrC1jZjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5628
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpUaGlzIHNlcmllcyBhbHJlYWR5IGdvdCBhY2NlcHRlZCBhbmQgcGlja2VkIGJ5IE1hcnRpbi4N
Cg0KVGhhbmtzLA0KQXZyaQ0KIA0KPiANCj4gdjIgLT4gdjM6IHJlbW92ZSBjaGFuZ2UgaWRzDQo+
IHYxIC0+IHYyOiBjaGFuZ2Ugc29tZSBjb21tZW50cyBhbmQgcmVuYW1lIHRoZSBxdWlyaw0KPiAN
Cj4gS2l3b29uZyBLaW0gKDIpOg0KPiAgIHVmczogYWRkIGEgcXVpcmsgbm90IHRvIHVzZSBkZWZh
dWx0IHVuaXBybyB0aW1lb3V0IHZhbHVlcw0KPiAgIHVmczogdWZzLWV4eW5vczogYXBwbHkgdmVu
ZG9yIHNwZWNpZmljcyBmb3IgdGhyZWUgdGltZW91dHMNCj4gDQo+ICBkcml2ZXJzL3Njc2kvdWZz
L3Vmcy1leHlub3MuYyB8ICA4ICsrKysrKystDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5j
ICAgICB8IDQwICsrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIGRy
aXZlcnMvc2NzaS91ZnMvdWZzaGNkLmggICAgIHwgIDYgKysrKysrDQo+ICAzIGZpbGVzIGNoYW5n
ZWQsIDM0IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi43LjQN
Cg0K
