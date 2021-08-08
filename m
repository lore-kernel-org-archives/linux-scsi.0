Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF72C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 05:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26A9B6056B
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 05:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhHHF4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 01:56:33 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:2839 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHHF4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 01:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628402174; x=1659938174;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=MNQaThKE7lXyCAOumG/I40H5IuZ+cjZlYivPfNbNImU=;
  b=b7TEsh3fFhcu7mJXF5fWa+aWZSAunQDfk2I8pP/tNLDMVBX9NW4c7jBz
   M3iU6wxQfemDJS36XBXP/IW1Q+xefNmTtNK4PnefMhQFZMlTNTcLBhrQ3
   UNerz54eim0KsnGzLSYD9yz/ZK0CXM3DfJxLC+Y79QKCrXzoPXT1zDF4C
   DMxpyKWpsckZMN330dZfnDkcIPUEQSWE4IBCH5qxThpxb3lrKApT4lLyl
   3sY3sj8w+a/JjBK4wIefmzCgG2XgqK0Y3X8wTKZgfFUTP8vb9VHCKauQa
   k70mBFi/RVXaWAGX0cF3s4cdJQj/ChYYTbyab5kfKQ2NAlSVPim7PBU8G
   w==;
X-IronPort-AV: E=Sophos;i="5.84,304,1620662400"; 
   d="scan'208";a="175810116"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 13:56:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWS4pdt+uuY3Ikpeaz8hA/SU2rUE0rWMtyCHZBz6TVEGaJROeVGF0pK0QqF2ZiYX7Y/bKanIB7iXlShbNDKvkg6OnGFOc5Mjjau3ga0AsjywfcxSdl5f5fi+a+NpkhqU4R3GX7U/UmtiDosnIsBuyxCTzLgPIKyoqIcQz3S4FXuLv+nqNdG63/51CU8Ssw36VSEh6L2xr0FAxPVOV4Y5puxr4t7Kdr1RFoYRv3CJ0l/9w7lLAaUhSyNRFQN8/aRGkEvbrxK1mMGBUelxBsU3qndw0sw5PdqFDMGwNz3FxfHU6iCkdDmvXxTf9llZcEBTE2cVrAdTzKjAia3Wtz58Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNQaThKE7lXyCAOumG/I40H5IuZ+cjZlYivPfNbNImU=;
 b=UeLxxmZPEU8yo6TenNlFpGfgRs5yrKNhTaIX/e60GvltvOwL2o4VDJ4wlFBBGUTs9OSmsCMesa9CzofbITGfuN6QHbMdwA7WcUtaKm24aFzXMXYtRM8VfJlOyZDMsrl9r+VFp6gsdqXgLxZMiCV24N80arL6Ztcw1Ty69gUhSGt1XwWzaHHROmSK7k085qYcn7FkujSfG6kPv2lyH3zIWdUse/a1k2AGrS61S2FZEZ5dPebqbInCrfQBF7mEBcuw4CpiwNI8Zi02OE9KAV7LMg8hS78kl1w4eUZH2iVyZcsG7Ztu028kblBif2uqGSpmts7UGYmtJvgAnS6RxZPPFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNQaThKE7lXyCAOumG/I40H5IuZ+cjZlYivPfNbNImU=;
 b=lP4f7Z2p4Hu9YtzsVe+ZoYtTf5p/jEZt37hjptcFfSOPC2B6RT0H1nH84Xob410TbGpaN/5sbew8lbsNlEWR3KMRVkbpcbEM8V6KE7La6NwJje8WKElxtiuG9BW2BOzqCODf5ucR3x4voG2F2TCF+vpSFnreKQ5rA7EjpGg6kAU=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4940.namprd04.prod.outlook.com (2603:10b6:5:f9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.18; Sun, 8 Aug 2021 05:56:12 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%7]) with mapi id 15.20.4373.026; Sun, 8 Aug 2021
 05:56:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
Thread-Topic: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
Thread-Index: AQHXio84XVNOs65jSEeqHkIvP9s4ZKtmp0MAgAJ2oUA=
Date:   Sun, 8 Aug 2021 05:56:11 +0000
Message-ID: <DM6PR04MB657589F482D2CB93113BDA0FFCF59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
 <cover.1628231581.git.kwmad.kim@samsung.com>
 <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
In-Reply-To: <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f4208f6-5982-4f85-d15b-08d95a3139d6
x-ms-traffictypediagnostic: DM6PR04MB4940:
x-microsoft-antispam-prvs: <DM6PR04MB4940C285F911B60F75CEDE85FCF59@DM6PR04MB4940.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TXUSV3gO/RJ3hbHKElQ4afzT2gCaboH2Fkx3pyZsiDswlz+lfrIdVkshMfEhi+a3aS9d4Mhxd+fFd8zoSMGFluhD5oxJE8cEVOMZCanqHTwykhTorO2PT68lTh1mmyWl3fYM1hNfwyP0gi5amH6uvF/QHcmcJbut6rAVb1geW0JrY4/1Wvnz4dj5aBdARfCI1273yMbyvH/zCaXNJGORaz7UZqPnvIx429t4DryY7uz500C4hASuGDAPh9nrpHGHsVu2HUqV5UnDReqKVSDfbYWhz8Fj0fKL3x2lws8F1lvw0p+FUeZ6z2gh4F17XIIST56ojC4XnIM7rI2J1uB42AAmiY7xjnQpyHk1ogkBz/dS0AA68otybmADrLi1wGSsAouepcxAuxvXWyhyt7dPo40xqY4bEECTP6iyjD6o3vcdK19BwEN9OypLbIh+d6srOHdEBtP8CrQVGH11YVyn/5cOD3HYvEwHHqsyjDkuNZDYbkzUvCutdQVqxF7vz5mDa91HiKF5YEdqHP+8+ZtBHOhHvHhpZf0BIsKGfZu3bp68aiA61WQT4C2P+O801vOJ/98wzg6EPH2WJAlAlSFy67T5w+b0kgwrllIyevQRthOEZP9GBanpvNlqXPs0+ZHxt8IB/GZIOjvLJYR3vmaneBOfxeoZrcEuhnm7mGHBwM3YLnhTrUXrGyXWciyl4518Ef57EeE77U7AQmwAMaSOQiFaqDapfxHzJKT42ndxWoo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(33656002)(71200400001)(66446008)(64756008)(66556008)(66476007)(66946007)(83380400001)(7416002)(55016002)(8676002)(8936002)(6506007)(9686003)(76116006)(7696005)(53546011)(86362001)(921005)(110136005)(316002)(26005)(478600001)(186003)(38100700002)(2906002)(38070700005)(4744005)(5660300002)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm9VZUhRVHJZa3hxRWVxaDVCYjB5a3RQYUlNUXdGT2sreUI3N0g1dHZ5Smxh?=
 =?utf-8?B?M1poS1BadWh0aXIzcG4vOU4rK0NUYWdNT2RUTWZYa0hpQTAwZzhpa3JuYUZM?=
 =?utf-8?B?dHFycjE1MTU2N0J0eEpjVGVxSWZMbTNicGl2RktFZS82QmhuTVJhSkVhVm5X?=
 =?utf-8?B?UFdxU2o5cGIxazFPbUdwalVQTFRKUW4vRE9qTXNCblJwaW13ZG9sOFZzNllN?=
 =?utf-8?B?bVZLck9hZGZYbGRNeTFMVWdEV3A3RGZJVS8xWnA4M2ZVWTBoOCs1TGFZbUh5?=
 =?utf-8?B?MEZydHRpRkVOT0xOUUp4Rit3VjlxSHc3cElPY0JXYk4rOWIvT0YybDVhRGhC?=
 =?utf-8?B?WUhVWTRhQTRFN0d4RE90Mkdaejh0VFZ0WGljZ1F0QTk4TzkwOWhSdG4xbXN1?=
 =?utf-8?B?Zy9NRk1iVFNJRlAwdWhWQTZEZS8xeTRwZjMzR3dpREk0eXpOdG1yWVJ0SkFM?=
 =?utf-8?B?UXA1RmxBbURYYXNoMlhJT0cxcHFvemg5Lzh6WHM2cEIzazlqaE9IZktjeG5h?=
 =?utf-8?B?c3JZWHMrK2dUdGtwVENKUys5d09TM1ZveFFHWFoxcUFPRWo4WWlMcGF5NXk0?=
 =?utf-8?B?R3Bld0I5R3dHRGhBWlFVckRJUGhEZHRhVXYyUjQwOXlIQU51L3F0QWU4eGpM?=
 =?utf-8?B?UGJxQU8wbkR6V2FHN0dnWjZSNDhUU2hRdW9JRGpHeHNFZjcvaWZMM3ZHbWtt?=
 =?utf-8?B?ZUxmOU9wRGoyU3c3anQ4T2QwdThCc2tDbU1LSHJVMDViZ21FQXpLOEtMcUIv?=
 =?utf-8?B?Q3RsVll5STN3YUowVi9FTFpSOVNHb05sWEtaSXNUKzBSL21iQlBuVlZOZHpr?=
 =?utf-8?B?NDlnSjZEZk5BNzJZVWVBRzlLcVQvSE45RVJWd0lvOTBlakZ1QkF2dUEwV1Ar?=
 =?utf-8?B?TEJWWlE5RzkySWxMYTZiZmRrYkNSM2R1eUVLd0UyRi95SVU2OTR5dlB4NFhk?=
 =?utf-8?B?UzQ0N28ybzRSTENHc1dMczNBTU5kMjVOWVhVWjFNc1NnNHBZY0xYdmdZQXpp?=
 =?utf-8?B?eCsxdmIvbi9UdmNET1dReDhHVmhnMWowSXN6aHoySFJDcVhXVUhiQkR4WnVP?=
 =?utf-8?B?RHRjckdyeDVURmxXd1F5Si9hZlRrcHdkRWw2amFUOXVoSnV2L1Bldm5uZmpU?=
 =?utf-8?B?aDZjdXNyYmdYYjFPWmJKVE1TdzU2czFUNEFaU0pOY3NQZkR3L09ZT21SdDN5?=
 =?utf-8?B?Nzk4NUZHUW1lY2dDRnhaeXlLYTdmTFVLRFNNSHp6dWY0dVB0YnJTbFEzbmJy?=
 =?utf-8?B?OVhERnpmN1FJa2pYN2tHeEZIL01kQS9FOWVoYmNvN1V2cHZlLzRpMGxlVUs3?=
 =?utf-8?B?OCtsTDJKaUtsVjVnZm9sUDZRMWh1WXFsSnliMlRYc1ZUYkFIejBTSGhtSENz?=
 =?utf-8?B?SXA5V1IxejVTMHBpZ2xzc3BxQyt6WjMrekxFakQyKzNOY1R5NE5QdDhyZGty?=
 =?utf-8?B?OGhPWVZYMDByRkZMS0YrUTVDV3lqQ1BFMHRlN25SYURMaUtBZnlDaS8wbWU3?=
 =?utf-8?B?MllTWTI5eWFwVnVXaHhTeDNnd3VSRStybzQ0TWd4N3N3ejNEVlhuTS93dGtP?=
 =?utf-8?B?NlN5cVJOSldxTDlEeWVXZWxJTEo1ckZ1cnFOd2h0MkxCNjEwUFFBNEFYS3Yw?=
 =?utf-8?B?QStKR1VXTTk3aW9VR25zVkVPN3QzZkh4N0JEMUpDNW02WCtTT0JSY3B5QVRM?=
 =?utf-8?B?ODBMRERYS29rcGlVUzNnb0s0QllrdnRnbFZYWTJlTXN3WU1nOGVsRFRUc0tv?=
 =?utf-8?Q?dWci1baq/VSLo7kkvBYGgahrcmBIo3L1v8MvN5J?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4208f6-5982-4f85-d15b-08d95a3139d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2021 05:56:11.8419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IVjA9NgAKm0ADMILcybchWc3wbjcvWKAli0rJz90khYfF+L5Qy2OmmOSTQiOZLn+UZAorcfwY95i2CcgedEMAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4940
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiANCj4gT24gOC81LzIxIDExOjM0IFBNLCBLaXdvb25nIEtpbSB3cm90ZToNCj4gPiBUaGlzIHBh
dGNoIGlzIHRvIGFjdGl2YXRlIHNvbWUgaW50ZXJydXB0IHNvdXJjZXMNCj4gPiB0aGF0IGFyZW4n
dCBkZWZpbmVkIGluIFVGU0hDSSBzcGVjaWZpY2F0aW9ucy4gVGhvc2UNCj4gPiBwdXJwb3NlIGNv
dWxkIGJlIGVycm9yIGhhbmRsaW5nLCB3b3JrYXJvdW5kIG9yIHdoYXRldmVyLg0KPiANCj4gSG93
IGFib3V0IGV4dGVuZGluZyB0aGUgVUZTIHNwZWMgaW5zdGVhZCBvZiBhZGRpbmcgYSBub24tc3Rh
bmRhcmQNCj4gbWVjaGFuaXNtIGluIGEgZHJpdmVyIHRoYXQgaXMgb3RoZXJ3aXNlIGJhc2VkIG9u
IGEgc3RhbmRhcmQ/DQpUaGUgdmFyaWFudCBvcHMgSU1PICh3aGljaCBoZSByaWdodGZ1bGx5IHVz
ZWQpLCBzaG91bGQgYWxsb3cgdGhhdCBleHRyYSBmcmVlZG9tLg0KDQpUaGFua3MsDQpBdnJpDQoN
Cj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQo=
