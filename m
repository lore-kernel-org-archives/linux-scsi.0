Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FCDC00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 23:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbiHAXhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 19:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiHAXhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 19:37:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BF142AD6;
        Mon,  1 Aug 2022 16:36:59 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271NYPIx024769;
        Mon, 1 Aug 2022 23:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=pEnrBI8j8vxk2YiDer0dNsukcRW2LHZoXST0Dpgi3xE=;
 b=C/utGuzDMYf9bwyVBAeN/HmojPDzcHdjEb+alo9WbF6+1XVW3M5zb5Pd/sueTXaHrQcr
 0BLXwqpEgTCtwgTbs4dQyEhlBn+IK1Rxnv72Rkuo9U0iM9HXkXAWzQt4j6n4rxAOUmUi
 WPNfpJtMQ6Fq6fz3MSz4eRu0Wh7g5Pb2oYsfqFkFAoJ2hkwg65HmSu4ySgZQSKZ/SFCS
 f2DyY1TISyMEGyXh/f1qww6QChu/QtuzrbDQvQO3+NQ+t7xzk1VTfCRv2XfRzEXBEfjt
 15yFa7pAYk2CUuS0zUW7Sdo4TEh0kXTcIv6cjJRsu6gy7CGOt/qVTTu5mF7zAIrK3sT1 kg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmv8s56uu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:36:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271KqdZD010697;
        Mon, 1 Aug 2022 23:36:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31qqjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 23:36:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJAdyfe7HANrGu0FZk4rwqNaZCn0xAn2VvN3XyQ5TWbumEhfF3bGiX5Oy7FLms2DisS3nDACkydOJnU4/AXANkK/RzikzuqKJPmeukWJV63y203X0F3DzhXPKbD+PSPKWAjKH6Vuc4XeWBvlRH5vnslfGz9kytTkP8jnKqDY1/3uegy7kfHXawSTZ3rhFMLEL6V/gUIbI8TSxn43sTDNTOZl3+d8OmB0R/KQ8oKGl99OzJ6wIB+E7M3d19HhJZW7gzbCxpRcnQVVBGD/5E5sJ0vmlfoj43SBnJk6x9dM+d88bpFSpgevcHrMucjUi56V2S39gTVG91JjwZ449v+Nvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pEnrBI8j8vxk2YiDer0dNsukcRW2LHZoXST0Dpgi3xE=;
 b=dXtNMiZxOmrPxReTenOzh66bmkJ45nCEIH0gZwR98p+BCWJZcaxI40+94RJyR6jYamCmH4qDwJjPxJC0Bd4c4XRW0tre5KdluvD5tzk6E+lqzAcBc6DWOBPy0es3MnvrVFQK6xryY5FCGXgRQC7VehQv6CooG1JwEa9qPosBP/s9JNGJgGlJ+EB8HNvg2q+2+3ONej2Iqjo6A+RYzqKFghM1jJvwQ/RN0JxcT8aBoX4Y57KAxe4xuEq/Q1eZDhql/yJ5XfTXrt7USE7OUhTJo9v6a7hg1T+810CM3GcDddEtgQbCk4q5j69qAaYdJepjMMIk5rlkYIpqlYLZl6ODyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEnrBI8j8vxk2YiDer0dNsukcRW2LHZoXST0Dpgi3xE=;
 b=BxSG9Ak1YmDNfXEdFwI7/5dw03jouSiYaEVb/DAjbXV5uga8b7s0UdX0ILQECdgoUyQRc7ja1bUFRENvBd2HcX3fRLWUVT4OL+jJfgikKUHayUXxx0turRFLOM3myDMkk6ug019pFcHQLZq4/QHLHY2ailPfc9sYpqKjpz4QJ7Y=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB3383.namprd10.prod.outlook.com (2603:10b6:a03:15c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Mon, 1 Aug
 2022 23:36:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%5]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 23:36:55 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v2 0/2] target: core: fix race during ACL removal
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilnb4jua.fsf@ca-mkp.ca.oracle.com>
References: <20220727214125.19647-1-d.bogdanov@yadro.com>
Date:   Mon, 01 Aug 2022 19:36:52 -0400
In-Reply-To: <20220727214125.19647-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Thu, 28 Jul 2022 00:41:23 +0300")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:208:120::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 513e79a7-e061-47e4-e45b-08da7416b816
X-MS-TrafficTypeDiagnostic: BYAPR10MB3383:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+onkf/Uo4Ugq1dsKMOX5f4S63x+UBXdd1yryFSON0ivD19l1DcL4XaiImu+k+6R4AZoRwahaqRpCN+xSZsmcyHJp+YvcgCBW0oWVfiMaL/8DL0s/veJxES/QSHS98NqwVjVMOqEQjnkd9Pe/QcIcYFbnnC/ZfMLiIVyzg9EFFQkCaSMJB6d1MMi8+RmSwjQNLKcg59iVgQDV5uccAB2uvNwCsjZZScSzmE8zDICwB5LFTFErWKJyGFFQGL44pn+SUXwB1CbJDIVGfWhHY4CWL/njOTfUtpSzfl8bIExKqTMGnhoTGdJ67BMWN13MDPuQZ3mFWwIfpkRcahs6LSlfwocmtTjTSav3ioSX12KTA1KLTAuN3ikcErcTtcFSd4iioRyhJXmjuQCZsGid8iiS+YR9HkTKd8/os+B/bLVjd9qCOvOYyUkZTwXPZkBg+nRro67sbMTfJ1A91FUde5mINrbUrac/B+QFNVMRW08ahlTuJzJP1YTeX7/sDNL9XFFR52zOHVPP2KdldOugoHXFXf3RFZKnEyPX7bX1IpdKtrCd1zRcApFynzTjrmP83e0q4HgCWMVt0pWJ4GM/QNBBCl/ywk1lZ0dhE1BJHuplIEg60kllC7z+gcI7DXPlRWCCMyaVA9VIUf9nO6DDmaOJpDNuzQo/tR0aIG8rcBOfeL98PZ0xNR5xpRI2xv+GU9d7ezBfaNow2VSVvwdfQxOFoY3jOTqC/NZ0Hmr7clyIDlZT2TBQ73az5oh7pi9uD/6LDBwPl/8jSVjqiltSCUI2fPp6e7hhCygIQBVzGDJ6UCmj5qxCk+KCflKaSTl77rJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(396003)(366004)(376002)(52116002)(36916002)(6666004)(26005)(6506007)(6512007)(86362001)(558084003)(38100700002)(38350700002)(186003)(316002)(478600001)(6486002)(8936002)(5660300002)(6916009)(4326008)(66476007)(8676002)(2906002)(54906003)(41300700001)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yrBjVBxPQfOUEQvv/0u3d6VP/EJVWeeVnUNJLh9ohhwFICUwBQ4GiJHbOryQ?=
 =?us-ascii?Q?s0Oo/9nmIJZrECU5AAnCQMMylAl9/wE33y8Qik5GI7wpsxR24wGB5lnbVQlq?=
 =?us-ascii?Q?d2tlHLs1m7BpIrDJAGSBSv5X3+DklDYFelBdDben2U9FaFUdu9M2caJeU7Zr?=
 =?us-ascii?Q?XoimxGabm9ZEHQuIjVC7Jj9haV/7xIVwNhTWYa0TkHucItxbVGwsC81qzS5M?=
 =?us-ascii?Q?qoSNXZmip1VNQU/yyDCLAWDAkKxAgyWz4vig88k7lMHy41oXtN0Ba+BFyUQ0?=
 =?us-ascii?Q?SvLjLQG/X+ktArSIe+fJ/nr7YQB4Fn25GWfHPTJnZv60/kr6wEIfV5jfBzr9?=
 =?us-ascii?Q?AYnb1/+SHAI3MMdyN+w58/9M9GFNs89cf1ZDKNzdIWZD43kgkyuh9N1kg0NJ?=
 =?us-ascii?Q?lShmIhfoDdupHUzOr2Sb3EAuA/id0LW5WLxUZng7n2U6xylXgpIr78EnEJge?=
 =?us-ascii?Q?Gco30AXvkR7ERkwiLiElz/gnbq+hSbi846BRT3A6kylIejqqKz5WfV33JH4k?=
 =?us-ascii?Q?6Io/y7O+R0ZdcDcTM6j6Rlrxb6SRkQ3rEmR54+03Ch1KFIt92xASi/EP9O27?=
 =?us-ascii?Q?wP6WBa7r+8agAEFk5JQs4IYnw+IW0QNDrhUQxRqkymdGccKdI+Dz7tJn/pya?=
 =?us-ascii?Q?hMVQeQywx77dEeFcXB6+jPMBOW05epSQ3GsvbAaC6eJqUSSB606JfdpybrzG?=
 =?us-ascii?Q?2487gZmthcehOVx44nVtO9yeLPnpXJlLkat0H2SMEO9pc4UoFXiwQqX0r99m?=
 =?us-ascii?Q?ZyPygdyZgbyvDLIjdqME/SWsCS2yaMDyX6R9Icg6L+o7bsuqGpmVGgxp/MWH?=
 =?us-ascii?Q?DSjtlApysq7G3OETyWxtTWUL8noGMxB6KT5pDdJSoJ6eAT9EVrSsWmNmAMTR?=
 =?us-ascii?Q?jvM0kE3/LHb/WFhhSAgfDriG1HMMKoEShEd2AGZuFGwYpQWRR87tx1PBeJE0?=
 =?us-ascii?Q?tyqs+RAY4tGraaIp+PUhWYnKD1KPxOfHDW+lwgdcVXfnlArZl+kSqG1rmqhJ?=
 =?us-ascii?Q?OLNwrlSv2hpbRBHHW2qtx0IHcvYmaU1qItPAqzrY3hdbvufYaJU3pH7EHB4O?=
 =?us-ascii?Q?pddsScKMNWz3a//suJk1R9gEa2hNbHOMhVWtAzZhtHN3dW6bhMB6CevOYf9R?=
 =?us-ascii?Q?mrDsWrRpyhFhUyCGrdik44LPjq2bSuABOzRo4Eu2QMyedaqd3ds+ffD+NEqS?=
 =?us-ascii?Q?ZJ/EuLA7zfOZOtC8N9qJFCIlj405htiqKu/skIfYBcyIBcG5+3OiDcAJQho2?=
 =?us-ascii?Q?kHHqT4n8SvSXPgGsLLtOZoHssUW3c1MfiyhAKsan2mqXy+7Pd2p5yvZ8UWQv?=
 =?us-ascii?Q?2EnGw1ln1C46znEGp3ma4MnZp2G4Ofw1QuH0BMoas9S405HLlF7XGqdUgZlc?=
 =?us-ascii?Q?R4uhvb6XItT+C3UaQi07nv4u5BNnL9imHPReJGtzzvQ30V4WXR0mDZRJBh2C?=
 =?us-ascii?Q?z04NFXLA6axGVmVoSEM2HhrqKQFj9/OnbIe8GjrS2vtoBeGZjRfIHEGZ+PnC?=
 =?us-ascii?Q?lcYOCi/qlPEWEc2Q2FRKTTPtJzjGm/xGMIVjaMGp6zF5Vr/zfBUbHgShexKp?=
 =?us-ascii?Q?GTcXaYm6GREHVZJz9dPE+jefIOCRvjtUv/OoNjzpAlrWv6PlLlB1WtbIWpS9?=
 =?us-ascii?Q?jw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513e79a7-e061-47e4-e45b-08da7416b816
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 23:36:55.4363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDdQrm6bDHXUrE/mpJg+VmccMy5CZR3HQZ3JJ+f0ETKWDgy/Zq0YbYiGb15tnX8LLeyvQ61cA9xF42rjWWyCSuFDf7QgXbok8bPkszGkSyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3383
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=951
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010118
X-Proofpoint-GUID: uTKqSH-4PZHo0bwblu9-qnYVSNxwmz-h
X-Proofpoint-ORIG-GUID: uTKqSH-4PZHo0bwblu9-qnYVSNxwmz-h
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> This patchset fixes a race condition due to incorrect usage of RCU for
> se_dev_entry.se_lun variable when ACL is being removed.

Applied to 5.20/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
