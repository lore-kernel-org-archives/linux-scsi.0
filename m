Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5C2C6FD18
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Apr 2023 14:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjDSOR7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Apr 2023 10:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjDSORt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2023 10:17:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D780DE6E
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2023 07:17:46 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JBcBNT006005;
        Wed, 19 Apr 2023 14:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=//Qzay+FVVpr0n1vbtxmoGfmGlbu8BaPX3mjkMuayJk=;
 b=fp9BrxS5h6bMwz0Z4mqisttHbDjUaGXPxR7tGz0aD2tYVUhsjd07YfiZj6/IzNguziQA
 roi84Mx74UDb06jTcmiSKDLVAbtkt0OXEEwBxD7U3M2pjkbj4Dk0QfqLfY5uLeErmY/3
 Du/752mXA90RFbs2Ya1Tr4s1yCiG7CPSacDBoS9IawAlI7zLKThMsyun4EKbQOaXV0jM
 pyOnCPkOWARJ2UZGXHybI6YDljrkinCH6uP0SYxQjdDZ4JCm3hAdg6/WK4Ft/duyfuO9
 Sv994wx5STi76YLbKnnWO7ihx5MBpicWMbtuRSHTZtN1B9kWdEbJPdRigLXipH5UzBfH Rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjq48f2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 14:17:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JDVZmU011451;
        Wed, 19 Apr 2023 14:17:40 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc6qe9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 14:17:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/YY5vQJOBZiGaFRENzhHiD4XMkdZUs90+QnaNcC09agS4vzLN00sOnTBo6iQYJrN/Jj7AQ2j5QnbYUKMkWJcC6VZo6YnmYUms4aJ42F5hzNX+6E9EfVQPWDcbTvwzG5Pkgh3vgmWre+8xMEQa8Z+FITqKwbKnEC/LIewvps+/PH5uBtVitkia1S3VbmHTGUWrQofK11z7G9bYEyZqP82H+RTnephdER06nDsZAVESV5YLFvp8qhVe05h6UndIkPCdk2prtQNwwQYyoNrRVP1vOC9U/XaRLSeoWZDc2e7ldfLl3hGYi7mITT4kr7zK48zYbgRQKaNnD3xuWV/MiMGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//Qzay+FVVpr0n1vbtxmoGfmGlbu8BaPX3mjkMuayJk=;
 b=DzpUuiUinRjatGEUrIqhgyZUVd2XZNeso0jnyhLb4NIIuwcVLpmoAp8dheS03o44FSW8ys0DyhUM6LnVUiZVALKiAmh3qGkqgUKR7Mm+2svAzvHVps2njzAq9FpQvjKooD4o7AEGLUfhDuYXzuqw/h1M25w+qOZkG2SPYvypEF8l4J33DOk9CLM+9GNe7/UseFHh9QqKV8stlGNnm18hxVysCE6WlxJ5V+wZh1FmkBYgA8DI8NtyUwH130kMO1igSRB3ok5kWkwlfSJAM2XwMpTw7EYTs2tHv1cr+3v9iyHL1/27JiAMiAWY3V/Mo18joJjeKz1wMy6KmNrBL3fymw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//Qzay+FVVpr0n1vbtxmoGfmGlbu8BaPX3mjkMuayJk=;
 b=x7BegXUV57bE7O4ug8fsGqs9zfhapCcn93KHfk6J8OxUodW+sDmO92m+7n3gxpr8V2B6Y+t+bBrruVct4tP/6xYu5XtuKDCp5RT5Et3KaLZz53fg4UGSjegWWB50maBrMpbrzOGKndUtqUR0jTWMdqNCCeAxk0Jlhk1cVAB62Ek=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA1PR10MB6568.namprd10.prod.outlook.com (2603:10b6:806:2bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 14:17:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%6]) with mapi id 15.20.6319.021; Wed, 19 Apr 2023
 14:17:38 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@linux.vnet.ibm.com>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        john.g.garry@oracle.com, wenxiong@linux.ibm.com
Subject: Re: [PATCH] ipr: Remove SATA support
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz40ot8n.fsf@ca-mkp.ca.oracle.com>
References: <20230412174015.114764-1-brking@linux.vnet.ibm.com>
        <yq1v8hspnww.fsf@ca-mkp.ca.oracle.com>
        <ed208a85-f66d-d70c-d3fb-12e66629863a@kernel.org>
Date:   Wed, 19 Apr 2023 10:17:31 -0400
In-Reply-To: <ed208a85-f66d-d70c-d3fb-12e66629863a@kernel.org> (Damien Le
        Moal's message of "Wed, 19 Apr 2023 22:16:44 +0900")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0142.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA1PR10MB6568:EE_
X-MS-Office365-Filtering-Correlation-Id: 36809dbe-8460-4dc1-651a-08db40e0d41a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gxfgvBQSrebN/92D+9JaLMCV9DUR5hCc12pVNKtDUaPU8eBIQppQm671pJvPNj3nxycbAHWvlRu0Wb2QIu7pG8VW6v3lL8mnNy9HDQBK6Cn8NFlyhRKbppG4ytS/33LA280PkqzjyTOaWFB4V4m1+0BFuJOydUGT7b9V5zO3W75KVTV+p8wyrHcMxmEY62UBYp53oJjueEYGfiZx8sxwEsDz/7MqaMu6GuJtzisRgBLMk+/Pk3aOyJsE/3iS8hLRsAsjTIFCLCkUUje0smBD8ry2a6xAgqbYuFUwAdypymBtP2annycxChBzwniaCtZ8HFyReZHwN+VYW7u7fJeHVbB/lN0NmoCiiBzy5evpkAUfu3IzNy8dzDT004jK2zGCqjb2TAyGnSMLiRY2+VY4BpUEqfdlNbkzcbhTWQvnk2sNCa5N6NhldLzewuOEToy4G6PLsNDvQzpW2OqO2O9YC8E+/IyyJTa2PEuwTQv0MBeDI88uqcJqBDgnmXR5Mb7embCLahjOFlGr02p8ck1aWSeG1CzMUeSYt7BlVvhMVVMpzSUw4sVvZBsWIG9Qo1vq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(39860400002)(346002)(366004)(451199021)(6486002)(6666004)(36916002)(54906003)(2906002)(38100700002)(478600001)(83380400001)(186003)(6506007)(26005)(4326008)(558084003)(5660300002)(316002)(6512007)(66556008)(6916009)(66946007)(66476007)(41300700001)(86362001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6sESzcIeGBS7N9VdiGRtsnr7P07HjiGUkjEinipslQSjbCXbrKWcAp4BmqSO?=
 =?us-ascii?Q?z6K81JGWDZ73fCLhp9vHK+O2pZSKbpDaGR2HpNUcPljxq3qObRSeE8f+OWPQ?=
 =?us-ascii?Q?hqSjwH4K8so+m7r7jfvjFMyjLR7abb3zk/58LfC+3mZTZ+7TUGfx9YaPxcok?=
 =?us-ascii?Q?MnM2eHWupUtlw5f0Dn6ESNf1a9u+qs4gKaWcZZ8wc4VXcOoThFcajZhyVyuf?=
 =?us-ascii?Q?NSr7TgnLJzByw63kkRc1lO2r9g5qfv+ffHncSXkX8Mp9fmb0k8QjJykp77Jo?=
 =?us-ascii?Q?jEHvRY5CGtPQkUGFAfGdG7IVNPLksRmTSuIfRUAjLHeDHnc0EjZN6SSyIdZt?=
 =?us-ascii?Q?9QrF2/bQWtrX2vxEfSwKLI0NSxe8lgM8AN3HiKcHPPPCBdwydG/l6KD9OOwx?=
 =?us-ascii?Q?y+ygo2KrKkQ2G5AqSEGEJMR4rtx2pembBNLaYfiXB7FbUBPPuwvXTaMS6Etf?=
 =?us-ascii?Q?ZgxnDmSaW+KAy1by+zNHXsnoGimvVqIhpmpB3hXbjOrntoVJ7khL2pOiaxjo?=
 =?us-ascii?Q?CT8/oYMVCj2uTwP1pxoIpmcOpKvnAG5PBtoVAIG53R2Iiaz8ZI1dGsEzsekH?=
 =?us-ascii?Q?C1EoOH3ZHVI8Olx0T+bqdW+QJDgzs8DjQ5t8KB1JYSDq1NU/uCD1hJXMGS1t?=
 =?us-ascii?Q?kj0RzUU89Bb/MH27nBFWK/oeU+OXPQ4HzpDD/BhlSswoQjNwJiUHExvanqOW?=
 =?us-ascii?Q?uvll3jylArfJjc6c3AUxKUltmf/ErTM7YYo0vnvqRmN0mMq9C1KIVA5iMB8b?=
 =?us-ascii?Q?D8tajcMetsXOqioSzk8gpioRNDfS8/K75y1y5eV/XkGqxvf98thQPV/iL/0B?=
 =?us-ascii?Q?nXT+yYjeHV6qPnSAXHtrG4F2dxz5k5puV3haN6WyqE8EXNLRrkBtscNZQRXD?=
 =?us-ascii?Q?zIrKfqGpuvPDgU0g+2z6m263/0OgFyK/54/nQCTAchOC1wbFCzzwO5WbRKpc?=
 =?us-ascii?Q?jgf8/RR5oRgkuinz9o3T2H59y5hu+bGulHHdx09kF5V8K6GdT7GNBzuo+vLc?=
 =?us-ascii?Q?JwErg+/ufg5fbgHF830RMw7hWS0ZHpqgsfIjlGdfNeppS+zr0G0Ce3yWgGBR?=
 =?us-ascii?Q?cH4SADfWHt1wTP46q0OTvE39EdsIKNOzAjVEKUVb+W1WTyTjNuEAGXjkK8dT?=
 =?us-ascii?Q?f9geabXT2Nd114xMYVjhX35l2IGFGAbVwDzMCphgs9+6KZQr7ICY+qq0o5gw?=
 =?us-ascii?Q?t1FlmW/UzPcJDFJpS/sysRt8+pUDffzqtN2sNkQlASj3nteYWb9exhkCXh9/?=
 =?us-ascii?Q?5aSZeFM04m4qs0tnevN2vuHJWG3V1bsfcaxaE2Uy5g04G4iziY3JIwtbAYf0?=
 =?us-ascii?Q?hbsownbTEYHXIeaCBpDsTXE7bi42gX/nJGRuI3ygpqR7dC6HHeX2pIPETIxF?=
 =?us-ascii?Q?ldi20DiSt9Z7tIm88cSGLKMNGAqe8S1GdS2jndv+JsNCBtfwcdR60KtRT8Lo?=
 =?us-ascii?Q?aDvc/nzip8P0hv+IYdevoa7DHGgxoQ/MOYeUjbmLhYL9mb458kfNuzzGp1LQ?=
 =?us-ascii?Q?HsgUT9oOS/zxHrgJbWHRNiAhqCmmb2kw+Ey9yEwePKvh3Kq2tE4mnntXfI1Y?=
 =?us-ascii?Q?S6lDlBT4R7/S7285dJNrKVyOeu/x42v4jJiVemjk9D1s1wl5wI2hEm+F4C7j?=
 =?us-ascii?Q?/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dhyCWW8lHPEsTns2X6gAFYPgTVDa9qkNwueTYECk93ejkGNj7XP783aclI4cf0/X4R8pagZEWuwdlafwCxP6BjJEpQUwAXAUcfAuDelRmWpDwRsQQxaWE1jP8vFXFGBDKG8hKpm1486J+Tmmc4poEqeEhmUDT1+8fJAOv4y39Wg3pIh7RFcofrBesvMbqfK51d/0U2EAZBUzx+DRx/IDLNDH/d1Dul0tAJsS8LD3XaC0ei8ZoVGI6Ijt+Agj4A0se8063HZsmpHfuOzzv+ZH9aMzI2cRFiIQfYX3DrHvTSTN2rSa1s/k/vxGhvogxjAwSxIKyvNhcxAU3p6sg38hpi6pPNg0AmDa4xQt4Wqm/x2HKYrg+96asESwQMh0PtNuHq/hS+xxDt1wXNN3dtVi626rKTTW5Lk9og1rtiZ2+rL9XncIR6xNfZcLrJ6e5mV56M0gGoW4/F9jBqDnBgseFLXSS0lgI+2aZjlAU7jue0JaOYyT1pHYc4BDkxeg0dwrVO4KBK1lesBBijmwPO6ipnGZ/5GbIrQO1+oPoS05RPDwBS1LcjIk/Z2jqNk/VcH9RuMkniHq9j8fJMStNvGDVw3WjEdKz0Uc32Yn2BLjnlgVppQZ8CPsZxG7kR4ggcHKk3FcE//AtcUBmqdB2Xqu4UpmVnBPq+hI8/3WTJQdQbG+tFRkUTFvyEvCgh+mVopNBBGrih04vdSqBsDZ0MOQ/84Ec0IBZn83hxoVTpZPvzMh+Lc68RTJ+/sJBYSmdd6gDp6toQqYLLTHkrzUsuWtPRLW2EExbdB1JpXEDgYWtvZcdHiE541GESR84F2oIhNBz8ID6mEMVOW2GNLGCe27lBJIdZp1REFzr3Wc735ow+pIFNqDMilX+UqThjOGyt3vll2+m50CnDw+Bagfasuxp2bIGZyS9ztbM126p6OMHes=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36809dbe-8460-4dc1-651a-08db40e0d41a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:17:38.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mSaOdBbBRrJgAHnqmNaRncPiKlrpWpinPL13Iozm8MwAQu5/Hm4UiWmPxg7SjEkcnVIxg70U4jA7F0GEXsWqGLWAklacBJfiuYnmwrR/EWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6568
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_09,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=832 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190128
X-Proofpoint-GUID: juAGLXiZi_e_l4G0kszpZPwzSCbF3g8B
X-Proofpoint-ORIG-GUID: juAGLXiZi_e_l4G0kszpZPwzSCbF3g8B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> There was a build bot warning. Was that fixed ? I did not see a v2...

I couldn't correlate those build bot warnings to the code changes.  I
put the patch in staging to see what will get reported there.

-- 
Martin K. Petersen	Oracle Linux Engineering
