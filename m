Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB5C5CD68E2
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Oct 2023 01:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379395AbjJJBoY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Oct 2023 21:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379389AbjJJBoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Oct 2023 21:44:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA7FB7;
        Mon,  9 Oct 2023 18:44:18 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 399Nwrs2010957;
        Tue, 10 Oct 2023 01:43:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=dRl7v8/cMmYSh8epSYlicwGdKllvqzKRkCal0vxvbWk=;
 b=KWh3Jlz49flwkj6WXp4NNfdoT9ZnhKYOhSoUVFLQ6X187eDW5vsakwYUDUg3GAkcsSVM
 ruVCJVFMWEX6JU5cLxwmIICIvyGoSICEGhIhwz1uKRarRtGMu2tUO3yW2p+aqkZKso3+
 DXsDy1/XEvpKxONzGKKd+Ngzw79kG4B4ygHTNrwV1Ezm1DRQkA4If52j1pT8dJpoce8E
 4JpJGDnMmd3WyD4dBgI6tvDnTVwm84cgUS6KK71miGRq71K5dT6fQM3E/yiALM7FvV+w
 s90fKn5gJRBv78OTR7Zrvo8taMMlPyFYRuDkGFuwXtilRqMgFSDCTkBvHa0EGVAEnlPn Og== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxu3xyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:43:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39A1XYPB004652;
        Tue, 10 Oct 2023 01:43:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tjws5ssv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Oct 2023 01:43:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+RPjrespgxTabgqfQ3uWdcQ2BQdMM4zomM01KQ//fwXn2KZ2ilk96JZ1ge8XvWFgZD08tP7TMlTLlf8p8NxKCR2czJVtBsX3i2xZpENrMy+vanZjRrpGbqXmg8XBP/gMAGiq6JrgWqmjCP5D8nEMc8MD+6V/v3OtD+OQNFjZe5mZoE0ur+qXU63AmS89JfXK9Z8t0HW2ZDShvIAc2MLAOVdHj9WXILg5AYHMWYi5o9fVW3MxSJvBpcfG2o1VbOPx4mEaxvqMtvX8GoF0AswW5EmRPDY1/AsJ1fcsHPDQmJN3G6nnc3GEWO+pKbcihuluLzFRguI5PdGWg12EySZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRl7v8/cMmYSh8epSYlicwGdKllvqzKRkCal0vxvbWk=;
 b=Denv210bZC078hn9A6lyjqktNpSr8rhUL0kYdQXV+jB3ds8UaeIAOk5fG3KXFahkQmCB80oKH45YJaytdR6E23Y8ON8okdQInnwlHUzTQyjubMDv3Ni6A/uUrsHBQ2vshbZdPAgDSTtsSQDr4M3DfJf7hlyokSwrw/2gKwrbPiNIn1O57RtR/ydCvb+gv8/yqBZObQElF4ovUJ9rgyNbi3sG7zcv8aJ6WiTjMDHf4SgkH2tn06Qgm1DuoMyiRYZQN0/zMevNY8nVDQCoMcvFtTu4Y4FK7NE76MGDzgjrImsrghPpxCsTeGaeB66DIWa0Kr5XTrUS2nZ/Z8QjM0KvwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRl7v8/cMmYSh8epSYlicwGdKllvqzKRkCal0vxvbWk=;
 b=qeVsujQj7y4aeWRm/cgUhvK/COcXqhR46Zx4lw5mn/sTze2VLCvxxTsXmEMXF0XkbvKaTjjWBsvFu1wFNxQzgT6om5zGnWUHaR+UMLgWB2HUgIxxz10YmczhK5KnCS6vId2LfQAETGqieUm2qWUNCOAo6gWF3AUW8aFfBRg7u8Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB6190.namprd10.prod.outlook.com (2603:10b6:930:32::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Tue, 10 Oct
 2023 01:43:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.032; Tue, 10 Oct 2023
 01:43:45 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] scsi: Do not rescan devices with a suspended queue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0m3ntk8.fsf@ca-mkp.ca.oracle.com>
References: <20231004085803.130722-1-dlemoal@kernel.org>
        <20231009081736.28ddb5fe@meshulam.tesarici.cz>
        <c05ba025-48f3-4c76-b4db-bceeff5d4f03@kernel.org>
Date:   Mon, 09 Oct 2023 21:43:42 -0400
In-Reply-To: <c05ba025-48f3-4c76-b4db-bceeff5d4f03@kernel.org> (Damien Le
        Moal's message of "Tue, 10 Oct 2023 07:36:01 +0900")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: 61efab73-db46-49c5-f1ac-08dbc932572f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gCMIM8IZmXKA6239RkS2Uw3WfsVHYA0pRj6Y++80rWbp0oy3nSIRQPeg7pGgUzMJp0R/tpchqZC43iq09GyCbpFE2Q+sZ5haS1LvYkuEbuRexhdu8S4Axi0Xrz2mOXnQy3dNEucmReXw6tbgUU2aWbiqdUmP/+4rxgDjSQ5YUy06HoGFwHEi6sXW6qCIAo7CCk0blCCjhnfYDRVh/jYMuh/rIYn11NKJqwFEuubYTCkcEPL1hm73Ryfd92rPMKR8GtzxozP7lIFgf0frIbSqf6g6eWY3rH2lFeahI0Cln18BkjDMMat9L9Sjz32Vm3/1+SC8m+VCuKVDq8ETDvqoiY0Jpzz2Vse3+wwiOBqqbBdPQGfGUyyEIW7kLRcNTUu+Zyj1nzxKMnmBa+H9BdRcSEEAmFR/kCexZUbePfbcdOHloZ1ect8cOSqiljpgSpwMNOTYWwTlLnMXGbp/qt3IbGWx5L86p+5bfvihuMwHeocBvgrm/TtR6phv3NdVMuIw2A1tLQrOrpR2o00S4tfq2u5kCAvqcEjUUj0H5BLyVv2rFJhBTFTjuRKlhjdr0Dcm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(376002)(39860400002)(136003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(6512007)(36916002)(38100700002)(86362001)(26005)(2906002)(4744005)(6486002)(6666004)(6506007)(478600001)(4326008)(8676002)(8936002)(41300700001)(316002)(5660300002)(6916009)(66476007)(66946007)(66556008)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WpPMkKzI9LubgHNTHv1Sh6Y7/hPJzUwT1aCUcvmasHncCxhfFY84MpIu6wSs?=
 =?us-ascii?Q?5EnWZvah3jHQBm764WworlpBOysCVrioCC5KwBwkpEBU1N9S3Tb+1rK0Uver?=
 =?us-ascii?Q?8Eej2l89RRiSiW0J0YMHl4MEWR8jTYJ2Y76ZDGbojuvN7WV4WwXdui37XMwO?=
 =?us-ascii?Q?2uVLhsVxyuZPL5ZsmbblAngEhEnTJsvNENIuMUhIP3CVuZpvI6vYJc7KayI1?=
 =?us-ascii?Q?a/lUT0YTkjC0BODHDXE/w/rQsCeK/Vpfepjk2bU5acHunw7DpPiNmJVf+x5i?=
 =?us-ascii?Q?ggCjr1XDkLO+LeNPvRuiRgpJHsQ6hq5mT3Fbx7G/FKEsmYKmST/mAmBbeFUi?=
 =?us-ascii?Q?D+cePz/RWIZkhzfvfLdTsNdL7tkDoK2s6zUhyrmkn+AHSUoFwbIIG3B2+dPw?=
 =?us-ascii?Q?FXhJ/ZqQUcMB1+bFzGqMwl1u3+yNcn1CfnP7zmXOBxgtolKg9G9WyT5ZELqS?=
 =?us-ascii?Q?j1wjOm+bk2osOl+UeSysiKfKcuIZ5b8jKc8Yaz4BJfDYnFRIsIPHH1SMrr9Z?=
 =?us-ascii?Q?BN7m0NGR9bLKJYhWt2dYYxOCLcaYYHTxfPvMe4DPWdDUEzfsjJ8qR3iRTpoo?=
 =?us-ascii?Q?IqmIn80rHiQ7yWk6nGYgWRT5e321yqqfwFqmKuDedzBQmWoZvDSbDYkaBQxw?=
 =?us-ascii?Q?DFck2lbc0ZmhD5a049emfZU4FM3Fsrzeuzrootl4uSadIBnI0QVogb62avab?=
 =?us-ascii?Q?Y7vLXjq7Duz8QvZmSFKzzndKCgP4g8pvMMpgP1Se4P27/ckfpYd+V7l9m/5q?=
 =?us-ascii?Q?DzofdnCaC0H26bSNIyMTAc9Ndv0Tojcac5GBF/IjXEerMyIqU16gxsP0SVpa?=
 =?us-ascii?Q?kgj2CmYlCR6D4Gd3PYFUIDIMwNJi9irlLeA6s4Jur2RTt33PQrYuDQUq8uba?=
 =?us-ascii?Q?upbZtOodj/m28ExvwdZWX/c1P3iO1qfNOkA88+GFgoQAUFaNIu9+ja+BkLb4?=
 =?us-ascii?Q?Ebxv/P1v65EYXpXN/mKPVqqUKBNur9EQpmR+FZZeDiAZUtDk3hlli2nTbtTt?=
 =?us-ascii?Q?x5g/4eA8VagYn1PoXNRvXgg4Qd+swow5oHjl6wKiO+1esF8tzk+rlcLDHcMK?=
 =?us-ascii?Q?9ZfNLXSpivLHmJs2ZYO3cwwSm6bDdyY+MTYDOL8sfrFcXt9OmdflvimRnit8?=
 =?us-ascii?Q?EixZIfcXhlgQ1cjvcMorXewsF3CD+aiRmZM7Uy3hDUp41mlgAHUNPwlsl78C?=
 =?us-ascii?Q?QSgqkCJsdwRlU5p3iean0g59+wCoz3TuRjP0ld8LfUA5TkyZ7SfGT11Gc6NV?=
 =?us-ascii?Q?X9FQDQ0mvqfXXh0mP+rvxfPpwOe/vu48pnVNnZ8OfiSsBgUThdO1P4ZoqXM/?=
 =?us-ascii?Q?IzazEyLVpo6B32p9vE02zzcrkAMwmyhGoJbxMk0KDVSCx6P6sASJbDhOVp9K?=
 =?us-ascii?Q?pq0R4eW0FHqgo8/GG7N9pC8Gn9wQ7tMfuGlRp57Z4w3/i2+OmqB5T0Vk1thO?=
 =?us-ascii?Q?02j4eZidHJ9MkU4DeBOM4ZMv8dwQ5ASF0NIpXxRrL/5LmNySRyt5xx3K+B+W?=
 =?us-ascii?Q?Ol19sZ/kPD2cr/j9Ro4ni70O6W8pfhHh4fgZPENtRuOwwplEvfDgL96GWLQA?=
 =?us-ascii?Q?LuscRHHNbHqN+8I/KK8GEBM2kg5qqYZttRSibX9qfego9yKraO7kLQsSnBWK?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: b1XH8c80AI3Yat1TxOGpA8FwxjQ3FrsHRmbHWzgYt4XzmCZaiBV0JJ+dRMz6LtCRQlzxgRp8Nh3DSxLl1nRMCTDHsHHdeqPnYzZucEYCaRT2ZkVQJgW7zgzqohoCuRdPkhVcAvJGm/iwc9gf5YePkZ7TAvzvLXStZzxlKJ89XDQyDqknkhryuF5Xkn8/WbpdlyKFfschqIIlyAHiqOGqCwIisLDlHD6akHrgWpt2/bShlITcKnJyMgosylHQ0JXU4OhpESwwFcVeAsu7+OidP/A8QrurfnCw4nn3HU35UhZPJiDiu+YbzB0SW3Ztlh0+jnOhiMMAytgQ5gqnHziHtprCZuQWiBnf3pTBpJM10bZMTH3Mh0R2bWgEmxOXkL9mpQKjy1OdpDOWDZRadpl86lINc2GCUNVnNZnH6O7qfA3X7xSDZqKWaH6G38S/rGdKE5WFqM43Wh9zu9yhjwkvRzvpaaoyxAi4QQWlppC9lShgMVPna3t9nCYGZX+muML7R1GGQQsVksjhlKjWNddcIN74c0NM7KnVCjs203e/VhR5aML149wHBvJYb8qd5cXjq37mFOzO73Jamqs2Fuo/13pzBZnIt/5Xsq/2msvTnez3Z7Jt33ZmdBkD22tBjHPhmL3kSQB3IKpZuqm7tqgogOwBnbvsWc18oHKdhAz6jrzmzWR6aE5Dd28X3kJh67rMXCtUZQVOGF/Tumfn3zTJAEhOefXtxEEvqAK3b/bUdFkd9l8bcBxo4M6vrI8x+D+pXBYO/ZzPIneBL7LBeyoNbxcvDqksPcVV1n1NXr5Kqga+Nejd92iFfkYpVcJUcuwdrfEMtuV8eG5Yjw5nOiCPDqkofhEBpPiX1ADN1yjkIK0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61efab73-db46-49c5-f1ac-08dbc932572f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 01:43:45.3091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vdp+vL4Q0wDHVMNP4CHmXDuAwfdzpRQlo8ve2X9drotkCxda/1l8mhzW0lSRW97/3eZrvnBx9AxOsWfGxXhrOhFKOhg9f+zo2wiN3sxHm+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6190
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-10_01,2023-10-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=871 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310100011
X-Proofpoint-GUID: Z36GBAovqCkVTmq6AT7tjfrpEDbd9K2e
X-Proofpoint-ORIG-GUID: Z36GBAovqCkVTmq6AT7tjfrpEDbd9K2e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

>> FTR this fix is still needed for rc5. Is there any chance it goes
>> into fixes before v6.6 is final?
>
> The patch is on the scsi list, not for libata. Martin will likely
> apply it this week.

Patch looks good to me but I can't apply since the PM rework series went
through your tree. My fixes branch is based on -rc1. So I'd prefer for
you to take it.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
