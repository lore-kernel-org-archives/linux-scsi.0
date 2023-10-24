Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD13C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 18:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbjJXS0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 14:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjJXS0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 14:26:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB99FA2;
        Tue, 24 Oct 2023 11:26:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39OHdjrA011171;
        Tue, 24 Oct 2023 18:21:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3eRRc4vVzFqm8a0MjnppOiv+Iu8cruIRXlJ0qJI3wpg=;
 b=TOIPqmGj2W/LqjZr8AXIu4HU1XTnL+b9B+om82Hb164JbU33tJF6g2uMlRF19BcWvvFA
 raetRQ2U8t9hzo7elXXSuBTUHB790ccpAl4DtEs7qqPd8MmMP1X49or7UR8Ljf3limYw
 3PT76pS8ox3dUOKSh0cF5r613Cs60NyTZtdNRByUQ7o38ucN8gyW9UbbF0XiwiUoh6FG
 Y5oshi5qlimXjTwZ5R0zgm1Jb9+VRkL5dMfhSeUADLX9kGsJCXmKQ8RbNurJ+V4WlCrU
 7pcNFErEd0qT01/gXiRP9WBbF0t9aq0Uv+W6Gyrst1Es029ZBE+ZJhIEzA5VKP2E5nVb Hg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581p4xx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 18:21:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39OHJ089019132;
        Tue, 24 Oct 2023 18:21:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv535v8ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 18:21:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KtXmEYOiVLmfmBHQ1hzv8XhIf3TbesxDlb/Y4cnquwSoLQMEMpJ7ppfQ9doh535B2931V11Xl/1jesVsClGm3ye27fNS8pRF/nFSl5yXhind1WDuXnnL6xxQYu3MC0ltFYxdVL9M4C1INixb40hCkabRgzWpk/Kvx0IorvkHyoth0s1JUUKo/bcPZ2uwRunPdfa7+j8+OB2qRbnwT/wMC7KN0Pyw2jpTKB1I7k/B/ZhsJq1X0fXLKLVm/uGAQyyYx0t5atuCSqsHnx8UxMK1a7PIk5aGnsxmBS/tOQtp7Ablm7pfmefGAXFTzPwNIf5l0HcS17y1eNm++L+P3fu4Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3eRRc4vVzFqm8a0MjnppOiv+Iu8cruIRXlJ0qJI3wpg=;
 b=DTXNogkKGKWCAjgISmLjhHZO8NPJ8evJgy/3L7VTl2YTzSt0Gn71RQcddUM/vq4Vb7BQcOImwAb4+Bw508P5+Z2inFhCUb3Ni+OzzdhvAI4mZ2PhekfcMVMWIVSg5+c0q1Df4K/qGaEl+SwGgINA1q1sKPUbPoB1E0Nq7tWyPplRkwJ2zdixEXAnAmA0hObXBrwOWcZ27CuFVOoUYFOZoqDnOcNwEa/tfAKpsrMPV4EuCketojyBoClnL1by9WIGLvwn8B4bFiipE81SQFOMSDYBLxGqaYXhehSAVjnXKEcAkQptpQGYouOAk+aOhGJLNM+xoFcT32aE5tkwViFgkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3eRRc4vVzFqm8a0MjnppOiv+Iu8cruIRXlJ0qJI3wpg=;
 b=KNte51ixg3KVd13IrwVXZJFY3tOSI5E5cF4aJhl/d6p0fF2iaqTiLG2ZOKQPBlctHEP1noZn/TxxFKZS8A3zAy27x2S8fNPonima5Hk7I46iXr+aJQjnndzj274YHTr118OvZLeDDMdx4P4IkxGghaJUagwir7MqgqWFJNwOk4E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6417.namprd10.prod.outlook.com (2603:10b6:303:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.26; Tue, 24 Oct
 2023 18:21:02 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366%2]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 18:21:02 +0000
Message-ID: <5782212f-e5fc-d482-cd18-a43d5d4955b7@oracle.com>
Date:   Tue, 24 Oct 2023 19:20:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v14 05/19] scsi: Add an argument to scsi_eh_flush_done_q()
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-6-bvanassche@acm.org>
 <dcd4019f-93ae-5843-b10d-af912013b3fd@oracle.com>
 <26ddfc1b-5290-4558-ae95-85fe01575c91@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <26ddfc1b-5290-4558-ae95-85fe01575c91@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::6) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: fe15fbf0-6dea-4ef3-ad4d-08dbd4bdfa8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVV0TNTHrDHHueJed71M/y0NKWlktCbEVxpEp3HupTmkpDg9vGMmnHp6p+IhQpSS4n4ehGC2929cTjC8ZM/6ZsCrV/sRbxyY5Usl4hg8JndOKmGBvXxW/FsPlwc4FDLMkwFPVwOF9fZ6BWI7HibHMciV4Rb5axIBfviLAxgkCru5mfVZ1DPtanlTeALbf4fTtqNgaGj36x4Mo3xuqn1xgbQx7OVuhp6WWdhN3U7f+UnR0brj+ZgN/6xjKhwOFykt49Wv8b5TMsTFX2sUdaez1Sj78srVn0wQwLn9HfRoIi7LN53FslAvld53WtmlBuHvMgs41rR1h80juWWuo4FGB1TyQ2Gspts/XLrW2B56dz28SvoNyRWEpjwvaZt3+zL7wHCeqXvtx3xEIZCC/hCHupoELNnf6d0SKy0IiFREcFy6zU3Hh0WZUpmL0bKSyyzou1Y+bgHftd0FonIXG0dqkycokIogn6UKNIOs9CnqYnqLojJdZdW3JdO6ven2a1nUL04yxZXi4fT0sng4RYxxEotyl5h+nOkYQLIy2TQYfc0S1ikNtZdJUa/aa9NFdUPit0NnyyLfBcx/hql1pqdMk4PC6w2eQA3oAf0wOWmrGKGF9J7Si6S69zd6AgnYoVZx688bJ/0dYYuxDRAATd/aWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(136003)(396003)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(36756003)(41300700001)(8676002)(5660300002)(8936002)(31696002)(2906002)(4744005)(86362001)(4326008)(36916002)(53546011)(6506007)(6486002)(6512007)(2616005)(478600001)(316002)(38100700002)(31686004)(26005)(6666004)(54906003)(66556008)(66476007)(66946007)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGY2clA2N3dCb29kSkszSVZ0bFlDN1lWUjRtcWZ2NU95VW5sbjhHYTVsbmFK?=
 =?utf-8?B?aXkvRklERkMrYk1KZm8xOUV5Tml2TklDakd4RVltbEQ3SmdRaDQwTXo1SlZP?=
 =?utf-8?B?WDA5UExVSW9hTEVQc2VoRVFOeis4dGh1MnV3MUpmOHg5bDVWR3dBaWZjTm9m?=
 =?utf-8?B?Q1BKOFFqSGt3OHIyeVpkbUJVQ2dxTTlEY0UzYU1NN3Q5ejlTUTU0Y2t6YVQy?=
 =?utf-8?B?MTByRzB6QWE0QkE4Nyt5N1FaT1NPNk9XcHN0QVhGbkdNZGNEc3RqQWhQZTZN?=
 =?utf-8?B?RDB6UmFkUlJSNWxGak1sc0V2VGdMK250NG9uMUlyWjE5MW93Q0NKLzUyd2R4?=
 =?utf-8?B?RlFDaHMrdE1XYzBJbi9rNUFEekNISFl3aTU3RU1DbW5oL1hqdll1bHBtZnBZ?=
 =?utf-8?B?bzNSbmRaeUdpb0JwY29EZjgxc1JxZlFNZlNYdEo2ZGRkUFZMMlZHUE9aKy9J?=
 =?utf-8?B?U2RpOC93emFuQ2hUOGkxVHY3dElQZkdpRkxBTFh4ZVk5bjZqSGdDMkJrVTFL?=
 =?utf-8?B?dm8wTWlnY2RocFRyck1KM3F1Zldab3RKSEFoV2JwYlA0MVhIS1RWcklnU2Q3?=
 =?utf-8?B?blFEUGcrd2l3STNPdGRVamVBQXZ0THNNNXZuV0J3NFdESG1ESW1qVDhYemM4?=
 =?utf-8?B?Nlh4bk8zMDBvWkt2K0grQk5XdS9rWjhCa05ic0lZZFpYM004ZUp1TXJpRXlE?=
 =?utf-8?B?QlgzNENtUzVoWVBzNmp3VmxqcWNESDBHa0liclZPMkJ5VDhxcWFoNEdjWVoy?=
 =?utf-8?B?Smp6QXhJWTU4L2RoM1E0ZzY2TmtPbkhHeWwxQ3ZDRC9rMVQrWk84YzArTHkr?=
 =?utf-8?B?STBINmwyUWF3QmpJanBVbjcwVDFmd2gvL1FIdEEvKzJXa1FlRmptbmlycHY5?=
 =?utf-8?B?eExvdkV5cTdXOWZ0MFhUWWx5QWxrdzR6aE1Ta1RtNENYVnlMcDBrNE1Tdk1Q?=
 =?utf-8?B?eTk2NXowcTJjTnc4L0R5K0dtOHNKeUM1VExxWkUvK21rYWhlcjFaQVM2cXJp?=
 =?utf-8?B?d2JpeGRLdlVkL3ZNR254UDd2TGg1Vkp4WXFyZkl5dEtsaGUvK1FvWlJTNDFu?=
 =?utf-8?B?ZmlpRFNDdjU3KzlWOFpOYU5zK2Z2dE1lOWFZWFV5anlVSHBuSVJBdXpKa3pp?=
 =?utf-8?B?QTZjeTNiQ094aThrb0JST2hONnZhbW1ZRlhoWVcvZlFZWFBGa01yeXg0Rms4?=
 =?utf-8?B?bVhSQ1R3bktkNEhDUmFZdEVRL3l2dy9UUDdDd2RGUEZDbU5jR0huMUZ5ZWZT?=
 =?utf-8?B?YnhNNW03L2dwaFpPanFDOS9ncUdMODZTQUE2WlR2cGsycTE0UE1LcDJYMUYz?=
 =?utf-8?B?K2ZtVFJVWjA2VkxoT3JSUW44NllNaEtQbEJnWlF5WUF6b2dEMnZHVk1LeTAy?=
 =?utf-8?B?OVVDZlUvcXQrMEdKdHJITHpDR2JFZ1ZQOFQ1TFRkRERYbUNwUVRBSzh6RkhI?=
 =?utf-8?B?Nm9UNHY0N2RvTnBzeW9UWFplNTBaeDhpcE16bFJrVUZYNE1BWXo1Ym8vb2pL?=
 =?utf-8?B?WDYrVzhOVUJTU1d3UXFSc3dEWExOeDlvMjhaNm0ydDJQaGMwbGJkRzJnOFBw?=
 =?utf-8?B?R0VrcUY0Tk52M2Iya0ppaDI5L2R0RlU4ZitUOVl0RlVOd09tbkFHWDNDVVcy?=
 =?utf-8?B?Ykw1L1lOQU4wUTh0V1BUT3FmR3RCRUpSdmFIS3ljVm5DalExbit1em1DSHJJ?=
 =?utf-8?B?SUg2dVJ5dXYzMjFVaDV6UnJEcE0wK3NpSWp1QzBtR3ptYUVLSHR0VDZzSjNV?=
 =?utf-8?B?TEUrbk1uMXh6Q3B6bnFjS0hTcUp6eUZDeHZJcmlOM05sM0pOUlZRazArUm1a?=
 =?utf-8?B?NXRsdVV2Wk5yQkV1clJpWlBuMWpwenZ6aEtwWUg2M01yUCsyTHJXR2wrYlpn?=
 =?utf-8?B?UGUzdkpZdEJyR3UyL1hmdHBnM0VWQTg3NlRoZk5lMUllb1dkZi9vRGFRMVJS?=
 =?utf-8?B?Ym12UVJHQzROS3FsNEZZMkRJL2l6cnIxTURyZENjVXhDWVBVdkE3UjQvYVJT?=
 =?utf-8?B?Y1dINjhjem8wSkpBWEI4NU1WY096eXJKaGpLa3NxK1JEdzBjQUxlMEZ4NGox?=
 =?utf-8?B?alBGZGF0dUN2bjE1eURaTGp5QmNoU1hLdUVrYmU2UWdsNkdEcTVBWlJVNmky?=
 =?utf-8?Q?xPnQfoP5ArT3sQTQ7yJvShrxE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1w8eiR0P/jNUpKABp3+uljZW5aGE8qchHCM1XRAgM0n3ED8XIP8f+poXs7IjZkwrCH2e9A+vAzU53lkkuXoyBhzqhMlXGlInBxMJAzA3HvH2k3PRyp188mj2LEhg+NqB0iKlojSDd+PdbTL8s0/5RBaDsQIfpM6gwvtbRkRjwuL5ZZxGWlmOGSblAaVOaytzsuxj/hDfDBttxCeRlRve1a4wIGT0Yp/XKTqv58/4vYFZkK7YONtROiWdMyanK0iGxQG9eCkLM7KSqi3l4qq7KataQEp/B30Yv9jI9Ha9SyScdpj63cYzTaZG6J8bb3o5FV1NK+az650wmz2mxe8AQfJ0ImcK3oOubbSs+M0N/SPcpWvX1qAh6clQtKOvY2T0yakSgWzHkPWE3UumjzrmewkvThveRgFOKze0FIRXgMhvOiAv/qEz6ehGX4XIrbB1qtUTG+VzBdF5THpq62iJwyuEUVLOKlyVdLX2fZLMoGlyrJA6+MgxenJwlS3llR/BQDXshVCPsLvACuInUjjHx4EGLcvzttalp0hlB86CK48nCX2c0AJaKxzpAIFdquZUAxG9thNOkkY8bHcBIW18QAEzYhnjINja9eXxUaDgLf35ynwYZyg3i+pivRyACJL52E/MhkZg2DV1K6QtHSO8d3q26onlAqNa+b7XlzR4tx5M8Rtx/edcpQL+XOdaOBd6NgxylLO8uG7FpJH94ZrY1YhlEOItDJN3jhhKClZYS40L5DQZnF0RYDYxTM7Xe9c/MHM3IWevhqtQHQ229wmnaXHD5ijSJ1pWeFmfm0UILqUOaiWZJMzJStVwsN7N8De0Ktrl+8WfpM4CPSpEZu7Wg/40dwLYK9lkgJxu9YPCjRz7P1XPem9pk55CAl0piaOwRkDDji/ggSdhMdAnJP7PenRs8M26bLGMTKvKlXXuIwQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe15fbf0-6dea-4ef3-ad4d-08dbd4bdfa8b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 18:21:02.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RGU5NgsqBgMrjuW0tXJ6+psae9RK95XZR3ZD3LEP0ElvL/LIUq9aqxQl/iOFGdz6FSToGrE5Sr8OYD3Lb6ClQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6417
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_18,2023-10-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=790
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240157
X-Proofpoint-GUID: a9nGw4fGZLpp4x_6CtUEd0UZQpQERjul
X-Proofpoint-ORIG-GUID: a9nGw4fGZLpp4x_6CtUEd0UZQpQERjul
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/10/2023 18:17, Bart Van Assche wrote:
> 
> The linux-scsi mailing list has been Cc-ed. I assume that you are
> subscribed to that mailing list.

I am subscribed. However I have a rule set up which filters anything 
linux-scsi to a dedicated subfolder unless I am explicitly included in 
the mail "to" or "cc" list. I guess that many contributors do something 
similar. So this means that for this series patches end up in different 
folders and it becomes a bit harder to track.

> 
> BTW, I'm using "scripts/get_maintainer.pl" to build a Cc-list. 
> Unfortunately git send-email does not make it easy to combine the
> cc-lists of individual patches into one cc-list for all patches 🙁

I just normally run scripts/get_maintainer.pl on *.patch and use that 
result as the git send-email address list and never bother with "Cc:" in 
any individual patch.

Thanks,
John
