Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2624EC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B21861380
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 02:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhFWC2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 22:28:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29178 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhFWC2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 22:28:30 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N2GENu019114;
        Wed, 23 Jun 2021 02:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/SDruGAJP946+i/1zjHG0KtHUSucDSztDXpxVhK+XXo=;
 b=YCvMZWHNKpREPZ/5vQvjyrjaJVOk65rryUnAVju+vAzf+bhtyWXQ9xo0KeG8biqH6rBX
 8aifnBvfh0g8YBfiiS6G3PaCJiyGsOk9XL4aNHDeqVZK/URwMc9iV5Ot01Z0VwjPT7na
 O+8fC2hQWYeJ7fO+06cp92LAU4igoGd+aKWFvRFv23erG3nxgCYpTz74euKlqjzKQQP/
 qQYnUED8lp16Wac7b+JSwwbmtu3B/X2NtXdQqj2K8XTRKTWocX6CcCj3RvbzHkSKQuQF
 seKq3za05yHWk7BQB6lG1A1B4AelUqXmndb+1DEh/rnnTTwaUB4yOpO6EKz4yuTVI5LO qA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39b98vajvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:26:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15N2FSkH026952;
        Wed, 23 Jun 2021 02:26:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3998d8e11p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 02:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzOBODLnFZc4+8AHfmXp1Q6JIosZGeCIMQtmJWPPriFt6qpliZe/fI5Zq/dNF8Ni0L7D+FuLEW8C6qyCfuMoXAJZT14qnBilhDFqdh2H3ZnVQmQ6ATaKadkqWqGQ6N0dcUMWolLXclLr7TpksdExQg5eJAB5ZhbCWSfC4r+BDNRcZQFc3A0t4EEP344PmQRHfdoH+Hko/QAlgEaaJsb/ymhpW3FhoE9RqVsW+lVprUbwewqkgScAWaPMER4WRTrT/NCoZ7T8u35lAvdYpO/IGicky4H99/9Vlz9DPu1Tp9XN+7T0CCpZ0/t37rL2De4gznXIhsS/gz/jZmkYshcWzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SDruGAJP946+i/1zjHG0KtHUSucDSztDXpxVhK+XXo=;
 b=Cbmc8yTFQ65KSNnjYKcSzZeB8GSAV2v8Po7wjC22lTbQTPad4jzD52tiJDikV1jDsAiX1+7mHf1ibdQYakLTL1IMN95NEjvSLSt93b7YyRzp4zfCUmz3XRCqMYIM8sSavPHflfycbD4eOEtPkBmQjXt7sbo+KYlRQO4AsqGC0IMqdQHRCytwn9lCQBGZIfpd6gmg5AXEIU9r6/5A8vHKy9/LTx1ciqAx70Q0pufQZssvcjZSeXxrlNsG3d5JBl6P7qMd41OijAfQpLM7T7DCNaRytwPV2cKff2Yl1AT2Ow8Ue06Z2HcsUnAJrkRZ88QVc+m/t8vX5kmcpLTT9hTdKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/SDruGAJP946+i/1zjHG0KtHUSucDSztDXpxVhK+XXo=;
 b=cCZWnm5sTlLq+KR3x0lTLe/wC2gclDwAhyTj27gf+4//Jn8vQ5Z4bXnOtdOjbWjno5Vy2qqYQL8AmIMQJDI5gXfO+CEWXgbPIbIGCTWAIjANBG5H0sFQa8giHN0ZzRKWu/ttLznO+7HucnDtEQdRgOd5uTo+sa1ivKktqGfCObo=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2398.namprd10.prod.outlook.com (2603:10b6:301:2f::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Wed, 23 Jun
 2021 02:26:09 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 02:26:09 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mptfc: switch from 'pci_' to 'dma_' API
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lf71qpvo.fsf@ca-mkp.ca.oracle.com>
References: <95afc589713ade2110e7812159ce3e9ab453ec18.1623568121.git.christophe.jaillet@wanadoo.fr>
Date:   Tue, 22 Jun 2021 22:26:05 -0400
In-Reply-To: <95afc589713ade2110e7812159ce3e9ab453ec18.1623568121.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Sun, 13 Jun 2021 09:10:16 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN7P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::17) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN7P220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 23 Jun 2021 02:26:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d882fc80-c1ad-4091-60bf-08d935ee42fc
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2398496F2DCC0EBD3BD975188E089@MWHPR1001MB2398.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ul5qi1dKX37sBo9EmpKSXtEPnKqJ8M//g3XufyduScQGX7YYzB0mm0e0VwyczUxEqbOH/BPTXX/SRQodBoF+amiTfjY/HcAA6KfvMFmC34cPVBbDRoqeCTWyVWZQB9URh0J8osIi4Ca9J0T/WrBBsnhwMIW+s6iBroS11hPmIe/ASqtQm4/Nclwg8gsjxClTDdbFXQC6L6nGPDMWmnvbaMEGcDTNYGRmT8RqhUS066G53IBa29QL5fTX1OVWUj5on3oXuA9Vl7pmr8oJPPZDxkEPaUK9LOHhxU2LaZZAk3cjNVhJIykMkTyyc+pghr3ORr+JYE/jQ1Uk8B/oIP1wlU8MsCaR1vAEzSW+VFZh8uYR/r1ZaddO8xyaoCwly85MNs3yo1nWQ00gVPjfdAN5epa4SJJTBtNrKlQhNEN4bPcsrniyRRijYDNSObyeiHZg+aEh97x6A3pPka5Xgbe0sUkbEBl6x0LR8/iCAUKbWiiIzICtocqd09VPYUqo9LJQWUCfDIZGRkiCODCjabnNRaf898r3fkxK8qINLagrNTwbbHL2aagj3NKUmjF7k/R0bcmYevr9KliYFBpCZuh0sW3yvM398zQ3eiUsGkY8ftUU4RCCAWM3vdWjz57a3O1gJjctWAMuTIcq/cigGxfVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8936002)(5660300002)(186003)(55016002)(6916009)(478600001)(16526019)(26005)(8676002)(4744005)(86362001)(38350700002)(38100700002)(316002)(6666004)(52116002)(66476007)(66946007)(956004)(66556008)(7696005)(2906002)(4326008)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vz78dgi73HrF7636Bic7XbXQpABEctpGfIbjYWCI/CiMToUcIl/h3VhP7wmA?=
 =?us-ascii?Q?nJugy0RNtfjgQd4G+MAhtESrBKOviDZMP8ivj+93wHfOaycHUEJQHW/Bknam?=
 =?us-ascii?Q?31G/4XrRHRBUOAICzUdxwXbHRWVqStTjMfUnqSUvxrLqJ/Zx3NSg5sBzZYOp?=
 =?us-ascii?Q?IGWuk8Ee7BIxTcNV8kOr7oluMNeGhSrHYu34sWfo6VFLXsF5ERSvB3UQzugt?=
 =?us-ascii?Q?NCjqJEIYcFG5nRFkkQei0F6EN28j3cQMtOxxl8jZIOlG5a6c2SXWOIPL13Kc?=
 =?us-ascii?Q?/XSjO5pAn8EePlLYGtwSnxC8liDwl9VgQCfEeRcoEG2MSNofYtRo4WRplTMX?=
 =?us-ascii?Q?SeuIoE1g1kukL+mhBwqQ5T6lgmXWOLKPcr2d6GVzRQuuzweHcS6ruYZfwvvA?=
 =?us-ascii?Q?ZMvk66nYcR9UH4dQw36+cTVLSro+0PYOZ1nZF3q7at0GRwYzCzGAB5DZcKwx?=
 =?us-ascii?Q?zYQ8V29l3BDPfNrjvjTSTv6S54idkXAaTCDPBMxACQmOHWv/MoIBJ2FdD/Xi?=
 =?us-ascii?Q?ebPmzZaCSTpPaHhdXU58d0zQakco0OzSeU+rFYPX31sQ31JCSjqJQubHjapk?=
 =?us-ascii?Q?Z2bUtuUkDvAfFtz5FGj8IiiyJjisHoUxSx5QB+Z+XjVSVN5pNWMkDNWnpmv9?=
 =?us-ascii?Q?kOl6sL7mC46Cf8n8Ab+FmLzyN4FDIF/XsmcaPglcC8JmvNyzZCsaMy8jhTTf?=
 =?us-ascii?Q?R8vVJ+myGynQFnPkFdLcdHY1CKJQ9Sejq6LuWF6layySvb0NjwJU82Jj62Og?=
 =?us-ascii?Q?gPKNo389fFhFwCijgHIwYkQtj7BzkMXzOxyVfKuG6qqN7CVluwYhQnsfdHgc?=
 =?us-ascii?Q?OHHauqhfRD/s+ElBR/yV2EzAghJmfOQsy9GetxUDIhrK52Ws6Lc+uLw5n4Q0?=
 =?us-ascii?Q?DZkR6owjIS0cOBue4Y9/oonJcM/dGqBkONKV+QsJdUv7tXr7GJ/fwF5+mPtW?=
 =?us-ascii?Q?5o4eByhJI1/gZjQhjxYNQO/n+r0/TqHu21wNURaXDCKeoz2mfoJCSlWsb96O?=
 =?us-ascii?Q?VZjjuAA9n/KH/BtcyPDCHGo8i+GricekmW9vl8gWY6L8gRt9s8yUKXCWnpOs?=
 =?us-ascii?Q?aqnHwoCr+CM1wmFPdMX97m+a+/+HSta/Q9GDZZYqbeH/eVC0ouNGAd22p1/S?=
 =?us-ascii?Q?gKwU/KmdrTp/TXfFzR0LTA3v4WUtJQos1DA44HubzKBN61CNfeUoBFvw2aBD?=
 =?us-ascii?Q?idPu9rSPaiyd7MMeDHqxeKoWY5gWe8MFiP4uDFO3NYzsbJozTvKo2gPKnF/Z?=
 =?us-ascii?Q?KDG5wUQNZZ31AD6XPYb0EQ23pvtViMYostNyNYnW+QYvDWOxAVQA58LS15aH?=
 =?us-ascii?Q?PUlerkwHZXqtcBHUYS7NAZIx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d882fc80-c1ad-4091-60bf-08d935ee42fc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 02:26:09.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i0boul7bi0+YnFrP8IsQ+zGeDVjTQ2sf4hnNOTWb41cW0Oo5rx/crleGCLVRcU7F+eCJySS3XyGkcqwqa67/0tTDLpHdXQ3vEsUnqJUygrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2398
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 mlxlogscore=995 phishscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230010
X-Proofpoint-ORIG-GUID: qKpbN2dcb7459TXtHBqMXNok8VdZNNhs
X-Proofpoint-GUID: qKpbN2dcb7459TXtHBqMXNok8VdZNNhs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> The wrappers in include/linux/pci-dma-compat.h should go away.
>
> The patch has been generated with the coccinelle script below and has
> been hand modified to replace GFP_ with a correct flag.  It has been
> compile tested.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
