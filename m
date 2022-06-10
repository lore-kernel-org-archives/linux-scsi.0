Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4263FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jun 2022 09:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244438AbiFJJcb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347547AbiFJJc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2022 05:32:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C95D2AE1B;
        Fri, 10 Jun 2022 02:32:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QObjlGImhlJ0FRLg7NP9oYA5Bn64C+b39Nq1LTi5c1uwKe0DP5fExm+t3ahW4cBUTT3jLm6v5eiTFedHpRxVcW+7QkFKf4Vq9JykgAlgifVs8NTads4vVWfTKPGlw21K+/cG/aoSJoEIVAHR0SCJ5yoNIbLZSEfq+UqQCnr0bkHw/0X3SYx0j7mPsk+nCYmZ3KE+7RiN+e9HfUIA8t1vhBlnu8C5jQX42dWDQyuAUhHd8HpXubbkm11L7EXBpt4Rq5RSc64/5izg+PXPWx5Wlvtp/YrQV+qdbRLRtTfY5zJ0SpLLHjWKUqB4MQ2F+Rfc/3xR2xkbQjnirfO5P+04eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2+3fFr+mfRCbE6Nt0mO8anMvT/0PGJ6NPzSmV5V+e0=;
 b=anxAl5isiGbzzfPo6UEe5ak+r3OMPxVzcdNyD+tvR1a48FuZqWDaLZ+7G+KvyHKQZwhhmbsj0mV8M2Wh9TEaz4Fw1EA+xlSHDYW2HiObBF5DIJvNYFoJb7g9FXzKsEt1AgmNlKrHV6iLU/hSMi35vp5l4qDbJYUiwMzzsxWzyQYT71IiSebUWXw1f1K7nW/I6hHM7+pN1O27y23SxgquPNCuBzjFsxE/046bxG8QuqFZFmyWZU88T619i7JWF7HqFI0+KYf9TcNHYBTujQrC+AgmqLR8J5QAKR8YAoHuN2skjJQ3fBlgJhSG2cT6BYEPON8j8DrwVwvcM7M7aimYew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2+3fFr+mfRCbE6Nt0mO8anMvT/0PGJ6NPzSmV5V+e0=;
 b=KWhbMcFLx3h2KE7O8hi2NdUoa4Kuy2xv/KQdjee3K6PLnSy0msF6waQo40923RyJswnsOsfX6csC0E8Z/KSkyLQtwshVOVqGBqg3gvW0HKdMZivkGPBnWAAX9VYqb88sV/rI3WwDlfgUx+8mpBOahApw386YS9PFr2VUhL1i++SBM7p7N4cGUd9G3TO4Y9dufKuO4Oasp3El5VXzD68Q74tX9OMT6YfTR8y33xHVSMdgGmPgrg10uZmEkwlNH7TNRkthCJ9+tyn7XD9PfW0cpZFVXB5Wf9BG+aUquJYCZg9QugufiqPCIk3oscwVIGVBUc7JmW6H2UkJxRet61kIoA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 09:32:20 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6dff:6121:50c:b72e]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::6dff:6121:50c:b72e%7]) with mapi id 15.20.5314.019; Fri, 10 Jun 2022
 09:32:20 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: blktests failures with v5.19-rc1
Thread-Topic: blktests failures with v5.19-rc1
Thread-Index: AQHYfFwe8PMwMXtEZEqIJFDj8WJWFa1IXnmAgAACxQA=
Date:   Fri, 10 Jun 2022 09:32:20 +0000
Message-ID: <19d09611-42cc-5a81-d676-c5375865c14c@nvidia.com>
References: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
 <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
In-Reply-To: <717734c9-c633-fb48-499e-7e3e15113020@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddf412ae-8ca4-43ae-b123-08da4ac41e1e
x-ms-traffictypediagnostic: DM6PR12MB4234:EE_
x-microsoft-antispam-prvs: <DM6PR12MB423434517AEFFBFA6BDBB9CDA3A69@DM6PR12MB4234.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OJ01HzZ0TqM3A+Dkp+x0D4P/spgMi9lZAg4V7bA2C5vCnO0FspTiZ2Ct3Izt9FfhoMxaG46njNaTt3ZThE2CbrHX84xtxAd25I852XD//rTz3Xui/e35HQyFAQ9rGiXSvsqHtv0lRnMHOPyfhbfpw/OojkfHuMSeYVWfaT6bLCa7vKey4tFtvNt4qq+eRi6rHhsyqfBrUjfVX5XJuxQJEIm6+qv6aVYSt+zDuvYVA56Vlzz06vJ2n+ROmMtwvG4Dma238/Wy5mD2J/L73vcN1J5qRbjtfMNy+opTGOxPS9lVQtRBqTELeODSeBpZkwV3i7w90RFoSgvR9BxfUlwDluaX2uBKGmN/8BcJLxuPd5y2avA1KUUi5OfmXGn9LGwtaderCWWEx2E1AZY8WgYpr/KfhVoxUhKPE/CDHUJ7/4lsgaDtHAJTYeKoO25gVZl9lakgTrzqHnUo8rWyCz9MwNWdPltHc5BQRdxL5Vgbuf46DjRHLxLvC+6ip3ImwYlXirnwxjY3PP8/bqERzgw6OkD07nFDWm5w10gDO/qeKrdQlH9s8PkeVYOJxaYDzzmaXqV3XdK0SjpgOoJ4X0/QXMTLRrYFWu/dq50oQV8L4ojcy3OIKeIVOs05vTuBPOMdyocOnNSK+/wB6CXXL02+cJ+VXEVmRD4q7YyUDF6Jg/lyHDJpr8cEBvW2dLjFidLPKsdpzJzgtC6QU4B99MrYZcINP6Dgwoo/hrGW4bHXev4ZOGL/58sDl90bZqUn5aWmFR+R+bExXEo7UUeZuReG5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(5660300002)(8936002)(2906002)(71200400001)(36756003)(31696002)(31686004)(4326008)(66946007)(86362001)(54906003)(6916009)(8676002)(66556008)(66476007)(66446008)(64756008)(2616005)(38070700005)(186003)(6486002)(6506007)(83380400001)(76116006)(91956017)(4744005)(6512007)(26005)(508600001)(316002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UTl1eFlXbFFxQmxsNG9HWUR0dXYrVytPT1Fnd3FGQmsyVTlDVVpMdWhTdHk1?=
 =?utf-8?B?bk5VbDRHcjVCeEplUldzQ0NlYXFWbUtCbmpEZ3dTOGUwTGJZeDZOSGFKaWdK?=
 =?utf-8?B?NFNRbmtwNVh1TzJkWmtnSk5OVHZpWm5wdUx1cFkxaUdIWGlCb1FjeHJ4dUFl?=
 =?utf-8?B?T05zWVcrOFh3OWhDbFdFZEhINjVnVVdlMk5nZTc2bk5OaklXMGg4SnpHc0dQ?=
 =?utf-8?B?ZGpBVWV2VFpzYkkzMElaSnhDRnpNa1Z3Y3dQN2xzeHBjdUYxTGhreTdNZGwx?=
 =?utf-8?B?RVNDUWJ3eTZwWkExcWtkVStvU3cvRkI2VzBvRVFzVVZjN0R0ZldhRXV6bTdV?=
 =?utf-8?B?QkR0c05aVXRkbDNQa0UyTEoyd1piUFZoT1BzM1Ivd2FQNUdUdm15NEJFS2d4?=
 =?utf-8?B?ck11dmNONE5XNU0zODVTNW5KWW5Qd0h3YThJZ3pHV1VWTWRmd0twbVlPN0tE?=
 =?utf-8?B?OFljTjl6YkNtSnh0WnppTzJmOVFrWkJiTDh5RXpiKytFbm04anFnTlQ2dzNR?=
 =?utf-8?B?alJXdTJBOFM4ZDZSY3pjMDdNQUVaRUx6cVJaVHBiT1FuNHlQUnVWUzY3a2Z6?=
 =?utf-8?B?ZzI1b0VsWERMbHpmbDdHcUxzYzZMaUNwUTRuMkh3aGVNRDgrdnVST0ptN3Ey?=
 =?utf-8?B?cDkwY0tvMFRhc3ovcFFVSmFwNXI5V2lZRXpGYXJOWTZJNkFxVDBYZ2ViNkcz?=
 =?utf-8?B?S1lKeko2U2EwTlArOEl2OUhkbmR3cWdrQ1ZjY0dzdXBVZVVDejcrNHZRMW5B?=
 =?utf-8?B?RUlqckhSTDgxNmMwVENuRGNKaEZucWRVQVlUUDVPTUVDRUdMS25KSkVWMndH?=
 =?utf-8?B?M1VHemRUQ0Zac1Z0dnlxZ3pVMWwvS3RYQUQ0TjFrbmlyb0h4MGZSejNlWmov?=
 =?utf-8?B?M0owUnlvSVN5elFyOWwyNnZNSEdweEhYWXRQRFpWQ3hrcWlJQ3N6V0R4VXNU?=
 =?utf-8?B?RFBtVS8wL0RFWnpMYkFsL3FJbUtIaWdKSnNoNmlMZCtrTzBCOG9wZkdoOW42?=
 =?utf-8?B?YlNYN2FleXN5T1diekFRVnFRZUY4WEY3eTVkenhPU1VYSGNsVXZVS1RsT3BH?=
 =?utf-8?B?MlBYV2d4SmNoT2JZc0I0RmdtNE1EaHowMm41b2hjbkFyeWFPUVZvK1RYZGpB?=
 =?utf-8?B?UUdWTTVZcGEzQXVURkl5Q2VmSUxWWCtPajhObGZpdnFIdGNsYkNET2c4SnBR?=
 =?utf-8?B?NnNCby9nVzg2RGxwTU9meUdzLzBjWk5ralgwbmJOS1dSSXh6Z3lkTFpFSmdB?=
 =?utf-8?B?N3NGVFFYcE5HdFB4eFl4MDZiMlV2U2syZTllVEsycUJ1K1NWZkY2MDFtQStK?=
 =?utf-8?B?NyszdHgvMDNYTzdma3RHWWI1QW9qMmF2WnM5dnJqcXJrNUh5VUVvRnFlVG1Z?=
 =?utf-8?B?bG5mMmNxWnZDTHhSdVhPUEI1Z0lIZTU5aklsMjRHM1F2M1ZrZFFpRGFTNnBK?=
 =?utf-8?B?VlVWNGg1N0dCMm1xbitYTExIVGFRcGlUeXB6M0d1SkpFRTNwN2hReVNDUVBC?=
 =?utf-8?B?eUpERWV5eVZad2t6ZE56ZDlMajEyU3kzSnZuTXBSM2IvbGFWSVdBV2NqZEVz?=
 =?utf-8?B?cGkzdzg3NDIvQ25kUUFvbVB5WlBsVm11VmJNemNBQW1qVG5Nb0hPTVJvbmsx?=
 =?utf-8?B?WE9DUTJ1UHRURldITXJ1eVBFY2VWbXdnUnZlZWtVRVBkVmQvaEFaRE93YWw0?=
 =?utf-8?B?VHNQaEpHYVU5cWFncUhxYWFnVzkwaWxHRHhSNVJtSG84RE1idkR4eWdXVWVs?=
 =?utf-8?B?ckk0VlRuYmxhL2xqbTJnUTlIMStINkdqamUvdVo0bHRIYlZ4QlJIRVRNOGtS?=
 =?utf-8?B?SjZ6QlQyam1WdUViRFZXY3FTdk5FQUpGUUpZTlZWQTFXa29XVlF1b3ZaQkor?=
 =?utf-8?B?alJ6bE50QUFJM2pXUzFhOXovTnR0MFJtYzBhbGxSZmJBWEhtNFY0U3lBeGFs?=
 =?utf-8?B?RjNaSzVIeXNpM3RGZEN4Q2tqdjAwSk5DNjBtdVpLQkswWWpDcVg3cUc5ZGFD?=
 =?utf-8?B?a3BBOHhHRVJjK0N0VVd3WllxRkZuNmw2blBhYTBjWGtiejJLU01jZXFsOTRT?=
 =?utf-8?B?eEJVOFVWbDVQZkYvZFY0K1VRT3k0QnltTDIrQ0tyOElxRTRXZXZWS3AyZWhF?=
 =?utf-8?B?REIwNHBFNVhmbktiY0N6SEdManlSSmZ1M25ZTm1xbUszMGU1emIwdldhMlpH?=
 =?utf-8?B?R3dFV290WnJoVXlzMU5UdjdodjdncmJGSzR4RjFkRW0xeUUrbUo1M0hOcWk1?=
 =?utf-8?B?NUhWcTIyV1N6SXFES25sRllsZEN4Z3BGRU5NQXAvYUFZcnZWc01aQmN6bUdB?=
 =?utf-8?B?VU9wTXlUaC9RN3luMnBEVlVBM0FQVmtjaTlyM3FSb2VMT3ZKMDdpUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D7241B6026E614DB9285F6779D58D02@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf412ae-8ca4-43ae-b123-08da4ac41e1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2022 09:32:20.5407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KiQu1k2/gjVBoncqElAT1v4sU5ymvHWMNZFYLx96oPwzFD5fnuCOYWHMbXlfOOyS2r77sPMsVizILwgQ8dKEiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U2hpbmljaGlybywNCg0KPiANCj4+ICM2OiBudm1lLzAzMjogRmFpbGVkIGF0IHRoZSBmaXJzdCBy
dW4gYWZ0ZXIgc3lzdGVtIHJlYm9vdC4NCj4+ICAgICAgICAgICAgICAgICBVc2VkIFFFTVUgTlZN
RSBkZXZpY2UgYXMgVEVTVF9ERVYuDQo+Pg0KDQpvZmNvdXJzZSB3ZSBuZWVkIHRvIGZpeCB0aGlz
IGlzc3VlIGJ1dCBjYW4geW91IGFsc28NCnRyeSBpdCB3aXRoIHRoZSByZWFsIEgvVyA/DQoNCj4+
ICAgICAgIHJ1bnRpbWUgICAgLi4uICA4LjQ1OHMNCj4+ICAgICAgIHNvbWV0aGluZyBmb3VuZCBp
biBkbWVzZzoNCj4+ICAgICAgIFsgMTU4OS45NzY0ODFdIHJ1biBibGt0ZXN0cyBudm1lLzAzMiBh
dCAyMDIyLTA2LTA5IDEwOjU3OjIwDQo+Pg0KPj4gICAgICAgWyAxNTk3LjIyMTU0N10gPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+PiAgICAg
ICBbIDE1OTcuMjIxNTQ5XSBXQVJOSU5HOiBwb3NzaWJsZSBjaXJjdWxhciBsb2NraW5nIGRlcGVu
ZGVuY3kgZGV0ZWN0ZWQNCj4+ICAgICAgIFsgMTU5Ny4yMjE1NTFdIDUuMTkuMC1yYzEgIzEgTm90
IHRhaW50ZWQNCj4+ICAgICAgIFsgMTU5Ny4yMjE1NTRdIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4gICAgICAgWyAxNTk3LjIyMTU1NF0g
Y2hlY2svOTcwIGlzIHRyeWluZyB0byBhY3F1aXJlIGxvY2s6DQo+PiAgICAgICBbIDE1OTcuMjIx
NTU2XSBmZmZmODg4MTAyNmY4Y2I4IChrbi0+YWN0aXZlIzIyNyl7KysrK30tezA6MH0sIGF0OiBr
ZXJuZnNfcmVtb3ZlX2J5X25hbWVfbnMrMHg5MC8weGUwDQo+PiAgICAgICBbIDE1OTcuMjIxNTgw
XQ0KPj4gICAgICAgICAgICAgICAgICAgICAgYnV0IHRhc2sgaXMgYWxyZWFkeSBob2xkaW5nIGxv
Y2s6DQo+PiAgICAgICAuLi4NCj4+DQoNCg0KLWNrDQoNCg0K
