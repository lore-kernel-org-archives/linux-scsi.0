Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7BCC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 09:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiLOJ0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 04:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiLOJ0d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 04:26:33 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5263C26F7
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 01:26:32 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF2NqWH022687;
        Thu, 15 Dec 2022 09:26:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=31AJxNr4MXqHqa9wbS+A8k1Q73beZg7aig0Jaw50c0Q=;
 b=xeod4pH4yWuAKBwJ30IjVPrBKi6TTXUGKRVyp3Mh0aNiNx/l2tE9LYNbusgLZ/43j94J
 e84eKm3y3Nry4cdct6oyir0l8l+HD+ClZJKyoMlzWE1VtQCja41iBBvH1+P/+ZGiZ7SK
 DQrDy+zP4dQ3zUQSGkFpCyxuiwuiX6Snw3jVQwH2LpFDm11E040jTTubx4YSpfywGfVr
 rExqx7Ao9RmgwgB4RetH9aD5oUgov21LuJsouP0n97RQXsWz4RfVsL6f1uYifW1HDFy9
 UP06XmVJqKh0SD/CXZe5bM3cA7b8cbjnKc9v+FlLxHT5ij1wHaEz3rqtO83Ort5oHl9d +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyex4j2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 09:26:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BF7jfaF003951;
        Thu, 15 Dec 2022 09:26:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3meyexd3fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 09:26:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgOVQDLQOp3f9nfUrkfTWCYGyNr9WHZTrkVUo3aNQIGWEgBFWBJjYK+XxG2328xeATW+pgx4s1a5qsEDoGG+bH2SNbpnMkvjmHFgpqaT4SzsOValq3ZWOLsCnBRaGhM83/WMbIP5YzyOvzrSn18KH5YMuT4SAHAPIlzctp6N+BAxWg8+IbCXU/xAa/s/2EkuKU/JMVKfte9mC17YElWQLHR+YoRPWUG8Vc6oersGgclVMVjuvDWFgGSqH2CG/uM4jQ8KN3irOoEGtP9HhSryNHY4NCElkH+bUGdJEtcU1adqkWDhm7vTDkmZmiPjIEBELIyaBz/ke0WseHV0QvtZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=31AJxNr4MXqHqa9wbS+A8k1Q73beZg7aig0Jaw50c0Q=;
 b=OS7cSGADo6hkm6CIWpa5ChwNyBaz0fsMgY2cb7N0H2X7Eb7wN1LEedFxtNf6911DwLBl1DfIjSiwSHsu8S9nzaR2pyRS7wcRe1EBPMvd/H2RvTUk+ITNnfdmRNCsjrEkmpt8KxOI6rdiUaWak+MBeFYrPMhkcR673R7QWv6jUzxmz3zHCG/JXn1FpcsxaVuKYJZuqULSmKPTpiio8X1q6yxh2r2oF6toKPEnH9GgB5jMT2dPb7GkBK8zpmJrElcXzQUXduwvWGeZ5XBc22WKL5TiNjHsc+u4b5ER2LjXNRUjqFuWLlyZ3pQmantxU12aq/9j57b6XQ+D2SBuFu2EOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=31AJxNr4MXqHqa9wbS+A8k1Q73beZg7aig0Jaw50c0Q=;
 b=0QyLld9cPGZUJiIZc8KSvRi0u5VvEMIPvBh14g+aR0kVbgZzQoLQZWR4UX4X5slks8I9E66MAt3/hMNHg0WHt2zQHpHvzUDCbWhMEnNOsAXZNmGDlIgQqMWRHGF9vYBBA5X9+2m+OxuyNzZQ3SzQUJVayFkivyaAI4iNwFXxcWE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6439.namprd10.prod.outlook.com (2603:10b6:303:218::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 09:26:10 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::1040:f0e3:c129:cff%6]) with mapi id 15.20.5924.012; Thu, 15 Dec 2022
 09:26:10 +0000
Message-ID: <defe3947-8c49-adcf-0f55-8cf3c889a3f6@oracle.com>
Date:   Thu, 15 Dec 2022 09:26:04 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] scsi: hisi_sas: fix tags freeing for the reserverd
 tags
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <20221215040925.147615-1-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221215040925.147615-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0006.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6439:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cea74ea-98bf-4700-4bc0-08dade7e6702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yDSSD6ED2wJ2JjOyeotgXFlcDRhoNpdjTTVLxh8vk5kmq4Qp3MWrOO/UOqj/lgEh8IRu4qRq1qmuCc7Rbze/0vzE6dRZnkUpXOEeR8QFtrVnSzvO6Oj04UtmzXWCHCtrmP2+QlE9VYAYco4oP6XG6DvwEKtR8JlIsnp0G217LagX1/hhXP1Xe1PBS1Uf6V606+WT+TtQMK4jIpHlCEzIGiLcAXMrOvxIwUNxfq2rvnDalXu6aJmjRePLYDT2yBq+gyaPJdtQ3BJKinBCu2C9ohx/AVVhfledidjYMFtC5YFSr02cfa3HQNrKSS6EhtCzwTw8/0/41vsUttUmyZqsR9V5CN6IN6YJKuuiZSejNx+9/6xgCX8BUNAGrDbZc9/NIEPSzMj1RKpfQJJ4cXrCgHYcDptRI+O91cpvPtxDtwkhwfl3TZG2Oy5kyAfouk2iOeuZIuTTLyYNH//Ki/seIMH37vX6HwOFTVw527G+P3oV4JMhL6yvskMkBkRdC1mL+rVviqArtEBxV8+rQS/+nC34TnIT031Tm/Vz7EdoS7c5KzCpEUZPwRPzNOSRJKrqaTqrGu8i/BboU5HylemYRgx3cug2i7jE1Npiu3tgzUAeSR7KeSPRN9KuGmRgz0a43fG3kQQZvZ/fw1212nzviDqte6dx04ZezMEjKJzxu8pGINrzl7/XpKA9SvvhVCykCZHmGwa7XSB3Q+YURpFqG//nAwurL+qg+4/UdisySxY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199015)(31686004)(2906002)(66946007)(66476007)(31696002)(2616005)(86362001)(36756003)(4326008)(38100700002)(5660300002)(8936002)(316002)(41300700001)(8676002)(66556008)(6486002)(53546011)(36916002)(6506007)(186003)(6666004)(478600001)(6512007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2pRL0s5eWo4NG5BQW5yVmtHWitqaDFmM2oySXBSdGpsVUUwZWdRMUJ5OERK?=
 =?utf-8?B?a0FURjdKWlVZN01yT25qNG5sanJPYTBScDZQVVA4ZTYxZzBjOGNkcXBjdE92?=
 =?utf-8?B?T1pkT2R2WDVHN055NkpNaVk0RTMxNDRDWk1BN2IrZHI4YjV3VjdaY3ZDa0lG?=
 =?utf-8?B?bTBNZzlFS1pTaCtQR2ZuaDBOc2VTTTNBdS9HQkFEUUZJNUVkbW5KMTMxRE4z?=
 =?utf-8?B?ZGloSlUrN0llWGVlc1BMeHdXSVE5SWN0L3hIU2x1dGxaYldOS1h3dENyNW5r?=
 =?utf-8?B?clJ2dkw2Y1FXeXRFUmtkbm9Wcit2WDkrTmlyMEJNWjUrMzhjYUhsY0xmeDUy?=
 =?utf-8?B?TWhhYjFHdkJ4MW9tanEveFoxUTAvLzJWNVFtVUMzT1ViNDloaGZqNTFDR1Fi?=
 =?utf-8?B?T25jc2U4cXFPTEJMVjVkK0lTNHVEZW9uTHlsZTZjSDRPTnB2YzdES09PYm5w?=
 =?utf-8?B?WnVkWG5IM1diM1pMSjNKdE5yOFI4YkF5ckhEMjJ5Y28yYmovSDJrYTZaUERT?=
 =?utf-8?B?UWlOQm8rQllhWmd6OXJhQzBuM2J0WlBuWGpiTEM5NXVXNTZtcG9INFViVXU0?=
 =?utf-8?B?MFlhWlBTRm8raE5wUERGa1N2clhHcTVleFhSUFF3UDlBNHp5UFFVVEpERlhv?=
 =?utf-8?B?dTgrNHFVMUYzVWZuM3NsSFJsb05qcnRQZDh2ZyttNDJCSHg0Y0RhLzRGRXFD?=
 =?utf-8?B?MGhKbmhwTHQ0a294RnlDTElxZENONG9aQmI2SnVsb3ZSQzVCMTNCK2Y4di8z?=
 =?utf-8?B?cUtFeENnb0tBUkF1ejFFODEvc2RJc1RSM1k3ZXB4M0s5ckU5RHBpclQ2am1p?=
 =?utf-8?B?WVBYaWR1OUxIMG9VeWRPTnFkUWoyZjM2UTR0a285SElmdlFkMStRd2ltYUhQ?=
 =?utf-8?B?cWZSSU1KMDBydHpvTlZJTkpTRTJOcFVHS3pkMTY0SDZwTE9ERGV4NjcvVE5x?=
 =?utf-8?B?NHFobFdsNVpaUXZnNU81WXUvUXhMVGdGT1BUNXNWeHVUY080b3g5dEdEMXZ4?=
 =?utf-8?B?UlBDeWw3akdlRzhhOUk5N0wrNkUwU3NUbk1IbTNMaElKS0xSKzVERzhTZGNw?=
 =?utf-8?B?aVNPNStFeUxtaGxTdG42Yk1MRThIajNvRE1aKytWL0RMU3RxZmR6NXZTUzBC?=
 =?utf-8?B?djM3OUQ2T3pCNnNiWWFaQWtlSG5qbk43SDJlZVZVTmpKSjlTTHgyZDZHOTZY?=
 =?utf-8?B?a1BtQzQwTTVGVXNiR1pvaW5mb09zbThCR1NjUDNIREFEU21JRGZ6TTR5emM1?=
 =?utf-8?B?Q2lBT2Jta1hzTzR3UVpyUHFRL2lqT2hjaHhkdGlCVDFSSmVvblRKRXA2K2dH?=
 =?utf-8?B?dE5WTTRWd1FQSjR5bmV4c2hOb3BrV29VMGp5YUFyODV5a3NqZjhqeXpaWFp4?=
 =?utf-8?B?bFB5QzcrWUpkWEFMVlNadXp5WG1HeXAzcTBVU3F1SjZhakp5VzNVc0EwUUtq?=
 =?utf-8?B?T1dDRGg2dmFtV0lOTTNQWmQyL1l0SUdXdlBUMXV1WEZZSUdjOVl4RDl4VVF1?=
 =?utf-8?B?Yi9XTVRyeDRUSUdsR3dmWDJOZE5kTGt6VWduUkw3c1FJNllFVEJtUGVnUzVZ?=
 =?utf-8?B?bXBkUW5SUk9SVDNaWlZRWnZhdlBhR3NVR1dzZFk4R2JBQnJkbXpvUVU1WldN?=
 =?utf-8?B?ODg3aXlrSUcvT21DaEc4TU1hVUcweENTZDBzdFZvekpvTlBmM0MzVHFKTUZy?=
 =?utf-8?B?d3JjV0ltWDlVQ3M0aXFtMzFFcjBPS2RoQzMrTVpDaFV1Uk01dWN6Z2FSTC9h?=
 =?utf-8?B?Z1Z6SVlmREhxcFcrbE9IWnZrb3RNd2J2WW15NmRqYTVpdXFKa0Q2dEtVYzdh?=
 =?utf-8?B?dzZrVzRsazlJTHRWeWtONyt0akt4QjVwNnlRWkdscXQ2SFJlbjc0dkJvL1d2?=
 =?utf-8?B?U1grR2ZrOVVaRXdiZktESDBLZzhRbnNhUC9CWGF4ZGJvaWF6TXdxaHlyNmxI?=
 =?utf-8?B?YzVzRERmaTlPR2hXM1lJSFFJM0wvQy9TV0pXUnlETEdVcGtpMGpjRE9rWFdm?=
 =?utf-8?B?MTVhQktGZjRlUDRkSnI5OEZ4NVliTDgwb1o2RkxUeUc2SjJUWmJNNm5sT1NN?=
 =?utf-8?B?RUNURHRMbmpFK3hRbTBOZTBzR1BkeVh3UHYzaEdtL2NCSkdPWkpwZ0o4THdj?=
 =?utf-8?Q?rn4MBRcyvYYBDx8jNxk01djhs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cea74ea-98bf-4700-4bc0-08dade7e6702
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 09:26:10.3982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9n8x6f7MT30d2prsxF1ceW1Ya7GeYle2UBPWB2vlQ9YBH4zuhoJyrUgCiZ17ZBt12sbqaBwi/W3JmJoPmf0XXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6439
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_03,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150074
X-Proofpoint-GUID: TtHcOG8X7ET3Z_WpCqvnFFCZ9cQ9K-9z
X-Proofpoint-ORIG-GUID: TtHcOG8X7ET3Z_WpCqvnFFCZ9cQ9K-9z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/12/2022 04:09, Jason Yan wrote:
> John put the reserverd tags in lower region of tagset in commit f7d190a94e35
> ("scsi: hisi_sas: Put reserved tags in lower region of tagset"). However
> he only change the allocate function and forgot to change the tags free
> function. This made my board failed to boot.
> 
> [   33.467345] hisi_sas_v3_hw 0000:b4:02.0: task exec: failed[-132]!
> [   33.473413] sas: Executing internal abort failed 5000000000000603 (-132)
> [   33.480088] hisi_sas_v3_hw 0000:b4:02.0: I_T nexus reset: internal abort (-132)
> [   33.657336] hisi_sas_v3_hw 0000:b4:02.0: task exec: failed[-132]!
> [   33.663403] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> [   35.787344] hisi_sas_v3_hw 0000:b4:04.0: task exec: failed[-132]!
> [   35.793411] sas: Executing internal abort failed 5000000000000703 (-132)
> [   35.800084] hisi_sas_v3_hw 0000:b4:04.0: I_T nexus reset: internal abort (-132)
> [   35.977335] hisi_sas_v3_hw 0000:b4:04.0: task exec: failed[-132]!
> [   35.983403] ata10.00: failed to IDENTIFY (I/O error, err_mask=0x40)
> [   35.989643] ata10.00: revalidation failed (errno=-5)
> 
> Fixes: f7d190a94e35 ("scsi: hisi_sas: Put reserved tags in lower region of tagset")
> Cc: John Garry<john.g.garry@oracle.com>
> Cc: Xiang Chen<chenxiang66@hisilicon.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>
> ---

Reviewed-by: John Garry <john.g.garry@oracle.com>
