Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D7AC54EE9
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 17:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiIYRRg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 13:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiIYRRe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 13:17:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E324D2A738
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 10:17:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28P9QwVi030813;
        Sun, 25 Sep 2022 17:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=NKdEH+jXXCotZ8wB2aO5B9aLs0ImY9CCnSZc1AbKLjs=;
 b=kNDHkNqxkQzbDjau/Z0g3oHlBOSAlnSisFRBWf5c0KAGnKfzzSgB+21FBYaz1bY1yvPB
 kzwQjfSZ0aqzUuNd7K88CB5jfn80KqC9Ses6oDmwBN4caP/WhVRgQ7CjZbOMMdjpVpiq
 6Ci+8e0iqWk4e3qtYC2LjrdgYqHSH5/6+Tpwzf/eZRYv0b9RiwcaCsqaRQZicpSfIgdi
 kQd+F1ZqtVySF9IctADna2t+/rN8Bwili/8MY5WDXTEMllC4cFiF6b0dlif3zkVTTkkC
 0JMNJmnAV94gqqcMJawHULDChr5c9bwBhKFyPyKOo7VfBIwcA/vjy1qxZtILe4Ehq6iQ 0g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst13a00c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:17:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28PCIADj019173;
        Sun, 25 Sep 2022 17:17:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvckh6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Sep 2022 17:17:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWFq17RKkpMo6FYlhZnptSyPPgeTeyIVRURMXqFHPrnElX4X6hwRX+Z6Z/zosBcMI9i6U0JhIvEzi3sli86JsUQn5+XGsrla/LDRQ1KbQNnhcttmtU2OlmElbDNMrZFvKJLYKx4GSLGTQAHH/xgzI0NEe/ru2Ts2zuB4nQ4AoBQd5NCIkPRE32nwCKh8IJA8FvYQVo+BpZBiGW3wTwb2jOqekJg5qVbc45GTItwpLXi+U+I2PUhn2D+F/9ksc5t8tIJq9d8ZVmd06o3kvt6P5DcK6iMkkpLiRTyBnGZQ4nKKPuj4PNsL59lFJ6OSNl/hFFhnPBJheFVr7HbtonlvgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NKdEH+jXXCotZ8wB2aO5B9aLs0ImY9CCnSZc1AbKLjs=;
 b=ffuht+K3wyOhXgvgb76CfSR7Ub6mtaza2sg5up4aN+UBVBXDL0psIWzGtxkN7vJxZky64DNAf3iAzyxiC1xUSq+23eKkC5TwPCLcpIGsVlLEkJF7ZhNBGBcZhY6+vbgHmuSO4l6xjmfasq67n3np/ooTuMoRm7wILoejuXBoRfdQnL+lz18VioyAzMOVkp307gPYwc/HCMhKxLo2Uc8D+E9XG52+uZPANVDNrn7EWvItcV+zqwNgwKcmM4KDbEIWnBkBhZDLKOxCyMnQaYDAv9CHepAgpH8WOuhZAlKIRwIVcQxOw1JOJK04IS4MwxDN5SqJqC7RxFmtc4JXYdZnrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NKdEH+jXXCotZ8wB2aO5B9aLs0ImY9CCnSZc1AbKLjs=;
 b=R2qBEj3rcwa6FSkm4Zn/Wfp+Bzqm5of1jSm+0UwNzv9hYNNKPi5Ccm8sSO0EBiRpNrlKXonaFb4RPNjNhDxEGnX1DMiic7v6vFHlTIUSremsMQHgSGAVU6KTtiftI4Ai0lt2dAi1oRNJMXFtvyBWFL+0GH4TbTa8M0E4788Xpnk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6880.namprd10.prod.outlook.com (2603:10b6:208:420::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Sun, 25 Sep
 2022 17:17:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%5]) with mapi id 15.20.5654.020; Sun, 25 Sep 2022
 17:17:21 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <jmeneghi@redhat.com>, <guazhang@redhat.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2] qedf: Populate sysfs attributes for vport
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d1rqsq7.fsf@ca-mkp.ca.oracle.com>
References: <20220919134434.3513-1-njavali@marvell.com>
Date:   Sun, 25 Sep 2022 13:17:18 -0400
In-Reply-To: <20220919134434.3513-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 19 Sep 2022 06:44:34 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0076.namprd07.prod.outlook.com
 (2603:10b6:5:337::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6880:EE_
X-MS-Office365-Filtering-Correlation-Id: 07158d0c-3af5-4d46-7df0-08da9f19ce49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6KsxTYU52EkJa1PTaCQTePWhloPg5RomQYqSdjL+/QCVpgCeuTWmC4LTVYjE9YFPPBJzGjoWUr8fvoiFnil9geRlMQ9FW6Wi4YstOw/KivvNZsly1C9u/2jyDfzv29ziV9kU9MFnB6CRkRmk/RNPW+FHx7OfU3adeRV4rQFIBQjoZKvzMXyWA87klQgN0u7IKsgzAclO1zVrCEDcGTXRMAjnVS0LlUH7AjX5JHrpZc59/GxH3DQ39lGdLoIgTInckX71vJ13Ncm+AL4XXBPSrxa/tZg/bv8AY5X1JFGWZJpyPD72JbspHc/UauFgclZg37Aq29IrTYvTiPbpIZQHlmjljZcfFQZhSB5GdA51Y+mkEsTsrCA72sTo4Ks/c/1+Of71cU3Fbjb+K3o4Mh5tP7NlijTt8f4u8MIz5jb2SqbKuUSHsuyQq2jcTy4ARr2li1VGloxe6/nEQ4+R+nI9M3ejGFscFTW4L8yH3bCHFdvN48fatuCJQN0ySyNJjLxByNPmaB5nX2GOaggFp5G5sunSHKOvtYt3sAwwa1HksAD74m1aRa4dpbgoVHh1Ksuo2hp4dMOoA+woWvuPA8wexr/oVcNWL379to80xu+PpOcVbVYG7mvM+gWXtLt40gjkz+15fbqWLBpLjxritKaRnDNjTmgRs+jr1AVqdkIi5P4tn6iTmjEvoCGlhxUufZs94oKE2sxceH6uWU4zuTRLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(346002)(39860400002)(396003)(366004)(451199015)(6486002)(66556008)(66476007)(66946007)(8676002)(41300700001)(4326008)(38100700002)(316002)(54906003)(5660300002)(86362001)(6916009)(8936002)(558084003)(26005)(6506007)(83380400001)(6512007)(36916002)(6666004)(186003)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5BSFz4uDH9TheA4ZkTiPzeGyTJy8Z3mU9QIGNPjQDu2ct5Pze7QPxKmRdk3d?=
 =?us-ascii?Q?HcOd0g2pOUBtIKZf7oKWFkZy1myiPW7lJVB++tpVHUAX+Mgjzql4kAv1OQiW?=
 =?us-ascii?Q?/P0macushi2C27Gh/NzTzNqa8sc8wDcFoS3euBmNmUbRUSROY57lhEcDhR+j?=
 =?us-ascii?Q?jfap6fVPzwL2yYd/TzK5r/hJ+W+T8V3b2eUTIK0lhkB5sNNfvBIBMvxysYH7?=
 =?us-ascii?Q?4SyQ9xQlSHnmEuirGnPEQCbBM/p1a3pKe7UM/P+qMjc/allQZ0rupt6q64Kg?=
 =?us-ascii?Q?pTHn0A1PluNztcOfIoMvovtRPPD1mjfXxKEorcGGe7LkWBt8taXzTwVszgGD?=
 =?us-ascii?Q?kvzDfu7wLSXaomEY4fsqFXs+fNhY5vh/ybN63d5s+yHQDCZX0Pl0Vpx48S9f?=
 =?us-ascii?Q?wDJCjBJjI3bf7rxwZ6yDcOBjwuzi1dZnPTJS+rq/lzbB8BADmGS1cDR5Exs2?=
 =?us-ascii?Q?QqEp68my8bbCbe3xmsKYfzRpiRLwoslALIKd0ADlfBcHoh1I7Y7KpqeQT3bb?=
 =?us-ascii?Q?+JoSEKLfn/TCPX4aBhJ5ST/pTgUle/v+WnMWMVrbRI2PCNUCYx4SobCShBtM?=
 =?us-ascii?Q?AeD7FCGwbIYX+Hu8v+X3jZ4ltZJNDkcfAiR68MyGhqQt8RC25m+dehJ1H0jT?=
 =?us-ascii?Q?V/7G90y5B1LAUOzX9Wparq2ikQUOMDo331cGvb2tdYSgUSZwUQSaiptSDuOV?=
 =?us-ascii?Q?7VdaE2JfwfNzrcKcBg59bZ+FM7Hqk2wp3e1iRG5OXhqm61FE1SgNVUVPxRP8?=
 =?us-ascii?Q?t1WuhJfzxygwMsMA9YFp54ygdHbt7RQ1TO65k2qeQQrT2mrExKs44slp/SuN?=
 =?us-ascii?Q?1Aia5vwCh818Foe8AJ1tGS17gxunF1lwa+tNiK5Mm9rP0Np1uKWPRzlsBUWe?=
 =?us-ascii?Q?9n8Mz3nlNDVIqOhofiarkRDZ0cdvDZuoW9H5IO0QVvKWJJThx3ic0TGhhM27?=
 =?us-ascii?Q?2Uidf/j17L9gCy6vwlvsbVxGluD17YvffaiE/OcH1s0b0Cn7Ebd3nl+0oCgP?=
 =?us-ascii?Q?S6PkJNX2+m2FZlux2qu15htrLNFkBUY0T977zPdX7AH+pYVXn1fbVQAaWNgO?=
 =?us-ascii?Q?r+5je1fFccZUurMn1iAu+ne+KR3bD/Km3JH+bTEdS/omAGlPNaGkmbkXVTE5?=
 =?us-ascii?Q?nE3qvdcR1qYVw9BoTS7QxKJ6zdwzYlRCuP0JI0NQrzKmdD1eTCtZErW8lDzD?=
 =?us-ascii?Q?kSlUVJSLQJKPw0NSV4s+rzEmBNpwEWjFi0PnJaFJeuHNUxmF8Ji7rRSUmzo3?=
 =?us-ascii?Q?eVckzPN5w1CtSu7WHWuE/Lp0LMjIuuHfYbVfSIyth4AnYKGDGZ4nzEgvw8oO?=
 =?us-ascii?Q?SYCcJmBkIlkUz37yios2PcQ40ahYxL+vQu6HGOdAF2vUuBNe5CKm2yHR0wHd?=
 =?us-ascii?Q?5jL7XgdP99t56xdUs7FTeheXyORm39AYkYVNr5ugIafoHvmxj3J08bDdMlOk?=
 =?us-ascii?Q?XgHoU6McrrITu/GIFeBl0Jdi+0002QwM0jwNevpQ09sEhfI73chpFSYM7zzo?=
 =?us-ascii?Q?rT9dDH9+79gSwsgKymnflrg1rk1gjB7OxL12kmo5CnYRnhE4dcZNKBzpvPUC?=
 =?us-ascii?Q?mJCV3EaSUkd5vWRfrf79qfh/To/dSpiRFiavlez5qkvnVndgYlbYFc+UNrKy?=
 =?us-ascii?Q?/g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07158d0c-3af5-4d46-7df0-08da9f19ce49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2022 17:17:21.1674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++QlXT59mg8IOfTZtyd9y62PMs7v5uvihJfnItD7B9zxfHuSdphWjIGxyZukQ29x7dXy8FNm7gCJTUXF3c2RGXEdDoRyguyTYder8CpJRdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6880
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-25_01,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=775 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209250126
X-Proofpoint-ORIG-GUID: eM-8uFnDyJmRR2KaO_3YLqo4x2m7Mgb0
X-Proofpoint-GUID: eM-8uFnDyJmRR2KaO_3YLqo4x2m7Mgb0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Few vport parameters were displayed by systool as 'Unknown' or 'NULL'.
> Copy speed, supported_speed, frame_size and update port_type for NPIV
> port.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
