Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B4CECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 18:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiH2SNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 14:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiH2SNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 14:13:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B466D8D3FA;
        Mon, 29 Aug 2022 11:13:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TGi0xr028160;
        Mon, 29 Aug 2022 18:13:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=E8Fe5jFaMlQ8b1p4pfzQkd22KHUI5ondNW5YUC2Xg2g=;
 b=JgrUmRhLmE2wZTPv1jNSnbHI/3FFCDtIzsaWYobEDJrsbNrysuMs0G2Z7scW94joWCAi
 7IoUGGlBpYgYhH7kZ+UwR/OrlrhG2jDUkvwsyudmVJB2no8Un7WoBTWYQ0mFI80LSTYA
 5FBGMH317h0hSga2gegL6hEhn3DnGUCwojp84j8Ayd2DzoYuwb2adpMMgzoM3MzeBQsn
 JuMwaw3cpxLwyZLivjn6kLKVt2MZiXh7y3gbji/45uRafjq+PD5WfAeksDYslI44B+Hh
 Pmjq3D9MR6LzvOR64BvwTm1jHTPaXKAEzTU791Fm3yq8QXZ58YKx/dJs+fY4//JTMWex SA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j79pbv4pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 18:13:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27TG60Ix033468;
        Mon, 29 Aug 2022 18:13:41 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q2rwae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 18:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fx1s4ZbcVMsnJi1lGt/spNYLTNkVaPPcwbFt8UBy+6EZUyykbz8cRKND+A2yzFJCvEeL66+x3rKFeaH9KC44fxo4Igl+YzaTWrP3Kpb5bPh6R38i0fLWDAj7Fq+NVG/MqCfBydoMrReecW/4EXwc/iMnKcFLiQIHITQa9j45JCCkmRY2EZWT5XnBtYVFKSP+GdI2zKwjdmn1nb+tlyCiXrd+9VYzGj62NJn0cTQdmLbpVwlwzDptsm/VJ+cjfA3zyQkfoE9AIyAoOGa5+Y3ok0kDMlAf1ZxK7uqZiaqSB3Z+ZqaJxEfPMBhsfbP5gkb95/jwtTtZY62oF/YHi0AVWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E8Fe5jFaMlQ8b1p4pfzQkd22KHUI5ondNW5YUC2Xg2g=;
 b=LLtUw4/zO+GuM3AuDlI3rh8u56FnzhZ9l80rcd9fsCJsMmUmOW7Q0waYUOAoNwo4KtisVX3Goy+jsnwjUqcEpRN3/AS1YllokxJCvJMqQzMn21YtgHU/S+JK9MS1kH2mEEScupIVePPwZ9Kf8toMDz/qFwKP3iwBPshEVSGf7mnMkASCkceM7tdlS0sqIcBjJeFtb2K9AcroGciUYgMSmquK+4mMZxFlBY+c0X3JXhz2vWKRt6PEVFsXFc7wHIplPXxGXrswQyZkRQ14mNWm5hytjPCrx3HMr7Dlyv0ygcnyzyFi85rkhrOb3wWz0eqM9gNtFCjbBPI3I4ZCjqs3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8Fe5jFaMlQ8b1p4pfzQkd22KHUI5ondNW5YUC2Xg2g=;
 b=KM5EPoKDVAGCzWIt0kln5+2nPn0o/SQES4ARATT1C9jOitJwfZoA6broJbnB8aswjDN3G4s9JJY/Bwu1zFHwksC7pNWIjONXtzmiA3LOldAJP9nzq4RZlkUdJEMqsaXAuPhVRL70niq/Y15xpINPu+4djytMD0SW23GALjRTlZ4=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW4PR10MB5726.namprd10.prod.outlook.com (2603:10b6:303:18c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Mon, 29 Aug 2022 18:13:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 18:13:38 +0000
Message-ID: <26c77569-9014-6baf-55d6-0dc1e470ed8f@oracle.com>
Date:   Mon, 29 Aug 2022 13:13:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 4/6] scsi: target: core: add emulate_rsoc attribute
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220718120117.4435-1-d.bogdanov@yadro.com>
 <20220718120117.4435-5-d.bogdanov@yadro.com>
 <479fd36d-7084-f37b-a2ab-f82105278cad@oracle.com>
 <20220812113441.GB32459@yadro.com>
 <7a21db22-5729-70d2-4f3b-f5f01a98cf77@oracle.com>
 <20220815063504.GA17595@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220815063504.GA17595@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0418.namprd03.prod.outlook.com
 (2603:10b6:610:11b::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 307052fd-b2ae-4348-3dca-08da89ea3232
X-MS-TrafficTypeDiagnostic: MW4PR10MB5726:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+fB+J5p3uCxkxSAp3ykMPS1X1zLc/3MkVXgxCz37bn4X23DpmDTms6d/J8BQR+U21ji5HLSNlQmVRWPZM2A72JEE/hotipByoEmIXGDTMNhqzLenHbMiPvBP1RZbF9NXcjtB41x+q1FIrIX72JKrqEFXoT1UErOh1aC3SXsN55kuApK46uHx9AY6Htao/AbG+ldMCWWuoX9F3wCa3ExHFQ67cYX/vLzGKl93mgypQClSjSM5GzbEBF96PgZ42KdVSLWf/swVn1Bm+jtHsE81VbgJnj+viNBBQxwAP+XApqlDPG9neXFN9CdRxGT8nGM/Zzu1rX4zDKLc8pMvbazBQQubIwcXRTvWFN1mYpTLrPI3vdRjmZ6j14LNpFSoJW7g6c+PeFYVkUEwbcmCddgI9B/Ez2bGFOyKYDqAxWeaCDmpaFeXnAibmKmSzJK1DpmtmgiSUOho7roxagFZH9sZyM3hUVkRyHxrSi0WLABtDDcXuWG6k4YiXY1Js5d7xosQh0aP5z9fakw276mg66AjRXGgGQKOTYgTgMYVA42wpGWKBZ9L2ZsY65Eqe2KRa/lxJ+KK/DNSAAPHY4humF4U5ECH8XicVk7NiTUUUVQUXEOG4ZGuRsEj4ziM3LlENcnnJ9b8V4ZfH7hqqXOc4rGWkqH/iogqrzCn31/GFX+9ujUTVPWKJG687+6ZrX4vDx3J4JMTKbPO8szz77MOS16XH6QzmOBmX299zoLVQ44Hc9+JtYCWLbCdyJbR1Xv4BpvptCvOkJzp0DRb0dIfpMCDOPDHnwfkex7vsYjX5G8YE4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(39860400002)(376002)(136003)(2616005)(316002)(2906002)(66476007)(8676002)(31686004)(4326008)(6506007)(66556008)(53546011)(6486002)(66946007)(54906003)(83380400001)(36756003)(6916009)(186003)(26005)(38100700002)(6512007)(5660300002)(86362001)(478600001)(31696002)(8936002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVg4d2NBdys0OFhrM1VJcENVUkNvQ09iNm0yZVIrYW0yaDFEZ1JBNS82SnF0?=
 =?utf-8?B?ZEd3dE5LL0RDU0ZURllKMlF6VU1qZFQ1WlkydXBBVXRXejdzbXFXajVvZ3k0?=
 =?utf-8?B?TkVYK3VxSDJSQ3NSREVIeGI4SXB6aFMrc1F0aXZDMVYxUDRCYTdjR2V1YXhy?=
 =?utf-8?B?TWxtbU1oRVFIbzBORlNyc3RvVnZBY202RmRPRWRsY0ZBdFhlVHNWcG1qakZs?=
 =?utf-8?B?OEt6eG9PQ01kNTV4aXNIUHVMdHhqWVFHTGx3Z0RqbHNCRnQvNy9kYW9pWFdS?=
 =?utf-8?B?RHBNeFNGYU41STZRcXI0SEUrS3RZbFlhN2ZPNVVGLzFsd083bjI5bDJCYkVJ?=
 =?utf-8?B?WDhpdy9BSUF3REo5aTkxaW5BWG0wdVBydEhIamU4UEhzSGZzSHBDZVFFc3B0?=
 =?utf-8?B?bDB6VE5YZDJFUmUvdEpHelhCUFZPUzlEQ1dWOFp3WjUrZDk3NHRIeEZTS1Nr?=
 =?utf-8?B?WG5NWnFWSjQ0YVllMmd2b3BsSkFSM2MxMUlRTFVGR3FmR1VTb1hnaFN1djZt?=
 =?utf-8?B?aTNkc1h2RWx1ODA5TDNKVUFqZndLQ01UMklZbllacU4ya0ZBL3FPKzhYeC9k?=
 =?utf-8?B?ekZnalovQ2JpTUs4dUE5RDdYWTNQWVdmZ3R0aUZPQk1LU0ZzeitlNG5adzYz?=
 =?utf-8?B?RGxFV085U0RxZFQ1VHhWc2l4aStoc2NJdmtOUTBzK24xV2toY0twaHRBMUw4?=
 =?utf-8?B?MGVYVm82ak9ZNytQVVozMllnVTR3ZFVxK2JVNTh2YzM1bzQ5aWoybkNvR0E0?=
 =?utf-8?B?eFN4ckpYYVRYTzJYcXE1cHB4dHhpMWd2bEN0Tk5VTlJaclhBN01uZFJTS0sy?=
 =?utf-8?B?V0UwcFVzalk2am9xMHY2Q1VnZUFSbzJ4bVBvS2V3WGNLNzRzdjlTdkJNeVp2?=
 =?utf-8?B?YVJVVU9kRkxvZzArSHdUYzF3eVgvUElYWjZlSzhYZkNaVkREYno3VHpxVEZl?=
 =?utf-8?B?UVFGNmJJRndzaFdMYzArVDVDMXA1NkVhVWJaNkh3MUlCVFk2c2ROOHlROU83?=
 =?utf-8?B?U05jVWZra1lWWUx3SjBaTC80YUZpM1Jtd3lhKzVXdGtQMzhHS2I0eVVyNFJY?=
 =?utf-8?B?Y3hkSm1rNisra3A3cE5venRGMG5ramJHOGUrdVJDejV1eW9lc1luWWVsQVY2?=
 =?utf-8?B?cEQzT0xKQjhFL25FZHpiYkJUa0s2QkVUK2VjWXhZNVAyNkNQZ3pKY2l2eHVB?=
 =?utf-8?B?MzV0Tnd0anFHOUdLcXhSLzd3RXlJV1JOVVNYYXRzbytsRnB1ZCsySmQzOXV2?=
 =?utf-8?B?N2ZmMm9pR0UzaG9FVWdtOSt5ZE91WUcva0ZlQTRkeGFtQzdZM3o1Y1FOdjla?=
 =?utf-8?B?R0hNTUJDRSs4aHUrcEhnVWRkNm1la2FZM1pjU0I2N3ZWRlJpRGRiNmR5Z3Vy?=
 =?utf-8?B?aklyU0RNUG1aQkZqSlRxTi9kUGNNdStTa0lkbSt4bDRLdUNvN1FsVnZla0JY?=
 =?utf-8?B?M3UvNHBERUJFa3IxL0wzZ3laTXVqdTZOWTdRSDljTzFCR1UwRjk0ckNHYkdy?=
 =?utf-8?B?MzM2ckZsbEdtN1Izcm1hNk5lUG1OQzdPQ24yMEFOdS9FWklSbnBDN1B3WHk5?=
 =?utf-8?B?ZHRHNTVBbWUxemtQaml1WVNvRkZFWmg0bDRxQjJCbVN1YzIzVFVCbzU4cDV5?=
 =?utf-8?B?cXc1U1kvNmIzWUJjQmFrUmtpbFRQQnRndS9VYmZxMHE1NDNUalczL1lBVG5r?=
 =?utf-8?B?YzFCYXFGRElvMW55SU1XT2ErTFRwVE5uSXJ1aFpJWnpoV3RsandFT2tRekJn?=
 =?utf-8?B?Y0xBZzdIT0xNN1QxWkJMWVFYdkMyayttS2ZxZDRIdVR2N0pENEpVMjZTTkhM?=
 =?utf-8?B?dXJ0YTR2VzNsaVd5cDBEUnhMUEY3TEozOW02eC84blhWVFFSS2FWbXlMbWt5?=
 =?utf-8?B?aFk2dkRnalNoaG9yNldTQzRWWHFQc1poMXZvTjV3em1LdTlyRXZHaHBUZjha?=
 =?utf-8?B?bEQrcDVJL1lNaDQ2VE1TcmV4RDlyQ0xXTENBcnJFN0k0T3lsMUpyUm5iTkpl?=
 =?utf-8?B?MGdmWVVkWGtHOXZ2OTlTUWFKRFB1SSsrcGhDQURmeVIxVytueTVhSFRtUFJE?=
 =?utf-8?B?Rk9tdGtmK09ZVjR6dDVmQllaeWRLQnZ3MFNXUkFrN1ZEK3BYNCtIR1pBMG9t?=
 =?utf-8?B?NzBXbkIvYmpjN2ZjUG10bEoxanVYdUlhSllGNzJmZjRPdTVtTWxhTVB4S3VW?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 307052fd-b2ae-4348-3dca-08da89ea3232
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 18:13:38.5571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmuQPp84XfNKB0VoWTQcFtSULl/r9VsJowiNVhMmNVHpOSJ0I5wIEB5WzA1IxNkV0vSy+iKDLXa/eNowrwOlKOtiKXHIHY7196EE5dIh070=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5726
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_09,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=946 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208290084
X-Proofpoint-ORIG-GUID: 3kABWUVnx8smO9w1Bj3_pga7EnNoKbk9
X-Proofpoint-GUID: 3kABWUVnx8smO9w1Bj3_pga7EnNoKbk9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/15/22 1:35 AM, Dmitry Bogdanov wrote:
> On Fri, Aug 12, 2022 at 01:12:12PM -0500, michael.christie@oracle.com wrote:
>>
>> On 8/12/22 6:34 AM, Dmitry Bogdanov wrote:
>>> On Thu, Aug 11, 2022 at 10:43:24PM -0500, Mike Christie wrote:
>>>>
>>>> On 7/18/22 7:01 AM, Dmitry Bogdanov wrote:
>>>>> Make support of RSOC turned off by emulate_rsoc attibute.
>>>>>
>>>>
>>>> What was the reason for this?
>>> Looks like, it was by analogue to other emulate_* attibutes. But
>>> actually RSOC itself is independent to a backstore device, so better to
>>> drop this patch :)
>>
>> I was actually ok with it in general. It seemed nice for testing.
>>
>> I was asking because I thought you hit some regressions when it was
>> on and just wanted you add that info to the git commit.
> No, there was no regression.
> So, better to keep this patch but to add to a commit message, that it
> is just for testing purposes?

Sorry for the late reply. I was on vacation.

Yeah, that seems fine. scsi-ml will take different code paths if
RSOC is supported. Other OSs might do the same so it might be useful.
