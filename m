Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B0FC3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjHYBWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjHYBWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:22:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E0EE7C
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:22:07 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEZYt027036;
        Fri, 25 Aug 2023 01:22:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=QRtOC6PQAdBYvw65TelcO8wCZowXrqWNKC73Ab7vyCE=;
 b=fxJNUTZ8ds+KBUDB7AZvZTGVhCYcqrzgKMSu/o57AX6byXosw6rGlMFIuRILMenW8TaT
 JhkHmQxGuuaiNbfFnIwB3LUvb+ZRLJ2ji+cqVTzCK3GVq2DWSYbwKVrYPzAIwPKIvEws
 uWzRyuaLRpB/3pptyKJYmt1tKdX1OPfLCW3VPlbovEEYc9I5ei8FDxfIyzxbrF5g3Zii
 zIbBzQIeM7YMUPbx9UYmdb6t/mcZbnPkJS0q9GVxVRjfhZvuCrNbSPxlYR+iXRwv2txj
 1Ya10Cat8Iq68i6ZFDA2ajnLGtdZwnHYZK5bndq7dDpW0lsIFHEHnBAZUJn7IkYLm3m5 jg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20ddd3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:22:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P00gKo005925;
        Fri, 25 Aug 2023 01:22:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ytyek8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:22:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVxlfy4f53y7wkcUL5mqsNqeBlgJ5EcD6EzYLGfd4hapSlnq7hrUf8UQLGQWJpT0gCGOlN0TBj/Bke0WDUEwiaRoNyooRAEnQkCY6bkozLk2j0FmP26r6xSb8aRTrkefJhlbC9QKsAhJdCe/s3hknzdkjgkHoEbjgX2ZUzKumPDVSh1PzsSvJzPM/Um5aJaev/G+tvbrJeD+CXOsiqFgBxIMwFpW6/zrBzvEwZKN9VNM2tfPlxWBH2ma0QIGnyBSpFARuAVXziTb1LDXaRYHp0M0iS/+3LdxnMEL5Qn6dVDHLT9WNeHC7+LRZ0IU4gqhhpJwHxWRVv3uI8Ru/w5caA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRtOC6PQAdBYvw65TelcO8wCZowXrqWNKC73Ab7vyCE=;
 b=m4f+a1x9RTCPTXHsRl8dV1krPcLX0FswWiYO6dYYs5QBinoSkRi2ws5JV3LfZMHZ4v+2rk93fULv1p1FEcPvPR+fRm6732D7mCp+U73K2M8+Gngemb+Z36LlHPP+CsrdjYTpZycBhxNNxv8ZJGjaSFcrZdsjA14YF6ssMNR4kT9ZpjBp87h1FcyYeHAulQ8tBjlCKGHfNrUBdtrFu9ij3vaz+dcI8xukc19N+T3Tk0usjgirc5xrLocBMSM3vkofy+1Yvx0xX/LwpGSQwS3FsgwsJu2PXpR62s96BCL6QmCW8yacMBvlk2G8+m2SfCspQyg92rKOJOGoQiT5p0zIag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRtOC6PQAdBYvw65TelcO8wCZowXrqWNKC73Ab7vyCE=;
 b=h7M+rEGncmkYtPsqBi/un/p4sBh14mZ81nh/euoJJawys4ewmuFVK1oCvzURxQmpgYS54sg0aloFOMvqo0HM0MZOS98FUkKjQw6UEDMiBLC3CJLHl0+QDprAEZDhAq9uW+7QK5+OV9WOhdD/jt1lApAIHyurRKXdhZbc52ZfVBA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4366.namprd10.prod.outlook.com (2603:10b6:208:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 01:22:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 01:22:04 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH] qla2xxx: fix nvme_fc_rcv_ls_req undefined error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkev532l.fsf@ca-mkp.ca.oracle.com>
References: <20230824151521.35261-1-njavali@marvell.com>
Date:   Thu, 24 Aug 2023 21:22:01 -0400
In-Reply-To: <20230824151521.35261-1-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 24 Aug 2023 20:45:21 +0530")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0136.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4366:EE_
X-MS-Office365-Filtering-Correlation-Id: 43620700-dc88-4c86-8897-08dba509b0bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l62mNOgsbxX2mkhOA+EhzItwIrNmLfk496bYUvt3P4Mr9sZQ01Q+ujFv6mZmncK4nI82AhDBTZOnhoh2q4/cw5OzaeAQS9A853lSY0nNK2/XczRYmyrh45aM7ZuzL/H25c3YLi2l4wbKN3bxNNbkkMP0ZykES1qtNG9oSFAHLBQfLQHc+JM8tybApmIiWlTLdO1CCfEIY2OeAhh8im/5EuxLQ3Sxtox3V1vP+hRPuoteD4+EmGiLI+bAezFlTk3VdUxXxhxh9UoM4KX32H1l/J8gO5cbzcDPfw4jraVUzEgJrJX/nG2NTF6crOlItoly4uKgPbhkYX3tjd+hzPXpcTZTPrJjeZ2XoJg8z7WYTcU6lHUrXyA3twjc0Q5cqRZVGQSFDr9Nh/crBsHPtnCkytmYjI945W55wzLfZxxLRZwQKc9M+JZtnca8T5FUj/dTZRgJY233tFkrssHD0LTqmUyS3SsJ8nL4OFRaXHAtBzOOyjF6H8UTbftf6NuK9O8BSLCcnykkM5yw/gloAYyUS2NwCNwUGRcht3HYS3LqWdUAB8vbtQ2TPYEe86+zH1FH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(186009)(1800799009)(451199024)(558084003)(5660300002)(8676002)(8936002)(4326008)(26005)(38100700002)(6666004)(66556008)(66946007)(54906003)(6916009)(66476007)(316002)(478600001)(41300700001)(6506007)(6512007)(2906002)(86362001)(36916002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t8Kh2Vo8Cs/ZO47l6MuSY/mIg05qhf63NZdth6Ex/tuVN4mILFfMH9tU/g+7?=
 =?us-ascii?Q?3aHZqq8Tl5ppjnQXMtTW/Ml30ESUfOpFlFmBkVmU6sgFzoGn17RAChaa0TRH?=
 =?us-ascii?Q?H+lc9Kgx32r+YT5A2PcTjivXrKo9uhumg1BTSlmDRdE8B3kcLKUyNNbHKotl?=
 =?us-ascii?Q?cqchbXbHvkKQOm3TPCBd9Oe4RYv06dpXprsqzGuqoDAgWAEFtbVzKZFupXbo?=
 =?us-ascii?Q?Pndv0CtC8VDsP2YlCj4hBQSN6hLFqP/Gr6MS0/0eJnkbEx8ZiUq3C1c4IlCX?=
 =?us-ascii?Q?k0Vo3zZJ7WoOmcTXEerPeuDsHR4+3VOWDDOqqj1XBuNyvwWZnbsCzPLFEQHn?=
 =?us-ascii?Q?3Q1Cq+7prbj/IwQOAkj9/tHjtL1GigDsaiCgDP+v73PjpTYSouqJE4J/Sh6v?=
 =?us-ascii?Q?jYMY9WWMxD8Opsvu8K9aiN/eXwzczPeUURaMX4m5zBU/g8+tUDhTqVETkhDM?=
 =?us-ascii?Q?8VKU1mimVgAXANbiy7XDvHbF+yENUbh9Na/8ZKpeBlOggnJ0eehRn4Af40Ls?=
 =?us-ascii?Q?D7x4DQDhPX32RnufWonOYC6obG/tNFAAmTCOCCyTMY/7gq/fUX9D1CiMjKlQ?=
 =?us-ascii?Q?Q8IHkg7scgXq2swWDYWliKJ0BOyxwbPd4baHZxJPOLzn2z0LOjxm9clVgFcG?=
 =?us-ascii?Q?t7AV1+n3h8UXgArA1JS2qjnxSmguBRLGdXe9ifIBnTBvwsLd9av6tv1oVtBH?=
 =?us-ascii?Q?XGxkKFsDVV+mbqItCMxjO7jKtRSsK6io+L+5tSOuSETqsaAW7l1I3CAf3i09?=
 =?us-ascii?Q?CoVXR87q0x+c9oN+E6pPSJqTRvVlFqVAnYxRjzEXchUx85dJkP1NneHbur4h?=
 =?us-ascii?Q?dIehpSTeJZO0Ex9t8Qb5QXP3w9FnHRizBy2eIAL9UomoGNn9MRow9l4Vuqek?=
 =?us-ascii?Q?sITtgt/hvzCJGksxNXnfHxQE6MJiOJjAjUcQuaYqG1opUelKgHIO/X83tWQ/?=
 =?us-ascii?Q?W1AkrMmzmW9kb8ry2Ne5cKs2d8Vu0N3/FoQzwochUPQQYv3HrJ6vzk60f83T?=
 =?us-ascii?Q?vODuAyBxFzmAkXLe18lssWS003gSmmwtoaT8xT2pa8S0dKpssuiNulS+SiB9?=
 =?us-ascii?Q?J9xO9iO+NgSO9esEkei2QvRlSqZzwVCyfrYhTukD/4M98zqyQz6H2ZTjwPNg?=
 =?us-ascii?Q?67HTVkkKKc2M5F1LPex5Gp7fZ75PNLVaL2TJiG8LsDkTWQumuH4g2wQplLXB?=
 =?us-ascii?Q?43Te7kud5+65rCkn0D6zuJI0HXaNvWvEXX+ARVXlPI+M7giiqnsfg7Hzw3c/?=
 =?us-ascii?Q?veMtAqjqM6f7a0d5MNF9JlCXWL59oJ7nFtVQOcrOQvo8dsTzQhXZM4QtYXsm?=
 =?us-ascii?Q?I9HYW9sy0n+ymifWQW4BkljTic1OmgUqd5VyQszzxqbsbFrWjl1WsNaOkKaF?=
 =?us-ascii?Q?9Q2NLlP+xEs0EtFWKp1YF5LZNQtnaSBLwkmR6HqFcws5s96khDiexN+wI8aN?=
 =?us-ascii?Q?LbjoBkwf7HpcqlI52WF4du4FDoY83AuIAYem/16z9YMWiTwtD/3X3dJgdTbN?=
 =?us-ascii?Q?9oA6gVVpvyjHUL6NUJGol19ABRMQWnPKFMLRzeF0GZbshZPXqvRE0YTUo9EB?=
 =?us-ascii?Q?iNtC1HRviSDX47mQm2Nn6ZQey2O5ITfHGsPl9OFHBGkAR2QAg0jRinyL70MO?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ofPuA8qYt0GWdbEtV9wumjqye6+1THrBtBrTV6yZ/CD2KECal2UshrkI6fU4waLhOS/JWYwsVH0HYCP2fA1I9wAtFNfVVVj+AwCX7eEUrTTkP6SluAdW7fFYmEOg4wQ1VMv4weegOPNrKl6/U9E+OGbmIrwoPdweE71vWR6WYgfpTHaHqObzx9Tha0h5ssNwiydNoq/Gvmfzu6ag28lJqMIT8CK4W+KsSN+f5TFN0eLP/swaL/aT8nTmAwMJKiGCVMDm6Cnsz31PzGKkqW3ADvPz7xyiDEH+jZCieL4HsklkGCr4unKYdqANgyo2fjv3Htc+Usa37PzsUhvxlQg4rJDGqyqZChTeVldR6aJTZvWHjVtd5JEnKWiMDGIP85ZZUSXm0ryYq2nKeweKcEX/3/SbUX7w+uan6mntcn4JOMN3/sQF9wAn2ItUW4JgwjlaGPee/sZ7McyAQW2wza8xNBu/UIbg9wIkpmDQUPptPdDiok84Jfgh9Z4mamVzNC+HBgj8BZgLh2UUVMj1a0dWAg+g61f9dAEESRu7RUEMQr07uMWcDSsDwnjXsi1lkoBjtWZJS/zfSEK6gnGAxWcavOKlDs9tcmAqgD1fWVaUE7Myno7N9Zu7ATam6/tEnv2rBw1IuwJ1wH4+00pnq0ZlN8XFV93AQ6IH4ejoghtBaZ3K4bSfuXdORA1uOvPuvVggyfrqSe5FFcBtcDDV6nQZpW+LIVBKZcfX3REWnCXv/xamZ1V2Ydce9cySQLMXvDqDzH7lUg2wupRuKuWWqlOqn7J0Ud8z3TA/hp7ofIZJ1g4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43620700-dc88-4c86-8897-08dba509b0bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 01:22:04.2630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxlC9ncqbxNetYKGplnqiRD7kpfd2bDPKfk2f1MjDSSwtmt9Zog25cILFc6IYmzNAOJtyP4t7LoLSzdcI/jAJYBjZcjT5VQ74tFA4unqeq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=730 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308250010
X-Proofpoint-GUID: k441INSALhHzjPRVB0AaxvmCTCcuY-d3
X-Proofpoint-ORIG-GUID: k441INSALhHzjPRVB0AaxvmCTCcuY-d3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> The kernel robot reported below build error,
>
>>> ERROR: modpost: "nvme_fc_rcv_ls_req" [drivers/scsi/qla2xxx/qla2xxx.ko] undefined!
>
> Use CONFIG_NVME_FC enabled check to fix the build error.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
