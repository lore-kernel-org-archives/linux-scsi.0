Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8920BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A54C64EAC
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 05:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhBIFOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 00:14:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhBIFOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2021 00:14:31 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191JrYc105806;
        Tue, 9 Feb 2021 03:16:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BHzA8j5qhw77U3rn94zEmTDPnx6L2i0hdBLHU0O78nY=;
 b=pT6UF5M2dMSeE5807Bh23B16j/55Po46DFQ7BFw+OU8A+IpfNigTRuy1tO482HrqC0SR
 NrF5rGee/jzl32V4pYVFNwFeLPgGdtCQNChfEnZZ0Sy40R0/DEA9I3etcyvquZA0FSib
 XZTMLBcSj1XncneFf/aus63lR4Ke9nWDLifHPSJrIWnh961WyjTcsT3oCti8TYFxk33J
 aSWa6GucKCjoA2+d87SvhN4hn29MDihWI4zcObKaSwFJ4i/l4jtvZ5gZJYTCohirIRM5
 BV5lgR9Np6XM5HZrhySkzNDuaRxEjePsoRymjVDFVkjz5vV5rJIG/fqGPGJ9OvlQhTDt XA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36hkrmx1ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:16:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191Lbe5009061;
        Tue, 9 Feb 2021 03:16:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 36j510mhh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:16:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGp2rabhydVjk8ZgdhupvqnG1DbKXRdqaQjIv1E8r+qDqYvroSKgq8wJWfUkXtQLRhrqa0Cp0gRfwuEYL7AzG825Khz+bO7yqw8o9XNWOWod2jn30NT5kf/1qHTv3YRJ8Gd7Y34w2gOY/PHpiOnffXQizDpmnJPHnv8rrltV7HK37xOyaMa9ioFXCsy8JdI4FD9cQrRuxlqbK4XMw0nAQXRyeoG4d5K23d7Uh87YPdPJ1vDRaToeShGRIauFyQmqsTZ4bOZqyQE39z6bmw4NYFLILL1fhihJmuPKBxqlmjg7yvdsLw9xB5rolCBkNtCrql8fjeUelDBx14EWY/hGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHzA8j5qhw77U3rn94zEmTDPnx6L2i0hdBLHU0O78nY=;
 b=luZ+PMnRtnnLVRE7Ia6sSKjiv7ALUUvvXR2r4WitbVSG5bypvVwQ779SeSeZ8PKRKFrts3QTNB99QtwKUcumP3IYLRJ8X+VAYRRmVZCFrCZZsJ4D/DVwpMZAJAJPTceTglCdcur3jJ5NBLIaQdvOXQMlMZHxJrDP0FT73+DoJiTxDUissb5ONMd1MW32n13ZMcCaRjgWYjtWK+8+S9sLqzfQsnbPqe+H8x+MxPMCpih+YOmOrXp3ic3x3Ulzz6UX2u+5mHLg+WRt8GpF2oCBRTT0aWQsi/I5yDvw6NSZfWLW9KRJSyFsDI70bIsBGjLwPnpdrCAh3xoYNlvWUd2zsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHzA8j5qhw77U3rn94zEmTDPnx6L2i0hdBLHU0O78nY=;
 b=RQFCAzBp8KiXW3LIuF7KpzH8qqy5PF6MddZL2I1jPj9RwSQ4Ka5kipsdWZS08jNgRhtawbqlheT+OWtYxMGT5JfpKMhxERkIpts72GsK3+UTzXrrfndi5/sre1L55ssvSKEMUKgrYSX/HFVSlMS8XCOaDAfLtfvRaMBNH2j6IAI=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Tue, 9 Feb
 2021 03:16:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:16:39 +0000
To:     DooHyun Hwang <dh0421.hwang@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, asutoshd@codeaurora.org, beanhuo@micron.com,
        jaegeuk@kernel.org, adrian.hunter@intel.com, satyat@google.com,
        grant.jung@samsung.com, jt77.jang@samsung.com,
        junwoo80.lee@samsung.com, jangsub.yi@samsung.com,
        sh043.lee@samsung.com, cw9316.lee@samsung.com,
        sh8267.baek@samsung.com, wkon.kim@samsung.com
Subject: Re: [PATCH] scsi: ufs: print the counter of each event history
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuqmq6b4.fsf@ca-mkp.ca.oracle.com>
References: <CGME20210203102752epcas1p16713d977a1a679cf641894144d8f299d@epcas1p1.samsung.com>
        <20210203101443.28934-1-dh0421.hwang@samsung.com>
Date:   Mon, 08 Feb 2021 22:16:37 -0500
In-Reply-To: <20210203101443.28934-1-dh0421.hwang@samsung.com> (DooHyun
        Hwang's message of "Wed, 3 Feb 2021 19:14:43 +0900")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR17CA0009.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR17CA0009.namprd17.prod.outlook.com (2603:10b6:a03:1b8::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Tue, 9 Feb 2021 03:16:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d096d157-2af0-4f6f-62ec-08d8cca91da6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4517A48312F7F581E20AA53A8E8E9@PH0PR10MB4517.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oIqMJV4r1zacM+Bo3zgqmBJSX9i5Mic5HP+1vIoPAyNqwvAKhnSWtQBJuPK3ia/LtBKKqUiVaV2p/P3fTYdUlI2hLl0uEZH0Y7HW9+ciOfIbStwX+N0HOLY/r2DteMl0RBqRkKgC5GVD89vyj/OOz2ApLIDv1lgVXH/hlwRKDoCzbJWvH0zsYmXk20Xx8QJbRWKtcCjLUmtdn0z8UhVU4kNkf8Bz3t76Iaif0ZuaDwqRayB4ZRqWAv6/L1Wghy1ZGAotHgE7JS8qibMtFC3lhY0RxiZycxvXeLjEoyahadhheKPBUoUdAo92neNbkJ+S3svIvWNpDWHNKSO3Y+weKdmkWoK47wbsQRNRbNIFfPy3aLdEqjFFzS5gGClIgrGFvqAzNljgmj83K/S6RUrD3OcjKnMqlV4i58ghaQoG784YZrFsXowyDlcfw9qfVzmYc+LDkK16+rRMW8+Pspe5WaIOR79oV3znhBrISM37DNAOzrDpVHB/hyulJn5K+ONnGm0Bek3QZe9L3OQHNixI7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(136003)(346002)(2906002)(8676002)(86362001)(36916002)(478600001)(66476007)(5660300002)(66556008)(8936002)(66946007)(7696005)(52116002)(7416002)(558084003)(186003)(316002)(956004)(55016002)(4326008)(6916009)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DRXYVVaIBMQm2qf0mxgJmAHU79EZ4VQVGoFv9aeBIQFVDTX1bwwq1g/VfFrm?=
 =?us-ascii?Q?xHVrO+ALa0m9RZpJW1bLlgIoSWgD/otRM46kFODVIPQZIdyU04sIphnu9Bks?=
 =?us-ascii?Q?HnQCBYx9UDcGsQQpiFKdpXRBAgV11d5xaJfY5V/EwILH3idzLTaUTKk3o6Cd?=
 =?us-ascii?Q?SnWOtYs8NWNY+Vuaa/35ko2rKs1mX2LLIrj8cdnPe0GoJVDZkBiWt82LGyxD?=
 =?us-ascii?Q?udM9fLftUAqJwTmA6rPwUcw3YavgtRbKNkx+YHcwq8u3aSXJqg6t7/eBpM4u?=
 =?us-ascii?Q?4z4QX4Hfw50SFEpotv5rGEM9IGgATMNXnZtDy7feD23vBWe6m3dB3xSRKIQU?=
 =?us-ascii?Q?r9Y5wPShZ8gXMfaKSvrhrbaJ6QCS/MiU1UZpPhBJ3irWephTUQ3WjgNCRTc9?=
 =?us-ascii?Q?JtutUeGJbvMxsjLakSPyfna+XCzi97plTOxPQSAeM4HZMtDxRKZhx3GC+1W7?=
 =?us-ascii?Q?dH8lafqxMeBcAwpGjQ6QgPCqfIL9Oauz/pZZRa3ldyLs9o7PsMFVk0Wr81Dt?=
 =?us-ascii?Q?SGBQPCG+fdmg1vkUnASv8eQDjPk3j5Hsm/5zi2uJwHbWsiYqi73fdX9sYIIJ?=
 =?us-ascii?Q?kunT1MSoKeU0TWacREzPFkxaXNgE94GrQ+ApoDfXN3GrLQWe+p4PX0w8f01a?=
 =?us-ascii?Q?DRD68tQhwprHYw+88gCpUVGaYQd1XApfIYdO2LcTVhEEQfnzwSwudknDsrVv?=
 =?us-ascii?Q?EhqrmrKyGHGJfqYU+nfuAGMm1c++YD19BtqycdTLv8APFLQjIeCU9zO+TajK?=
 =?us-ascii?Q?tGA92ZBk1rgpGKiMvydYmb2luGI2+LRglpPLgOTRdBsaP2miMX2CIY5jGCXG?=
 =?us-ascii?Q?PH0VLw/5cKjQiMGG8FCbCGilexgPLqNBijTJAhgdEHvMFwK49NhJhDmcv/56?=
 =?us-ascii?Q?DE+C+vl25qC86aiOza5nvkTTmADYDkf132p42u0Fcu59VLE91zuck0/ZLpMT?=
 =?us-ascii?Q?cyCkb6iefY9BBa5u37K7iifZu1d702jUqPqfshfejswqx+la7xk//VcvIZKC?=
 =?us-ascii?Q?CG5CQRpMwEWFl+P0WU5N4mZYLl0gsiqCFOXv2ddUB9+xurKp/QMygyhJJxVc?=
 =?us-ascii?Q?RJ7x0+cJvEg7Wx3d76oZ6SoyTXN93IzHxfCVOaher1fmq9yxFnSUFgR5fkts?=
 =?us-ascii?Q?VOY0xm0ZGtY5KUYEH0DcCFG9aegAVPxZTd5CqsxzJNt5MRrrO0lVHoq+gs6r?=
 =?us-ascii?Q?42stk63vyz3Ne+/IRLBO16s69RXOtT6HpVLURpZkQaTR5PO5StlBvf3lg3oR?=
 =?us-ascii?Q?kKbRMvJatWEHt2scvxbDiENE7ZtqjReUX2QvpShda0ffaF6V2L0Gq0nxCBZ2?=
 =?us-ascii?Q?Ock4EvOexOpi65jdWf8jBZsS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d096d157-2af0-4f6f-62ec-08d8cca91da6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:16:39.3212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAOcpZ7zyz0R8fPPm/uko3W5AQE9C6VPvdfgeVqfT9uPsTtm/4DpTXwkGFKJtygG/vYyhqUrb0ypbco+bOE39V3IRPTjmxnnXJn2SCl5guQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


DooHyun,

> Since only print the recorded event history list, add to print the
> counter value.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
