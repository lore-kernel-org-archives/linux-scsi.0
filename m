Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635AEC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C0D5611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhIVEqu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:46:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54202 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231741AbhIVEqm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4bAoI027967;
        Wed, 22 Sep 2021 04:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7kIo71wvosXPI9cwLxbROmo7HWuX96o1c5d/o0YJNHg=;
 b=wactvP+jwsOqnpj2bDcGXKLMf8cr59EmFkucw45DfwvZUPVHgFqaD73OG4WW9ajhKp3s
 hMazwfwrookfZndt0CWWFFKECNiCCEcnM7bm1Jgc5NjFQojwb1LOAIkpaVsiXWgIG1pj
 18B9uQwXexuO5aAjnNvNRIEVbIACDLPbDFZdVOvDIe1q5uvYi7NLeqa6w2qHneq0vxSX
 /O0UtMXS4+WEyFPgEAr6/stUps/otUJWZe23kM3WWGv0vLRQ82G1H5+BSYhuA9zRtsnx
 vxedulN46dyENFkr0wB9KziJ/QiNaZSe2VLX/AA1lpWRDYeg3AfPeAxybyfNKFuTle+n 3g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4iwBm195776;
        Wed, 22 Sep 2021 04:45:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3030.oracle.com with ESMTP id 3b7q5bks3v-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWOTPL9G8GWdqJbu3xLJBRtknR/P0kXx9z3qwexmRgfQvHQvWxTTP9Uh+3xZOz90dSQSHVjrsXU2fvsENAL+n7K8MPTpA7WqhhXB3292/2elvQBisKLe268e3mC/xiXVQCAewQkN27eCEYmGwkXEsa7dTD9G+H1F1TebbhybMXKQX0bj67/6wT955MML0I/3R9cT3niEPC98eZDEveTGTtaWj8JOeMv9uNr4goh49KHKHeQRnysOaGouQjs0U53mpxARc0mU0ZmydDBoWm5FQqEkGISlMuy58MkAi9Z8h175OvQxn6XwYikem0XRedm0xojHrkMUuqB4+uKrZBhumw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=7kIo71wvosXPI9cwLxbROmo7HWuX96o1c5d/o0YJNHg=;
 b=n0BBKKDRj9orK0gatvqp59U3w5Et5zU51H2jgxUEPRVDsoQGZ6By4GgVZKbw278+qOPhNJcKxLs/fdhUUmKYXdXFFCLYq+v0ZwP1aZYR/0d2gnbNsXd3UEau7MRFuT05tOL50P/yOtLqFiOF+cmnUE0UgjUvr9q3jZjYZy6viz1QgXXC97fZsBjm5DTXLRhsiU/NWQRSfcFbtZ2IyuC2tlcPvY9iVM0TP6jQsF+qKoQGnHKwU4IOArzOq8zcIj7umytOUlDtXiLgDDvAoz15SDodIikS8QJbTF4zm7BmDKYR3T+IC62ppMlvhEgzZA5ic/uj0lveStcRQKd9Vh2yBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kIo71wvosXPI9cwLxbROmo7HWuX96o1c5d/o0YJNHg=;
 b=x/VPQVL1gHy3X6wyS/5I+hSHtbTUqbvD3IQEQXQcrQtoupKsxiJOYHnifruqeb27BVEkzUUxlBU4VZssrKDtkPxRWBo6sP/kYWZPX5S0o8XxQp6NpOezM/9xzZpqfn4dTQHq9s5FYIf66frE2qwZ9RAn/SAMN1CaPTt/O2z+ikU=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:44:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:44:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org,
        Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v2] scsi: ufs: Unbreak the reset handler
Date:   Wed, 22 Sep 2021 00:44:46 -0400
Message-Id: <163228551951.26896.3096733485631630084.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210916175408.2260084-1-bvanassche@acm.org>
References: <20210916175408.2260084-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8e07fec-a42f-419a-2ba3-08d97d83bba0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518CCB55447C8A2CDEF3FD78EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MW7EiZWcnaOK75Ag6knIRARpm12ObKN9MpJLfQJi3Bwl+dXqMzY0+6Fv0G79TTj/BE/JCKL13AB+/8hNadR3DNRoMe5Zhr/ysbn1oKPweja8ExLN/zuq5icOvv4CPtCz3gypTLl2dUxXw+RD8c5YoyIBPfjm+zOpI3DDIMletBX3wviVmlIEgy28ubhydqm9qtTjp70An2j2EsGo4fuCK7rTjkK/EWjQsFWKxADvZ4dncUqGz2qPsakXZQTvzdtBN0GjgawEwYkjfDLKivsZQotYQMzuX+oNVk8NSwO2mm3yJDh/OwmDs8x8Ms0a4WuqXUtGl7aWs51w5kIvQr5I3fBdWLPxi7aiRW+5q5cScuyD+HyIws+v7Z2g1GyFGjn7hk9u9kRYBItAgPEUbSqlN2o10WeRP5F4/sqObMvacRpb7ooJ0aXe9dh0I0xwxkBc7Izx7BP1wettggGXV12Rgw8Aim0j2WybR+Y/cGCGBtsrIi2XzEMDOZJf2N1vlZrcnzPRYmY+42qm+OWBtRZ1VjYAuwpMkyKE6TimP6UwoSyYmMkU8hFzzZVqIT0t2irB41ybrNu3RPLdr+ke0UwHACkkqKZqe75+femMCa6TP4zRYSY9sSdui5cGWbXh2E5pkZM3JXb2jq8SozDEVJCwxTIGjqjDCB3f7j656zgDbtyiuC2sBBxI9HTcfCj3XmcIQ1zjaXFmu8c7q5mnnrqYjLBXAvojaIc+40tvfBcQH0ZTR7ySf4HtzTjCoqSk4lVgJss4RAHNG9ilb+hmgEf/Lv5GJovblhpBNRKCYS2pcLo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(6916009)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(54906003)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OS9KS25wMWVrZlVWR1RxVmdsbGQyMXlVYWxVM1ZPK2RId3dqOVp6QnNvWDdS?=
 =?utf-8?B?dmNOS0ZFTnlpSGhhNkk0MEI4V2wwcWllWVlpcnJlUkFQWHgxbStrbHI3VS9p?=
 =?utf-8?B?U1ZmZSt4dEhEaTlHVWcrdURFSldRNTgyMjc2Y0E3TTR5aSt0bWZEYjdyakFI?=
 =?utf-8?B?UDBocitnMkhIVUs4ZTdlUG03YVlFSmZoOEM2cytQREtrRGgwY2R3TmJrR3NQ?=
 =?utf-8?B?WDdYWVptV2Q0NWQ1bHJ4RmxLb1RBdkt1WUZnem13K0g5RVhyTkwvNzlVeUZC?=
 =?utf-8?B?NCtuSXA2R0MwNVVsdFpDUDVZa3JkdHFTMG9YZVYxeVlYMDM0MWh0VUMyTHFD?=
 =?utf-8?B?aDRKWGx1NVhLeDlQeENkL2phQ3pXT25lM1ZLTXVCUHU4MkZKL09zc3RIWUlU?=
 =?utf-8?B?NFlNanl5TjEwRGpaMW1NTzdEeWUra1I3U1lvQ3lNc0FTUjdQRTc5RW0reGM3?=
 =?utf-8?B?RmRtbDlQVkszTDd2VGNCUnJLSm5ZQ3gwbVl3RkR1dG90TWpyR0xIM0U5WHYy?=
 =?utf-8?B?VGdhT0poOFQvSjl1TVRlVTVoNlZPQU5sMlBHS0VpKzVEQmF2bndtOG9HSS9u?=
 =?utf-8?B?bERRR2RmSnFHUkZxRjg0aTlVZWd4U3JZV3VnRVNZNm9DOXc0bGU3NlhJS3pR?=
 =?utf-8?B?QlBWMEs2dW4yL2VqRm1uTHhRd0wzRFNZdWNIeVNyb2JqMG9acnVMa1lPS3VY?=
 =?utf-8?B?bkZ6MXFNZllrRGlYZzgyaG9QUXRiSVFldzZ6ejRMRnlNNk96Q0dLSWY0OExI?=
 =?utf-8?B?V25TM1lsVndzd0FqSVRJSWxES05DN0ZGQzBHZStCc2syVitVb0I1Y3ZUdzJV?=
 =?utf-8?B?aUFKUUI5S2t3Yk5HWHhzTVRNcGIxZ1krR2FKS3k0OHBGU1FHcWVlVVpjYzJ0?=
 =?utf-8?B?ZUl4cE5VcEF5cDMyNGpRcGQ5RXIzM05MdkxjWGQvVXR1N29zaWRXNUI1NmtD?=
 =?utf-8?B?VmU5TVRJRjFPZ0xsbkpUUkdWVm5Ga2wxK3lVdnZNUXNTTzl5YWNPYjA2VFJZ?=
 =?utf-8?B?aEZQNEJUMVF1VjIyVlUzQmZpandEVEU0QmwyOHFXaXZ5Qi9mTnBXQzRLZ0Zh?=
 =?utf-8?B?cjhCOXUxdytJRGp4T3BwWGpHVlhoSDk1OUpzTTdkRWZYMEFLd1lsZXlnd3Zu?=
 =?utf-8?B?d2V4OGxsT1VLdUhQTzg2ZEhXSU9EQ1hvVUc0QWtKNFRmQnBFYXpZVXd0S2lR?=
 =?utf-8?B?R0kyckhIYXNDMU9TTDdHNU5sdDNIWTA1VkYvM3ArNUFPTTljbjhDT1d3dnVX?=
 =?utf-8?B?bXIyaXc4NnNJN1Y5VTNTK3lkOEZ4T2h0VmFXOHVEb0hFdzYzUGpQK2plc2xW?=
 =?utf-8?B?Y1lsRWZDTEJOQ3dYblpMS3JyNjR1SGJqc0E0cVQvdUpvSWRCZTRabXpNakNI?=
 =?utf-8?B?WWJ4OGZ4QkQ1Qkc0M2NDRnQ5RW1Qa0tqaXJ3K21rOGJoU0R0WDhFOWsrOElV?=
 =?utf-8?B?TWFLS2Z4eHZDRFFsdnVTTHRLZ2lFRjBUR2lvQmpLSU93RWlBb0RnMDBpa3RT?=
 =?utf-8?B?OWZwbjZjanE4VTMydVV5L3B1NHhhSXRhWmdMRGxWcWdBSHJFZkZZRnE5Wkxu?=
 =?utf-8?B?T1RLTzBXZHpCV3pUMDR2S1pJRWpPYUNvM0ZleEh5WmcySFJkc0hGNmtYek5u?=
 =?utf-8?B?TmV4MFVaVEZqYURjUVBhbVZTZ3FmODVCbEcxdXZjVXN4RExZNzJGN2hMVmds?=
 =?utf-8?B?cUxNWldnMmFWeURyanJONDZKUnBkTE9udFJKQnpUcmhpMDAveDRIenpSU0JG?=
 =?utf-8?Q?NQvRRMkHajlv3qEaEmt+Zr3ZtuDNZNF/4CioEda?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e07fec-a42f-419a-2ba3-08d97d83bba0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:44:59.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ebpxw/u8RnaqQ5xHeNtBSdOWMl5jtdRg4lErSqjR435xj1HDDOps9u3NMxBnr7Hxm7DmwTDPXOLfqUE1WUWAalMVXaeFfENL2oO05I11wbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=949 suspectscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: LmXDJIJ2DjYx_n5sj_anKq8GOfVeuj0v
X-Proofpoint-ORIG-GUID: LmXDJIJ2DjYx_n5sj_anKq8GOfVeuj0v
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 16 Sep 2021 10:54:04 -0700, Bart Van Assche wrote:

> A command tag is passed as the second argument of the
> __ufshcd_transfer_req_compl() call in ufshcd_eh_device_reset_handler()
> instead of a bitmask. Fix this by passing a bitmask as argument instead
> of a command tag.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs: Unbreak the reset handler
      https://git.kernel.org/mkp/scsi/c/d04a968c3368

-- 
Martin K. Petersen	Oracle Linux Engineering
