Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E458C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1844E61D07
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbhF2Uid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:38:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23880 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbhF2Uic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 16:38:32 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TKGh7R025883;
        Tue, 29 Jun 2021 20:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=TWm68BYY2YiMVdnzS2pa2tzUV0uMYKTeoBkAo3qaYcA=;
 b=GCr9HfCUw39iXMHVk9jbtznLhW8WpK+0T92FRCu7gEWlu84rR8OLsnzioAxXSiXtyuiO
 uG7PnKtR/GcXH4D7ru6DZWrwNEhzdyuWbFZoQVoqA8N4xxA+TkCNvaPmLwQcL8vnViUG
 pfMHrN6p0qIiDtnCVDDntV5HJQ6QqExg8Pk54q31+DHiEMd5JZbR+xkoPOIZTeF3b3Gr
 u+MeO4KVJUOz7LgWFSt8eqH+qLhwJ7JldsWiTqRqT5XiBtN15PPRasMtGWBiMXg3wWRq
 ZalNwN6KTYyL0Fhqv8F07BVSFB060KQTgjWz9e4xh+vRQ97SpQsKKYJO+bJuPxwMe1fl lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f174mq4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:36:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TKZvuv172735;
        Tue, 29 Jun 2021 20:35:59 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by userp3020.oracle.com with ESMTP id 39ee0vns4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:35:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFci8le8Zzlc+MeMG4nmaR5e8CrU+3DtoUZGng19YJ+qTEKjHcWedhnC9aPMSOn9c3QuKsV0/14T8N0UoceFyW/23VqBsyZQHv65ZliQXIsN5qt9ea8/bcxqfuVZ5X1lBCkMxf4lTp0HHxyYfBaklMiLn0tY82lT6kNT+0pcVh6T6jT6r/iZor2x9GgSyhJQ98jEZNa4hmaQYbOIr+C4Q0scBH2aOSH3rHI5auFVfy1g9i7qvWfGMxO2gz03eu/bIo5TTw6cQwLV49Ylte/TVe0DNmrokmC+EsAIjj2ysr3BUP9Q4wo5usFq2/XNQ8NVHQ7+sgAVxMm/z6I+xxnAWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWm68BYY2YiMVdnzS2pa2tzUV0uMYKTeoBkAo3qaYcA=;
 b=FHAITJbLpgXCOBspXNjBsxkvv7cSHpawMg0ABn/9kdPuB/839v8krH1jkvBZiJWwuR2r7Qf2u5tzyTFC46pwVTsi3+8UHWLh0oSoDNuHgbwIO4YNu87b4wN9uXy1RYwmJ9ZqkVrQW3dADRROj0ascBQHdDL/uYvECpuVRSx/8D6L7Tldk2zZYGObDscLiTN60Bo7v20om4uU6XfNDbgLZf4Rz6MZaECGaeiR8q0NlhXzYWjPFYYHfFQhzrSJTEYylQQlx4KetmYvGPkVTp4+cHMwm9JaZki+h6IQOTdwYwQPIqUvkCYEBv6GhATSneqpkGKLb5aAKEntg6kHkjB9Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWm68BYY2YiMVdnzS2pa2tzUV0uMYKTeoBkAo3qaYcA=;
 b=k5+Ev/UnjCC2TMA5NKmlnBG6nzUqx2GC/lsxKrqKs3iJJeAyvWvomDiSdQo2jBTv4dFqyzhj9X8QffCBzFFUEQCKvPlzxz0vPXztkaaEuTA98YRpPbtwd9Xv/64mcku4OI2v/OvmMBCTl6uxCG9fisi81Z2dBzdn+/0kqNMuVvw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 20:35:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:35:49 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mpi3mr: Fix W=1 compilation warnings
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czs4jvul.fsf@ca-mkp.ca.oracle.com>
References: <20210629141110.3098-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 29 Jun 2021 16:35:46 -0400
In-Reply-To: <20210629141110.3098-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 29 Jun 2021 19:41:10 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:806:21::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0027.namprd13.prod.outlook.com (2603:10b6:806:21::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.12 via Frontend Transport; Tue, 29 Jun 2021 20:35:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b7e10b-c1c4-412e-3408-08d93b3d7af8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442368E2BA2434098E36717C8E029@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wTxMNzPKGDHb4v/9NtzbJB0HqbOeLJPn+fDyn4P8SjzRasc1hQv0+I6LlqZX8BCZFetT/zi+j5vX5J/TEHl0IpYmCRTSYkjnFKV7dIB4bevMkBJ1FiwimifngB7hxb/4gDMkT5YKQDwCeCmu21pG1ZbNXIQnJA+45YXiUtLukZyFm1ydWMhUSvz/JCSCaljclLBeMDzU0LXM2wmPiyQsMdVpLLHZswjRPBtwoe13+MoBnx5SQ/PpVy2/67hejGQS6eEXhT8d0MeBVcbKONnaKg86D/MJlK2RGGqrcmKw+fCnxkdBrqKNYZaWJHL7wYUo9X5ByuStc1ICzP7WhmVd5tvblJQBlfwvy7UF2NB7uuDa+Ra6F5l4smnnoS+Rh6t20UUTL8+xyjsSZvRGOFs00Vr+9JMmd2RyN4ITFxaCm4XzzW/LqCY0RkbWJew0eberCKWRdx17sauClz5idvsvNrbOOcTqGbQeCbbuSKGIpPqgyyu+CwHE1BFRuh+CKerRd0pv/chLYe9CEHHp9an5/JU9GiU+/gf+3DHdrzWRs2yHhKO44fDZA+h2U7qcCpMH0LSy3++076u8O/KFcXj58J16hXrqOo7jMgQ9rkXykv5rcAv4XyrEByIP4UoU3cMHQRDP8Ukrd6Q7uJ+08HtEF87Il7M6ezWEPiBFZth2FkLhAyYYoEkIvY6Gvj1i4H9ASjDNfSLClzpZURle3eMgLUNt+G5v0AxwwQB+JTOWrHs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(36916002)(4744005)(186003)(6916009)(8676002)(16526019)(26005)(956004)(38100700002)(38350700002)(8936002)(316002)(66476007)(86362001)(52116002)(66556008)(66946007)(478600001)(5660300002)(7696005)(4326008)(2906002)(55016002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BoHvGm0SowlVdP2vCr7GmDjl5hRy0znXXtMi8sIITYp9cMY9xC+VpAKPy7Kr?=
 =?us-ascii?Q?+OrSpvBw/N7QdWP8U9KS7HAk69eWZP8uPcSokv3WZM8EKLjKTOpnzn/RPhK2?=
 =?us-ascii?Q?XR7L9a+47v9was3oxH91MqGIhg9WtPgWkbfHyrDZ7XS70bRfrypnO8e3764h?=
 =?us-ascii?Q?jbSjSpoktefIgksqLsW3Sy6Wor9hcJNZaXN6dM8rZAIzYvewwiN1Qp1E0ZcY?=
 =?us-ascii?Q?SJeQ6ppWXzwTWH/enqdtRU1YneoG6Pc0LMQTVK6J2pK7WT2kTleVWH5lGvMU?=
 =?us-ascii?Q?UorgTRqqk9GtMsdAn2hP8ki0DFS2yE576PsXd77cQtINdS2pqz6j+C7lkSbd?=
 =?us-ascii?Q?bcwqiepQFQSh2rnmBgSNAOzXXpbrm8E0Ng/15UwzKB1Tfn5U4PVrw/Pdglir?=
 =?us-ascii?Q?j2ZsYh4DFpF6tHBYpiWTvpvzdAtXWBpEmK8TBsOv2ygbCWocg5n1Ys1jygXg?=
 =?us-ascii?Q?CbeDIAzQbfYy0s2/8EtrDYBBbpD7BA0QZRh/06aOk0Pe0R4kOfDjE/EYY+va?=
 =?us-ascii?Q?xqx3kDtTtTbzjlNIq5kQKkRc1Alv2SZid6+SEMF3C5G5/X19MZp87a7Wby1j?=
 =?us-ascii?Q?W1DJSimQ5Wc+9MwPsELWgXZekh+p4cP3kM/L5XRWilSrjaxGHxm+ixbkvFZf?=
 =?us-ascii?Q?CliNBXLAHG64vexzE5wSf4jYSW4WSu1tGHXA7O9UoSh8RoHXNKjqR6FP+UFd?=
 =?us-ascii?Q?zi5x/b0KteCSmCyK39bL43JmhLaN5gXhuSXKn07SJKl4S0F+sLRIqq17GZHD?=
 =?us-ascii?Q?zP+9pwG7ACdRlSKFnBwxMC2CwOQiO9bnwjG/w9Ida/YfVTCGZg0EXdVBqiee?=
 =?us-ascii?Q?TxgYRHpA/wnFsgOa0xB2l8Sh6D27soNdrkNJTLtkT2ojpFxm72rsF/Pe/nze?=
 =?us-ascii?Q?BdWbn9OSCzrVg6CJ8oF5D8I34hGQTThk79re+K697P4YvbijL+It8TVBd7oE?=
 =?us-ascii?Q?iPpGn6f8la3QxCCiFjwieTlR7doGKc76qE7JypH4S45FcEcPYqr+c8EVfaw/?=
 =?us-ascii?Q?XEBUrn3bNq/xkixid52ylrHGPMyyaJ+yJLGx84leUCsM7PTwapJuijHprDRt?=
 =?us-ascii?Q?N6tKwsKVoEeLXOlYpHAy6PKYYXiDKo07ihpU18UKc/I35gxSQM1y6MmM2M0m?=
 =?us-ascii?Q?M/id6DMsr518QDiYkWR0or47bf65NLQ8AKAhntozYW/5t816HXGIOhQmFkz+?=
 =?us-ascii?Q?xavU2xscSWiBQeN5ZqaClZ0Y9JRXF1ZOzD9mSvyZl1ag95RjusjRBnZIPeFK?=
 =?us-ascii?Q?avxPMQ3+j2KkoryAgaEpilfvXsAEgFCUt+O2Rt6HPsCP5HjgHzJ2v9gLZVXn?=
 =?us-ascii?Q?GgWM524wI5zHTjwTb0GFPver?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b7e10b-c1c4-412e-3408-08d93b3d7af8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:35:49.4026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fqp4JHeNnV7dpVTTOvOjhvyaMGk0Ni1SNz1wGPUELWXGcylNSrizQEyIU1OIx0twgPSq0byH7mciLtzPeuU0gOzFXjG0PYSTjSxDI2BKdWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290128
X-Proofpoint-GUID: oOjKDB3uDIL3Mxk29vKEqImb3VvjST3Q
X-Proofpoint-ORIG-GUID: oOjKDB3uDIL3Mxk29vKEqImb3VvjST3Q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> -	strncpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
> +	strscpy(drv_info->os_name, utsname()->sysname, sizeof(drv_info->os_name));
>  	drv_info->os_name[sizeof(drv_info->os_name) - 1] = 0;

strscpy() terminates the string.

> -	strncpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version));
> +	strscpy(drv_info->os_version, utsname()->release, sizeof(drv_info->os_version));
>  	drv_info->os_version[sizeof(drv_info->os_version) - 1] = 0;

Same here.

>  	strncpy(drv_info->driver_name, MPI3MR_DRIVER_NAME, sizeof(drv_info->driver_name));
>  	strncpy(drv_info->driver_version, MPI3MR_DRIVER_VERSION, sizeof(drv_info->driver_version));

Please convert the remaining strncpy() calls as well.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
