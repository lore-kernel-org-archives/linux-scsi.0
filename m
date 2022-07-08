Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A662EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 23:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiGHXvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 19:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiGHXvr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 19:51:47 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B035A545CD;
        Fri,  8 Jul 2022 16:51:46 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5691CC0D66;
        Fri,  8 Jul 2022 23:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657324306; bh=z9api/D5onMmXX558VGy64hrXxIjmIDnw2cKpd6djMs=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=FJ/MUT7M9Rn+C0ovX5uHFXqMxHV87iQ0FdA+jL9+MdG0ekV3nbW2NU7x2W3pzrAiO
         VzIx2SW5Gt9dL9z1Z6YStrCAkFoL/jsS600mAuYTXe71VEMS44T3x0XqvSGceKHmmH
         NQFxV7mbCS5W21GL/CacK3UX5JlLVJJAl5jDQ+1UkNMwFoLq0nPY6FMMZXE5dimkt4
         z/F0ve4BeSzX9D5sWNluzg1/VPtlrPGfShPfk3Wmuk+OsqSSaeUqZcYC2et1qlZCOC
         IDOJoEInFE4funH0wdZKO+2x30wezg2zC3owhuD1gwZgv+KpCryo5nxNpEtBq6iRg4
         yKg0nvtDw4ceg==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3AD0FA006F;
        Fri,  8 Jul 2022 23:51:44 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 140BD4002C;
        Fri,  8 Jul 2022 23:51:43 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="sWUmKu4N";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaRO21Np/+ZtLeyz9OZEOJYtFCIRmZBOd1ok/GUOEscslG6x/MVo76x1BUGEjxbsKCVdc4zQnRqmVv5GddU0ACprP1Q8suN7vSluilDYTKUnYYAmrNKQ1htoq3FTNmuIcRZzen+B49fVCbFGQMq/EK0cn0sRF1eLaKJ0ivRDR/DJZnQpJaGVzAB9b8Vg/cTT5yL1Zt3v2VWlj0a67UV+g6z9Rm+YwRCUoQmyORjrpU9342qYwGACJ++C+VUVFgiirzzUdJpPjWkElQ4Odu5ctHzo+H625/sbkQjsKcBDsvhFRZGhaHYpSvpXLpSP/RPlBPdYqlX02GtnAWyWIMHIyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z9api/D5onMmXX558VGy64hrXxIjmIDnw2cKpd6djMs=;
 b=HAWnagf1cy9kwT8VpckaHa5BlQ2FckDL4Nze0eCU2U0nI+5VjF2am0Qr8qPj/c7lxLOt3QnQcCN5X5Mv35HU4ahJvDqzqpbhxdC0n8f4vyNvNRRwPm+j68goEPFhQaB/bvWaCaSLFYkRtxlSdcA6kJUfe+zL3BttUg9/95QosONSyB9CNn+w8eA253690pGIWMeY7o0VALFWJquxernT6KSuM3/20gOxeScChX5WHPMgA949/6yAjXKH32oDd0fT+OSkhdwKlXVKJY22XmZ/yRw3/GpSBaiSQaqEdrphoztG5zV920RJU8ks4U9TKAJbHM143FBGH2JAIRwoiGzXJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9api/D5onMmXX558VGy64hrXxIjmIDnw2cKpd6djMs=;
 b=sWUmKu4N7CEnYtlML4BTR+cSd4G6xGr9lY3wgzWfcFI+f2S/TGvpss1cX1iQj6bNu4++RxiT0rwqbuBR+kMQ2JEo6kQSAVMRk5zBz12u6iAsUqVs7eRvR6gEnQcoO6xWDU6ra7kIOzal0LFoYfwwziiIZRO7dZf8xGa6XGmk7lw=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB3889.namprd12.prod.outlook.com (2603:10b6:a03:1ad::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Fri, 8 Jul
 2022 23:51:38 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 23:51:38 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/36] target: Return Function Complete
Thread-Topic: [PATCH 06/36] target: Return Function Complete
Thread-Index: AQHYkZEE1a61PxgizEShfWPvH5eQe61y6W0AgAI+xAA=
Date:   Fri, 8 Jul 2022 23:51:38 +0000
Message-ID: <a20da7c6-3903-c193-2eac-41d9cf053f60@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d25dbd79f4234f5b0d7574cc1ba02e42e3537d81.1657149962.git.Thinh.Nguyen@synopsys.com>
 <20220707133428.GD23838@yadro.com>
In-Reply-To: <20220707133428.GD23838@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf5ff682-1907-4e0d-d65d-08da613ccca9
x-ms-traffictypediagnostic: BY5PR12MB3889:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iojdp6609tsWs1IrH3JCFaRpwgYFoa5gCpGhdXGbC+xL3WOz5lWUEO1cQaRu0BfqzmbcjGkvu3KW0ynAaVaCsskrlZDTfI6vzZnfsbp9FMA/PqlPyG9GQMb4cVGFsF+IpRYZsWdwBeYIvFO9EuWLtV68+nU/Rp1ZbCouagQkNOtmuSy7u4GDsoZyD2YdbOiKQhLWAnzqauWlBrPwaXSFDeOUDHrdJnWa52CfRipRtylrjdYaXHYUa+j5qIlGW37UjvUKXORK/G5UZYX1qi/pyFlCjSD1WMtpMGZw70Jo5NnXf03hfAbUZJDkTc9JIqwpOJPdTUKT3kRz4UGLwb+htCwrRtL/8+HRZbwb+5lQXZ21d6yow5N8uAkIraVoM9Ug9M3+Jvx9M2m3xODrVbUQXYCLpGGJtDc4WYmIKvPhQSthY27n/MF7m1NBmml66sYnOvhVuCVWHTIulSu31Zechor1sQWZJi6gtDcjWvP+k0uw3myCBZnx65NHq8uE+rk8NZtvLh3mb7mNHrpe1gNCmQNH9FGBxiUT5RG/OQ6obCju42CQPflOpn5Pg8cpoCEZM0filwgQXNHF+9HZarGNQ59kOhYQb0aHeAVtRLLDswPm6GlOKoST28uKgXKY4wNitMz9JKH3feAp1Va7MpNNXT+AkppNYExU/tttbGzHw5anWSiXzUajYIQ6PZtimkZM57ux47ZJfgaa9KKbV15j8UsT0b8BqgU8AmzrVa1HP09pIey3lpxp4CXqVk+7XUq+p9yk5/H/9A+pMI6XCkFv/1MQrplMZykkD0B+dyZEkQbeHXAgTJCC28O7fBbD67Y8mR9NVRWY4mXPB8zk5C5B7u1aR/NEOUxVzLcwUbi8inFnZNAflT0qkz95OE4IrNPo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(346002)(366004)(376002)(136003)(41300700001)(122000001)(31696002)(6512007)(86362001)(66946007)(316002)(26005)(66476007)(6486002)(66556008)(110136005)(76116006)(71200400001)(6506007)(64756008)(66446008)(38070700005)(8936002)(54906003)(8676002)(4326008)(36756003)(38100700002)(83380400001)(2616005)(2906002)(5660300002)(186003)(31686004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDYyak1QZnpEcW9qcmJvN045cVpJS3Y5V1V3ZWxRYzVoQzFFelNJVjRySFFv?=
 =?utf-8?B?cVp0bzJhVi9aQklyUDhFMzIxV3A5Rlk5RlZVTmptczhwQlpWN2oyenFBMWwv?=
 =?utf-8?B?a3FkVWp6bDJLNmpyS3BxZ3dLWGVXZEFrOGIwZEpKd1JVRkwxaGtKaUJUZTVW?=
 =?utf-8?B?b3F2MkRWSzAzVTdDcHNXUjVTazZULzh6OTNVdEdPSkR0NjFRMnpaeGJEU2Q2?=
 =?utf-8?B?SXZnSVJWaHR6UkZhR1FldHBJWmh5bUw5TW9tRk5CazdlSW1MMFdwSWtnMmF0?=
 =?utf-8?B?ek02MzBkKzFaU056cFZYRDZIcVZ4MlBmK2h2enhVVnVuMWc3Rk9qdUVvTHpH?=
 =?utf-8?B?NHZhWnl0cVhQWmRlSzJZNWJoL3F4VW1GUDZsT2dJbTB1VlE3S1dkS1Z6OWo0?=
 =?utf-8?B?eU9zZkVBWURsOHJkRU5XUzZFUGY2U1VXNXJCb3FDUjJELzZWcGs1b3V4T1Bh?=
 =?utf-8?B?N2VhU24reGw5VlJ0YUVwU1dvWGJ1V2Y2eGdYTzlLTzV1Y3d6Qzl4QWlpdU80?=
 =?utf-8?B?b1REdU0yL0ZDeFh4MHlDME15UVFVZTlhcDhpc2wyTmtxSmVVdnArMmg1UE5y?=
 =?utf-8?B?YVBLRWZKeTg2bUt6bExMSmVZZ0xvRmg1b3JhOEVVOWxZbXBKVEd2dkRVOFhj?=
 =?utf-8?B?dlFlbG82aVhlVFNkcFNQeVVTQ1NjQjI0S0F1Q05WZVFGTTFIUGpPQmZBck96?=
 =?utf-8?B?RU52SG1ySzhNTHpNZ3k4a2NwMk0rb3BuYWpFYXV0aHk2dmZFUGdUTytxNjFU?=
 =?utf-8?B?WnZveHJQbUNlZFlDWS9iVG55SXdVUHZQeHBTdzZqTTNwVHlNZzBtSnNRLzNI?=
 =?utf-8?B?ajR6dnVSTk9zM1RIKzJHVHQ1MHkvMFN1V2d4SFVuMnFVNGpmNUxwelpuUUgr?=
 =?utf-8?B?YUplckg1Ty9tKzk2N3V5c2lNOWsvOFRzVjJ4TjVTTzBGYUQwMFJiMnNHb0Fn?=
 =?utf-8?B?MUhlSDRKcWhhbERiTHFoajluY3ZOVTBxekFmTXBwUUJkTHBOaS9wejJTQjhK?=
 =?utf-8?B?MHFpMWNrWWpFbU44ZHFDRWRLT2NETCtLSFJ5K1dqTWtLWDIxeXhTS3QwN3hS?=
 =?utf-8?B?MXcrdUhLRDcySDV1akQ5bUJPUCs2a2ZTWUkveVRYaWRjd1FiZmxCZDJmcWlD?=
 =?utf-8?B?MVIzSUxvZndMY1NhTWRBUVB6K0RENDlHUXV0ZWxTekVwMFkxTUNNb0FKYUlU?=
 =?utf-8?B?VlpDbWJBcURlQnkzSnk5cnhxVWQwWlVDL3Q0bnZEUmtkUmhEandaUDBWbXhz?=
 =?utf-8?B?cytMNHpUcGxidkFhRHBPTVVhdjNnZkt5UTBhOHhJN2Q3Ykd3cDJYUEtMQk96?=
 =?utf-8?B?MVBKbXBZZFJJSG5LMVF0SStJdllHTDNia09kRFJacVcwOUxzamM1TzE2Ymlp?=
 =?utf-8?B?SlRWek5xSU5FK2FwQlFyTWhmMWVHNTNHM2NMSTJwY1Q1NlhuYUpHaHJmZHdj?=
 =?utf-8?B?RjNzaURFM2ZzT3FNK0h1UHVzQkRCRytnTHMwT0F2WkJ5cTFoTTVLOUc4aDM4?=
 =?utf-8?B?ekpvdXVYbWQ2N2VzNEplS1BSdHd5NHhQMm5wblA4UHNwK2l5emJzeWYzdXk1?=
 =?utf-8?B?T0hJNjIyNWd1WVJsVEVYUUNHcytEREd6NmtJblFQdTZybGFYZm9UTXNkNEV6?=
 =?utf-8?B?VmJxa1dGdFhEMHlrbWwxa3ZDTjhWdTFicFd3cXJ5djdUT215bjBpNDhtS2tS?=
 =?utf-8?B?WWF2cENzN0pmQi9zWHZnNVY5bE9aZytDZzkvaExJMjkxWTR3V0Q2b1FpdjNz?=
 =?utf-8?B?QWpsTmVMM3dMb3plQ2JkZUo1aS9rWTNWOXo4QkZZbkNPV2ZNNU91T09mN1A5?=
 =?utf-8?B?VTRsQ1M5RW5NVFVNU0d6SmhBZm1kN1pGV2FaQ2tEOUFGZlRReGxUQ2dMdHJ5?=
 =?utf-8?B?UzgvdTNoT1ZJc1N6RXc3U0FHWnZESlJKS2gyeGYycmIya2dCRlhtdFpzQU5T?=
 =?utf-8?B?Nk5iUStVdnE3VkpFTlVaMXFkMDZmWFhwTkZaR3FuTGxwenpCV0F5MzNGdm52?=
 =?utf-8?B?RVFJODYwSjNheHhrYVhoZmFoNXhpeitGUUZoR3lZcUFMcFJXUHI4R1JzeE8v?=
 =?utf-8?B?UmR0eVFGdnlPZ0J2WDhaaUdJQ0gvMHp6OVRjemVreUNidCt5aVFDUHowUmEw?=
 =?utf-8?Q?81IGJUoqnLKtD5N2VdeB8eGZs?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0A95AACD1036C4D83631EDB590BDE6B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5ff682-1907-4e0d-d65d-08da613ccca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 23:51:38.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rCcdxdoIsQa5OfcQROyFdl69fgnhLM85Ca5760eVrDMF0gejnLtXgRsCdbP/iYe6875e36hCaQr5ZQEQIvjqhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3889
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy83LzIwMjIsIERtaXRyeSBCb2dkYW5vdiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+DQo+IE9u
IFdlZCwgSnVsIDA2LCAyMDIyIGF0IDA0OjM1OjAxUE0gLTA3MDAsIFRoaW5oIE5ndXllbiB3cm90
ZToNCj4+IEFjY29yZGluZyB0byBTQU0tNCByMTQgc2VjdGlvbiA3LjIsIGZvciBBQk9SVCBUQVNL
IGZ1bmN0aW9uLCBhIHJlc3BvbnNlDQo+PiBvZiBGVU5DVElPTiBDT01QTEVURSBzaGFsbCBpbmRp
Y2F0ZSB0aGF0IHRoZSBjb21tYW5kIHdhcyBhYm9ydGVkIG9yIHdhcw0KPj4gbm90IGluIHRoZSB0
YXNrIHNldC4gQ3VycmVudGx5IHdlIHJlc3BvbmQgd2l0aCBUQVNLIERPRVMgTk9UIEVYSVNUIHdo
ZW4NCj4+IHRoZXJlJ3Mgbm8gY29tbWFuZCBpbiB0aGUgdGFzayBzZXQuIEZpeCB0aGUgcmVzcG9u
c2UgdG8gRlVOQ1RJT04NCj4+IENPTVBMRVRFIGluc3RlYWQuDQo+IFNBTSBkb2VzIG5vdCBkZXNj
cmliZSBhIHJlc3BvbnNlIHN0YXR1cyBlbmNvZGluZy4gQnV0IG90aGVyIHNwZWNzDQo+IGRvIGRl
c2NyaWJlLiBGb3IgZXhhbXBsZSwgaVNDU0kgUkZDNzE0MyAxMS42LjEuICBSZXNwb25zZQ0KPiAg
ICAgICAgIDAgLSBGdW5jdGlvbiBjb21wbGV0ZQ0KPiAgICAgICAgIDEgLSBUYXNrIGRvZXMgbm90
IGV4aXN0DQo+ICAgICBUaGUgbWFwcGluZyBvZiB0aGUgcmVzcG9uc2UgY29kZSBpbnRvIGEgU0NT
SSBzZXJ2aWNlIHJlc3BvbnNlIGNvZGUNCj4gICAgIHZhbHVlLCBpZiBuZWVkZWQsIGlzIG91dHNp
ZGUgdGhlIHNjb3BlIG9mIHRoaXMgZG9jdW1lbnQuICBIb3dldmVyLCBpbg0KPiAgICAgc3ltYm9s
aWMgdGVybXMsIFJlc3BvbnNlIHZhbHVlcyAwIGFuZCAxIG1hcCB0byB0aGUgU0NTSSBzZXJ2aWNl
DQo+ICAgICByZXNwb25zZSBvZiBGVU5DVElPTiBDT01QTEVURS4NCj4NCj4gU28sIHRoZSBjdXJy
ZW50IGNvZGUgaXMgYWNjb3JkaW5nIHRvIHNwZWNzLg0KPiBNb3Jlb3ZlciwgVE1SX1RBU0tfRE9F
U19OT1RfRVhJU1QgaXMgdXNlZCBpbiBzZXZlcmFsIGZhYnJpYyBkcml2ZXJzIHRvDQo+IGhhbmRs
ZSBzb21lIGNvcm5lciBjYXNlcy4NCg0KT2ssIGl0J3MgYSBiaXQgY29uZnVzaW5nLiBTbywgdGhl
IFNDU0kgc2VydmljZSByZXNwb25zZSBuZWVkcyB0byByZWZsZWN0IA0KRlVOQ1RJT04gQ09NUExF
VEUsIGJ1dCB0aGUgRlVOQ1RJT04gQ09NUExFVEUgY2FuIGJlIGRpZmZlcmVudCBmb3Igb3RoZXIg
DQpzcGVjcz8NCg0KVGhhbmtzLA0KVGhpbmgNCg0KPj4gRml4ZXM6IDNkMjg5MzRhYWFlNSAoInRh
cmdldDogQWRkIFRNUl9BQk9SVF9UQVNLIHRhc2sgbWFuYWdlbWVudCBzdXBwb3J0IikNCj4+IFNp
Z25lZC1vZmYtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCj4+
IC0tLQ0KPj4gICBkcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyB8IDQgKystLQ0KPj4g
ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPj4NCj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYyBiL2RyaXZlcnMv
dGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+PiBpbmRleCAyYWY4MGQwOTk4YmYuLjcyNGRkYWJk
YTQ4OCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdGFyZ2V0L3RhcmdldF9jb3JlX3Rtci5jDQo+
PiArKysgYi9kcml2ZXJzL3RhcmdldC90YXJnZXRfY29yZV90bXIuYw0KPj4gQEAgLTE3MCw5ICsx
NzAsOSBAQCB2b2lkIGNvcmVfdG1yX2Fib3J0X3Rhc2soDQo+PiAgIAlpZiAoZGV2LT50cmFuc3Bv
cnQtPnRtcl9ub3RpZnkpDQo+PiAgIAkJZGV2LT50cmFuc3BvcnQtPnRtcl9ub3RpZnkoZGV2LCBU
TVJfQUJPUlRfVEFTSywgJmFib3J0ZWRfbGlzdCk7DQo+PiAgIA0KPj4gLQlwcmludGsoIkFCT1JU
X1RBU0s6IFNlbmRpbmcgVE1SX1RBU0tfRE9FU19OT1RfRVhJU1QgZm9yIHJlZl90YWc6ICVsbGRc
biIsDQo+PiArCXByaW50aygiQUJPUlRfVEFTSzogU2VuZGluZyBUTVJfRlVOQ1RJT05fQ09NUExF
VEUgZm9yIHJlZl90YWc6ICVsbGRcbiIsDQo+PiAgIAkJCXRtci0+cmVmX3Rhc2tfdGFnKTsNCj4+
IC0JdG1yLT5yZXNwb25zZSA9IFRNUl9UQVNLX0RPRVNfTk9UX0VYSVNUOw0KPj4gKwl0bXItPnJl
c3BvbnNlID0gVE1SX0ZVTkNUSU9OX0NPTVBMRVRFOw0KPj4gICAJYXRvbWljX2xvbmdfaW5jKCZk
ZXYtPmFib3J0c19ub190YXNrKTsNCj4+ICAgfQ0KPj4gICANCg0K
