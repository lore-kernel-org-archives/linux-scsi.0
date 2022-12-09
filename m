Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7DAC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 00:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLIANc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLIANa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 19:13:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB182F9A
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 16:13:26 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MIZOJ001128;
        Fri, 9 Dec 2022 00:13:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BHsMK0zmkD5Y7X0CJwsy2fS11rDJrXcBf8NjbBgMUT4=;
 b=BMdREPqT/G4jz5oDeMo0hXlboVruuSf81e25UalDkWnlzKfCsDY/xPr04PYb18Xd9kwD
 MK7aDi/+3BawVVQjMPCkQsplpqRuUgKHValaUozTIbJmLK8htpQ++fPZhB8j5ZtXTSzc
 GqaAxbYWKVCF8WwJc/vvDSNNBZW/wytqlW+m5FYyY+NeQu8E+OnABvsIy8fw9k9Z4N99
 8Cyghc5yztuyWiOkbYCTRSZhTw4Gg2sxnJeLFFUndKerTSShsGiKnn7d+tOZ7fN2O9Vb
 gUXyiebZYoRyQ1e1N9Aoyp2h6ybeKKvbBwwWh9Mv4i1hOpwzFayDZQglMQ0tBjM1pWY/ uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6u8ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 00:13:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B904HN0008326;
        Fri, 9 Dec 2022 00:13:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa61ncts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 00:13:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbgtuSHuGj6hdO19c2M5yk87tzgNzH74L79T26Zo0zAbch5hnuktTiwdamT0lcz0MwwyFXTICT+77EAj29+44kbU6BbEnQz9oLpz7PPn6U029Pf/N7qaTp1fsTGWo23bzpMEWKYcbOzt401RBRBSXuQM5tyAJ6oNcOPdvnK30CkoOZxHLlhb2QDQIWra0gVLuc2NdUpgtUfjIzLvGwWhm56UwYyov5/tKHgLpLBY3XuERKsnOo/aG3O75rN826AObtjJTFv+hz9pFemU6Dbrmo69QoiyULFK37a8heha104SGvqOncG6tC9aL0uRmUcmWMXLaek2+sYa7+ZKb/B8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BHsMK0zmkD5Y7X0CJwsy2fS11rDJrXcBf8NjbBgMUT4=;
 b=VompuVkwWugO1VWmhapbRjjc9XFQnQROwZCHY+q7lj3UhHCkViP/JigYz606Lqo/EYHXNMhHcGTFqh6izquGNwu0BfEuW7KZoBeGr3gHco41s4P4tKjItA8Xr6YJAR0Nh32lEYy8KdJW2FdXOTMngwiszEYfrmO5jYiUjE8I1ogOr8UKjrs6whLEnvJ3lnSgB96UvWCB8D2blgF8IkC8484DD2fzOkwFIEf0E4AqTwO8+49wIrg5ui0jm9GtkaQp7JOwFF7TTf7p1Qs2vqKyfBMkoE5lj9IaRJx8OT3xUg9JdW/lLQ1QWnbwfWkUzmDk+onUcTb7m8sch9jvY8o9dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHsMK0zmkD5Y7X0CJwsy2fS11rDJrXcBf8NjbBgMUT4=;
 b=Ne93ZEZC0MwrDvLj1Et5IqYt7sowZkaZAQiL1d6Fy1xILWjK9YViVb3Aix6prRRWAwgSMEbiH9aMYyyxsEsE5X8o6Zo3mnbIexuvSCRUOFxMzt725g2Y4UmxkWP1eeaAj2xRKz1rvf1X9Ya0ujQQ8kNplvesVFmoWEulfTm+UDc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6650.namprd10.prod.outlook.com (2603:10b6:510:209::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 00:13:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:13:17 +0000
Message-ID: <2fe5212b-308a-54a2-cf44-9b2895132f74@oracle.com>
Date:   Thu, 8 Dec 2022 18:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 23/25] scsi: sd: handle read/write CDL timeout failures
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-24-niklas.cassel@wdc.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221208105947.2399894-24-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0022.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11c::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: d39e90f2-b90a-4d1d-c624-08dad97a2c19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsVnAjOldf+9GWnJ3NNLjj5RzDba7ba8MEVg/FSk6RIqReZXmRb1pSY0kgJxqAQuD7LK1u6LnOjCorOUlhhA0vdnkZz/e7MXV4iNK92J1ppv2LiNJGzPXBo0rmdnRz+QYV1MaI0pMo872QENoggrZaKmWLm0JJ2sQfUT7kO8iibtpRfy6QvMRQ7Wg2Xj0Kxsp798KyvEwpjj8T9YS9i5paYSsTaT56JuP9v2qWh/WJwxw/tyaZKuQNyzRx3dou9rr7QKxccX4OEuONPTCqiv+jSmADJf1lNKHo+jm9+Bqwqn56jCSIhrj+aSoRdyBI1QUpaa5Uor0De/cZppuKfjbvZC6GZL1UA7zWzCzSZIb/MrwOFGd4x+EdWN0l+bJoZN0wjcFsCGNMs0h1OsonHdDKCSk46d0zf3UNQKWKTNOqDUVYlLKK2yd2TX/pIwDpV5XzWTerrborz2jV+wozDk0TOB4X0ChZ7mBmJjb5Za2hZkLcpmb4D82631epxih4TzkIwupZL6TRTqRIe0hUSpPM6VWQJhH8EjPuUyuK0Vbia2bWuAnmhKAVFRcTUISEM60au4w9dbOQnB/eVSpQhPXl2rIcHvQBynpJ9E9MlVlExtr8LqscFe4ZsnuleDi6eUQgjQC/bgepH/UZfJJIJmljrCDAoVxuwKInB7CbfVdST9napUNiyaDd0AuDKqg7xSI6CLOka1K8+FAgrH6rMfoMnY/ST55vzCUyYVIThTUfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(376002)(396003)(451199015)(36756003)(31686004)(2906002)(38100700002)(8936002)(5660300002)(83380400001)(2616005)(186003)(31696002)(86362001)(54906003)(6636002)(316002)(478600001)(6512007)(26005)(6486002)(41300700001)(8676002)(4326008)(110136005)(66946007)(66476007)(53546011)(66556008)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGRLdmwrK0JIRWIzQmxYR3VPUGRnbm1aczNha0ZOT1VhamhkQVlPWWhoOGRF?=
 =?utf-8?B?MlZMNExRSm9XcUdMZjdPLzMyRkoycWJYS3A0MUx0dmd3Tms0MGsyQUdFN1U1?=
 =?utf-8?B?aUIyUkd1WDdsUkZ3M1FIOVMvejFYaG9peGlETHlRbVlxWEVvK1duQ3Z3MDgx?=
 =?utf-8?B?YlBBcXNEa21QcWhXRWc2U1FzZlJObjFoamJsZGlHdXBiczRkRDJ6RmNSWS9N?=
 =?utf-8?B?OFhYM3J5ak56bXd6WHVLVXBNeDltbnovdndmNEFwR1V1cEk2bHc0MFNva2kx?=
 =?utf-8?B?Y251bUUybk5NOXJySkZjSEx1RjZRN09pQkJCd0ljQUtHN0FmQjhidUJyM2hW?=
 =?utf-8?B?eFdSdVoxOE9Db09GeWd1Tll6b3UvSkRhQ05kaCtmaGczRk1ROXUwNTk2dElK?=
 =?utf-8?B?SFlCeC9FQ0pRYm1CT1lreEtiZUhBYmJuU3prVFdqR1RMTDFoRHlmWkVBZFE5?=
 =?utf-8?B?UW9WTHlrOVl2SnRobFZKS1hxS3BGWGVCRVVhNVlGVVBtL1NWcTMxR1c1Rlg1?=
 =?utf-8?B?MzNzdjdGY1F2Nmo0ZXZ2VnNWRExJODB6ZWRzWnl5a2V4aTIxSHAxK0tDOFhD?=
 =?utf-8?B?NVdNaW40MmJvZ2h0blNRTldZMUZDUDV6RFNmbkV6VHE2clNBak1lVUVxaXVD?=
 =?utf-8?B?V3FkVzFBMllMdkczak9HNkYzR2FWUXRNWHNRUndERnMxdDIvYTRlZG1zUzRk?=
 =?utf-8?B?dVMxNW44SGo2NkQ2QTU4cWNZSys1TlV6Lzc5SUp6RFZzK1UwTlc1ZDlRK3Qw?=
 =?utf-8?B?UGpPUTl0ak5JVEZCSS9ZazZlS2FGeVEzd1N5cSt5b0R6UlNnSG9tanBHWnZw?=
 =?utf-8?B?MU5CR3h2UHNkMWZKNDk5b1huanZUY0laUHg1eDVWeEVMaW9iMTBBektXRG5t?=
 =?utf-8?B?Z21xS1N5K2NZK0daRlVzZ1NlSDZObEZMMTBSNGZFeVdUUWkxT1cwZ2ptMTFZ?=
 =?utf-8?B?c1NWSklhdFRtSnMwWGN3MklVdTFGcFZhNEFibjYvZ2lyaktXY0dSYm84YjZR?=
 =?utf-8?B?VG8vdmU3SG15M0NGUGNvRGNwN0V5K0Vac0pmQXU5M0lwNU42TkxmUER0R1VT?=
 =?utf-8?B?YWQ3a0I4VC9aVWhYcUd1aGgzVStDMVZHNnpPMEVCc2NDSG5BbXpTV3V5ZS9v?=
 =?utf-8?B?QndxOFNraDlIditUank4UWNBMDNQOGJXU29HMnoxOGNTekF4OVMvZGo1U1Vj?=
 =?utf-8?B?YWlCU2dKU0p0dnZZUVNUYXA2Wjdia0JLc05vZ0JoNjVUZ2IyYlNmSHozeTJt?=
 =?utf-8?B?TkJRT09QRWFaclpqQXFCYlhHWFJaeEFFY081R2o4ZWlYVVR3bFNDZTZJRWU3?=
 =?utf-8?B?NVpYMVVoQ2ZZS3VpQUtJOEJTS2FKR1NFc1JsTDF4bWZ6bisxSmhrZTJpRHJj?=
 =?utf-8?B?R0s1b2VtQldnU1VNaVhRS1h1WFIybFRZaVRDbFd3eTJWQVBEMHVjWU5mR3FN?=
 =?utf-8?B?U1RTRE01OU8wcitBYzFYL2J1WjJGSSthajM4RFFXRzljbVFwRWFldWV0QXYv?=
 =?utf-8?B?QWVHNXJveDFnUGlSMnVkVXkyQWcwdTNGL1pFVW5BN3h2Y2lwWEtoQWdvS2lT?=
 =?utf-8?B?b3dYU2dzeXorWm5QUmtqbko1eVZuZUNKSThtenhBNFMxMDlyYzk2MkhPRzRB?=
 =?utf-8?B?V0dsTkhXdjNlY21Xdnk4R1pzajhXanZOa0UvL1BidTJTdmRxbi9tMlNIK3ht?=
 =?utf-8?B?WnBXbEExT0pxK3JJR1YyR2t6eVc3S0tCNGZVZ05Ob2ZvYUMrYXNDVkg1aU1o?=
 =?utf-8?B?bzFtSHBMUUd1RW5Lbmw1V2x2bWFzVFdjVytnbjBWYmJqMUgzL3hUWFVRN0xV?=
 =?utf-8?B?SG0wMW1QNUZvOUpNQVBiaVFrRFpmNXZIOEg1d2hObHpyRnE4cjdQdkJNVElo?=
 =?utf-8?B?SEJ5UUxscEFQc0FYU1pQREdJZjA2VGRkMXpZemNWem8xY3lRSG9nUHF5WDlS?=
 =?utf-8?B?bWlRQ3R1aENBY25nVFpDRm9FV0U0Q0QrcWVxVXd6NklmdlZSdlVrZUZnRGYv?=
 =?utf-8?B?TE5ObmRzWGlneS8yc1QwZlJqMUR2TmZSZXJ0VTFQaFlFRjVia2VPQ1ZTVGdR?=
 =?utf-8?B?NEIyZ0pWZU5vYkVUQjlKQUFNV1ErbTk2UlZnZDdiZ0FXcXR2NzZaaDJPT2xV?=
 =?utf-8?B?L3lZZE1BNXpGZXNyRnQrREo2S09GYlY5ekJLL3RVOWU1WVpOeHdNd3laNnZK?=
 =?utf-8?B?RlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d39e90f2-b90a-4d1d-c624-08dad97a2c19
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 00:13:17.7033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0AQUixxcy/LebbiiRgqKVtZMCFUT3NtPRg9y2Mi1/2/8M7qW9YTzTGuOCSWsVFF0xMAowC8VRWxp0WQQ5Wlso2W7OylbgFv5OA+8nnUm3wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090001
X-Proofpoint-GUID: nBB263PXIGQrUQ7d5x4_LkvsupHQF79Z
X-Proofpoint-ORIG-GUID: nBB263PXIGQrUQ7d5x4_LkvsupHQF79Z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 4:59 AM, Niklas Cassel wrote:
> Commands using a duration limit descriptor that has limit policies set
> to a value other than 0x0 may be failed by the device if one of the
> limits are exceeded. For such commands, since the failure is the result
> of the user duration limit configuration and workload, the commands
> should not be retried and terminated immediately. Furthermore, to allow
> the user to differentiate these "soft" failures from hard errors due to
> hardware problem, a different error code than EIO should be returned.
> 
> There are 2 cases to consider:
> (1) The failure is due to a limit policy failing the command with a
> check condition sense key, that is, any limit policy other than 0xD.
> For this case, scsi_check_sense() is modified to detect failures with
> the ABORTED COMMAND sense key and the COMMAND TIMEOUT BEFORE PROCESSING
> or COMMAND TIMEOUT DURING PROCESSING or COMMAND TIMEOUT DURING
> PROCESSING DUE TO ERROR RECOVERY additional sense code. For these
> failures, a SUCCESS disposition is returned so that
> scsi_finish_command() is called to terminate the command.
> 
> (2) The failure is due to a limit policy set to 0xD, which result in the
> command being terminated with a GOOD status, COMPLETED sense key, and
> DATA CURRENTLY UNAVAILABLE additional sense code. To handle this case,
> the scsi_check_sense() is modified to return a SUCCESS disposition so
> that scsi_finish_command() is called to terminate the command.
> In addition, scsi_decide_disposition() has to be modified to see if a
> command being terminated with GOOD status has sense data.
> This is as defined in SCSI Primary Commands - 6 (SPC-6), so all
> according to spec, even if GOOD status commands were not checked before.
> 
> If scsi_check_sense() detects sense data representing a duration limit,
> scsi_check_sense() will set the newly introduced SCSI ML byte
> SCSIML_STAT_DL_TIMEOUT. This SCSI ML byte is checked in
> scsi_noretry_cmd(), so that a command that failed because of a CDL
> timeout cannot be retried. The SCSI ML byte is also checked in
> scsi_result_to_blk_status() to complete the command request with the
> BLK_STS_DURATION_LIMIT status, which result in the user seeing ETIME
> errors for the failed commands.
> 
> Co-developed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  drivers/scsi/scsi_error.c | 46 +++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_lib.c   |  4 ++++
>  drivers/scsi/scsi_priv.h  |  1 +
>  3 files changed, 51 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 51aa5c1e31b5..1bdab5385985 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -536,6 +536,7 @@ static inline void set_scsi_ml_byte(struct scsi_cmnd *cmd, u8 status)
>   */
>  enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  {
> +	struct request *req = scsi_cmd_to_rq(scmd);
>  	struct scsi_device *sdev = scmd->device;
>  	struct scsi_sense_hdr sshdr;
>  
> @@ -595,6 +596,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  		if (sshdr.asc == 0x10) /* DIF */
>  			return SUCCESS;
>  
> +		/*
> +		 * Check aborts due to command duration limit policy:
> +		 * ABORTED COMMAND additional sense code with the
> +		 * COMMAND TIMEOUT BEFORE PROCESSING or
> +		 * COMMAND TIMEOUT DURING PROCESSING or
> +		 * COMMAND TIMEOUT DURING PROCESSING DUE TO ERROR RECOVERY
> +		 * additional sense code qualifiers.
> +		 */
> +		if (sshdr.asc == 0x2e &&
> +		    sshdr.ascq >= 0x01 && sshdr.ascq <= 0x03) {
> +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
> +			req->cmd_flags |= REQ_FAILFAST_DEV;

Why are you setting the REQ_FAILFAST_DEV bit? Does libata check for it?

I thought you might have set it because DID_TIME_OUT was set and you wanted
to hit that check in scsi_noretry_cmd. However, I see that patch where you
added the new flag so DID_TIME_OUT does not get set sometimes so you probably
don't hit that path, and you have that check for SCSIML_STAT_DL_TIMEOUT in there
below.



> +			req->rq_flags |= RQF_QUIET;
> +			return SUCCESS;
> +		}
> +
>  		if (sshdr.asc == 0x44 && sdev->sdev_bflags & BLIST_RETRY_ITF)
>  			return ADD_TO_MLQUEUE;
>  		if (sshdr.asc == 0xc1 && sshdr.ascq == 0x01 &&
> @@ -691,6 +708,15 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  		}
>  		return SUCCESS;
>  
> +	case COMPLETED:
> +		if (sshdr.asc == 0x55 && sshdr.ascq == 0x0a) {
> +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
> +			req->cmd_flags |= REQ_FAILFAST_DEV;
> +			req->rq_flags |= RQF_QUIET;
> +			return SUCCESS;
> +		}
> +		return SUCCESS;
> +
>  	default:
>  		return SUCCESS;
>  	}
> @@ -785,6 +811,14 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
>  	switch (get_status_byte(scmd)) {
>  	case SAM_STAT_GOOD:
>  		scsi_handle_queue_ramp_up(scmd->device);
> +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> +			/*
> +			 * If we have sense data, call scsi_check_sense() in
> +			 * order to set the correct SCSI ML byte (if any).
> +			 * No point in checking the return value, since the
> +			 * command has already completed successfully.
> +			 */
> +			scsi_check_sense(scmd);
>  		fallthrough;
>  	case SAM_STAT_COMMAND_TERMINATED:
>  		return SUCCESS;
> @@ -1807,6 +1841,10 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
>  		return !!(req->cmd_flags & REQ_FAILFAST_DRIVER);
>  	}
>  
> +	/* Never retry commands aborted due to a duration limit timeout */
> +	if (get_scsi_ml_byte(scmd->result) == SCSIML_STAT_DL_TIMEOUT)
> +		return true;
> +
>  	if (!scsi_status_is_check_condition(scmd->result))
>  		return false;
>  
> @@ -1966,6 +2004,14 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
>  		if (scmd->cmnd[0] == REPORT_LUNS)
>  			scmd->device->sdev_target->expecting_lun_change = 0;
>  		scsi_handle_queue_ramp_up(scmd->device);
> +		if (scmd->sense_buffer && SCSI_SENSE_VALID(scmd))
> +			/*
> +			 * If we have sense data, call scsi_check_sense() in
> +			 * order to set the correct SCSI ML byte (if any).
> +			 * No point in checking the return value, since the
> +			 * command has already completed successfully.
> +			 */
> +			scsi_check_sense(scmd);
>  		fallthrough;
>  	case SAM_STAT_COMMAND_TERMINATED:
>  		return SUCCESS;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e64fd8f495d7..4f317c6593aa 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -602,6 +602,8 @@ static blk_status_t scsi_result_to_blk_status(int result)
>  		return BLK_STS_MEDIUM;
>  	case SCSIML_STAT_TGT_FAILURE:
>  		return BLK_STS_TARGET;
> +	case SCSIML_STAT_DL_TIMEOUT:
> +		return BLK_STS_DURATION_LIMIT;
>  	}
>  
>  	switch (host_byte(result)) {
> @@ -799,6 +801,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
>  				blk_stat = BLK_STS_ZONE_OPEN_RESOURCE;
>  			}
>  			break;
> +		case COMPLETED:
> +			fallthrough;
>  		default:
>  			action = ACTION_FAIL;
>  			break;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 4f97e126c6fb..f8da92428ff6 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -27,6 +27,7 @@ enum scsi_ml_status {
>  	SCSIML_STAT_NOSPC		= 0x02,	/* Space allocation on the dev failed */
>  	SCSIML_STAT_MED_ERROR		= 0x03,	/* Medium error */
>  	SCSIML_STAT_TGT_FAILURE		= 0x04,	/* Permanent target failure */
> +	SCSIML_STAT_DL_TIMEOUT		= 0x05, /* Command Duration Limit timeout */
>  };
>  
>  static inline u8 get_scsi_ml_byte(int result)

