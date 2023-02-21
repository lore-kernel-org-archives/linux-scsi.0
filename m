Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC23C636D7
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 18:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBUSPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbjBUSPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 13:15:10 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875382194B;
        Tue, 21 Feb 2023 10:15:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VPesbu4qSd8pk6odruXj4v0Cvcciyov19xTMHbTkuP//cgpX18yZRpfGKiubs6dqFoqMKQgHzWYjabytSC3ftFLSHKZZTH2Q2f/FHzx6lkABfiGMPwbTJCIrbldZVrXLTctx/HEn1lNemQqA3rrnlDMgp6SWPwO2j+AOI/jdf379BJmReg41jt7YjSyNtuYK5KsNe5vhBW/IHEx9ucczVSNEX/PM5suJIaSOf1XIm6XICvX2wHgTzqQ1A8pvBzSLZznWpNh+nLr2SbS8avCY0X1avvDbcYGr6Xqmwa+sZ6w+nxHc8iWAMLjT8Zo/L8x66GIp7hzwIO7XQq5RWX5diQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4y6MCXqOpwjylxqK7uY1N5bXeFdWBeS66wtZq4LeLdQ=;
 b=ioK/126jQ8tB5fxFL5W0iGONFSw9pubdjSiufbug+l/rFg65XlnMcrIgBKLD+3LLO1QJvDnqr4HeWWRKUZt4U67aM+aWc7ma8/0i3wAD+EY2o26r/PBlrAqh6HgAVhexkDP04TZGlyEPXx6ahYt50czUAzXoeN37YO5Q68oASNamaf7osvSr+20/FgPi25ibJm8D6Ni+AFmg5gBqt+d88c+3yEU+6RAfGLBOR0aSCy7a6VJCds+QBHLAiur6Xxk+7zVKGFOY2ejxZGRvjxQZWVdy3F3GDLDX8FmspOVMtz07/UXAgGbpJNe3dLECYt86ff9r67ODLjGu6SXvQPTTEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4y6MCXqOpwjylxqK7uY1N5bXeFdWBeS66wtZq4LeLdQ=;
 b=Nj2+LxIt/tvexQDFZ0J7O72CkIxH4GRhQ5tXKidOFatZmdq0C9Kqsq35SLlfldvhjlIOma8/Rk9gn7uUmQTBXwc+p/JdG3AC0mS1aVdUyUGnBKLXk+Qv4ZJSxnECIpnD8mk3AB572El4bBwBSKU6H4bFkY7cuvvpJ4vAEhQ/TLzH+1MMttOJYcNAI3FrhK9aRCBQUtDW1MxAUpi/YIzPuvgSoU94sdU5HJK2B1G/YBGXQ06fqQWsfNC9lY5/IUwEBHLF339Uj0xPMILWN8+k9b/hkxQz9hY63GEEj/C5Fn6duyk+dBBzCbGoqhkqjq2LE/0vq04bTVl5FOt7rPaL3A==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 18:15:01 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6111.020; Tue, 21 Feb 2023
 18:15:00 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>
Subject: Re: [LSF/MM/BPF BOF] Userspace command aborts
Thread-Topic: [LSF/MM/BPF BOF] Userspace command aborts
Thread-Index: AQHZQ35sKPIta20fBkeKrCWOajq9w67ZudcA
Date:   Tue, 21 Feb 2023 18:15:00 +0000
Message-ID: <6ba38fe5-ed51-7ec9-df06-0526853269e5@nvidia.com>
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <e7b781d8-d5a7-cf7f-f681-c116fbadfd01@nvidia.com>
 <e83ee317-9b4d-6b51-dc0f-25c54cc69c94@suse.de>
In-Reply-To: <e83ee317-9b4d-6b51-dc0f-25c54cc69c94@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|SN7PR12MB6813:EE_
x-ms-office365-filtering-correlation-id: bafca0a4-f968-4498-8f05-08db14378bf6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xK8YkE/tXcj8+z7KsoetMeEeaUxg58BYccOZj42Qt/1ZQ6VBLq89DZfErfkVuacqnhT4iF3ihMtZr9piYRlD4Ai7NfyIpU9wuP9rPMLBK85wJecMvt/7KlzhfPxvkFualGUovAa5iCny8cCfp0VsGXxbcCYcbzD6a2ugBOO1LjbC04Ulp/lMAyn5LAqidJNCwS5jbMQn5z+0sZQemZy0sBqI8fFWHHy7f/rBETrNFJyQfAjO1eJiiAHNuaiFz8Lqo4ncbiUEt/AkjwdzBcdXOZjmlGK6UiyWzEq04EdbkDTKhGCcMju9v+SdgUjoeZ4QvmP4f8wQQR1F2KwRkXMVCKns1NDDxIqEAUyUz/rfEkA57URGy84mipmxEmRuwEIpcSpk5aY5Iv7LDjMShodehb7ox+6XOmaH5t6n/+U1Q4cOGR3Pt7u6ROsKIUV4rhWbts9q4Fj3QpDpaihBANChq/4QVozgzBzYvfRJIjWh87hVBT80WSedzXb9OAchcZ8f0TOUtlBD+0vOp+zswZlY8iKDY5+SFS/lpKc+FahjGtMjSYU5b/J8G+SgjkUJjL/cOo1E6wdCUTqA05tuz+NurWG6g81LqoAOwGCSZMKnwoy2B2/y2W3LV/MvvTGiQETelmqXTKzy1q9GOez/WPBVPCOAu1YH4CjF/crFv4htJuB6RI2S2GSbK7MYFgRWdw0+Z8xW49tulLvHSdZbsSqdgudre6OWG70qnqV8ekhUv6tyow6ihMk8y4xZHZcVPhYJLpVjJC/E1kIoDz3t4VIiCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(366004)(136003)(39860400002)(451199018)(83380400001)(53546011)(86362001)(38070700005)(110136005)(8936002)(478600001)(36756003)(5660300002)(31696002)(6512007)(6486002)(186003)(2906002)(26005)(6506007)(41300700001)(71200400001)(66946007)(66446008)(122000001)(66476007)(66556008)(76116006)(91956017)(64756008)(31686004)(316002)(2616005)(4326008)(8676002)(54906003)(38100700002)(66899018)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2JNVUM3UkZraHYvQWpSSVdNeUFGSjJ0ZGdNYzlxN25Cb0Zucnd0TmVlaW1S?=
 =?utf-8?B?Y3orQkdnaDZUVmFuSFc5VTNGM09jYmZoQmREeWFOcEUxSkhKYmpTUmt4MG5T?=
 =?utf-8?B?bTJoYlNyb2tGVFhiNDZ6alg0NmhXQ3F0WlNJS0Q0aUxJVld6Ym5oeFQwRjRK?=
 =?utf-8?B?N0hVZzVWWkc5Z0FsQkNVMnR5VHU1UVYxTUNRYmgxcmNkQnhoNExkczZwNVJG?=
 =?utf-8?B?TjNvZVlOZUpLd0hpLzNIVmdjZWRMb0c2SEZyeUo3U3g3L3BuSmt4QVczQlBG?=
 =?utf-8?B?NVVVQzB0b3R5QTNqQm4rSGJOZGZCOHZDMDZRdHcrQnlzMHNPTDhud3RPejVG?=
 =?utf-8?B?T29WT25JYkhPMi92NXpobjJwODVhYUh3T0ZveGdqWWxGaU5GUjFHVi9lbUdP?=
 =?utf-8?B?SCtNTUJsQ0R4bm5hWGRuYnlGN3VOalNWYXJDd3hoaDBEaU5qaDg5aGo4Ui9S?=
 =?utf-8?B?L202RU0rZzlsOVRJdGZiQ2tUTUF4NmVabkhoSTVuaEpSNzlkT0F4Uk5qZktn?=
 =?utf-8?B?Zk9yQjdDNnBWUW1keGV0cXpHMCtIQ3J4MUxTRGVsOEU1ZHNRcUNkWnJBc256?=
 =?utf-8?B?TkdsdDZRTGR1R1BmM1lQQjZ3Nml3ZCthT2ZndFFhY2MybDVxTzJlTzAxZThr?=
 =?utf-8?B?ZzkvZ0ExR3hrdnZjL0dINVdRa0xvRC9GMStwN2FqT2hpK1pjUFpRdHdONmFH?=
 =?utf-8?B?NWlJZXV4a2c0Rjd2NnlMUW9DcTF6WlIySjZiZ1hHWk5EbXA3dktWcVdHalA4?=
 =?utf-8?B?RFhIVnNQWFRubWVCdk9ncU1FZC9uR3NaaVNjaTBadEF4eU44c1ZZQVhwTlk3?=
 =?utf-8?B?dlJxT21GNS9BeUtLRjZjUlN5S0wvcXFhVWRSdUVlekIvR3MzMHNGaHVlSFph?=
 =?utf-8?B?QzRRMk1CQkRTSTZYT0F2bUZCV3JrbjZXVGtGM1I0NmZrZEpsQUMrZzJ6K0hk?=
 =?utf-8?B?Ujhneks2NUlNdUVEN0pkTG1UU3NGeVZtRDJITWszWTBxMmVEaXpoRWQrQjB4?=
 =?utf-8?B?VWVHYnFCZnAzS2JXcDN4ZVNBTDZFL054UGlWazZuOU5rdXhxL2tEaVZDOGYx?=
 =?utf-8?B?cWk4Y3k5VE5GYlhyWkhVenMrRkdBK1NTZWg2UUU2SlpqTnNkMGtrcDhCQlFI?=
 =?utf-8?B?YllXT1dHK3MxbkFrRlZOUkJsY0ZqQUU4d1RXSXJXRzJiV2VSL1NRWmV6TnpD?=
 =?utf-8?B?emhMQldpQmVRblFXRXE0ZVg3OWNXSmxDZ2dEanVxOUhYOVJpVFJXU3h5aVJt?=
 =?utf-8?B?ZVpmTytIZjVUbTRLR1pRNmUyTlljUWdBUkkvOFFCUy9Wb2d0MGlscXFMM2ls?=
 =?utf-8?B?VXFJc0RQWURjbUEvOUNVU1ZLaVVLUllwL3dDamxWNUphNVovT2FsZkN5WlhM?=
 =?utf-8?B?bnY3emtvZTBPVXh1aGxjUmE3a3I5Z2drTXlIL29uMGpZVTlNRzdnS2JEWjRk?=
 =?utf-8?B?aXBrOStmUGIzYjV3cU9hQ0NlSU90cG5SOFZDQ3BzcmVnSG4rSjBOeG42VDVj?=
 =?utf-8?B?OGp2OE9yUEt1ZitnRHZjM0RDZ0FtM3cyY0Q1M1NKS2VWeXVSN2l3ZVJrSFha?=
 =?utf-8?B?Y3p6K05tSmRUNWU5dVJQWVJaakxWWVVzdTh6SVJlcXBkTUtHS1l3QzFXVXNH?=
 =?utf-8?B?UWkzYmpsRThpNlRmaXFIWkd6SEdVNXZybmdQY2VhOFUxeTBDTHRTcEpGaXE4?=
 =?utf-8?B?WlJUQ2pLYTFXek1SRGNYWTVtQVBSNVkzb0FkTS9mVmVIbWhRVWp0bjlCVzBW?=
 =?utf-8?B?aEwzR3hFWFVSTG1yMnNpa0w4akF4dEVxbWZidGFTUUFidkhlWUFRNHh3Z25J?=
 =?utf-8?B?cTl4eTNxVWNwcS8weHNkNUZQMWFLa29PQzk3enNRbzRkMkFqamxLSDQrY01a?=
 =?utf-8?B?c3RRTWxSR2krWXFrTzJmR25FNXNSOWlJSVdkNHFlcE1LaDFmcngwbEp4SFZ4?=
 =?utf-8?B?SXJVTCs1Z1BlbDBpV3U5NGR0bU9jd09YNkdXUER0dmxiVWQySUpGOEJQVTBQ?=
 =?utf-8?B?Qm9WSlprWGpGV3ZkSVNLMEtocUxBQnVSRVQvaVg5dEJWbnNsR0dBUnlDdmtT?=
 =?utf-8?B?TU9DZmR1Ym90Q1hGaDJ4bVlIU0VxeHZjUFlhT3dXVk9hZy9qQWduR0dhUERW?=
 =?utf-8?Q?83oHHf3rT9cghPV58mrMQvPu/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEC08377954E5344B39C1ADE5F629927@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bafca0a4-f968-4498-8f05-08db14378bf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 18:15:00.6849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZH5lEgHlo3HbRwrHu0JFJXi+lRnkjPPWp86BouLaL18YWa1SUEQ1rQzm6AQCL6AlkneqYqGUqfKxiic1pnC0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMi8xOC8yMDIzIDE6NTAgQU0sIEhhbm5lcyBSZWluZWNrZSB3cm90ZToNCj4gT24gMi8xNy8y
MyAxOTo1MywgQ2hhaXRhbnlhIEt1bGthcm5pIHdyb3RlOg0KPj4gT24gMi8xNi8yMyAwODo0MCwg
S2VpdGggQnVzY2ggd3JvdGU6DQo+Pj4gT24gVGh1LCBGZWIgMTYsIDIwMjMgYXQgMTI6NTA6MDNQ
TSArMDEwMCwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOg0KPj4+PiBIaSBhbGwsDQo+Pj4+DQo+Pj4+
IGl0IGhhcyBjb21lIHVwIGluIG90aGVyIHRocmVhZHMsIHNvIGl0IG1pZ2h0IGJlIHdvcnRod2hp
bGUgdG8gaGF2ZSANCj4+Pj4gaXRzIG93bg0KPj4+PiB0b3BpYzoNCj4+Pj4NCj4+Pj4gVXNlcnNw
YWNlIGNvbW1hbmQgYWJvcnRzDQo+Pj4+DQo+Pj4+IEFzIGl0IHN0YW5kcyB3ZSBjYW5ub3QgYWJv
cnQgSS9PIGNvbW1hbmRzIGZyb20gdXNlcnNwYWNlLg0KPj4+PiBUaGlzIGlzIGhpdHRpbmcgdXMg
d2hlbiBydW5uaW5nIGluIGEgdmlydHVhbCBtYWNoaW5lOg0KPj4+PiBUaGUgVk0gc2V0cyBhIHRp
bWVvdXQgd2hlbiBzdWJtaXR0aW5nIGEgY29tbWFuZCwgYnV0IHRoYXQNCj4+Pj4gaW5mb3JtYXRp
b24gY2FuJ3QgYmUgdHJhbnNtaXR0ZWQgdG8gdGhlIFZNIGhvc3QuIFRoZSBWTSBob3N0DQo+Pj4+
IHRoZW4gaXNzdWVzIGEgZGlmZmVyZW50IGNvbW1hbmQgKHdpdGggYW5vdGhlciB0aW1lb3V0KSwg
YW5kDQo+Pj4+IGFnYWluIHRoYXQgdGltZW91dCBjYW4ndCBiZSB0cmFuc21pdHRlZCB0byB0aGUg
YXR0YWNoZWQgZGV2aWNlcy4NCj4+Pj4gU28gd2hlbiB0aGUgVk0gZGV0ZWN0cyBhIHRpbWVvdXQs
IGl0IHdpbGwgdHJ5IHRvIGlzc3VlIGFuIGFib3J0LA0KPj4+PiBidXQgdGhhdCBnb2VzIG5vd2hl
cmUgYXMgdGhlIFZNIGhvc3QgaGFzIG5vIHdheSB0byBhYm9ydCBjb21tYW5kcw0KPj4+PiBmcm9t
IHVzZXJzcGFjZS4NCj4+Pj4gU28gaW4gdGhlIGVuZCB0aGUgVk0gaGFzIHRvIHdhaXQgZm9yIHRo
ZSBjb21tYW5kIHRvIGNvbXBsZXRlLCBjYXVzaW5nDQo+Pj4+IHN0YWxscyBpbiB0aGUgVk0gaWYg
dGhlIGhvc3QgaGFkIHRvIHVuZGVyZ28gZXJyb3IgcmVjb3Zlcnkgb3IgDQo+Pj4+IHNvbWV0aGlu
Zy4NCj4+Pg0KPj4+IEFib3J0cyBhcmUgcmFjeS4gQSBsb3Qgb2YgaGFyZHdhcmUgaW1wbGVtZW50
cyB0aGVzZSBhcyBhIG5vLW9wLCB0b28uDQo+Pg0KPj4gSSdkIGF2b2lkIGltcGxlbWVudGluZyB1
c2Vyc3BhY2UgYWJvcnRzIGFuZCBmaXggdGhpbmdzIGluIHNwZWMgZmlyc3QuDQo+Pg0KPiBXaGF0
J3MgdGhlcmUgdG8gZml4IGluIHRoZSBzcGVjIGZvciBhYm9ydHM/IFlvdSBjYW4ndCBhdm9pZCB0
aGUgZmFjdCANCj4gdGhhdCBhYm9ydHMgbWlnaHQgYmUgc2VudCBqdXN0IGF0IHRoZSB0aW1lIHdo
ZW4gdGhlIGNvbXBsZXRpb24gYXJyaXZlcyAuLi4NCj4gDQoNCkdpdmVuIHRoYXQgdGhlIHJhY3kg
bmF0dXJlIEknbSBhbSBub3Qgc3VyZSBpZiB3ZSBjYW4gZG8gc29tZXRoaW5nIGluDQpzcGVjIHRo
YXQgY2FuIGFsbG93IHVzIHRvIGRlYWwgd2l0aCByYWN5IHNjZW5hcmlvKHMpIHRvIGFsbG93IHVz
ZXJzcGFjZQ0KYWJvcnQuDQoNCkFsc28sIHdlIGRvIGlzc3VlIGFib3J0IGNvbW1hbmQgZnJvbSB0
aW1vZW91dCBoYW5kbGVyIGZvciBOVk1lIFBDSWUgYW5kDQpJIHRoaW5rIGRpZmZlcmVudCBjb21i
aW5hdGlvbnMgb2YgdXNlcnNwYWNlIGFib3J0LCB0aW1lb3V0IGhhbmRsZXINCmFib3J0LCBhbmQg
Y29tcGxldGlvbiBhcnJpdmFsIGF0IHRoZSB0aW1lIG9mIHVzZXJzcGFjZSBhYm9ydCBzdWJtaXNz
aW9uDQpjYW4gbGVhZCB0byB1bmNsZWFyIGltcGxlbWVudGF0aW9uIGFuZCBtb3JlIHVzZXJzcGFj
ZSBhcHBsaWNhdGlvbg0KY29uZnVzaW9uLg0KDQotY2sNCg0KDQo=
