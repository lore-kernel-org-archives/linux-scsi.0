Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAC7C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88F6161246
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFPDvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:24 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8942 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230390AbhFPDvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:20 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kTcZ028388;
        Wed, 16 Jun 2021 03:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vROhp+Ufaregfq0EgdJfvT5ZYXzaoTV1zAy5JkAOBU4=;
 b=ZbLxlh0TaoG2KvIq3jkr5ANraUoTE1Td+ddvxoiskSn5ffWUdYCYe8mI40drq1bX07B+
 uo5fwQRzzIoCMVf9980lYk4BJHiQwbXAD4Y/qTBtPFMTCXZp3mCAde6o2uRaHq/3Scqp
 lji7u5p3N9ejGq38f3o+bnzU+tqsFIEEGl+ZfX4483jyDcupL3C8gCO/vrq6ioZPovXN
 1QOkT+wC3bI8ZS/NkT2g1JQHyvSQKruA0UA9lugHbInVBp4eIvQ/c1WPneXSG4xNgRex
 Un7OAV89Lbh8CtuAsidN79HNKNcyzI4j4UKaN+KM67YLuoXwqBjTwXtHO5RIz7FSDAK9 aA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39770h857u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3j1QM034001;
        Wed, 16 Jun 2021 03:49:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by aserp3020.oracle.com with ESMTP id 396was6yhh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b43BqxDv+JjwxqkNtdJSs/CULiU9FkvdFvk5yCU7T8M7KAmMNkWzda86qov54UbF6CzLlWfwdMAVfTyJbaHuo7oZNlLYuiHyaJD8BHfAbzr3BUeXNsuV6ZfadcEAKY0bgVEP5qvmeqKYy7DvWIeGLCwTGRdFsGxiXpIioLa3wAS3ozWAoe20asOYRCeHHDwIdlVXmgHu/esUbyhlJeeCNL9qdJ2Fhnjo3qUwx9kV3Gaw5/Nd243JY2Jcf/T5qcShn91j5wR9vNBjXouqCLQLylZxgU5h5IUpyO2zj+cVt0Kyub57b1fTSIjmiHP9i4NSn47dNLFPO1erYh3M+3jxJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vROhp+Ufaregfq0EgdJfvT5ZYXzaoTV1zAy5JkAOBU4=;
 b=G3d2OFG/Aa/aB2UoCdhL+q1nyNCINWwsFIAACVGnEnvPDupDYkfZBCJXP4oyfyhQK9s7hAG2RM9pD8hzyz9RIjr7i29RJCDB+MuOnqVWAJir7N8s6nFJIZqW9nLGzSbf/SeXa4aSfZEI/HwQVG7R4KL5CZAGAQIXFzKv7thivN3w6cITaXyn8nTUIQkR8lXR98gzKmm2d1dOpE1/2ZzUdT9m8IsjjLPy65MMN9XuS2W+sOtN8AYpVotOWfQrFhMF6Pwvqy3uvqbvmza5QRGbkvNxAU38/H/m5/jHpAcWUTFSVcWTjX0RTLd5jq2RDi3SeGBuBdOzANrrHB6l8ss+Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vROhp+Ufaregfq0EgdJfvT5ZYXzaoTV1zAy5JkAOBU4=;
 b=D6w3hzNgxqeZYSduMQYkEW+lftPcWMJmvJmPjXg7a745WSV7DphX9KktcvOBfZElITmvQnFesHKaJFc7NDcz9VCPTcQQVsa8aREwEkSOMjG8gl2fS3kqSfw1a2jBtKqaCdGA8ZKoEVjIHRG9hv7coiUeztWjrqIqPWGeQIZCO0s=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:09 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 0/3] Introduce enums for SCSI status codes
Date:   Tue, 15 Jun 2021 23:48:49 -0400
Message-Id: <162381524893.11966.14020312846954326507.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524025457.11299-1-bvanassche@acm.org>
References: <20210524025457.11299-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d100d7a-fc5f-4d74-32ed-08d93079b260
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663A8018FA3986449FE42B28E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aas8fzTSwSsViGqACqbiHpd1hbDTGaw+XqpNv6H1GDe/f+5JbUgWnUaAH8qmcjH7gMeQrnVsQ0xdaYgkolEC553f6XcJCY7lU6B27Jkt+QI8xEj1iv48sHojkN8EaC2hesSzM1A6yRrFOMYh9qOgcFpDI+UBSP2o3X3N3TnAVHjdNO0/YXGON2cQ/RZXhoH+02PAB09SCKjzMpEjjauBtldmS589EYg+JUoqBU+2R1YH1aZggi1HL+h1miXjiAw0TwqEE5t5bkrvDn+GecS7gl16YHAd/rlCVdBGXAJWrKMN1IpwZs4SDcJYwgw2w8yfpNfKX2I+qlIkl/kJKXx8Mi1EwgIIK1l4guQmi+9PGR0xnRxA/XekwBy3yqpnlFNaJmdtcAddd6Or/bxIT930RQIIwj7Nc5HPKUVqU6cclK1OkCmR3dYAOx3ltOKzcQToiaK2F+oGexuXWn8bT7rJtPDUmYn8/JdoVFRJD+t7thzrYML++gAUoyFuUpW0eEl3xeT3CVAm+sYSgVuY+gsi7l47LPYltwneOjiETUpjzX778e7GvL8yKPrWg/zrIoSurrHzP5/cZlcvOo8LA9EZAo4hwr9fAJ205P6nOEmvu5v9XzApHPlxh3wG4h4Un8q4TpnlBEEC1z0lZzXyUE8+8VyKD3FNuuggokfpgnFL0KrQyAi6e4El7RrdVMVK/yBVKQF9YomWNnYe+LsDzN/mFBziLDKRfpUcTxL9ZT7hPdbbuJkJLmbLX4pmX2WMpSX4AVjS0WkBecWtnqOn9maaKfr3o9TBijgJW4JYT6i3UNZwZP+lwtDj8b9LEpANYkg5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(6916009)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alh3NmhaRFB5M0ovU2FIaGYyNU5RcldLT2xPMkNWczNUbHVEcGJvOWFteklp?=
 =?utf-8?B?a0MrOXpjQUZzbGp0NVJ5S2pLMGk4cENUTVdlL3NpbDBWK3pkRTNMbktKZFpT?=
 =?utf-8?B?cG00MlNVaG5WN1IzbU56bTFlUFF2b1ZIZXc5REQySnJsS0tkTk1oWXRXQ1Jm?=
 =?utf-8?B?R3NZdzhTczZBbU05M3ZaQnVpcjZzL0FTUDBoSjVEUzI5UWxZb3QvZjRVRTVJ?=
 =?utf-8?B?RG1DQlZ3Z2tBbWJzbW95TTJEaVNXWThJdFNTOWVFQkczRENENzU4bmdvMjhR?=
 =?utf-8?B?Y3NOaXp5Q280TmlXQkdodUtjYklUNVRrNUJKU2xucFNPMWpCR0diYVl1T01S?=
 =?utf-8?B?bm9wVGJRbG5BWFlRZXYrWDM5RlgrWndWZzRxbUREK3lQV3ZEek4wVEVnR2pu?=
 =?utf-8?B?SVRTTGxVb3d4V2dUbDBvcE5kY3pNbVBFZTU4Mk1FSjdUaDQ5SmZ0cVkrTGM1?=
 =?utf-8?B?MmZZK1IvQVZJbmpsbW1xUGFMekxlK3FjdGt5eFpqd0RxckpEdm1FU2hJdW5D?=
 =?utf-8?B?Q2ZEWHRTMGtVdVhnSlI0ZkJkYktoRGRVcnhJZnR4N1VOT0xRUEtlMmY5YkJz?=
 =?utf-8?B?cEdaZjhBdDh3VzRtYkxMN2Rvam85cjREaHFpOUZEQ01LSmhGa1ErK2pzMS9U?=
 =?utf-8?B?eG5ycTVOWnNjd0IyMUxOTHV3cDc5NER0LzZUdWFORHhmWGNDRmFRWlZsR2JZ?=
 =?utf-8?B?UmpiSU1FaUoybk9NZUNLamY1b0tFK3ZaZmw3YXZBdDdxc1RSZHBQUFlWZUMz?=
 =?utf-8?B?OW9rRkllV1lzYTVSQnRYZ3BqR2ZhU2g3NU15OWpYaTgzekJhbDN1ZHVpRTNK?=
 =?utf-8?B?c25PakYzM2U1aDU1VlZsS05lTHpTbFc0NEtBVFlNbHh0amc1S3VBK2hHb3Nr?=
 =?utf-8?B?THpaNEpWdHZxVE9HdzIxb0hKZUc2RFZCQ09DT0NvemJZaW1KYWFISVJtemxK?=
 =?utf-8?B?cDZtNFljTTdsUERJZS92Y0pxMlJDMmpjaC8zc0NuVDRGdjM5RlNDUnFXb0NW?=
 =?utf-8?B?dUFYOStBYVVVUVpVME1iVUVuclB5dmFhSVBnTmo0VDVkN1JlV1JxeENUYlZl?=
 =?utf-8?B?VGdGcTdUOHV6MkE3akVXWkRsVjIvWDNaYzFMb0VRQ0F3Q050ZkQ4eTFLRSsy?=
 =?utf-8?B?NHdNMzJwd0JYc3U1d0pZQVZGRUdsRlEvWkYrdUl3WUZWWUE0bjV4MXUrOFhU?=
 =?utf-8?B?UVBCY084T0w5Z1BoQkxKcFR5REJpeVdoN2kwMVlSQVVHRWp2ZDkyV2Zkcnhq?=
 =?utf-8?B?dUxSZGxTRTRuOU5RSzZObmpYN1JaYVR2U1BqcmlPczcrQyszOFA1QlVhNVQ4?=
 =?utf-8?B?cVR3cUlOR2lxZ0ZSOGUrbmVKNTl2bnVEMkdhME5FeGJVRnFtUUU5eEJUUEU5?=
 =?utf-8?B?ZmtMc0RNdXU5VzVWSWVuc2pYOUNwRUcyakl5V003WnRSNFJGVmVjYzhIc3N5?=
 =?utf-8?B?ZWtRVXM3VXVEM2RXcFd1bm5xYlBnckNPandXN2ZqZGNRaHI5Z1FEYkhoU08y?=
 =?utf-8?B?S2p5blFDY1B6YWt0NnFObUJUM1dSNmxJN3JiV3VJY3c0a084YWplbXRRei9M?=
 =?utf-8?B?dCtpSVhYUjF6ZVlUYXhvUitGcTdxWjVmRmRXL2liV3huNXRFRDJXT3ZJNGR3?=
 =?utf-8?B?OEROWUdTbjE5MWZwYVRqTEZ1S202T3dWaGZiRHlqWmZ2YXVuZy9DZHl5UnFX?=
 =?utf-8?B?NVJ1OCtOTExKNGVYNzNTNEdpVXZxYlhpV25HcGE3c0ZWT1NsRWJ5NEtmdUVE?=
 =?utf-8?Q?vt1zZW7HwgdZ6sGSQ7glCNcCJqz6zzRfImSnzN2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d100d7a-fc5f-4d74-32ed-08d93079b260
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:09.4019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3PtJLbu038nHulbGA+MBbly8Y0XbbQPrCm9NcuCmPhKmqOJKwaIVV3cFfSkVAoNVeRUMhrBXIpUwdPB9SSFpCnI9BExN6W7wM8G8Pm2zIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-GUID: Lm9dstKvbBKvLDrqEc1WsJyUkklODVlh
X-Proofpoint-ORIG-GUID: Lm9dstKvbBKvLDrqEc1WsJyUkklODVlh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 23 May 2021 19:54:54 -0700, Bart Van Assche wrote:

> This patch series introduces enums for the SAM, message, host and driver
> status codes and hence improves static type checking by the compiler.
> Please consider this patch series for kernel v5.14.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/3] libsas: Introduce more SAM status code aliases in enum exec_status
      https://git.kernel.org/mkp/scsi/c/d377f415dddc
[2/3] Introduce enums for the SAM, message, host and driver status codes
      https://git.kernel.org/mkp/scsi/c/149d0e489e80
[3/3] Change the type of the second argument of scsi_host_complete_all_commands()
      https://git.kernel.org/mkp/scsi/c/62af0ee94bfb

-- 
Martin K. Petersen	Oracle Linux Engineering
