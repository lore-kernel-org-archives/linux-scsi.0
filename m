Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8178BC001DE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jul 2023 14:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbjGaOnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jul 2023 10:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbjGaOm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2023 10:42:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E330AB6;
        Mon, 31 Jul 2023 07:42:55 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDTJUe029569;
        Mon, 31 Jul 2023 14:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cdD6sf4OOa/R/ve2hNTLcchbWbVqyUDhnDjrXjvtDTc=;
 b=HUD2kBmiI3IgwGHn9dIZ33wt/kNZQ2batw90HhQCAJ/MYKDhsev4iYjqiC2uOVv+DuQv
 sqOIPrDMHcKOU1St5BYk8Gwso3QfEZ0XrhXvYr54YLkMj2veLiSGij8Cg8nDdJ69Mfsg
 xaWmVqwoqxWDu8f6mjbqTuvIrvDCg8pxeK+/uvt670IY/pBPRRppZbux8ndkFb8d6VVu
 bTy/Mxr5nn7BQaGX+Z9DBvm6EifTe3heAtRpSFWNjQlwJLKubx52Jw9bm3nNz86Wrr4x
 rd37zmzIQM63Jwfue7w+aDeHv5beOctOfJyccF/WQLAc4jKao5Ha8d7FB2Vqp+WblaFq tA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd2rsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 14:41:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36VDbesA008582;
        Mon, 31 Jul 2023 14:41:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7b6enp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jul 2023 14:41:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJfjW89KavZe4mAcK/GeVpWghby9CTbHCsdwwKpmBbWlOXz/80CFGlolu+Uc0hImEZCGDhyLYUtzVdpcTFhdJ9hzAO8Qi+CfvtGNsk6w8L1Iv6Z7gEmYouZs+0xq0y45/wMY7aE2zSByjJgMQ3BhirsxK/h9+n/3Q130IB3FWecfLBeI9fcLnkvS8NMSu0BnDxShTkkmO8X3lwww7m6qEoVXI4ph5hcGUwnRibNcBSvq2dDJc++97d0RKCB7dtZMl9PMOWe/1DGVa4QP32zHiklE4BW1W6atJ16iDYRlnSfFjOuKbyDq3FLlqxBct4v3RkDACj0YaYq+2dZr3TPguA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cdD6sf4OOa/R/ve2hNTLcchbWbVqyUDhnDjrXjvtDTc=;
 b=OniGf1mZTHtJme13qbyQ9e26XDABIZ/YzQUfFTnzpVVH9Jk1SOJ0V+Nh4kEzzFGgdzmS9WWNz/pesgSb1rahEQKgsy9xeQBud/k/Af00va9yHLe2kzp+JONc7R831Nh5iz9mPSu2w9RBaJW3jqIfgCEQbYAFNA7NwvDde/bALk9uIwxsnO2Lokg3oro6j+KvOp17IfSQFjv20X+lgvVoctkC5KgfrpGIt7SmO1G8RBwAgxKLecplThsdRm/8bpz6h7sW9qPZYwrTX9tkkAQAExAZOF2I6YP0YGcda5DD9wVx9YgnI6RZRsJlO+CeT6hUdRl1FKCG4oWHR4gbhjRdCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdD6sf4OOa/R/ve2hNTLcchbWbVqyUDhnDjrXjvtDTc=;
 b=cMldNLoj164raMYV6Fxhk377d6PHt3p91bFM5ys25glEqXDsqlFtAojencnl4lHQmr7M4bzgvdHnngK2xGLy2YO+7uZs2fIaPh7XFltOOMLglQ1kBM4yg/NRBtQmAvrNN20FpnmBGy0L12xXbVyu36jN8s84fftDiOSxHgMInrI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7432.namprd10.prod.outlook.com (2603:10b6:8:155::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 14:41:08 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6631.042; Mon, 31 Jul 2023
 14:41:08 +0000
Message-ID: <15ffae0b-075f-dcda-9c2c-514e76ad7325@oracle.com>
Date:   Mon, 31 Jul 2023 15:41:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 02/10] ata,scsi: remove ata_sas_port_{start,stop}
 callbacks
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230731143432.58886-1-nks@flawful.org>
 <20230731143432.58886-3-nks@flawful.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230731143432.58886-3-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0066.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7432:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d01b4e4-2ccb-45b8-a244-08db91d42d1a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VzL9e1plIXgBbW8i7iMh2ZC/LepYtNBdM0te9EFcxkpkImB9ATpwaj8UJEOKz74bGAkbwCZ4m3SbWKrpQVDBOJ3siYsTsSnbEK16s2jZ12ncNxor35pvZQ19eP458EInX0lDTUeKLgeYP0cjrSSmzrp2t7YkCLo8BjGLZPCxOZZCkzMhyPA3h392hxLBFsx9QKt43SQqaRJnoCPfee9vIorK0sgGhX1hpD+Ae4lRUCb5XSziBqtIwYhJHXwsYoqxMJfRirEdf7F7WAHnCvhQzuhtmswECbHIzPjsDuxqe7+LKdOfm1Uenoo1PkiDsVWDXglv4/KF+YWevo41R9U86Em1J20+cM8iLMft7B9IRmYzJDm0fOh1b1RlQCNhrU9V3RZFJZ/bIAGIxgOtDkqkkXFwIKrHau15Pz9dZVg+iePe3hcWFcq7PNuSy00uzxmYmUn7S8NYGqqpBf11LvehDnUMx4R5DUW1xIRH3fFA2VSVoTpRWKqrMGvg+e6zYwKTimHbvHycvrVtVegXplS0fCFLE5JG6dQAT0TEEk1MDSFlRjDJdNFYwotQQEPXgBhSeUvtfu/F2uGltkVq5m/O7a7fAlnHluZkJvn2mBUKr5bjzv8WXKEogFaPsQA1XnScsucM8bn393M00MIn6+VpMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(376002)(396003)(346002)(451199021)(6512007)(6486002)(36916002)(36756003)(53546011)(2616005)(26005)(6506007)(186003)(66946007)(66556008)(41300700001)(54906003)(110136005)(31696002)(86362001)(66476007)(316002)(4326008)(5660300002)(6636002)(8676002)(8936002)(31686004)(38100700002)(2906002)(6666004)(478600001)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE1yZUJoZ0l4Z0ZuZUdhc21jSDBSMmQwMTYyZGk4U2dtR2Q2TVZzekJMcXVy?=
 =?utf-8?B?VHJyYWxlaFFPY1FDWWM1Tis1a2VaY2N3STVjazdXRHRxVjZvaWxzdVlVc01S?=
 =?utf-8?B?RDhOc205UUVuUkZjUHloV0JvSzRVeWI2eEFvSG5qZjUxVUdubWViL0NuNlZZ?=
 =?utf-8?B?b1VFaHlTckVtcjd6aXdhY3lIVHBPbjIzQVVpR01ER2krK3ZCeVNqc3o0eFZN?=
 =?utf-8?B?ZWZZNmFhUVdpdWlMTWE4VVkzWjZERWM0QmJrWkJIMUVxbC9uN2poeU5BZ2hi?=
 =?utf-8?B?c09jVlFXT1Y3Sm9NUHIrcnhySnBubkpldFlORncrSlpsWDBtcGNSK2E5T1M4?=
 =?utf-8?B?c2hjOFc1Z1VEckJDQi9Meng1OFR0TkYxLzJiUFVPYk9NVFlmNWNBSk94V0Ja?=
 =?utf-8?B?M215enN4M2dxRE9oUTNOVWpWMG5IenpRc1ZFTFdxemxINjcvSUllcmVVZUVE?=
 =?utf-8?B?QjEzeTJ1SklubnN3TmZuNU84TnNZUE9hemJxMVFKTXlVQ1J3U3FOTDJPR1Mw?=
 =?utf-8?B?RVNmdElOU3BCZExLaUFTTXVWTnNqVnlKSURwd0Y1MSsyS3FnRHZ6K1pxeWRq?=
 =?utf-8?B?WHl3VTJiS2NaTXowNzd5dUk1b3ZRYjdjNzdSZHhCcTNTakZoMlZ0UE44WHB1?=
 =?utf-8?B?NEhFdG8rZjNhbjlqVVZZZy9WZWxNdGZwREtOaU5PUnVuR0ZmVnRLYjcyVU5H?=
 =?utf-8?B?ellzMFRWenBwd1ZIc0NhOVFkTnc4czBVU2lSUTlGQmkrdEY2Q29OQ1VxWW5W?=
 =?utf-8?B?STN4ZUg1YTV5cDdWV1FDRW0yREsyamk5UjRZdnQ2Wk1QbGJHQnZkWDdFMHpy?=
 =?utf-8?B?SXRCY1FWRzJmZmN2UHBJSmd6VXRWa25EQVFaTXBJei81UTkrZE12RVI2L2Nn?=
 =?utf-8?B?ZWdOR3dmaWRPRkZmb1JSTTVTTzZsZHVOY2V0TThWMVdiUmJxTmc1OG1kQndH?=
 =?utf-8?B?Y1o5MkxERkpFS2ovbWJJVlEyc09GYm52NDdTckNRbCtKZW05a05PSVZiNE9y?=
 =?utf-8?B?TmFwdVQ0QmE0MFltQURTWlV1SVVUVzhrbkVWTWtlcEYzNGJHT3c2d0FvU3F3?=
 =?utf-8?B?c1VVWXh0bUw4WFlFTkxrVVllMGZMeHc0d1NIMUYwY09LUGhaT0g4eUV2U3pQ?=
 =?utf-8?B?eUNadWgyaFIyMTFHS2FXVXF5NjM2cFArcHp0RXVuck41YTJMQ0NpZlhFa3kw?=
 =?utf-8?B?WUNvOEZXdW5Ra2p4T3ZTWWxHUk5HTGY1Y0dsV2JFZnBzMFRPdWdkK0FZRCt6?=
 =?utf-8?B?eHE2eER2a01IamowcjlHendhdndUb2JqSWxJMEhuVmFURHNtaW1BVUZDMkVv?=
 =?utf-8?B?cEF6YnFRR3hpQ1hlZE5tZ090d0RvUzdQSHpQdmRPRTc3VkI5aG9LZG9zSUtq?=
 =?utf-8?B?M094RmY3bWZLVStkd3g2bWpjOCtuejBTVys3T3l5SXFhYTdLazNvTllycmVY?=
 =?utf-8?B?TmJtdzhNTnlYQWFTZTg3UnhPMklKb2FlUXpUaUtVcU1wUDRmdUNvaS84a1F5?=
 =?utf-8?B?ZjZBUWFWcGVkV29tWGwvRWkrOURwN1pzRVhOYW1UdzRIb25CZnVyRldPTzZC?=
 =?utf-8?B?NFVUdUFPRFl5a0RYZkFubWFuUGlTd2pwV0F2YzdVL1JzdktRbk56R1hIWXNG?=
 =?utf-8?B?U2NEYzZhOXJ2czh0RzkwQ2ZSUVlFTzVzbjhVb2tuZk13LzdkNEJqNUxMUms2?=
 =?utf-8?B?WXgwWnFVRFFyd0M2TnhwU1Z4M3ZQaUQvRHgxKzJLN3dhbkpLcExwY3ppMmlJ?=
 =?utf-8?B?RFJBYitnN3J1d05lditoMk1tRG42RUs2dUtYejRxcjN3VVpqbndmM2ZDUWtL?=
 =?utf-8?B?VGZMcEJ1YmFWbGJjYlowL0IzQlNUaGNCSzQyRXR2ZEZDVCtMcTBHU2xpZEE1?=
 =?utf-8?B?Q2VtVllkNEk1KzBVTUVHeTd4Y3JhMFNwalZ3VC9tQ1YrSW5DWFVFaFdYZkNK?=
 =?utf-8?B?NUhRdjFrZWhnQ3BMVHRGbmt5UDljajNPZWFtbXlYTVZaMi8yUndWMkdZNUh4?=
 =?utf-8?B?ZEdFWGRrVEFsZVM1ZHZqVEdTU0o1UDhOQzVCakxVMFZOdGNScE80eDJpL1U1?=
 =?utf-8?B?ZU4vekxqb1BVdVplL1o2RlFJaFJOZ0lJZjR2U2V5M0pUdnM4Z0RocUpwcjJv?=
 =?utf-8?Q?9HiViVvpz5GnNlk1QqMlM8G75?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NmdWTkh3eHNPT2xRbU5zSkJLakwzWWp1cU85OXQ4NVZicHRYWXlkR1ZsREdz?=
 =?utf-8?B?c0pDNXd5MVNiUzVaVjRnVFpBU2tybWNkWnVWVHZCVlQxdVNTUklOMWM5aWJ5?=
 =?utf-8?B?eDdUYi9sWFdxazRvRHY0eGVyc3FtOUNWV3ZHejhpNXQ4d0ZmSWtwdkhoSFVU?=
 =?utf-8?B?blRqdzJSUUptZC9sWEtHRFBjVFpQYkhwck9mYVFod3N0Kys1MzlGNTMzdkVH?=
 =?utf-8?B?emp4dlRXNGtNclhRTE1oWTFLazBxMDNkRUVrZko5ZG9ucllUcmtpYjIrMVFp?=
 =?utf-8?B?WUduM2NzaFVXRGYxVytGOFlaTFh0QjE1cHVpOFk0bzY4bU1rZ1RFZUx6djYx?=
 =?utf-8?B?em11WXlkdUdRd2RkZFkzRXBhbmlLV1o1ZUxsTE01MUtMNmtpNjJOL0tLdXJH?=
 =?utf-8?B?b3FaWEtyMXRiYyt4aXdzek1QcTFBMW9NT0ZobTYzOTZHblVXZlRxNHp0OVFL?=
 =?utf-8?B?NUhQdVFIWHhHYlpTblducGJ6WE55Q3k4Qi91Qkk2VVNOcGs2UFhWRkg5cW9v?=
 =?utf-8?B?MnlQcU1tUGZyc2JyeUtRTFl0MVpUVWcxdE8wUmo4S2xnRWRMcmNKY2VmREVS?=
 =?utf-8?B?OFNZZ1pkeGlqSnZsdmlhN3dNZ1BNMFBaOWpqa0cvSkRLMC81UC9NWHI5VVRS?=
 =?utf-8?B?MWs5ekNTbE5HbFFmZndlNktwWERSRndrUitGSGVLVDJSY2JpR2tyRVRxYzJR?=
 =?utf-8?B?K0dZYkdxcU1iOFlxVzk2dTl4UlV4VDRmR294NnJKQU1pd0V3S1hwcmJ2QTls?=
 =?utf-8?B?ZTJtRUpENjc4KzBvUkFJblJXeFluOXRtZjNxOVdkOE5JUFA0R0NWSzlBMkFD?=
 =?utf-8?B?a3NjdERCM2xSVEkycTJUZzdJalBzZS9kSWtoWHpEN2l5NXJhVm1UY09tTG14?=
 =?utf-8?B?RXpnYzVPOEVUWVB4UnFFK1habUhNMG5BRGlSQk9XenlmZnNZM2Y0ckR1Y1hy?=
 =?utf-8?B?YTJOV2VqUDdQY0NpQlRTSWpmMWpjbHJZclVKaFgrYzR0SjNMTGhyUktGVDJq?=
 =?utf-8?B?Q2E2WHlVNjBTNWZMRGphUnNlaWg5SExNa3EvekE3OTJGZ2Q3RUp4REpNWmZi?=
 =?utf-8?B?NUF4aWJTd3lIdW53Y1JHM1NndTZxTVRiK3JQb05IRGx2UEZqTkNydTFCK1du?=
 =?utf-8?B?VlJ2dDZVUkxEekU4ODE4djNBUGJUTmNNR21BdWpkZ3owbENsS3ZiNmlRWEk4?=
 =?utf-8?B?U1F1NFF4Z0tvek91bktpdEpVTjBMcW9WZWZrQ21tUWFnUnJ5OW1UZElIbm8w?=
 =?utf-8?B?d0drQkw5MFA3TUx5a3JaNjdmWW1ueE9VOWhjTDlTcjNIUGExQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d01b4e4-2ccb-45b8-a244-08db91d42d1a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2023 14:41:08.1150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VoBBmMruahBksTwJFb6m/RiJkWiV5vTsF35GZfVl7xo8y5Y1jjoShDvKoSWPfgj/fqafh1k0BonELjZpesPkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-31_07,2023-07-31_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307310131
X-Proofpoint-GUID: 2jxXdfcCGzaQ_lfYh7cKrl3iG4fzEYbH
X-Proofpoint-ORIG-GUID: 2jxXdfcCGzaQ_lfYh7cKrl3iG4fzEYbH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/07/2023 15:34, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Callbacks are empty now, so remove them.
> 
> Also, remove the call to ap->ops->port_start() in ata_sas_port_init(),
> as this would otherwise cause a NULL pointer dereference, now when the
> callback is gone.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> [niklas: remove the call to ap->ops->port_start() in ata_sas_port_init()]
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> Reviewed-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>
