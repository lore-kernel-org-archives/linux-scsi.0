Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFAAC4332B
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA79D20723
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 06:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbhA0Gbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 01:31:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32920 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbhA0DJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 22:09:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R31w1J114724;
        Wed, 27 Jan 2021 03:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=e551TuurrLpo6+RPI1DNevXI5Qvm+2XXO2LwkjTRwS8=;
 b=cj6Wws2+enNaoPs6LTJjZzK2n5G8LEj8XioBxPH9jMztXTwlLH6IyHL5zois3kHUIaui
 1bsqO4r/xodQknydLuFmJQi4gB4sKxdzFpfCBESR6QlZJxvq2x3CmYUxOuYqwMj7wT+a
 Y61i8Sdr+5tpvyTp74A99TDbSEuD2K4xLbAfa/F2P7n0l+q/rrrnia+oK6cjDaT2h2HN
 /B8W9V6LrYyw6SW/wn7c+8yQdRgtyVEKIqnghgX5xqMkBbavKglXBymQsS9zAb0QfWqE
 6J7U0RZhhsDugCyWNfJ8cYPxIq8jo2H19TZ+XgW83M9ZbcDCz/DsYY4mRSujOmLfmz9y Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7qw0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:08:52 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R34W6h021742;
        Wed, 27 Jan 2021 03:06:51 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3020.oracle.com with ESMTP id 368wpyq92d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 03:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDkX6Di01y4MkMjXyCPZuc2n0PLBcKjCO6+xIQTdqUqKYGGz71vsMdpOmP+uFc9+kAS3VVitINOyR4lcs5ZVWDPKHgXBEBtU/wuAUfIKPP0UFRtgFZ6mByvI+J3jEy83DRvgbs+MNVY2YpojHrnKFTiCPNYTYc5nGIz/dfL1LxNCMjR++l1ZCDEO1opJdwixqEFNCHoJzU0wBwRlezwuJQd2jUDIWW/+QRifeNhPQG92hzJdWVUR4Q32qZiXXaP50OC9swnUbaHepa0k15tOZFEkVyjzuWeMqZx1s7S4NmMRIlXs8SAvAnLmeY8WT1JyKdkUjuQSmycUJv8l9rH/6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e551TuurrLpo6+RPI1DNevXI5Qvm+2XXO2LwkjTRwS8=;
 b=WdbTHZg1N5ItcGa2nAOKGyj78ZQvNMCvCKEuUC0R95QI30qx+94c2ik0n5k7psGSUtVAkP7R/vgJnxthdG3wjJsLZWHT4U0PMvFB8dsr8SjrTtKatkqU+043QdYnxWT58xB/FtYAHzYoHAXRru4SH10Wdv5ShFUw6sD4nVVMak7vpOUL8seBkcGggXilar2i6M4V3DN9ndayBso80K+Q1qHHG7tVind6GyuYtE4OsgNbLN5uqtF7rueK0g+9av8xnPQQiP/K8bjqRV0hLdTTAUAvD7xidMeuCykV97pPknCFrgKuENe0NPNjJXpC0tQNKTUm0PatYKJ2X2zpQOKdmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e551TuurrLpo6+RPI1DNevXI5Qvm+2XXO2LwkjTRwS8=;
 b=uVvCxypZzfr06zYB5+cTGGJJZjwTfX1FHxJP9dkl4gLn0jQJZco4pMHEzPTROJLfdLRzJ0B2m39uMAXMO/1Ny904bbFSL0F/pUIUjVaIaKoifNoN8v/DG0ZigjdyV78nELIi3dS4DI4hk8B0ilQbIv5jiseGzDJ2DqQhn5g84kU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 03:06:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 03:06:49 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: fix some memory corruption
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7n3xem8.fsf@ca-mkp.ca.oracle.com>
References: <YA6E0geUlL9Hs04A@mwanda>
Date:   Tue, 26 Jan 2021 22:06:45 -0500
In-Reply-To: <YA6E0geUlL9Hs04A@mwanda> (Dan Carpenter's message of "Mon, 25
        Jan 2021 11:44:02 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:610:54::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR11CA0029.namprd11.prod.outlook.com (2603:10b6:610:54::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 03:06:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31e5f1a2-2d13-4aca-db88-08d8c27096b2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44234C3F5CCDDF4B94F933E98EBB9@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjwafRBj3hYmJhxLYCzj3PmmNVCOj8cfLsQb8fYw/2SC8gtBO4tpnvmt6t2OrnaM6dCUX7m7gnnpQoy2WdEVchsNPjGOcAfMzrAqtHTivoz0ZX58dBz/Yfn+JPWkE+AgYKUrGDTR+zEQxQBPCJcfQRP6OYmbtw9d9lYnR80POiy0rcRJLUimDV9rwNbGDtO9qrUtwZHtPwDnukG+hbfWbJt6FUIPQPIcHTxy+B9WYqyCaFP7yG4Y5NkO/0bGqNnOBAuwYCHvBGuor4GtAmfus6pckAcchh07mWDXx2pQJnWHY2T7yjbFL+RFT69TMpuH+KAgJwnjbaJ0LD5+Oph4Rr+bHb1sljV9Cs2NpZOHGe76d6/wsVly6flX1KE+63phyCQ7QWhZoD5NWKeJIQk36JDxXNKWGYo79pLIrJIulUIatq/v91UUrg8hnQtH2uaqBy72ezVZ6XH0ZNIWRgP3WGQi/3bYYCdMr+DJPdelDA9p0RsXd3YWdnvHOe239t856ueoks3MvR0CSQnlDOthPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(346002)(136003)(396003)(52116002)(558084003)(5660300002)(2906002)(7696005)(6636002)(6666004)(6862004)(8936002)(36916002)(478600001)(66946007)(16526019)(956004)(4326008)(66476007)(66556008)(26005)(54906003)(8676002)(186003)(86362001)(55016002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ejAYkiaseh8tT3c/wJLwDn/U97Cfb/epGRXISJBgDCTpS3NWrHANu9a5CSn4?=
 =?us-ascii?Q?9Au1/I6Vc/hb0N8903zgamUDavcPVOQsJ1xoyNdDKxEVNgmvK6w8u7fX/xVO?=
 =?us-ascii?Q?0jJpCJNfSVGcZFZMBi0vzBQPCq/0WjA73kK65f/zZQ5D4f7XdGIZzhklVKh3?=
 =?us-ascii?Q?aL5jL9xGWV6M8jG7cvXITaXgJzSrpK8wk//NnId8n8tsU2BE8DEKI1fXSVUE?=
 =?us-ascii?Q?2G+4DlVr9ffo/JQ9HxJIs1qpL8JlC9HQNBwTpsM8doP5k2v5dlJaj6XyavJY?=
 =?us-ascii?Q?6A2RY0I/wlQr+MvUdmeKW/njPiiJ1QMxcpJzF1xxSHU5Ullkp9ouVdmUkrtk?=
 =?us-ascii?Q?9YFX0sioPtS43rpXcK0Rfx/1/PlrD+Qq7nxKUKVBgP+Q9zicaBRrCZJWREt5?=
 =?us-ascii?Q?iwxum60U5MMD4fdAMyuhZb2Byhk2tYnYKlVRMMU3x4AYWDwM/5tcDWWWH1xx?=
 =?us-ascii?Q?lSUETt4HmgWQKL+bbkviZIRgSOdHrRSOu60wCqIH7ZytwC5HlLn/IdM8tx2n?=
 =?us-ascii?Q?T4AGEQjfQEq/PKBru6wYtbTTFLniF8MQabIAit9ZUxce+IO9x72kXuE9wBk5?=
 =?us-ascii?Q?FVY8yWtKfb2yFWNpYc47FRf5OTJGoCnCWgcg0WmMd8t9YDTiwsKh35X9J6xt?=
 =?us-ascii?Q?98kje5geObcarWeQSEEMmufAxkf5Db5hRI4XBXtNmrYiX2LZtueFQ1xX8CIK?=
 =?us-ascii?Q?+G5qnAOBA2bXEYyQ7rey/sq/GsU8JGqQvWJzmiXntecE2LX1zAciz5Ddlb9z?=
 =?us-ascii?Q?ehuW2C23EFzr9k3A1Sgiikb8RJwkIJWKoVQ0M39nvc2nK94hbeaR4Rv8M4KQ?=
 =?us-ascii?Q?JvYqpmSag+5t4W2vjkxNM+Y7kJ/daKdzmbDBdaH1kVFIxFN3+Q+QcChw2GXK?=
 =?us-ascii?Q?WaVzrXRnWw5FQ49G3LPP6wOcb7WcN9EkMm+zUYRK3QPPdcpL0qjXnm9f8n1n?=
 =?us-ascii?Q?bosQnA1kvOr3EIH9jkASnqag0mlU2QhETo2zoHGt8y1mccwh9aJ77bNk5Cn2?=
 =?us-ascii?Q?Yo63FHOw93iCznIhvuzaacHKnzAVOOy0HzdiZRcRLlvte5oDvqzPMaN+oJ8p?=
 =?us-ascii?Q?eXD5ySTt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e5f1a2-2d13-4aca-db88-08d8c27096b2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 03:06:49.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sqdMMAL+7Bh8ZQqXQoAv+uAzqu/RH7571SPn84mOsDB8i6W7/EyvVg8KZeyEw82/bvQK+pC8W6/sI4UGXEUkM3VeSdKtLkGvwib/Pp5iTX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270017
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> This was supposed to be "data" instead of "&data".  The current code
> will corrupt the stack.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
