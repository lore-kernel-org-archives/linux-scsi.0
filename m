Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B741C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E6E764FAC
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 01:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhCQBlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 21:41:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhCQBle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 21:41:34 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H1YwP6051255;
        Wed, 17 Mar 2021 01:38:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BJTGyg3lNgEx2nPl7SfEgFNlN4SYGkom2//fcm8aJ74=;
 b=Z1SsR8Fsl8unl5TXr5pNt38dODg34S8hOkrjgrybO231aLVSkOr4U6b/OaCQqTpN/CFQ
 NNUL2rujJkyns+urol3bVO7Ndxcm7V1EVUesqfcd5SGlHS6teLb1S/xrbFTCNQf3RXzl
 AjCaBT6H5mO6Q7a2AlzaoUAv3hdn4605PewTil3Ag/rAQL3dw7toAhschdD/O5o7Vth5
 zpnYXKjx1FECUNcRMemto8DHdDQnlJGnHzoswA90H6iZhChfnnYveAG9MaX8yrn5QWVi
 +63KHHp3+OEI2A4lFeQme2oDQafXbbyslDjIMdXuLhnl6lWBqPKd+RbtM56BlUk9Iso/ OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 378p1ntf1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 01:38:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H1ZtZw074770;
        Wed, 17 Mar 2021 01:38:21 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by userp3030.oracle.com with ESMTP id 3797b0uy0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 01:38:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtCucoSjWmSsZ5N9JHfPJ8t27NG2XwHsot4MCTDRLhGe9oIIE/AD5bdbzeYFN9JtPJSutEKTAnKnpVYxaGILLXtQRw/BtqI1uS/OSiXHMYol486rjgYXscMIt+u3M7CzVJ8bI1CfDYwwUFx9tgzBbJC0Sqz7J178JY946uz5PQnRuieSyoB9bfnWo/DMo6e4lJvieaIbacKGU2wGBwml8fw8zv92re4Nrv49AX3iANSK4qL5aA/bzW1fgCUuMyiKxLsTEzmGCRLsGs63Le64Uc/89o/bzWzBk6os78frtgpqYpgpxg5bYGvxU+S4tFcEji459jSd6YQE/O3wOcjPlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJTGyg3lNgEx2nPl7SfEgFNlN4SYGkom2//fcm8aJ74=;
 b=nAF0m7GC6AXmxvXxFJdqLl2sxXS9My2hQLDwI6NoridUxxCyd8UURCXdP0TCLBWxcet8knfpwoclB++/qHSJ8Tp8cjx3R2CdWwO5R033zmodibqVq4HI0r4IQaTWIGW9RsQDVpnxpbrqB/n4H+P1wc1dglSkKO1keTuh+x6EzmTzbUN945bnsgkYYwJ37a3u6IlzBYyJRDaSrUVx4AdjjOfOu4E0i0+TKpgNyejNEaDOy1AryrRkiahHqDRcRZMEFE1jybp1XF5PerwvO06YJ5xyOmqf1sCTCNFKIPd+VLqKplNdFCBmywJqMzME7Ua2CKHKuQRstddDDMxdbBQHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJTGyg3lNgEx2nPl7SfEgFNlN4SYGkom2//fcm8aJ74=;
 b=b3pU5+p9uziNfHpqDTGl97moha9azjCsHdERAE96FDEf4QpcYcYLuB55YtTdPXABsgxz0MhhIWFIIWl4RzEacLTTD3NxAqFJ3WNY6KkjoNg1c6OtJNvmgjPlkkWbTzZyRhoMfLrpOyv7GVA2T4YVLji+x8WzuJXQtwpGSO0bHe4=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Wed, 17 Mar
 2021 01:38:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 01:38:17 +0000
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ali Akcaagac <aliakc@web.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        "C.L. Huang" <ching@tekram.com.tw>, dc395x@twibble.org,
        de Melo <acme@conectiva.com.br>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Erich Chen <erich@tekram.com.tw>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Jan Kotas <jank@cadence.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Joel Jacobson <linux@3ware.com>, Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-drivers@broadcom.com, Linux GmbH <hare@suse.com>,
        linux-scsi@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Marcelo Tosatti <marcelo@conectiva.com.br>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Nathaniel Clark <nate@misrule.us>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Oliver Neukum <oliver@neukum.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vinayak Holikatti <h.vinayak@samsung.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH 00/30] [Set 2] Rid W=1 warnings in SCSI
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blbi36zm.fsf@ca-mkp.ca.oracle.com>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
        <yq15z1r6db8.fsf@ca-mkp.ca.oracle.com> <20210316071725.GZ701493@dell>
Date:   Tue, 16 Mar 2021 21:38:14 -0400
In-Reply-To: <20210316071725.GZ701493@dell> (Lee Jones's message of "Tue, 16
        Mar 2021 07:17:25 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR08CA0060.namprd08.prod.outlook.com (2603:10b6:a03:117::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 01:38:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87541f53-dcce-4a7a-926b-08d8e8e556a7
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4407823F7FA301B4EA39D31A8E6A9@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8xkkwSJtaoGPW+RDZCPba8+Vj5u/XGmE/patgAPORNOa5RH4dAexVKQ8vzcpUmnnYFffIHDOFCvMq7DqY2Ani4CaR3O5ApKFBATvpRpzUqP69SQHQHlJJbhGLUSDTdOgtURrNGBSRbpaLPaMJLCZEcQHC1cN6pNLTxUPINA1qiaKsQr1eJrA3rVWibrJXDSNeR61ZpblIKt9B6arbjp2CCoGnoT0jLGRxeSXqIiwyfXHYwzZrTR18xSBARqfbCnC7ZINP7NTS4A/z5ZX8YuGeawTCsWAD7wT+MmHGzRcQiYygyCvuyqNhdoxFHiEkIwSJwr4Vfp4d7gO8P/9+r7uzUDo2izCKVD7MStnKdi5z3nbcjj8zRd0d5yOSH3kIajuP3mOjcWjIpkgt7R4Az4WndZptQnCzRyIJ67n9d/qY4+BpTuL0ELODmw7X3Gwe2xEf/lgGKteKidy9f8pI1P4pOunxfYm8wz3cQMR0Sv8n+/PVQgGchejDSYXa1cR5PcxDe/SF2CjLg/9vJDalqDywg7kHrto3K/SWAltX2s0FAliU3X8UNmVzWzYTlzaNTCy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39860400002)(136003)(4326008)(4744005)(956004)(316002)(55016002)(8936002)(86362001)(54906003)(7416002)(36916002)(16526019)(478600001)(7406005)(7366002)(186003)(66946007)(7696005)(5660300002)(8676002)(66556008)(52116002)(66476007)(6916009)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+kmLkZg2Xg+GjEGnQMLnyBSXpTjAYi+9YyrYXISnv5KbX+Ugua52x40pPwpa?=
 =?us-ascii?Q?Fs6qcgB8wV1ct6vcVr50g3Ns+d+bNme2YFqSS57g7u17X9hJUN7LatQaEO1C?=
 =?us-ascii?Q?7HMUB1xIstkQwyGbA+U+OHc6UVXJcFlhPQsHoVs/P75NclUL4OZbVoDlBldW?=
 =?us-ascii?Q?qckwmw0s3cRSbASpt9uihVPXA+6DfQ1b4W0trzc3N+bEcTPBYRGsYjUymodL?=
 =?us-ascii?Q?kMgvVDDFlEmZy5GJWg5zkAJLh85HuNkk7dyJy9b6zA/TOvIT5Y0VGBQxGlDL?=
 =?us-ascii?Q?w3Eg7jcv3mAa/9LieyNqTZf6g+iRw+2JPReoevpXx8UIchdDQ657J7OaWs70?=
 =?us-ascii?Q?y+y8RzRB/Xxk/eym4u4CvOlFtAgQ6q456C75+fhj1t4batv9ZP+Ww3nqDauA?=
 =?us-ascii?Q?kHBW9MH+/DNWLycluAid9XgPElH90PpRw7zSAjRaN6UflQBxUCfajLGxJp7x?=
 =?us-ascii?Q?8hm4WxM0drzFCu89nPu171pM0UHbRsd0TQlTWIbltKDQ0483iKd4Rbgcu6Df?=
 =?us-ascii?Q?FFleFVtlStd1+Jlw5U2AigoFxCbjAczcTz+9VRO1glRggUVfUW/4+Nw31Elz?=
 =?us-ascii?Q?n9Z8I9nx6k3odp9ytN5rIF/JtP9BbOlsGZ5ag2nbEYuvLtpb2VfCZjkVcImV?=
 =?us-ascii?Q?xR/7BRalzkqPpZYOFJuAhYMMeVSUQPl/K5hAtKPjD+fxNXABtGv5+GNKiWUx?=
 =?us-ascii?Q?v00PXroRNbufDYHyX7orx4GusHm4ZNt9pkjz1i2qk9l9XwhYEZrVSI4NvY0G?=
 =?us-ascii?Q?mNaYQ464YHpESguUAdQ0iYViYq0zMucdMIXVzX8qnOBaZaIKhB32Tkn56UHj?=
 =?us-ascii?Q?rujNHuykVveQISykngQT2Ne7c6haccUcY+dfuhyoquPFUt+ldc9jQJatu1Qj?=
 =?us-ascii?Q?GD4ORhKu8KiOsAUqClfEeDMjFe6KUBDNmwspzU4NdEhYRBg3AmqLN0Y3Seji?=
 =?us-ascii?Q?ecElpij6kjrDro3WUVLB7cS9nKONi+M37J9k6vBRELGPKPz404Cg+N3LzeTM?=
 =?us-ascii?Q?YOdIIvb1pNw/HG00pGrImcuWK2LctbePFLTM1RAAngHG7eEwbsnYRQc39vE3?=
 =?us-ascii?Q?P43GUv+r1S9H1RLHushrbFE1MQ2rvcnN3yUaCNuAbWMo5k+zAMXjCGMlYsUI?=
 =?us-ascii?Q?csW41rzKfX+45ShZYkNLiKNdS24j/bwD4fM8/PUFk4zMwWjuPCKZYMsXLgGy?=
 =?us-ascii?Q?kbZpgm/U668lbKSj/S3qdfpA3Bbzgu4g5E9GuVFhuApFZIqmIsnbjCUAWd/i?=
 =?us-ascii?Q?YmuyXc7zeLXa3+mWB64ki8EzGrZda15OkcHsoHKQ3kgJoS/kOpNyxAlBNA1m?=
 =?us-ascii?Q?8ulNsDb3T+A5GvZ0xmhgRwXc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87541f53-dcce-4a7a-926b-08d8e8e556a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 01:38:17.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EHhLjt4Khpka8cfac4bdoARhQziBmZrDoK6l/ANiRbYFP6EfMUt9PMAnZJnZiprGoGmRe8p221Hv/J5DvggHDJyN/N3SUkssjp3sTQ38znE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170009
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170009
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Lee,

> Would you like them in 1 or 2 sets?

As long as they are trivial, one set is fine.

What does help is to split by complexity. In your two previous series I
would have preferred the mpt3sas and bfa patches that actually change
code to be posted separately. Just to make sure they don't get lost in a
sea of trivial changes.

IOW, if the patches contain substantial functional changes I'd prefer
them to be separate from all the kernel-doc, function prototype,
etc. fixes.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
