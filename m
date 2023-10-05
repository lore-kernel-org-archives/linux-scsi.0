Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0537BE9270B
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Oct 2023 14:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbjJEOnP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbjJEOhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 10:37:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043D34F6D4
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 07:02:50 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 395CBSXg028063;
        Thu, 5 Oct 2023 12:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=upY0ttRhJW16DYR3xm8Zge1rKPTUjKRO9hoireGE/MU=;
 b=PSSV5Ms1sfmmOy/807O+w0OX3uITAXPxm+YyjM7hdhMJKBe9aLl9omXkiMNSFUQ0Ynvr
 RYezWTsVIbWAu4sPgsrP85J+fQSQutnoSo8iur9OFkz+x0ZqddDeJjsNoKBE8fqyOfHj
 IKl8uFaUPBHS7x2KoXJP8T/oB9ASbbrGveD+1o/unm1PYgMkoMye8zN2VWqzb6iLWdT3
 bWtYPmDoRWEC83W/zCTvU3e6u+XGCKjFwudQOs9Ad8RduUQ9gpGL0PCLLCxUsVPnriYU
 X3u05+wzWekE95R4ZOGRG/BPwb+aa1M4/XE3rBTbaLts2aofn/ABCQxWUTxm1u8KoUPH tw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebjc1b00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:59:51 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395CroMY010167;
        Thu, 5 Oct 2023 12:59:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3thcx6vn47-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Oct 2023 12:59:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK3VOf9GAuGl3E8PU7/SsresiVbFAp05bD5JuEZv3saJRLF8lAku1veB0o+h+/ExJmBDooRdGWlB1vYXIYjPV6L9o6x12RPnWWTPcgAksgfZWEOssBdUl21Fq7FwzqKA6F7zZViWtQc30QYpm6+3DrUt5oU48KHFsZCUz/9VE73VYTEQohW7nrsebYKgIfyWurUevkHAIKtZqdYBj9kn4ceWP+DNN/RNvfcCyMttuHZ00iDRRBCHsXnuOn6mMHr+nAQAAlsJpMRMBI8dBpl8Whnv8N7CacF30g31/fwkGxjnZUEQoyNDL8JBKZw+izansFEDz4ZhiOSI/08wyBPT5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upY0ttRhJW16DYR3xm8Zge1rKPTUjKRO9hoireGE/MU=;
 b=gsukHX4h9cy5Z+YQf8bTEmn+CVxzHs2w+GVBLu41J1tLP9kUE3VVvTpye2dJqyas2Fj1RWMiOEGUvVnce5DjxQmKvwaRkfYSIrF+inJTK2gZvLiR9OcXFk0OriqZvbYtCIvfMLrdJ+hxLnNljJVAMoYNrXSEOfdG9ICpZ3mrAI7JMkN8FVQ1YoDFdOX/0/3NuixVxISKaD0A6eSB7pXMeezdFhati5V2QeZsc1t9ftDALN/DgIfPEEnqEbm2YEcWkxOIAQ+CKrFrlOYRLmlsrm9byZzd0OWodwFLOwQ2x63PsygUvdgKAOq1IxM1v3c2ztQywg6K69qK+3INCPp4JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upY0ttRhJW16DYR3xm8Zge1rKPTUjKRO9hoireGE/MU=;
 b=IRlukTwYgtPWBQwz/DBJ/QHwOLIDoTMN4VyxirlWUauQuGXge6XaXuAwCrABpQHmwweMF0jvVax5o9pPxdhrQIYG2F/iOgnNGHX5sXCmzGVlkcXnK6s87RC1UT+gGMKOVnw1vsKY+9pD7yCMmdNeLW7Z6WBI9mCj8bYLBZdOwl4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.33; Thu, 5 Oct
 2023 12:59:48 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6838.033; Thu, 5 Oct 2023
 12:59:48 +0000
Message-ID: <f8f4c253-1566-98f3-b8db-948ea8e803ad@oracle.com>
Date:   Thu, 5 Oct 2023 13:59:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4/7] scsi: Use scsi_device as argument to
 eh_device_reset_handler()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-5-hare@suse.de>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231002155915.109359-5-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4266:EE_
X-MS-Office365-Filtering-Correlation-Id: b8940e8b-1583-4bfe-40b0-08dbc5a2f475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gU1EzCtHElLkmW2sFArogRn1GzD4d2PFwillCqUQRcFYdX8adSa86es4mLkJpUigVMKOqxYqd1r0ZAvFe4BxQ81qehbOBi8LFFkZ6cqOCoExBY4ynERh1Yoj+wPyRZ89h4FIUXy116Xp5bxRAwkAEwBAzV8tNWcws7sLjWmLCQ4jYebGJrbaNo+ykJ/4DK8dafaqoryB46SgZLiaSNOQ9S7B9GEuKF42sBvAygPaCvz0587NTeRhnT6hwLZfhdaDhSnyImjMgnslGIFTxRC7SBVdGRqFgb70ha3/TKEP/X35Ri7MZX1yUxg+zOP0urRB2z/V7jXa93tJ8B+m8ccD977lZy4X36NLlz6wgbImGnaKpisCUF3/uakSGr2U5VuvvSzl2rsXNNH/pB1iioGkrKjaLsvaTus+ZjDKM867/ukFI32Hg+2Z82i9uxfuc/vgLYRhcn8XCCb5yGtO8VdbeD2IUSii292GzITkIoTs+AOKibPa+BTE98pqs1+PC0CUu67sSqiE7PhKJCda45s33E7Pw3QzeBbk0gUitjzIsefpVMuh0u9hwVnOFmyILo/Um1SmrijyVOJK8Y8qtdxZVJtbW109BXItX1dC/wdpQ3e4sLT6fM5QxZy6aqL7RzpRJ8E7Juxwq8JcI5//kGdtJw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(366004)(396003)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(31686004)(6486002)(53546011)(6512007)(6506007)(36916002)(2616005)(31696002)(86362001)(38100700002)(36756003)(6666004)(2906002)(4326008)(478600001)(83380400001)(26005)(8936002)(41300700001)(110136005)(5660300002)(6636002)(316002)(66946007)(54906003)(8676002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXFtbTlONjc3R0dkM1ZtVUw3c3pmZ2ZoMklrR1hnTmxuRjBheHBORW85Wjdp?=
 =?utf-8?B?UU1rL2JQNkhCckFrVUlOM0xSaHhsUWY4L2RsRitUd3JkMTQ1M2NpS3V3MVVQ?=
 =?utf-8?B?Qy9qbDZrY3g2TVViV0UvYzdCTXMrZWxWUURGbkZsRGJwS090MWNqNnVUdU1P?=
 =?utf-8?B?ZVVSbWFycUhXbmd1UysrdGMvdzNBTGFUM04xNElWTCtXTWljc0ZxejFMYXZa?=
 =?utf-8?B?SjExc3RNWjhveW5FZVhDWlJ4YkM1UU52dHZDTEttS3YwQUdWZlIyM2huRFhF?=
 =?utf-8?B?U29WSzR5MkJ4VU1TRDZOaFAwZGtUbEtya1NvTDJQWURnVG43RnVMOUd2L0xv?=
 =?utf-8?B?Smo3Tkp1UTVMWUpKdHhGMXAzYUZlMk5PTjc2eWo0T3V3N0RJb3hWdEczeE5U?=
 =?utf-8?B?NmZtVHQ1WVQyQ1BlMkQ5L092alJvNzZrZDF1SjliSzgySndPM2k2OEZOK1lD?=
 =?utf-8?B?Y3FHS3J3dGFWdHVOcC9KTms2OG84cGZkYVREbTlzaWFZcVkzY3h0MFhyNi9S?=
 =?utf-8?B?WjVWRWJRZUN4M05YU3NHS1c0WWJMcGhINkYvallyZDVlbFBkL0Fad0dDcWk5?=
 =?utf-8?B?VXpDTDJvOFNTOEpCQzh3SDdNdWVuWEEvVHk4U3pISmFnanlVYU9NQTR1Y3Jh?=
 =?utf-8?B?WjNFdHY4R3JncnorS01FSE9ULy9EbmhOckpHMDhaRytDSW9TTitjTUw0U2xk?=
 =?utf-8?B?eXd5NkU1SXFVejBzbENtT1ROUjFMcGs1allwd3pXQTNyTlJHcnM2aHM3M0Rz?=
 =?utf-8?B?Sk45V0tqNldBY0RUZ2U4b0lvWEFHTG9GWlRjRFJsQ2FWeDJMeE4ydFpyNU42?=
 =?utf-8?B?dERpem9OSXJTNTJvbkxGRCtnVkc4aXlUVGtkZGNXeTBJZEpKVjQ0UVJVMzZi?=
 =?utf-8?B?VnFRMWYvNm5TKzRyeEF6NTljcVJZb1ZIRWM0NnA5Q1RRbTRlcEdIQlBTYXZw?=
 =?utf-8?B?U0ZsakZmSkwzZmZZSkpTZy9hY2dRMjYxTnQ1MmJGTlVYWUlhcFk3U0ZRYXBS?=
 =?utf-8?B?WjYzeWltWnA4ZmZsdklUR2d4aHFoYmY2UEQyNHBwYmJWekhpVFFLZnE2L215?=
 =?utf-8?B?TXN4SCtORHRwRHcyUFYwbGtYVm9Od0F3Tjg3T050dGZNTVNKNlorYURBcncr?=
 =?utf-8?B?Z0VWZlJVVXQweFlhOGFpcFJQcll1T0lscitreU40cHR0a2UveVMwTFNxL0tF?=
 =?utf-8?B?bWVXVHZIMGpnVHVaRkZhTC81STNQdmEwdVFpTzV5QjZSNFZPKzQ5azltTldL?=
 =?utf-8?B?YW9MR2tDZEg1WUs0akJ6NUt1YUp0NDlFaU1UZmhRREE1OE45dDlQaUtOaWdB?=
 =?utf-8?B?QTRuMThqUjZTM0xDdmdHanVCZWZWQXQvMW53enIvamY3RFdRQnRJdWNYUzdi?=
 =?utf-8?B?dFk2eUdlOGhDNnFRcW1FL2c0MXRFRzJ6akFQVEV4eVBCNlVDYmcwbkZXMnBn?=
 =?utf-8?B?NzFONDVUWU04S1U3UFUzSEIxMzJFb0pEc01BV1VSN3gzV1BEZitkeEpBQlpz?=
 =?utf-8?B?eUVrMHQrcUJiOVFPckN4d1BKZnd6ZEF1U0V3Ry9kTU12WTVUaGNleGtkMjdP?=
 =?utf-8?B?TytvN1ZPOExsSVFrMlBSRkRKTEpFL1VQV3ZvWUsvOEcrVWhjQ1E3WHFOSm00?=
 =?utf-8?B?UXVyY01JMXpvUG0xVmV3cjd5R0FEOFFPMDlOOE1SSUh4UlRkRndLdEIwVUp1?=
 =?utf-8?B?eDJiYkFVdENqOFZDMGQ3Ymp2OUJPSWtIMDVwbkdaeHhJZklEd0FUNTFxb2ha?=
 =?utf-8?B?NUpEOFhlcFpCb3BtZDFQc0Rkbm9XM2dwUUtRc2hQUk9zMmE4UjhJSEt1b1FW?=
 =?utf-8?B?emJyMmFvODZoOG1EQ2I3VGZvYjFGUnREODdOSFBCWklpS0hsSkg5QzFySUZs?=
 =?utf-8?B?VVVjRmN2S0NHMm9WNDlQSGtsSURZa001RUtqRGI3UjRkeEt6eXZvSTcvaWh2?=
 =?utf-8?B?Ri9zZHplZ3luNEtEOXZvNTNtZFpnVnFjQ3loRnQ4Sk9XUmp1YzJaQlBndWpV?=
 =?utf-8?B?MGlmakxHMWI4Z0h5cndxakhTWFFzQkovRjNjY3kya1QxV245aXQwZ01MUFhN?=
 =?utf-8?B?c0xrZUJLSkZtNWFaeVA2M0d2ODZaaDdQdTBkQmlnbjNGb0ltYXd6UE4yeEhQ?=
 =?utf-8?Q?OYyCFMulLma826MoFs3E3NSCL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0mvrc7coBKFsHrlO3h7/RrLl0MC0frNqJNsae1a9p9L+fxBbolnIVgAADCS2A2kLcGOh4QUodGzqWug/UP1I4O5nQDuTJn2rAFhXOwSSm0AbHWch5PzN6pzTlv07LttL+72r1KNmO+RuZnIorgrqgT8KV+kCifu5nrCn5GDRuvw00iDN8I3xRAtEdvLaPOdGlzizc0gJ191EGfv8XvPyFpT/6JH/5BdoRANX+wa/npZLn6tZcg942GJsGpDR4ozoBLB0Uq3kYX8PytYRTL95TIX6L9BRapcZ5Jp8wlin2sPoKcR904f7li9Xa6tLYDeLcG6b1ew6X6cp3NExiAiUulwJ6yMYRK+vqWzNN+u/Pv0ZNpCZTT7WvXffht4Muz6/Z2Ilu8sqIBhyM1ZWh613U/5UjbX7G3B8lETSvnX/aeDTOo05dk0dB+n7NC8nKQ2mWylqaZBT+Dzs5irXKFqX3YZrrjqlsHTRgxoSdX3wwJ5ZverHX0zps4kxXvPd49XUmwPXLeCz4hfM/LAPeFd0gagLPlSmH10E3zaW5R7BA38N/JKtPdJzJHQUmQCdWbCVaTiWhTJdMOooWSC1ShmCOLk8N1brk3chnJ2LMg5xkiWhv9v1Zjtfj+5un2/VU0F9atFldKaoVPSmHIZDQ4f8mjDXpK/GHTGSzu5hANYQZv9l9FcrC4sFI5WhIWqHZYgs1zJiC2vZy9WRqcJgFiYzO8HYZevg+iTR/yTrqUN+RMga8BjZNQffOgO9ipbIH59cdlDqy4TU1t+ycaqgpfBBjgQuAXurRVfcmOGKKJWovk3RdPpsYYF6Le4sF2IpvwD2ETH2tFjSDFYwhntoENZRMXoFEHWZe76tvZRkI9aXqMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8940e8b-1583-4bfe-40b0-08dbc5a2f475
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2023 12:59:48.1918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K89lthIUk/oarHIO4FrkgLa3qxyyRxBi1VJ2HiF4AfRyaK3jXKm3g23cDvTaZ+OE2y5aE1ibKp9kZW6Hosktkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_08,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310050101
X-Proofpoint-GUID: GEQbGYNBUZrFJxrwKQsJwSFwxuiWsn98
X-Proofpoint-ORIG-GUID: GEQbGYNBUZrFJxrwKQsJwSFwxuiWsn98
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/10/2023 16:59, Hannes Reinecke wrote:
> mptscsih_dev_reset(struct scsi_device * device)
>   {
>   	MPT_SCSI_HOST	*hd;
>   	int		 retval;
> @@ -1810,18 +1810,15 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
>   
>   	/* If we can't locate our host adapter structure, return FAILED status.
>   	 */
> -	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
> -		printk(KERN_ERR MYNAM ": lun reset: "
> -		   "Can't locate host! (sc=%p)\n", SCpnt);
> +	if ((hd = shost_priv(device->host)) == NULL){
> +		printk(KERN_ERR MYNAM ": lun reset: Can't locate host!\n");
>   		return FAILED;

again, I don't think that this is possible

> @@ -2887,20 +2887,20 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
>   
>   /**
>    * ibmvfc_eh_device_reset_handler - Reset a single LUN
> - * @cmd:	scsi command struct
> + * @sdev:	scsi devicestruct 

nit: device struct

>    *
..

> @@ -1676,12 +1676,12 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
>   	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
>   
>   	if (rsp_rc != 0) {
> -		sdev_printk(KERN_ERR, cmd->device,
> +		sdev_printk(KERN_ERR, sdev,
>   			    "failed to send reset event. rc=%d\n", rsp_rc);
>   		return FAILED;
>   	}
>   
> -	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%llx\n",
> +	sdev_printk(KERN_INFO, sdev, "resetting device. lun 0x%llx\n",
>   		    (((u64) lun) << 48));
>   

...
>    *
> - * Return: SUCCESS of successful termination of the scmd else
> + * Return: SUCCESS of successful lun reset else
>    *         FAILED

this can be united with the previous line
> @@ -4174,38 +4172,34 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
>   	stgt_priv_data = sdev_priv_data->tgt_priv_data;
>   	dev_handle = stgt_priv_data->dev_handle;
>   	if (stgt_priv_data->dev_removed) {
> -		struct scmd_priv *cmd_priv = scsi_cmd_priv(scmd);
> -		sdev_printk(KERN_INFO, scmd->device,
> +		sdev_printk(KERN_INFO, sdev,
>   		    "%s: device(handle = 0x%04x) is removed, device(LUN) reset is not issued\n",
>   		    mrioc->name, dev_handle);
> -		if (!cmd_priv->in_lld_scope || cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID)
> -			retval = SUCCESS;
> -		else
> -			retval = FAILED;
> +		retval = FAILED;
>   		goto out;
>   	}
> -	sdev_printk(KERN_INFO, scmd->device,
> +	sdev_printk(KERN_INFO, sdev,
>   	    "Device(lun) Reset is issued to handle(0x%04x)\n", dev_handle);
>   
>   	ret = mpi3mr_issue_tm(mrioc,
>   	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
>   	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
> -	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, scmd);
> +	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
>   
>   	if (ret)
>   		goto out;
>   
>   	if (sdev_priv_data->pend_count) {
> -		sdev_printk(KERN_INFO, scmd->device,
> +		sdev_printk(KERN_INFO, sdev,
>   		    "%s: device has %d pending commands, device(LUN) reset is failed\n",
>   		    mrioc->name, sdev_priv_data->pend_count);
>   		goto out;
>   	}
>   	retval = SUCCESS;
>   out:
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "%s: device(LUN) reset is %s for scmd(%p)\n", mrioc->name,
> -	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	sdev_printk(KERN_INFO, sdev,
> +	    "%s: device(LUN) reset is %s\n", mrioc->name,
> +	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));
>   
>   	return retval;
>   }
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index c6dd00b034f4..530a043e40d2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -3365,9 +3365,9 @@ scsih_abort(struct scsi_cmnd *scmd)
>    * Return: SUCCESS if command aborted else FAILED
>    */
>   static int
> -scsih_dev_reset(struct scsi_cmnd *scmd)
> +scsih_dev_reset(struct scsi_device *sdev)
>   {
> -	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
> +	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
>   	struct MPT3SAS_DEVICE *sas_device_priv_data;
>   	struct _sas_device *sas_device = NULL;
>   	struct _pcie_device *pcie_device = NULL;
> @@ -3376,20 +3376,17 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>   	u8	tr_timeout = 30;
>   	int r;
>   
> -	struct scsi_target *starget = scmd->device->sdev_target;
> +	struct scsi_target *starget = sdev->sdev_target;
>   	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
>   
> -	sdev_printk(KERN_INFO, scmd->device,
> -	    "attempting device reset! scmd(0x%p)\n", scmd);
> -	_scsih_tm_display_info(ioc, scmd);
> +	sdev_printk(KERN_INFO, sdev,
> +	    "attempting device reset!\n");
>   
> -	sas_device_priv_data = scmd->device->hostdata;
> +	sas_device_priv_data = sdev->hostdata;
>   	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
>   	    ioc->remove_host) {
> -		sdev_printk(KERN_INFO, scmd->device,
> -		    "device been deleted! scmd(0x%p)\n", scmd);
> -		scmd->result = DID_NO_CONNECT << 16;
> -		scsi_done(scmd);
> +		sdev_printk(KERN_INFO, sdev,
> +		    "device been deleted!\n");
>   		r = SUCCESS;
>   		goto out;
>   	}
> @@ -3406,7 +3403,6 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>   		handle = sas_device_priv_data->sas_target->handle;
>   
>   	if (!handle) {
> -		scmd->result = DID_RESET << 16;
>   		r = FAILED;
>   		goto out;
>   	}
> @@ -3420,16 +3416,16 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
>   	} else
>   		tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
>   
> -	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
> -		scmd->device->id, scmd->device->lun,
> +	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, sdev->channel,
> +		sdev->id, sdev->lun,
>   		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
>   		tr_timeout, tr_method);
>   	/* Check for busy commands after reset */
> -	if (r == SUCCESS && scsi_device_busy(scmd->device))
> +	if (r == SUCCESS && scsi_device_busy(sdev))
>   		r = FAILED;
>    out:
> -	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
> -	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
> +	sdev_printk(KERN_INFO, sdev, "device reset: %s\n",
> +	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
>   
>   	if (sas_device)
>   		sas_device_put(sas_device);
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index 8636f0053c02..c2b522a194fc 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -297,8 +297,6 @@ static        int        nsp_show_info  (struct seq_file *m,
>   static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
>   
>   /* Error handler */
> -/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
> -/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
>   static int nsp_eh_bus_reset    (struct Scsi_Host *host, int channel);
>   static int nsp_eh_host_reset   (struct Scsi_Host *host);
>   static int nsp_bus_reset       (nsp_hw_data *data);
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index d806576edb87..92ed0b86ad80 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3014,11 +3014,11 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
>    * Return value
>    *	SUCCESS or FAILED
>    */
> -static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
> +static int pmcraid_eh_device_reset_handler(struct scsi_device *sdev)
>   {
> -	scmd_printk(KERN_INFO, scmd,
> +	sdev_printk(KERN_INFO, sdev,
>   		    "resetting device due to an I/O command timeout.\n");
> -	return pmcraid_reset_device(scmd->device,
> +	return pmcraid_reset_device(sdev,
>   				    PMCRAID_INTERNAL_TIMEOUT,
>   				    RESET_DEVICE_LUN);
>   }
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index f6876307c304..bf169950834c 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -864,12 +864,12 @@ static int qedf_eh_target_reset(struct scsi_target *starget)
>   	return qedf_initiate_tmf(rport, 0, FCP_TMF_TGT_RESET);
>   }
>   
> -static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
> +static int qedf_eh_device_reset(struct scsi_device *sdev)
>   {
> -	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
> +	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
>   
>   	QEDF_ERR(NULL, "LUN RESET Issued...\n");
> -	return qedf_initiate_tmf(rport, sc_cmd->device->lun, FCP_TMF_LUN_RESET);
> +	return qedf_initiate_tmf(rport, sdev->lun, FCP_TMF_LUN_RESET);
>   }
>   
>   bool qedf_wait_for_upload(struct qedf_ctx *qedf)
> diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> index 1df3deb618e4..cb010aa271ce 100644
> --- a/drivers/scsi/qla1280.c
> +++ b/drivers/scsi/qla1280.c
> @@ -963,13 +963,24 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
>    *     Reset the specified SCSI device
>    **************************************************************************/
>   static int
> -qla1280_eh_device_reset(struct scsi_cmnd *cmd)
> +qla1280_eh_device_reset(struct scsi_device *sdev)
>   {
> -	int rc;
> +	struct Scsi_Host *shost = sdev->host;
> +	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
> +	int rc = FAILED;
>   
> -	spin_lock_irq(cmd->device->host->host_lock);
> -	rc = qla1280_error_action(cmd, DEVICE_RESET);
> -	spin_unlock_irq(cmd->device->host->host_lock);
> +	spin_lock_irq(shost->host_lock);
> +	if (qla1280_verbose)
> +		printk(KERN_INFO
> +		       "scsi(%ld:%d:%d:%llu): Queueing device reset "
> +		       "command.\n", ha->host_no, sdev->channel,
> +		       sdev->id, sdev->lun);
> +	if (qla1280_device_reset(ha, sdev->channel, sdev->id) == 0) {
> +		/* issued device reset, set wait conditions */
> +		rc = qla1280_wait_for_pending_commands(ha,
> +			sdev->channel, sdev->id);
> +	}

I am not sure why you are inlined what is done in qla1280_error_action().

> +	spin_unlock_irq(shost->host_lock);
>   
>   	return rc;
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 53bb73e07c3a..5c160f8ef013 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1445,9 +1445,8 @@ static char *reset_errors[] = {

