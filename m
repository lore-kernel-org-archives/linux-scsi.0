Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A62C77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 01:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjEQBVw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 21:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjEQBVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 21:21:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E958730E8
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 18:21:47 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34GJx3om021325;
        Wed, 17 May 2023 01:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=EGCyXGq/u7DWSvzmYGsWllo/9rtJzycOrFf0YiZk1Is=;
 b=U8eLpwSvvO++7IHM3GPHBnfojAMaNDu0l0IqKCMju8Dj9eVKsKeRwv29I6a5wZcTLgRa
 lBtakHliGNBnZf+9NVSSV+sODZ05kKTJo+8mZntYIIqGOM0T0vru+8+IspIX+GYPQZXB
 Lw2mACqp6UcF+TOWn700LwQuq3RaAEulbeQuGUu+l50DyWe2Hyi5FaMVlI/xN54eRcAd
 6Vi9w/zpSO2oO/dp2hbR4QwVft7SC2VKIEtbL86X3ZOU6pIILpZ3PaOSeD0L05TVfLHw
 Xggy+oIbpWgK+35QchBEvEs1xlE3d6KAqsMjsdjzCvDDwWpS1of7vz3Yva/n0Vh+VTcO /Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0ye4dxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:21:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34GN0REv004189;
        Wed, 17 May 2023 01:21:42 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10b32ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 01:21:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afIsfWZgmnL7MeYvv3aDZqoJiHX8V/UaJhrn0M2V4X4pw8eoGn1RmaiE84yG7U6SLO1KguA0EhJ+Rq6m/JIgbMbUTyVrkeVtBc0kdNDl8PB60nS9lI3/bkOG05K8U0kTyyWG4wwGlYNCDsepuzsWCJ3hTNoXBmln1Xj7E7xPpV2fQ9FPheclEsdEwE74RIiz6yEZzvMGFfwc8woMfOgEadug1pIsHTehPPYcWPcFelK2rAIKSErHR2a26Ly2vdfVr4W+zTI0R4PWxvWOAPdZPpY7oWQXyQ4tajdSIQSn4m/DIniq0jBqDevQFMRu0/RknM0tvp5BocXF+WWqzzXxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGCyXGq/u7DWSvzmYGsWllo/9rtJzycOrFf0YiZk1Is=;
 b=OliMal9NNMY+q5ukVGYuELfvn/vCj5m0eO0rLW04onAdNGY/F5rDu9si8uVNH4jLEYyt/W20z6QWvZOIqA7tylEQNEgDTuz83r4lHUzZeAmW4SkEL4YqAlc0PO5OcEULKm+9eBGQQvGRoWPeYedA8HJe8leN5h7UvmxFIUztDXbBKs+D0GhiK7Mygwjs15MZN2ilbqO20Skh47YIFCv1UDG6qme1atnpf4ZOYSvFvNQ6EUtwuPh0q9rk0WmCVkpB+RlWuzTe2waoCG8vDIcdGyeCj6+XirxZcixn3HBGvzzSgOw50pn7gJ/cHnyU/eRrX9+Fjm5ncS82aSjM+ndc6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGCyXGq/u7DWSvzmYGsWllo/9rtJzycOrFf0YiZk1Is=;
 b=LC0Fx985ieEvfhoaM7uETspP41qSyfmUMd4XPhgFepcgyQIdMhwP8KuDVJN9BiqLFoSMKOtzqMDzYOqbH+VZAFvLM8UITzGkjQcuvcAbfXimcXa4nfKs8mNyMYabsgLewRbofin6GKV+iqjbOybUATRiZtjRCQ4VSd0tPBOfKro=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW5PR10MB5738.namprd10.prod.outlook.com (2603:10b6:303:19b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Wed, 17 May
 2023 01:21:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 01:21:40 +0000
To:     Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] qla2xxx: Fix NULL pointer dereference in target mode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6sbvjne.fsf@ca-mkp.ca.oracle.com>
References: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev>
Date:   Tue, 16 May 2023 21:21:37 -0400
In-Reply-To: <32b0bb9f-ba6a-e9f1-e779-5af2e115c67a@scst.dev> (Gleb Chesnokov's
        message of "Thu, 11 May 2023 13:02:41 +0300")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0313.namprd03.prod.outlook.com
 (2603:10b6:8:2b::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW5PR10MB5738:EE_
X-MS-Office365-Filtering-Correlation-Id: 74108a77-3f9e-464c-91d7-08db56751126
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WGxkYVN6iKuKc5nUPdQyWhiqRYiInzSDEklIy+iYqooBzas2K0PBHrPWtDcVf2mqjNx+Iv8uji0so1Ikqr2FuJ1Y1kinS0L7QkAyFYd9yg1QyEgILsXYNkiaFJYHfXBE8SVxko1qEwSVwf5kwVb3vjyULxiY+c5Qy3fBMNOTuN/HZTLpsp8h1XMhojY4QPTeZ48qnih2rGTz0EVuNURiYjxuXTesEFjf1NhlmL+jZlVdBB3aJyNs5032Rw589zNRyj7fc0c/XtBIGI4dStDnLhWPr9Tpztf02VqPbOgVsFDqNsjXGNX1dv9hAJrrOUZMGFmwFRiNw5GhyUuZ8ydnaPGJbgl5febG+HoReRgfO8DKoOtuOBiIrvebxIgNbR3QXTGe6APBXReJOkbPheLnNhydHjC88B+EGZc89hnNNZDvilrHTqrb3EDqzfR0bI6BaD/Bnu37RoDgzFvBODJxboX94zLOuqgn4rIL2tztv/PIT+mWk395mEsxF/FZnvfYsIdK3GCMCXaSrn35YJ2rpZlH6pLm+MpodQhv5JFGhlhvbMmtCpvnrTb8aNv3I8ia
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(39860400002)(136003)(451199021)(6512007)(478600001)(6486002)(6666004)(36916002)(26005)(4744005)(2906002)(4326008)(6916009)(316002)(66946007)(66556008)(41300700001)(66476007)(8676002)(5660300002)(83380400001)(8936002)(38100700002)(86362001)(186003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qY9SCQTX0inow2ALTT/qW8LUaaP8BzdhzDQk9XyTROjCG67iKSo4SnP3+uHg?=
 =?us-ascii?Q?1uGVNDo0P6oo5LB9g913Nf2fqQ5qaPBckgnlq6ORxdhXaRZPtcsIiuVSVZAG?=
 =?us-ascii?Q?m1VKekQpRiccuBJcgaGSZJIT6ViITRETXxlfv70au7Ckken8oQPHDm7vVV1B?=
 =?us-ascii?Q?LGms+ltcjVHjCJYrSTrpDTnTPQC0B5rDtjKfLlPNdG4mZr8tQm1ZzD3tKAtO?=
 =?us-ascii?Q?YHQWNJqp4ufiMJsuFiW/6IHsIAJ8YFkvff3UKgM7vAXVzroJH+rNmRhREwpT?=
 =?us-ascii?Q?pS9guCXxt0t0yW+1tZAwK2lH8rvFAuip/BkD3BHTfsNX8xs2axZi4GK8J3Id?=
 =?us-ascii?Q?5895wcPBWe1IOqHcUiq5FAegsSYppWfT6XdzbE7tpl7TX9IrQkAqjSnRrCZZ?=
 =?us-ascii?Q?eLHtUocvG41reUME0OE4wdHQQ0QNofgRLkkNe1/5IzllBpilhz18AwgNMYZV?=
 =?us-ascii?Q?YhyJRVlwjtdi84OnGjzwgrZ+PhIGo8x4MnEsHcJ3uz52t13AsMPTFqlMSH0o?=
 =?us-ascii?Q?eCPOu4OU8yl5Y44r3n7WB0ZDxMvEtLxdOrMTPqXJVOmjXPqENnlXYU0ak1w/?=
 =?us-ascii?Q?MAiEjo1VQLNcZr5l9G4gfUZ1vSlvY1s4vfoTp1hmH8ZkhGAC5YZn6rCljUxQ?=
 =?us-ascii?Q?9aKxy5i/UEzKpcdYLhyTvHNwoftgNyrT1p4ky7v0mwnhBqZvdHhGcXYYk68V?=
 =?us-ascii?Q?gaHu56tgn70Ere1nbMrqyQHGLahFvkAx4XC1MkuD+3DRezi7cqmXqL0FZCx1?=
 =?us-ascii?Q?rjOUk/BIR0LIbeJa4lPIgHQsnfvRLmY7FOo/9otZAIRMXvDvWVjH/2Vyw4ty?=
 =?us-ascii?Q?SNUDPij/SskEpJNDVhpwmcVSOiaDxJG6fPYx6eBmGHqYGeTcM3GrUiV1nQv3?=
 =?us-ascii?Q?QWUwMjuYXb/RJAROkFNOx6G91wbhL/hDpmmZ3An1oPyCV2z/TMpdI0d/PmRc?=
 =?us-ascii?Q?2wd+McfJ/lOba3fvBmsOQKc5n+jFYjyLLY4u08kEqqAY8+5q0aP1Zuiayveh?=
 =?us-ascii?Q?bLcr7XsxzOpOUZtahVMnfwdvt0T351lHVfqOPs8+FDF8DjEdrV1Je0RL6tKY?=
 =?us-ascii?Q?EQvoeewQr+UOon4bzX09yuE037J/z5/9wMdazu1xYq90XsNGGFUf0XKxYTXk?=
 =?us-ascii?Q?zjh2/0waUYEx9cWxAyBwFk4ba1uNloAs1rTnODWQga4YU3fnzvLGyJYowMv4?=
 =?us-ascii?Q?8/Cc5q3v407NrbjKqvFo8VUMkbILm+XD60fkxtY3Fa4AyqoPSEVjUiqSjD8D?=
 =?us-ascii?Q?hbH4dNAODqEidy4/7KSAEPKY/bKkchsIDsNLeJdIOpgx57G5gJIyETheFpLg?=
 =?us-ascii?Q?qBpaG2uToL21iWAZuoBU9vAZjGhxR5S+uWBD4r+uMPVoDBn+ykbKpnRJaLHv?=
 =?us-ascii?Q?cMBN9mLeUmDruL2btuievaDfgsjAznRDMQEVQWrrIjrx70HPb7WuH5tCsU5T?=
 =?us-ascii?Q?AHa8NKTRf5CGanvF1PBTSjrLE2kshyi2japdPhJM6zt2VAEyNPZjd+5bfebb?=
 =?us-ascii?Q?oKYbea09E+HPLB3X8mXJkUo8GP7n/FvuAkw01QyLPfdpfgNrIBvW4pesEp7M?=
 =?us-ascii?Q?UF4I0pgBj6lVhDfCfkwM2ZlQVRKTR+0ltCFwV7WVbpACKx1o8GYdcFceDW3+?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mahr5c+IQ4CihW08ItdDXTJzqvLdh97LTjRP0WZx+caK+8SD/EZpXbnEledBVB0yAGzcOSPjx/71nHJ56BIWPZfAM9tvaWNPwzfzaalUw+u0WV3Q3FA/o3y15IswWA5HZpYO/+OlDhnzkYvRXzfmsWGPsK8hqYNPZcrRBz80YlUUBDfuV008SXhtAMN7N2AP/r0zK7Q4U01AozxUxTE7Uudz0VX5Qbd+fot7RWaC5XlGf+PFkTm3kRR206/kpLO53ov4wHnIzqZtbexeVIoqQ8UpEoAZtOPQpqPEbP5F7yAff9jA/LBL8yq17mdj3e503vgSxe3WB4CcE9ITD7IMXMFv2uMunOPBE1bAyW9OxkMhrWYhadv/aMEsAUJ1AS3JWl1/iz0BXZMPuupd7+Cl9WFoSTM0P68QyJInMIETk02mWjXdnbxCCRUaB1Xjql8cSloTR11CZKH9g4048Zr8s4twESWnGGo9z4BO0kS4fevQ2d8QYcomijnNbDTiOjxhGfzXIQP161az7B0DTXz7ikcYw0G/Sp2SnXU0USBlzOo2m1HNgypJtLynYhoSTbDvUIhf0clFTg0B+OXDN/VyC68Tg4fF09Hc0bMviRjOXpVMnQn2DP8stlY8bKIk56KR1b+jp6n5K7/LO0kOFeEW/dboSiG70f24tKWzcLoMJGJA8nlQ1P3Xe2pQh9xXRJkOvX+G/TCc+ahtAHPlD0UA8I6J1feGARegRypkhGWhXH4nPDxHrniR4zMQBgjBguCPonTDHlx/WROEH23+9D48bUzqRwj3jq2WFV0vALGVzmc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74108a77-3f9e-464c-91d7-08db56751126
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 01:21:40.3537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k5d153rxct/pgMNoesk71Pka23/+Ej/mtvcA0lLNluajY5EW5a8F2KyS2sUxXKpUrnKR/tN9v82zVsenjRAE4ogtKGXKjDOuQ7dCwlkYyo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5738
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-16_14,2023-05-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170009
X-Proofpoint-ORIG-GUID: sWR1muzeOjfnOzY53rhUWtv4tYFku8VF
X-Proofpoint-GUID: sWR1muzeOjfnOzY53rhUWtv4tYFku8VF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Gleb!

> When target mode is enabled, the pci_irq_get_affinity() function may
> return a NULL value in qla_mapq_init_qp_cpu_map() due to the
> qla24xx_enable_msix() code that handles IRQ settings for target mode.
> This leads to a crash due to a NULL pointer dereference.
>
> This patch fixes the issue by adding a check for the NULL value
> returned by pci_irq_get_affinity() and introducing a 'cpu_mapped'
> boolean flag to the qla_qpair structure, ensuring that the qpair's CPU
> affinity is updated when it has not been mapped to a CPU.

Your patch is whitespace-mangled. Please fix and resubmit.

-- 
Martin K. Petersen	Oracle Linux Engineering
