Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD5BC77B7A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jun 2023 00:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjFAAia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 May 2023 20:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjFAAi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2023 20:38:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF87124
        for <linux-scsi@vger.kernel.org>; Wed, 31 May 2023 17:38:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJvVqt022056;
        Thu, 1 Jun 2023 00:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=UEJIKWf1PdPO1OExHRaklwBYd0EYmd1GlwxF+2ICC2A=;
 b=dT9DgX5OlcPG7dg8L0IO01JRYeTfgTJ2ATPhVT0MQadBnxqA0D3SunbDpO2FVWM5wN76
 Ebf8V6itrGL27AJ+awEkwaxswzF+K7Bah73I99+S1Oz3cS4C+Kw8UAsRwzR+xcTJJMsJ
 ovRTGXK2GNTJtocewogmOPLFJbudff2dncoM4B/wpU3BfLaIp9D0YWMDVzsTS6L2pqyR
 moPMOxyvs+5cGEFFKHjJkmbQCc7T49CxDJ3yKfN4atBBvWtpEhl+mdQW7Lfct6qZX3gu
 Xxwid8Mhpt3d8OViZMVruPUxL4e7VmLjDO8vjB9n+DNxHqfRNE/RtNgJ8+JLjiAhgOpD Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjqdas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:37:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VNvIDe026028;
        Thu, 1 Jun 2023 00:37:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8acyxfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Jun 2023 00:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/VG+zcZS3kRm2qlqi694z6D4zntMCgUQoPnCOYkdKaBqt+ahBqm48fHmGr8ORa5R5pHBINR5wlJT7Tgw1LHexUfLM8EV58fFCb9q4kr8oMZH0Ttj0eCuD4voIiG+sE0n5XNcTbLf5nHK4U3TkADd4Gd1aTxUwrhU6npUMxYob1OaYrdtvviJHepMZmgMPRIa4Y0PEAvPiVWQlciDlEQPIs3iX5LcFIJB6MSsVD7b27JnRV61zpiroGlLUj6NIiPMhy5119Kz80D3DnQRJAm9fab82ZimMshCePnMOtIBTsas2HgVSC1czwLLIbCybp4Kl/700X6/LtAGM1hCrsI3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEJIKWf1PdPO1OExHRaklwBYd0EYmd1GlwxF+2ICC2A=;
 b=hxe7B3zjQtwBJTmsls6+SVmj5u9iv8LDd6uzrbjwf5FfiJW/3JYLcBzjJ+fCbCyfQvJx61Vs8h45YyCuFp510dqE3l+fPfyrSj6QntdNjqrs0QQkULw6lmnXdGyMvQy/O3sdiLf+v/gdGylh0/HOZBUhp54C2MIDnnRXwVaBrHWZp6HDzEoV8s3ymAACRWCSMDLQ9ogjqj8/YE1vN1xvFQPYpFqUrKWK3IQVENUsSqu3sXLStvHu57MtOr3tMx3iD4uhduyxZ+UyTuc2FAGmvzKoO/402a5Oq2apMbd/MJLI4A1hdPb7cHKTebb330vpH9q7nD9CeQLsU8AuS7VmVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEJIKWf1PdPO1OExHRaklwBYd0EYmd1GlwxF+2ICC2A=;
 b=qzACg8VCnoGJWrD3v724IY6gPWCflcFuVR5bkpYIoTZTY0iPVm+QOR+VCRxoKOu81WpiB5y6xub9Jtr1/wBtvsWiezcnkZpMaRcNBTrzLhK2fKK7LuHxOAMHEBqr6hJsKZeffhGUH/A++FjaUAvwqXAW0TiFxEPpk+qEqcG3yO4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM4PR10MB6206.namprd10.prod.outlook.com (2603:10b6:8:89::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22; Thu, 1 Jun 2023 00:37:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6433.022; Thu, 1 Jun 2023
 00:37:49 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/4] UFS host controller driver patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8g89g04.fsf@ca-mkp.ca.oracle.com>
References: <20230524203659.1394307-1-bvanassche@acm.org>
Date:   Wed, 31 May 2023 20:37:46 -0400
In-Reply-To: <20230524203659.1394307-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 24 May 2023 13:36:18 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM4PR10MB6206:EE_
X-MS-Office365-Filtering-Correlation-Id: 715f205f-b783-456d-29d6-08db62386d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cS7R+t/8wWz543ubaVm7ENlqlv6q2LnwwjkAUDg5rfXRHBe8L9LdCJQgmNKkr79p/63zMpNNS/dNp/can6A/8tuFU8OMTwLAujJZz3n1PlQFC1yrTAQjqSoVfcjQ0K5RwgxfHZXgEdnceHvPKUDfYGVOEEh1YYDrpJwSBkL5G16Cpd3whuP5oxLvSU6cfgl2QgGzTu0tBD7kXFwy55Hc51ebtdHJuLGwI/agEuhFHPQjD44XyxHTqxo3D9I/0RlAsyr2DMc3D4caWKj2OzVRybDEn1FQ3GMjsXdbjSQYhlVd9eIqCR9vlynVtQmk45oHIkQnkEq1GvJ3atdtdX3spRAY04REwbuDi6pe0mWh5aWDo4aNqGZoTbRKbODBz+4JXSsfZzWO+SmiJ+Gyvurb6p8oUNsNCKDT6mxVTBDvpvdRSAJQobwimmHec6nDt/1l6G3zWLf542smYjBgLwVnzIX+wqzXa8p+UobE+C7q92jzXUoqS4t59Qflkky2Siz4ZYEhI/yR2vWj9GPOd2wMWltH2IH8wwMdbojYprvgMrnzSDsSdSXzSRqpd5EsPXPg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199021)(8676002)(186003)(5660300002)(6486002)(38100700002)(54906003)(86362001)(66556008)(66946007)(6916009)(558084003)(478600001)(4326008)(41300700001)(66476007)(6666004)(316002)(36916002)(6506007)(26005)(8936002)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZVgowGSnuOGVFldxgsWWAjhQQVVV99Mrp5l8Jt/K9gDBd65zQMbQBP3oGjN1?=
 =?us-ascii?Q?HtA5dAG2ttowUwISiGa14HfGXrnBvMECgONx95FtOwrh+vj80U3PQtBj3JNk?=
 =?us-ascii?Q?G0RHO/aKCBscSRP2phPxaH/uu4tH0kQRcR49NOuvQ4l9eNkRZNDji4EpIGuF?=
 =?us-ascii?Q?vR6reU1k83JSbvVw39RpTzdiSiQYxAcVTxCinb/eiH986lx7zILNR9erbha4?=
 =?us-ascii?Q?4y38k4041lo4mESWwHeVw+TrZKsHemOcfQ8r2lL+X5lFaAjnHa/JDw8QD3tE?=
 =?us-ascii?Q?KJzoJCO3/S8QJ9dU7QX7lpbD/+UnRPQnNw2esVB6XWrWnRryjc0r3G0ByAAO?=
 =?us-ascii?Q?+7a4pV28HvaBrMJ+2V6WF/SHikmUkJC3QH5z83gDGKgBS/Mj0ZUk1D5ZH+Q4?=
 =?us-ascii?Q?+07XtNr/6fPjMCmVDq7puXhxojIwaWToJxwxTL230MwzgsZfPFkTJtl3SdNE?=
 =?us-ascii?Q?F4e2Zpvjx7U2v0lNz6FqyTs7qA8xQB7iFKPl74N3qD3vtbT+688hsi9fSPmF?=
 =?us-ascii?Q?0/hhSHmqZVPJbHcHSAHStFhmDgOVUwcFUCYc5hqUOLpuvO1DGqVPZrGnGT3C?=
 =?us-ascii?Q?l5PyvuF7TMtTIkZd9XcDVnqxuZRkHGkAKopDknnof4+qRVfh308o5f5X1QpV?=
 =?us-ascii?Q?veulIJ8ApD1dWXo0uAfXlmR6jorriQ7xr+Drf1RFlePDVW3GgPiHUd0pURj4?=
 =?us-ascii?Q?ChEMWwVKLgznDXjBRne8J57d5pXfDVmpqPTYlz8QEFmN4qVflTN0ddohyJu9?=
 =?us-ascii?Q?aHe8h9GxuZMD/pr9CJKVlZOGF5HdAl5hg5ZbvaXFT46pE1z7MOX43G4C7zyF?=
 =?us-ascii?Q?5onomRNk+ZTRn7zbzD/LSuYBTc6Q9lsFAV88LGAE84CKe5Uh17Y4LuPoUkjl?=
 =?us-ascii?Q?UG5JIQBsxzWJfs+guSXPEfFp8VHdkrQqm3V3U0qFcnAE8HuRnzELag9HDFun?=
 =?us-ascii?Q?yAHsDP/KqVaW6rdpOYHwupZanCmRH4evXMi939Zsg/GOzr1Nx02rjqzHOND0?=
 =?us-ascii?Q?0v4crHFcmU/Yf7IaJUOAb9fOf3Vufao+2GE0R8PTHFYICNyUVQfrqHLNxYYJ?=
 =?us-ascii?Q?5P9i2KvPnRyWhleD+kOudZsFXQHDRcT5gA+SlYgecal07N8l4IcU32jutrra?=
 =?us-ascii?Q?EJ7eQ0Fvy7FgThwFPeEJ9cF7CIRRqnLo2EpjfzFYRfXXBJlMUmP/7l8kZIce?=
 =?us-ascii?Q?b3+BYqS9v73DGWXfj2Xx5gRYREJH8QBhxtHs+sLAU7KBusQgH8tYhLjF/rQV?=
 =?us-ascii?Q?UTA30r47X6XyjkPvSeotbtE+ocMBc76jkjxkcBNxOkgq/KW0sQNc/eJhFvXl?=
 =?us-ascii?Q?0O7QIf4ZLHHj1wKUl+vkNYVM1En9GyfcZlke8oNulJ5T7nMpevFHAIFoul6v?=
 =?us-ascii?Q?fDCedZSu6x70sGW2YFlBefa9a2sGYZwTee72UlfGSZZw2dy+izndNdDNmIsK?=
 =?us-ascii?Q?iEixUsciHbhBYWBdunsQYuodbHmcIoryTuYSNHyqeVec1/MchqiMIMBdu3Cu?=
 =?us-ascii?Q?EKfwMNbrrBjEONk/XdFoKZOV2LB/21ChejxUX9JIHhwJ4r7mGEESLHBjvhma?=
 =?us-ascii?Q?b0Bzu8BvSe84nAK8/CQVPUbhiZlL6cZQ5knHnGp9aD/a4TZGZ3lHdD1/A19d?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: SuqRktn7kHdVekyvoFqS8XAoaZ4+zh9j/D67BMe0K/CxPGpq+REhqXZDQcJrE5B/nk566gbDiraCY8lqPXO5DWN/SAlYghzOBV42JYbnCdUxCqHQi24P3Lf0QpxuVQl4DK5hiAIbwt3w8uT05J0kvNG9rg5O0EMBRzYTFMq3ibEN/qpVb9CrCUbMQCp/b2AuwJyCtbdDJb8Wns1hZXttCGNBNLIwijTu9fJUo3Sy5DQVpjOZ+HWrTkpL6yqKHj7sHXlLoC8bzkGohzcligTx45E00Wq1fctRDV0Tj55mhXLLV4cmAB0C53CSomSmkIqR4/ANH3KW79cc1rDwq+JagoztZe2I45N43Z3QebMWi3d6Gw5ubVGqzdkkAQfaUprIo2zs/vQCQlXJYkO8+iBNtK0iMC4N3cFPKzfV5KZFEMwGLBGBSyUAXzFEsvXT+aS4+pM6S/GZGocOjfBHBaEFPskXyfEO0cXj1cqRAttVRdOYUNmk7hYOdqG66C4g59yxEQ9BrhYfa70Rmfquy5JIRnx8DQFnF6x7nNaE9xtUwhEOdpdAx2BmuClamYLgXCbzcXslbDjrFVnhhIVMCU+cPOQeF11sJ7jAF25xgdVIeqMlqa/+hE7nYfE4mlmgYQ2nZMdxAd88MDuCzwrbfAuqhZCWqefwseyYGCG0b0znYc3DbxU3WplfZlnhkrOWi/D1u0XhRhCcxDw0h54p60tlqV428CwLgRmJEqm7yDLVtEY31LmBHEvMhlK9t2W42rbJxEVVMctOyCcSZ89JCobNo0FiHSsUzdyt49DTgoWnLZ4zXCbAvT5eVW4d9W/rzR78X5PUY83m46/K6L/ckKNLAg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715f205f-b783-456d-29d6-08db62386d08
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 00:37:49.1494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: alQkoB1fce/R4xEqkc1Zq+yP6VlQUssOi8a9ocuZIqBd4XkrZbz/1yUFaA1JZ76XW+Fv8fTX/JMENJoD6WSIwQI03tgE/57XEYoDITQHiVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_18,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=889 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010002
X-Proofpoint-ORIG-GUID: xdDMj3OQu_jrdq6Yw25uJ4xsP0SMVjL7
X-Proofpoint-GUID: xdDMj3OQu_jrdq6Yw25uJ4xsP0SMVjL7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider these four UFS host controller driver patches for the
> next merge window.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
