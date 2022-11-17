Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49E4C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiKQSMP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiKQSMJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:12:09 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271BB6BDDC
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:12:06 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHGxSoR019516;
        Thu, 17 Nov 2022 18:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ap3lO8j3xy3CL02/HlcW1RvkhrXL3377yB1/Kcthq80=;
 b=y6famdMx9hQzrRGx5vvqBnb2kq9jMb+QXg2xP4hzZulM1GNqgN0Odez5MMzB1HJeurs3
 ETuy4CXYgrSarcGswKvYJhBa8KRYodeRkaCflchBRLqUgLilWPOIsmrkwr9wQn55HUYW
 eMxs2wBMU0A0QNeoqp0rty4nznDU1imyFIjg/kv7eeK8yF18DYJY4D48g195eUpOxEb7
 N6Nf7/3NLwkl2Pp4DPoh8vzgQiqngidUrXWvw9ItXfKvr/IK4yycc7g5K6qY0rJmj77r
 E0z6CYfw103lKmLNHuktfQUv3GB1UFAZtkOXTEUKIlmoFF3MVfZigSwjUTMYFrNiVNVK fg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kwryb87ju-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:11:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHHfVm034325;
        Thu, 17 Nov 2022 18:11:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kw2ddwmfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:11:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkJazxURZszRDWMNH2lF41FysDrX9q3S2Vc4/waCqn99iX13VQeDy/d2+/PO3KkuV8SBRACS8p7j1Tq3gAuyiKfcu8o1dJNdaAHpvnbqY6MUsaGxET3uRNm2l+BdrKcycfrwcuP5WJpgna/m9I5G7V6W1a6BsIWhFh8xq6EpO0UquGZ2xApP9wWQ0aFIfS08abw1xRW87QDhJxhp3ufN5NARnAa2+yGQSgwFBPJ3FNsjEcQISViAWgkTe0yeizmljjDaC9lEQ/80fSckp6fjTRF5Ab2ESK/zbc4j6X7d/KlKYXg4lje5raryH5qTa3oCaomFTn19Qh4LPxcIipQ0jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ap3lO8j3xy3CL02/HlcW1RvkhrXL3377yB1/Kcthq80=;
 b=ipdyURR+kEVnw3iyvGcMsEqWq1yiTwZD+Kkn6852fsTL4LvNP8x1MuuHTI5xXLtng99yuStBo42iXIMut4mWLDaVCrr2cUGe4oTfTeRSGDCoR7sqvrHzN7l3RJCmnuplGXXwSXNMgK06j8PC9fhavJByUcZUKNL248mev4eiFmV4unl7Lsr4fg0GTjGCWAlfzwEvWwBoQHR3i4s41AOnrkfPbK0ivscQmTvSu4myklQfUMeymzlrMOxdxyI5OhZqb8SQKHCzGpUs2JwaSti+SGqqPiUj9CV/zC52IF9UxZSf9RieY9empV/+KCB7LMdRYkgpm0flSqqQe353tokThw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ap3lO8j3xy3CL02/HlcW1RvkhrXL3377yB1/Kcthq80=;
 b=popSfgLo3sbC7aQBe/K+k9gmLuDyv7uue79rIoaX7Yk0AbgjsVom7CdroYybd9Bw1znQOnlDZWQIEkOdf+nKwhXpbbufILektI7muLYR6IlUpHrxjsbj7IubS+AwKXvMXzLNloTqC8xhxNJ9q/ZU9oHPDN4iFhfozjNyfIONB6I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5052.namprd10.prod.outlook.com (2603:10b6:610:de::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 18:11:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 18:11:47 +0000
To:     Don Brace <don.brace@microchip.com>
Cc:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/8] smartpqi updates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a64pxxgn.fsf@ca-mkp.ca.oracle.com>
References: <166793527478.322537.6742384652975581503.stgit@brunhilda>
Date:   Thu, 17 Nov 2022 13:11:44 -0500
In-Reply-To: <166793527478.322537.6742384652975581503.stgit@brunhilda> (Don
        Brace's message of "Tue, 8 Nov 2022 13:21:32 -0600")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0148.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5052:EE_
X-MS-Office365-Filtering-Correlation-Id: 9342ba06-08f2-463d-7748-08dac8c730d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z6zUC8cxtntU8dy6AT0rH4eqjrU49GNsD93ICbvehmRbKtE3iN072KpDeztMCo+Zpvb/bIFOIo2bjv1ZA/RtKS/jPkm7/T8GpRmTMxrTm9qDFODCFyBoSlb5tlVkq3nlbFYji+G6it8oK+npOaslmc91mZLuErYGcXxOfjZ+Fd5vNgzisYDJpcDpSKfuE0um9k5eE8Aq0DPtpACn+m6B0ZkyI7EdkcYoWqTk32oC7UHrfIUuYFf5Q5i7yTmkArEygl876F3xB0kNunrA8IDaY+/YeZBbEEEkKb97rfbkQwSKbJqGsDwtTVeZ0RJ/sLfxxVWuTCoJCmkPMhdTz8ELjqRhLTqzK+tznpEofl8bpy+XtVpH4DM4mfIsteg7JGZ47ATWeiOBc+kd0g/XjZXC6X3p1bdutxNqLBXjJjRX5JL3LSu8KQ35CWfiGINqBI5Xa6GC15h3PE9YWOoThFFnRGrC2+UQXeUFzpZL8P2s97opGy7xrtBDCIPkq65Az/sOhiUAtZL4nbeBRszg8eBI2n9kSzhIQUTyf0qEdDTYPuN13tNb2wPPiQKZKecJ24opOK5GL78T+VffXOJOTNEORiuJY8Bt0uczHoc5Dehk5h0gZJK8E9tiL96QEFCnw+jdVPDIfvmdyu4PpuvzbKY7lUw8+a+TyyR+PYHqcsTlyZQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199015)(186003)(7416002)(5660300002)(6506007)(54906003)(316002)(6916009)(41300700001)(26005)(6512007)(66476007)(4326008)(8936002)(66556008)(8676002)(66946007)(38100700002)(2906002)(558084003)(86362001)(6666004)(36916002)(6486002)(966005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N2OKDPnD9tcYpcLVdNCj0wQPrzFgitJRuruWJ0aYt+1tYplwpBjLsdtF4LdY?=
 =?us-ascii?Q?eKpuRY7VUcxRlcWb1Guk37qI1ce2JBhWQdWduIKo9t849pQoHnaL5OCLqBCo?=
 =?us-ascii?Q?+uJ8mgDqye8BlrJhdLdaUca0YS6PkHHd4FrhM5Gdk6g0v1S+NweQJj1+XNUn?=
 =?us-ascii?Q?SXD8jerAKrwoSraE8Rmak1xmhcvPCGI7x4cy0RgKegT01QyhmqV80sxbziCo?=
 =?us-ascii?Q?yaKk/hdXQ63ud3qnFdTrwrDmvRzNTIIURVQS62DT/1ExU6C/gXBnZOJmXTi3?=
 =?us-ascii?Q?0YVcQSUBbThFPRUopWYzvHR14H45gHJESF2cMmeobx73czUFYpgADIbdJCO/?=
 =?us-ascii?Q?Zhg24sqAqjiZqKoTYS5NxRj3lApDGwEr4F22cC/VsIhhHOshhewmJw/zxF+O?=
 =?us-ascii?Q?MwMiR/GsILbVGO6hEw9L65buEajnJbdTw/lm5fHEdw2ghdk7VHWolsOzPXJV?=
 =?us-ascii?Q?78ZsKHzxj8kTJScVj0GW4kn8qBD34dVwrEyZC7IzzB055HRMAFnwc8KELYxh?=
 =?us-ascii?Q?QT+GZI/PeDPvaNf0uRwAZgithdGWQFfM/Xuw84wbc1jRZgo7WHORFqcLE4Jx?=
 =?us-ascii?Q?dozT+AnSjjykAn+eDgiXF1zf3CCUBzo7zO6ZP4/J1dEfv2oyvhcWYeDa1grx?=
 =?us-ascii?Q?GsW6388/PVGNxeZG2BzJhalXNvtW+1qKXIfTZFbVIP0vEIePmcBXYbBgaExH?=
 =?us-ascii?Q?mXuhWKxO1WqXImCXEWLBB6W9mP3AjsPP1jEqwHvE0XhoSgzJQhfxT4vWrMEe?=
 =?us-ascii?Q?cIvHIATeS320BDZLmw+9NYXYuGSu+2IGarifOZfS4yv0FNgdo6GRuZGx1iih?=
 =?us-ascii?Q?lLdiIy6Vc623x40fdCOnx8dlhRDk3YnIWEV3cjNV8TB9Knf7eGUaYschcxVq?=
 =?us-ascii?Q?bLrRbE5IPtMFVr66ZmJ1wCpPV83s7JFrll8iEO5iYMHrq+cADp+Hkm17dfHj?=
 =?us-ascii?Q?S1Dpxtu2J1alUQp8bHRIIzEhlvRhOMFeuAwlJrLYyRdt4rYPY6nlqj/Dg7fU?=
 =?us-ascii?Q?ClGq/PibnppV7v+3xR6BP2/kTBF/Cs0BEL60Y3ZorvyGoIJub+Z0MGHg52fK?=
 =?us-ascii?Q?BtFIQuOMMcj5HfHdx01TBD6mnK3TXw+uT53L9hNkJyBXsGOnOhxyed9cneBb?=
 =?us-ascii?Q?xY4FD3pGypsGMmx22Tyy+/pvdTzDbgk2sLa9KQNNpmouaOYQ+BoOmrSuHRec?=
 =?us-ascii?Q?9+VKTBzlAO2PyAm+K6Fy6wAWPezqe9y7XGAwhiFj984T/oBGq5h6wVtlmqRp?=
 =?us-ascii?Q?ZwHz7jZvv2FEWbb4KlptUTuliJ6hJvze5+9hdwlnq6K0l7Mxug54p52HlTBv?=
 =?us-ascii?Q?ej460AUZb5PvcGON8xtlYBnYV5ik3Z+hbKqlxmxGZzenFm5kYzJO+northIg?=
 =?us-ascii?Q?TmbUY6UVh0omYoPpgpofh4wxqatm5JfAyz+2UPaFn+GaqElzpiwrRtzcIxzU?=
 =?us-ascii?Q?j0DooE7bRWnkmSikBUdr/5KaGRt6X27qOC4YfIdLxHtrx2F/h7aGVtoPW4rs?=
 =?us-ascii?Q?PKLK09jGGQbJCBNP6N9ewUjDtzgqASLIQyBMKZE2TerX1/0ePSDbf3omvnVH?=
 =?us-ascii?Q?M8QTujanyJZVtprIzVN3TNG2XWSQwl8Hrax0OtSXKY8uY0QcFrjJFIrU2IUK?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?lnZ7VLzvydVhQpLl85oLFoHbdcYHjuR3a0RWoaLydR6GYC5PbAqvV4Hfx057?=
 =?us-ascii?Q?tXsWCXlFjr2youlhxm2Jud1uus2tGZoHzg3QPXtFa4vHTL0vdxoNkLVjgVgR?=
 =?us-ascii?Q?mhVD6GSyuQ5kkqY8x1kENvkZ6806wzhhBEznfZPtEmtKyOvLxfcFMfPnI6gM?=
 =?us-ascii?Q?I93AjF9FeiWwp80UlDCzbyAsNbU8IlD9m94w5OV71EzKg8a68B2mwqXtkqKh?=
 =?us-ascii?Q?vTtnKV2HG9oHelpGQ9V0YtG19de6x6wT6uxM3prIaWQjWpQ5cFts9Umc7c8j?=
 =?us-ascii?Q?E5EXjITGTAzNYOP6YM6qVTORFivI/fCXvut5xlQ+tvikhdu/yGatGcHJ12IQ?=
 =?us-ascii?Q?GYqwBFyyOP+LSpUHERZJW2CI4q+Wv98cOihqQEHfT7YDmFtVHN08NtInSGe+?=
 =?us-ascii?Q?IekTGMRqKGcX27g6Qh+nNlRvgFiZIo7ExX9IrvZoV+fOKkB9AbqXrbyo3rEL?=
 =?us-ascii?Q?ptsUj8P0xC6XGznABx70e2Fxfhz2agmooKlHk95OWMPBfzD2aIVCGQgl/f91?=
 =?us-ascii?Q?uHrks4779n4FtKysHYLcq/fH7hTS4LwEAYdn6ztmfWal8mJ1NPu++1dBO5R8?=
 =?us-ascii?Q?f0u9Vca201hB+DZraNRrmvBnCzzRhTHezUZLtT5jCeGWxBw2b6ffkbba68df?=
 =?us-ascii?Q?dP+rOy37bVN6wiM6c1nEVgjedoOB3XjQFRoQZPENcQ0hizgmcZ6eHIbmy793?=
 =?us-ascii?Q?QartjMUu1MDeOdRzR77OGSYmv1+VTFK5Mi3UZiAeWOhMmvFTPXcinLRFvH4O?=
 =?us-ascii?Q?XtDiWmnnB405hbGqLwXkPxQJNzPWklplT2DthZBcs2Kqkxcyvg1t8XoO7J99?=
 =?us-ascii?Q?/NRinfncOdmAOoybFU1mGzc0Y6phyFkVp7yADbDHJmbgkLv4xPjRocISX4eb?=
 =?us-ascii?Q?VtzyEvTB63ZrUDpWLsqomIdMztIi38kIoJp9QlNoNSz91pBzyKUonFCRXb7M?=
 =?us-ascii?Q?wHAjD+gN8/8EbgKgENMs7k1rkphYcX0Y4IqBlJBt9f/BU7R1pkMhqD20QS0T?=
 =?us-ascii?Q?tUTvtSsXrGhrlTM0pPEqmhNfrBHoe7uS9X+Pj6wgfsJzB+RCzkvM2VvwQbMP?=
 =?us-ascii?Q?aAiKeWSgqJVOFymdznRUU+cwGclhoAFsVIrAoyJrmVudD+ZPgMBlI6xn5r1R?=
 =?us-ascii?Q?8PzN1WfcRfK2ePqErRSyB5WEi90fEV2xyuFUhQ8B5aAmYEUvmT3Oh40jg0PJ?=
 =?us-ascii?Q?nZCCBLUh64OvW+nKxCKRp65C7+1UEXPiME90GXmbCo2a/u+DjtnvWpTMST7h?=
 =?us-ascii?Q?ZcxsxLuuPpm+5qowSzo5kslQ/0p7h36dqGgqvTIQXDcxpqg/JgwIgPubLTK6?=
 =?us-ascii?Q?Bq8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9342ba06-08f2-463d-7748-08dac8c730d5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 18:11:47.2501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GpL0HqkQuuasGfBWbl4LpBoNlaN0ZqKvEfTSmCM+ELE0yuZv3BpeuF6kZA6YN8OUnM70VwNjtg1CEEHBrdsBHO1A6dyVJjgp1ibByGfWKvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=879
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211170131
X-Proofpoint-ORIG-GUID: AWkU6pL5nngtZvpWHDjcQP55eiJ3nI0a
X-Proofpoint-GUID: AWkU6pL5nngtZvpWHDjcQP55eiJ3nI0a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Don,

> These patches are based on Martin Petersen's 6.2/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   6.2/scsi-queue

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
