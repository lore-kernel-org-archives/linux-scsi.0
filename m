Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6DDC07E9A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 968B561206
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 01:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbhGMBzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 21:55:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:56932 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230000AbhGMBzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 21:55:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16D1jkJl014424;
        Tue, 13 Jul 2021 01:52:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vPMngEdC4U2bBIrcszWHxK2MUNF0W8B/cQvwAEazt0Q=;
 b=tQaTCavPicSAZkZ/tfcNG2exZRq8jwhIa6KRWUtT1XHpzRZzVyvhQDVmIq2zTgZbZevZ
 Zg8EBZqyUVicjDMDMC0CQr/nR/wK5sZHRwyJkA5YleyGl+IHw+G5u3RewyvOVN/0wgrS
 3QLIsOH2BOZ4dWPdacwXMvG9kdvSTdUus5Af5vnU7o53Jl/9BRh1It57fbDQkcNkDZk7
 61jE5P6t6RgfykSYTzxZVmcSe9O84jgje0kQ6iHbq19l+6wRiQbPfuw/ysRDQYNacDNo
 vFWUbJUCTwjPbuH0apP8Sz8D2y7Qndg/U9nym4cO5PgYfnEoBbd7tzQC9p7n2jetdTl8 fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8sec4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:52:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16D1koC7091920;
        Tue, 13 Jul 2021 01:52:21 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 39qyctr5re-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 01:52:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mplA3tyELd+vwaMsMpPrKyYLq0f5HzKKJzGUO0dCGJIDNmvTdt3m0z5cIfuEu5fgu4fZpjK/AOIJdmedoCUd1vpVhMLEELZU+X0bhxdUyQWomoMElQu8yq0+Tqj0rmLRVwt4JxH1L4kAT62FG6V8psEDJA5AMShmSFRyvq5KFtBA10U/gsQF6TQe68wRgqRUwdi9Myd99XMxhdu+vlnYDzdpdqGE1BLV7AmBBws78/uKELb3rUPXARUHtpk8boanIIDuDYZfVLuWYAcqqjBd2gJOVpwl8mZKoTi+d7KyRVjmjJkMYven/gu6PM25sW1HHsAMlVPnESrBm7lSImhHvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPMngEdC4U2bBIrcszWHxK2MUNF0W8B/cQvwAEazt0Q=;
 b=NuXprZI3RuufW70AcBN42dy7H73rGNdFOqPfbdI6UJKbVA0nibBZGq9mOsWY/3xuUXPaYfNkmq87j97ldPx6nzpC7t9XX7gIoAWwfsabLcqCfFt+N2pAhkmOFkbwEQ5APsLzpaWZe7qRBpWcAFdvpkT80zjR/CZYXlTFPp1htcgtfpU+qiLjyGP7wQVG2wU1n7VuvaB/BN/8vIS+zoFxYQgyzzYj2hlsNybPaxuLHpsuuiKhoIwJzbk4FjNYedmQB7vKOXzIkFNWn2TGZIhpvF7MM3jPmtts3u9ORElMFxIIjH5W74emcVAPGCFrDWS29k4sW+glPnh4KNkfB1kcyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPMngEdC4U2bBIrcszWHxK2MUNF0W8B/cQvwAEazt0Q=;
 b=PFISnSjgbJP6u4X3UhRtpPR4d21PAeGh7mOK0EHl5VlhH+YD5MnOdyWObqH7KhxTn/TZvO+rjrPusW/Aw2+xoi/CeKhyKzqu256NNUF3CJey2h4XjKIE5NmZqxgAPzPvbY/2Pc+vDyiK9criJLVviUCw/HYkyX4N37ryXKB9qxc=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1616.namprd10.prod.outlook.com (2603:10b6:301:9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Tue, 13 Jul
 2021 01:52:19 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 01:52:19 +0000
To:     Steffen Maier <maier@linux.ibm.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] zfcp: report port fc_security as unknown early during
 remote cable pull
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtqr56bo.fsf@ca-mkp.ca.oracle.com>
References: <20210702160922.2667874-1-maier@linux.ibm.com>
Date:   Mon, 12 Jul 2021 21:52:15 -0400
In-Reply-To: <20210702160922.2667874-1-maier@linux.ibm.com> (Steffen Maier's
        message of "Fri, 2 Jul 2021 18:09:22 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::32) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Tue, 13 Jul 2021 01:52:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8408f01-5ede-4da2-e8a9-08d945a0d927
X-MS-TrafficTypeDiagnostic: MWHPR10MB1616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1616AC94CE6B63F4E350D36C8E149@MWHPR10MB1616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ideVMaK/zrhGEDbpgLg8x6EjuthW63LmC/7+BQwigktU4JvNrEo1nkXMVKLo0xzCLSTtmnXKkDF07zbklE6lOehr8/1NDBuHi826b9HFrW4BmPEvZ91JeT6zaphN8JOw5xrrRzvt58rbgLS6riQ3PGb1FbO3UGpmpKVmPeujNhU01ywKXeVbMYm9MO+RCX/iu+koHOuWvYRBBC7AcRRQU65eDch8LZnCIc5GCZa50dgYi6zNE9bL0SQO6cCk5TEustn30aZ31Vtw+l6XNEHTihgMCYHqRcFXj4+FHdpaWQLGV9HCO3B1WBH+SJv2JPccTxAOYJmM89nxNR3ToZS4g5kH6sIKYtI4ykYEwTQ71yNEAyX8TZWa8PXzLW1EEV3CVQsSFGL4EgWvkMLCeC5Q36WWg14p+6UVyuC4LkIKvOnqGCktDNEhpvHls+S+Hcm8MVeDTJ7ujiJ81l1JkchREP6w8MEgTz/2k4It0kL7ektEqoDZu90PRqlJG8j+p8KRjImrPikxJJsYWcWZaHBNIgbBxdF2pExa0qLjKAkVWEFvyWiXFfOLDV/AHDCNF46YTb+Tkc9htF+i1/rDpesXxDmL2R8I6mPLlFzbOPstKDsr1Y18lHBBdNrY525A51qX84moJ8rCwEkW/iF6vZrqoHyg3jkxLFJxjxi5elK071nby5Bk888UkyZPQe8wiufhex7rJixNVhbl8aOcFKT/Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(186003)(4326008)(83380400001)(4744005)(52116002)(5660300002)(36916002)(6666004)(478600001)(6916009)(86362001)(7696005)(55016002)(316002)(8936002)(54906003)(2906002)(8676002)(66946007)(38100700002)(38350700002)(66476007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fH2/rjoH++m5geqXd53z2nTmMMjQYgw0HNDvCOI2HJ//F312CsAmstTqkhKP?=
 =?us-ascii?Q?1X5Gb0zB1SmV6aqmdIyjYkG/Bn+uC1zv94QLHQOtVGlHmyuTnoMg0mOHV3WM?=
 =?us-ascii?Q?815bhar55fwQaJ71Prcwg5tOWluI3zJwf0zzKZH4HDnpCK8eD54s6Ex5A7gf?=
 =?us-ascii?Q?ljKAccyGhoqBu8TgZ63jOu3Ao1wfJtHsxYdGhBdJ5EaZ046Ocrch8HH1rYfC?=
 =?us-ascii?Q?MAFDERXV8XAQN3qITTtmkIqQt1dqknKZQSUtAo5VrUGzENDevjCMPfQXs5IJ?=
 =?us-ascii?Q?uN/xZvUQHpTlGhqoNzJV2AaX5tAZTAsSQfDpCbCJCYTBM2PwH/1sRJQhXMTw?=
 =?us-ascii?Q?gvzoQkWqG529pdSCkagEtZ5pQJCRcGM7hmGnwpuUaNyFdZXiZrjfl5Md1n54?=
 =?us-ascii?Q?b9fBcCpXouQNWVmfMDi583qQMRWhzwinleldTga5+E3Q2U4cdbD0eQ4axD3b?=
 =?us-ascii?Q?BmfWWQ/HFEcQzIboLkO52K6bTHPGRnCbtJg7RxTR1f5rZIg8eyNEsc3GSdS/?=
 =?us-ascii?Q?ufsDAbtF7WrROJ7qrypDahpLL2P8+5XD0kGNtUERIZEje0hV+UsEMBwzaL/I?=
 =?us-ascii?Q?0xy2xmRD1ERCfc8cSVqLCWa3/KNnTk2GFdegnnqKP7BrO7FKuGVyE8t6ESOe?=
 =?us-ascii?Q?pXCjajfC5E4COa3agAvS/GiQ+B5AFhZj6w36ea2pSUHvarmwtJQKAQFTihsz?=
 =?us-ascii?Q?4u32cZnfAALSyhoJheeB/a+reugnxmw7AlHpi5jN4Fcxb+6bPR/S+b1rSk5t?=
 =?us-ascii?Q?++bQpObNsnE+uhh+s5cfOMAnSUWtsa0TRWqRHSgrscQ2Ue1cIdOUWqqaeCvc?=
 =?us-ascii?Q?C9nuh6Mbeo8b/I6L0q/dfNJjeBZ4GovQ8z7QilZ2E7RkrRrAVCRonWwtrEiV?=
 =?us-ascii?Q?G6PKwS7YiGr1X+c7A8kCWM5j7ymg1/MVLvdu5lc+M4l37cqksyey0+DkauK9?=
 =?us-ascii?Q?3Ofr3DadAGSt5No3N0FNQrQGhknACBv0C9cHVfQHx2/zIBaJWpLf42z4DiJI?=
 =?us-ascii?Q?JCEqeN91bxdFjI9TCNH6YvKUDr/DYrgYILMshiJ9yYzVYzeazOskqaGpWttq?=
 =?us-ascii?Q?dnd8jhysfqajHIaPEe5mzEIW9B5DYkytxLxKM6/CanR+5reKWUqxUGo5wAu+?=
 =?us-ascii?Q?jXwVYwDl9Q4aEGaprnKpxriihUUKeS6ms8ow2WUbh0XdxQZ8nMvOy2E+tN3h?=
 =?us-ascii?Q?RebxvWYR53Qc99mdLdJH7X1Nl+Zom4UE9LYWTrLhdwlP5gcWzwlLL9V1/YM3?=
 =?us-ascii?Q?nhjTliLvq+FjtIa4zyAqP59/pZy/8WfQzb9MxUsilYuPcEoYTGPGx1+w2jby?=
 =?us-ascii?Q?wqJk0HvDHxEYad3PkXaAeL5a?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8408f01-5ede-4da2-e8a9-08d945a0d927
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 01:52:19.1136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LA9G+uxGOjLv1UXzPIP2iD7P/L2fA0qarn6k9GNmD+LNubKxx2FyWficjazLpy3e56knANsTUXoDX2Wz8ycpB7l+CcQpT1BG1ZANbTZ7Iws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107130009
X-Proofpoint-GUID: lspHUcLed7XCloV0HewtVlUOysCSQSQk
X-Proofpoint-ORIG-GUID: lspHUcLed7XCloV0HewtVlUOysCSQSQk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Steffen,

> On remote cable pull, a zfcp_port keeps its status and only gets
> ZFCP_STATUS_PORT_LINK_TEST added. Only after an ADISC timeout, we
> would actually start port recovery and remove
> ZFCP_STATUS_COMMON_UNBLOCKED which zfcp_sysfs_port_fc_security_show()
> detected and reported as "unknown" instead of the old and possibly
> stale zfcp_port->connection_info.
>
> Add check for ZFCP_STATUS_PORT_LINK_TEST for timely "unknown" report.

Applied to 5.14/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
