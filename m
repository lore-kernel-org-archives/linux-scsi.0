Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC512EB64D7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jun 2023 16:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbjFPQXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jun 2023 12:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbjFPQXa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2023 12:23:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4DE1A3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jun 2023 09:23:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35GCiU23024630;
        Fri, 16 Jun 2023 16:23:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=eNSmtOccgCy5GM2Wq8fGXhjSvSo/vKVFdWZbRA2qOko=;
 b=PSNXqxpJCTtO/6nGSSrW+GCmvuM3nII/OGnAzmCtYppatgR458Jyvp7WZzYzE/35MEjh
 qm0e3D7zTdB+QbDyReTIdltTM/KGwuvI+WGIQZsBPsCDTZpANTWEro5COJPNth/2I9AY
 dSgwWpJn8T268q3FqERxUv79JYR2pjNCXG2CKk6gocj8SevHOduWVPSSQRG5K8X1WQv4
 A1UNma84jnz6urofna+NGYihjS/g/vox3NO2JY8UCtKdgB86tCFX43taKwN+xv8Izj71
 h4SSMS3TkevUY+HRaE5j07kRSigFSCYDh3BwTXBl+sP9vHGBr8jySHZOQyOyuNAestbX OQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4hquvmur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 16:23:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35GFaJRu033575;
        Fri, 16 Jun 2023 16:23:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm8eh86-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jun 2023 16:23:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+n4NSwuuma1VkUYF/mkE703sTPiEBEHUXjBQpNjXuYmOMbVqACBRK/QA1Ee24XDDqFDVtDi11FkiJU+RlzgHAn5LCPhKNFd9zM8valtf/7g5dSDDSuZHBDbL9iaPXS/eLf6zDlaZ9hGb3nQYt3PfzZSYS3h4/uWD7JIW/H4Z1gP2+NMFf/w1zUIfbDGYf2DcIMHZzjiGzAJndrIwQrB/RKPKw+bohIOqrrzous65uO4oml6UXn01CTWgpUkK/cOy2ogByr4druMu7sbxnRlELq5EWUQns//3fMQ8hwN0GRzCG2LQKCaNrBHj8EjXKLPVdMoFaMrn+38f8ICMZF7Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNSmtOccgCy5GM2Wq8fGXhjSvSo/vKVFdWZbRA2qOko=;
 b=ZZlD3w90S77N9SCMquMKX7Cdt4n0wwqx/sEWQselSiEZ7NZB5l8UBcXj+/xVJLedSSOnZWc6bEdoQbI1C5FK27vrJ5YSfF4a1Hk+LZR3YP+HOMaYbxEHdchHbChQz4I44MbzYuprq72nLVoVduJfTR+RVhMDckdRRNc4CVf+SajUQCYQVnXLDq+NXoaDpagP0StDzVaqwlOEhqTUvcfCqnt+F22mqicZMw8d8/FL7jJQL90SCGkKZGN19t0wibcvxC1ONyhh4UxtZ0mnxi1/Q/+sNB8gDUPsZPwa2ThC1JeQf9EcHGJrq6iWIZWZK5z2mv/4KsaiQ7noy77rWxv3Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNSmtOccgCy5GM2Wq8fGXhjSvSo/vKVFdWZbRA2qOko=;
 b=ZIPD1k0XPdXJ4p5hmBR/7fofgTlNS894MfRggqeG41+CGdcLMBUlcBfGAhMk7Ai8vr1cOz2t7GfJz2m5mQOdeWwAOotHMmEVg+/cPFZKo9hrmly9FvOsfwe6R1vHbpIvXCaxq4cu31whAvFzsR/EuOzPwuVcMDZVwN2/vvSTN5c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4170.namprd10.prod.outlook.com (2603:10b6:5:213::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 16:23:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6500.026; Fri, 16 Jun 2023
 16:23:17 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH] qla2xxx: Remove unused nvme_ls_waitq wait queue.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15y7ntlzq.fsf@ca-mkp.ca.oracle.com>
References: <20230615074633.12721-1-njavali@marvell.com>
Date:   Fri, 16 Jun 2023 12:23:14 -0400
In-Reply-To: <20230615074633.12721-1-njavali@marvell.com> (Nilesh Javali's
        message of "Thu, 15 Jun 2023 13:16:33 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0246.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 32616b28-650f-4689-8f6e-08db6e85fdc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QApIDm84aoerEFwJe7Mi0MHO4xi5dF8mNRcYgNpooPCDYALHa4Qr28UhfUirf7K7HJXqN7sAUxPVETDs0VFObxCn+NvbikykqMd9gJE0Tvfm+Ms8ZnyiVK/qumzAAhIsDpUyr+yrtLrASCcu8cDTn6TKxAQXibSY3ixlTb1D7HJqlYWZZm5WmGiS15I/G6JU9gvJ/Hj2oSCL7dtiyoVN2C4tXTW6GFJC/7NcoqXNBYN11SZW+f3FYb7hkGnIFrb7aYi9ESc+QtSu51pkTxoqr+uPc29jgJyXuWgsaGwMTFcd9uIj1Bv/Ef4DgHa3pSk9DezaY3SJs3X3zV9PSVczXYk5g47AFbW4qDGaGU0TCnz4rswhUB7mOS9b8donAWvaXwkD/wzjGet+GMVrFMpNUkY9d+5EzTZg4Gyq12MdQ8bk++SklYoofQTWZrx3iA8jwgL2APXTbWDP6z4RSDq4U1uai8M3N9nWSQu+9l3NEJJBS3c+OANZ9G/oiuobzwxz5tH4nd829krApoO97jLWohgxsI46Fbt9qjmX86NFP94M/WIHSv4kTh7k2/ibRW/Z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199021)(478600001)(6486002)(36916002)(6666004)(38100700002)(26005)(6512007)(186003)(6506007)(558084003)(316002)(41300700001)(66946007)(6916009)(66556008)(66476007)(4326008)(86362001)(2906002)(5660300002)(8936002)(8676002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Io1Xpb0rAqV/8fHyxuT1vWqckJRh+mdZDCzTXypUvm7tK3Ua/uCXJTviFAxr?=
 =?us-ascii?Q?x+a4j2dZkX8E2AIBBoVimRRJNMRYyGVAFiOlkqlIANUcZKNVZV3i2BDYscF9?=
 =?us-ascii?Q?oPAzfvQeAsC9hPq2zja9qnPXT9csvm4C1b+0kOaN1LQKzIATD+sO7wKvPwT8?=
 =?us-ascii?Q?OJplp7JGOo4vjsQFILDpaOK4kWjX4LNjo2tvqai5oyigooPPoylzKj7QvZfc?=
 =?us-ascii?Q?N/mxxYZ0O3xDcHY4vSkolRheE8U9eQd9yc0L/555O+bJHTqtkRRthVHe92TL?=
 =?us-ascii?Q?kGjUz4Kri5R9lGQ1alpwA0pYeBRfhKY3gOZmHupzSe+HQ+4xJdiQkcThtEjQ?=
 =?us-ascii?Q?k2r+QWUq5Javd01s0yDEXyTRBgTV4uZQxhV6O/O27uLXahUZ+F8gZGlHJjnH?=
 =?us-ascii?Q?d3ZdvoT5gqoO/QCuK/2QUIw9BeF+ifRJ3Nk/6X51P3s6NGlgVcdqlfRGSU7z?=
 =?us-ascii?Q?K8WcqH3mVHSKTnMYkt70laVRLQvAJWxAbdkSEMzfzZt0ndlM1z7Vehh7XhBG?=
 =?us-ascii?Q?vbYcR0Cx+SP9Zekq7CsZZUUP/v6UJIWh+t5ipWfeEOpX+ThomRJX/CG/LMpn?=
 =?us-ascii?Q?KtJoKZ2w8pX0rr1lemkEW1MAFCs7zw8u12QGA7N7WTrdnOSgLe2JhuQYs/Jl?=
 =?us-ascii?Q?/rR6N4XvYLuYAvndfG+oSBcWgXeJqQnAnhloOuOmYykavp3AR2p6eWlgR3O3?=
 =?us-ascii?Q?2SrRA19Pf4ZCsPR9p4v4pjimSjphBDObvnQ12MtCeVk0SGq7T8KcGR/5SAMw?=
 =?us-ascii?Q?/W7x33BEJnhgaZ7BFaUg2Jd0uH2x2VMyUx6PqGh35mQA6SnBiJjEo1A6plRR?=
 =?us-ascii?Q?r+nEN6nob9YL6dfa+S9jkiSzG7yl7QycRdyg+8uVo+rCdwbXZ5Seo3e/GVrs?=
 =?us-ascii?Q?Sa6m6PubVu8RceboLSfuaPGbBuLMk1dkRcSpft7OjjFHjHTC98HE+wB7GclK?=
 =?us-ascii?Q?01OLzcqhP8wxD6BZWrKuxvwxGAtgLxEMEfqepjDyKDRrOIQT55x4SXfPuKVz?=
 =?us-ascii?Q?JRHsNQQgIGr36uDWNxDia9qf2r9KGn69U6z7EgwED+zhIAOBAFGD2YCCYkGF?=
 =?us-ascii?Q?Ac7eAQGAUtta7/TkbfBbLiRWa0onEjuS7g/6BD0UT8TV8tr5QWxWySeSejHa?=
 =?us-ascii?Q?Tuuv16zxlF5ab6OA5T4WOuUTVhCcJQ1YRi++vKoLQGEHab0nF25zffg1k586?=
 =?us-ascii?Q?IBuk/44U61/663jIwz1W5VQZ4ZKENtQ5ZWMRymDNlIlUqRy2yZhybYlcNG42?=
 =?us-ascii?Q?MKEjngkc3MNPORF3EIsutFpkOc80KwC5hdy+me+czQbnx+QRoET5FQLj/CvZ?=
 =?us-ascii?Q?cNUVrmqE5pnpLOq+wENVkPDJ4hgtuviUlAS83f1t/FJgjFFdtsta5hUc/dTA?=
 =?us-ascii?Q?UOLCRHwq0+j9y26QtSmztj0NjyeGJPXmdAWAV2NahcCv+WjBiiqNi8U9IasX?=
 =?us-ascii?Q?20wj2rjjloTkNx7JG6r5OMukiyBO6ptKeFNKQI1JYaSs7GO0BcgqyW8hI3Bl?=
 =?us-ascii?Q?/DJ1eAU0C2zPHgzE/lPQ+bV6PVBvVgxZSck15xjX6CCr5q1q/lmgX2hAPW/w?=
 =?us-ascii?Q?+dGWB0JbHMMQFa+tp1+/BTQxkxJPF6hG5QvJmgixAUxpjOHnZa0gCzXuCs9A?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ontsZ3h1sceC+gHH7mvUJzzJN88VF6tVz8LldlIq/fc0hW1fmXGEXegZtFKYLvdC2zjCrNziO1Ypm2tmePhlBpZ4AZMyIxAFqiW+EMVuTBQ0tY3Bq4aHWqoCDi2ZD6/unSPoEcJSqOB1h2QX+9kqASRDezKoBhLoLAhpFILiGPdz30z2zp/eeNokqH7y3e6teC8kmHnlLq2nQoQ/Lej0pOb4PY3hkOLvDGexH4b/dsi6duTf4RfDZVhFWoQhnPm8qWXbSQbge5d2U8n1lG9UAuFbG6LsjsDjmEvWruCscP9mVAiOXyuO/X+4cJANfcw/Yxu9ouG0EudpL4KexjfbZhFj4LFpHmaz5e+s9y2o1eOb7VRPQXK0ueQRZlDB//xzaNgr7F6ku10fS6tNHwCII/ceV3Vx/Uu4F1255GRJzAg4Irlh6rssjAp/Rx9uTirX0ov1klp3ojCmFUYMSy2QkpSVeLqYkKjcTiou48mdMPThfJWkagwtIU0oQ3AvwbQ8ZFi4dK1BcQ6k7InNrSTxj+2jOqKqYqthjD9PjKH5PNGBq/C2xupezZPtKGF/VuBQbhkumWCVcGnyYjpbVhTPWpgYgEqveYLq/JLlqcEh9dWwBfsYSmPQVMpIvsRUdIlc9GaXgCkDaxwqamGdTtlXB5OSzK424i4qb7SUoSAWJcfbdg0zT9biv1oPARqbTllrhfU3oWSqI4t5O4VesgGh/1eKU03baBASdGqBwS5XGymcIXuTB/H6p4NTwngkPrxVKlkzYzWIS7U8ginbuZFazNDo6JcB2BxxducC0E0HdPc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32616b28-650f-4689-8f6e-08db6e85fdc2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 16:23:17.1683
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkzI7Syd8/PrjcRPeHrkGvE0qmFsvOzgns2hsJohY7F9Wu6BKm2azx3qKxN6UKnh9pLE8KE6IMdTYWyOB28I08bw29uMSNHR8Rg2gjInqzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4170
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_10,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=877 bulkscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306160147
X-Proofpoint-ORIG-GUID: OXP1RoOnCSSZNMLx-Es8G6piYgnBy3i3
X-Proofpoint-GUID: OXP1RoOnCSSZNMLx-Es8G6piYgnBy3i3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> System crash when qla2x00_start_sp(sp) returns error code EGAIN and
> wake_up gets called for uninitialized wait queue
> sp->nvme_ls_waitq.

Applied to 6.5/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
