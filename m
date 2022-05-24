Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25097C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 03:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbiEXDY7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 23:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiEXDY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 23:24:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACBE7996B4
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 20:24:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NMhw5r032387;
        Tue, 24 May 2022 03:24:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=jCXIT+Oa7cUc1hTw9pcz30pcpN2E1giXxP464j86SfQ=;
 b=PDP0bb2QkPNRYd+1tUqQNH5q/U9AjwK7IfWLtG2za6j1DRnIcZFc63yGC8v51rxKUQaM
 E/i+F8Gh+BIi6wBuIsAHtttqucIDMA+0sJcERlzkXQUOZvltv6gEYoXkSfroMH+macmX
 w+JP1cqSSSUoozPyCbvth4v+x7PIjG10l3pa1dZ7FbGnBsUhPd5TOmEFU2uUS2/2uH21
 TW5BRn9WOdWTjsALEGsCKrjZcex+AzNGPF8djfrSNe0kAAf/vLSIKkoHR6E9WSAjaTkO
 NzB5LTzlrQeek7hXKRpjoV/i1fxcivKWWn+1OHnTnahq05VT2YOqdvQj8+XyAWW4YUCY iQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g6rmtw2a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:24:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24O3AHh0008895;
        Tue, 24 May 2022 03:24:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g6ph7vmug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 03:24:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DySe9GB9Q35ROQJRnPmFY5Pd4J0EVaB3lKq9qN24KSbBIT3k5WRpkfVPz47H7LNYmRzxgVWTmRIT0QA+IG2vk/Ys0RWv6YBXnLi/6jJspHjLo4h8giY9zG1K0Bcx4dNwdjK5UwSQXRoxBmgINI89P8DtjFzEFmX2b0XOr6dk8eDdaQDMX550JsGXL9w6Zje346TdczXQZ1uSfYAfpDTSz0sEzqHH9ulvthsEoj+NEk5VWH6RQS5C/lc9ZKnn7SrJ+KDN/fCgT5Ex3qRdeoXlpVZENYO4a51LqALb0dN9l/hC7E5lJswfjfMgU/+jJD3h7X+DCLOVWRaYm7px92kfSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jCXIT+Oa7cUc1hTw9pcz30pcpN2E1giXxP464j86SfQ=;
 b=hpkAOojHz2A9UvhJkqFgItzDfC5gPQl9KcTMWFMiKU0w+Yej2IPtA7G3ORWIxyphruYMYs14lPb9MlEH07eRAz6nlyflAnWIP8NERTWWE+8DWZB5JbgsRIiDVqIO/1X+ZU4pZb/03JIRdRqxcJU04JvuJoX3p6XPwIi27Pf8cZmlPLB8nngH7E/Cb3J13VPZQ0VIJRtrtxRvj+ouiJa34wmW/59YDOplp+gqdM2nQMFuRNQwuwnEDMpzguJzxci0o5thCIj7CdpPvLjY+M1VKTlsTlny7oD5ma9k1Asha/j4uGSZfu9T9uw3AElTdmL3blmMMffmVhXKYOSU5t02Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCXIT+Oa7cUc1hTw9pcz30pcpN2E1giXxP464j86SfQ=;
 b=MHG6pT1zIWyO6AsqVDN3Bz9jcQoK3hzhCLMNxqGjE0rfPI2zIPeN2DWBJMkiq9ejydyfkaLGaSZ3QVjTCYjFGjXeZl3TOq7EzEK+s8nLHmlZbo7LA3da7+kpURJpgp2iZLdwFvajyw2q3AlNrVXtVZkcSA+3B39bQv2qHBEAL/w=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MWHPR10MB1327.namprd10.prod.outlook.com (2603:10b6:300:27::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 24 May
 2022 03:24:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 03:24:41 +0000
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>
Subject: Re: [PATCHv2] myrb: fixup null pointer access on myrb_cleanup()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d6bhatr.fsf@ca-mkp.ca.oracle.com>
References: <20220523120244.99515-1-hare@suse.de>
Date:   Mon, 23 May 2022 23:24:39 -0400
In-Reply-To: <20220523120244.99515-1-hare@suse.de> (Hannes Reinecke's message
        of "Mon, 23 May 2022 14:02:44 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:806:d1::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3772274-c499-4170-03fd-08da3d34f098
X-MS-TrafficTypeDiagnostic: MWHPR10MB1327:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB13277275B31ABEE73201A1F08ED79@MWHPR10MB1327.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smarQdiV4Okz+vXAEcKXglyko3N6RQ4pxgMrLx7d8rF7gIzI79TaDdxVx9Eo3Omdz5ivK6N6MEGcKDp1inl3w6luxcVpK/CDAhN5LO6BW4HGtuKC/fZJZkUBu40wDMbHjyGYD0gg7zN+COQcGxAyiaUojbooImEN2yxIxZ4XDsqCPFcfMbPtaS+r+3yDtKZRi2sBb77pEcGB7367V8KKwFMTAHXoz5yBkJJJa7BZihO0Q4TQR15V4QXyEIlgm9sPtC3Gl+ZRhSzNAWFbcQKoa1If4I1eXODYoEqCO06Wr8kAKpvVKvWPXXyPDg10la9ps+hJ5BEBVOqktr3YYrHnSyj50xmhxCylx9rs0ZrTzDWBZKuEQe2UWFtX8ZZ+xOziwR+mduqj4Q0oX0FEdp33mJQjkqKXVi5IKdOWzzngz6uKMW/RG4P0QQ5ouzjJezAI68Vm8wlD33/O76AhouPiWmAuYZ5uZIN3unKE5swnHphLo4DMOB8amaGO7LHBbP5Fu1CwR0SAZATKRwOW02m4BytMNfOrDnRoUeDRi1tGekJOyQcO4tJtFzBzdbdz4WJ6SaycoLrfr3fU7z7xLrb7knFhxjRShXBoxF/fsAFu8EsIYRDxsJ2snp7zD8gy4Do57hLpFBmsSyBXzeJeB/8a/NHphi2DEmtdgRT/HpwdDgAFEzx0lrrSU0qjOd2hbE8YsclRNagz3Is/mBGQ5Jnjtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(2906002)(6512007)(26005)(6916009)(316002)(38350700002)(54906003)(66476007)(186003)(4326008)(38100700002)(8936002)(52116002)(36916002)(508600001)(4744005)(6506007)(5660300002)(86362001)(83380400001)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZnGxBhU+l65B5zOEZ/lsF3aYLMA4At8v9uGLfBTjKkTno49dtUTxrqDdGBqM?=
 =?us-ascii?Q?vv/z547UPxgqG7TvrCrAoMBT7K9/I+RSaADXkFN4ttW5gnZUnB6yxwYP0ni9?=
 =?us-ascii?Q?aq3If3aPnSxjBHMn7ZF5kcnrQ94ZOJmlnmGN/3AoW6zD9Wv9rzHXJVZO0wts?=
 =?us-ascii?Q?iNTZEHxnwA1DzCIxXYcog5AzZqyRf2u4czatRp8VlRpvsGQAzGhLuYzC1EHp?=
 =?us-ascii?Q?F0MfsB0p7guy7B4+qlvhF+HHEJKkickxlA2bXLNYFKy0RtFMXoWmdg0TWgqI?=
 =?us-ascii?Q?QFhi/nmtgqj8KyWNW3P5FV4TR35HrLOXpVdx3dfnNDbWBUWGZ1Z9NseW6R+U?=
 =?us-ascii?Q?nk5NOXWA3xxTbQuvclbb+ZUHowRfX4G8hlMKyiKKb+km9SgmhEys2c2f05CH?=
 =?us-ascii?Q?f43cqnUoNyE2EE18jMIMA5wdUIKb+CDdowTEJwO3MaQJDJIqMeyQhirlfw8V?=
 =?us-ascii?Q?tQFf0C/x3YEcORXtgjQ/cJO+3n0DR4jJfoNI+GT7WHEsP1mtyF0d4DQJizAA?=
 =?us-ascii?Q?H0gdtFqNVqbmVT9iHTLkJfRDQbgLVd1lZ2eu3Ev12vZWwKcCRmK7RW0c7V8u?=
 =?us-ascii?Q?PiBqSl3EaEEBVwrui2Ngux/netvxihEgVTYfF8q0l6H91FOH/jNkj5Tzuv5e?=
 =?us-ascii?Q?0F8UQnSF351YgT0eXRvQ238HYzfu3SSH2C/rrCQjghsAlUU6yb1prAQa0CcW?=
 =?us-ascii?Q?K009VpcTkA6q3b+c+1ukxcmw4Sy3pLSxLDRwLIQqbXKEgywTqHj1nWydh99t?=
 =?us-ascii?Q?r1l9xXCKpTLqY/7yGKszYdQdMLU7Ps+SLeoHg3X1YBMDwnZN3I4YDsCVooA8?=
 =?us-ascii?Q?EMCa45bbBLL88UwNYgbJ0IWOiarn0jw0xnaowInwbMRL0BZWvjTlXEip6QMK?=
 =?us-ascii?Q?zNVQsASNq9g5LDtM2agPv7nvaFtAsaAdtX6stvXxPlBQyD37ftf1ElfyhF3t?=
 =?us-ascii?Q?+VBbbKG3IZY9ayGDpMQCeJLF4mYIvEF9VlawM7gNFwBnp6H8pZFXIam7Chcj?=
 =?us-ascii?Q?E9MfjOqo1axTBzwreV4+of6BoA/f/5+yAszbuE//nuxqtcDVSj1FeX5GAp51?=
 =?us-ascii?Q?tH2acBxpI3S8yZfP/zF5rhr+6nyf189vO0PWZP7Emmf/jFd6FDElmkvK3DW9?=
 =?us-ascii?Q?s7CGbvlTZc2OjGxbpzsMcMva3F1dSeIhdOyP+UtJcd1zmYmP9VLmXrfv9uP8?=
 =?us-ascii?Q?u13NaRYv0sNM6AdypL6rE712HYITZA9dtNJiPJTK6/YKe2EA84K/MpWEqE0w?=
 =?us-ascii?Q?54GGfnFg4qL74A7ieMxDZmSksPhTC0rUW2IA9RV8ZdnTtGDzq8RQhXeksMv0?=
 =?us-ascii?Q?7vaYl6eIHn5KKZ/CpRrNzjf0d1yYRXg8B4ov2VuWw96ggpXtximJXzsW2McI?=
 =?us-ascii?Q?4noTAcq0NW6iRYJd+AlcDK/Ql8dOTNmQykfcYojRCGnbC/bFgSygOtZdomGt?=
 =?us-ascii?Q?5VBLkDitSEO4vDPLDtu4tfp4+6v38/LXM8qMaolNR2OG/JUQZjdP6lN0TZQD?=
 =?us-ascii?Q?IGLbjOiu863F+24SEe+vR0kzu+MY8q4VnU0iS0gBoiMONQ781ugaysxMBtwj?=
 =?us-ascii?Q?FiV8cvyiKeSDqXSUI5y9AHc+PFKMa7T+A1S0G1GFWdxbxyGYg55JcsM7pJNw?=
 =?us-ascii?Q?vPSiwKstE7KoQSmAFLUwiqn1/k2tu6JqW4nJqSL7bD9ZM4pHDoozf7t4jkEb?=
 =?us-ascii?Q?qVF2iCatWsPDs3MxxaVeeeuvCWybeMhB3msgsXrI4k3l+eSWDQJp/dl3ePvg?=
 =?us-ascii?Q?gpaXKdMf7bmrBRySdSsLMP3938+ZHcg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3772274-c499-4170-03fd-08da3d34f098
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 03:24:41.2153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tyn2r+vyduzOTWrrM5W1eme6ivD3rNUDYHdSWmVxyuUa9wD6t5B/cf4DhGni+AnnrfnhiwAhNDZ4L/71t3EzALvlV94MTuUIJmquGHISyOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1327
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_01:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=722 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205240016
X-Proofpoint-GUID: WzHRIuiXwf11TingpBbCqxAE0UHeneq_
X-Proofpoint-ORIG-GUID: WzHRIuiXwf11TingpBbCqxAE0UHeneq_
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes,

> When myrb_probe() fails the callback might not be set, so we need
> to validate the 'disable_intr' callback in myrb_cleanup() to not
> cause a null pointer exception. And while at it do not call
> myrb_cleanup() if we cannot enable the PCI device at all.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
