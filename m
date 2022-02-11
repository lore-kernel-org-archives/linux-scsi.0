Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03070C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 21:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243940AbiBKVtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 16:49:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBKVtc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 16:49:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0CCBC;
        Fri, 11 Feb 2022 13:49:29 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BKv0NH006459;
        Fri, 11 Feb 2022 21:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0CbIC875hCBWhloeFFM4clWwTYDUjnysywSq3iyGRno=;
 b=iQf/2RzvhriXdXTxeok8h7ri021IA1rvvUeA/eblp5XEdj32S69ADv9iwb4h155WJ30N
 J+gQi1jek+ZzUKvz33iaDOpLma+x0a6644f3QxeZllZcmrk3dWmS7mkrMvCrXCja1kgU
 Bu2GlGNJpzk05DxHjAUr9gFhZK72wnsCpoqKWaks78J3gSmuF2PgBc65fzL0UMgAx4uG
 eUXT5JpboXyJ0QYxm8VF8e+1Ov/5BglITWtN7OXQMXYmN6aQRcIFGGnGgPOY++S+xuJZ
 cFo8x+cJtfP8G4ZBY3iTXLAI+UfAHNbdXIFNZkXR8vppGXFBYch9UzsPgg/hx+MHqRW7 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5t7ks04a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:49:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BLWIg1172286;
        Fri, 11 Feb 2022 21:49:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 3e1ec83k46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 21:49:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiwODfF4pylBnQ7uO3gJsa1DZo3maHCnfcrYoD1Lm0/7hnt+ITuIRt59rLe62y5sR5hZPDD1jbnwvaVi6rC8inY3DAUQ+vixLfyjl4ms4SxgeOcIA6G2gadcVshcNkXlikW6ux40vWMJlfWTi9ryX/tBBK7pZ1GbpLlcjw0GAnFrrwM968c2DHM/Mh9W9Xok9n0Tdmi+Rjm0q2c0Z4uOtpaD45ISHiYnYdjMZwF4oxjS5RCUmaRUAaUOoVrSHZFv4jZG9itDB9QL/eYftTfygFkCnKxLaiZ3VU3MsIOTyGB6JVBlLq3rZs7ip4Z32UOcD2h9rTJmiHFT8WQA0JNxTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0CbIC875hCBWhloeFFM4clWwTYDUjnysywSq3iyGRno=;
 b=JZ9FNOwqf+LB6UBEPkNIQDbUggTXc5RlC7NKgiAkEUkdL9e71NcfGM2X5xP61IAJoPevKZyeYguhzKS8DNtQPf9PaYcQYkVX5Qd2LCwUlsB8OQSjwT++cSHPcoZryWJoOgaJunhfteQeLbTbGl5eGUpdd3hAMya8CucYLJso+L0gKq+ecZNf7MkfvkEivntNPSj+CtPbHOO/t8FxoanXg8EYBgdF15NlEHGlcypTf2nDVSVBc0koaZHwz4Bv6jn1BqP7BMpct0MxtiZpKpHKiKX+l8HsG9hs0QO7CT4gHC37URmGYzoDpnJGO8Oug/Cih5XH1DMOFKCwL7VIW6FfOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0CbIC875hCBWhloeFFM4clWwTYDUjnysywSq3iyGRno=;
 b=x1nBrkBfBezbbwnAqHYz/4YaWPjcfQoi7Bx5//f/ZxQfPEzLZF9zd1fJipzcisBVq6HgWrnNqAMjfyvueyNomfuBVFk5zwx86l6ZV3msh2MCWNkNQLfuz4swXrRsoOWWS0cquKp9V3ynfO91JYs4JJs4SNkdLTroGaznVVQy3cU=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BN6PR10MB1697.namprd10.prod.outlook.com (2603:10b6:405:9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Fri, 11 Feb
 2022 21:49:21 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 21:49:21 +0000
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        martin.petersen@oracle.com, bostroesser@gmail.com,
        kanie@linux.alibaba.com
Subject: Re: [PATCH 1/2] scsi: add scsi_done_direct() helper
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r09qdmn.fsf@ca-mkp.ca.oracle.com>
References: <20220208063707.4781-1-xiaoguang.wang@linux.alibaba.com>
Date:   Fri, 11 Feb 2022 16:49:19 -0500
In-Reply-To: <20220208063707.4781-1-xiaoguang.wang@linux.alibaba.com>
        (Xiaoguang Wang's message of "Tue, 8 Feb 2022 14:37:06 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::23) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f14eeddc-2b86-4342-7b42-08d9eda85c93
X-MS-TrafficTypeDiagnostic: BN6PR10MB1697:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB1697075AFB08471DD22A5B218E309@BN6PR10MB1697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZU4v2GGiFtl65rv96sBWotiqdEi7aUrMMf3O8vCgq98GKS2ukqQgSwabGj03goViG9dcjDrTE6csncwrVA7BpdJMY3tDf4vEqvnp2W2tmLaP1vt/63YO/bp7RBUPaoPz+PaAHrDOG1128ZJEEDRyvOsAt1KEMoa/agW2yBO1TyWYYL7/A8YIgU5igmg6aDJcutaMEXJXkjccNfQ5dNK95g3PlznBke2UWWpWkF65W5y9ihtZhyXYWEFOlfTabKRmb8vMYhiteHYF381YwUH4hosPjSigNAgQYooRQ7dSeiSqZ67YwuE0PpBcT+zJgU/JO3Pzw/cDq1mwsCLiAeIpr/zNCRROixoUOoTHLkV0DxRKqcBQCEudf81s6m4FCP8/HhYinLpk85sfitkqUQTOE5OrST3HvYdINCGYzJMAJ1e+fk6xnLsOJ6PMDrPDQO+nAZRXxpnVBpTlgkduwsgnZG6p13/tHjXt5kaiWCpFCbdl3M41ja88gLiZ9IfP1LaEAPgiEc4oK1jlYlrR0Wh7RIeneC+Zak6j9mOwcr1ahFxP4XfKX1X/7853p1afMsDk/wUsbgglJjaMf+aSyRd3uOlX6b/RavTOWYhYv8rURB+YXvZHSJpR1i6phnPk8NdTu6XWkDGBVHDgz33jL0m0JfLP7/BXcv4NXWnhijPHKEzKQ7Nm7bnZTKkiPiusHGfsQ35YbBGAlSNtqW048HVs8ZUKNuccGDTvDiyb+YXSxb/+S1Dc8nkcm/Fthq36ph7EdWWF67tyW1774KnhvIjCltXJqWjS0wa+yHjZahd7lnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(5660300002)(26005)(38100700002)(2906002)(38350700002)(66946007)(4744005)(66476007)(52116002)(6486002)(8936002)(6512007)(966005)(4326008)(66556008)(86362001)(8676002)(83380400001)(508600001)(36916002)(6506007)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Xga2H3hzxGFDSgvidsBqtVmvL7cjoFNC5nWgA+dm3Ywi2L99xwFhNoCnjEQ?=
 =?us-ascii?Q?P1fj/5evBgW/YWX1Cl4I2S3NTGQMncylVzpb8couKD37u5RbXQW2YYj75EMw?=
 =?us-ascii?Q?XCGoz/3mEjOH9UO+Gw25V0NIOH/6vrLYUGTjsddG/Kv7wQo/+f5udWClC8xr?=
 =?us-ascii?Q?Ztp1dFrt8jl9hDptDt6LIomGAUWSYNDIZJd28JJtqJDI2fRJYJTHR86JqLSh?=
 =?us-ascii?Q?y4jHztSSNH6mXk10XM/T0wcexXen5s15bzwNGFkNqBdQFEiK3Z71RPhTdPGD?=
 =?us-ascii?Q?3YLdbDvy5sxVI+bvMQ+7PcLPbV+1ZWSP5IraC3PD4CUkqBQq/Akd6L6ITA6G?=
 =?us-ascii?Q?VhkfGHpInAKF+hKBDt0GtHFOOJcudicggwCUAS4hh9uTy0RvM0y+rJHPVEgP?=
 =?us-ascii?Q?WGfbC3fYAzmc9baO0tVq0BzhIH7yS3qCZmCNgJQyDytxc464PPKwjMG64xYc?=
 =?us-ascii?Q?K4W5Yslfjk6eEDTsirI/ZuVcvrXfwLlzJqZV8X5Iv9DCSFAtmWWoOO5k67Yg?=
 =?us-ascii?Q?oY1VA7lVcoHEfZFVj40MikW+v1dRXisjs6kf2hwJSOtdBbGqv7LYFW/xoi9A?=
 =?us-ascii?Q?FtDIaCnAl68leILPhcXsZjyCU93rpsG0m1dEXnDeppjKVkaPHI3xJkZ/06m+?=
 =?us-ascii?Q?KoO2YA1Kx+CHQY0mbvq437GY9JocFJVZMsaWaiExV2Z7Mj6/UdPF++57AE1r?=
 =?us-ascii?Q?aJZEgB0fiOIredBuejRYIEn/KVNmHusaxPLmpbHIMIQrvdj0lRzRJa/SBe+L?=
 =?us-ascii?Q?tk9/midUajKdeBGbojzbG3ChXL41+szbkrCxmRkaZiqPseQzBF49dKtN88dJ?=
 =?us-ascii?Q?9mvE5eY9jxTGdr4cq3eJKLkONwjlSu/tx4hRPf/ck+4EOw0lbm1MEBxrQqnH?=
 =?us-ascii?Q?eEfK0pwW+VZoVvKnlSFnmeeTccBOxmCAHsgUN20oGBCbrA3BzLrC1WG147VC?=
 =?us-ascii?Q?CqdRWKARMLGhK+ntASYAZNA3y3cm6jUXQBPhGBE9aqPl8dilvGLPLa0rGqNe?=
 =?us-ascii?Q?+cnKDcB6GEEB0NHlTNMBHZLYhu7yjnhmyIPgVmo+ykkHOkpRDq2JGHHqdLJE?=
 =?us-ascii?Q?Ggr6Zljk5LBJXketRr4z3uo4Ed/MbwGNn1I8fXNWBquN0bNzN2HrdrAjE/yn?=
 =?us-ascii?Q?d/msk06r6AsVvv4nUs2NM1lK+zmhxFRTJTPoPhis9UbxO5uQ6q8Qys9gclhu?=
 =?us-ascii?Q?lY3GXy35c3zi4DMjVe9+PuOMdfJ6Q8Ni8ugU494M9qT8NvQo/7jTRNHdnYGw?=
 =?us-ascii?Q?czL2yhfZ9QcMGsUGZLF6EaBpcw05sseEIrrCaaWGuneLpsQNCCgpNRue35bu?=
 =?us-ascii?Q?GEJj+8shkoFOIUuuJwrr7g7RqTXlt7esxoeYc0wZ9MrXgjznCJq1RG9WvPUy?=
 =?us-ascii?Q?s3xkxdFwiuLnHCBvxtsiU8r+HS9kcEcjXuLmG9ozY9HeiIG1HbPuEC5owPXK?=
 =?us-ascii?Q?D7FZLB/7Cd24YrCBepJiiXblu1nOOoyweinWLofYlPpACNC5ARZVw7N6wgKE?=
 =?us-ascii?Q?8MdhAAcIfVCLPy9VaMvqExkJHS5+8Rfdf7PspuBm31Pur8eVwDRPurBjOr7+?=
 =?us-ascii?Q?e8lDGDOufK1jlYKvVFfwYlLOecxXAiiDugoB9/Yr5WJZXVXer/v1m98rGh+U?=
 =?us-ascii?Q?z+wiJ9w4/RxDEQj/FjanJRWbEFNnUElA76nuNNG8JCuIcC6TG3g7ppjzlt+f?=
 =?us-ascii?Q?VJKRhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14eeddc-2b86-4342-7b42-08d9eda85c93
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 21:49:21.4187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: by4z4+muqqCJK+Cwh0Ntexi381rWclVS3ocBzTENBNX5DP3vTWgTffaS58bPyqAG8krCi4crucqVKbNvhO/ro68e9yIkD3NYfBF0979y1g0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=954 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202110108
X-Proofpoint-GUID: RAHp7CZIgH80gU8qLPnW-9qMHa2dfpFU
X-Proofpoint-ORIG-GUID: RAHp7CZIgH80gU8qLPnW-9qMHa2dfpFU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Xiaoguang,

> For scsi commands that are known to be completed in non-interrupt
> context, scsi_done_direct() calling blk_mq_complete_request_direct()
> can be used to completes commands directly instead deferring it
> to softirq, which can give throughput improvement.

https://lore.kernel.org/all/20220201210954.570896-1-sebastian@breakpoint.cc/

-- 
Martin K. Petersen	Oracle Linux Engineering
