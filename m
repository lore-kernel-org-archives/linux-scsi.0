Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8C9EB64D8
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 02:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjFOCIf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jun 2023 22:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjFOCIe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jun 2023 22:08:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9C71BDB
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jun 2023 19:08:33 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35EJrBHZ012619;
        Thu, 15 Jun 2023 02:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=wtk+oTw/rC6LdEGLyi7bHwFDwLxrRK9dt9lTuTQvPFM=;
 b=ktGfTdSPlIwoMM3Y5S0heUxwf3nlW6o62tfFB7rP0tRi/ANBG+apCT5nBZWzhZwHOY60
 bRJ1QU/geDw8UwkP0J9d6hTPYZL8MLYfDnrd1fNyFaG+bQrffXqdkFbzcHQ81j959tFw
 xqcK1iO9cGDDgBJnUF/8cOo7EsTOzeQNsm1vGSNPWA/Ru7W25Cei+KTecJeoavJY42/R
 MkV3luOD9ypJWImhjXZutexRoIS2dmPV9sLijJIFEW4v8bu1D1HLUTlJJ6c1Ego6z68u
 h9zSdd+Q7E1CEiopvtbJ9p1uy+oGudg61v5lToR6vQvhncYblq7D16W46qsRlh2T4Qwx 1g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3gwff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:08:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35ENHXRN016231;
        Thu, 15 Jun 2023 02:08:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm6bghq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 02:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJpMOP4lwaRo654vR5Ur1p7XgcAQR37EnRf7GTunNqBdHQdjwyzTFufLLSfbwXhgzVQEwPnxdXmT9GZT27fp5R8SlOF3T4r2NGaEiLPaXzMuV4o0wpYuA/LGnStuxr7PbHTeosaZaWUcbKc4V4vg4uFUhADWpOFinZkQ04wEUyJWw3o5gME7QH685S1mbggYt7syY61+s/wV0qx7pXA6PisATMAp3JlY27VYTELHrRCHnNbJVzoQoNvQpkGqfGhlMZc1EyvLqZjdI+F03hYnRkQkep9TY2mmP4FAU+GyqQ139PRZbl0S3XU5yuZClZYNoxf7De+TWxkw7cZnQuEZIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wtk+oTw/rC6LdEGLyi7bHwFDwLxrRK9dt9lTuTQvPFM=;
 b=jP4rikA3JVXZ7h0DaALf9jjlglMCNZeWFSJZlULaBVEH2kCga5wskYUUzOYB1w6UVz5Bgg671SzBbCjO691XjKqUSy7NQa8ZUraQ/UukmOmTBYsDqFwSLeoyja26Y8L4iEVgwM0nIVcKoJbJ+fsLOu4JnSHHvrcUCCVJjSYjUdHJ6ToIlC6E6QXef7fB5x9msZE0OWjtMt9LuGI0QVowe7pYsU7NL+TVsiPF517aNC9C3cwhE3lmAXeQCOEcRrz+JUrnTYGsX7VwhWSl5pBKDmWuA8cYwSnG75b2BGfyw/genZSdAFwPxUGVOOh51yVXW9qE4EVMtB4i4NJWQ3HR0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtk+oTw/rC6LdEGLyi7bHwFDwLxrRK9dt9lTuTQvPFM=;
 b=vqkRq9dKLi19Zx6iVkqgDwrdaYzrs28soJ0RReAMTGodAp7/RIc33QA1X8fCyaY31/rCqoyWljYydPJ2spg2y1lyekstfflBaDCgmgoXBuO5wCEcvvXF1Zrs/HQb4SlM1df6OoZqXtq9BJknJxbhmE/X7RdoLEEGY6zF8pKGauA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB7643.namprd10.prod.outlook.com (2603:10b6:208:48a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 15 Jun
 2023 02:08:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6477.037; Thu, 15 Jun 2023
 02:08:28 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 0/8] qla2xxx klocwork fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt11v5nx.fsf@ca-mkp.ca.oracle.com>
References: <20230607113843.37185-1-njavali@marvell.com>
Date:   Wed, 14 Jun 2023 22:08:25 -0400
In-Reply-To: <20230607113843.37185-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 7 Jun 2023 17:08:35 +0530")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0035.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB7643:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ee68ad-1c97-4594-bf05-08db6d4568f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DL6P8dL0J1OlTYsaw1slxWVT8q7ovW7p0HTaApFxOpjdqWBfzwxOzhCdolU6isYZ7Yz4cDhmb9dv8MnP5BB/Khxl6/+9oAEttiFIHo1Fa9agA8kjOOHFeQSpU5jlBOAqzjHNJAOkga+5n3GtbRQ6R/8IcEnbjcrLYCShDoV0yikrZY1OGCHkIshhR+WAzmodaIPllT66GyMyUvXy/tcdRbcFe/noY1N9iWLZgUvfe2cJ0qmqOhGtBxwlyxOSGBTEKvyTEm4AIgOSsTJvjcBxGqoKmpFZQuz0Wv9RO5nmtko27xxrhgNIW4Eitj3chvtGCh09Zv+KJPzEqDQznq1zESIcli3lSGTd3XyMFzeIozlhhsZrytCHGtG3ArgNEKoe/ULyIcKaqw3YTlLVEMNGf9Wm3/lP8iQKlmZxialyWhY4P24WBtsPn1MoVKBTdG0640+3TG9qKveKOmyOpH50dE67mw2JOptZyApqJWq3nkm8jJ8P9QLvdtdmUEOIIaJ5xL2wLtwuhqVVcdCWGpBofLTYIqE3moFtrFAxv2tYT4UMunTnKvESyUPhvFU+SMc4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(186003)(478600001)(6512007)(26005)(6506007)(54906003)(4326008)(41300700001)(66476007)(66946007)(558084003)(66556008)(2906002)(6916009)(38100700002)(6486002)(36916002)(8936002)(8676002)(316002)(6666004)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8mgjee68lTdnEumTJLv1AXIe2GrOtN0ykCvrqV9QSMKQmtOpQZSmlbaG4bBy?=
 =?us-ascii?Q?K0a/c2DqQHM/836ZQ+8Rzo6ypBNX88flH5mfRasZo8mdXnJBk+bnAQvxAtuj?=
 =?us-ascii?Q?CgBPLHJIiIKLkIreaSFelmX9qwLZovbujNGIS8e4RZbmVGnqMmDn7kRCoxBr?=
 =?us-ascii?Q?+UUOyvI7dJh+iKzwUFlG9TnmmTH8aHvWVc21pEIiczVIz1ARZz5Y/zfVJHPg?=
 =?us-ascii?Q?BSSTTeAnt7C75soiDrMMLCSR6ZhsQ3bkCkBDLnKOCIDg68RLbsfqGjEphikK?=
 =?us-ascii?Q?FJHcPkGX5n7KV3mjQgbtdmUrd5xpR4cEbkaPJRWiErCMkzyDKUcwH5GBV6LK?=
 =?us-ascii?Q?/1QlmKAd63veoHqmLWFHTdUXOsx2XUtu+1sS9iwJCvCs0Q2r3tWbq1zb0T9G?=
 =?us-ascii?Q?ZjTgbbZU/XmOrtz/9gP6rxCs9QDis5A3+cndr0M1sSg3Fju1k0C3ezoDHy69?=
 =?us-ascii?Q?FfetkwBciDsDaYqwoOx/CkfLMs43YGA5co4SmdT/fsi9Z6naw817rP1voBzI?=
 =?us-ascii?Q?qPY2Ae/+qNMDkpdVhFqhJhctSkeQSx3OyHpy62YDEq6mgaurfhdepeKGk0b9?=
 =?us-ascii?Q?5pkDtRTIBc++idMOR5BRBeiVFCwx54vHB4Vh3K49+X5Us6LuCWxMrp8huLM5?=
 =?us-ascii?Q?+F9qUyIrmcaCSAVGjfNnhYmO2BFQMEmJKO5iGIyWjx9tqm7BOfpb3gKBy3Ya?=
 =?us-ascii?Q?bx1DJlKmUXu9WXa7N9uxMBKmx2B0blidIY4nnCfdeDdja8IDi7OE/E1hD3i+?=
 =?us-ascii?Q?Yemyjvy9xZQ9j7v2giQRz/3Aby2Rb+Un/0dF0kx4OdhYnTbqERSzqc0H6Enm?=
 =?us-ascii?Q?cHZtpjIuWcKXuVYnNvQZaZH3X0F3jJHMGJJYiraDfK0u7WqhpSCJNYcg3yx3?=
 =?us-ascii?Q?QccXcNYidAnNFi9/g6HI4evBecbGl5RqJuO8QgPwcH6GxPRjfu/xorwpRZ8N?=
 =?us-ascii?Q?wg3CcPTWOvfNY7ht/JuMH/VxV+FpjUQYJ1DL/pwZeAo+EG+6iwIld+TqO9ai?=
 =?us-ascii?Q?bOged5J28giL364BUjz1zjv8YB1zD8ZjYeQGxHoC5GOU5o+Un5M+j/Zs9wRK?=
 =?us-ascii?Q?5B/EY3GFII3vP57VpZRjNTtQhulLxOhWXUCdQQoEyAFxaCM30M3RUK5lYdln?=
 =?us-ascii?Q?KToiLbvWrSLJ9frx/r8l4pckPoJRr0Xitmj87q1/j/o4G1rJmro8X/J6bvdZ?=
 =?us-ascii?Q?ulWnfiRLLuOPRwtL+hdZI/Z9GIAPBog7G24xJvxhUa+79otBd+GlNtucAldt?=
 =?us-ascii?Q?+FuivmF+ehMKUVSfwFI4qGbqO7YBj53VAubfT2CQZQg9XdpBXbWsY5Zoreg7?=
 =?us-ascii?Q?zjErJTaH64GXUIHmqMPBN7Vl6Ul4FnQIrS/LhXAnfXGJYtw3iHQu0rQc2hGi?=
 =?us-ascii?Q?y+1+zoARB6usO6kH5chJeN+4z97R2Or5PKOpyrNB4y52Y0Kibuuo5HCgk8D+?=
 =?us-ascii?Q?TdVxZWeBBzv9Ef1DuSb4i72IseTLRpdedNyqOFJ6c6tDzAWdHZBbGi8oNIcb?=
 =?us-ascii?Q?MGw/ausPdWqf4EHGg+QFYTaAU2VRRZ2PbEf6qb2qfaP6io6cQ1mDU3h0fG22?=
 =?us-ascii?Q?+y+n8NJzrSBnA/F0musWX+BNsMfO9aTRH8M1/+mE4QUaOpVTMo8HSLRjjDkB?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RN37U7OF3C4CxyrwMdS2BRRkn0ldAuHhItwloi5xHMAZ31MkpgHXChV847iYe7QvMZ7wBKxIOb4aRrmi1FCn/4DUKRx4OCVO7NCjLHYVrypDBIMaAe7pvII61H5X4sOV6nQ4Vf+ByUNI6FCicCmxDcTNXDjov3tRs0TG6eqEUJJx/2VwHG1sNIFEg7UVpyl4znuwFRcT7hL5H0E0N4QRUqFxVRHZQeaT+CvrziZnY9LLbUvcdd+nLt9xDXmYDoo/5RKelgxsv955vXvb6dNkmj7QuWmnx2euXAZ8Z0JXEsfyCKvKO7RSP/kd3Z0+IfPjtdCJqN7H2YBCCBRVIq81Ngeqgh+umP8vfJt0dtBMfcqbH575sDaV8sDBM8zD8/Ti5ZMWMhRom0PRFuMecuhjjDo4yg47aTCspzjUHdnCKt8hbBnmESX004KYwZbStguijRHfSIlvuZOaesWCTYkatL0oHvgYELy6tbLC10GhIZF4100Jf5pYrtLy0nBq2V+Sj771oDOjHgO7dkCEV5C7aVhp9r1boPKnFaS/VqGm/mdxOqsNgwCO1VZBjmQFg8B+Gr8/Cni4XQdQFSO6P2LfaLdxg16zwBCInQcG0J2UlFqzSrl3VWYSDXuHkiSDwvNZIAH0cVuJSjOUQJA/1A4XgSrglZuZVlIhvc09oh6iqSjHcTxN70tiYQlUBcEwWn9BhwHhX1eu+kfhzsij95tHjdTL2dSZvHz3Cy5kvcBml0wmCLGXhXp3klEB1vRTZvfIOw6+D0nuwXvf4dgFOFr8ybaN4XHgABx1tDtwdSNtC6g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ee68ad-1c97-4594-bf05-08db6d4568f5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 02:08:28.5263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ArXbnoSqA1AF/W45KQo9ETVLPwitQTU7/JmPA+PER0M/3YoDn3bJq2Boo6tEZgVwmx/jx/6PPGo/X1c6ey76KnflqK+O4mb8BWS1RkuZd4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-14_14,2023-06-14_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=708 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150017
X-Proofpoint-GUID: f-NxlJTvHM3uI2nRKYCG2U9hA5Y4Y5Ae
X-Proofpoint-ORIG-GUID: f-NxlJTvHM3uI2nRKYCG2U9hA5Y4Y5Ae
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver klocwork fixes to the scsi tree at
> your earliest convenience.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
