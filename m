Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A712DC636CD
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Jan 2023 19:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjAaTKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Jan 2023 14:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjAaTKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2023 14:10:05 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0573A4B1B0;
        Tue, 31 Jan 2023 11:10:03 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30VIicEp014466;
        Tue, 31 Jan 2023 19:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CIk4cda4Oy6wAiEdqQtw9roVUzkN+d6RKNxJ/LpK9iM=;
 b=GjWK7iWniBfdUNC5tOfRj3geFF86S/2OHRyMIUVzJ1MFQbplBR/qHmvEWsc6nDBJtn/3
 2qnqQN6gf3E5aWmgujtXvihSgtUWJae5zT6Z+X6mHVUmrCK8dEP8syLelLU7QOOAt21F
 o+/rbqavBtTIOXXw9fwbsFuMuqUiHdh7SJ3eIkniApANgJcs2hU2rp+x4rpjmwAimuIq
 tVDGDatPWuHuc7UC55NG8L4TryKOEfPNFQbwErLlwsUubjqim51lNGsLb4AIj9K+xNxf
 PcTHGWkkB/nPUuZXmihdxhbRHEC8ETJFO79rmteRG2LfgQi8DkN+1q3lrgejfNQI1tWS Mg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvq9ph6q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 19:10:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30VI2YA1003546;
        Tue, 31 Jan 2023 19:10:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5df1ru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 19:10:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z168PzJYe/9TaHOXjWBOXPAjnaSYnmJOsdZwYoU7BrYiN19JAdqR/zOilWmZc60Cjjoijx9hr4m0aQtxA4v+dRBzFQlEdYprT7KwoxJBfhdCkUNla6OUV3mx2g5OCKo9uENd9alDIoeAOKriHR+73NYjDpJlvBn/bMJ2in59td+bBGbPpKPEhZ1ueUlmu/Tq3du55OeEG/om9xC2+p3m139PfMBOMThTTVLBUXjLwb3VZrAMtjecrfPvykktazxW9zcJM3dEVQAA9u3ZgxaF0nLEnMKq3cojuZN6SQbRp/Sab5C4F0fogoL7mNr+rvGd7Eg8YaalfFLu+Mkfz5p6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIk4cda4Oy6wAiEdqQtw9roVUzkN+d6RKNxJ/LpK9iM=;
 b=cg3fZhWtYClozYfyKnOy/hMggD4/9xp6akROgcIIGElTQ0buQQ2rww2EphRmpr4fmQtNki6l4B7cHRJHuuTGMNJ5Vn84tCUagVM0hc+GT4ksvez/oz8teKywG4NQs+f4gqfG7LvSal1oLkpLq+lXnQtbbRkqEa1f3gy1sEfdmQeNNcdzsU4AaHJGBKOISCWqpBTyYS7Ef6e6BfKqHTbDQXWDZ6Nf2NBzuXoIj13ZN9oqx3Ey+/NypB0PPjKZam22a8kFthMYL/0JiXE8GP12EqFoidnmm8DeE1pBSQVKUKS912wqls4UuttFTR3nFfZsB1jXV+9qBxrnltu3P9nAgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIk4cda4Oy6wAiEdqQtw9roVUzkN+d6RKNxJ/LpK9iM=;
 b=HNIEIPmUv+p2mMjYPf30uFfUhUwfNIyy0XkNNciznAeqeLOTye51PvFTuR39bE8ZiBVy60+IAhTeMXk0rUhb5zu/YFVAT1iNDvm4F/c5/zGV3GNmi4S/iFJFLBZAvz2fgB72PeD9ZFscZSEhuVA5x8seYGxgFcF1httWcx32WlU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS0PR10MB6871.namprd10.prod.outlook.com (2603:10b6:8:134::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.22; Tue, 31 Jan 2023 19:09:59 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 19:09:59 +0000
Message-ID: <4c3e72fb-a61e-2cf4-31fd-51ccb8104792@oracle.com>
Date:   Tue, 31 Jan 2023 13:09:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RESEND] target: add virtual remote target
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20221202122319.28508-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221202122319.28508-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:610:5a::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DS0PR10MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 8777e954-a66e-49ec-0537-08db03bebf05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+JE54O6YXMkBtEiEo/+tv21KTCVJJ3kHV64VBKLAzDoUvmAiX4Pnd8fd9UmD5quTWeOeafvtquLpUG+sV+R61LnghLQsFKkv1LdXzy1+hPJ0v8d3mh14+bGpYDETfXxv22AgbkPvgH813nciKVBZrFGXAfVGfHDmOlEoCzpXNkArgYR+2lbJo7qJLoxN2kYYzOxZP4U/REdr4SFwdI2uki4GiXPKWr+lMI6iVfdX5V01c2aFe0S/54ZpegrbA5GclDO9egEWTsczXtD2hc4+ju8Ns4onShiYQ3oF4vGyfX1qEAIumulkSZSfywxaAvYNa0oglZK8zAsRp5wv8hrhTLXDdpKZT32iJ2HO0CeX9LZApyirfkrCjLjw+6NNCxZQMMv2AoSX0qjWnqBgxvvmtfF7PHI6trVjubqFXNt2J4+tirXOaxA/H41N1fwvX8c3ANEUB9Lj+52iL7UBce4Cu0UimZGCQQKmj+VxJCQ2dwDMLiFXnnZdO/tIpUDpeSWIC+m2MJm5UwQtjbUUAAqyfjzsTsiJRk7zqHxJC/wmWmOotO2/IqwarqjmwwLC1LkQCuHJ9nfHkAlV+3EjwGDRtm7CjQLi2hrQ5DneRc0dRhO0IMQCKQ1hDfJXz1ciCVGHtH1DOna0Af60Kw7Uf2E1OEEottF+BrGfuohriy36nkJH7CX+KIBVujWUozcLh4J82Tfc01Hj7m1yoOiQ4qJ9co5sBfYwHSmmVo1O2VqQoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(376002)(396003)(346002)(136003)(366004)(451199018)(31686004)(36756003)(86362001)(31696002)(38100700002)(26005)(186003)(2616005)(6512007)(6486002)(478600001)(6506007)(4744005)(316002)(53546011)(110136005)(5660300002)(66946007)(66476007)(66556008)(8936002)(41300700001)(8676002)(4326008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHZKSVZoWitFdlF0K0ZIVkxtQWF6SFRFd1lneGVXSjZoNkhmMFIxNUdvbWVX?=
 =?utf-8?B?T1FSOWNpd2xoNTRGam5jdE5GT0pmVzJtbFlHcGZ6bDY3b0ZneWlzSllJTjZT?=
 =?utf-8?B?RFRKSWdFYityRmkyVThDTEJtS0xZYlI0b0EwQU5mS2N2MFNFZC9ZcEcwblZN?=
 =?utf-8?B?Ylcyemd5WFBqWWl5MXZyZVFXWGw0R3JiVmN3bWhHTDBkd3I0YmdGR1BuR0g4?=
 =?utf-8?B?YW8rekRERGs0cFg0cmZkcGVxYzZ1UG5lNCt2c0lIeE5WYmVGT1Y4TkpONHE4?=
 =?utf-8?B?MDV0Tkt5dlg4ZkJpOE93cE44NjRvR01pZCtGQkpKSWtWWTNyejZPZnRsV1A0?=
 =?utf-8?B?UGlkd2lNbWxaeXVwbjhxVitwV1kzaWsxTmlRODYzZElKTWJvdU5yaW1GaGUy?=
 =?utf-8?B?SDRWYkNQL2RPRkJyZzNoRGVIdHZjNWVCNHVqZndPc1VDbHExSjMwVjZiSThi?=
 =?utf-8?B?S21kcDlCdkpGNkVvcnFzUTM5eVh1dngxaVRtZmhmTUZXak1EQnQwN3MrME5v?=
 =?utf-8?B?VXdpTkljUFk4eWJXTGU5UEQ1TGhlN3ZQV3NnRnY0NVRrcnh5OUhUUnJuVDFW?=
 =?utf-8?B?RExBYnc0bDhuVDE2a050eWxJT0VqTWk0QVlQS0VVU0FpaDh6UUVoVGNLcnIy?=
 =?utf-8?B?a1JsWmlXN0EyQnVxemR6THdQZVVYVnB6U2tqYVlKby8xS2FvaUwxRURLQU5X?=
 =?utf-8?B?M05SZU15ekRaaGR3aG5XbzhZNlppUS81L0FiNHZIbUlCckR2NE41Z0xqWWoz?=
 =?utf-8?B?blJLK0dyU0lxeldnN1c2cnNQSktacXRWMXVrUThLZ2JpUllnUkxUZDFrTWhl?=
 =?utf-8?B?TC85MmcwTHduTmdQSHFOSzZ5UG5sMHNXYlRCTmxOUUxrRmRrZDgzRWlYZndj?=
 =?utf-8?B?djlOWEUxKzJhRDgxM3BlSEFGemRaOFd3cEduMW1KN25ET3BaYXVFRzRTNjEw?=
 =?utf-8?B?dVJOdWlpVnVDRDhkY2FEWno1ZVdrRkROTXRMQy9obEw3aDN4Ykd6YllUZGxH?=
 =?utf-8?B?MVhlRXFzZHRuT2ZRNlhDdTNCRkFMMlduQkltUFdudWloa0wwUC96Y1VabS8z?=
 =?utf-8?B?Vk9uZzI0VFdlY3FsQTZ0OEZBRzVRbk9QVFpubmVjVS85QUd1REY5T0dWbzFP?=
 =?utf-8?B?Szg4NmpVbjEvc2VnSGxpRmZRQnRIZWtJRExyRG1Ubi9rbStkNmRlUHdZc2tL?=
 =?utf-8?B?V1AyeFJXVTdzOWd5WmdrYXllaXRlOGRqWjQ4THRIdEczaDVxT3MwMmlNYUVp?=
 =?utf-8?B?c2FtRUZ2dFVISDRORytvWFZ6a1NxWUtZUWZ6b2xzbHllcFlLa0lWTXBEd0Zp?=
 =?utf-8?B?R3NkRGVObXhCL1cyV3BXdHJUbzN2bUx2TnBka3IwZVp3TEdPUEJPd1BJK0pw?=
 =?utf-8?B?RmQwbEdwUXlLUXhEM1h1RldneG0xZElOVmZEYUprcmUzS1VvbnljM0dXcHIy?=
 =?utf-8?B?K21aUEdrQ2x2ZlNBczcwTUoxMDBMRWNFcUpZd0xFK1F0dUtMS0VZTkhBa3J0?=
 =?utf-8?B?YkdJTmpSNGFWNTFPV3lIZTNXdXhwNTYyM0dXL09jS1E2NHVZTEljTlBZbm5Z?=
 =?utf-8?B?SEJhSmFxZEJiSXZyNDFvWkk2K085dFJaVTFQOWoxOWZBS2F2NWdGd0N2cFRm?=
 =?utf-8?B?dzlUTXFneTBuM2M3eU02MmhpbVY5WUk3NDlKNVl1YUJpNmErYWZrbUlEaE1D?=
 =?utf-8?B?emxGMS9QWklKSThIRExqUllLSC9ISFVaeVBIS0tjUExyd3lvcFhiWDNUYlkr?=
 =?utf-8?B?YjZFMHJPeEdxUzBFM2VkNWZhVjZqTTVYMVJLdXo4cWFwcWVKd3NRUW1GSXdr?=
 =?utf-8?B?aXczR3JqNEREc25UMFRxV0pkQlIxbkpzdEppQ1laRk1mWGpQN2M3UmhNbHJH?=
 =?utf-8?B?MVpxbkloWmJycUE0Tm9XS05KZ3dqSjluampVaXJ1VUU4M05GYU41OFA2eXpw?=
 =?utf-8?B?YzFiK0U0QlRvNlNXakVaeW5YaW11YksvSmxSRFRBbFFkSEx6TXZoY3h1MXp1?=
 =?utf-8?B?V3R3Z0RrYjIyUER4SjM2bjZXZXVkU2E1OUtsMjNlRFNINVZFQzZ1Y1FaSmdp?=
 =?utf-8?B?ZFR5WWUwZUd3eWd2TVVmSU9MajYwTFZnUHF5Q2Voc01uNGNRR0JRNTl6aXZx?=
 =?utf-8?B?djRMTGRvYXVYQnVZTlg1RHNvYUdEYjEwcGErUEdGcmdtUXJwalAyMnNIRFVI?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lXMv1JNQwQFZYIUYDAldpSkmTm/RAheRbjKPpTT0H0Qq+W3/EDXKjpGWbAlA7IFK4JyZSNNTpdSstTBNOV18vD+bCOcu3YDXYZiSlKXgBs4HAiYM+6RSMddbl1XCo2PSwAXXopSltKOW5Z5msxaUfMeRunshA1lZsmDuTo3VGRKR4xqbkOD8kBGFNspRLK7gYqY7oM2NSuXu2Tco0kW0PneQqZU1UyMMR0B/yWQHWsolPYD6gLOUJb8GGde9gkC1iYIMWo2YeyFPKMVsYt4Htp31A9fvTCJ900BxwH5SWrZZ//GtkgHoPU2KwEd1ayCPMts/cn8+AIVfC+U0gZ1cApXcGoilFdeIYknIeNfMXF6yDeRl8Xq6vA1/UpAwhxP3RA0w1V4tlOqX9umgvZPxguDV3cWT+uxjFu4oCN3DcheLJ52CSMlkCPiibck7rtmDomPBDznjviDv4jwnec+OhTNDbYhhdOJ9efKGVhEEn8X0hg/Yz1sWR0fMo0LKYQZUH1eAnFFPA2BCO5jes6AuY3CkjqFZo0SMvRro0wgIVAeq3C8dplVAfN00nfCDltGgBxkV6bvktDDRoZOQXE8jiXDDjsigKn9Vt3ogkmd2WTnlD7D6x6usKGQt8A93GO/bz1PLHDicNV9aVC3/wqUHP+lRvScVrSjcutIlIj4iRZ30MAfJxUMrGx32CUhcxu71Asxvb6Yr1BfA0ZQiU4P1c8QUk7Zka2q5GGcnrck7bm73chh7TvxMiQnxwtvZsGAcFQxsNWyfGRcERk7nfurtUnTziyMG/x3d2OgDJiYjodA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8777e954-a66e-49ec-0537-08db03bebf05
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 19:09:58.9316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n0Tkfj30BFSMzAbTMyIg9wwP8lg1DKn/1EBCP0F04AKegM0ACz/UE2MxGcwRkvdhErsmdpHJRUmiT/ZCggbqRq5RxEEh1ptBvWU/V/Wdy+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_08,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310166
X-Proofpoint-ORIG-GUID: YQoRx6sqUovf_V9ZUpaE4JTs-LecyqdT
X-Proofpoint-GUID: YQoRx6sqUovf_V9ZUpaE4JTs-LecyqdT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/22 06:23, Dmitry Bogdanov wrote:
> +
> +static void tcm_remote_port_unlink(
> +	struct se_portal_group *se_tpg,
> +	struct se_lun *lun)
> +{
> +	pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
> +		  lun->unpacked_lun);
> +}
> +
> +/* End items for tcm_remote_port_cit */
> +
> +/* Start items for tcm_remote_naa_cit */
> +
> +static struct se_portal_group *tcm_remote_make_tpg(struct se_wwn *wwn,
> +						     const char *name)
> +{

The patch seems ok.

My only comments are on coding style:

1. I know we have a mismatch in other lio code like above where sometimes we
don't put any args on the first line after the "(" in tcm_remote_port_unlink
and sometimes we do the above. Since this is new code, could you do the more
standard style?

2. Maybe for some of these callouts where most drivers are returning the same
hard coded value we shouldn't make them mandatory. target_fabric_tf_ops_check
should just set a default callout.
