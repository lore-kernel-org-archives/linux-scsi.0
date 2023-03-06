Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CC6C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 17:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCFR1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 12:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCFR1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 12:27:38 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BED367816;
        Mon,  6 Mar 2023 09:27:01 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326GwrWU003384;
        Mon, 6 Mar 2023 17:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fo7+hNK3lOXNySsz1C6fcn75UrE9/Zio3ZIejxvkC6Y=;
 b=eMteeB5QaLJkdOuOEUpWcT6365eMrsSoyTUSN6AlXbip2vskC6JhSSHV++opS7r/aW9u
 0e/N3AvVZVkNFka0hhFzsT+YpHkT+T6dkW1/Df1pU6gxWHXF4X7m0NnzXVs1GCnqU7MY
 43hwqA8ygb3s9PEwYOwIjMUSzeOzGKiC24rld3nu34QRpQGcimrtegOekYPTLUeLTBVU
 d75jyQStwNCkxF8OsNSzJvIeDT8yXPM9xS2Q7prX17QHgT2Nf3506fqnJdhd+7Ao727t
 vCG/NcOgoRlCe0myzqGKWh6GzitPa+z5C21VFJdpOYqyVBnvlM0io+c7Zzt/uAEYlOLj 8Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xugr1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:25:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326HMpgm023367;
        Mon, 6 Mar 2023 17:25:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u051fcc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 17:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FKGHLumHtoipsBjVuhrSBV95xN1jCV+EGTF3eItEhv0WYMA1+1bofuiohSvsEUUhE4vnIBm6aNGCBe2skKPDQY4/KW9aUGQWi7f3MRXF9P9S+/vFCE2B4ZpveHb6Nuffxn7IiDvC+csIYiJsfpSVBrvghk8mCXe1ygzpJFhecZW5CeogXd1VNO/XNQeTdhkwidZi7GWr2YraqmUqJqBVvEffx7za+4Hvv/u4mSMeLlFLI37ucJQLPrp8WsPG7kjSlws1FLOJMU3QW6o4A9tSirbJrzlIef2MiWh4TdjzJa6UTwsyZDlQGvy4n15i2HtfgTf0Cs29f0r0WN38F7pWuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fo7+hNK3lOXNySsz1C6fcn75UrE9/Zio3ZIejxvkC6Y=;
 b=JOfhTsw/DNlEdS/CY+9uUNtDK86ELM64zrrn3IiqJfthU8EcOE4Hx4icqXDnJ5USHXQC8pADJUNe3sDkiDGTI64WoITJsGH55dsgG9eanEkGw4zD51XDk839W69ooXDbAK7Z87eTbkpqkLp+k8t2/LJqXLWpIgRymvMcRiWAtHsVPPmjhACU+vxWDL5GZs1Vu/WmbIfedehfaoy36JHlcENfnbZE2pXDVJNe0AKQkBgQUqrX8RfWdbQWXyizi3dy5gCkNCGg6qA5pSue4bIq+5Zh9Fda22xOjc0x8dkOnfcgTpuBMiRdw6WrXzsAa2fEE2Ku8dF0HHgOOvhZq3eW9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fo7+hNK3lOXNySsz1C6fcn75UrE9/Zio3ZIejxvkC6Y=;
 b=ZKPkdyJ7BcOry46QUx84nQ0cRGRpkn9nQtF/M69aNC4Azg9i2SNBotMvzZh6It0H8Y5wCq1VJNzW6P7KGAvCMnPdlp4Rf0i/Kxh4gMPX9S4+2YrcPJgTpStUTF3AGLWs9uvABHETzORQtyVQeMXfeCh3kW5e01XQJqcZiHlM4m4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB7546.namprd10.prod.outlook.com (2603:10b6:208:483::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Mon, 6 Mar 2023 17:25:23 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:25:23 +0000
Message-ID: <55874bd7-5c05-4d55-c780-c4206156b708@oracle.com>
Date:   Mon, 6 Mar 2023 11:25:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 10/18] nvme: Add helper to send pr command
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-11-michael.christie@oracle.com>
 <b4b5feb7-521b-fc5e-8c68-a05bea292ebf@nvidia.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b4b5feb7-521b-fc5e-8c68-a05bea292ebf@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0067.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfc83e3-e903-4a3f-1263-08db1e67c4ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfbC7mtZikQ8vqa/fuTD3Ao7M2LS+/HanmfZQiLtDu8ydp2IhjYfqWxgEDcFK3FDYEGtBAzLBULFyHkcyrxFhqOzwARLUUNQtzB1osmKmEATYLZJBXTbC3LMBPIO9JS2bzlbokiDB6JMEK2ttRvZobiyuUMdOspkJnjqHoJzcrgrwWaQLGx2u5CrZPy33r5NSGXmyXuUV1swJxaSBIRbtpYftho1uYc9QoqUQrk+U8+ZkQ2YQs5n6VuRr+ptS1Ix3aGrqVcst18lQ6s4SOzEnIgXy92DAl/aE8bEoSX9I3DI8t1po8krNfEzFvMpAoG5gh2FfELYUvCUxa8qXLUJHmsN6V350vS2ZeL/aEhF0kLmfEjRFR0USdMCDfLz7qg169mxFyLCNR331QacJp2Endvba5LU1g74nc8Tl/bFld11oWwrS/IcJvRpZ80N94hsxJY3WEwOwClFn5HkDRabYg9fiGY6AYqjet0CjAOpPkIcvvGggIJd6K7qoXvw+h2+hhJ3m/uSck6YIb4q7r1saEGzcE5pzo81UpFaVxjtZtxTBFPtPBIYQJ52zIYylH7Bk4cjYWlTQqy2f0RJFbE6Jt6flLsfiZlEHEvXwLzTbznlBZuMsMhqcK8u5vtvjveNC4iENjsAH5tmJL62nAjAGdDypwD/eWVfsBMMy4OMjyelO4v+LYLaEXbYdaNj21AhtHX7mTPMF04bzT2sMaawwfweM2mh3yS6U1Rh5HR4zTXt5ugj/qzeQUV8aFnmXsvq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(921005)(86362001)(31696002)(38100700002)(36756003)(4744005)(2906002)(41300700001)(8676002)(7416002)(5660300002)(8936002)(66556008)(66476007)(53546011)(6512007)(186003)(26005)(2616005)(6506007)(83380400001)(110136005)(478600001)(316002)(6486002)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUtiMm9XMzhGd2lDTTg2ekdOWExzVlFXejZqak80VEUzR0hlQm9PUVVWMXNq?=
 =?utf-8?B?S3N4M2k4MEhIS2ZPYUxvNFV1UjVDNllCM1hlY1ZmR010UkI2MnlTYWFQdDc1?=
 =?utf-8?B?eFd5QlI4NGIvYnlFbnZjNnZwNUNKQ3laa0ErWTJmWUJ6MDN6U0pPWFNzdmpx?=
 =?utf-8?B?S2FERFdiaHpUSjBZOE9MTUxZTUp6NmdSZFJ2eUI4L0FHMVlGWDBrZmVGTFZu?=
 =?utf-8?B?bXBMNDJiSlV5eG1UcllwT1UzdThqYWczVU5mM2V3ZmZWaHp5T3drY0pycElG?=
 =?utf-8?B?dDFzMFhiNWtpRi9nUWNIK0pRMnNyVlJwWUxSdzNzSTBqaUNQdys4RnMzdTJz?=
 =?utf-8?B?eHg5REVCcE91VjNNVnc0clFxY0NOYzV0V3hJSnZEdkNoQkhhalc4OHpWL0Nq?=
 =?utf-8?B?cmFkNWJBSzJZRFZxdmZCWDRmZXc5dWNnSU1NZ1laeFZSZ2IrWGQzM3ZEZGl5?=
 =?utf-8?B?RHNpZGJOYkxNTUxMUmNtVzFDa21UMW15LzhEQmRxZG9JSFlFNzhsajAvQWpO?=
 =?utf-8?B?b2NDR3JFa21zWHFWdlRpR1p2Yi8zQkFMYTdjTEFYVWJDK21RTXhXcUVEZlRt?=
 =?utf-8?B?OHRhamdJVjJHcG1XMnJZSUNzWktMTGdxeDl2aHE2WUp5cGNvRG4zR3BnNWxj?=
 =?utf-8?B?eUhHdHFvUzFIeUs2YlpsdU1pMXJWM291SGZQbGVFWXpGV2lxdDZGalZ2eHY4?=
 =?utf-8?B?c2ZIRkdEUWY4RVE2UnFuaStkRWd2NDd2MUhtL3JBY3lUMTZZaTFPWU16ZVpG?=
 =?utf-8?B?em16dUlSUFgxWGJrekliYWRZTFpKYVpTdTROTFIyYzdFdllPN0R1bDB1TTlN?=
 =?utf-8?B?Mit5UVR4TmlscGJtR1JtZ3lpMXpVa2dNZHFNRTFlNXNjU2R3ZG5iRFhJVGJ2?=
 =?utf-8?B?UHE5NVRzblB3NTFNMDc2VlYvNDZHdmFrYXRSMEVFZEVkRTNvSDFSdlJZbHV6?=
 =?utf-8?B?SFRqQXQybERlTFlOUWJYbEZnem9nYVNGc0FlazdPMVJ6K2JaZytYNDZSdlZG?=
 =?utf-8?B?MG9YZHFHUjRObk14K1VtY2NRNm5OSGtnazV4czd0WHU4ZHdEdnk0RkdPZldi?=
 =?utf-8?B?THcrSzBzMWFoZFB4KzFIMUEvWTlnNkZoaE1UREY1UDdRUzI2NmJkb1pKaFRD?=
 =?utf-8?B?T0tIdnFTdW9UNlNWMGNnTkVZVmxKVXNKdjU2WFNUSXVzMGNWQTIyTEZCQkcy?=
 =?utf-8?B?R2xXS3pueVBnN2d3ZDA2MU9XUnNiL3JrdU9CZzJIaDB0QUtORzltNVByc2tq?=
 =?utf-8?B?K082QzIrTGc1V1Jla3VyLzlMakJZcGpGazlacFNPMmxYTy95VGJ5RDR0Z3dL?=
 =?utf-8?B?cTAyNnA3TWUxKzNMaEVQc0p5Wm1CZGN5WHJjRTRrZzRkTjVXM1g2cTNuUTlp?=
 =?utf-8?B?Q29aUncyWHQzMzIzajc5V0RxSGJBTFdBdTNDcnlLSmR2bngrL2c5Z1VSSUN6?=
 =?utf-8?B?UjJhV3ZZZHFVOWpZSVlYME9ERjBHQ012Um5iS0l2bXUyb24weFJoQ2Y3WEpV?=
 =?utf-8?B?MVhMV0FXeHBWdGRLQkF1YmRMbHhCSHovL0k3RjNDaHhEUGJ4QjJTWEJMUXNr?=
 =?utf-8?B?QWN0SUdFR0NGTThpd0hsUjFtaS9meVlOaUxIeUtpZFYyWmdYYThiSmlYZ1Z4?=
 =?utf-8?B?cDZpMWp4L09aQ0xYcTF5eDFLSnRieXR5SFpFNDl5TGxzMlEwczZxclpDMHBy?=
 =?utf-8?B?TktjZWhzRjM1OEZmQW5WMjdYVkVrWUpyZit2OGwwNjh6eEFQVkwrYWRTR01I?=
 =?utf-8?B?ZG9jVjRta1UyVmpLcFMyL3VVeSszZUhaZ0lGaFZIMnpOT051a0ZtWTFDZjEz?=
 =?utf-8?B?TlBtZkdEUndyQVV3STJOYXM4V2ZNZEROMTc1RWFFbDNONngxR2hHUlhnTGpz?=
 =?utf-8?B?WWo1WGY2SW5HdGpLemowOHhLNjRRV3Zjd0FJdlovSDJKcXlkVGg5YkJhMEpv?=
 =?utf-8?B?bHhCZVc1cFRRTGxGZkhmaHF5VXZnMFU0QysvZXFoMTNPSlBmQUQ0N3JtUS9Q?=
 =?utf-8?B?VEcwUHY5T2FJMW1VcklEemZTZm5SWVJpUmhqcWxTM3R5N1pQOWhLMDBzT1BN?=
 =?utf-8?B?cjlSUjd0VkRQVnBBZjdLTzRES0lZem9jcVVqQ0FOSG1iWjhQVldJbkwvL3lS?=
 =?utf-8?B?YnQ0cUdpVVRkU0Q1Nm5BbUtzUUhFNmxGSFpkYm1FVk1XU2xMZFZyNFlZTFJ3?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K2xKa3VrT3lheE5IN2FmTTB0N0tibXk2WFdxSjU3Mis1WkV5cFNNbnR5VzJq?=
 =?utf-8?B?cm5iR0tnRGFGcjRMRmZXdWY2T3FMVjdqZklaQ1dCNW1Xdjc4ZGw1RjNORU5O?=
 =?utf-8?B?R0lSRXhDUExnYmpXNlk3RG1rZFlZYkF3bVNEaTNzS3BWREVuZGVwbjdOdytK?=
 =?utf-8?B?WkpXKzZjcTJQeWQyRWVNOGRQVXduTDVVRlZsMG13b2lncEU5aTBjQ2tIdDdU?=
 =?utf-8?B?UlZwNTVDWFZtOG1GRG52YVM5L0pBbjBoekN1eWE4bm14SXN2VkVGczlxTjdu?=
 =?utf-8?B?NmpEbks1WDRTb3lDNEIwZUN2YVRReU10Q1FFQ1RwU3hWVUh0WjU1MXJKODE3?=
 =?utf-8?B?VVMvenNWSHdFakxMOFNPMlVvMTR5OE5Xc3M2VFJLL21mR0FwQm51bVcvZkpk?=
 =?utf-8?B?OVVIdEpBcmZTWlU4ZzRkSU5QS2E1ZmhoMkI2QmpKbWcrSjhCMHZQYytwRjI2?=
 =?utf-8?B?YTUwMWlyYU1EOWFPUEIwaFdFS2RacXhBTTRoSHdUYmgwL2o4eFlXdWR3S3g1?=
 =?utf-8?B?Nmdjd0M2ZWxZZ0NYLzdzdWpkMWlXUGdzWkVvaVA3dFEwTENOR3ZENHV0WWsr?=
 =?utf-8?B?dldodktzZStsd2ZTZUJOQmMybEQreGRUTGROaDhkaVN3SjJLVHhwajR4OEQ5?=
 =?utf-8?B?d0xxWjBaaXRwR0gvSkQ0R3RqYnFaUFM5SXZUME9INzhWZ0VHN1pOM0s0c2Nu?=
 =?utf-8?B?dFZwMzBZT2x1VTlOYW4vMHFoQWdDSGtqbURSM0w2TU5XazBBelFMTVZkNTYw?=
 =?utf-8?B?UnRxUWxvSXNKQU9KMkp3Q29nMGVKYy9tY3dHQUkzeUI1cGpsZ29leDhiNnJJ?=
 =?utf-8?B?SzBqWU8zaXlqQklsb3cwUmxFUmt1TkMwVVkvcGxDSktKODNCeXNTM3diUXZX?=
 =?utf-8?B?enhXZStFOGVmdmIzdm16N3JiMWR2QWo3TEZyMkxxRi92NHQwdVEzL3d6S2hP?=
 =?utf-8?B?YVNsZkZvbHJabEE0N2x2dmJERHNiZ252aGVkeWJ4WmM2K3E1Y1pzcVQ4eXdw?=
 =?utf-8?B?dHVTejB4ek9LTFZCRGJsR214TUQzem1HVTBzZjFqL0VCa2pjZnZ4TERKa1d3?=
 =?utf-8?B?QzE2REk1ZFhDVjJrVk4zQzVYM0NCRkwxMytPenlEUnFzenZUZlZRRjQ1OXNj?=
 =?utf-8?B?L05PSSt3eUorWVAvK0MwYm9kRHZzM1BMWnZCZVFEd0s0TVhzb0Z5TDhCbTcw?=
 =?utf-8?B?TnVKcllaSFZzeVJaVU1KWUVVQXJuTHlBRi94UlJMbFI5TlVERS82c0xZbVg0?=
 =?utf-8?B?OFBTN0tjUjUzelhEUGVaUUFOL21rT3pjWmZSazZ4M0c2SG9YcEFJdklQSVVT?=
 =?utf-8?B?dTJUN2VzQ2RNdklrbzd2aVVaWkR6OGt2RWFaVjFNNitDNHN5UHRUaUlHemc0?=
 =?utf-8?B?SkhVazIvMmtZa3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfc83e3-e903-4a3f-1263-08db1e67c4ae
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:25:23.4670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l67PSWdjoyeB9KiqyRhgqgGx8nnv2W9G7LbqzBFcuqHEXa7OJxdvDyFDp5uuqKzjxZcbjgpZGgHhGRWAauH5dLa3PS++vLpQviaCVGFPATc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7546
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_10,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303060154
X-Proofpoint-GUID: wYAbemW-Ov5Nj85Bu7DLT_KEsjeJ8zPe
X-Proofpoint-ORIG-GUID: wYAbemW-Ov5Nj85Bu7DLT_KEsjeJ8zPe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/5/23 3:28 PM, Chaitanya Kulkarni wrote:
>>   
>> +static int nvme_send_pr_command(struct block_device *bdev,
>> +		struct nvme_command *c, void *data, unsigned int data_len)
>> +{
>> +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
>> +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
>> +		return nvme_send_ns_head_pr_command(bdev, c, data, data_len);
> below else is not needed after above return..


Will fix. Thanks.
