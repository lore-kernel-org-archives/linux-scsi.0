Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E161C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 04:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbiGGEvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 00:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiGGEvM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 00:51:12 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB7B1F2;
        Wed,  6 Jul 2022 21:51:11 -0700 (PDT)
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 772BBC071F;
        Thu,  7 Jul 2022 04:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657169471; bh=4zF2kJ2sFmm5XX0B3/10wRrOk16tUjnw7Y5DvnhiXQQ=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=W7CmFLYAQD/WXuNKT9TZbkWcjy0eau9rtbbjVRihnHpeblxZbFegtuWDmT8nOO6Hf
         Kk5sDyz/giRA5vuHjRkv2E1QfnGcW8ys1uLtjCOS/8753JZ2U1tHiIJ6m1r9KmoDbv
         kvQAFHQxHcjoO0e30rn3sCI6c3Qyc6UE5Cm9xOh1Z8xMhhbQiF+ugZmRMZv+19teXr
         G3PXzpFmAX/WEVTNp8RYMGXUHp6d1SXs2pSyQC4Kpw5w4WepF5s8czC+k8BsXg35I9
         ADokceIgzT0svv6+Og96Lyq4YlnBinrekiZqjXHsiI4P/vHVNCaQlCm4zMwbXxEXr4
         lE4jj+NdXrYrg==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5FF41A007F;
        Thu,  7 Jul 2022 04:51:05 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 443804006C;
        Thu,  7 Jul 2022 04:51:02 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="oLiG0z0P";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4bzfi8p+tC503GLjSqA6C/vt7xrDWUZgvmQzi0ci3VcE/bjCaRafBzbzKmZ4lH0Qbl62KoiftiXBVqfFMuuvVwcOIQnUXC9nud/XPZjDuJHv3drSFX1SS4m9dgT3LVgznBy1ChOZLs6Lz4gkdwc365v4SUFwifokVd0ZCz8mN7DJ73FoT2HXN5L5s/qFFAXmHI2oC2Yi6FTUFTLUdR0XxWvZTwiR5FhwZwjkyojCrQEOTn7iBxz6UF5Tl6Nqn9HD0Wv9tXIsKOa90/jcWBvdgWrypEOcf1VXHBcmsAtO1bxQfTZGmpgDxdpaU13GNo6iHa4KhDjxGrrxT4Zk9Uz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zF2kJ2sFmm5XX0B3/10wRrOk16tUjnw7Y5DvnhiXQQ=;
 b=F4CpuO0qEnSRbanBBEm4auGIYmWKSKBl2MyljVY9JQ77Ykdkn8aMeHJ82UjgM3wJFMAfC4DoVKh94gva4ezOeZhDvwlwmCFbq41O4TE6a75efn+6m6DcFPcPGS83cZx9M6eIpt9PPu23Zf0ykNxeH2lFOP/Vxd8nnLX0ZQg/0cuKznUAc1bbvhJxdskJ7I6jul+gB7J9SAqGrn2EAKu7BDXurXZkFmeMsH6T69oBx98tFztjQ2dGz3ZjTjOCkND3ZvLB4Sb+HUFQruA3iNh+Ql2whot/gwCdNaNUBzyrAWpqA/K9BtQA1orf2tgUG1+EcrWIRLAQNV9y769rTn2elA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4zF2kJ2sFmm5XX0B3/10wRrOk16tUjnw7Y5DvnhiXQQ=;
 b=oLiG0z0P0cWvU0M5ae9QJjswdPBGFtCvfi/CT6EpEbpC5ikDZezJyRDyLjWJlev12zxdq2BLxLc7ewQpd/g49u6JNGc09VCkDtqsGcNRaHZkGp8mQ7/PtF3jckzOXEKYFUtqFKoXAMgjPqnPzQECXWo4aZKA+vQTd8rEc4+vhzI=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SN1PR12MB2383.namprd12.prod.outlook.com (2603:10b6:802:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 7 Jul
 2022 04:50:59 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::8948:d205:4d47:c54c%7]) with mapi id 15.20.5417.016; Thu, 7 Jul 2022
 04:50:59 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Christoph Hellwig <hch@infradead.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        John Youn <John.Youn@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH 00/36] usb: gadget: f_tcm: Enhance UASP driver
Thread-Topic: [PATCH 00/36] usb: gadget: f_tcm: Enhance UASP driver
Thread-Index: AQHYkZDvNPvW3sRbaEm7K8DR0I8G9q1yU6OAgAADhwA=
Date:   Thu, 7 Jul 2022 04:50:58 +0000
Message-ID: <0eef8df6-4e2a-7250-e151-5fa9e8f0c999@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <YsZjPZxQZYhZ34Vh@infradead.org>
In-Reply-To: <YsZjPZxQZYhZ34Vh@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=synopsys.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa739ccf-b95d-4c3d-9882-08da5fd44919
x-ms-traffictypediagnostic: SN1PR12MB2383:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9k+15+Q4xC+iW+DgwNWhGtjWbebnnj6EHE95jQIZIXA13+AgaC/9nEgE1LVmpQT4w+qWSYwrm2W7FyD1Wt1j8sMkUtgiTFY3iRmQm8DUJGEHZvmdGOEyAeLcZGi42LgOA3nu0jNf9hDY1c4//uSPc3jvb3IAOjs/4byjMGzB6uBfihD3tOY0vQzcw11KvzeFcubb/905i+xadvRkolifTcVImKcnBNNHay+tuyPIAp3hW+SGiIRY02xBCW//8y9f5yc6H0pz/W5Nav0WcX7iYFJk75QkqT+iQgYGNLUnVl0i7LEi9Lz+2E1r0MI2Vy9wv280uooeS1D41LMR1FGzLTnq5f55Vmqg1P5BiBFenR+fv3AuS8EOQRGNclZFKnVP/NjsO2kJmf9I1Oo/xLRDu0WpO6OQI9AVP5neiEzwk/3xqCNzNyc3Vnh1XNQgowo00WbVVbxZ1q47KTxA0vWpYxOG2qo7t43BckPi/78bDBT50m0lbWR2Mp8I6Vj8U/WQHjDWCcPWxBC6Ty815Ppnw7NmZ2qbW3fF2GKvp4+v7BCDi4TFwx5HOoMDu6d8l4+y0RihilVxPzcO25koEEjcIOIq9q2/TBhDlNNp0WbTzjp0o8t43NuzOwcvorbgwzq9SIoRmH4e5fiEU0Qgxwo7X7qvt1LBR/OUlSTaliCJOJ3mYavIO9eUKmNO1asZZxp7rvW2uuwP/M9QLXb6Y01m0wv74kzlqVf2IW+fpNh7S5HreWCMPSVxNLBCSmVaY4Yl5E0mABvpkBSlfl2tvDNANDblYWW+GI8cZ5r9wFn2b5lbK9h9wwma0IsSfunluvKQWYpfsp3DGNfh5kycS+Hvdv/tiGc2M+oD9ASLj/CjypyO7jV5Y0Paoxgb7L2NSqQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(136003)(376002)(366004)(186003)(2616005)(38070700005)(64756008)(54906003)(122000001)(110136005)(4326008)(71200400001)(66946007)(91956017)(31686004)(8676002)(38100700002)(66556008)(66446008)(36756003)(83380400001)(66476007)(76116006)(316002)(478600001)(8936002)(7416002)(6506007)(31696002)(5660300002)(6486002)(86362001)(4744005)(26005)(6512007)(2906002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXZLYlNWeFBZUkkwS2dCdG1YTmFjVm5QeHdTOE1ZZnh3K1NyS1FZQWNJS2NW?=
 =?utf-8?B?SXFOSit4YlNtUWxhN2l5bkZSRkx6eUZ3b3R4UWp3OEtPTkJZem00cXh5KzlP?=
 =?utf-8?B?Nis0ZFptQ3ZMNkxqUnc4SHpnMDcrdTZaV1hVMUo0VWd0UnM5eFRUWGFldlNo?=
 =?utf-8?B?Q2Z1Z1AvL0FpaDFVQkVwd0Nycitseis3bHRTZVFZVmZjYzRIY2JON1ozNWtS?=
 =?utf-8?B?bEpiUi85clJDTE9WL2N2Zi9NWTJ2QzRndDhCTDBINlZpRjU3bnN0L3JZRHBW?=
 =?utf-8?B?TW11cC8vUGlyNEhKRG9jRUZJMHZYbkdpcjhVMVJ0QkdOdzZDdjdpdU5OSUhr?=
 =?utf-8?B?eGlrQk9BUXVnMjk1VGxDalJpeW9kRkZ0RG8vUlNHdTlPOTF3c2VGUUhXT1lO?=
 =?utf-8?B?am9paVhBYkdYNEF5akN3SnVwZ0FoT3N6ZHJMbHp2TDE5UGpTYURPOUxJSU5X?=
 =?utf-8?B?cWtXRERCODRkU1oxR0xHbVkwZTg3TktQMUZkOVNTcGIwVXFrWVVZMnhjbEFi?=
 =?utf-8?B?SEJibUppT3V1NXlpTHE3S3M5a3QwbTNHMW9vb0YwVzRodjh1TmlZYTdRMzRP?=
 =?utf-8?B?RHZHb0l3SitoZ1V6WStyTC9qUkdhNW9VdUM1Q2Vqb3lpTEU5YlhMak5wQUd0?=
 =?utf-8?B?UU9QblZxZzRiVStKS0gyR3VFRWx2Tk4yYmdZSnZWVnFpYXV5Uk4wVmN5ampY?=
 =?utf-8?B?MkExRmtsMnBhdVJyNU9VVUFDNTQ2cCs3MGVmTDRpYURHSGUrb0EweEFiZHRC?=
 =?utf-8?B?ZWhGMERGZ2xEMzFXZ1Q0Q0ZHYU9UNDNMeEhmUjRHVkRnTFY4TXQ3VHhpeWd5?=
 =?utf-8?B?S080VzYzZlZSMVhJQ1o4QlU0Skd5RFhSZnU0bkYvbGVDSnpNZWMvMVRQV2lI?=
 =?utf-8?B?Z1VXRjQwckxjelBJNkNwK0xvbDM1YjFNeDhjUlIra3RMdE1LMytvQ0doRlFY?=
 =?utf-8?B?c2F4T0NLZDQ4ZStVYjUzaWx6eEI4TTNRNG9FMzlkcHdiajBxckdFenlGeWRS?=
 =?utf-8?B?MGtsU0ZQMFJWeklTdzlQWkk3enVFQ0Vjb25GN0xNSE4xZEFwR25SSnB3MnRV?=
 =?utf-8?B?V2JXblZsY2JJUTZyYjRtR0pVd1dabEYybDZ1M0NZYWFWUG1EZUxqdDdRUmt2?=
 =?utf-8?B?UnZpbFZtVUg3VWltTmE4UWI0UFBodENqdkdkT2M3b0FKUnVhdkdUN1J0WXNl?=
 =?utf-8?B?QmxTNXBDWUMwZldRQVhYSjBnMVk2UUozYlZ1WE04Z1V0dFVXWEh3VlpCMFZj?=
 =?utf-8?B?QTZhSmdGSGVSZlNpTGJHVkxoVytXZDhZNnNBUUc2VkJETGVWMnNUbk05M3p2?=
 =?utf-8?B?emE5UThvY0lmcnlMR1UxamxDNjZNRnVOMFdyRHFrUVVRbnhQc1pMaUlqbHMv?=
 =?utf-8?B?ZDRmS3hJOTNYZ2pILzFaQWJXYXhsTkxvamZkY0dvcFk5ZkNSU0NrOUxIeXdk?=
 =?utf-8?B?M2wyZUtLZERHbUFnYUJTa0ZxWUhURVNzZVB2QSthUy9vdWNvTDZ4SVVON3dK?=
 =?utf-8?B?OXFNUEE5OE5QV2FLemdWazBxOGwxaFFaTCszWWNkbmx4ZWRuTDU0WWQwcHFQ?=
 =?utf-8?B?Mng0RWloVUg4T3dHanZiT29xTkVhUjRHYU1KZ1kvYk90VWs3OUJBQ2JyM0JF?=
 =?utf-8?B?enhKRlB6cG5ReGs0VCtkZVZPejJmdldzOG5vUjI2YVZ2THlsVFg5alFDeG9Y?=
 =?utf-8?B?V3ZqUk5aclB0N3FxRkZFdlZsRHdRY051cHN3SWFUVjZpcHozOVdYZUdNUTFQ?=
 =?utf-8?B?cXBJeWY5Wkc5UnZEOThwL3c4cWJWYVpWY3I3dkdPdWZ5NHRJUGp5ajRRb3Nh?=
 =?utf-8?B?TnZ2cHJLWkJkMkpabjQ0TlRudW96L3psUk5XNXBwaGpSU1RpaWNKcDBVL2M3?=
 =?utf-8?B?eklKbFo5VmhpVmwwSDNuYWZmNW9kS2FSS01PRVJIMFZUM0h3L2RpWGUyK0pj?=
 =?utf-8?B?a3NwL2RRaVE4UDJXaTk4RHJla21uU1FXb1FGeEsvbmVlY1N1M3hwS1ZYZFh0?=
 =?utf-8?B?Qmw3NWZtYzRDRmQ2OFdMZERKVWNVdWNDeXRRY2w4bnFvbGJud0pGUndLUThC?=
 =?utf-8?B?SFd1UnBjazV5K3MzaW5qZENFeVZPWWN3VFVWaENtS0hkc1lBemVPSEgycG4x?=
 =?utf-8?Q?zDi4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB86C70DAA1A474EAEA675DB71295492@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa739ccf-b95d-4c3d-9882-08da5fd44919
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 04:50:58.9997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lK73joSusYlX8x1LLSXoTOq9wV4tkH2Chnlxx8mNSF9eEuQVYWnhpEzfryDsmFRIoDJPnJ9fcn/d5xAMN03TXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2383
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gNy82LzIwMjIsIENocmlzdG9waCBIZWxsd2lnIHdyb3RlOg0KPiBZb3UgcHJvYmFibHkgd2Fu
dCB0byBzcGxpdCB0aGlzIHVwIGEgYml0IHRvIG1ha2UgcmV2aWV3IGVhc2llciwgYQ0KPiBuYXR1
cmFsIGZpcnN0IHNlcmllcyB3b3VsZCBiZSB0YXJnZXQgY29yZSBpbXByb3ZlbWVudHMgdGhhdCBj
YW4gYmUNCj4gdXNlZCBhcy1pcy4gIEFsc28gcGxlYXNlIGRvbid0IGp1c3QgQ2MgcGVvcGxlIG9u
IGluZGl2aWR1YWwgcGF0Y2hlcywNCj4gd2hpY2ggbWFrZXMgcmV2aWV3aW5naW5nIGltcG9zc2li
bGUuDQoNCklmIHlvdSBoYXZlbid0IG5vdGljZWQgYWxyZWFkeSwgdGhlcmUgYXJlIGRlcGVuZGVu
Y2llcyB0aGF0IHRoZSBmX3RjbSANCm5lZWRzIGluIHRoZSB0YXJnZXQgY29yZSB0byBmdW5jdGlv
biBwcm9wZXJseS4gVG8gZnVsbHkgdGVzdCB0aGUgZl90Y20sIA0Kd2UgbmVlZCBldmVyeXRoaW5n
IGhlcmUuDQoNCkFzIGZvciB0aGUgbGlzdCBvZiBwZW9wbGUgQ2MnZWQsIG1vc3QgYXJlIHB1bGxl
ZCB1c2luZyB0aGUgDQpnZXRfbWFpbnRhaW5lci5wbC4gVGhlIHRhcmdldCByZWxhdGVkIHBhdGNo
ZXMgYWxzbyBpbmNsdWRlZCB0aGUgVVNCIA0KZm9sa3MgZm9yIGNvbnRleHQuIExpa2V3aXNlLCB0
aGUgVVNCIHBhdGNoZXMgaW5jbHVkZWQgdGhlIHRhcmdldC9zY3NpIGxpc3QuDQoNClBsZWFzZSB0
YWtlIGEgbG9vayBhbmQgc2VlIGhvdyB3ZSBjYW4gc3BsaXQgdGhpcyB1cCB3aGlsZSBpdCBjYW4g
c3RpbGwgDQptYWtlIHNlbnNlIHRvIGJlIGFibGUgdG8gdGVzdCBpdC4NCg0KVGhhbmtzLA0KVGhp
bmgNCg==
