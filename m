Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EADA3C25B06
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 02:01:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiHLCBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 22:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiHLCB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 22:01:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62C11056F
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 19:01:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BN6D7M002866;
        Fri, 12 Aug 2022 02:01:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=C8RWcTz/Sd1fFRF0xZgv1dz9QMVZkgENbUYHmIH7RAY=;
 b=YlT0p0W8lGTYABDLqvSE8zr/pKv+gZL08aW6sonBsosx+79SljHoFdVMEH/24aQ9XmDw
 PR/lI1KPQCVwHCS9QyZuAiHnMSm/HwKuNRXukLE+mKYbE/FZJy707ruyhE/c2UpE0DRQ
 1t8mrvLArORhIDs4C2uIhxer5vaUImG+oxB81tJRRUTqGGbiSFe2CjLaoUznJhOfdRZ6
 DJkLoNA8JvXVNKF2YJV2WKtds5Urd66Kqy9lGTnGgZr/SKpwB8ujGVXHcZ2Sxggahz6D
 k6fPk/15k0wCHmi7eoSDDEgoHaeu3V9V+qnKyE1SC0aWk/UJtWCpNceG9AcsDxev8ct5 2A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqdxb0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:01:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27C0TnBU004932;
        Fri, 12 Aug 2022 02:01:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqk7sfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 02:01:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C8YL7VZgVWrsNmv3kzF09xlCFKtlU5jTaUHcgX0Zcs6bukTFXcde2ZKFqEgJlFvOWHPta62S5wmkcLPouxXmxPqalTgGWq3kUBMVO6l1Hlq4WpZ6IG0QJ/lkEofWLP5Vynof6RUEkta/qqotbdaVsZIM8xpDTrKBSmr1QOQWeLNhOjeunYbkHWx3vhQbKu8iOnAFO8vx7tpNl6KAXP8YIoBZJEIUl0X5Bq8TX3aYwTJFhpjOx9tDZGZZuFs3wCFRnE4Y2AJLPwRf9vQyLo0kHijzp0ZokOcKfzEd9zuXOMfCouoCGwZcw3bfNB21eKCG25BZMFZqqddwF0lg+Ua+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8RWcTz/Sd1fFRF0xZgv1dz9QMVZkgENbUYHmIH7RAY=;
 b=gHJOGFAz/d9l59yu3D22uMuBfsywwHqqBV4To+aLrnnKvIR/rtYGfC4qMbWBP0iCsbU3Qptni2Css5wLlK2llvfc79KWSMFOKhCSU1WT+x6WKfJgLCSuzSsXyxUwhFU7UB55+SwRYkTEAs/5vMjgedtyjxIFvedB8n2PTy03JH6yS+7DQG7VQ5sN26ocCKeUJrDLdKUAgFDLpMmtNxcS93NJNLTeU1EREcD/55YEDL6hsnXRI1Pvkd8zHdy/GI9OdP/3X7HhIUadj65CROvMGW6jNb2d3Q2raw/5wRDgdRHsbhnj6kkKrRydtcvzdiiLUOLC1fs0qilqHJDI37AIPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8RWcTz/Sd1fFRF0xZgv1dz9QMVZkgENbUYHmIH7RAY=;
 b=YXdCtMa8XuaQisKV/otasZoTsvLC3qn6ouOGe3qo34SdEqpr8SlgRkm5oxoy7GoPl+afC5o6B8ua0BEIaIpY3u16Y8OOFVoKajaBxsj21VEBA6ZOkoS8I1d0JxoG+8T5pBRvgJWawxt6qqoIwx1RT0GPeiFkdxXLUSsnH05aoV8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM5PR10MB1945.namprd10.prod.outlook.com (2603:10b6:3:114::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 12 Aug
 2022 02:01:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::89a7:ad8f:3077:f3c0%8]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 02:01:14 +0000
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org,
        Krishna Kant <krishna.kant@purestorage.com>,
        Seamus Connor <sconnor@purestorage.com>
Subject: Re: [PATCH] scsi_lib: Allow the ALUA transitioning state enough time
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1edxmmd9i.fsf@ca-mkp.ca.oracle.com>
References: <20220729214110.58576-1-brian@purestorage.com>
Date:   Thu, 11 Aug 2022 22:01:11 -0400
In-Reply-To: <20220729214110.58576-1-brian@purestorage.com> (Brian Bunker's
        message of "Fri, 29 Jul 2022 14:41:10 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0092.namprd11.prod.outlook.com
 (2603:10b6:806:d1::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe460835-35d3-4cf1-db69-08da7c068927
X-MS-TrafficTypeDiagnostic: DM5PR10MB1945:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZbysmqGGk0wi1NGYo1c84GU9ExJb4cIlGMtsioupMAeLILW4fW8WYIDyYvJLnHqEX0TNmxFiPDDcUp5cjnmeSIZECUFF7uhyUQMvHcLBE42mr/iLhmwtcrEtK9MoYTxsd8zRsiWgEA0BdJSr3C7o88ivFzT4Vjcso5OlPJAsoeVe5ziNlSRHlg1K/b1zCIbrRu7kvMk5JkR6Ae058+L9iiXcWhkd2CMwxvkr4Q/LWSlz11YH465KPx4JblVpjYHIJExtyJns9iud90uyIAq0/Ni8E+8ucDVItXGbttZAI4PnzlnEuRLYDyrkuQ7bnN4LtWvYV/dwQepH8STEDMAYVd6G25QBIJL9fAjOqSJbssGOUM0jswQdMO86DyAY/bl7V72k/SjOoGAlQwkw5tlas6KS2M3JqOqUIoNBPHPqy9clgri6unNtgy1hE0rDtRwG9eIiSIEQGOEgKOcAsTJ9TVjp2hzxQYge2LgB30uBz8oWDOLUgzPPhFe9sPR8EbGDVEbd+LP+uKuQcHL0sNDBvb4Un/nAXWCHlt3vDYHlF3KKDeBu01ccgiy3GmCQQCM4yKBC7YdtT8Rygbuhf0+GczwOh4R2cReWlbzY9HRFvhwPDe1OiFfjnyJv6l3VX30P3FV01a/PfmNp2qOiOD67IJy7xyXeM9D+tfJmPo0aMkEqSCutmbglbqwlPCfJEWvH6v+lqGN9lUcH84sn3/EO4Sx/fMeHk1RosuQE214F5qlr8ucGf4QrcWz1XD0h+cjYDfYvHBMFkNwnFacldc/e0g+z270YEyNI/sqDtI3O3wyc5bkvfjRY9PPBQQIA9Kbd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39860400002)(346002)(366004)(136003)(396003)(38100700002)(38350700002)(186003)(6666004)(26005)(6486002)(6506007)(41300700001)(52116002)(36916002)(6512007)(478600001)(8676002)(54906003)(86362001)(66476007)(4326008)(6916009)(5660300002)(66556008)(316002)(66946007)(4744005)(83380400001)(2906002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RrvjihuqoMOQKjbEbAwcijMt2HuN9HtYzbGTotj/OJ2c1VbyambiRre4L+KW?=
 =?us-ascii?Q?zw6QR2ME0cciSEGOEPE9DbYSKLlKeUL1jRbWdvimd/yZJ4jMr/VcbToqzM/v?=
 =?us-ascii?Q?Jx+kJEEUnPMGl0RCa/Of3wMya5833ttep/w3Hd5jj3Y0H6Rrex9b+IJpjlmi?=
 =?us-ascii?Q?yIOHXhLIk8p0XxtRXFaM5PEad+QvHksMBuOXPHIT/f2ILO16TTrhXlFOPanO?=
 =?us-ascii?Q?EuLSeyVer4doXu3LRpZbI3/zgT+kIOHONcKsxbKlKtYCgOfkW4o6xPe9GCEo?=
 =?us-ascii?Q?fn1dIIPgSlpHhaNSC737gQh2vq8lslulMBinqAoN68A5h+VW6jOw+W3dtrpR?=
 =?us-ascii?Q?bdaehZuB0mZHV3aheI/nunHUobv8vypzTMkFeSGw/+uYC71ciSIslM9eJQhp?=
 =?us-ascii?Q?n3N9/LTqlz5n2CCRpFS+/nwKkudHX3V5mgB8aAi624Q0WyMbJbN4h9XNO9rz?=
 =?us-ascii?Q?yF2qfePqiQ+34igP9qHu7QxhAq0XkGLruwnBBi2YDPJjA5etvjhE3iHA6cjQ?=
 =?us-ascii?Q?uAvvzlAh2TPPu4myhNapqcy0LaVm4YPI2H/+22D9alvR41KWKssLHM+jF0Hj?=
 =?us-ascii?Q?c1B+eDBO/IxoZkq7EMmZzLef7OJ1vSwofmdYt4pWtF/lr54BoISGI0VXpYVm?=
 =?us-ascii?Q?dLdrFmcPpfMhoSTe0mg+r2QxIGfW53sloN2L6wMKb9xu1IEeA1uizoQHh3nW?=
 =?us-ascii?Q?DZlta2EHRPFtIMK5xMe61TH9W+rEDlAhNRhGkgy44Cg3Gw4NAuFk12Vz5lWT?=
 =?us-ascii?Q?pgSn+vn7xx4os/6w5V/eCDSw+91riBCx5laN8qFdzOQMz7pJJEqQ6jn0/L59?=
 =?us-ascii?Q?iuth0HT/tn3VOGSFNajrRckbuD6i0mgdp4uwm1eJwo5qafPSuaY+1hYYiMqu?=
 =?us-ascii?Q?cHK3xYvcagtOsejtyCg6qJSic3iwLqzhiP1sYLdk92bybCF15C8jLsnNJCgw?=
 =?us-ascii?Q?KLz5ezkAQRwA/tOKJOgPw3TPvn/d7O8MS/LImFsnwknecWUVkvhFwWWcrG5G?=
 =?us-ascii?Q?CP5+q3JUF4v5DTzgHN9/g3c/0w4ni3c9JGd7pqLV4JKha8bqaZOUxNf3AK/a?=
 =?us-ascii?Q?OuK1WEq1tqXMC+z2j1JcUNAOKH0xNNpJshh9EK027uJeSLdp3UuChT39rSdv?=
 =?us-ascii?Q?OnfLcrNYEjaeZxS3Nfs3ub4aidIRTfjyF9tFUPtHV8ipIzcJuKaRY96v/uvX?=
 =?us-ascii?Q?WsNa3LU2TEN+9yn/dZFvS1p4Y0FrNnBVLBCwCMf65b+XeUEXfxqTpcaXSVY0?=
 =?us-ascii?Q?Wq/4AqeTvPaCGdrFbGa74x92yZmNUPgt0TXRzi59mPV4H4n7Yyrcv6chli3i?=
 =?us-ascii?Q?BMdcMS4fPDJDvAsWziUFm31r8xTB3u2dJNu9j43b/6FuipLJ4mZlV1OTV88W?=
 =?us-ascii?Q?nt3Tc7koHw/vYwrMV2ntI+OImHWVqYWr9wcPbVISFrtZwTQ7p3UROgCU9aWr?=
 =?us-ascii?Q?I51aGDWu8nV90U/lQsCg6DtiP7t4NGJhkDsddmm1tGmeeUZuwSWXLOW8sgz5?=
 =?us-ascii?Q?Dppv/8LJ6B19Rut9Lbg7CKYvHpLtejdlRbYZ4UJhqvO3V2PbCwQuVwmZ5uAn?=
 =?us-ascii?Q?xMqKUAwoLhVCaGM6LQMi60mcNXYnh2qDIIvdbNUHRaP++BqR69rC+3HFQCfJ?=
 =?us-ascii?Q?7Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe460835-35d3-4cf1-db69-08da7c068927
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 02:01:14.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+iIrfWB34nBg95cSSDU7Ijp+/9U+WP+63ItBPjD6nD1sDf2NH488V0XhkoLsFVGjsEYpzjevd/x/wONMDfT8j2iNie4ju2kbV5wZhoaggM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_01,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=947 phishscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120004
X-Proofpoint-GUID: lAmiVGfqdazfYlcivUvH1jRNUo8mA4ZP
X-Proofpoint-ORIG-GUID: lAmiVGfqdazfYlcivUvH1jRNUo8mA4ZP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> The error path for the SCSI check condition of not ready, target in
> ALUA state transition, will result in the failure of that path after
> the retries are exhausted. In most cases that is well ahead of the
> transition timeout established in the SCSI ALUA device handler.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
