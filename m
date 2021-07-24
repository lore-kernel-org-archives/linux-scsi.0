Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C71C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A2560EB5
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhGXBei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18586 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233628AbhGXBeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2ClpX006595;
        Sat, 24 Jul 2021 02:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5taLq0627g64NOfnrE511SVzjoiuH6MarNpVbFk7zWo=;
 b=ojpnMinVnSKiJzMz+gZULRRbLJVHNhHs5TS9BUk9hvocaOKqre00dHgNsS3W1PyrzE2u
 D5way7yNyjO1gGaZsOIeJfHuWfk3M8TEshcBppvoa0n5kwaCjaXD3PuTelDPdNzUnBOT
 FS9IdfizwTo56ZnVOzA/381ovnRA4gYkB8Tlk087mookswybPMRFi80QazpPcHWPN6by
 RLsyF9uZ09bteDQkdKpJKCWmdUeATB38BRbbGjREUqX+AuV+Y5ReSDKvxAw3jELAMiew
 OmXPZC6CZmKJ5ORl4bXjc0/YHiTirGHXbH8Ux5fwASP0T668N5JaNFicAh9yocDquqEu vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=5taLq0627g64NOfnrE511SVzjoiuH6MarNpVbFk7zWo=;
 b=Pa0HLravec0y8zTi4IvjT8qDOMfu1WYImW+TXtlp++t+QHu0rjxvEbIiHrirrQ12zEAz
 q+UbPa++zVGb+bIkR5GEHVBcW3Qz9TqnQPcfioaZ9uM6JO4ZnpZwQU3s+XXVv6fv9GNu
 TVD4QFOuUCo6llHkgY4N1vo3Mw8rpw43RXrft55gyKW3Zpz3qDEc5ceH+PKSvnO4Ap6z
 nwcnw+scYRynyr+TyTn4AW9cgC9CwpYmxDEQXrEh7mWkRhQ5yNMt6rCsYixuhWmiqTy3
 9j+/KYT6hT9A1Urly3ktAG+tqiAP4wwXXwBihLPzpJTTi5Qj5cGNfLqbGZmgeHzsG8XM NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39yj7fjc1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O24eKR066066;
        Sat, 24 Jul 2021 02:15:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3a07yrmqnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpGjLMd44X9LN1WdG0E8dmyKlO9GnEqwfi7qpoDaYAqUbDX3EC/CT1RgCbhatHd2kGvhJ0y2Pc0rDVCAfAFH/njrR5Lk1NZ2xcQX/Cq1eKZDZKZdJr/FrVH3evgJEBGeaUuW0yLU6lMfrzAGItuoRiphdmvU8i6IT1EtsQfAb+BGlL+95e/tmjZQVVMypVgKfTZvB5BHyw0qCr5Vtkn5U1ASOqxgp9w/0uwJ65j+4XuMRLnAu+830O00Y/CAGM6kpsHLPVBKZEkOWtevP6tOrAxhK2Bwa1x0EHilsjRxVvBM7Fkg3ruTImQnPjsSZfcpVegPDYGpn0rq3MCkPd/5Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5taLq0627g64NOfnrE511SVzjoiuH6MarNpVbFk7zWo=;
 b=BASZ27qsqfAYP95pqGExVn4LZ2hoha6oqr2hMfFmguFBsa1pyVLKS5wflsfwN6ixZWCt8grCyh4wlrWBw61aBKxaq/2Z4TactYlD72G/pY8Yc3cYCxg6c3OoIb6dceyftN/S7qaIVRNc+N9xTmL9ENIafQ+SdcZb1CqP2PUSqpvFtEIZKkDxyAfjNyZKVzzPUJxmWWBC3PbelwrI/zV6EmEqP8Zfp4G8BbDxe81niExMIZY0LtFgbZQJYwIe+0bV/TYC5WGH+DoCkj3ksemNCWsPd3HzVTLi5ueI5ivjdNR4Wt4flKBwqYuThkfBvGnSmrrV3UT4jG5bHFRLiv1M2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5taLq0627g64NOfnrE511SVzjoiuH6MarNpVbFk7zWo=;
 b=To0qRumjB9im7zKjOFQ75+jl+u94cNqicghtuGeysY0vauHbHbG8c2eWQvwxabZykGh4hKYoxnjlAY6ttnJr0sOekstzuHLbdi+aYL1SczXLOaLM8G1vmQhioJgFkaVRxKycc1AzSRLwHXLjDHx/Nic2QCUVJUaIyHz7iUhl2e8=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove redundant continue statement in a for-loop
Date:   Fri, 23 Jul 2021 22:13:50 -0400
Message-Id: <162692235523.25137.4560910396688989511.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702131542.19880-1-colin.king@canonical.com>
References: <20210702131542.19880-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: edacc693-e8c3-4094-960e-08d94e48d853
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46478DD7CCE9856D8DA012218EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9O+Ro4QUr8l+WvDLSBNz8PtcqxiZy1m812ds6itIGOHO1W83iEy9wWu4BR9JD7X4aoo33lKHPB5+qwuNYpSpJM8ETMnsNRxtympyDlwOxNsF3545/zU6D7RBlWdgPfxgAJAU1V056SemGSVHTFNUw9IaKw2iYoJYpxKu9g0TPGSW+wGQd3eCGSii8n7/acxBFA+Q5TxIF8B4Bj6pr4+AhFO+Lo4SfK3CWGW0+uuxab9Pec5BdNN2LtYHtncaDk7jkLAS6EXEBWZ5wfBDVhJWsw5tdYLv27HToDhh/m/nNdMMt9ivXyQfkK+fnUGL21UM9h415cF21Tj4sAngllBxKYc5lcvS84Y9gRoILQMFB1YwVvlAXWc6Jn2OlzdwgK63noPjFPIuhw+3OwaCsx2XhKPsN2APuBBbDXVLmRuMr6m3pR8O2mjnkCuReU0dfuxU3jGOl/++PNBOx0BnXfckm8Dt93BEL/O6jSEQgLOmENBfDX18uPwhfM9zhxGMEW/JZGZ4jzeccC9BzZXWh2sYIupyFo7x1Rb7pnsJ9qr4Sdvg+Ku3kZCEVtOGHaWikfECdZRITBKfhBsXhn6j5P2UBtTh0haZe1L8DwoY39yYU+u5hUZzsl9Zm5h7tzJINcHNH0AJh8P0bq/1ayOJZLfgQ7hYQF3H/iD7PSlS8Ed4iVZzAzNnOaVzsSrjx6OWzby7khCFRmzxyenhSr+6Eq9YvM6+8+vl4bWYZjq5g5bNYqgBrjpwyCJSIlsZWl6RjtYo06L5CfCoQZHELR/9ZS5Ihkxk7N3iC/AtGJ+WQR8Cu4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(52116002)(7696005)(110136005)(5660300002)(4326008)(316002)(6486002)(4744005)(38100700002)(478600001)(6666004)(38350700002)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGRIVW8xQ2I1TnpvYm1CeXdoYzF2UTVTeWZjdnRsWkZMZksyQ0d6Y0tVL2xn?=
 =?utf-8?B?UVZLMlNOZnVQNTFSWm1RSDNPTEx2QnhTVmlTcFp5SElTczZqK2MrSXEyL2ht?=
 =?utf-8?B?SEE3dFhhOVNkZVp2ZzJXMjdSVVhxSWNtSHpQK1NJWTMrNVR3Nm5NSXVtdWRN?=
 =?utf-8?B?Rnk3TWEzWTJnZGNveVVScndWNnRDc0UzK0xXOVVyb2M3bDVxK0ZZVmZjR0g5?=
 =?utf-8?B?NnNDOGFBWThDOU1zNWN2REd6elhzaGYvcXc1L2pEbDZQVXRyNi84UnZMTWhJ?=
 =?utf-8?B?TzBGWDU1YXFYVTBTZFV2WlJSTjY5ZVNtNmZrTE01OXA1SWNOVCs5YWVoejdr?=
 =?utf-8?B?emo0c3puekh6WXlKL3BwVS94d21nRVhMZXZBR2FzNFF2Ui9qOTFCeW5ZYndj?=
 =?utf-8?B?VXBXRE14WlZUTnFBV3lSNm5MR0xVSHRSQmhqRm1XQW84UDViN1hRZ3ZSaS9D?=
 =?utf-8?B?SGxhQ2djbzQ4U0R6QzhDb1VNL0VDSkFMYW93V0xjQ2JWTmhBTFFJMGczZVJ1?=
 =?utf-8?B?SHlhRHkyZ1NXUWhYRlFrNXM0MFJQL1BUS3dxeElrS3VWa1krYkY4MnpJMkZC?=
 =?utf-8?B?bnVRb3ZSbGpwSjRscnNYUzdibmc2ck1jVWNVOTNtTXhCZ3JKUjM1NkQ2MHNm?=
 =?utf-8?B?ZkptU3ZvUVlJdEtzdDlkajNtU1VxS1EveEd4M2VmQ0swM1VQbUdlcXhJV0hH?=
 =?utf-8?B?OWNkbjZ3a3dNNnFyczZ6QmdmbUpEWkFiZURENC9IaVVGRUJPK1lhemx3a0Ur?=
 =?utf-8?B?Z0lDbDZNU2sxZXEzQWtRYlQrWHdCTDJ6WHc0L0RjSzY3WDNwRDV6VWUraU16?=
 =?utf-8?B?RDhtUzdnOGNzWXllUUZNUit2ckFOa00wRkhzN3F6dUhaZWx4L3gzVkI3Vnc1?=
 =?utf-8?B?MlBRSkZLTGRUY2dYdlZmMkljbUFNYlJ6TnNuV01EUWpFREVKWmlpTUxXT2Zs?=
 =?utf-8?B?bkNFL0hEN29tdWd4WkEveU9MQmovcjNzMGMxTXNlcHN1aFdMQnozWWl5UTBS?=
 =?utf-8?B?WWxTV2tPL1BxRHVKdU0rMHN3U3kwWEF3Vm5QeVllQ2tzYWhoeHBWTmg5Rkwz?=
 =?utf-8?B?RkhuR1dla2lRd3pVMzFBV3lQQXh1dUd3Vlg1azJKY2kxVGhDYUhValZ5aThu?=
 =?utf-8?B?OGJiK25WOXZlckFTTWczcVh3UWFWZlNwYlEwMDRBN01RbDU5elNaL2dRYjBK?=
 =?utf-8?B?a1FyNVhSd2xSY1prTnk1V0xGOGF6eWlKT0lJcFVNTWVwc3RDZVVUais4d0RV?=
 =?utf-8?B?aTVRUXJXZlljdm0wa2t0QnNPb2lLYWIya1VFT0dFRTJ5cjREUGJDMmtkRU9L?=
 =?utf-8?B?QjBzcDZ3ZDE1dk02Wnh6cGFyL01rMU55V1NUdTVId0huNDFJbjhqR1EzbTM1?=
 =?utf-8?B?YnFlbkV2QVp2Z0hYUjNGY3VxS1Y4K2gvRzk5TWFRTkFHVmE1NE1yRkdwTk56?=
 =?utf-8?B?N2g2ZU93NjhvUTBMeU55TVNPTE9SYzRuTWxFeDh3MWNKM3F1VHEwMnRYTFBv?=
 =?utf-8?B?TkFEOEdMRUJTMHh3STBlR1R2RThYYmZLSjVPcjY3K3BFVG5zN1VOZnc3WjRJ?=
 =?utf-8?B?am1BUUg4c2c1MVhPayt6cTNocXV6MXMwMHBVcDRBZnVYZlFUa3RYa1BqRStM?=
 =?utf-8?B?ZUEvZ04yTjNVSnVXay9kVDdxaVJTZEVQV2doc2k1UXlxSVp1eGtBdHFBbTJL?=
 =?utf-8?B?MEswZ21wcHhQMTlFRGV2N0VRQUhQd0JuL3RNWGJtS1M1NWtwZHBBSmpkcStL?=
 =?utf-8?Q?+40xsENvVzrStWBFi8mg8EoQYFolrFWHfbg+Sa3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edacc693-e8c3-4094-960e-08d94e48d853
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:02.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5O9R6I2gtRcY/5LZMQcYiuJrDM7x6aIZ9xX226KQh/1xVLOLIbMH/vIo8oPpIZIgcEObMF4gAxTlWn8sMFSUrO+GHwTk9qVzMK/G7FtYSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240013
X-Proofpoint-ORIG-GUID: FDN686n3YxuQiOlXdFmgn2_tzTje8SAi
X-Proofpoint-GUID: FDN686n3YxuQiOlXdFmgn2_tzTje8SAi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Jul 2021 14:15:42 +0100, Colin King wrote:

> The continue statement at the end of the for-loop is redundant,
> remove it.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: qla2xxx: remove redundant continue statement in a for-loop
      https://git.kernel.org/mkp/scsi/c/37306698c3d0

-- 
Martin K. Petersen	Oracle Linux Engineering
