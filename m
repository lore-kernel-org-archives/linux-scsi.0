Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C2DC54EE9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 17:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIVR27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 13:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiIVR26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 13:28:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2184C105D65
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 10:28:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MH4EpP008161;
        Thu, 22 Sep 2022 17:28:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jggu6CZcj4Y+zUmm7lckJEFDoxfWZV3wh2Cma7Zj+eU=;
 b=rR/l3/QNgeixa91yFk1DoPDuRUk3nHTyFYnMt6iGG/UDjVu+Vcw0ZwIafnMieJWIyXcG
 VP9H/hrwtDEQO9FeEBfS7lp6vdh853bA0NUcb9nVIpPCYg0gwFFgZaRVchwaGlGkG2MS
 5mZRVTfWIuasnzLrCClbrd+nEwva1h0KCEXtfbSP89mzT3HZSJKGZ6qn9HAbPFT8+HvE
 SUFRjEyQHLirS6iuA51VtwcY7ob5itWuG0qWD2gjQ+kh2SVoKsRbgW1gQSL8pgbXUm5V
 tAM8K22yRkbNHmbL/SaRDkf+BgbPLLJI+KRaT3lvSKsdyIlFh6WC65R8CFhixIWRG/OL sQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0nubb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:28:42 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28MGJAsV028880;
        Thu, 22 Sep 2022 17:28:40 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3d4uv36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 17:28:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLIL5VWN7tXth+49sew04ZlTg/dWxL6IzZHFXrSES1zN7zCftGbmMVBJIo2FuhqSnMFZg9tvB0StxeZ5xyQOKANk+3jfjQ+SUNf0kzTuBSfmi04GpNNg0m8qFgshB0sxMzfMRBi2+F1qNkRsNHKjEjrZZp2Y95dPNXYQ7GmE9niQkif9TCiUiiDtkrc5CJ0Rbe4WeF+GQPBvwIQhMG1A27ivgHUg/5RFL0mxbGmAAZqZ7IpgM66Sn0L2TDeiltULruBnGTOS4CjewCL24YS7kRKfh6iPt+IataLNXYSqxF4JWOAwFe09Cd6Q/5e16e5i3FklU6MB+mAXUR2BScI+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jggu6CZcj4Y+zUmm7lckJEFDoxfWZV3wh2Cma7Zj+eU=;
 b=SITHuu756lJTJOwvSu7J0r5ZUblMAdWZ2NEPCmVQldnBfgZTbBho6xqMfEpM6ZpiwKk+EHE6KQ9qgkDoM/fEjycG16B8aWK9Rvr3O+1GBh/WNkuf5OC8Lsp+oa7NddCwv3DSo4NiIp+NsUnHzEpSm0+A1Hxn6ajtZCJCgGhuTZYDx7vQZjUsriZX7I7nOr+zKbnP9mio5PfpcUPbS8/CbcSbsurxQVHKpqR+HHM5n9ihjykwuDm2zj4rao4ozXEfc1b8Dxs8eYEX+em62JIMTghUyr4QFY0x4Zj5Vey/skA6AV2ERgWQEdkt6Xo9s0qIT4XrOB1ZVjgW8kUAY1QFzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jggu6CZcj4Y+zUmm7lckJEFDoxfWZV3wh2Cma7Zj+eU=;
 b=k0Thjshs/y/n/fzajBo+DbN/g9Gft+oJNFLQqOcrEEQUpDuYA+c3Ij66oP5mc+36b3BOOdXXbFdiowIKQ4ZvbmCRVWkMGsIM6M5Kyjqlk1sfZVGIwNhezWZJcTDOu4mdCwyKqeC77oS1dOdc/AhDYbN9gMnuBaeFj9VN8EwS8q0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5692.namprd10.prod.outlook.com (2603:10b6:303:1a3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.19; Thu, 22 Sep 2022 17:28:38 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 17:28:38 +0000
Message-ID: <4a71ef55-e67c-fe45-aef7-081e269b0c2f@oracle.com>
Date:   Thu, 22 Sep 2022 12:28:36 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH RFC 02/22] scsi: Allow passthrough to override what errors
 to retry
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220922100704.753666-1-michael.christie@oracle.com>
 <20220922100704.753666-3-michael.christie@oracle.com>
 <aed47648-09fa-77bf-55d0-27fb7c477405@acm.org>
From:   michael.christie@oracle.com
In-Reply-To: <aed47648-09fa-77bf-55d0-27fb7c477405@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:610:33::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5692:EE_
X-MS-Office365-Filtering-Correlation-Id: b41397b7-1937-401b-bc6b-08da9cbfe2d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AN8UQx77twc4GlbohU4+7++4qrsCE7Ai3E6g9bSYgk4GFrJFb0FO/7AJ6eSpX9+qwnBnnTJDCQdfGe6MGxqowqIXFFV8N4PcmcdyeAyOZy8R/qsDw+CFHBvPN4e39i4IiBcmObOrXMLov97fF1+k1j0aKtzdM8JuCoYaRQWfpIITa21Zd11XHMcV20yRPuopFekIN7QVkP3RJf/8UkKlpwUc3UP3j5pzo/3GYI1riXFRRhFLrvSEoD+o0RBgc/eK6JlTJAY2fLupHbRot4eYR+meFacL65QceHUzpH+mqy4D5G2SIflyjb4hqErC2lvHH5PINkSCjo971LCnPWHD1+7uNb7NSLy2liCCpzX6+9KqWZ8GZngADKKbqvtsiF02ZL+X6fAO4SvEJLPvJHUGC0nJblIrAloXZRtgZySqqGlYJJn48VEaDlVdw1ogN3FlORQdG5CdT7aK1TrVEHML1xkmt/Irh6KnqChTB7zjKsvDa2wLdwAiHZtajU29Se3Zoy/RjjYFqaqAi9RnJYrlHtF5WpIAI1VFKekgLZhwflXKr3TUS7pwTdGl5aIdovafc+vMzesK74bPVDxlVa/Uav4nPoC8fz0aJ4hqCvWPdo4xE66CIX5tuIqhrGdBQRajUEnvaC838bJH51lTMQFz3mvTb45U4EHUKKbRN6HRsHQSazJE/IuxkNsXf53aCWe95qnpnBsRUaSVh9FLYf8x9+I8QcpNR5R42Gh6/Anl7QzBFvROHYI2PuiRI8h7lyldIHXrw7N75u4oO967775oQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199015)(4744005)(2616005)(2906002)(186003)(5660300002)(36756003)(31696002)(86362001)(38100700002)(83380400001)(31686004)(316002)(6486002)(478600001)(41300700001)(6512007)(9686003)(66946007)(8676002)(66476007)(66556008)(26005)(53546011)(8936002)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzNadXdTdGg5V1J0SDcxdnFHeVNWblVlWi9mQkZKRW9iU0dQSzUwUEwveHZF?=
 =?utf-8?B?dm1VU0VsSk9EMnlUdXJsL0NsSFRKdTZmd0dmUDJ4Sm5wOGlUSENITmtHRWUw?=
 =?utf-8?B?YmdYVFVEaW42M0ExREVKM3VULzkydDlqTFBFQ0pzLzhsTThzb3lVK0x6MFlr?=
 =?utf-8?B?YmF3Vmp0RngveU4xcUFWQzdJMzZqa2JwTFJFb3ZvOFNhL2NpZTN0bHppREhR?=
 =?utf-8?B?VEhCanlCaklvWUVmdXNtYVlyU01pbk1VM2pYVloyd3lXVHZ6dG5lZXRUdU9F?=
 =?utf-8?B?NUR1ZzhNTEpnWE1xK1MxQXNpNnZwQWgzaEtmSHNVUmRLUkUrSUtvRjRRWXhF?=
 =?utf-8?B?RFJNMStKbHRKYUVkTlF1OXQrUG1HQjhjcDdJOGwzZ0luWDEwcFc2ZGNoOVRV?=
 =?utf-8?B?RmxiUFJaWGlkbWVVa3hMUTFJb3A5dml0ZWtlRzUreTBHVWgyVURXOW5mYWE3?=
 =?utf-8?B?Mm1BMXBlSzB5NnI3VS9iUVFpY01oZk1ZUVhPdXlSbDM3V3pSWkNJM1pXazAv?=
 =?utf-8?B?M2plREYvSTJMbGFxdTdsNDcvQkNwMmdPQjRhNW9ITWhNak1BampyQ0pReDhY?=
 =?utf-8?B?c1EyWGgxd2lRTHFKK01oQm9PUzJyVzBMS1l5NDNoNmJZeEd2QitOY2pRaCs3?=
 =?utf-8?B?UDB3Uml0NkFrb05xaGM2c2l0Vm1PQU1kSEpzQ3VEbzQ5ZHNObmNPalYwOThi?=
 =?utf-8?B?UjdzR3RuWkNJVE5hZDVoK2h6YU9NL25ncGl1UTRJWDFpN0t0dGRaYXRickpx?=
 =?utf-8?B?WGFXWVZNbXVoSzZISCt1Rm9DN1hzalJ6MHVTaVNDVlBaM0YxT091SEUxUFdE?=
 =?utf-8?B?dWlaQS9sdFJFZnVCb1NUaFNKM1d5YnVSa2orZXFVamxwMjRxdUJiRnZEeXBJ?=
 =?utf-8?B?V1BSL25pelJYYTU1eFVUS1RMOTZveGVkUkh6Z0l4SmZFNlpoSER5Y0dYUURk?=
 =?utf-8?B?dmlVWXBIYTFmaTFRR2RSUUNJMlhrdUNTcHg3ZjZiejVNblR1UWZNVDY4ekVF?=
 =?utf-8?B?YjN4WUY2YnZ3ZS9DNjN5UW5PZHg4STkyNjF5bGFCWTFZeWJZblFJMFZxVXFI?=
 =?utf-8?B?S1pPVmo4L1J5STdQT3F5Y0JhbjJKOUg5S211d09rbnYrc3JyaGJ6WEdLYkRR?=
 =?utf-8?B?bVQxRGZSRTl0a3BGbkxkUjJTbVdrVnN1TDJRQ2xWa0ZLaE1QUDNSMlZWblRx?=
 =?utf-8?B?ZVNlTjFPTTM5aG9FZE4wZEs1c2ZZMEFEeUl4UlJ1VGJPdnRXWUZvRVBSOGdx?=
 =?utf-8?B?TC96OTZPL1Z6V1VCNmZid2h5Y0RkbVltU1NwTTM0aWtPczBXbWhyb3FSenBj?=
 =?utf-8?B?M2JpWHc4UkZrS2V1bGZ3djk2dlNxQUtqek9SZ1R0aVltdHRPQXpqK3FMOXRn?=
 =?utf-8?B?WlVHd2IwczAwanc1am51OGQ5MjlpZ2duckNqUUNvbXI3TXhFS1FKMUxkMVM5?=
 =?utf-8?B?OGVHZFhtWHZJUzlsYlA0T3dNeW5GbEZlWGM0SzdMa01kOFYvREJHYkM2VGRt?=
 =?utf-8?B?d0V3NWZ4aVkvM0JrVmdqZ09sUG50QTE5Q0NjRktLU05DRFcwUHhzWFdXVWpT?=
 =?utf-8?B?RVJYT0Jjc21mSmRIcWl0dExiMXFvcmV5MkRielo0aDJyM3IrRzVpWVhiY2pU?=
 =?utf-8?B?eTVEVUVDWmtYOHFZN0FZTE9WYzBYcWgrSGhIMTdpenpuRkJJK0t3bHNyVWlW?=
 =?utf-8?B?Mk16Qjh6T2tzOWZiQUdVbnR2TEhObWZtaFJVcXVnSmEzZTk1a25xTmZVSVYx?=
 =?utf-8?B?NDhobUFKcUtHYlNmeGhWN3VId0l3U3pMQ3BUaDVaZHdpWVpjR3NPNE1sWnJt?=
 =?utf-8?B?VVZicEV0T3ZsQlFFS2dtRWtxdFFEZk94cTh1a2JEeFZxbk5hbnZMTlMxQXZV?=
 =?utf-8?B?T0kxWEVTOU0xSzBDTGtVZmdGcG55M2wxeTRBOTdBNUsyRklwZU0zbk90emdY?=
 =?utf-8?B?TXNqR1E5ZkhGRjNMTXZ6SzFtMnIyVnBoQlFjSFFmVi9ZZFZuMk1kd1p2YUpL?=
 =?utf-8?B?TTVYVGVOUDhRSHlCRWhpOVR6ZzI5M2V1eE8vWFdjRzg4SksvVUthU1VHeFM2?=
 =?utf-8?B?YUNQZHVWaS9jUnhhWjQxQzdkQXZzL05ad3orT21mR1BNUjY1YkU5QndyRWF6?=
 =?utf-8?B?N0xEVjBrK0lLOG8wSVVvRm95RWd3Rm9ISDRyV3NQU0xydlAvMHRDWlpzZTBD?=
 =?utf-8?B?ZkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41397b7-1937-401b-bc6b-08da9cbfe2d0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 17:28:38.5613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNmxa3enr2GSsnaD0W3WcMQ+Lc0vFkmeqBie27CK1IjnIHsIf8x1WT/hoLdw1XegPlMGrxOuqD0/PsdySTOI+4xG36EIUIuZTgz0ooxc+Rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5692
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_12,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=994 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220116
X-Proofpoint-GUID: 6aCQu-ZZFTnDYaZxZrRyQYBcTMHop8lo
X-Proofpoint-ORIG-GUID: 6aCQu-ZZFTnDYaZxZrRyQYBcTMHop8lo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/22 11:59 AM, Bart Van Assche wrote:
> On 9/22/22 03:06, Mike Christie wrote:
>> +    while ((failure = &scmd->failures[i++])) {
> 
> Has this patch been verified with checkpatch? I don't think that the Linux kernel coding style allows assignments inside conditions.
> 

Yes. With --strict that part was fine.

--strict just didn't like me adding a new line further down the function, but
I thought it looked weird without the new line.
