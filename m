Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3E8ECAAD5
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 16:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiILQDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 12:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiILQDm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 12:03:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6403B326C7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 09:03:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CFDks2021413;
        Mon, 12 Sep 2022 16:01:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=R8DYEXmR+w7EqOKudDsORR1qeBHMmtIXfk0VaPRmA2w=;
 b=NP2tjXgDuGqEyUR0gJEMzRtuRBuWM8XjuNqG3u700JyzHcbTauA8Dpn5Fi4QXQs82r7Z
 3oZ3KBldBe+n3TUaYRq4PZ4+J3e0Z51MBpTQ0aPTUjQl7H7KCaakrAb3Gs7Cxc0QxHk+
 JtduGxaKmslsrVC0ZrPNVKefgF4GDqsyQuDLS1omX/WNMID/SqULSIJ1Z2qJYmTIw4cc
 v0RPN+Jih14vJBcPYpanenEj+Pi4z+4/ycfLc4XrMMNzfa9Cq79W8FY57/Ha+WU9rDxn
 UNBA9jU3389v4r5VzNRQccV+NmNJN+TsblpFCWxtcxE4ndHPWOkcZu7z9EGz96Y1O4nP Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jj5w28dbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 16:01:39 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CECT15017390;
        Mon, 12 Sep 2022 16:01:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jj6b1kx8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 16:01:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrH8+whveihZFVKVuxrcs0VgvSp1aVOzb03NujAKAm5fAz18R+Mx54RI8Bws8L5NCFWUyCaoGDaZQ4+h1gJmCDD0jteehhPG/9oYv/tiHTYdiG+clQCrsJowmpsjR92+8N0bOjmOccTHRjj/Df2qyhg4Yf2NdrRKtPT+chgb8PXZQ5xB7DbFa9PnbtTPzHosfbVNFvI591zp4jdU5tqCHobcBNqP5yRckDAegnz4g0qgQtQXLLEuUppsPPLv4TbEPxdLJkPZShXpS3MQ36W3QgrtTuHyZ+uCz0/uCr5bLiMl39PNY2tSaomvs+0G1VShycU1DxhutDPaAzeY+f6T2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8DYEXmR+w7EqOKudDsORR1qeBHMmtIXfk0VaPRmA2w=;
 b=f/f/9Pt5rl2agKtC7O3oqLXDWSGJaQbLAslOubmPv86DotMyZEU365+DN6TsT3lXIG6wxU/bLzXDKi4ymvt7qiaG/YfwGhcznG7BohoGHcxtSB3I+Df1+47adEFA77SEUZUVlOpXtWBylIFU/F9LfqjI/UwtzPB4VfUEyfpatIiutfXkESug2yQf2wqzFchh2plZq2bZumgAGmgeCxESy5oo75BQS6xLGRvvAP6YGbo5RDcQQdN4uxqGrDV1n+/iZcB+8fvMVyCuGehZnFVA3sboLnYrLWvH5+YDVGSH52vAcln5kZ5sGZFFAp1lAmRODkJPK9KXx3aXJDOGGBtTyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8DYEXmR+w7EqOKudDsORR1qeBHMmtIXfk0VaPRmA2w=;
 b=nCnIDWQY1F6jvc//XTcVHPjuJ4UtMCx1lWY4LMOMGv+nUBFRc62zXS3ZcPB2mhbNoHj3f+nrbrTmnx1BKHRbz7FaHDw4BXb3I/TAhOzfVxgkdkwJR/lrCBbdeqI9/P6VIffWYH8r5mELRMCLhhNNaqoiwPgd8xn3rvPWphmHEmQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6148.namprd10.prod.outlook.com (2603:10b6:208:3a8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Mon, 12 Sep 2022 16:01:35 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 16:01:35 +0000
Message-ID: <06339cdf-ee18-9d97-65f9-3a7fba68d0bc@oracle.com>
Date:   Mon, 12 Sep 2022 11:01:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v3 2/3] scsi: core: Introduce a new list for SCSI proc
 directory entries
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220908233600.3043271-1-bvanassche@acm.org>
 <20220908233600.3043271-3-bvanassche@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220908233600.3043271-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR07CA0020.namprd07.prod.outlook.com
 (2603:10b6:610:32::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6148:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ecbf324-6123-4b88-f2d0-08da94d81194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /kbiYlZSeOp95LgGwHA/k3G9CSJPChhhVOMUHWpqOUPyrjupHd4hwGPqIqMXkKuHGJ9Q+bd8wVaJ3+AoshJXH37i1LXZBXGkgrP79pF+NArfSmirENCjRi9JvY83DIBGwe+3fLQ91x6NsM2kesL7sm6+ynDrddCDewlinfF8CCuYKGMJsLeNxgZy/eDMLY+0FPbvlCZENRzRums6vsp3rSZJvKfVYRtikjH1l7u+XfO96U3GUxiKPeRkyczAcoZ1Tz6WoUw8gxKyLkZVdp/nUi/RW5QrNr7LyTQesa3LfJXevHWOUHZOlbw4dZjC2hNP4PLCYtgsDH807XWwFJintf8Q46VwBar6vqLwvqCL9nWO8hFDOD1c67lapzFzPL4sMKc2w7Q4QvYOybcSSaNBQ3+k6fxUTpXJ8VBvodMgTkzPkuyoX7OTSsAEla6TaYdqL6MHlMPxrxzeU09oCJubuJaSMSGtVIwvK17a/c/T4+Kos5Z2ekV1Xb+ZNEvFhmQO99LuGYpvv3NfEMEKfeSbyo6sD6qfwXX+8FhtYKNrRdKQGkORJLpTm+J3S9LBoJC6lDCCvSriPgiYY5Uyp2tIRNvJ5flCYZpyaDlo9hL/K8YqSARkTxfcUK89/hGrpIyRwwy8v1rdAUE2FScD/22QjgCGC5Hh71sqraZQhXSFMLZGgMUH5TlJbaj/VTKe0cHyTqWcSL7/1Fnwoy+qoHisXUGS+WC9dSjn78azKywvA+ypiwyTQUj62jgbH0Zhnjt1gspKU7I++cWAAoiuPiy7mwtuEuH+HK8j+4oIYPpHvUA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(346002)(366004)(396003)(26005)(6512007)(38100700002)(66556008)(66476007)(5660300002)(66946007)(4744005)(86362001)(8676002)(4326008)(31696002)(110136005)(6506007)(6636002)(54906003)(6486002)(36756003)(316002)(8936002)(31686004)(2906002)(186003)(2616005)(478600001)(53546011)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzN6clVlTE0xWUp6cXJzQ3EwMFZZL2h0UlFmWHFROGtNQWg4OWlEVDdMd0ly?=
 =?utf-8?B?OHhtNkJsNmR0cEU1K2xpVUtXNnNsRlNFcy9Gc2lFL2RRQmpMbUphQ2RqQWxt?=
 =?utf-8?B?bUkwN25NeVNpUHBCM3FQWmxMU1A4SVNNZ2FEOGJxM0RmUGlJQ05DUmMwOUNO?=
 =?utf-8?B?WHJKZ21MTW1VcWpiWnc4UkY2bWZoR05OSlpHTGJHU0lkSWhkTnVEQjUrcGt1?=
 =?utf-8?B?elNpeGY5U0wvS2Q2aU1aT083SXdrcGsxaDdGMVhlTFg4NnRzRmFYSjVVNmZk?=
 =?utf-8?B?QVo2UkhBWFppbVZEVGxyRDdDaVhxTXR4cnp3SGRoYTdyZWQwVnJNWEs5UlZQ?=
 =?utf-8?B?L0VCd2FzSGd4SHZ6RHhLVVM2ZEdLNSthU291ajNKQTZBT2xLajRXTEx5Z1FP?=
 =?utf-8?B?RlF1cHpkUTBnSG1Rd1kweUpoMC95WVRLalFSM0d6OUJBdGthai96cHhrdlRz?=
 =?utf-8?B?dnd1bW5nTFZUNTZRZ3RkOUtJZHZHU1ZmbUY2Q3JCQ2d0OXFNVXIzT0ZxMG9u?=
 =?utf-8?B?UXdDNk5SS0dwcExYOFJZa05yRVVUbWZseU9WQXNsSTdMcFRBMGlJSVZCSFAw?=
 =?utf-8?B?QXIvanlzVnhVa3ZNUndlUzc3ZUxSaDVVMGpNVmtyUUQ3d3Jiam12MlRVdzk0?=
 =?utf-8?B?dkFiNFBncjFBeE51czR3OHd3emR2N3BjNWNxNU92VWI5QWFUOXFyaXJoUEg1?=
 =?utf-8?B?cDlqUWhrcDNYWDdvb1dCZ3JiWXcyQTlYTWx3SzlQRkkramtoc3dDbXJKbzh4?=
 =?utf-8?B?cUV5L3FJMFk3ZFZhRTJlbElXVzczNVlkQXlYOUhhd0wyLzB0MzI5VEhGVzRO?=
 =?utf-8?B?MllWZXlRTWE2b2szMXNrU3RRelNSdDVYVVEyUkNHSzFDM25zZytzSEVrVmRs?=
 =?utf-8?B?aDJOQTVPOVVha1EzVTU1Wm5OejBIQWVFSjdlcEJyN3F1TEVjQVA2elB5SjVB?=
 =?utf-8?B?QWpKOGkweUQyNDZsMG5nYW16ZnNlZDRmV0Y4VU1PQ2Z3ZVBhUlJEYy93OENo?=
 =?utf-8?B?MkxqeE93NC9iUGU3dDRsOSs1ckJOZmFXdURzN1pvdjk0eW9SbEtPdmg1djQ1?=
 =?utf-8?B?dy8zYWYvVW1YUHdnWlpPa3k4a3E5cFdmUENUcThXVmJSWjBPQWwxT2dPbStO?=
 =?utf-8?B?dmxNYkIrcXJEdVRWajZIQk02ekNvdEFqQjl6NGs1aXlmSmVCY09uK2lGWHNF?=
 =?utf-8?B?VlpOZ3hCVGVGK0pPQ2NPbFA5OXlvNFVjTUpqMFV6WXNRMTBqTVBnWGt0N2ZC?=
 =?utf-8?B?dUVKYnFzNEN3MFRaaTczQ3o4ZHpkWDBZVlArZ0EySHpmVHZyME1XQVc2MkxU?=
 =?utf-8?B?cVpaVUovVGtHVkJJaFNCam9ZRGZpNTB4NStHMDBzL1IyYlUydDAzOENYc3FQ?=
 =?utf-8?B?WWdqNGJQaTFpVFRkNy9hSlBzR1R2T3VNbEpFRUd3T2xWK2JXK2lrZ25WdnRs?=
 =?utf-8?B?VEY0R0k2S2ltZ0hjUFRjRGR6Mmx0ZkRYWGllSERJYWV2Z04xVDRVdEFJQlJP?=
 =?utf-8?B?RlVNc1BCc1lWbm5oMVY2OGFiM0wzejJBSUhJc0Y3MHFzb0RleWxJbzZrMEl3?=
 =?utf-8?B?SWgwOFYyejlZbGJiSDB5TEJSYjVGNlVBMDNUNmxwUTR4LzFUVUR6ZFVFL21i?=
 =?utf-8?B?NTh6Y244cUs4UGx3cG5PK2JaWWVUaHlsMW8wZTVzclZUSWZVcjMyeEZmWk9p?=
 =?utf-8?B?OG91bExrdVdZOVFPdEo5RGhBTjB3aXhHcWxRamJ6M21oWnF4Zm9EZTA0REpk?=
 =?utf-8?B?allJNVI0ZnRFaEp5UEFPUUoreGd3NEVNMktGQklyUW9rTVE2c1Q3NnZMemhv?=
 =?utf-8?B?SHJCN1VhTTQ5SzRicmN6SHRlc1RJL2RwR042ak9LWmJWeVc0NUl2ZUhheS82?=
 =?utf-8?B?K28yVGxkbzRyMkU4WDIvbkErTWZhZ0h4SlJjT25OTHh6QVcycmE0QmVVUkdC?=
 =?utf-8?B?a1FDNlovK0VVSDZyRXlNOVVycnpHUTNWa1g3RUNlUkp1bEkwakdEMi8xaDl1?=
 =?utf-8?B?WGhLdGlpUW13RmxvWmlwbE82dk4vMDVqTGdkeU56ZU1FN2FtU2RxUldnWUhv?=
 =?utf-8?B?MHZCT0VOL0VHaFZGeUk4U3NWbkV4Wjk4QUp2dnNYNTZ4OE9ibUFYOGF1ZC92?=
 =?utf-8?B?MGN4VkZBOWVucFI5ek93eHNsdGF6MzlURzBXdVNxRlY2Y0dSVm1PRk9zK0Mx?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ecbf324-6123-4b88-f2d0-08da94d81194
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:01:35.6573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tysM+0MmoOKiKKS2cisX217yFOdNbGKxm7uc1KCg1a1Wa/STUx4e7LPX4Gy/c9toPUeYx72kMmrCluEu/3pZbsni7dNfaz4MyPSsgQ2s/js=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6148
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_11,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120054
X-Proofpoint-GUID: _sfHrBcrul5brtiSWq__uLQMuIPtFufb
X-Proofpoint-ORIG-GUID: _sfHrBcrul5brtiSWq__uLQMuIPtFufb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/8/22 6:35 PM, Bart Van Assche wrote:
> Instead of using scsi_host_template members to track the SCSI proc
> directory entries, track these entries in a list. This patch changes the
> time needed for looking up the proc dir pointer from O(1) into O(n). I
> think this is acceptable since the number of SCSI host adapter types per
> host is usually small (less than ten).
> 
> This patch has been tested by attaching two USB storage devices to a
> qemu host:
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

