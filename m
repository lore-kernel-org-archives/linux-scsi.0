Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79090C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 03:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbiDSDLB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 23:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiDSDLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 23:11:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B442DA9D;
        Mon, 18 Apr 2022 20:08:19 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23IKwgfD019298;
        Tue, 19 Apr 2022 03:08:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=t3uev7ASPyL87AJEh/QqNiKOIFUCU8rfFYswUbVrq0Y=;
 b=kGEroTsKc9iDE2POdijDzhbLlajmYtmMxR+7QnRKN3fCRZWnR9lqtITK+Rzsf9cl5eR7
 RZa6jEWWvt82Aa4WiQizAxHLjiGaSg7vyXgJxhZPNDzeCDckaBOa0ObXi+kJPn89/E4e
 Ua45KQYq+mkT9MCY3iirUw062G1DmoasYd7UjPNfhRCrOM5MhJjE8eLoI4Qq/8rSy8oG
 ppwah4UVybyjgiNiNEMt6lI8o8ieBHLZWaaOwKZw+48QTuKokIvT9B+h/O7w8ZIAE8Ge
 8uXRdJ3NUupICjbE0bBtRXz+19cIwuwvmyvY4+hliFlBG5ZsFIzxYlo+1QaUN7JCbLJ0 Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffm7cmrdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:08:18 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23J36b9b033002;
        Tue, 19 Apr 2022 03:08:17 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm820fbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 03:08:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5gaE7xA6mcMX7uv1C3bKLKK2Pa2H3pwQ5nmzV58h9+kmDevLNgq7O9+aF++YlH8nv6UX9Gjv4GxbClS6t4R+dL7rfR+z/v+G7aRFMbddo3lULQpTeg9f+2y+M99t82XHYM3qL3LUGXO73Jfz8xQhQbQ2mpY1MEwDsXxY4Kn4DcnggmdFO6gkaO3fiezqqERoebj22/GeZtJJXtVA+BlPCowf3nmKK1GjD6WoOuq+AsoW/epWaZ+5Gr8fyrxWx45olRYDqCyHddIyQb4SIcuOwM896MDkbi24zWRCKRNZw1Ie1ODBEhMbADRwzQezGUBJyKcTHWov/k7TqS9awrMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3uev7ASPyL87AJEh/QqNiKOIFUCU8rfFYswUbVrq0Y=;
 b=DDtbbR0Ik2oZMAKsG5HhWjU5i7a2bcIMr8O3Fgw0KiIAohaSrtpvinVfvo0V2vtu8NP+6W4WPhufT9fSKZuKW6i0JbIitdzOtZD/Xw+oVDfJHFfawHpwbyJWToohEsQaQ3mRQVygPw+5vesUW9qfKJZ1M0lKJtBH9rZ7SoILhloXXng0PTmyMa/6sYh9kCIg5o1X0S/Q2aNmA+5KNlM9dtotiDO1y/7SR0eSTVzVg7HdW1G92KdtbpZRwitLZ7CRwcJmbyO0EPvHSswLGopBk+dq6Yd0SxYBymHdL39hGQSL2i75fnW4YOVqDcFTobbjyL51qabF0rrFyf/1RG5WRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3uev7ASPyL87AJEh/QqNiKOIFUCU8rfFYswUbVrq0Y=;
 b=MD+wiBTU+1Otu22gPSJYcY1Q9/pvffAYVXMaJ6F0/G44q+qBk4NyuLPgnmwGuhbQ964UPpKzxDDJsE0sJfSqfXGtj+M3YyhgIcb2R4js3by0G1XsUpDwZMGZfu7dbA9yMQbB4TvCXw3RP4vnH79dcVhI7S2CrZ9XJBTg9c2PiQw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB3744.namprd10.prod.outlook.com (2603:10b6:208:11c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 03:08:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%7]) with mapi id 15.20.5164.018; Tue, 19 Apr 2022
 03:08:14 +0000
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] scsi: target: core: Silence the message about unknown
 VPD pages
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r15t93gh.fsf@ca-mkp.ca.oracle.com>
References: <20220418212622.275516-1-k.shelekhin@yadro.com>
Date:   Mon, 18 Apr 2022 23:08:12 -0400
In-Reply-To: <20220418212622.275516-1-k.shelekhin@yadro.com> (Konstantin
        Shelekhin's message of "Tue, 19 Apr 2022 00:26:22 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0007.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d45509a-faa9-4f2e-de25-08da21b1d833
X-MS-TrafficTypeDiagnostic: MN2PR10MB3744:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB37448CC72941485D06907FA88EF29@MN2PR10MB3744.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbaIwIT6JkYWABYfllP8ozBjnlG6Ja1VO3+Crc88amw2SfRCAv/fdK0sGiqjpqRzzB/iUEASUdBiT6vvT+nr1JdqxMK5K/u6nV+b5WMvIwpVjvDycdkNuAI9AkcBXrQ1kY0psTPtDue3PzJZ2grH03AxzUACOe92oMlwirnfdYnsDV90eaAyUN2Cqp6ic32o3xyVKuN2RLIIHV58Nf30+o6MayPDMMWZflobi04/+PcW1vafPrYv8SqGZ4jXofSZ+4j+DRBjWnqUmNAh+1ey+rMf+IvphSj6RNPpvCqO2wru+NkimegSMdhpmjYKtW60QApcK3ty2FTeWVoPtmyQtCAAHaa2XyQfn9r//n2xQwGofVUWGuawjAWEd3J/TTUDPppN12JOZO6bA5qEhV3WyIDH+qtHLpsfZLE7TQ/ofqm296T2Fk36kByRtbyc4xKBotfZjDWcuA9ph/VZqJCIRJ/2KsfELcwKnFJ1x4G7q7vxTVzwLV5nUc558lM8gKGgSRU4C6FDouII4nSWnmPxJpUzbburaM531qT8UXGHyP6QK2rVPYZxZWubKtZo7bR57PsYX29OUpbXzrJ6mwB0Wg47LDX0xPBRRp42paS85mwiVIzzoTrvOtMZkl0BurNVJJKmFRh4Q2r5A1Zl7Clu4V0wtcbYFjXSfj/EcYE+zcuNuWoTFUHyy+HUDCjTHc24HD7mPekasbYrdKTPpDIIYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(508600001)(66556008)(66476007)(6506007)(52116002)(4326008)(36916002)(8676002)(38350700002)(6916009)(4744005)(38100700002)(66946007)(86362001)(26005)(6512007)(83380400001)(5660300002)(54906003)(2906002)(8936002)(316002)(186003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?68wOa0lxdrYvE37bG8FhC85b3isTIrSxso2TFiO1OPgB3z8zG0mGOWK8Wb/Z?=
 =?us-ascii?Q?KaLKujZAd7VVlfo/Hqv6ZcjsHBsZUYY4voBSzFK1geqyI5jCAAkr+F9RbvPo?=
 =?us-ascii?Q?QJ+zrjeNomffBh+AYvqpDNSemB2wYoOYnkP4RUPMdkLOC60Sbgz4gF7YC8MI?=
 =?us-ascii?Q?CyalfOof/pl+4Rp5ZmQpyb6jreDXFmq9jKB01/YZbcYcHm4PEOnBPx95RnLE?=
 =?us-ascii?Q?1WONaLyWh+ohx8n1gwidPDcr+Z35lEM39+Wokm+Zz9V3UqLuh99foor+lZhP?=
 =?us-ascii?Q?aztj6nZTIEXsn2EZhyFji84WI2+HqMRjKsg8nIAAvwUa4AsYl2xSgsNFB6Qg?=
 =?us-ascii?Q?MwM3mWcy5zLH8Q4um0I/Hu80G9yF6AeRjZZABwRoMjzukeFlipnxhf2K99cB?=
 =?us-ascii?Q?8hSrP7aXlp83oNe9/V0XOKNER31ztKV4fZbn4RJy1MAoxYivJXqyhq1l+1G0?=
 =?us-ascii?Q?HH5QtctTryKmzLpG/iGesQciQ2nzNzgMmbBF9OTlOob9/ZurRmrlhPZhFbkp?=
 =?us-ascii?Q?VGC6RbuR2eV/mMCV0lYFatD3Lt8Hkabsg3sHqJh2RHr2NNcCcqJfHiezwyBg?=
 =?us-ascii?Q?6IQ3x6XRf9jmJIs0pBbcDe5iHOYZ5s1o4E2zBxC1TMsQxLZ0OnJJFYieupRx?=
 =?us-ascii?Q?q9dLb3JZDILlh07c2+/oTDvJxp/uwLxSHvqNmi1GlJqJo3jBlTCexTVy5kzJ?=
 =?us-ascii?Q?Nd3gbPAuLXEQHAmm0s0ZQA7r67lgwuD+qyaTaD73yQBQqDnob39iGyl/k6uY?=
 =?us-ascii?Q?FNXgdkIFG9tdd1LFZoYcv8IEbBE9Jeh9lxNYG+DhROx6uvU4mwDkHlSoohUR?=
 =?us-ascii?Q?SQOOaSpovbSBY5SXegslD7YfLthKDR51VFWD5M37ezOU2jLzVnLUz+/awDBl?=
 =?us-ascii?Q?yD8pzO89hgk90IOxUJBMfPYENuE1HxiH0AQNF4LbCrza2qilx3xYd5T4vkIY?=
 =?us-ascii?Q?zAbZgzJ+ptHEqOMIYiY3THTAGg5KCJC0fcizT415FqEscXEcWDl5S/OUZfp1?=
 =?us-ascii?Q?V5b3KvNUWrjru/5sdKIUE5y5Uv2Osxxd596gBW4W+/2QhVuiSQhBWykvce1F?=
 =?us-ascii?Q?E0h736V9KA+oaOMpvklCAh/YXo2pu+uvcpuR15SJWEtqNDD8AU7YaWsiGOAr?=
 =?us-ascii?Q?HDxpcvS49dSn1MTgTxNHqwwt0MpM6fHqm2AGm/2YZzXIRlmzQKdtRvP2dDrW?=
 =?us-ascii?Q?08LzEGKMcLa3PUzzg5rA1GIj7Qt1Kj/oF1BO1hUc3xaWY9574n2CDJ71tbSa?=
 =?us-ascii?Q?8qLjCWDOAUOGTZzQb8i2vX4HRPEEM8ADbuhE5Mdu74t+qy391+8CAtRd47q3?=
 =?us-ascii?Q?Q/A8GUw6hdU5RW75spzxzfm/JnjSH3XYle6/OSuC7LDJBWSkjk82PM4xZzQ5?=
 =?us-ascii?Q?2r5xlMgxFOGoCtPOZhjepTHTO+DQ6IHiAz6IysySt4cyt2ReVe9/s8a7j2LJ?=
 =?us-ascii?Q?uB5SYfylHMMKYSfg9SJRtAb+kvqqPG4KRrsI/c6ElcFefL3KxS/DiOUiQbLM?=
 =?us-ascii?Q?zwNz9CVaNEO7jOIKvjVQxn3CHYVexI8hzjn5qSTW2VQChabfE9brP4SrSq43?=
 =?us-ascii?Q?1155BfwVa8MH/YQS26qGiSIvy/ZYKUkYVH9DYfeZgLKXk92ME2Do4O+xUFu6?=
 =?us-ascii?Q?8Nvcwelg8i3beUhzeFaQA4bLR1Iu2LYGPjg9azuWEZnJ7MdoRYLrx8UMtrxN?=
 =?us-ascii?Q?18hVq+7Cx0aRVDnE8ZpiyUaQ5sRGoH3YSkA2gQv/7IKzDaY/kDRb/7AV5U20?=
 =?us-ascii?Q?ZvpijRwiXxqvCnUrb3OnMWORPgiQ7xo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d45509a-faa9-4f2e-de25-08da21b1d833
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 03:08:14.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dGRdQYN0ZVhDrU6sDwLb08rNsrN0xlC1jRgzvfXoel57v/4/o6mft6lhYPdvcGfSzmhAhA9F4ZOrdLyozum6/I3dUo6r2TOJTLbPaqklmMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3744
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_01:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=761 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190014
X-Proofpoint-GUID: JdzH9U75vhRIsSLPDbmTc2qCQww3eY2X
X-Proofpoint-ORIG-GUID: JdzH9U75vhRIsSLPDbmTc2qCQww3eY2X
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Konstantin,

> Target does not support some VPD pages and is very verbose about it.
> Sometimes initiators don't bother and just keep sending the same
> request from time to time, filling up the logs.
>
> This patch lowers the message priority to debug.

This essentially means the message will never be seen since it is not
particularly common to twiddle the syslog level. Have you considered
pr_err_once() or similar?

-- 
Martin K. Petersen	Oracle Linux Engineering
