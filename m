Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B19BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 00:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C80C60EFF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 00:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhJ2AYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 20:24:11 -0400
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:47865
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230211AbhJ2AYK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 20:24:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOE2hfqL4j08hbFf+IYfjIjlru9RVoyN5EDfbejl2pKrHXGoZmTIIjwYjQgwmNaX4g5pR+2HNpbSA8hGLDxMa30Snei3lB9TEEc8ei2bqLXx/mpFMCvkAht2AMxP37tR9qeWz3zU95TABYi2ZR0Qk9PWL5rzC6hoPHFQYCJMtWbpj/5/hjRvIES1Ri8xts6ww7Ss4sRCH9JnFck6ZYcGkpTFzfnsaQdR5g7u8bqn5DQiWz8kcpHa0ydyd0PRJ1GhP6zXYJQjc4oThZfh4CUuK8QNOZxwsrfWitiNxmcFEALnjuYWF5owUPet3I4RQndt3gLxyaY2sU1c1QuR2WMHNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+NfkAjuKdzrORq6ZkyuH6WCBtH//AfamrHHUdjWK/8=;
 b=XKmG5v++F6q/guhTJw+ml86uLNSKpLgPg62Z1rRdCQKKCCVDir8As4bP0HCM2sPGUezKtxhBJM19CgP9aQJ3FBOCixc0kFbINnKk1iLuVGr61Jz107IWla63E34xND5K2z3U0H8Nm/SrgR2QFRmWDJE8HGd5tgWvkRUFtNkJVq5y/idGaKSYLieRKncInOKXVHJmjyn96T8VO9S6yEdWzE3LuKyg5prpXgQzM8kwrA2Ka5NmX878oi+RtvpRmhId2dq1zL5KKqz2RaVWcszP5eir+L4OO8Cp3WOtFBW++4+t4WlYznNc5nhEHEMHoU5Pn/2hT2fkGuVT2Quk0n7vNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+NfkAjuKdzrORq6ZkyuH6WCBtH//AfamrHHUdjWK/8=;
 b=cjTCwIDrYPPT0x5wqgBaM6GkKV5DN9wdavGbcHQTtORYrTpwZWID5qiJouRdnlwHpdqND+v8KTO0T52cIBdX1JIS55kTTa559Ncdd9NFxNAG54xIdUYxm5KfbHeuil2xcCMXrvZ1sViVJg3SRAB6c1un574FpC9S0e8vbUArbxQPqgZpOilY+9Hn0akcnZjrKSZ8qioVt5HgpWfdu44eCDqNGuFFVr319luXc5sNyJJ1kThAuifWffwA+bB63/CkCc2prXwoM+CA9HJvsKeDg/mZW31eXDBJMmpsdxboD2HkUV7kQl1W+s3U/ZsyBoRIeyGhYqoBYXD0ltaVvyLwTg==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by MWHPR12MB1328.namprd12.prod.outlook.com (2603:10b6:300:c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 00:21:37 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::3db1:105d:2524:524%7]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 00:21:37 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     =?utf-8?B?SmF2aWVyIEdvbnrDoWxleg==?= <javier@javigon.com>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXtJz3aovD145e60qqb0tlGftm/6u8xNMAgAkFTYCAAH02AIACcLOAgCCUmwA=
Date:   Fri, 29 Oct 2021 00:21:37 +0000
Message-ID: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
In-Reply-To: <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: javigon.com; dkim=none (message not signed)
 header.d=none;javigon.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 502ed39e-6de0-4210-c699-08d99a72129c
x-ms-traffictypediagnostic: MWHPR12MB1328:
x-microsoft-antispam-prvs: <MWHPR12MB1328545DA617D58091C15128A3879@MWHPR12MB1328.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YeMzO0ehQEFtXZp1IbAaL5xwj9cKK9rTv9aL2blBLbE3UZoeU2S96jFiLvre90+Yv/MVg5e40pRdBKc/MDhA1G7pnZenNMvc+allpLIhaTfwkw5xYGZ/0L0wuGQsVvuy+lxG7KmdsKbWid73lZEzu2lc7sZn7O5bcuBqloskQLiLWYuc7o6EDbUpqA7+JoABDpoTx7w5UrVIdk7mqfIaiVDzIZK48WpRJ9OSO0tWobofHEUBZ/Hn42G7rfgP6OqMcJ3SiUXIISULtZkypX+zuBX4ggxIpUxN33LJkvlpvSscfNVL2Mi6qFgv6f6j3xjnrm/3B4zjQWJGHewHd3yOAOcNuoS2uCmbKqMAHuODCWB/Kh5L1Q8UR8nGRtvtJAMonaHdvsCeb8w0VUNvGmwq7GJw8DJIiFPUfEV3+WyetAh3UNf2O14p4pBh/A1FZu4a6Nv8akI09+6okJ7vNtuedxDgxJLHCNTChTN2soqOp2H85kLfcSvUpwbRWcX1r7uaq8PFPsphyrSQrPnQTMqklUP6QQYEbCqAh9j65kFwzGdP7q55buEMYYzlOcJFtSVub6ZW2+p6o1g+yslqxl1z57Bll1kYkoja9TMM1WddTDZo5/Q5fieBksjSTbg4nbj6zmr5kPIzJiA7guMwgRMhodL0Qzp2VosPGCXF+mKUdgnqrV7e1RKHIFboLtlB6fw8kjNwevn2cKlf7W2FRkW/PIywUzRkW6V+w945OXUGzSLznVhKSrCqFzpwzHVNs57mLSLSgNdjlSEiAZiHtJtt1UwMwfTwMGZO7zTDLNuRL04/e++yJmiwbx+i5JDibmB+Lys8oljAGNksjJCrbnHxDMUOCW83k/ElHGG99AXeSM3GrlrPvacCPddqwBLPjb5A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(2906002)(6512007)(36756003)(66574015)(508600001)(31696002)(966005)(8676002)(186003)(5660300002)(2616005)(4326008)(8936002)(6506007)(7416002)(53546011)(86362001)(76116006)(71200400001)(6486002)(6916009)(54906003)(66946007)(316002)(66556008)(31686004)(66476007)(38100700002)(122000001)(66446008)(64756008)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVJYeSs4YTNmeUFVWEQ0R0dFMXpBbHl2K3ltOTYyQW1NZ1VENjY0VzRkMG9m?=
 =?utf-8?B?bVo2R0dkdEFSenE1SXQvanZqaGp3eDZLL1Qvcmp4MXZxeVdEWXFvVGhTdnJG?=
 =?utf-8?B?ZkN3SlZCSThEZ1hCMW9wVnM0SWVyM0R1REM2TS9KOEQzaUdJWG5aOUEyN2pi?=
 =?utf-8?B?MVZwTm5rcnBhMTk1WERIenk2T0RLMFJQcHJpenN0RVJOTzlmZUlaVjlKck44?=
 =?utf-8?B?REFGa0NxWEFHd2c2RkZ2VDVvNXhST01rZDY5R3VyMEdOcmdVL3IvbHpXQU5y?=
 =?utf-8?B?Rk9OTjFCeXVWbnpoU3RWZUozWDRyY0lYQVJvUmwvYjByMGNPUkprWmhYN0FD?=
 =?utf-8?B?V0hRTWlXR0dzVzlJbXFhd0F5dEU4WlBIMWFiNzV5UVdjRENQNlFlaHhTbUdB?=
 =?utf-8?B?MGo4WUpqb3JQZWg1eCtGTEphYjlYREJsekJCZ0hhQ3lRb2ZpcUd4OW9keXl5?=
 =?utf-8?B?cVBHN1g5d0pWSHVyZ1FST09QckN4WFNyWDJlT2lGWE5FZjJDSDBMVW1SUnZO?=
 =?utf-8?B?R01abzZRUVJ1TmFkODR5ZXBTaEJBTExWdUlhWHR4TU1uUE5Qa3J2d2hzT0Q2?=
 =?utf-8?B?VDdtZGY2YTNYSEdUVXNJYVhGejkzb2tJT1VObzkwQWNnOENpT05IaGJhYlgv?=
 =?utf-8?B?Wks0L3RwMzZGMG5ZandXWVhnZmJoZGtxU1RQVkpMTzV6YVN2akJHSS9YOGJF?=
 =?utf-8?B?QVgrM3kzQjNzd1RBU21hbCtRYTFQVG1laFBFRDVTb0RiVjZsSjIra1lOdUpP?=
 =?utf-8?B?RmVna1BWZXhINzlYMjFDTWVEUHEwQjNNZDZQN3dpcTdGMEpsOVcvdlFML3E2?=
 =?utf-8?B?eEZWZ0Vrak5rTWl2djRzYmNmTXJjVVh3UXZmdHRZUzMyc2NqR1FtL2U2T2ts?=
 =?utf-8?B?TURkMmptY1dwSjFOa3lPYmFFSlJSQ2VtOTBWSDlUYTFKdWRpV1BlQnA4U2JH?=
 =?utf-8?B?MEN4RlFNYkthTC9RaERNd2FSeXRhUkZ0SnBONlNMdzlneE1Wa0pJeDF0QmF4?=
 =?utf-8?B?c1ZjS2tnejFLQklyb0V6MmZVaFl5aXhYV29mcG1hUVZBUW1CdjV0SDI5dXpG?=
 =?utf-8?B?dGpQK3dPWEpBOC90aGRUTlNqZzRPMzB3NlNHZ0VWelJNSm15NStQUmhsRm8z?=
 =?utf-8?B?TlFaMjlGQjVXalBaKzlrL0RuSFpxSzFwRlpqREYwaGw5a2RRa0tOZXdySWwz?=
 =?utf-8?B?S2w3ZzdveVZFbDJKc2FCcHR2NEVPL3FzYmw2RnY3OUJVSUZOTHRiMWlCcWZN?=
 =?utf-8?B?aFRlUTdFVGNUZjRUZml2Rkdid1FaWS8yN2NtOEpSUnhIR1g2NFFYZTY5T3ds?=
 =?utf-8?B?Wi9RQlFySURJQjZXQk5rTjIxMkc5NTZZa0RQcm53Qm8vNVVIUkZaWEpwdjhR?=
 =?utf-8?B?c29wY2lsVzkwZm9lWGVudXo3QkFTYm1qYmxvOFZLVHBKb2thc1VUbUNyN2FK?=
 =?utf-8?B?eGR5UnpZOGltdVFSQWVnTXZqdnQ0TENXUVNpcUtGL0U2QXM0eit2NXFESkRa?=
 =?utf-8?B?R25lU3pIY0pvYmdMVEs5aiszU3NXOTRCSDlNY1FqMFFUb1g2NTV6a2lzOFNo?=
 =?utf-8?B?czdOeE81NHFjS2x1cHl4NXAzQzB5ekNERlhjTk9CVGRmTklnRnFKSkt4RUph?=
 =?utf-8?B?V29KMTdHdk81dzh6QWF0V3ZjNitrTllqWWt2c3BPR0M1ZHRhbWxYNHpNVXpM?=
 =?utf-8?B?VXdmbFhYVDdaTU9nQWd6OEpZazdzazB2ZzJSaU1qbWhkaVZPSWx0eGFqbW9W?=
 =?utf-8?B?ZmZTYSt2bUR0MmJUVXdqMWRYODdrQWpOSjB3UFg5U1ZBN2JiWnExS1NCYklx?=
 =?utf-8?B?aVVncWk2bTgyTnNvREFwa0dnS0J1djZwZ0dVWnRyNWZPRmhiK0dkRXZpR2Vo?=
 =?utf-8?B?dVlTUStKL3VxMGJSeHpzY2ZxZ0xPTlhrTUxxa3pTU25MUHpIK1c0YUM2YXZY?=
 =?utf-8?B?Z0NiSldyU0NSdWRvMTVUck9IaEdqNklDbi9ZbXpSc0IyWDF1ekxSNnlHWmVF?=
 =?utf-8?B?UXJBWG9uRlBJQzVxcnp4cUgwd2x0MUM2ejh1MlJKV0FXcnpWNTlReXFmckk5?=
 =?utf-8?B?cXRXZGpBbVFTVkxkSEh3S0VMRVZBRDM4Q2d3U2szbDFQQVBqNGcxY1lVT1BJ?=
 =?utf-8?B?RkFPeVBwSzRWazNFTEhqZUx2aVkvMitDdXVPcHF3WjFFSGl6NUk1TjdoWnlW?=
 =?utf-8?Q?RULcJOtoF/eihBoPNc8wOgLMebRsv/oQSawwwQmAPHBk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA9967A942905B42A22F8E68BAE1FFF8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 502ed39e-6de0-4210-c699-08d99a72129c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 00:21:37.7110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5MPXmI5jXqIHa7Uas6n2pZ8ojSNlOBVzghTthPI/+kHE/eF44J4a8sZ2zWOOOXbNWAHf5ga4CBns2nGQtDUVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1328
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gMTAvNy8yMSAxMTo0OSBQTSwgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToNCj4gRXh0ZXJuYWwg
ZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0K
PiBPbiAwNi4xMC4yMDIxIDEwOjMzLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6DQo+PiBPbiAxMC82
LzIxIDM6MDUgQU0sIEphdmllciBHb256w6FsZXogd3JvdGU6DQo+Pj4gSSBhZ3JlZSB0aGF0IHRo
ZSB0b3BpYyBpcyBjb21wbGV4LiBIb3dldmVyLCB3ZSBoYXZlIG5vdCBiZWVuIGFibGUgdG8NCj4+
PiBmaW5kIGEgY2xlYXIgcGF0aCBmb3J3YXJkIGluIHRoZSBtYWlsaW5nIGxpc3QuDQo+Pg0KPj4g
SG1tIC4uLiByZWFsbHk/IEF0IGxlYXN0IE1hcnRpbiBQZXRlcnNlbiBhbmQgSSBjb25zaWRlciBk
ZXZpY2UgbWFwcGVyDQo+PiBzdXBwb3J0IGVzc2VudGlhbC4gSG93IGFib3V0IHN0YXJ0aW5nIGZy
b20gTWlrdWxhcycgcGF0Y2ggc2VyaWVzIHRoYXQNCj4+IHN1cHBvcnRzIHRoZSBkZXZpY2UgbWFw
cGVyPyBTZWUgYWxzbyANCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9hbHBpbmUuTFJI
LjIuMDIuMjEwODE3MTYzMDEyMC4zMDM2M0BmaWxlMDEuaW50cmFuZXQucHJvZC5pbnQucmR1Mi5y
ZWRoYXQuY29tLyANCj4+DQoNCldoZW4gd2UgYWRkIGEgbmV3IFJFUV9PUF9YWFggd2UgbmVlZCB0
byBtYWtlIHN1cmUgaXQgd2lsbCB3b3JrIHdpdGggDQpkZXZpY2UgbWFwcGVyLCBzbyBJIGFncmVl
IHdpdGggQmFydCBhbmQgTWFydGluLg0KDQpTdGFydGluZyB3aXRoIE1pa3VsYXMgcGF0Y2hlcyBp
cyBhIHJpZ2h0IGRpcmVjdGlvbiBhcyBvZiBub3cuLg0KDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBw
b2ludGVycy4gV2UgYXJlIGxvb2tpbmcgaW50byBNaWt1bGFzJyBwYXRjaCAtIEkgYWdyZWUNCj4g
dGhhdCBpdCBpcyBhIGdvb2Qgc3RhcnQuDQo+IA0KPj4+IFdoYXQgZG8geW91IHRoaW5rIGFib3V0
IGpvaW5pbmcgdGhlIGNhbGwgdG8gdGFsayB2ZXJ5IHNwZWNpZmljIG5leHQNCj4+PiBzdGVwcyB0
byBnZXQgYSBwYXRjaHNldCB0aGF0IHdlIGNhbiBzdGFydCByZXZpZXdpbmcgaW4gZGV0YWlsLg0K
Pj4NCj4+IEkgY2FuIGRvIHRoYXQuDQo+IA0KPiBUaGFua3MuIEkgd2lsbCB3YWl0IHVudGlsIENo
YWl0YW55YSdzIHJlcGx5IG9uIGhpcyBxdWVzdGlvbnMuIFdlIHdpbGwNCj4gc3RhcnQgc3VnZ2Vz
dGluZyBzb21lIGRhdGVzIHRoZW4uDQo+IA0KDQpJIHRoaW5rIGF0IHRoaXMgcG9pbnQgd2UgbmVl
ZCB0byBhdCBsZWFzdCBkZWNpZGUgb24gaGF2aW5nIGEgZmlyc3QgY2FsbA0KZm9jdXNlZCBvbiBo
b3cgdG8gcHJvY2VlZCBmb3J3YXJkIHdpdGggTWlrdWxhcyBhcHByb2FjaCAgLi4uDQoNCkphdmll
ciwgY2FuIHlvdSBwbGVhc2Ugb3JnYW5pemUgYSBjYWxsIHdpdGggcGVvcGxlIHlvdSBsaXN0ZWQg
aW4gdGhpcyANCnRocmVhZCBlYXJsaWVyID8NCg0KPiBUaGFua3MsDQo+IEphdmllcg0KDQo=
