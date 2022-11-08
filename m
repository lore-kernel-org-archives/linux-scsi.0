Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0068DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 03:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiKHDgo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 22:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbiKHDgn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 22:36:43 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBF113CCC
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 19:36:41 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80OMK5018354;
        Tue, 8 Nov 2022 03:36:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=RzDFv7vDJq9awob7FnN/G5pKllNb4phv4crVFOlNJ6A=;
 b=G5GJFDzM6W5v+vI6rmRKPhcVCdIJRzjMCGXntm4nOEEK069vwroFUjcyLwdllKr7FS7V
 WcFKR2NbQvSFmE2dkxkO9UEvOfVz9uBi3A8lUVEFTFMOez9KejTgQGEon8/yykT0weiX
 kBYlMidi0qUevXHXY+59FYmBT96P/loDUoD9dl1RWFiAGcj2yTbofdrQONdzpZg4JNhk
 gqLFRD9epfMCLKwluhKIz6UC9999pcXZrmvqHasFMORmhutFd1KZPqp5WqEZdZjuRn21
 1//VUsXKl2TDCuDEiKUl49YZOlOhnJd9pbBIvk2nUTuUZ9c4apN2Z+1vYjvF7FcvyhrW YA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngk6e4nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:36:39 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A83IuTk003328;
        Tue, 8 Nov 2022 03:36:38 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctbq361-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 03:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0QFt2il0+GagborLcNwZ/8xs5IDCxBLYBnZKFK6kZqMuVSa2roIeNxBu21fMysGbDpRv+/4O+vswJrTCzhKbzP2tEKOaTkiCMusG4kXoru2NaNYvlSN4qm/wq0BPJxvRXw1RbkyPEF+Ge12U0bJKGAM6enq7RLJQvRS+qtiJddNVp4KbReM4BXk2qLNmzyah/ZsfA2x+FApdsQi0CYGcnJ25LGgZsoavV0P30/7mSB0dbz/2NKLZLrGjddRwVgk7kwSMvEtmc2dC/jvSkwedqsAlkt+QSSDqIAznAgQEptw2fKl5FHEj5CCDLH4/+sOM78P+lBv52JAq9ppl0VElQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzDFv7vDJq9awob7FnN/G5pKllNb4phv4crVFOlNJ6A=;
 b=Rei2Ak+imQcbPrwSHw2gaNvu2u3Z0Y/NQ2MeiqiQPhPIqKRO2vB5g3sJUueR6EDhUW6awAqq+QYnyi5jzUg7w60JWBxQruVMCs/IvLqoDPM931z18TsiJTzh6yevgIxMZfqkzvM3Gy5QoW0bDy63mS4r9n/zYpLrO7F4CIiVouP+r/fBNgEu9boycEFu2FHE0WQAF1suRgkrne4l27C8EdPQPE9DbFe1d2stwlqJZ7XaV6f4j460aIVXXuGeA6Y7TSMWHFzx7hepCGKfTP6W0ARINYU8kLIFM4nfNbg/zIH9xRuPOHPnxWsCEoMZpS8+rWRbF6SLXmQzVAJwt5NMPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RzDFv7vDJq9awob7FnN/G5pKllNb4phv4crVFOlNJ6A=;
 b=CtrBr5rK42O1Wqy8K6QNvkyHh37Zto5eme/8vLiVp7HsnMFgAmL1A5srAeV7RNh5sERxp093PRHhmXqAZpbJuELcAFx1vS5sDIZm8Yq0FoO7aK8whWq4p7cDhgNe4wBAnRSaoIq2//8NMYxl4bhHBybHZ2ucdfaDqTD8Rx0T3gs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4182.namprd10.prod.outlook.com (2603:10b6:610:7a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 03:36:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f77e:1a1a:38b3:8ff1%9]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 03:36:36 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/4] Call scsi_device_put() from non-atomic context
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fseujexl.fsf@ca-mkp.ca.oracle.com>
References: <20221031224728.2607760-1-bvanassche@acm.org>
Date:   Mon, 07 Nov 2022 22:36:33 -0500
In-Reply-To: <20221031224728.2607760-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 31 Oct 2022 15:47:24 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0233.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4182:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ac3aea6-2ae5-49b4-db61-08dac13a7049
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyGqFZgexj0aDdFSl3kEmrdFtyr1fXlYcXMgUpJ2ZdwZXREpB8pvXi2t7xEsk3m0r3exJajnyy5Y6mu6pz4Ncj6qXGhBGcK2Ug/3joKtWMWfSA7s7/SYzntejC1V8hp9ja3ATPw7lLaBesOqHzUe5jTfraqAUbynxlhn+/wGOml+PKYZyZ8x/pckixjBl4V9GMBT/V2swwavwB2i5obmkKPDne0q5uspGO6d+YV9waAzujuI4Cx2Vka3BW/MBIbzAktNtp6/bER6Atj1phm9/WfFlPrfvNEHA47KBz4qR1iGWfPvzH3ZggYldnsNhl+aHVx/0hZyNkbjGvl2est6Tn927W894mgDiL4/pocdTCNyJHYbtDrO4Avusg47iCGuP/Iy3RtcXqunRRjWEqdi4eWrTlDGKUFL3awqx3YKnwTxBTpTL22uNiSOQEP3rqj/kh1/ykUYbo4uVIsyvgZplyM7t7JyHmAoJjPD8x0jZ9paovvXZPJsWH7LGY9iz0R/sGN05Wc/JxqhvfSr/66p4KKT1T/v7/RlieXBhwl2A19DW8O+yGN8nmLR0Fznic9ZgxuXmhVgwbEsKKHDb9KK/tziDSAL6pl14cDiF6t7F5D00zphN+9hXszcMCUwqCL/e4B2/mAQmTlxOOM2ZbWpJngT8zQI7dIL+EUF0dWQuaYKDx6XF7ToR4MRQHTuxq6Fnj07UjbrpXpFRyFnxxKMkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199015)(66556008)(4326008)(8676002)(316002)(66946007)(66476007)(6486002)(6916009)(2906002)(38100700002)(8936002)(41300700001)(4744005)(6506007)(6666004)(186003)(6512007)(26005)(36916002)(478600001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Van2LZU2Hgw4Z/fHcP4cX+MKBbeA0LHrQ25BxrYkUc2q9zm59dERNi7UQk2a?=
 =?us-ascii?Q?cSVGWT4jhaL76aP0O+w+RBf5opXjYMzPAbXm5nULjbeHXAQQGNQYp7ag8KdJ?=
 =?us-ascii?Q?yP+kdeWy32tL8lXtHIJEb5gRqA4CIxvGY7QfEuFTq/4+SMkuEdwoFJx4+ffV?=
 =?us-ascii?Q?anI/dZY2bPKair+vaB307D6eMG6hS14D/AjLXjUoq4hXiDsCxjq3A+I7m3fE?=
 =?us-ascii?Q?ONgAHye4FS6isVemPkwc2wbZeQRTZIwB8MrxxogKm+rcDyV+Y5T3rAgMy3eT?=
 =?us-ascii?Q?DPgERKNQPzRze85AtVy0IWtO+yS/cW5Mu1auaxR9SeZXL9bLwFKThC2JQWaG?=
 =?us-ascii?Q?mNtWWt/4o/M5cx9CuiIHctwO9KaGOYA6K+ERWTXQM0L+GqpxBKFBx4wZOSQZ?=
 =?us-ascii?Q?al1dZ3ikK/N2gztcOn9J91ohHJtWf6rYwxpeZfesJ3FN9VefZeLzHKFbb+7I?=
 =?us-ascii?Q?T5EbAYOpvtPzMqInYNXiovk+zvExO68mSGwISzfB/iFq24WNyLPssg3U6gGb?=
 =?us-ascii?Q?9kF00eCeYVwwPeU6ZfL4tBb0Os0ktcx5O1qYgQaZ4lPiS+IBTI0S3AYnYM8o?=
 =?us-ascii?Q?WF3Y6eYFB2TPeenLvQXDI4CV3gLrULW/tE8isVP3pakZHrb1SLi69kOPBmMn?=
 =?us-ascii?Q?zpz+TR+k+8frxE55/SmFTzMomMrUsk/2fp6kBxWYgBery/d0jMZfnId5/mFS?=
 =?us-ascii?Q?daMv359zhwIPPzcZ2LhieSywEQ9OoWRGGBJgu8DBQ6JLKFrfdSz6pNytuTyh?=
 =?us-ascii?Q?ZmuFdedI2RdtxbBGm8E5Oc0VA2iLgWYQfSg7ojIma/FR3hGju7sVSrcF6NDo?=
 =?us-ascii?Q?2d1h1u3MUP4BaAYU39DgFsraGeiuKYnp0CCMCrYanFstnFStCrnhP30n4mQA?=
 =?us-ascii?Q?ypFATpEXsBoKp9DjLPNZNGlUBKoYUpdFY9NW6dNwxmt9Y2evTgDptsVGrQRA?=
 =?us-ascii?Q?6ttQ2Y7Fk65jWfERgpWijCtGlP+yzqrpLJ0YlNurdhyRJHOZ5sVcEzW4j6xu?=
 =?us-ascii?Q?T2zLgCne9FYb0W45FEyLqxFHgwbdfPNQ2r+U5N/tglVhTBMVx2FwPYyPH9DF?=
 =?us-ascii?Q?zVW6HIVeFnBHS2WyLIxCPxmdCskz83oY2KfG1tdWsMhKas+hyCpDgXyAN1Gt?=
 =?us-ascii?Q?F47s9TLEQcYv+qxg4YaNcXESuTnYiSZl2v3E5rZMiIuNpqtVMaVh5/UZGQOn?=
 =?us-ascii?Q?wDO4EVgJEdoWwv8SFJ/YMLwhzFHYWIGIxiPlj90RlK/6tNb3j1+ovH444iJ9?=
 =?us-ascii?Q?XSPJKGVD7KWNUuOlItniCbs7OWBWG0imT7mFsCbG85pxI+kYxLYSJYvCA+R2?=
 =?us-ascii?Q?E9wK1nWCaC0oEo2KF+2AU/SeFbOEByunDeO9s9ij3ibqfjM1ePOAAdfpuOis?=
 =?us-ascii?Q?lAu0BwD2Ns4+mwuKIHhC5ZEDsfxi7nWRo6fVLK67VF+V5KxVenlk2UNg+Vdp?=
 =?us-ascii?Q?GdmbqjuO/Cff3GmjenEJVU1SSK2UBNrCwUYxhQVdbBUTTYvrjGIOQ5l4fzet?=
 =?us-ascii?Q?Wzv8c3gote7S/onoOIIJ0mWbtuPccUzHFEUbL/w7enoCC492x6AgGhja3qBL?=
 =?us-ascii?Q?4CJ7WHntngIjfB9A71UL/ONAVuNCbkkvVsSgEq728TwQpOmRaOMbYCACbDLL?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ac3aea6-2ae5-49b4-db61-08dac13a7049
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 03:36:36.5623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJC2yrxJYjYwK6hCMNio+9AOkbONJc0p7vOTUIwO7EkH4ag4hYqj96aHO2H10QrOF7OFeCvSV+x7CQG9Bsm3+SxTO+vBYpdMr4NXStK8ta0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4182
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=897
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080017
X-Proofpoint-ORIG-GUID: pQEYABzWgMl_2gscUDyJ-ZcA5kUNeS10
X-Proofpoint-GUID: pQEYABzWgMl_2gscUDyJ-ZcA5kUNeS10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> As reported by Dan Carpenter, a recent change may cause
> scsi_device_put() to sleep while a few callers remain that call
> scsi_device_put() from atomic context. This patch series converts
> those callers. Please consider this patch series for the 6.0 kernel.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
