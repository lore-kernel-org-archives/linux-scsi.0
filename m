Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFF3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 03:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhK3DnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 22:43:18 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49348 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhK3DnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 22:43:18 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU1R5bq026596;
        Tue, 30 Nov 2021 03:39:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PO9vXuWg/kByiqj30ROqwLogZlQIS4Vf415+2G1Axqc=;
 b=mKw5icP7gvFufanhNh2XZmtVRWM3WklWMllQlgQ8CEsBRbhk+Dnc2lrSV+9bHYgO6vmJ
 22GAtI4VGaHCMJcgLoFRMuk/gV6L56hpgEk3D/j2TdPdjfzaAmbQqLwmhjBbberKGytL
 21tDU07tD3eRlYsdjYVypKS2vXrjPed6EmvKI9FFQXxHuLz4GW7dTVYpDReNWVMvrIRn
 8hYbf0xucTcjuO4eMfSq+Wx2/zIi8FS9T8Udvwr45WYKJAvYuBTaKQqECichGj89flSJ
 p7uWx4xQqg79TEGhQA7AzGxddzmc3cjPe7+1bwcj5jv1NvhcxLCVWHxTRsmxGcke7EZf Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmt8c637t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 03:39:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU3Zalv152676;
        Tue, 30 Nov 2021 03:39:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3030.oracle.com with ESMTP id 3ckaqdxycj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 03:39:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hH2AtrIaI4a0Cbe5Wl08oClPwyXFYff8EX/vbYPUsChj9F2PEfbGU/eN2H5aSyNIyGuTb9cnHuWhLGAlYX/1Xi60U/XdGV9nlsY/0deWvA61KTFGR9sx8mMDqr00e8ygB4R16/lH/CBo4OBjcDs/cNeXU42TUcn+IBN6yAn4cx5gp7xsjIKHgBPel0XAlu+5DwBYqFqB4iQRQS80ik2leRxnha/ZTt3NbWwuux0BJS9StIHGdR/YxlaZlWkKdW891WZ/y6xAI5O81dGqOK7J+x23Lc4uIgxyDHob8y3GE+69AvYhOeKHsSgkk397kgDcLMl5D5XrIUTzdmUIXisfXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PO9vXuWg/kByiqj30ROqwLogZlQIS4Vf415+2G1Axqc=;
 b=W3Gn0cYs1KemldBgXV1DA3m9BPTvEN8lBGgH8ys796+kkS3ieq31dSQPsD2yURMram050tyfHawBDF9SEDVFrc6ccsF+o+Fw5PaJSnXuInkCL4IQY6zxcsMaj7SoLOp207I6dttD2jCIBHQ6e/u62SwQUz517Y1PSwCUCXAq1wf1B4jNPqoNrHALayjqfeHWsm+FjX7PpSBPwzv1CPeJo3GL3IgN86OE+E6bkNuB4iB93bLPG9a3LY9dyEVDpgIBzsNYBCmllh70YxMKvVl6b3JMgbSkb51nlmbXG7Um8Dxof4orFhF65ISwCuOANXpSrr4ECXf7w+keh8PENpso0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PO9vXuWg/kByiqj30ROqwLogZlQIS4Vf415+2G1Axqc=;
 b=NcCV5HlQGfH1VZCWJ6pS+c0cg/VRq1Oqj50fJSAIcvz2cgBzT/E1SPd/34fINK7ywuiQ/6xz9EsJlYJrxMcIbLOsqG5qV+lYnzsuVzp+t5qHBwFHsUnjtmantJ6sA8U/3oAAR0XgZQOX4q/2VI4m/KRlBBJZ4mAN3xxZOSyLpyE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Tue, 30 Nov
 2021 03:39:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 03:39:54 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: ufs-pci: Add support for Intel ADL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtlmz506.fsf@ca-mkp.ca.oracle.com>
References: <20211124204218.1784559-1-adrian.hunter@intel.com>
Date:   Mon, 29 Nov 2021 22:39:52 -0500
In-Reply-To: <20211124204218.1784559-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Wed, 24 Nov 2021 22:42:18 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.10) by SJ0P220CA0014.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 03:39:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dcb4efaa-3952-4604-671b-08d9b3b3126a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-Microsoft-Antispam-PRVS: <PH0PR10MB44082777351706D3D39676F98E679@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fCoK0XNjYq7ShoYWKESDz/yUxX585YC+kEGsT7npu6WeNFQ3U0AKTrHplVada7mchuNBf7Oy3RutTepej+/mhzBxn4tn6Sv0vMNUfGzpP/l88ryGfFo7DOFk7fBmxsYuEgFQNl7WwrbGKz+XK4CF4TT/Vi3A4tH1anC8aWzBTim7r6xEn04pQZIBqDghP9OLPGrnJS6eeCOA8HVqMl97KhMKHxP9Rp99N8w7ueqyoonGK7dbbSDLgOEG6lHcEgYczloVDyTXUD1qSy5j1JkAYnVr06O0vAR0ucCXyQIq7tGoKP1xsVqa5+QRXcGqHqoGZmT5XN2oWo3A8W8YGSgJ8I32tKDBK4UIYJhr55tKcWWZjcxw6WthPyUTGrH7/u3GcBhnIrUyjccKpnTCzFgeaB+Vzp6JBk5gptat746xEzCz5/OMj8x3zRANXrlxq2ZXgZy3V7kIKd3+MT9p6oVZDLZVWeyvOXVD3hOP1S6sId/3l4snNgxDA4hiu/E3j2ipGrMwpvBgDJeyFxEjcwgctZkbPp7l/EhrVpsB6N6EW8ley6GoZnD8zjCpLr+ZptFnCWhtujMXqWEtOhT+mYs2+sLExX5uySdRU4M/k0o74Det4qrdPEKU3Vp2yn+RXWs5gfbjuNK7sMkVa4MO6Yv9q5rXE4DpxnMtu0evEZg9d/zVa98hHJIeumsLA5niXiXPYIL0baBRff+aIvGFTouajg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(38100700002)(2906002)(6916009)(4326008)(956004)(52116002)(36916002)(7696005)(316002)(55016003)(8676002)(8936002)(54906003)(38350700002)(508600001)(66556008)(86362001)(66946007)(66476007)(5660300002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fNUUBnGp6U0N1nhf5zBOXABrOchCeqL7co+xibSqDxOPKgMZuLzHjci0JDFp?=
 =?us-ascii?Q?7bgUuIHXS257GdEtFe/9jKuYtUO7HDg869Awkcx/lssI3Gs+WFHk3Qybpjzy?=
 =?us-ascii?Q?0NjkcibmZvpZuajBwq8nY5epy23aK0Da9dzhLK6bv3vwA+RT9NY7Y/QksfNU?=
 =?us-ascii?Q?pYWYonGF71njjP972kil8jANDPXoXPl2SGIyUD6oSP7bO6a78TGM5PkgVXvU?=
 =?us-ascii?Q?rlPUgcO0JDzqEgzBTmESMQFnNSPQWz1Efy+4Qd2jlsX/kVtXiAe6we5xaEbq?=
 =?us-ascii?Q?K2d2bIOr739XemXd7YbWqxcgOmNNdVz+/6G7Z8gGrLfDmOSqh6ooxxeMjZav?=
 =?us-ascii?Q?Ti5qq8K+DdfPssIU7S4XniNT/UWhUCOBcT1zT8zfm4EE9dl28nUSFTpESJRM?=
 =?us-ascii?Q?8YvMSQqMzBrnb2DK7+mHhgjekfEfEqkmssW1eCALnZESq058SRLyT3pjOIBK?=
 =?us-ascii?Q?RpYWAEWGt4K3YwezqHX9dcOrYyCxepO1WynXNzl2IfRgqeio2bdz9NAwZ7n+?=
 =?us-ascii?Q?DdsucqLbu+in5NGqKjZ9LuloJHEzrk1H+iJecRsxxni4yj2tAfYMHCAcWiZk?=
 =?us-ascii?Q?90ia9x32C1w+699qOwpEp8/QGZ77YBFm4UbXA1n5SwrwSBAuUaWd5R8FfJj2?=
 =?us-ascii?Q?juFfK6ez/ppEdhHerK2dfGYioRne54cvJDEnA/nD2GQbUAQDl51qtapt19rm?=
 =?us-ascii?Q?DD/oHEAb6BgbuGyLVDhUVOD8EQ6chkVpoHVoP0zcFxitmqBLLbcHulkNCCYy?=
 =?us-ascii?Q?5gMu5bIYEQBlSPlCzH0N5OeL3mycIfHd2U4yJ9saBbawWRs7uGEasfBNey4b?=
 =?us-ascii?Q?8M61MAYfAFMrZq6zLQ4gY9ok7o0OngPjgRU5rHEFXlz9ku17I6TSm98kJGTY?=
 =?us-ascii?Q?2EKMFzuBPh9yfJV+maZ+e3do2mDVNuPeAPZrHU5dUT0Yb7bFARicZpax2RLY?=
 =?us-ascii?Q?xwKMFHR1GwqOs5goVgo2YmyvCQ7LO6D6Q+Fzx6+gnmj0Bk1Gv+G7gHwJ4FrR?=
 =?us-ascii?Q?EdXEqCcDMteCiQkIQB4D2U11u7olW+560J7wAtMqeVDrSRKDrQJv/jf9VlUv?=
 =?us-ascii?Q?+YK3nl+6wUwFACQwNMrX5rCihKB2ophKox/Qe0VylUbEKRrTebYiqZB+TnRM?=
 =?us-ascii?Q?fQ8eXPr0gvDY5v7cevgSr1RWq/J0TmL3keMIVSrk4uRn0HiIO2ehMh5c8lfF?=
 =?us-ascii?Q?A2rbdILlHkniXeyMkEfpDEZsY+/MVsahv6B6AsA19hWfQ4xAfRDoUIOjEqmk?=
 =?us-ascii?Q?SzQEWGoS5fNUyassHTqxoUVUXDp3ZSOOKej1+cwa3FKyvmC5z3NlC4GB7vGE?=
 =?us-ascii?Q?GHpreHcm+YB/3AyyKaLjDsl2hufGM/ToiYK13sDw18VsBMggqXDSvPSHFYtK?=
 =?us-ascii?Q?qFsxQNT6OugKVUqBJoyl25wSEFX4yhi3GtIXBjIDudfBXS+DIoLIclquaNQo?=
 =?us-ascii?Q?W/a02r05mUj+UcfW2P4wvOLtwLP1x3sbuosbin7tgX52pJB1R/HJazmrgNJy?=
 =?us-ascii?Q?YD3WCsh26cSDnLqyRal6ySIhSSiEKfcW0HlEIsUDslJ2Wu1VUByXezMRUgx1?=
 =?us-ascii?Q?ID4Z41guOUTs/rNUwojv4XmEnNxNGUu8V3v+b9ajlgWn/hSpFRqHoNcPI3vy?=
 =?us-ascii?Q?t2YniHeq6QTrgdVowvDc/YG/Uu8w7XA+Uaf4lwjpmWhFyStk6Zjy3rUaV9+t?=
 =?us-ascii?Q?M182pw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcb4efaa-3952-4604-671b-08d9b3b3126a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 03:39:54.0809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LxxkBnqvFH+J/+Ct9IOWIaNF58CYa6VQDnuFXJB7s9PR852JsAxL/1I+Bqc1AaOfcr/rlwormaZY5izlZBIF5UmYiQkE7Io4VrynjMMJHRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=988 spamscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300020
X-Proofpoint-ORIG-GUID: z8pcZK-jBQGp27Pm2CQFSSxvakuRjhTq
X-Proofpoint-GUID: z8pcZK-jBQGp27Pm2CQFSSxvakuRjhTq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Add PCI ID and callbacks to support Intel Alder Lake.

Applied to 5.16/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
