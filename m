Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C0EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 10:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbiLNKGG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 05:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237951AbiLNKGE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 05:06:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B0D1A06E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 02:06:02 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BE7IB9t029203;
        Wed, 14 Dec 2022 10:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8Yp3+5fNRN2cLzeDAJ0PWHviJWlhC7nz4bTFDkHrsnU=;
 b=lb2Cfd/mr2ASJyztybv5KA2iMdAQL/0xQAJA9JmEILc6x6a+U4b+TTsUCzl0Ln+sy1sS
 pErJmcgNQ3ZejgmETNIoSJyBGw4OkGG1uLKek3F9yVM5Y0t44ZJ5hYtaZSacm4CNSs8x
 huQRzFfi2o1fHN6WBhbLfNaJt+ejd8/NOKnnky7YM41TntQ3DBTMlELU6LUUPgvig0Mx
 vRTj/wcVGlblkrPG3s4tEfkV+M5wmsrndvtfhqHc2f8qaWsdVY3AI1TfltU9Jf5poZdz
 7mQwyib4xSvTjz4D0DVuuJEE2rpix3Bcd9hSbXfF5v0o0uLxpIYjYE1nAVPXHxpyRNuY rg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewsq7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:05:46 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BE8fC8c037586;
        Wed, 14 Dec 2022 10:05:46 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyekyed8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 10:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN5Hx7Ejj4i9dm8TdxNSMbD7U9MSd0S8YNnJPDzJRcL41q1a76LRDzl7pC32gE71SU0ecmMCvz2RKyochBlobevablLDdfM6D7wXU0JrAL8HbEVARUU6HPAJrtjN6cliw4LPcur8waXhoYaij+VBtqFHVoK84jywj2lLO3Lkj1gnvNqr0B1F1bPpU/mZ8GaQ9yFbxRAatw1t9+cRkiIpAceWrYBQWV+tVZwcPRsbFp+MV96vLb0dNliNiU/2hKfXzrflFRQpbaNHx/u5qEHfVtxaCyN8+Q0RK5jlCwVAf06vf+YUGTR/XaHF7UljK048dRGSb+604udFmNkClDaACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Yp3+5fNRN2cLzeDAJ0PWHviJWlhC7nz4bTFDkHrsnU=;
 b=kjyf9CSHp5Ydf26eXAOfHgACq6nSf/4tvpBrKO2i5kjVd9aB9Hve+E1ptJos9yGnCyAE805+NUWYUiIBwe2Jb/fmOkFuXz8+oVrp4cnRgsrNE08Du9ZoamskilfhKTgZiXS3NrqAJZW4U9YHEAmMc3wNqgQjO8a+/YN/sUIK6CYNr4Ss0jjqQmHR8UZHbReErtMCoCR94VcIpX908CVDbxxDjNXdjuEAgbUusQCc0s0aJMRFv/K12QjKbZz/G1VnlmCCFma7hfZ2MhS5HtvD0Knw0WwDvoVNMiOW9xoTfdk3cqrqM3Kn2iBX2NWt7u7FwM3QJfRbP9CoxzJBft5nCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Yp3+5fNRN2cLzeDAJ0PWHviJWlhC7nz4bTFDkHrsnU=;
 b=nlkUTaEqrgVTHNMs03/RTbJHQLdHngIuQTA2wCADPtU8bcbhQDa4nnAs0o8ipJoxrbttE3iN8O2d5z7LgDRIQxzJxSUYI2bcgezKE/0KjRaXcN5/rOh53nnxPrPehUokQ9eK1e0uMXNOqFyIw4pncA6/+X6eGryZJeL/d2hUUhQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7319.namprd10.prod.outlook.com (2603:10b6:8:fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 10:05:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 10:05:44 +0000
Message-ID: <f808191f-6723-257b-6cd6-3e2db2fa4b27@oracle.com>
Date:   Wed, 14 Dec 2022 10:05:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 4/5] scsi: libsas: factor out sas_ata_add_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221214070608.4128546-1-yanaijie@huawei.com>
 <20221214070608.4128546-5-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221214070608.4128546-5-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0299.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: e57c35b1-64cf-42b3-d991-08daddbac379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMqgqbgEAnXY+94mMH6bQIlmy0nihxObEuggkTIMARPlcoc+vUdlqQyKTjIcnuu34ylpVPfVT9mCn4EWhW5HCQQ4zoiGEmTSpNmHIXpbA7USr8B21NbbAJFmyb7fS3knpNRGOoOnrbZXDz1ujX+kettRTsFc96ewMCEegFl1nkBywf4MOTK9ErPHz+c6gus7slqSc9LtSslRjgQH0t5icsGchgtb3tojHAPW2z8FlG2GgH26V8NJA9pOQ7SmepKet6B5xrztpl0IHgmWou+PbyVyZg5WLJ20M0HhfvFZD8EXwMu3RTJ8Q19k3iGYAtvpIaM1pbAaxk/N759HZQz3Fb4qO4A+lSjcIHWdXkmHbAIbJvejznssEJUmJUiXEp2T83Ta7XomY0Rt3uZNtudt9R99p2+LXiCXJMjVf2vLHrNcLRSbtr7iM6BJpEDAVyYqcrS6HEMtjZBOn7By7qoQbDKtqzFVDVEN0w1pH+yQ424DFgmbgRRlORAAsQ1caQWg7KkEVOtpDv8CITL1QFhL8+PAv8wu8l+z7Ctc/UtqiX4YH+HQHOCgNn5uG988J/BcPDUFsn5OtxnBN5rRWKqwwMsdLRexbzZJiDrJzHW97TlM/vIRGf6XpKmFKKh60fi9W/kzLTHK/GCc96ojAb/hvdKl5lZaxkFqp1EGsZ5lKZyPS45kS5xglPgEI3YKkaGZ8dvGzc4THNlTVhEv63ImEKvOcvBl9FhhUtLxNQXebyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(376002)(136003)(366004)(396003)(451199015)(53546011)(86362001)(186003)(66476007)(26005)(6512007)(66946007)(36756003)(2616005)(31696002)(41300700001)(4744005)(5660300002)(8936002)(316002)(2906002)(8676002)(66556008)(4326008)(6486002)(478600001)(36916002)(6506007)(6666004)(38100700002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajI1ZXFCc3NrdkVYSEpRWG5FN1U2aiszMDhuUXlyUFJuSWQ0WHJ3U1NUSVVs?=
 =?utf-8?B?bkNUNE9MSnV1MzNnSmphVjQranJTdlo1ZlpvZ2RZb2xOcVhxQWZjT3N0NDR6?=
 =?utf-8?B?TUViQm9mNTh2MTE4WWhUNm9lL2w0VFhxeFZOeG51MXBmVDVUS2lwN1VqR3My?=
 =?utf-8?B?TzArVGlvSTZoR09LMmxqaHRNeS9WZTVPMnNWWkNyYjArUXdtZFVsa0wzdlh5?=
 =?utf-8?B?Z0sxWm93NS9YcjZjak9haHBtV2QveW4wRVZaZEtxbHo5TmZUQk0wUmgzUytn?=
 =?utf-8?B?bFdwOHArYUdEUlVBVWx0S05McGFEWElJZkdHZGFQK2F0WjNLSUtaVE16VUpL?=
 =?utf-8?B?ZEYwY1Z2OHZ6Unl5VEtEZ2NOVWxhVFdyRnhsRXR3THlYbW0yUjYrNDByVW5o?=
 =?utf-8?B?dThla3k2YzNuVGZsQ0UxN0V0WEtiTUdQMXZqMzdwVEpNMEpLaWZWakJwWk1Q?=
 =?utf-8?B?S1ROZWFPM25uNGdJc0I5ZkNTTkcxTWNBa1VvWXhiaTdjSmRpbVF6VWdMdTZT?=
 =?utf-8?B?YlEvZks3WHIwTElERUh4TjQyaGZtOXFGblhhQUZIell4aWx0R1JiVHdNWXZV?=
 =?utf-8?B?UXNNQ1M1YUhkQ2VFR2Q2UXRmc2dFQXpDMWtsWDdTQzFhbk05RnM4K1MvMHJ5?=
 =?utf-8?B?SEhJTTRhVGo3RGVBUVBSZlREWHZhcTh6eXdHNlQyaW52amp3KysveFZIQU80?=
 =?utf-8?B?OUMrYktBbWxtVUdjbFBmbG5obmxMS3d1M2ZMUU9sTnhscDNBVFNyVW90VWRH?=
 =?utf-8?B?Q2lzdmU3OXlaaXRMU2xkWVN5N25oaUZYT2gyanNFUlRLQUkvZjdaVVlMK2tS?=
 =?utf-8?B?ZElhV1h4dmFLcCtIQkIyakJ1TFVxUTFIcGU0bi80ZndCQk95NmlQZDh4Mlh4?=
 =?utf-8?B?OGMvU0xNeEo4TkZRM0NwdlBnd1NEb3BrZDZwUUt6VFpZZGlReThnVko3WXJN?=
 =?utf-8?B?OTAvZXZvbG9MdHRadTd2Y0VzZW82MHAwQkg5REVWMnJ3NWNqdUdEY3E5S1pZ?=
 =?utf-8?B?aU1xeEFmbHFCREx5aHMrdkp5VFQ5RzBpeTh2MVpWRDNBajhBSmxmZFpSOTdh?=
 =?utf-8?B?YUpjRkZmeWFCeFZYclNJTXZQaHVvcWgvV0VQTkVMOGJrbDVOVjk4LzNYeWNh?=
 =?utf-8?B?dHo5VDRVRGNYZlpHNUQya0c0eUJRRDZSbklDdm8xTjRCMTNZV2hDQjR3RFpN?=
 =?utf-8?B?Q1ozTEtmZE1wOGFPWjZ0ZHd5Sml5VHhBaUl1ZjVnVzZ4Zmx4UEdqdWVaTHpz?=
 =?utf-8?B?VDg1K2xFeUdXQ1dTTGJYU1I1dkxpblVFQTJJWG02TEZKcDV6L2p2OEtOelJK?=
 =?utf-8?B?S1RteE5kNGI5dy9hYk1kK3ZVOTA4YktEVDVrdTB2RWU5MlYxTW5XMURCQTBm?=
 =?utf-8?B?UDQ1Y0JzU1NBVjhFMGYzUVdqMjAzcS9DUWdZYU9iclg2dmJ5M3dMdjExNDR4?=
 =?utf-8?B?RlNVSWRGZU5CckZSSDluUTFrVSs3Rnp2VXFuOGlBNS9VbkRtbWlwQTUrdkMz?=
 =?utf-8?B?bWphYzBYWE52eHdCeW9VZGJZYkkza1lCYXBrZkV4WEowUTVYVDBHaTlJN3cw?=
 =?utf-8?B?L0JiWDMyUnJFMUtEZmVNeG9tRUdNTmlzbFlsQXRKTzBFWG9qbnFVTklqWXhK?=
 =?utf-8?B?ZW9UMGVhcS9jN2R1UkpSbnNsZFZpZnJxNWM1THN0Mm9YR1dLcHVyMDI0Tzd6?=
 =?utf-8?B?cm1sUEk0UUhkN080MEUrcUVLV2dSV0pXUElwd2QwaC8ybmY1TjVCa2ZockJi?=
 =?utf-8?B?a2xZUDRwV09xUlB4aklaYi9qTzkzbm5QenBSWityTTN5MzZNRENGNlB0UUQr?=
 =?utf-8?B?S0p6TGJHbitYbUtGT2QwR0I4QlUwVzRwWG1OZ2lqWkt4azRnRzFaZjlHR1Nn?=
 =?utf-8?B?eUx1d2VxUjQwazVuN1NvcG5FemN2T2xjRUFGd2h4cGQrTVZMVGpXQnllc0pE?=
 =?utf-8?B?SnpPVkZxNkl4N2VaSEJhRUR0VWxCZjBjYlZ1WDdtQ3hSNlE1ZEFoeGN0RlFW?=
 =?utf-8?B?VDRzR1dYZ1ZCM3psK0UxUXlFb29tbFdrT0xGMkVQTDJDbDdFdHEreitJQzBX?=
 =?utf-8?B?Vkwya3R6OXMxVUlSU0h2THJ0Yzh3VWxRdnIraVhXTHFxeHhzbzB0QmpFemlE?=
 =?utf-8?B?ZkdNOWlVQVR2bkNZZXZ1Y0c2K0NmZFJFOGZ1SUx2a0Zxc3JoNWdzaUgzaXFM?=
 =?utf-8?B?enc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e57c35b1-64cf-42b3-d991-08daddbac379
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 10:05:44.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58um9cGo8IXiwzqd1eERVeqLTN3NYWkBHX+WV0IBIB+rcSkPf+5qfAD9+4I471D9vbEzcOn8qNY1rnzZHVYbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7319
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_04,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140080
X-Proofpoint-ORIG-GUID: Zs1UH9qLXlnGV5VgU-LwZBhzO-paUZhD
X-Proofpoint-GUID: Zs1UH9qLXlnGV5VgU-LwZBhzO-paUZhD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/12/2022 07:06, Jason Yan wrote:
> Factor out sas_ata_add_dev() and put it in sas_ata.c since it is a sata
> related interface. Also follow the standard coding style to define an
> inline empty function when CONFIG_SCSI_SAS_ATA is not enabled.
> 
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>

Reviewed-by: John Garry <john.g.garry@oracle.com>

Note: you made the changes as I suggested, so I think that you could 
have picked up my RB tag from v2 series, thanks.
