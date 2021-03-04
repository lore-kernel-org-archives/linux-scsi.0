Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AFC9C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D44364EE3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhCDDpm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 22:45:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51170 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbhCDDpQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 22:45:16 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243ad9M100221;
        Thu, 4 Mar 2021 03:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=CJhVGTDlUTRqPKU6mok60IldlkavTSqK7orjyIT97bc=;
 b=f+c/vkuWhXQkyPByWhHYu07JhG/w/mkwg+1pfzt3riQ/aewiu8w3cctQxDtKnQEM81tP
 xRiDbavr5fOIEukKlOqJzbhW8J9kcvt0wYinJHyLJ4hZTpDJI7zpeQ1IFFQ3gLO6Q3RZ
 J786moySLs0cjmv1qU7EQVkcNgF/67zcqALcXI1BYmtTjmveNadOqINYfL+RW+GZYQu/
 E5tu3F/3P0he/wD9lr2ytlk6H98m3GaBrZsAfLNIarASQSdNbuCvY7qH++c/jMpI5ArT
 mWJN29FHq+dOq2919VJ7Vz2NE1tqYX5x8P31KgblPbpyFRI8aOxWoIql89Zl3NSuSrzF Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 371hhc71rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:44:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243Z6pp086962;
        Thu, 4 Mar 2021 03:44:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by aserp3030.oracle.com with ESMTP id 36yynrc21a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:44:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kw7cAU8LJ0vG2d7sZ5c+8alQnpZ2otfqpQDXIPHW71qk/FR6VuhWFDJwEWp/AxaqoaDHai+E1Z42VHVfJyGIa3EEJpw8k1bjOVmNBOGuefVZWut7phIjU5qb8xBhwzdYB8vHxa0UgWSmSkJUm9ZcaLT264dV3+h9pmxU8mFXVinlwJ+O+y5eAO1ZtGjTHN05DmbgiaeVveKP1/ZE0wDYkBB1uBNZRAX+NwBhvL9fPUG4E2faV9bVjey7xDpgCHxUqUhKKW+1OcocVb7SYY2WRHIAZps7dqbde6w4YenMtj2iyPu713Wu8X1DFRMpOg/RhdbxBpnYIsXtd8+B663mOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJhVGTDlUTRqPKU6mok60IldlkavTSqK7orjyIT97bc=;
 b=f3g/+UQ+kuFzqv26U1PMlzEh26rodQ3jBF4cxOzFQ5szqlHIfmTMzQeaWhfYKZGFQ5CxHm6IYZliAwWI7EImxp/SLeZq59Ty5KVWanuYNvH/lrvq9Isc++bAEC36LGyZ8QteHwRkF37u5Goz8kNHa/yrTHZ4ThA22NNnOiJpPuBx41qVMzBOYW/Z9ezvUFWq1Sv9IDCZzaAKGO4sZ+fbXlNA6Tvy/4aZHWMU7V54jmngVI9OBa7oBASnSA6mZ1ENK3qogW2izXf2x/jNe7hlSlwjzhqghUH3MHVH8dbbYAHXgvPzhDbdfcpd6QxSS+/R3kI6zWiSdreY78jcrJzYbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJhVGTDlUTRqPKU6mok60IldlkavTSqK7orjyIT97bc=;
 b=x5byFPIljC+jUZjA0n0BO0nsZg+5iYcwanbs39IvUJZ6ZO2pGE2S8NrhoXKTcH96Cyk4lpjPguZomEEvdYzkdNXDETPdU0Ja+Q9hRuQfPDOiu0hKpsMs4iU1uSt1GO8PvGtYjEwjaFW7w5EPtY1ocOiDw5q+qhKzHhfsCjZcYOk=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 4 Mar
 2021 03:44:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 03:44:32 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/22] lpfc: Update lpfc to revision 12.8.0.8
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7lrh9be.fsf@ca-mkp.ca.oracle.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
Date:   Wed, 03 Mar 2021 22:44:29 -0500
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 1 Mar 2021 09:17:59 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0275.namprd03.prod.outlook.com (2603:10b6:a03:39e::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 03:44:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e881f9e-fa38-42bf-e362-08d8debfd233
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4423C34F907C38689F72CF5D8E979@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpBYeDzHJH+pq6OYH/40GNqICwBSz+c9obWuxj0q4MmZpbZPFXFWXcoL14olCoe23knnoIZjiO3F7BThrF2dTRMHY+wB6uPe4iwOwveD0lGQvSsnY6UB/Vk2nffVKnyK18IrlsryrvuUmcR3JqFiRJwgT45UGUdEnCXM2kxP6X0iRYuyDYwx0qdWYc7I7bQ8xwfnUtqX3VUo8ctqMyr+9C/k5Dgio4UVC9lSC6v3FLINj5RM58rA4sKQ4J9NRjsPDblsMH0W7xfrbAU3RBKC8x27WV2jnGCiYgxs1cXvp02HJ1OknsF08rkRb0XVt74CcImHYNwpS+Nu2Utpj6/Qvg9i5Ek7xx0oYCtCmdDlgalY9GL3IGSfm/V2iQI3/6YardzGz6+QdZK093NdmeaoSOw5bPncMBKAMqKVP0pJFysLKxMR72apkS5PbKZgNMTXwEtyH/6B+7+EdZ9hoQ2I3Wku0Ai7k0vQZV3t3Hc9lvm6DU0kkx9ON4Fv/54CNykDBnCPsu78LLP9Kk9CNlJagg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(396003)(366004)(66556008)(52116002)(26005)(66946007)(66476007)(7696005)(36916002)(16526019)(6916009)(5660300002)(186003)(558084003)(83380400001)(8936002)(15650500001)(55016002)(8676002)(2906002)(316002)(478600001)(956004)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nqpnNdL4ifgFf1lYnYhAoozZM9SsKllseM9cCDah6GrHZohiuwaj7fkSn8T4?=
 =?us-ascii?Q?kI6aipzXwBVV/HloqjBD7NpepwzeWXiOf+bwkR/3rxkoRiB57e/UzcVioBwo?=
 =?us-ascii?Q?1w0N0ODFbmZ0t/lkXOd8NLPWYLQYGnMd64TxmMfNQOQdz7A7Ig+S/pO/hy5u?=
 =?us-ascii?Q?/2y4LuRB1Wm6ksFtO4y/KPPQqDDuWPMwOw55boaqLLtuHfwubr9kxfEsSQ2g?=
 =?us-ascii?Q?dnxh4J6P648p6bbq8Wa0MtPl//2hPd+A0t/jCRe0gTXcdiNLiTUapFeYRH3F?=
 =?us-ascii?Q?Z+50bC37Qb3SEYMkbFPihnixtXjSsLo0tzxk/6XEqccAzshWi2o0zYKDW4AO?=
 =?us-ascii?Q?tQJ61gnOejUkEOYIJBjcef8/mL8QDjy7pnKGVl1K/N2vLb6lHtWx1pTXZzNT?=
 =?us-ascii?Q?p7Wgn9p6dUFKLeIyqaoAVL915EcgE0D/qEkjbVBc6kXMG0C3hiorgTsnHkrt?=
 =?us-ascii?Q?06VIZYhAL/Jd66TQaWJJMKIvKbCpKh7a3aZkM9AE+5NdEi2aKgAvfzy1Hu7n?=
 =?us-ascii?Q?O+iTUvaSCHKWKwmI3noHq10ZFcT2ihs8h60bw14coFceHY1ZDhMVMbwwj4cf?=
 =?us-ascii?Q?6E8jr1UcLUw6zr80Wtxt++KQiNAVgze6T/zEp8c18W2XAvDi2JahavxzG/Wm?=
 =?us-ascii?Q?XcKVRfAmNVo54FfOE6WUYe+kx0XID2rlTK3x1j6/uCdw1UIyABrOiSg+OoYB?=
 =?us-ascii?Q?sPU0uI5gZWYs+iaDytxRnT0QMWSg0RU0MLGfFnzlITo7hQH3QfH6uog0PoZd?=
 =?us-ascii?Q?HEW8zaq9g2ahQRjaO7AujM28XeZr1uMaLWQSMx+SaK8SGI1keA8rQbjYTbAI?=
 =?us-ascii?Q?1CYZsKKS0hB/BHnjGvX0WAK2VZBP6exwSb7US0A8obJ8gPeOoJVXOrQWVXA/?=
 =?us-ascii?Q?ZJbPkNJ/cdm51ZvFSgtKOr6vhbltSNNlNjkh5yMm5ySBID0C0ptVxPuWIgp7?=
 =?us-ascii?Q?NbeCri72x+hR0VH6J84oVAlsf7bbJd+WMn1G5mhJYvYlMIqk2UHXtBix3G3m?=
 =?us-ascii?Q?lk+PNnQD6JJeUf4VtKhQu0e22iAzWBjK5hoKaKKzNUnORywBte3AoRWW+bjR?=
 =?us-ascii?Q?X2dhAJxabh4j1lfufVRIppwC0SGlR4xx+FgsDOMc1BSJhnfHNoA33/jWxVX5?=
 =?us-ascii?Q?xZl60bGx2FeBPtgvJcRuzozPOgyGXT6v1R0ps+14GIb4gUppXl3e84CxaPJA?=
 =?us-ascii?Q?lLoEGwwH01CIrP1Dt46PDfAVI9C6C5WCQyaKBMKq6nBNeVO28vImKFnM3O7e?=
 =?us-ascii?Q?Do4p6/scXVEIhl6S4Y2USTz06jhl3pyVJy7UJHCLD7BWgCNivBUaC4f1mxaL?=
 =?us-ascii?Q?p/m1AiJIm/ZzATaGRdICmUAX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e881f9e-fa38-42bf-e362-08d8debfd233
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 03:44:32.0517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IknLyfPfTCBUQtBYFhuHkzikZsKpH/6gtd//YQ3+SRXoySGNamlEIbXMFuyenylgbn7ICf+OtgeF7koL0Eeog0hsYXnMfQkrw98UHHzZUjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=954 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040013
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040013
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.8.0.8

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
