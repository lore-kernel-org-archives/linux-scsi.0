Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B44C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 03:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiCHDPB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 22:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiCHDPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 22:15:00 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC28DDFF4;
        Mon,  7 Mar 2022 19:14:04 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2282F15M009301;
        Tue, 8 Mar 2022 03:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=4qC1KeeKS0tp3Ts4i8vjKscSdMj1i4qe+63XaZ2skng=;
 b=C8hgZempYQK0XooQzqWiBbMWaJW97vVyCigt1BaDqajcbvG0Qj6Z6jS09bMm23uB3qs2
 1FYLdDiiwVs/syjmpnfQRmkmHVTYEfbxvhD4kFwOPGiCG4c+uYg9DOaIm1Bw5z5yAKJe
 ZHaJRbLauR7FtV7UvvJRbOO5Xwoxncnn/YfopdDegVienGN4QSIuv6cfethzlMocKtSg
 IXgixYARgkp4LSGGki+FJEtwpl1fO/A1YdQ7RyzkIlr1cLrd7ITcmbF6sNJtHSxbziE/
 A1BUfOUW5NBhHC1HwT4jjW+g0pnFzwk8RBHFGG+TuN3Unnh17LxWxBYsvxeO8/o1SBGh Cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9cdnjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:13:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2283B2KC179869;
        Tue, 8 Mar 2022 03:13:53 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by userp3020.oracle.com with ESMTP id 3envvjtsnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 03:13:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOTlmvopDP9kMwceD5c6H/ey0uDeejKtsQ20s/cyfQnTlFAQ+UiNvCyayTDJaZ3sPEeC5BdT1Gg4NNN7E4VHhYaGY5NqXDLk8dNfsnesX6QJKFCeXsBzrq2rnBJ7fH438aNo1VG7c+CKCvpT9feTjfiGtGtXHkbiMrglNiglXchrkevcT4seLwCZd7QhEymiqwoSKOOt5+ltzlJ8JquZml5ChIBNrehzcm9zbt8UX+NpD+zBQQcVieFZfkz1xj75UeVS2kTJaQBP0/Ls5qtA+r9v1vOlmWD+lSeHUntAa66pg6GBCJAdixgHgrRrsSeYP8xiXKrfKacpPCIPciAHbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qC1KeeKS0tp3Ts4i8vjKscSdMj1i4qe+63XaZ2skng=;
 b=nh/DD2xBU+ZaKZvPuxMMMXIY6Ml2mvlIEzAMN5/fq7AgtcHlLDLAQsrbS9DMwN3JKbHid0pMlyRWeSNiNSj96DFY0C15dZe+m+qrNWsCzOU10bmQRE4t7atcMvY0ODVz5otMRQQcWhQpT6NIXXftrBT5ADwfldxP2KRbg6MEDUigdBB5HnH6rmosHAUGRbPao+KrZcEVe6DT6N87Uul8Qk/lLpAWn5wsWCy9+ovTBXLzQAnLs/bYtTwMXeo9ks5wXyYRj5adahzfjDOcuFep0eJaopb8A7k3ko9iJG28FVUCtr4qo2ELaWphUwxB6qvagQ3B8AeGCY98zL5LuNamKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qC1KeeKS0tp3Ts4i8vjKscSdMj1i4qe+63XaZ2skng=;
 b=d4cbSkrZBpE2HVhjE/XgA22fCMj2mLvg7sT0ycaagYZ/DqcX3hszRB6NjOcTIoARLmDiOjq6LUhicJBFSy/TzeUe7b9Qqf9aLAUJtJKW+tKja/QR9zr8QdEhRPyYzijtde2L63m44znRhVT9HyZSSAav/IHqQ4b1zRI4ckEvfP4=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2255.namprd10.prod.outlook.com (2603:10b6:301:2f::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.23; Tue, 8 Mar
 2022 03:13:50 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::b51c:77eb:39b5:f67d%3]) with mapi id 15.20.5038.026; Tue, 8 Mar 2022
 03:13:50 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/14] blk-mq: do not include passthrough requests in
 I/O accounting
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee3dqgpx.fsf@ca-mkp.ca.oracle.com>
References: <20220304160331.399757-1-hch@lst.de>
        <20220304160331.399757-2-hch@lst.de>
Date:   Mon, 07 Mar 2022 22:13:47 -0500
In-Reply-To: <20220304160331.399757-2-hch@lst.de> (Christoph Hellwig's message
        of "Fri, 4 Mar 2022 17:03:18 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::34) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73bb1766-debd-4c73-f6e2-08da00b1ab08
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2255:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB225580499A390AEA7495FDA98E099@MWHPR1001MB2255.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baIhynNUyIi0R3dQy/dQm8BQYhMjLmkpUH4usVtq7YD5Tf+QpoOkA/Zl7AEpd3WDx7/KZMazIo927Yybc0i0sBxvLjyOB9pjAznb23LX0xE3n2WQX6n2BTaiKpVIfa8LlBAt3aOMUCRUN6POZpk01ZAGp4L3GgkjLa3ZL0cF8w0sRBcw9lEQMdaojK+Y8nNq/k/lKAG7BIPjnjFguwpEInoqi2n2iWD2pZ72gaBHG8alUhC9HWgeMXEKxMa+QgWQZ1kPg795+078ER2rJ4Pny0IP7sFLu9mKDrt3WHWJfiHemzfX+Jjg7sMLwsjnBfvlgOlBljOHxJQmPKoa4ub2Dtlx4mzYfyQFIUXuWsSljIjC5LbnXHmaoQj4MrzL9er4TiIb3adUjItzhH059CGFJf4oVboHhMzEMV6qPD9XEjbm6C7AbLOGNc1FQs11lOQIHvi9J7mCCSAwL/qS9ZbA/zAMdiCsqPtL8vwrnURVjlI10wdWUe5+I1Fl9mLcRL7jq5gmQWzufn4QVrF51yLTwXUVmMlqTaoo27P5KqwAyWwbDP80YYviLTAgC1Rq3sq+4SStCqGHiv8fXPnXtkGtQ5XtHkf4aCs64OeuOorOtiz5ErTmEBHPI2MtIMpqR5NktXTAbSOSNbjNkPfmU0XUpW7ZebKCNrQsp0oAmvaCUclycjkiP/c5veK33ZobUnPOLaZlsnu2P3NUqXK1F23GIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(83380400001)(186003)(86362001)(26005)(316002)(38100700002)(38350700002)(8936002)(6916009)(66476007)(54906003)(4326008)(8676002)(66556008)(15650500001)(66946007)(6666004)(508600001)(6506007)(36916002)(4744005)(2906002)(6486002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ER5mrNC7smyseGI6px8D4REiILkaMg/jgPoSelhMcAnDCAN7LAbh0CHVAppa?=
 =?us-ascii?Q?4KidXs/KbmVKH7on9idWhqgvuOKuyLTBbwl6Q/HeHkYj2Q99c4eUPNpifb9f?=
 =?us-ascii?Q?ZYMairxpnUp5Ss91gk8a0DUMQiec66dgRUmnenol/Nn+wURW5B1lwH1WqqJc?=
 =?us-ascii?Q?ihN42GazpzOCqz3Hf76N08ozbKyJIsQZbfsFYia5q9GKPhwBYiCmE4WmTZFF?=
 =?us-ascii?Q?ck5a0zdJGxjiHCvggL/9ldl2ISzDogvnFSb3BnPRs9Cnxt1lSsKi2scK25TS?=
 =?us-ascii?Q?8yO6FbNm1Cwu5fQ6sJoFB4qFTErCfpREBMSMHEcp/aXjTWhNF2zFaleLzWLt?=
 =?us-ascii?Q?/+Yk6/Gij4RhmHXvoQCut/TfZ7lcnfyFdnpPpd96FkWLynvZfeiSlGMspipn?=
 =?us-ascii?Q?fuuqlc1hjVi3je1TQjSrRbY0di4PHhwmJWbXFv80NErKZi7operTnNLDkF0Q?=
 =?us-ascii?Q?UCgr4N/1ZI78fSZku/dzSe6gy6KNB/dSeYl2sNyJoa0XuuhT6e7dVOncPPM/?=
 =?us-ascii?Q?fMW/sHAgbzkHbdChdAF+iZemTbNnIe4MRsVfQqhId2erwUbPxAeGpqpH6YwZ?=
 =?us-ascii?Q?4aSu4Cw+WaSWuTD/H1/2ZXYMPcDO+mzw3k1E0rKsdg/vm4BsWDP/KtNNeYxM?=
 =?us-ascii?Q?4EdacR43XMQaunatl/Xbzq+BAJNwZl/XaTRyi4xdFz8iDj9K4Icey2wKwLNq?=
 =?us-ascii?Q?Bm9nO/nPai9L0dPdf1K9dC9/23AE+AqD5KcomQtsnFXaPF8Yoo8+blmcmpJe?=
 =?us-ascii?Q?6FMwu+fxIeD7c1DPJrySlHV3z5G8bv+qYQOJFCVKF5xSLObOL8YHVKZRSbR6?=
 =?us-ascii?Q?5+4P55UQRof1NMEmadF6NYwY4gr9OXOu3R8hEiwOj67nP8TcJHRvoODclAsF?=
 =?us-ascii?Q?3DYFyxmJjesVBQzirO9XBHIySjxfDl/HyPPKEoNaTPQk3XDxB/G2MSTI2sNK?=
 =?us-ascii?Q?f46xXlKbaUgnmRK6MX/lltYtdZlZckbH/Hv3wiurXjeHoWIj+foodAtFG9s3?=
 =?us-ascii?Q?GdRWnODU3p3/5nHJk9QAEpIyv4WIs7mgt4+XhlfNNDMpRQkYPRrwnmKexFYB?=
 =?us-ascii?Q?tKggepQduWuhI3myVjb6Y+WI02qcLULnfda36rVI7JqnhzEw6Je4goLfpWGx?=
 =?us-ascii?Q?rhIWaGiNe6bMcP+sr/Lhh508y+duiu1K3xyAVWvItUNWgFXTRMhYH1Pu6kkf?=
 =?us-ascii?Q?nyq5LHqX9p5CGov2jrxV5UgZTKbYOILFxAZj3/alsVI4JGihHrdA4thIYacb?=
 =?us-ascii?Q?6JWc2IMT5Du33rNNfjPxgfV/ZNglCbTwuh9fLRGoEXZxn/XFmLhLnG9bpb9X?=
 =?us-ascii?Q?MQMm66vK8Xul+1O9wUWlkIadY6nDGzspfoCpq26wnCu5Dgji+9nR0UWBjfPX?=
 =?us-ascii?Q?zxRwNk4JJMllJAm1Ak4GhaIPUbniyzC/7AFAr57OCFiKXKkAecNufm2B5ZNs?=
 =?us-ascii?Q?5El04Lsv2SRQVeOFu8CcMFfrs77s9hr8nFyfTE0eS8IrP6lPQDKUDENhsx1h?=
 =?us-ascii?Q?Ba16piRsehPriLOs8idKOPVnG7rkq7SxCaWC/qOxbRkqkzItxlHKPdzqOrgg?=
 =?us-ascii?Q?E/i7H5n8DansGhNZC3yjPekmzhx6A0aFdRxUaNqthem9rxMSS2HqieNrxkNV?=
 =?us-ascii?Q?1LwijbKSsNpDc7Bw/+ggV0AN9lBR9mPKmT1PS419GUQ7P3u78jVdgNQLTdZr?=
 =?us-ascii?Q?Ek+GkQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73bb1766-debd-4c73-f6e2-08da00b1ab08
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 03:13:50.6455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li5xML8kxW6GDKM6OZL90XF5G19LmaM0JcEimkXq/vvlaMN6da9EnvJM6EWg/+kUIPObuvoOgo7AgwikkcXzqtXsVqLePdveDoYCTjyfR5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2255
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080006
X-Proofpoint-ORIG-GUID: fqdvaYB1c1xVv7wtxVILNy7vlTU7uVte
X-Proofpoint-GUID: fqdvaYB1c1xVv7wtxVILNy7vlTU7uVte
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> I/O accounting buckets I/O into the read/write/discard categories into
> which passthrough I/O does not fit at all.  It also accounts to the
> block_device, which may not even exist for passthrough I/O.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
