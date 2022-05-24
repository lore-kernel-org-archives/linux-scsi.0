Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF02C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 15:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiEXPOg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 11:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiEXPOc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 11:14:32 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15468AE49;
        Tue, 24 May 2022 08:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jELyxC0X5NuumPAVGcWSDFymEvC50OpQmibwZ1tLTRTt/eCWBHoI3XYsFJ1xvI8HfVEpYHMgNQaZLAZHy8pddthvTJ9pvxVMmTtoq5KyjZLG2Btg9yDxyOkvHWPFC7CHOLBZioWTt740qVEAziZyAfXI+p9woA1OSIGivafvj37Enmb944oS4RZxfEGnv2heUQVjRlr756W09iLMF4XLl6AsExhbHgq542DBnR18K/58sIwndjkvNCOQ5vb8WSV9tF8kMYaCyM26O0Kd1iqpCRYCQG55hynnNsRpdIKkGLhREQ0Zp4cjtOjT9OUzGdzRxqpi9sf/GXSf1psO0yNslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQVkj0wwNcI2O7ozvpbygSnranVBMyQoeF2nmbZfP9Y=;
 b=oK3OU/N27x06h4qK/PabgIPhqTd+40poRBN8TztOd8iSXWEVtqAOhFG+0xkoc9rdJphmTch+Yq1+HpNdX4idRNvZtzuSNrZgiPmkLXcDn6teYK4DiWOIFm/7rVhtTx7ViOv41eoxFa4mwZI9rR/tCfkKP9Qy7zCwazTSftcpllcmwXwdD+dOYzcvAIld7OWpEtrtxRfh9gv3jAKsyQxMHZD6BRR/zI3jSrrsHccv0oFLMlK87J79eADq/0Hh+OO3IzcYlvPkKcID3FFDAXVtQ6BzFpa8uVxndQ3PNnjx84aWFubl35Hi12xnrvuj/pIRzPZGJH3ZuMzyp7Oel17P8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQVkj0wwNcI2O7ozvpbygSnranVBMyQoeF2nmbZfP9Y=;
 b=bf0td/yTCStOqMfcVIas4aKtaGIoDxAB+2dRUVFS7iI2hFIvVk5NDXUfq1xp2qJEuwpTDdP7XikYvwiR+9m4knEVaUJr3t+BsClBDc1CFRN8IzBMobrvPamqshF2O0qW0MMwHdY26PM8VZrOJP8mMyJJKIyYauw/+pgFee/cam7pvz13VsVdSdZ/RAighrhF6/Eq1vhFMuoTP2jv299pVYPZFCPwHgcnYSjrnAy4OQsYozFVUh7LxgKD3zoEsSGQ5YNZcs5T2SLeb6KKjHBx6rA6D92690VkzMN+2G1wULYB4o5p8S4avLeMp3Y9ErpKRtnXgWiXbdnTxHhTGYPdJQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM5PR1201MB0075.namprd12.prod.outlook.com (2603:10b6:4:54::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Tue, 24 May
 2022 15:14:30 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::d9a5:f1df:5975:a0d6%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 15:14:29 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: document BLK_STS_AGAIN usage
Thread-Topic: [PATCH 1/2] block: document BLK_STS_AGAIN usage
Thread-Index: AQHYbzMXbskx2GtQA0GmHwTSu8wff60uI4aA
Date:   Tue, 24 May 2022 15:14:29 +0000
Message-ID: <8d77cf38-17d6-265c-44d1-d4a43e6f7352@nvidia.com>
References: <20220524055631.85480-1-hare@suse.de>
 <20220524055631.85480-2-hare@suse.de>
In-Reply-To: <20220524055631.85480-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20441aee-e200-44c7-aeaa-08da3d98193c
x-ms-traffictypediagnostic: DM5PR1201MB0075:EE_
x-microsoft-antispam-prvs: <DM5PR1201MB0075FC09F72EAAD7B0F10663A3D79@DM5PR1201MB0075.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bxcotw44SmYYKrGhmLdvJ3DlMueuerAZpOJDiL0mBead2gCAuGatbbPhln8lbwYhGNPmtmtgYGz+HjAZ1bBUtYSJRMmFxBMxPQgRrc1wD+AohEh0dqUgvobz3RbFyra0cLcZZW4XCM9p/6/eyo0you7BcMfmkwVc9Ro5dsxb9W94t4li0f2S7MnESnPV6DB2283YkQOXlUqCrbQautkBAH6NAf+SCmioEe+aOGSHgila2He80fNInrZ3jZttyaMn9Wa1nQPDedFChy0Udjn1J2dz2ruIsyCGgB0lZtPcEgtrGe/9qEVEhErethLqZ6HsOC/ZoGEbxHVOGdsxuf6O3UR7KjLqDjDo40DurYSbTwFEZwimClDMNfPz48V4jqPal2cIhORbnpIpye8l9uW4skK6PbGjp4lZAfIzbehVRZEuDs2Nooqw9DSb2tC98vP92ePYFWrffQ4npvqGwIyoNSaPZ26SFoWwd7qPaIvaCtd3XJ0TkB7pR4SOpw7iptMM5tlPLnNZyv7Eny/jFB/xe4Xi8ZdxudSMI4McBCsSVq2m/lH9QiZn7E1cMTLS5fCYb8BfsSo3MFINP8kco9k9A6BrmtwsqM0omGoTMW/AycNdhcTBJb1T8sR0ahtxY0z1cBWtTVGONAOPTs8f/R2bDEkNspA3/EEyY+pQZnya6zZe3bs8eSqX7i7TzymeNok0Uj0rYasJ1Orm6pbGViMRu4WM4yNesmSCnWQ9budYgRTdbl4nPr29i3X0P6eFwNlXTkSxohQfje/4lmG5MshBlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(508600001)(2906002)(2616005)(5660300002)(54906003)(558084003)(38070700005)(38100700002)(83380400001)(53546011)(66446008)(66476007)(122000001)(66556008)(31696002)(76116006)(66946007)(64756008)(91956017)(316002)(4326008)(8936002)(8676002)(6512007)(71200400001)(86362001)(31686004)(36756003)(6506007)(186003)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R25LNDRYbnpWL3E2cGF0U1doanJyTDNYdVJ4UUl2Q2Z0L213WWZ5ZnQ4MGVW?=
 =?utf-8?B?NXdwT0VicjcwbjUxUE14cmVabHE2cHhqKzdaK1htNGZNRU0rSmRNMDAyYm1r?=
 =?utf-8?B?R0VPb2FKQUxhMEVSajVLbVEzV1NNc0VSR285dEdDeDBzRE1VbFNaOXdneUtD?=
 =?utf-8?B?R01yYWZqQ1VTeDlSdVRSek9HRm4vOFJlbXFxSlBURDlDLytRS3daZ0pZTGIv?=
 =?utf-8?B?Mjd2TTFReUxYQkE4VTlJLytRa3ZLZGd3bmZVKy9Lbno4TEl2R3RXandtVWZh?=
 =?utf-8?B?TnhoTVZjUXlXeXhwVnBJTldhQnRFYmRjYzRQL0EzUTJZdVo2VmdnV0E5Y0Ja?=
 =?utf-8?B?QXFBZG90Ui9ab1dvS1dORnVVRXhVRjlwZjh5T3hQN2tPTzh4NEZJZkE1d1JB?=
 =?utf-8?B?YVlFNGZrNVdtTUtoTTY2SzY0bGVxUVAyZnFXSnNXZ3NBQlY2NkhEMklpZXZS?=
 =?utf-8?B?V2hFSXpkZmVXVWxPTWhoOUNlaVRlWWg1WVZqWnhUalAzaVVXVU9sNGQ3RU01?=
 =?utf-8?B?dE1IMkJOMEtoL2pTWGkyQnpsUWsvcWRncStmTEZSeUd5aHYvQzFXV1ZqMW1u?=
 =?utf-8?B?NUNJVmFrclRJRFQxVDExMFhMUmtrMy90bnFDRmRMSHhIR2VsR2tlMWtrVVMy?=
 =?utf-8?B?RFRmQkc3MHVrNlBpRGU0TVY0Um9zWUpldTUwUGMxVFNhZ3hjT1huMFZ0MHBk?=
 =?utf-8?B?dUg5SCtHa21Ec0duQnJHYXJhOGphZWxHZmxZYzgxbWIveHpTbTBua0hKMEJ0?=
 =?utf-8?B?ZWx4TzJZbjBVSS9jNU1sOVdBTnpPdjVuY09XY1paQlhaOUN5RlA4NUEwVjNk?=
 =?utf-8?B?eU1xbWFaTnE4eEZQQmVVemx6UThtTkxKZXN0WWNyWVN2LzRpZnpYMXNwVHdI?=
 =?utf-8?B?SytzQ0t4eU8vMTI5REtPWmNZNE9Ga3J3K0NkNEhhOW52c0RZanFTbTl1RG5k?=
 =?utf-8?B?ZmdpaFVmanJRY1k2ZWpLTWlhTXVSRUQ1SzJhbHJGZ2RrSWlRL1k5MTFFVjVP?=
 =?utf-8?B?TkJyWVZYMWhCd3U3VlhUUWUxV0ZJWFY2bi9RZW1SbzE3UDRxejZKQkpZN043?=
 =?utf-8?B?WmtZZFhPcDNkYWVZSjFuTWxEWndGT3JlNzk3eng0Ymd5UnlES054Mm55RmVJ?=
 =?utf-8?B?SHhIbitFTktzQlo1TW8xZmNSR3ZIT0cxM0ZKUkN4TjF6WkYyZ2dhYmozSFF3?=
 =?utf-8?B?TEg5WFBnN1pOT2M5MDZXWUZHZ2dnalJFUWVqMVFoRXY3aUtiZW1ma0VFNWRS?=
 =?utf-8?B?UTJKK1gzNjJMZWxkQXJNaEtPYTFqRTE3Lzd3ejBZUEVyR3dsTnY1THNyUG9l?=
 =?utf-8?B?RTNjcm9qMUI3NVdIUlRwaDFoeVNDUWdoa1JnWDduSVhtRjNWbUlVMWFRTnYy?=
 =?utf-8?B?MXp5YnBkVVNWUlkvOVpqQ2RxckZzRmt3YUtsWkphV2dORWlSbFF4OFpxVTlt?=
 =?utf-8?B?R3RxNjE4OFJESEJoZWR4eGlvdkJ6cHd3QURoYzFLOHZrbll1RlRhM2luS05H?=
 =?utf-8?B?cTBIeTI1djRhTnc3OXRJdUdyRDFtcTNTODlxdW8wU3VyNzRTYkR1MFl2SzVH?=
 =?utf-8?B?U3dRSFpkZURVNGJEQTdyUXpxaTduTlJmT0l0eWpibDVpUEVYZHgxL25XNjU4?=
 =?utf-8?B?WFlaY2M2d1hxL2YyQzNIYjlGYmtkSzhoKzRkSGJHRVhDd2xhNXNJdFdTMkpx?=
 =?utf-8?B?WjR1NEdBcW9BakN3N1IyMVlheXY5bGM4ZGtTWmsrbitvdU9uazhuY2pmc3BM?=
 =?utf-8?B?REpPQ0N1MEJ0SmJneVVveENKYzlidTVuYXQ5UmVXUFhaUmFSWFNybmwvNVBS?=
 =?utf-8?B?WXVsdHkzOWxoeGovcWRRQW9SS1EyemlDWnhFY0tBNnQ0dXJ1YWFNTnRXZkVm?=
 =?utf-8?B?T2IycnlzYUdjSVdIcEU0S09MVXIySFIwQzk0T1dhQ1BFbS84ZWZLQmx5REJh?=
 =?utf-8?B?QnZ0VnFVQ1ByUEt1bXk2SVU5K01jbzJOOG84NEtwajRwbytsRzlrSE9xbUpQ?=
 =?utf-8?B?cTJQNjRkTmR0dGJvQVVBUXk2ZnZQTzZPNHNrM0FhdC9tWUluOExjdmw1d2R5?=
 =?utf-8?B?a0hKSmFCcXdoVTljUC9sOUN6YXJ0Z2RsbnNyQUphZUF2aEpVSzJzZXM4NjJ6?=
 =?utf-8?B?ei9STTVMc3I0R1ZsQTZnMXFzWmtyZjNHL3puLzNKK1RsdUR3UVRoVWp1VFE3?=
 =?utf-8?B?WlFWWnppWmVQMXNoYlVmalZXb056dExUdFZrRGgxZTZTdkJKU1VBSkVTNE85?=
 =?utf-8?B?aHZ1dXF0WUQ4VkYySEJRRG11NkRZZStLVk5Vck5vT3BYa0NIR092TGtNTlR6?=
 =?utf-8?B?R05EWVhKRStabHdsQlIvR0V0N2F1dzJ3ckFJUjR5VDl0M1RXb0N0M1ZMWWFQ?=
 =?utf-8?Q?AFzxZ9SJKdV60Wf/tdItN8Cv3X99ZAI8mQud/8ch4malv?=
x-ms-exchange-antispam-messagedata-1: OX6aN5ezsOZubg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <3BCC9A57255F714E8C67BE7C4348BE91@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20441aee-e200-44c7-aeaa-08da3d98193c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 15:14:29.3920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +mM4fVEi0M4RUGV6jlyfl9nissgnupHHl9ap4GSIicYoGXJ9qxmIgZlJMy+XOX88AEcJIL0c+fCnhBzZQdEtmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNS8yMy8yMiAyMjo1NiwgSGFubmVzIFJlaW5lY2tlIHdyb3RlOg0KPiBCTEtfU1RTX0FHQUlO
IHNob3VsZCBvbmx5IGJlIHVzZWQgaWYgUlFGX05PV0FJVCBpcyBzZXQgYW5kIHRoZSBiaW8NCj4g
d291bGQgYmxvY2suIFNvIHdlJ2QgYmV0dGVyIGRvY3VtZW50IHRoYXQgdG8gYXZvaWQgYWNjaWRl
bnRhbCBtaXN1c2UuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIYW5uZXMgUmVpbmVja2UgPGhhcmVA
c3VzZS5kZT4NCj4gLS0tDQoNCg0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55
YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
