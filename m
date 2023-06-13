Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15C2EB64D7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 15:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbjFMP2j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 11:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbjFMP2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 11:28:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A7518C
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 08:28:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35DEZ5EO021514;
        Tue, 13 Jun 2023 15:28:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=n2KsbOoDJbe8ty5OA7jFV+TdGOecHF9WsytfhHPUXfI=;
 b=hCsfdQGaxJSjnfobaV2x/THODxpvFzr5oZYUwf+vUCp7mE9t/ZS08N2NF1DV3H9B016a
 e3Fa6yUrPQCeOOb4xPyy1Cwpz26rczl3eVpFr1zQEdX5wI6/X9pjmZ9KsbMjc5yTQEo/
 VHuhiFnGkxv4yEe+R/1MGUUlYPJGyQA2zwASrXmtaG90wWltGLM5Lh9DjxZH2LU5uHIt
 TJ1OJSWBz5RX1JCfJlNV7Rcw6Nyl4YF0L4DYiXB3U5FQPCejvKQCApqjUZEHSlkU2SpB
 SswNam1h72AUGmxsfdau09lWDIGCHbNlx8b9+WNw+PN2qSJboqUbsMZa2hyI0KCpcyvB aw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4gstwf3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jun 2023 15:28:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35DFJ4wS008307;
        Tue, 13 Jun 2023 15:28:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmakbrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jun 2023 15:28:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWYDrXFp1BjS3BGD9WObgbDfcd27qEaUaYQE0zn3J3wxXB/QQnut1o+HWcn0XNXtehckFuxrIj2CnCMTPyqQEnCrqUHcYv9gUeo5v4+6y9rDQdEckIiSghzTbS1nibA1KfgB4Eomyh2b6atMqWzQK24X9k5knU3ZawuV7JPtJZuVeAVbIvczhGKPKeWkfur8yjEm/T1KJen5enpuVC8pgqiCEVao5hnvzmB00Cv47o/k+MxqKNLShpm1jcsbAvm5oDU+pjgeC2gDK18O0nCu7eHYQ4lMJWy7iZM8vIDj2nIDOTIoSiVNmUI9E3Gjq+BWMZU17xW1E6QrGhSKv3cRlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2KsbOoDJbe8ty5OA7jFV+TdGOecHF9WsytfhHPUXfI=;
 b=JRQNw/0m3BsPQ06U/bhVQ1YiVJVOszuhd9J8UxRM+bb+MhHmP4WRl4M52Y9uvSMEgeG05BHo+OKBrcQZJfQCYe2V4DPVnXvwGZ8xLXNJetESkVSI5wkz/O1ACqbur9Br0ZtQSNgurJ37cwSx5oVLahIrJgxTVyFCA8mnD2Ms1uFFYmcGeSeEefrktnUhz20QbNr8Psjrs81pCZdNyBoSfoAhsBoMVbd5HsoebaQoKHMKo1lrn+xAV4pjN+FL4b4m6Cn0bT9ebtBwx6/yiJwZwpovITaFLDkdxtvIrk7ZYFzUhcxqmQFGsH565ohCNZi8HxRPcDN99Uop6HKcjldXUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2KsbOoDJbe8ty5OA7jFV+TdGOecHF9WsytfhHPUXfI=;
 b=Q4qeejVXpBFZ3jtDAr3NOu3mnXqMmclIFUJYUJOBvFR6wj8Hreg5XBJCM6+0Ick3Sy0v4zVh6Kh7g8Kv5NSYaSO66vRba/qTlunmQuETGx2o9G0BD/GV67hKNZGkjvRKh+XUxgP3Dvi6jCoMQveJebJuo+lAIaf7qtmidfF7Ypc=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by PH7PR10MB7105.namprd10.prod.outlook.com (2603:10b6:510:27f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 15:28:15 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::6f12:fcdf:da87:2bfe%6]) with mapi id 15.20.6455.037; Tue, 13 Jun 2023
 15:28:14 +0000
Message-ID: <d8859bd4-3ffb-45ea-9230-5838cdd774d7@oracle.com>
Date:   Tue, 13 Jun 2023 10:28:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] drivers: target: Fix error path in target_setup_session
Content-Language: en-US
To:     Bob Pearson <rpearsonhpe@gmail.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com
References: <20230613144259.12890-1-rpearsonhpe@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230613144259.12890-1-rpearsonhpe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:5:74::43) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|PH7PR10MB7105:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ead2868-b0b9-4862-1e16-08db6c22ce0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Awjd+lYizCx5dRs2kwoywIQoYL5ti+Nvj7j8AIuQExhHl2z2+pZlwnO4G5cjeoGGDCcugCyqFvtkFlyK1kmTGkRn0DIzddsWlBdPKY+WaEgasyumuQORYUTnsQQocYfIXyJDuZU3e6GzXNrQVozkOcZXW0OxyTHzTfRFvrqQt7MtQy4VvijqDuuwLwM0nCc/52kX7uJLIX/zSN6WEybc0ezWvdIPtgxsHIVDk9Qbu4g953Ck6TUppnRg4aM0FkQ/eWloF5iwEBscMfK2uq4nFaIsgt+wgPt/+vy+1AS9RwCmz1qOw/hDFbX+Q0yhwL6AYCIVKGuzc9FrRxcN0DZNGfdOxx8Zo3sI3bix1h6yUKUEEwkIgPIrPH1nSRW5GF79h06fN0UqClT3KEaS/f8HZxzuNFN52jkDHSVWhicBtWlrNiOU+YePIhGaLCg7ZZFjrwnFABugtITkt4g1W0daOSQovC+aguukOuY2ixFXOyRFN429AugrOmoH/VKAf821RKebqgSBiHgzPREDM9hx/BNnkgL8O5wukKKB/DQ9NRQb0TZh78cO/lIreyXNDNZISiLfuGm+sVmx2L759twlxWFLoxaAk5oggZeNnwaecUG/CIEmH5r+uHZvis7eLly3fbXT0YW+hVxEGeiUeybgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(36756003)(2906002)(31696002)(5660300002)(86362001)(31686004)(53546011)(6486002)(6512007)(26005)(6506007)(186003)(478600001)(2616005)(316002)(38100700002)(6636002)(66556008)(41300700001)(66476007)(66946007)(8676002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmRrN3l1cTkzdHljc3ZGdXZxanIwbjVDSHl0S25BNmFRdlJFV0FtQ2FkcWU1?=
 =?utf-8?B?ektNeG9rNWl2YTRkNCtobTg5STRIZ0JGWXd6S3A4UTZ1ZG1VMjFVdlB6U3BT?=
 =?utf-8?B?QXE0eUJWdEkzcjZLRGNENWVaZ0VDLzFQY2V3ZlA3M0hyYks3cGM1RndESzc1?=
 =?utf-8?B?NkRvblowWGJsaWFRcml0VUJVSEg0dWxFdHphQ3l1RzMwRjIvUWRVMzdDUW40?=
 =?utf-8?B?aUtTV3kwbkZydjk0ZlpvNGxyUWJsZHd5SEc4T3dWenFqTkFsNnpLQUswWG1X?=
 =?utf-8?B?ZklJTkJqMmJ3bGhVdTNIdTNnN1E3Mlgwd1J4R1hCWTUvUmF4RHV5VHdwSTdz?=
 =?utf-8?B?UHFKMXVwTlpWMFZhTDdzZHhxN2wrNmJkVE1HN2hHaU1MMkhTTDJpcmtScjlQ?=
 =?utf-8?B?N093c2Z1ckZvWW5XY3poM2YyV2ZOaTJsVUpERVRrY1JWdlhTbkxpMWc1bkJ3?=
 =?utf-8?B?QllaZlB5TVFrbjJKSXZUQjM4WElYS1M3d3ErcnZRZjFKQW9WWVZFVlBuWXBM?=
 =?utf-8?B?dUxDLzdjVEYzUW1tQ3N1ak9sT2luYzBQZUU5Mmd5LzJ5Z3BqdFpFQ2FDSnpa?=
 =?utf-8?B?NTVHZWdxckZiYVhqTHAzbTBHWldCMERzSzhvSDVFRzVmdDdnc2tBMk5SUXZo?=
 =?utf-8?B?M29ZdW1aaENPbThvR25Jc1NvMnU3RWJ0anJlTm9RUjYzTUpJNkpkVURLTXlN?=
 =?utf-8?B?bHMwaGFmc042OVdoZ1Jscnc3VGsrTDhra2xCUjJnM1RXNGZaSXdEak1MdmQ4?=
 =?utf-8?B?Z0RUaUU1bUZiSUJYZkpZR1JuQnpqOEVVL2tXRktSWDVCKzFJeUV2S0VGdTJO?=
 =?utf-8?B?M1Y3Q08vTDRLWUI0aEJlWE0rc1VORmxMdEh2QlFWS0dlRm5Ncm9md0dwbEpN?=
 =?utf-8?B?NFB3Ty90WUE3dDZKT1BOUHhTRVhITDExNUNBQ1ZWRkdzb0dJbFZFU2F0S2FF?=
 =?utf-8?B?dWorQXFuVTE4SCtaSjNSdUhHNUFBZHRCc0hpZVkrbTFiRG50dTlZQUhkbllt?=
 =?utf-8?B?QXUwNnFKUnFGb0lMTHF3Nm9lMFgwTjRvaTg3b2xUQy8xTGRINnlmSlRrUWxk?=
 =?utf-8?B?QTdUT2d3VDE5Qk9IZ0o3OG9LQmFmMnNRRWc3dHpwMGcyT1FyMEdmcHVVVTI0?=
 =?utf-8?B?ODBNZFRsRElTVFdKVjRyYjBnNjRmeHFVRDBCZkltV1FxZ1lvSjl6V2VYbkRV?=
 =?utf-8?B?V2NmMkJjZFJ2MFo0Y2xYRXQ0ZGlzQlREeklFS1hlQ29aVTltQjlJZHZ1UzNI?=
 =?utf-8?B?cEdrcW5oYlkyL0hkQnVURHVzZ2tqQkFIMVlCOGdPWTdKVTZXeEdvS1k1bVVO?=
 =?utf-8?B?Z0JCaEFsdElWSThkcCtuYWRjb1poQ1o3aUtIeGVwSHRsZndyY0FTRlN6QUsx?=
 =?utf-8?B?RkswUWxjckNxWWZZOG9GZWFoaUlXZkI2Y0JPYXNrTGwxYzMyQktsNFNpemdi?=
 =?utf-8?B?TzhCd3hRVUo5NE50a0lyOWNvczhZb1NoeGZqWGs4a3FkYWpEM3c0VkdlRFU1?=
 =?utf-8?B?ZTZxOGpiZFFDYy9OeUpNRk9COXJ0ZTE4Q0RUNWtqTDc0TTJMTnlreVd0R2k5?=
 =?utf-8?B?R3IyUkhNUGRqRnE1UzJtWUhJTEdPc0o5eUJuS3VCQVYwUm96MXIvRVFvR3J6?=
 =?utf-8?B?UjNyM2MxNytXZjdvRXhqU3RWSnNBS3JlbDJxOGhIWHF3RVR3WTNic3RIOFdq?=
 =?utf-8?B?QmRvdmUyUmpTVGxmeWV5ZDFZTGhacUJPVFhtVHFIcEJpZk5NUjd5blRCemcx?=
 =?utf-8?B?bW5TdUQ1RWkvVENmaVBmeTdXMEN0eWlQOWw2dDlRamlnaEVEU0QyQ0NrMVFP?=
 =?utf-8?B?SUdDM3kvemY2b1A3aGl2anNUT1hmU0VuaXU2aFUzZnp5UHFhZStYM0Q3NmJq?=
 =?utf-8?B?a0FIWlVvdG81VE1GL2xSQXI1U0kyd2VEVU5yTHg5SzdrTW84VkhSZUFkRitW?=
 =?utf-8?B?NWhpVEY1QWRscjFTczB5VzFxU0Fkc2M2Uy8weU1QWG1MMGtFYXBaWE90TU93?=
 =?utf-8?B?K2xmZ2pYUHA2M1FyeVE1WlprRGhHTG5GdnNRQ2Vyd293TnVUMDBndDNtZjYx?=
 =?utf-8?B?STFsdVRXT3Nqd256WGlsU3JiUHF5QktLQS9kTEtHclJkNVRtTi93OTNlYU43?=
 =?utf-8?B?NU1TZ1AyeFJ2NnA1endPWk8xK21idmJmWDQxRFg2bzRXN0VWa2I2YkU4Q0dx?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: J3LBMb7tUMhnIC9q2as+Z0mVdnT+J37XZrkEusTKD68AQzZXPi0GPsDGpvhJNZiTflYWgl6Dhkq6FLkkL2nfPMsEarjjyOC/U18egY7LFXAg2CvYVEs0jJRJ4Cov5n8g3agYyMSPvH48XVxShz/9IGr5C4uBQk6I6HskW2H92+URhxGMyw0C/SrKQaiSh0pxp6dL1e4Au+X1xwQvn8Wn9gTZsk8xXSgwm6+/apuWKQ2hCURD4ODgxiJrNRf2J9vRI9Qx+Ukf1UmmqiO7jesDZRrN0/2lBRRGL+39i/hZpTfbGorjN1FdeD0jnhrGPzR5aRs0aq74I5kzPHmeOvHEEwUosEbyfUvlDWp9EDOqvOA1P0TJgJXE74qJpSJIwlMBOGtxB4RVwojkYO7gFH6kkhKJMwXXEYg9wJ9ZGfWVQ6aBnliQLAzhpCGl21xtFJ5WHjU5/MegfxJwbdnqFv67Hx5fjWBe1vOFqxJ1xA/AJeF7At+OrE9MXHLzr6GlmGUgi7KcwuCegcQKpIcSz+nVrWlVxy8Nb8QzHKaebr5eQTCezdHqKUmFdMX9N9Jho/xXOw6X3yvehtSCbWXIBnsADJhJtBmzbmOmwU4U9yaIwcKc/EkOAQkpR+Hht414jgAAHiO7Tc2sy29zhbi2x/mQkcSyCPIPhz/jet9D9FepcFBSN4v9Gbpo4iV/Hl66/QNPAskq9LqqJ3HMgVKdQ5+ddCI0sGa9tIRE5rFxrFqbA74uiuFHBxIOv78nhzxtGmy272cQs+6WIFKG4YlA0GzwTo0hee2LuopC6VWD0qNQi14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ead2868-b0b9-4862-1e16-08db6c22ce0f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:28:14.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LY0i53diQADaAUqufqg2TQTHykQoRylETaITAr+lRKyu2ZWBT1EHR6y7YoyA9a8EAtbpSFJGlWEsog7EDTAztxrAl1gTN7bNGt6GuMzmEfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_18,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306130137
X-Proofpoint-GUID: dZ7NHjSnEdSzy1BzwXACLIrIG2pr4VJZ
X-Proofpoint-ORIG-GUID: dZ7NHjSnEdSzy1BzwXACLIrIG2pr4VJZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/23 9:43 AM, Bob Pearson wrote:
> In the error exits in target_setup_session, if a branch is taken
> to free_sess: transport_free_session may call to target_free_cmd_counter
> and then fall through to call target_free_cmd_counter a second time.
> This can, and does, sometimes cause seg faults since the data field
> in cmd_cnt->refcnt has been freed in the first call. This patch
> fixes this problem by simply returning after the call to
> transport_free_session. The second call is redundant for those
> cases.
> 
> Fixes: 4edba7e4a8f3 ("scsi: target: Move cmd counter allocation")
> Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
> ---
>  drivers/target/target_core_transport.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 86adff2a86ed..687adc9e086c 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -504,6 +504,8 @@ target_setup_session(struct se_portal_group *tpg,
>  
>  free_sess:
>  	transport_free_session(sess);
> +	return ERR_PTR(rc);
> +
>  free_cnt:
>  	target_free_cmd_counter(cmd_cnt);
>  	return ERR_PTR(rc);

Thanks. Reviewed-by: Mike Christie <michael.christie@oracle.com>
