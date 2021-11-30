Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01992C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 04:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238076AbhK3EGO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 23:06:14 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:46314 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230427AbhK3EGO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Nov 2021 23:06:14 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU1qD4S028124;
        Tue, 30 Nov 2021 04:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ckVyVSysDst7XyZl4tt9KjCOABCH5qL+9X5wtBFem8M=;
 b=LrnVjQylslxWtgMJ6yFKQuMrtEfH3GlFlSA3doy0niCQP3Gz3I6Z+DN1VmY9hW3APkmE
 nqQexwUszVQbHk1Kt/Eg18VV9iZmfdfv21Pzazvd88hKcWGJCyu97LH4bJ0S3A8WwGJT
 o634skLSuL+FSsjv1G3SPgyf3CPWSX2U8hmih/J5aKrhmuVlCHq68GjtWHcf5zUheiPb
 W4QwUlNk4wwQ99awV4zIRCCieqwl42qcLJkxBQ+ldm1MGB5x44e4RdcXCSS8zS29Cxai
 mCGE1aAMWLNSpkaaiYy6EbZm7viApZ1WY6sXHXGFpfBUgyOCMgQw1tXuISzgR/Fy0b4j lQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmu1we162-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:02:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU41gGx126611;
        Tue, 30 Nov 2021 04:02:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3020.oracle.com with ESMTP id 3cmmup8xdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 04:02:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2ZSNFgvMm8RNZUu5nuqX63Kd1tOGmeIco2xJ0oMMo4fvOSDUu6Gc+qlaMwzMQte2O6juy0MfdwY9+CvXRXAIgeexosTsaNv3B+VX5E7xJ52g52IoU6x0/9ML6onZbOdHmT7v4RZ42Mazbr8Bt32Etphi6ygUCXPOz6Plz20PbhUlxJsuo6D5qHKEv2GgcWTUXRU3sjoXxILvQM/R/yqrMUaEjL4WB3UfTY2oBrlKrzmpcKrhQFc3zV3OiDvTQn66BDBNx1GVUN1T8saFQdNgQlRAGxp51Wsn0KimLAKgmTRuEFHgpvATVCR8dfmNtWbbHeh1Ye/YKs1+H/hMODf3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ckVyVSysDst7XyZl4tt9KjCOABCH5qL+9X5wtBFem8M=;
 b=YTN9uDybXCtDIdKDmklecQ0Ql1rfDkrOzDmbM/bDsKqssntNe3sn/WP2fH8BvIaOkRnVvg8Sl7nvMrocWZbcdzs1KRTChBx8nQAutF/kv4l0d1RwixEv4tmCii30vsN20t688nu1F02WO8tWWtqYfyUAvrWEvUerHQcDlrSLhqnuuM73HEUXrko80fd5p4jaK1MXLujrFmZ80u0JJ+FcK4mQ68DtI13An9vMMQ6J+DJX4wHMSufcQnKFWTeStJOhuNXAXv5pp0/FmoSVCBDQdK/RUnlfbL2oHP3P1xxY7XtwyVBP+9QYvwUy1vkWcDoddEK2PCy6A1ErWwK5vFCWGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckVyVSysDst7XyZl4tt9KjCOABCH5qL+9X5wtBFem8M=;
 b=BtnpnCj/bj5SYanHU4hFitxavHdJq8VUMCjBESM6bfg5L3Bn4ynVn1FIppIXUvLE1iKJx+HrnwiOWakc0zvYPzEQsWHc/L34/Oehj2saLQQh0PZKCcVIL9c2gl+FmNNnhw0uj4e+KhwXkUi3ra37CbWOSwTq3Ia5UbhSsikmkmM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Tue, 30 Nov
 2021 04:02:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 04:02:46 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/12] A series of small SCSI patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k7uz3xk.fsf@ca-mkp.ca.oracle.com>
References: <20211129194609.3466071-1-bvanassche@acm.org>
Date:   Mon, 29 Nov 2021 23:02:44 -0500
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Mon, 29 Nov 2021 11:45:57 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0134.namprd05.prod.outlook.com
 (2603:10b6:803:2c::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.10) by SN4PR0501CA0134.namprd05.prod.outlook.com (2603:10b6:803:2c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9 via Frontend Transport; Tue, 30 Nov 2021 04:02:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cf3279f-ec12-4417-da7c-08d9b3b64450
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662BE334764F310CD5B9A068E679@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNY8pvyPbSfQ8fKknr7T2KOC4byH3Ndfv6BTdwb511qD7FfACOHkWXCh7nQ/S3L6FE7HZRtD389ob11nfoYyKmIyfCbnssq6N1YjKLr/6ZFcaNmNzYfYPIf8vegQpP6EIuKEuk7WDR6B85dr3HHn/YnkvljTkVYVtgmVLv/e8EHKHycBfNRT6xfMAN5ios4HcQnG2ZzB4fNZzv7yMdyRLid8/YGd2+DDSfF60sJtNWHJlcRgH9gkGT+kxy82eWh1g9D4hLVC/uivyomavBQK4VeUba4G2oXPIRZJH5ITjzF43UBfzBnmyHXEVE+Z7ANbMzv5nKToeMUjpEHUzqVVJS4Ew7dKpDWnnGp0xWsBer2i/wGrnyaQUmhgL0XMWBuv6tvtQdJW2KBdpc9MMybUfO8bdqvKlBlYhIzh7LvChPzPZr8pVClOul5OwNYOu5g96UfT9PmhU9ctu3PnSmOAF7nnjOzbGGS2bjqkcT1KciSHR7dLkxJFjl+CGsNoeITd4hDAEjrg43oB9Y8cQAxkdE00CQz1TFat/wRZp027zHPKsRPldbetHMkj6v8Z7BDb0AODxdGroaK5tuTxezZdLWI0PvAhsx48EVCg70zB0Q/JvKYlf+0VJplaNJk1wIlZgwWudpVFrnEYCgRCDmMvGB+atSoEoYC4JIEnodyAfJeNB6wf+hvl1SMtyRwtE5snWro4QsoGLB9MP5pCx53HMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(52116002)(38100700002)(186003)(36916002)(2906002)(55016003)(38350700002)(316002)(5660300002)(83380400001)(86362001)(508600001)(956004)(558084003)(54906003)(4326008)(66946007)(66476007)(66556008)(8936002)(8676002)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j6M5RXubr++cYwSayvgv7ghUxVtIjSRbOJ65Ceocu/tv5cZfBHmN6j+yTiBY?=
 =?us-ascii?Q?XuTg6KVccWREVlacTzqMwYGWjC1R1/a0H/aA7M1ltBe9H9/9HGTBYPuA4LD3?=
 =?us-ascii?Q?WNyg6uvnrIMcD5LEr8VCDDOP81fgpLoolWDEGj9Kc6HpUl7fq/6abfXWopzb?=
 =?us-ascii?Q?ORitJOKEOsdiPK/Q94BBsNzPZ8n6zVOxRF+J24T4SKekrVhE9e6BPLSSHBFg?=
 =?us-ascii?Q?kPN7204+WoDjlmAvlPsGH6MBR5mKggQ3Ekfz31goi9BnTykTTFXQKtoV8eq2?=
 =?us-ascii?Q?5aIN1JmAVngaxR/aL5h3zzeiAP0uLDiFozNW4lG597MkLURuLcMFmMXCZeFN?=
 =?us-ascii?Q?jDww7mMDY8+XfmZky2thpJOB4AZvOWDVEynGczW54JADWpPW3dMH59kgdqX6?=
 =?us-ascii?Q?vONY0AtRsyk89DIclVIsg+b7zqrSmd7ymdUGtHChwVcHsz8BpkEC52e7zBOb?=
 =?us-ascii?Q?xuI8CLadk2gpMQYxf3797VmE0/U9ckXAuBSVZSk13DbkWtLjKyAUseT9vWuz?=
 =?us-ascii?Q?qf5YgcsMkIR8Lvndm55t4X7CjT4s36uzpIBCWXLuFCPJum6LUx/oMSHfOTx7?=
 =?us-ascii?Q?cYt+w51uE9Klqg2hDgAsZS3o8YrgdBhneDigs1g8uXp/frpG+dbr4LycqVl3?=
 =?us-ascii?Q?2xPl1je/gNsSN0LZZyuq1y+hAPqTuRRxd9XwMX1Imc6uQH+nMPbUNfj7Vxhw?=
 =?us-ascii?Q?dhUW3fuEol9KmChMtKpptNtu2xmoSj2Wyr7Wfk4hd8AXYSDC1AcC8meDx3ur?=
 =?us-ascii?Q?v9rsmslNU9fw22FkWWFb43N9qTiONOulkgsMEDqe3CHeS1zP1cGM5oAWe7Bx?=
 =?us-ascii?Q?hlvHKj4jcDvd89hia+QqICNIyu1y8THKiU1hwk3TEs76lg7kFWqp1t6H6USx?=
 =?us-ascii?Q?Zz58l6RqcMSl8Jlsr3oQgvI9xGk1z7EiSS0F7KPZvc4Xz6qFs63sXvXed7OC?=
 =?us-ascii?Q?voGNeOzsx9cdOk5elUoHBz+hEOAKcBVKKVhSvUTTFHHwxueiSqZ1UqnnzdEs?=
 =?us-ascii?Q?YzcSjWgheQm1+a/tozyxM0hoEiWccGaadO6I8Fsa6lp78Q6iGbrcJA0KI7Nd?=
 =?us-ascii?Q?Z8oI1ySYpyH3jrBfbDYJzTB5UxT80ZuBG06amx0KoU2uaXjD/hTi5wqysxe3?=
 =?us-ascii?Q?QN8TIsXZiUzDE9Ll8woJyGhmv1El6eDcGMPGHK7VxG0PBaj3lvor/43179i4?=
 =?us-ascii?Q?Mmb7wYvkd3fSA664wX2CjzjjiKfUGEbG7JmoWT4tEW4yzrHaucC+AHrpgCWA?=
 =?us-ascii?Q?FBdRpVIpDx0zVVBD6UgqP5IFl2F85/cxGsgAwB5nHr+GBMuq11r4NnpFEDoE?=
 =?us-ascii?Q?idq/WWEpiLuR6z8caDFZ3avqIykdJxsunCYyA5JAjmoCm75oGzUKLHzpOi+A?=
 =?us-ascii?Q?v346Nd+SVIbnSKKPCWvWBafq+IorXF5efMvKzssG25vsJw/K3R670CNpesTo?=
 =?us-ascii?Q?Ek9OpDhjsF+BYI9UzCjlvmSTZjllsiHbuNPgdE1Pe++N7b9OqVEMmWRRM28I?=
 =?us-ascii?Q?bwUG4qf+7Ct7cepCibpWlG5wFomg5UOWOWU2D2BiWCaW+19frmwtELlGV9Pf?=
 =?us-ascii?Q?MulQqnwSfrLnqFX5OMw7fmWIZfw8ojWa/Mciy9sBcYhVAa8LIJhqDp0LofMy?=
 =?us-ascii?Q?2VBLkbxpJD8Rpa61HqRrlJof773P6loH01nt7tNuF0LMa+Cxn41lSSHxVaD1?=
 =?us-ascii?Q?gVm64A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf3279f-ec12-4417-da7c-08d9b3b64450
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 04:02:46.2728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9C2EqeCp5XzulQNSBVL9qBwAq2ICRjoUm+kQkzN9ZxNYT3WzNL++AUC6BzJrzJd/FwfOi+8wCwFx8OItmpXKHzD7/VkVLg4WFDV6duxllKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111300023
X-Proofpoint-GUID: MJAU_GOM577Q52W52xXZYympnrgFZApa
X-Proofpoint-ORIG-GUID: MJAU_GOM577Q52W52xXZYympnrgFZApa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series fixes a number of static checker warnings. Most of
> these patches fix warnings introduced during the merge window.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
