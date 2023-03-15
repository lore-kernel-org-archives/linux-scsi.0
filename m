Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE50C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 16:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjCOQqs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232173AbjCOQqe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 12:46:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD5AFF2C;
        Wed, 15 Mar 2023 09:46:06 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FGZBom020607;
        Wed, 15 Mar 2023 16:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=BQKHBiWY9yhAwV/Ao5m17LgNyFfAFxeancV9ygdKQ54=;
 b=n4daQ57z9KvEymZHBdtfCxn/1knX0diF8JNFNvkUzE025/87tXvdILZHUMNa7GCRUKLP
 phLoevK8EkWQv5+ix695IqaWfUdQjq9dxRf1xmNJGhkcca2b3ONIyEEa/s50qfVognHb
 hVBMpxUgI6VgbMG2U4vtle/hKPPx7NhRgMG+H9ME8+haj29AOmYR1NgtoIoA4Uu5AkJQ
 s1PIOkO3jOTiqAwhiG/ernT/XJd41uvmW4a7BmJG/llPhjoZf/+4xXKceBVeoKpmVBDp
 IzJKLk+BTrBhcUo2YhvFd0gCQuftJQOX8+nqJJ2Tr7JJXJzxgWAXqwtnsGm0t978EMvf gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2bu1tpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 16:44:53 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FGfw5O036131;
        Wed, 15 Mar 2023 16:44:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2c0mu8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 16:44:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTpUhOC/v/0SP3ZKMhFx3zd/qv39qIxKKhEQ4/43DxNkNo++RA9so5GLRI+UGqDVCT9yqT731wOqtPY767CA8Troq2bh9XpnacJVv3kI9sppufYQ1yot/nu94b1rGU7uWn5csBrWHU8bQFh0KU3lXM24zrBZyu5YMCxosrTpLD0WNyINkygwxVUDGIueQO8Xc27GmqwMOX6Zpr8CCusuEnl252pBiIDRVj+izfslKqWlzLB8o5IfqjaEzgsQDd11yXrd5k+qmCCrZ6/S/xopz9H85jPC69nRZFoppDkEXIIhC3BCD4Fni3qIMh9FuW7mArGB6A3VER66z6wa7omSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQKHBiWY9yhAwV/Ao5m17LgNyFfAFxeancV9ygdKQ54=;
 b=hGDwPg5Rm/3SPAOcaGuorEWM4It8XPgi9fn5pCnxq3ZLdqLRaqzeZd10692PlXevvUr+oahdFZpt03BWqLYZWGQZCq2meTi3jkZZ8L8zJRfpISP2EWQvtxBklsF4K/8aPu9tBuHFit9nNo2n1iEYpTDrdLUyeHs58kW/mBl7Dbhx+Uq8UMtMwu3ccGpA4jwADp+r5N0oaAwXTcG+9WrNXgJ/EUdISQKYvQ3UN5zv3HgBvnq065o3aaLjnxMT1fb0QQdcW/V9KoIIsamO6ETf4535zJj9pMyAmPDCY720anT9/L8hQ20a12mJOFYKGsMFu0/b2P4ncP1v96cpla0I+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQKHBiWY9yhAwV/Ao5m17LgNyFfAFxeancV9ygdKQ54=;
 b=Knl/MHsx39lmYFQrimLM8MJsCEr+PgSO8IjjIPng4lqkD3gdC/38ou35uTmVZuZw9Jwejt/sQDIm70yO8qfUyWfMdNuZtBs4LLOdGiDB9HpcA8h2TJtJ0w9r20M3W5ZQmPrnJ5qGZ2+pe2K0pzvz8DNyXdk42oEPGBe2USrCrfU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB5669.namprd10.prod.outlook.com (2603:10b6:a03:3ec::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 16:44:50 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 16:44:50 +0000
Message-ID: <50afe378-c0e8-7914-377e-ae8c91f82455@oracle.com>
Date:   Wed, 15 Mar 2023 11:44:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 13/18] scsi: target: Fix multiple LUN_RESET handling
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-14-michael.christie@oracle.com>
 <20230315161301.GE1031@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230315161301.GE1031@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR06CA0081.namprd06.prod.outlook.com
 (2603:10b6:5:336::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|SJ0PR10MB5669:EE_
X-MS-Office365-Filtering-Correlation-Id: 7455c776-4647-4efc-0c0b-08db257497fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOkjrwXZzhBCIXT5zx3S4Z1VXmvkTEb+BnP0+QTThXAQL636+4A/ZJqa68PeovsrbV8GaoJZjjjEo6paqYEoBhWarYXjvSllxE4WpSXJwX0xBuoh62YvgAThTVAnuKmQUAWajWC0g64WzK+SI0Gj+FePs2T83x7S0TREcne58GcKttS2viTy6z1VW9UBTWi+Ld5JZL6I+9ASx9KjE8FncbQKrbh8o70zGvSbVfVUFaj7XM0qkLgCsIUS616EdK9WqmgisKlhe9w+LiZkflKoPeuxwArRKE7BIr7MUwQwyJ3U0P7d6/FbcqJ3IaSs5D5n9xAS+VM8V1K4znstWICYKIa3La820hDl/0DhKFS0WMl7YG5CLjJS+R+LgkWyoxdf4HalI9zHaropuzFr1JC/inMAUBA41xwlj1n8An9tOAK2yQa/Ady9LaNIpbscOS1vUjMPDAg4OyA4tfoQL7i+qdRop/uOxYHzRAkMafA8VsvMCd/Cj458F8LYMKTzb8DMTMV+onGfsE6qkxjt6QrbslTAc8PYdSktOfhQD5NAmAIL3GKqxP50OqCKOpa10QcIAKOaUZhBn2/XjmoFJA7rzZUCVxZU68NVwaedCHDFEYDSB2b+FITWcWxyMj+J3TrbEnxp6NVOrFJjxB+Uh2O0y3YrA3F0jut/pPrjM3lAiD8onmssTjn55an6DYKe6KPYJ5UHFx0AZoaQaLfI6yJEVzgwh7mAuP17Fk57b0kQN58=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199018)(83380400001)(2616005)(86362001)(5660300002)(38100700002)(31696002)(4326008)(8676002)(66476007)(6916009)(316002)(66556008)(66946007)(8936002)(2906002)(36756003)(41300700001)(6512007)(26005)(186003)(6506007)(53546011)(6486002)(478600001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWlVV28weXZtUUZ1SGVUcXV2eGRTd1NUQy81MG11cEhlQUNNdWw4NHN3a2NL?=
 =?utf-8?B?ZEFwM2E5NEFCU2dzdlZVNGh4N3F2bzROcnkyTEFwU1FWRnVSSWI2M1VDZ2ZQ?=
 =?utf-8?B?cTRJWllERjA5MFBOSVNGYUdnS2VOQkVRSm9KQUQ2ZmN6YXlVZG1EdHNqQWhv?=
 =?utf-8?B?eDh1dEZnV3lZUHpVUmNiVjJSMzZvSGpIb3FldWdOUzY3Nm43YlN4QkhHRng3?=
 =?utf-8?B?UlpTd3k4cWc4MzVINExYOUJYTzJFN1djd0VYMzhVTm9ZRzF0ZDA3WmNWaUI5?=
 =?utf-8?B?eW1NeE9DRCtUelR2Mlh5VXp1eE1KdWR3ZnI3dUNwTVBVQzVuRWxwaSsrWFNu?=
 =?utf-8?B?MlZDclp6T2MvelFVZURPcWlDaExibDhTRDVHb01BUUZvMDEwRXlOS0xBWEpJ?=
 =?utf-8?B?bVhTRUVMR2hIaDgwUlNMa1BCNWRvaURoNkVEVnZHWWFmUE4xUjVrdmViNlBn?=
 =?utf-8?B?OXVraTBuVVJnaVArQ0NpeFlSa2I1cTA4d1J0K3VtbjBXVWNwc1RnWk84NXUy?=
 =?utf-8?B?MGh6WmJ5YXZWVDQzSFBCWUJtNGxwQWFrbmZoMTVPWnJiMm4wVE5ENlhNaGFB?=
 =?utf-8?B?eWZwRGs1UXZpMngzYndESUoxY2dSUlZMQTQ3cG1wcmJCWU1MVmZ2TlRVRWJj?=
 =?utf-8?B?WllWUEplR1c1ZXFEaEQvY2dwUm9WZ0R0b2hoRUNnN01GVzJHOGJLakR1bkYy?=
 =?utf-8?B?TVE3cDZRY1BKak5JSmNVaG52dDJvWE4vNGJOY2srZ3FHM1Fmd1NVNTNMd1ln?=
 =?utf-8?B?TkpBay9wd00wdXVVZCs1djU1dVNDbkUzZFg5RzAzVWdBcW1DeEtyRmYycVpQ?=
 =?utf-8?B?alNRMkFBOU5GTEVzdzAyUDhjdjRicXpWKzcwWGxsOTVGbElxaE9kNE8valk4?=
 =?utf-8?B?TWFObVdka2dLWUU5a1hRT2NXMVoxa0JaengwVXRxd01yTHJ0Z3czWnl5aXFy?=
 =?utf-8?B?WUZWNlIxRGY5MDlVbHRsU2dDbDJzT3dBRXlwbGtzeDJiQWNvLzBEa0VQTk1C?=
 =?utf-8?B?dkZZZ2EzNEdqeTFCTVRqdTE0K3Vyekk4ek1yWkxYNldUZ3JJSHFXaVhpRWVH?=
 =?utf-8?B?MlloMkhKdlA3QUF5V3dwMUFIRnhPNHlYc2ZidERPaTR0SEtRZlIxQUpoZzE1?=
 =?utf-8?B?TnFPa01VZG1qNU5kbndBQ214aVM2Y2E4UndjZGpTazNHSUdic1I3eXZyTnN3?=
 =?utf-8?B?Q1hHYnArMENmK0dsdGVtVGFmNGJmUlNFakN6bzFiLzFpZGlrZ1VaLzY0T2py?=
 =?utf-8?B?b2FlM2Uxa3lCRnZHVW1FdGloa3QyL0IrdXAwZXVxUkc0dThISEUzZU1tR2dz?=
 =?utf-8?B?ZDhkdFlFdzNMVVg3cXU0MUNaM0RyOHJsQk1YNFZDL3NtMHU1b3M4T0pla1BF?=
 =?utf-8?B?Nk52UUVYZHc0bUdCODJLRHFhL04wMHBKNFRrbnVFVzd0TmZiWGp1RWpwYXp4?=
 =?utf-8?B?U0p2SXRtZFZycVdUc0NXNU4wRHhWMHBGdGdpSXMvMFpMbit1MnlPWlp2WkZL?=
 =?utf-8?B?K0NFQ3F5Rk5DRU5oSFpEa2IyUi9IL0ErR1Z0bTRlNmVSRUp0Z0JJUGVRUTFD?=
 =?utf-8?B?RTJhNWJjMWRJWlNic0dsZkVzamlKTVdFOUNxeTNINk51Q2RROWdDZ29tMk1n?=
 =?utf-8?B?MVRPY0JQS3llV2xkYm12K3E4bzI4N3QySVM5TTVtNUxPd2xOL1FhZ1o3RnBN?=
 =?utf-8?B?YjlLcmVFVjlrd1p6VTlUQmF3UEYzS3hoelZQMHZSNExnT05Ud2xET285dnNX?=
 =?utf-8?B?QVF6OEFJWmFoakltdUdnazdCZHVoNWZyM3luSU5QS016YlBrdWxlRDlFRDI2?=
 =?utf-8?B?ZFBTcGFtVldOTGVZK0ZOVFQzeXhXTEp4MWo1NFB2S2xJVzJmbVhSYVF6bk1q?=
 =?utf-8?B?UnhpakdWcnhkR1JaeFJQZjd6K014YWJJYmdWTTVJQWtoRm9HUXQ2TzVuMkhI?=
 =?utf-8?B?aHpybmxEaHRmU2lFQ2VsY3pKd08vak1QYmRFRkdqTEZkZEZxS0E2MStPeEtM?=
 =?utf-8?B?c0NrWVhpVlI0UDhqUFVYRzVGMldEVkVDMVUwRTVRSUU4QUJRVzhyNHYwNmR4?=
 =?utf-8?B?RjRhanRWZlRaSmkxejlvckpWZnJkdmVNL3diM25uUDhxL3RjRklybjZVb2hU?=
 =?utf-8?B?UFFyajlwb2F3bW5QVHNSQlhpRHVPYytvRjh2R0c5bHRydXptR1UyWGJ6dWRu?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: I9cYDM2k1bwoUU4oPH3i0p2hrWBABWiWh3UAoz614RsPi87+XUvptjY6XfjHOSUFnTUB0scDDaeQiettRL2XaDUtrq+YwyX/bodX+u17NAnu+IqHJtFw7eBwcFUxWZVRrC7ea33YG9PR2DpTC7bwUPXkR5W5JRuuVAbu0VcVu6ngEwqVzQ+7/ugUHqQ0ZSzo8aoOg4EnB1G2gkOB8a16Qk42EW7axD33MSfZwANRpO3NXFP1AQq39u33Ihue5Lm24oQOFa+CF8+TcHmk1YPODaqeezMabsEcRT+r7/jQiqsKMdctfbwpCEsqWmC9xyD5O92gvPjUY7CcYO/8Af5QQ4RVacHMlmauv4asB+2d3qkxqT/4W1yPfPRCo4WzNHpxWf1uJesOArAcaQNNtGeJaeOi3+ZMmYzB/69o9l3EObaXtlT4Ll/TbQrdjxbgZrT+8GkvDO3rewEB97mkVRyOxUYf8a/ECYyfS3Bdoy1hvZ7I+Pfa55v5hCqudE45iBmJDNQv2Phxu9jGpbW9iUnZWuDRD69+9PDQH9WlUhN2jiBhDtQ3MC2DyDmZHC9L/nwSHhk40GzV3D3UuacUFbZZBxf9u0nbtXyiRQURSsJK5bRMM6kqrMiQeyXxDrRa5iSVxl3/Sj3HEfl/xsCmgc++AKwFTl31naICVT+eiCQguQou+mK/gHSxg3oCxsxl7oSvngrVgy0zImn2KzaDU4xjhoPWmo88vHLw0pDb2+B/XEIabWsg8ZMnFMCx7LsvmoijHrFVYcSSv95EHI//BgjpKlawzevDxasqmC05umxqiGUZvCl5V7SV7asrIxgCUt3jhZ/7KdtM65EwkbRt5aELdkohXa9ZAyCrbD5Z97GiC1EaDoNAgmMiCL8tn2n9+l5u
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7455c776-4647-4efc-0c0b-08db257497fe
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 16:44:50.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLBNgrx7nSMOEE850jEFP7VTyd7DHTe6oUMGe4mTsnbzs+IvvsmKUReoquh1oLthNisdplYU+RR+p5A1ayfrHU7QGj123wjQOxUPZQPCA/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2302240000 definitions=main-2303150140
X-Proofpoint-ORIG-GUID: 29T6pw-FV7W7McmPmN0_Isy4fS3OzDcZ
X-Proofpoint-GUID: 29T6pw-FV7W7McmPmN0_Isy4fS3OzDcZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 11:13 AM, Dmitry Bogdanov wrote:
> On Thu, Mar 09, 2023 at 04:33:07PM -0600, Mike Christie wrote:
>> «Внимание! Данное письмо от внешнего адресата!»
>>
>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
>> up running commands when it hasn't. The bug was added in:
>>
>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
>>
>> The problem occurs when:
>>
>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
>> 2. The initiator sends a LUN_RESET for each session.
>> 3. session1's LUN_RESET loops over all the running commands from both
>> sessions and moves them to its local drain_task_list.
>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
>> the commit above has it remove itself. session2 also does not see any
>> commands since the other reset moved them off the state lists.
>> 5. sessions2's LUN_RESET will then complete with a successful response.
>> 6. sessions2's inititor believes the running commands on its session are
>> now cleaned up due to the successful response and cleans up the running
>> commands from its side. It then restarts them.
>> 7. The commands do eventually complete on the backend and the target
>> starts to return aborted task statuses for them. The initiator will
>> either throw a invalid ITT error or might accidentally lookup a new task
>> if the ITT has been reallocated already.
>>
>> This fixes the bug by reverting the patch, and also serializes the
>> execution of LUN_RESETs and Preempt and Aborts. The latter is necessary
>> because it turns out the commit accidentally fixed a bug where if there
>> are 2 LUN RESETs executing they can see each other on the dev_tmr_list,
>> put the other one on their local drain list, then end up waiting on each
>> other resulting in a deadlock.
> 
> If LUN_RESET is not in TMR list anymore there is no need to serialize
> core_tmr_drain_tmr_list.

Ah shoot yeah I miswrote that. I meant I needed the serialization for my
bug not yours.


>>
>>         if (cmd->transport_state & CMD_T_ABORTED)
>> @@ -3596,6 +3597,22 @@ static void target_tmr_work(struct work_struct *work)
>>                         target_dev_ua_allocate(dev, 0x29,
>>                                                ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
>>                 }
>> +
>> +               /*
>> +                * If this is the last reset the device can be freed after we
>> +                * run transport_cmd_check_stop_to_fabric. Figure out if there
>> +                * are other resets that need to be scheduled while we know we
>> +                * have a refcount on the device.
>> +                */
>> +               spin_lock_irq(&dev->se_tmr_lock);
> 
> tmr->tmr_list is removed from the list in the very end of se_cmd lifecycle
> so any number of LUN_RESETs can be in lun_reset_tmr_list. And all of them 
> can be finished but not yet removed from the list. 

Don't we remove it from the list a little later in this function when
we call transport_lun_remove_cmd?

>  
> You may delete lun_reset here with nulling tmr->tmr_dev:
> +			list_del_init(&cmd->se_tmr_req->tmr_list);
> +			cmd->se_tmr_req->tmr_dev = NULL;
> 
> Then the check below will be just 
> +			if (!list_empty(dev->lun_reset_tmr_list))

I could go either way on this. Normally it's best to just have the one
place where we handle something like the deletion and clearing. If I'm
correct then it's already done a little later in this function so we
are ok.

On the other hand, yeah my test is kind of gross.


>>
>> +       spin_lock_irqsave(&dev->se_tmr_lock, flags);
>> +       if (cmd->se_tmr_req->function == TMR_LUN_RESET) {
>> +               /*
>> +                * We only allow one reset to execute at a time to prevent
>> +                * one reset waiting on another, and to make sure one reset
>> +                * does not claim all the cmds causing the other reset to
>> +                * return early.
>> +                */
>> +               if (dev->dev_flags & DF_RESETTING_LUN) {
>> +                       spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
>> +                       goto done;
>> +               }
>> +
>> +               dev->dev_flags |= DF_RESETTING_LUN;
> 
> Not good choise of flag variable. It is used at configuration time and
> not under a lock. Configfs file dev/alias can be changed in any time
> and could race with LUN_RESET.

I didn't see any places where one place can overwrite other flags. Are
you just saying in general it could happen. If so, would you also not
want dev->transport_flags to be used then?
