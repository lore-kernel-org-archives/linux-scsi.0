Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA54DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 02:59:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC5E6115B
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 02:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhIODBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:01:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:45758 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235103AbhIODBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:01:05 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2bR6R032050;
        Wed, 15 Sep 2021 02:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=O2aeL7R+QR/YgCaK/nGkSNkSuu/ywZ4xlXi18e3M+tA=;
 b=EUtlkXJApUCMgucCogEV0bsVuyCN+KQDXyNJ1CnYzHVHR7ag1EJ9sjAwqQXc7huw02tF
 vzjSlVZ0p8shfPuirg+JD2GemXN+4vvj+BJoZhrlkyuKnWKpTXoRwmx94BWPz0UHMCZX
 oF4wRplq5XE/lYwGwgLOot1UHAD+rcDKegOEeMP5GKzK2Pad3b/jJ5Mhq5D/hP4gEkNv
 Bn/TDrOpmLfG+XERCb5rgH5anBR76uAz487Cz2fTpQ4xBCrhGFxpLeaRoLfWRy0rLE6o
 AX9vID2E8Nq9q7e8Rf9bK+bQPeUoA33dMTg2+n/GgiWq7Ob1+T3YLUmGCItHj7BBaqkb 7g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=O2aeL7R+QR/YgCaK/nGkSNkSuu/ywZ4xlXi18e3M+tA=;
 b=QfJS9aO/pTN23oTYVD0nejaFARmpWlLPVFic4P2QaHJjIU6awwKwMbf0jzR0uDzaMkpo
 TkejaJPHm0p3wjLQikbA6tJGFMUMFp19JB/yxeAa0qr89KIswoQM/sfSH4zdiNRq8/Jj
 3vlMQf6FWTRLZGGR4n4V2N5c+1W1R2FWRHMoqok4q2nB+KAMEW5WjWk0AL//ZBnaDDxi
 ihTXN9D0QzU6OUIZuqaWUwIH0NoBP7Q3cDQpJ7ciJ33g6dcAngxMRXAgfzMLEiTSb0W7
 nD/CKZuJi7NR9j9E2G51s6jwf19vVsvZ8dgYlAGERXjIlEf9Mwh8wdvB2htzLFgopo6O Ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mkggw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 02:59:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F2oPRE157196;
        Wed, 15 Sep 2021 02:59:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3b0m975te6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 02:59:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbqXrK3k+NrAook9hc+UJzf/0nmqm19t6BANQQKtgVoT5ROXjc9QmiGWBkXvBPA8vlNBkDzchnXU4gpieddnBahiEB4KnKsd8UkI4rmBZoCZu6+Uu3exguPI/T96RpWVslRvNEnlUOjnJ86agX5gZkGcBlXYDv4b4xs3XedHvF1R4mB9GsYDdL+VnXEGcP1d/uKpqSfzYWrhJUCnLTiIkTRnlZ2hgLTtzsoQK9wTgOlRxvhcBdGEkJ/H9+92UzkmZ48PUKaJudC/nRm1v1Gh+sgraM+C/iUrSvJgYNyyUTnm7B0H490qVMMRdGMq7TFSe9A9LU5yMv/rULvH5g7itg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=O2aeL7R+QR/YgCaK/nGkSNkSuu/ywZ4xlXi18e3M+tA=;
 b=XB8wjQ2LNUlk1X5Xc7xKFxfTTspncVY1zpiab+UybT+4xciXSCkfuKXkvsPq14d78H4szcafp/2w6gNRJoe/2ZIkZ8dFXqPT9eViHNudB2/+fT0ftIhCZXyw4+VIxd5XsnZgZd3H9Tjs6zmPCmY2U/fMbsZ+shBKkIyv70it9sARi3S98py5F1hEBxHtVYuzhpohiSC3j9tMK8oSLr6crWsW8yFo9qlPap23hN6HxokTF8qC9+CyWHiZQPuswbN187ffnB3IeS2we7NiiFydz7Lqgd5b1eHiv9CDHzEHmiI5cGLaHkrCwfO5PS3Gt+a5/PAetaD2xgJ8t3a7CPGI0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2aeL7R+QR/YgCaK/nGkSNkSuu/ywZ4xlXi18e3M+tA=;
 b=lxnV/NVFXnKi67HqNrMlE1n/71PbhyjtmMh6aaWpxbURZqRyiOfacuLveA0GMbyPA/3aGuomghoE+8BneOZUGo8MYwI5gOC7WpP3b3kS6/xOh7qWpXo9DkvqSBZDv4eVCcnxPus23qBFlpfFJVjQJoVt8NumVXAXwKbpDsXKx7k=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5657.namprd10.prod.outlook.com (2603:10b6:510:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Wed, 15 Sep
 2021 02:59:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 02:59:40 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: Re: [PATCH v2 00/10] qla2xxx driver bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o88uwnnf.fsf@ca-mkp.ca.oracle.com>
References: <20210908164622.19240-1-njavali@marvell.com>
Date:   Tue, 14 Sep 2021 22:59:38 -0400
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com> (Nilesh Javali's
        message of "Wed, 8 Sep 2021 09:46:12 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0131.namprd05.prod.outlook.com
 (2603:10b6:803:42::48) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SN4PR0501CA0131.namprd05.prod.outlook.com (2603:10b6:803:42::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Wed, 15 Sep 2021 02:59:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 473d8749-7db1-4fec-a03c-08d977f4dc4d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB56579C608FFE621207C7548D8EDB9@PH0PR10MB5657.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gA1ym6QaLKDhSAcxG92F4X5Yguoa+FUwf2UhxUuaqZ4E3w6It50LMT664KYssDKaVJWtlxvCyOd3dFckeOoqTEAURls4Ury4J3rsBlj5f5LGgnunYzV41hahv9fDfq62UCQ/+f1o13E1nGjKqeMEz46gVSBrn3S1PoWk2zrlhl9UsqTIyqYgOX50XFxSkko5WJkfdviyix/ZpRox922nmj9w6cuaNnt7bmUPcZNICid0UtvgsIAEYnHSPLvxKFNxA4s7b1DHeoFlC9RydHh2ms1HkJtIbKC0hxFvGL8cFCqEDbJOAYF2GgtgXkIpbfGFFddEgSHTVCrayO0cMAYvjB8VUQMo1lHgwFavMh0tJ5TyU7XV+NXGoXdr+Rthpg0+Je7fcv8RDb7+e4edUghyopRXp2FlvjB1/wJNmNe8BaPtzdI3SK1W/Zz7QGBtp1s2YdYtavLmfFl5hGBagtHvuRoqBggyXE6zoo1uCG/PvlXVvvH3N856HPntsAJ1A5VUkoFV+es91N6VsRbDHdqljqs3bPi4azyDNEycclAILw1003LV2h3FV6El9QiblKsh9mQ7Nwoc3zwLd/60Ub9DmNOZQHV0uqL9nOItfVgk6bb+fSxIYORaNf2cVMuRPAsySRHeiowW2F5fHsTh4hR7NzsDitW6DQB6YK6fLiiu5NnOTboWOpS4r/sBlJmwqUsCfu9KmvCt7yr0t/Ww1QnHgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(376002)(396003)(36916002)(558084003)(86362001)(54906003)(52116002)(8936002)(66946007)(4326008)(66556008)(66476007)(5660300002)(316002)(55016002)(2906002)(8676002)(478600001)(6916009)(26005)(38350700002)(186003)(956004)(38100700002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b75dGgeN1iHUhMCxyJ9nBJzhouQuBIk4Y8uuDZWA7UTSQ9u2pHtOOybU+wF7?=
 =?us-ascii?Q?Y/VHdXqd9lQDbv2IS9hIyNL2UpDFXPkO7fd/jbugsCx6YIIMbg6bJ6VaoVrs?=
 =?us-ascii?Q?gXimAdM4bpQ0iLMwwmGj4YjXCSwLdPoHqd8yS466Lc1/wO3H0n8XKEvfJOLt?=
 =?us-ascii?Q?C5T1amhc3g8Ic9TNgZHp9BGFmGKjeL3pibwt1PW0IGDuJW8h3cotR7inrSBt?=
 =?us-ascii?Q?lqr+nSkNwzFmaH4G4mmHk/eEtnII2TWwQUFaaMxz9yoGM7TSPAhZtFTyksg1?=
 =?us-ascii?Q?+SwyhzBbvPeIMuIns7EA0yxYByZ4LCLAQ/Bqr1z6cPgnmmhyBJTBTtNkZaIr?=
 =?us-ascii?Q?Zun/2rSmKJOn74ale1YVBLmzjWo332JXAyXvERfxkpTueuHfkNBmU9RY33oE?=
 =?us-ascii?Q?ZFjENpGya9KQbopME96EFiOKm1vbULmHVZq7sFUxGtyACcDucvidN4sae8aZ?=
 =?us-ascii?Q?RJecTtCw2uki1jt9VEkdBpe4XltvZ1FbFaxsbH5XLqZHuj/eLuKNFMuwl2jc?=
 =?us-ascii?Q?JrGhu+CI2NFVYoUqRV/UtcKZqd19ZojnODIXBsaGdcXqzBnyVNTczAiljO44?=
 =?us-ascii?Q?g04AlQAwvPot7HOkW0AZdIMpGeuwkb90uhl29CtSWu7glCwiH61j44YPCAoH?=
 =?us-ascii?Q?HOQNKMtM+a8vlmTk7PE4L9OQfqQJFYHd99znWpJFugLKcbD7vjXtzUmr/WOu?=
 =?us-ascii?Q?pZ/3Rtg2SfcDWflbVVMM7khY1eVS3lS4PccUj4FWV9RXDvDzhU6Iv8eeZoUR?=
 =?us-ascii?Q?phWJwT2ErsRT5m36xaJpOT3ZdnTsaZj1aBnnUNbdUPTpq2r5LD4ET6pEldn0?=
 =?us-ascii?Q?q7dyUBot1Xq1s7vWohlQIt2a4FTVS+rKVqmLBOrs4GbwG4P3OdSYMx8Q6fkv?=
 =?us-ascii?Q?lMw3iWrGl9m9FD0J/4Gie+J3QTi79GXtHZo/Uk2vk/tiTCoyjLWhQbprRpxU?=
 =?us-ascii?Q?vP4cIqW5L+iVfdkSVJ8oavFlvHTwaJubjLgXPxGCwxeZXViP/fUWpelP6CJJ?=
 =?us-ascii?Q?/KtwzznUZhElLAD1tvtxZMtrtaKFqopgKJvr2vMB60P0j+BzZQVqLXXR6vdn?=
 =?us-ascii?Q?zkTE/R1EZG9mNOQuXxj4CyRVOqNAhD9v0xjDtG+rVi+6y+mbheL1paB+Btc6?=
 =?us-ascii?Q?hihZE/NPowlcr2JHqK6i6A9u9bDuIzosQ3biD0wT0DxxGFiPpWN/yf5X90fS?=
 =?us-ascii?Q?3UfnACKHAiA7QSOjzsdKmxPY3QOMXMvHnZgWvkhNBSO4DL6xniInhuiZ3V67?=
 =?us-ascii?Q?BB6dGp2uQUC4B7WG6IsdxU1Mqy38TssKjMnXG2RyMYGP4qgh9Q/IrCtCdY9N?=
 =?us-ascii?Q?XsGDS84Jh1IZxXCEniEOkbD0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 473d8749-7db1-4fec-a03c-08d977f4dc4d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 02:59:40.2820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2lk354LkVZ3w1QEFYUyWLUYbDnPbRs1AkV6sqgc2hdWN4HHn4WoUWJ0eiyvtrwzAQWAI9lflU33Yxl0/QiLCaOB67rWzz0EEU1EvZoLA4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5657
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=878 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150016
X-Proofpoint-GUID: 6rfC78YucGuL3YJqjfy9RhKw-9_1cw5H
X-Proofpoint-ORIG-GUID: 6rfC78YucGuL3YJqjfy9RhKw-9_1cw5H
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
