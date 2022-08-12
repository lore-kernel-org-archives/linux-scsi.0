Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA40DC25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 02:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbiHLCOB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 22:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233840AbiHLCOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 22:14:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71450A223D
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 19:14:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6D8W002866;
        Fri, 12 Aug 2022 02:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ljLrMtUYjM1RLDbwXke0yKCmDPsfQ7jO40EPd4d3W6w=;
 b=rtczTwaVdJ2cMx0nXp3+BsPCNAPGQeiA3LiBYieTdDb7AxQRDbeE6gb7nnN2/u9LrIsg
 7x/Si9pIt+QcwvpLmQB4boT9vaDNxo78duC7yxnCRzN5kJKt+xYBQFIxYzEsrmNiPNz6
 FJStSb6pgp10PvB1wCxmw+2jc1+WQHKvK6F2o4C8t4nDqjsEydRHkuQgvoHVscNmO9jh
 nGIHiHER7hCS7a9WuXX+k2pdCd8YkcLNfKOGf0mBFNaoIjHOdHKbYPhUiFged0MqBuNm
 ZS704YQ4Uu8xaS6lcnyi0DdqYxgKM/p5a149nEmXcci5tu+l048470H1s5BYCacRETXE RQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdxbbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:13:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0FOMb035368;
        Fri, 12 Aug 2022 02:13:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqkr0vx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:13:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDGgV+o9j2Ju+X2ItP0JNhnu/ow93g3k7Yai3AjqkncGdlRQsmkLU9G0utYf/5KdfWxSsNh4IwenizMN9UVxsPN9WoIHMlITYWZ/mnUcCIG8AB4sij3SlM6vIi7a4FgQx8o9Fnnp2ejEn3AxP5A76FUMcGV7SBeljzWZTP2C/30QyF4Hmz7Fz1z65//oAKjUb9vgAc3CO6BvcuCcPqE+gPL2vTGSrqo4yQK3R1sMdtcv1vzP5t8y3uGDIGEaUA3FATOSyQ2A07BgtkXcKzJ7fKDatSJB6glSGQ7xWqEkJP9YODurnJhl6fKZ1RnqU1F7zJoTWcJQrCGF6THX7LBkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ljLrMtUYjM1RLDbwXke0yKCmDPsfQ7jO40EPd4d3W6w=;
 b=cuCCZKGQQcZekxtPfsic3xiVbRLi1MgujoowkfKBjAkM5AY+zjH0B9lzXMFM72vtQA6l53eRitT7ps2x+nMqUfd9KRQK9EML0FyGkpEWGIx3m4PXqHCmBxn+G4LDCH2Ss49fh+iBIfq4E4LRQgFWr88DJH+8XgSZ5xarjHIwr6yzesmFo9PTnQ3/UtqrcwHjfm2DZnQo6V9klvhZiMp5p7Tp4FCl0iLzQYF9KJjMVEkm+H14CJXljQzwa6BvCGMcUT9Y+dV3cYhJOnUqP10Euw7AiaKGfy/CCvG+i0ZIGFIuTr8H3hxU076Agz9YQO++ad05VBWzWXduaqr8jvkiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljLrMtUYjM1RLDbwXke0yKCmDPsfQ7jO40EPd4d3W6w=;
 b=u0jtPfUs43ZWKZiZyD2kvLpErhXyMb+drNe7+3pE+i2bdXRVZCts/E54XitAeiyjAlhkUXXrvoNxa4CFSfXE4VcEbLgtZSygun8HWuGeE1wv9PBDHY8nCpOXdvW3nrGe3HlN9rZPcUScv57GwwiR/ksbq25Hzpmnj38WBWoHZEA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR1001MB2327.namprd10.prod.outlook.com (2603:10b6:910:43::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 12 Aug
 2022 02:13:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 02:13:52 +0000
To:     Guixin Liu <kanie@linux.alibaba.com>
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: remove unnecessary kfree
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnbeky3v.fsf@ca-mkp.ca.oracle.com>
References: <1659424740-46918-1-git-send-email-kanie@linux.alibaba.com>
Date:   Thu, 11 Aug 2022 22:13:49 -0400
In-Reply-To: <1659424740-46918-1-git-send-email-kanie@linux.alibaba.com>
        (Guixin Liu's message of "Tue, 2 Aug 2022 15:19:00 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:5:14c::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39afc017-6ab2-4603-f8b7-08da7c084d15
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Mrb5ZqnBSuHBR0T8HfK/yLQWC1O9nTy4Iy1+BStMlQEn5zL+i2G/h+7xO/vPHBN73T7hNk5R/qtr9F09zkYko2vLXme3MNccvwU0YNAXnO724MyvcQDeeflD3T11hdYEULErDd6fTLR9mXIkTQdabC7WjocirQJcnPBtri+9XYtuAw+sf20A+L1os8poDfoBd6jGQvLHUytBqaDfo4cek7gwRn0o6c3f/HA8ulk/CFAhRCpGqSRfgqny/3ilfVrBdOWAxxh8GEOx8e72xTdeA2129AGEJfntx/yN8Kf+2M6WyUwu3QP2tMKMQIrcx/hztJGrKkHX3D9duUbZkr6rzhoWJIOpHV2lzqqJDq9GdhbaOZbl3Vy0wqh0p6NwWWHGbR55BE+ZIE1mIFqGfbYOHkqQwAv3zV0hob6a0wVwXWx1en8m4M4UxAmnRTRtxBUkOyfAYKGO5Tjbl/hUTOuUNOXbEz6a8RngUuTWbA58/yCBvrwfjotEpOGKw0Qy9ysPp0BLsU76P2/br6J0mibeHZNhFCVPwiQKApK5j2TpHYaGJuG1cLrpbW1Ae3/Jqf6rh3GMTSi8J8FqGlqvKO2UuOwH3yvyNB4bAARW9jmtzSmj1azG4NsnWmNxzUlKJ4Rh8ETuLMI16QwGx9DNhPwxVHUZ31ajUeMNUV2R9Kg4IsjQxES8vitfpMKFlyNPOoJbSZHVdtbOynDyHLvMvJENwCs4fLDxS1fr0L6sXjLUxfdqHvIdLyAVHjLHTd9FsTDGKGar7hZkOhG+idkF6x+G2spkeKOehKXFnS4u8BF6ME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(346002)(39860400002)(366004)(396003)(41300700001)(86362001)(478600001)(6512007)(6506007)(26005)(6666004)(52116002)(36916002)(558084003)(6486002)(186003)(5660300002)(4326008)(66556008)(66476007)(316002)(66946007)(8676002)(6916009)(38350700002)(38100700002)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?06OIDvwfGvnXo38uxVZU0cihkdgKTrUagYH1D4jAHUyamoWQUTP1Fdz3N6p2?=
 =?us-ascii?Q?0s9GIJ60BKGfq1+fVegCegW/cF6Vkrpa7wfF2AUcxOSbUk2SJ5iE0NP6e8Fp?=
 =?us-ascii?Q?CC17JlbBtARkT5d1ia2DYs9m+86bSmrjH7NOqYRv4oUEARa0YN9wAEpS+1Wl?=
 =?us-ascii?Q?uXVAajZFmCo6lIP9iSzGQFIkF4AnSTu2zDpGdXe2umPrOcW2nFDfGNgkEsjX?=
 =?us-ascii?Q?RxGCuR5Z6rnrGSTCwN6brF5s8fS/26eAwKt0maqsx2Wnre5D+fbWwD5zZbZD?=
 =?us-ascii?Q?9LvuRcJuNFG2z6So4HyPw8ujx/hg7Jc6e0TbRPSSafcndWfglEl3EFi8OeV8?=
 =?us-ascii?Q?ri1A2RBP+PkA3Y6fl16qmF/cMCPA8Cx53/ABKY4MMzE5RCHQZ8fHnMeTyHxI?=
 =?us-ascii?Q?DFUtCnCTcXDNULWXnuABLS/P+lHWVUuB0SRhqCKr6DsB5as0chjeQ1jUII8F?=
 =?us-ascii?Q?sXcWibUQdUE67AzC+ufny8P/abQ8MTg+Hl/dA6w8fQSRoePltKzTW27owxQf?=
 =?us-ascii?Q?Vkg1H6UT2yUlEhPjI7dPE864SNdhf1FpgvyS3rek6jXz233eDLwZQBeBY3ot?=
 =?us-ascii?Q?dMni7XF2Jo9zgtOvjFE1920RiSyFgrWD9Z7JKCpz37iZLJkBf05kAAKGKShk?=
 =?us-ascii?Q?YHJ+5M9SVNJZvQ1n/rq6+VxMWf+S86xVeG4RVbDc5azZiY3O/VRfge3Ip1AQ?=
 =?us-ascii?Q?QUK8Lkep2Vc8252FofbjbMQonq55TUY0+/NqWE2dI8WgHUjLjQJeR76aYPWF?=
 =?us-ascii?Q?PFmlAsfNNoFRq7ehAO+U6NktEubx93AB+1BOGoZoVtzKv8sEfLna5XGZUWCd?=
 =?us-ascii?Q?sDBPcOmSqN0q2FLRgyrQ9OoDc4Ux6xJXGH40I1EHTcy1BXzOj5XrVrxXp0Ca?=
 =?us-ascii?Q?VFMCL7weCxVp3R+ZinqZ5nEo0z/7bHzgPpqw+dbD5c3QunHoNMTs/iShhEwf?=
 =?us-ascii?Q?HXwFDYF1mGvzDVJ/YbLG7VH94Mat1cbIHy8k1PXlFhlUVRRStjhFVwVXwG15?=
 =?us-ascii?Q?qXiSSA9DAaiYba4cixiW+ebqp9uGiS3Mh9Kn34sFqDtyxZCfUw/wcvwaSliZ?=
 =?us-ascii?Q?FqyMxarMVS2rR0nmmSLfsoBtGMXD3zONXCI8UGtUDLKNaQCe1KH5NCj4Ftpp?=
 =?us-ascii?Q?Tynyu3PiBVMF5feZpCuMptb5ftZdyWYA9XCDfWwJ/llNmDrOLQ4J75YLegMk?=
 =?us-ascii?Q?Xq7OwwZThmfwVA9MTHViA6FabYxnyZWVEOBcuG1ToSbrvpwmpFhKnmNn6PFr?=
 =?us-ascii?Q?l+fM87J/zQ6D4VFgaq+ELiJNFn4EwC7y2kcpmTjpk/6wSxfgnPhvgMxBu66y?=
 =?us-ascii?Q?rDrXN68Se3Pmjl/8tFBuaorCrbCKkkyxLWLkmvuhHab3/J0ieNZ/kHUPZ0dY?=
 =?us-ascii?Q?5z6SZL5XcOnp76CtfURf84uWU4vEfQ1EAAZb9MimON2m4+5nTrodpxXAA90k?=
 =?us-ascii?Q?zxJuUO8ok+c2ck6tsRmCkiRTOWf1MVHkcCcY7zxgwpqTpKFTlLGYEf72iG3h?=
 =?us-ascii?Q?/WRhHxXpWjI5RJKhT5xxhgOKAXmbDA6KkrlLIJdP2yj8WAt28hbnUREPum25?=
 =?us-ascii?Q?aoSpCiEZ8D1UPxF1YwcllV3ZF/Ksi9mYG+G9nUGjXhhZFnLvbfjZhhTsRmgA?=
 =?us-ascii?Q?Ww=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39afc017-6ab2-4603-f8b7-08da7c084d15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 02:13:52.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vDhpbwsnJJOCXEnnFkVOZfa/AugUPiv3dmd5i8o9WAnCXpJFS9sLjXjmCzMtRWXsPpFmWzcwcZPOW/bdWVSLquPrZDPTqF6tKxIJKkmkFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_02,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=803 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208120005
X-Proofpoint-GUID: LGWFdnEvkGYGzllLyT7CkbReBmZq9phX
X-Proofpoint-ORIG-GUID: LGWFdnEvkGYGzllLyT7CkbReBmZq9phX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Guixin,

> When alloc ctrl mem fail, the reply_map will be free in
> megasas_free_ctrl_mem(), no need to free in megasas_alloc_ctrl_mem().

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
