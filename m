Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5F9C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351641AbiEDPEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351649AbiEDPEW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:04:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD02103D;
        Wed,  4 May 2022 08:00:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244DAPfM003197;
        Wed, 4 May 2022 15:00:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KBkDBF6MH/5vrAcckJyokHTPd2999MTk0ikTihH1qyc=;
 b=HmI9mddrY6Ac2jEfeBs1ji1crDJnDAEFGsHQ0+/h8X88QIlG6bDuiJrPRrW6gBr1KDfq
 2b1+H3AMTRmMUkqIVUebozV4SBZNWewmhN9G0qy78n2Prb+zg0StIM/ZSBc6WBP5zDrA
 H+8sPRbx9wncL2zDKdorDMPO1jl6PqmiX97J8C3epuzQN80i0YCzc7MroGxmZzjPMt8o
 X027Br4d4v+Dd05PmM85Q+9ZjwLK1J26WZbIVYy/umSqyy0cc0BB2sqSQdwM6rPMxsKK
 y/H7uHXfmK5E/ndUwZ4Sx/zm1oTD26/AsKWn7PTQvFASghbS3YO0qoZPV+zAsaM3ozyV 9A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frw0arg2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:00:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 244Essi2036259;
        Wed, 4 May 2022 15:00:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj9khr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MjZXQjUN2rnLloXpKSoa5ia0VrDEDb/GMGuHxwWGJpYIbk9SMkj/Wz9GSialm3+f4NAa2w1d6MJJVqd6AzPwQb4rXgCDFiNwCXGsH7+16O0y7YoE973WJIOtcMIXrywzFyJSaAhpM3v+yw7z3bxL7iseYLmXkn4A7jwKsXg4YXIb323/OdwPhPEZYUhIIuUzTcfvaQ22JYHAidPeZQkBcRBGrr0A6nhQAKRk1rtD7CkDzcos9nRPwzT5LlbDqK26IXBtczklR24OqE+D/4WyiioLMXmqp5+YXcN9NNRCf39GdAK1CZEGtihIK9IBGxIxk730W5uJIZtz5TP59/pwHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBkDBF6MH/5vrAcckJyokHTPd2999MTk0ikTihH1qyc=;
 b=l/74/hiKVQcI/SwmdkXvDRRaIk6CrajA8ZTb272FbBEuA3MYrgv/XSzFjj9kJ5E3R6VwZOUaS22/PTuGMXgwQrPXjf8IH9IOXAMrnShbq4cG81UoGXg5uNrPmrZT+GlnG+U6533Qd+qwQAiFecHm62ljs55/QbdJWTSjheKcTtE4cI3X7fNMI5j+yIh6wfuVQSxenyA0ryU1WkHfcgLufxyGgixXbr+3+ujaqw99Jy3hM7QfoK52WDNlow4QlUzZ9D1DBz9a0CZc3O4sHPmFoJK2VuDF5ZLf5iNJCTVmcWxuXfx6lb/NNZoEvxDeY0g4/lL955UkUhqS1RGOXCRePw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBkDBF6MH/5vrAcckJyokHTPd2999MTk0ikTihH1qyc=;
 b=ozJ8rwYwGDinQgaK5bLGw+jleH7zY6q+5RmzJOTZ0hRThAoGv5NVxOlZkrAFnqPFjYtgxoa7zzTTqBIbxIdd1HVsZqlfM6bS22TJptLkRNaqp1bu+xEmZ+JlFa0gFeUKVkUpjAtBiwuUId5mmWQ2lr3MBbTuotxSSNpyt/Pv8/I=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5056.namprd10.prod.outlook.com (2603:10b6:5:3aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.12; Wed, 4 May 2022 15:00:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.028; Wed, 4 May 2022
 15:00:31 +0000
Message-ID: <b330fbf7-41b4-6a67-38c4-eea514ebfadb@oracle.com>
Date:   Wed, 4 May 2022 08:00:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 1/3] target/iscsi: rename iscsi_cmd to iscsit_cmd
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, martin.petersen@oracle.com
Cc:     hch@lst.de, sagi@grimberg.me
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220428092939.36768-1-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0099.namprd05.prod.outlook.com
 (2603:10b6:803:42::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18ce5c28-53be-48aa-d694-08da2dded589
X-MS-TrafficTypeDiagnostic: DS7PR10MB5056:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB5056DC63A4621942EB57E882F1C39@DS7PR10MB5056.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDx4TwQ5bOJzNfoXoHBT4c87mTcQ2ukPnGEeEehON1F/k05gROkQOYg7Rg0k7jTLUN63MvQ75JmhEcqoS8SjKXAqlf/BBhEKRnp+82Z5/fygn20RzNKjFIQvVEbWXllyJF1DdNM95Ap/Bndf5QdevoDyZrai6beo7geT4VekPh16a1colVrtPjoxRVP01z6Vp7NK3mZDod3CftqEuzOgYTj0sMMrsHKib4bBbTA5KcjLPrkLUhV0jJfyOUPuZdbfpJ24afE1QdEbYDNVKLm/pSazZ29uRYbg1O58IFl5pwG2qoBWQfzMSo9lD40y6191FT4SfSDK0x9VoEb+DmQgtGOCUK69HdBWFcXdG6yKzQ+573f8VB3Ra2/XUTB+F7mzvePDPHm55LXMvktWHCIoRLDwtsjLvYjIr+SdOjMz/uJxvtTXNRNzxmf3wOQl7SO0E4ry+kPs0w+ygTjDfEs70oFu9dE9XQIinZJYxyvTQeZ8GFFxlIakYBKWleyvNtPc2lEvzvOKrXPgOq5o9+sjiecgSVg4cDnmyM4bXDyHp1yTXxTMSjCdYt82fbrpzroQJ3J6UqXMzyY4elAbs4ylNymHLVdVq1ySDle9QxyHPhA2J96uNGRzQBIQVDprQo4si0PQS+JeD4weQzBd0mRK4wDbBm58gsxH/vKeqIkdEwa6xp1lelKxPvh+vLbKZ5gGrCDh+kXFPysGMwUT3kvPQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(9686003)(36756003)(83380400001)(31686004)(186003)(6486002)(4326008)(5660300002)(508600001)(86362001)(2906002)(8936002)(66476007)(31696002)(53546011)(66556008)(2616005)(66946007)(8676002)(6506007)(6512007)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2JkcXkram5yNXN3Vlh6TFNIYzNQeTYrdFcvUnJSU1NUY0tEZTVSVElUdjRJ?=
 =?utf-8?B?SjRBdU1sdTFKakROQk5ocnVmUHFkaUJQWDM3WnI0QUl3U01UU05ySURJVGkv?=
 =?utf-8?B?UWpWenk1Z2ZrcHpTcTljUGJaUjRtOFVUK2V6bzNCWFZFeU54Z0RxVS9zQURX?=
 =?utf-8?B?QUQ2SzFZT2pNblo0dmlUSVg5cHlPYUhsZ3JiT0MrbU9wOEwxbUdDS3JOOW1w?=
 =?utf-8?B?SVRJbjhLY2gxOG14MU1odGljcHRFWW5OQ0daRzljQXNlc1UraER2Wm9WZkVp?=
 =?utf-8?B?QXVpMmlpMThoUEphSTZrOFFzQWplQ2lkVVNkMVZCR01maXpWZnJ0SnpHRWdx?=
 =?utf-8?B?ZVR3aXNTMkJWeEZaUHdQQzdYUm4wNXNpc1JWcENabjV4MmQ1S2dRcWxtZkNy?=
 =?utf-8?B?MjdCM0YvS3Vicnhac1l4a0dHREF4Q3VTRkJUNkV5QzducGJOc3Y2endST2FD?=
 =?utf-8?B?YlNXVzF6K0Z1Qzcrc1VLWHZPM3IvZVltUm43aks2WUFIK2hTMy8zcUdJaFJi?=
 =?utf-8?B?aThLRDl5VzVSckwva2hNTHROMUc2SW0zdXNtMXRRZHZ5VnVnUkFxYkZHNklM?=
 =?utf-8?B?NlhhaWM4bEM1K3lPVC9ERFkxWkNZYWJlUXZTUExkcVJ3Y1Q4V0hpN01ES28v?=
 =?utf-8?B?a29LL1gxN2RjMVBLRHR0V3hjN2g3ckJVVUx0LzFWQ2dMWW5oOTZlT0s1L0NE?=
 =?utf-8?B?bnNIajR3VVFGbmxzQzdzUUlXY0RKQU11Z2hqdXluM3JIdUdBU3BsWWRXcjNC?=
 =?utf-8?B?K0t1M0pJaXhnOXlvcVE3ZUNEdEg5dS9LMGtheU9WNFgwK3FHZHBscDh4aDRl?=
 =?utf-8?B?Vmc5azM4QjBOVHZsdFJxOEhrNVB5NC8rREpVSHpoSkc2aVdKbEFxRFQ5blZ6?=
 =?utf-8?B?VGFwTTFnQ2lXVVUrY014ZTdDS2p5TFZKWEpDWHZzWnBhZWd2Y2NSb3hxcll4?=
 =?utf-8?B?d09RNTBLTWsxZitBKzVjSlFzZnJselZXMkp6M3JlYXg5aUMzd0tPbjJPUDFN?=
 =?utf-8?B?VFRWR0M4WHcyUXBCejd5WWRXcTBSNDRZRWF3TXgveDNtdFdFTEpKeERiWUtN?=
 =?utf-8?B?TjJCOUdNTld0TE8vZmpzbE1BU1d2a1IwVVBuSDdZQ1V0T2xXQkx1T2RKcnNI?=
 =?utf-8?B?YkJHVmowaGR6YXNadkhmU3BGUUQydjNGSks2bldMZE1sRkNyc05NU3E2ZjR0?=
 =?utf-8?B?Rksyei9JVnM1TjhEL2Y3VS9OamZONWhkNE1SY0pCdzhkdXlaSktxY0VDenJF?=
 =?utf-8?B?ZmRKNXYzbVp4TkZUQlhkZlhGTU9COFFiSWFLQmlhdTBwSHIyMUFkaXF0Q0ZY?=
 =?utf-8?B?d1VINFRLTlFvTGdLcXNGSHNHWllGTldwMWdJdHl4TzM2YzhqL0dzckdJRy9I?=
 =?utf-8?B?ckloNnMvdzc2YWhCTE5LUjNOaU9QV1RiOFB5MkU3azlmNGRQb0hIc0tyaHoz?=
 =?utf-8?B?OVpoZDdvL1VtR0ZVUjF2UHE3VXRIejdRRGtiY2pyajNad3FkN2NwV0NWeXhP?=
 =?utf-8?B?R0RRUlYxVTUzMHZhOStnY3Q1ZldFa2x3aURQTWNwZzI3anpKRUM3WERpaEJQ?=
 =?utf-8?B?VHppeVJqaDAxS3ZsVjE0Q1pFWVRxYmNyUkdsdTVDcGlCN2hSRmEyTlRKSytM?=
 =?utf-8?B?ZFFvcGhBaWZRRENXS0g1bDU3Vml1N2Yxd1YvMXpobXA4d2QxZUNoVWtiY05v?=
 =?utf-8?B?dU9KWXJPYU9kQWNZTkQ2QUd6bTdHUTE0TFlaT0oxazRQMHV0R1MzUS9RSVow?=
 =?utf-8?B?UTJXMTV1MGVrOU1wc2UyWXJ0akl2N1NWVXBpMkp5bUs0VlE1dDdmZG0yZEJM?=
 =?utf-8?B?dGxFRS84VmRheGlQQ2NCNmwreVJYb05GRWdIMFJ2ZTRTL3BDUi9sZVFlam9n?=
 =?utf-8?B?UmlXcUNxeW5UOFJyeGFnOWtKVzcxSUhzaEptQ0Y2T0pvcVlrRU10M1VzckVa?=
 =?utf-8?B?bFdxaUtkWWlGc3BXbzhDVjJMOVBiQW5pZGVkemNSVUxaRlF4ODlORHpxN1hy?=
 =?utf-8?B?N2E1VkwxVWVJL0FPK1ZNT1Y1VlAvVmw2RXJuY0JwRXZiUzVBV21mMkhyUnA2?=
 =?utf-8?B?bUs0bHJOcW00N0dDMW5jL2I4YThSdUs4M3Q1REpsQ2FWdUxNZnZzNlpKdjZa?=
 =?utf-8?B?WE81SzE2VTlSQ1h4TUErT3lQUkxvVzJCWFBuZzdHenlQTEdQNC85Q1FIMnRP?=
 =?utf-8?B?ZElDYlkva21PNTV0aXNrUUMzQUFUMHgxdjBOdnlIMnkwUmthMHYrbU80Nk03?=
 =?utf-8?B?Mmc2SDZUYW1BOUplZ05rZ3lWUm9tbG5CMWxsa1AzNlZaOUtPNHBuSHc3ek1Y?=
 =?utf-8?B?SlQvcEJ6S01Vekc1dkJZWFRCYUFsM3hjU1drTWUvdlhuMDJ1Z0wxQStJeHNZ?=
 =?utf-8?Q?ci8VaTtdTV5iCztU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ce5c28-53be-48aa-d694-08da2dded589
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 15:00:31.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3m3iq+vbGz8MPI0gRHuxHHSCz5QCYWlViaFP3WHcuPHMyI1by/F5X40j4D3EFSIOGpxfXGHdZ4dCIQZJbRNzPnQUQTRdd1TGRiFvB3vDVIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5056
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_04:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205040095
X-Proofpoint-GUID: 9F20w7lOagtJhGsj9nMQdkptI2DZWRQW
X-Proofpoint-ORIG-GUID: 9F20w7lOagtJhGsj9nMQdkptI2DZWRQW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 2:29 AM, Max Gurtovoy wrote:
> The structure iscsi_cmd naming is used by the iscsi initiator driver.
> Rename the target cmd to iscsit_cmd to have more readable code.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c       |  64 ++++----
>  drivers/infiniband/ulp/isert/ib_isert.h       |   2 +-
>  drivers/target/iscsi/cxgbit/cxgbit.h          |   8 +-
>  drivers/target/iscsi/cxgbit/cxgbit_ddp.c      |   4 +-
>  drivers/target/iscsi/cxgbit/cxgbit_target.c   |  34 ++--
>  drivers/target/iscsi/iscsi_target.c           | 150 +++++++++---------
>  drivers/target/iscsi/iscsi_target.h           |  14 +-
>  drivers/target/iscsi/iscsi_target_configfs.c  |  14 +-
>  .../target/iscsi/iscsi_target_datain_values.c |  18 +--
>  .../target/iscsi/iscsi_target_datain_values.h |  12 +-
>  drivers/target/iscsi/iscsi_target_device.c    |   2 +-
>  drivers/target/iscsi/iscsi_target_device.h    |   4 +-
>  drivers/target/iscsi/iscsi_target_erl0.c      |  30 ++--
>  drivers/target/iscsi/iscsi_target_erl0.h      |   8 +-
>  drivers/target/iscsi/iscsi_target_erl1.c      |  42 ++---
>  drivers/target/iscsi/iscsi_target_erl1.h      |  20 +--
>  drivers/target/iscsi/iscsi_target_erl2.c      |  20 +--
>  drivers/target/iscsi/iscsi_target_erl2.h      |   8 +-
>  drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
>  .../target/iscsi/iscsi_target_seq_pdu_list.c  |  34 ++--
>  .../target/iscsi/iscsi_target_seq_pdu_list.h  |  10 +-
>  drivers/target/iscsi/iscsi_target_tmr.c       |  38 ++---
>  drivers/target/iscsi/iscsi_target_tmr.h       |   8 +-
>  drivers/target/iscsi/iscsi_target_util.c      |  66 ++++----
>  drivers/target/iscsi/iscsi_target_util.h      |  48 +++---
>  include/target/iscsi/iscsi_target_core.h      |  34 ++--
>  include/target/iscsi/iscsi_transport.h        |  92 +++++------
>  27 files changed, 393 insertions(+), 393 deletions(-)


Reviewed-by: Mike Christie <michael.christie@oracle.com>
