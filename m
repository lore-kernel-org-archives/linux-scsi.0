Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA3EC48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 01:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC6160FE7
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 01:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbhFSB51 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 21:57:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36836 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233167AbhFSB50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 21:57:26 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J1ouFH020737;
        Sat, 19 Jun 2021 01:55:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vHT4QiUxMgGBHWGAdeZKQ96FHRfN8NSRC7FRhY0CywA=;
 b=JwNy8HsT+qGZll+KMr51W+TehfrC9UJearYG/FuVlOyK8lA9BN3cOMz4xJmj2qf3/lsA
 JV5MLONE7oBQSFt1+xDkNsaDMyc9bOkQzfmCTAI7bqio4b+Folb34bztB1DOKjcAqv1v
 aOaeW8E5M7efeRufoxbWvwyDvheAnjX5Nn72zAFqVLxx6ZkDt5gDZO8Xvw1fPIV6Oz+1
 PteHku6Ixecj7kPnsrDoVw9y1aERfwae5t4WEn4DH8O+8/zXQY6HbIU64DzvqGkM3k3K
 uweadRMq2jil68HWEJmse1nlOFdSlYrcSl2KQKGF5hAqodMALYYtMPW3BSjZBkKtL3QC qg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3996sn80jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 01:55:11 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15J1tABh169271;
        Sat, 19 Jun 2021 01:55:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by userp3030.oracle.com with ESMTP id 3995psa3e5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 01:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xa6BwsmbjQlo6+dM64jcrkXCr69UXKrB5xF8AwuRbzLEd3sD/F9ARW/ZpDVsdTKwSmaeVgQrvtZ9uZpRtKoNTKX9S40BVgAwiwEZ82wmP23Ay9SKFZnvv6Z+kUB0m6BSnaSUxOTADHMeoglwtvKITvAs18d5TPFWY0SCjY4/msNC4MosLe9qrKlzZyPPkg6M+aPvYqGS+3Q9lpxgWtA7ZIzaJb9RRZ0yR/YCLUKuXANVYa20F/7IZmhQwE/5wi5z+3PzusoQqHYTk+bKlJdOteWfJ+UWKz0/4BOz5RKtblwA/QaiQ4hvsLCe4dthv1bngXXrnNX+RY7rerV9KCCZZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHT4QiUxMgGBHWGAdeZKQ96FHRfN8NSRC7FRhY0CywA=;
 b=GTlTXdSqJ7bNdxfStDVMgzHHA013nr6OMrvbEixZXSZWi8s108t2OELXjQEJ90xJcyyr/BZXTrEKLYB314JOYoLTvYxhTYXTSnbOni4cF0iK96yy0ut3LSCDo3zEor2uMN28mkq0kG41LZMLsmXs1H7oQgdVTS6oXv62BNWY2Aax1EDO4Br3z/tZEXPMIzgEhKqXUuikF1Gy6fL5MWKl5KsWlvWYnJkvAA0JnIuGa1wvks+MmOEjNxSvd+WDlaU3Uifo+EklTaEFVeKTvxsP2Y6KnRAsVRi702GpVy+mQIkR7LhTSu6wrDiqdjy+9DbiFJo+6yK3EPCLB1fcXvpTBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHT4QiUxMgGBHWGAdeZKQ96FHRfN8NSRC7FRhY0CywA=;
 b=E0scmd9MWg/LQVuycgMQrlOF1nw/khqq78VTflVbN1WL094lHzdGiNv2Ey/dtYw+isRdAB/XBl/0Oe10aPO2jVAuyx3+dXUZt+xLQwaChWMbq0KHUSVbuEUO7lRh757oyVItu5oBdCBOlT+9HMoUYPKZsT9e4rXGHzKSnF93aQU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by CO1PR10MB4692.namprd10.prod.outlook.com (2603:10b6:303:99::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Sat, 19 Jun
 2021 01:55:07 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 01:55:07 +0000
To:     David Sebek <dasebek@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1o8c21uyd.fsf@ca-mkp.ca.oracle.com>
References: <YLVThaYJ0cXzy57D@david-pc> <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
        <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com> <YLejIoBJ8YJuonVZ@david-pc>
        <yq135tpcfv1.fsf@ca-mkp.ca.oracle.com> <YMqxLleq6LQP1Ecv@david-pc>
Date:   Fri, 18 Jun 2021 21:55:04 -0400
In-Reply-To: <YMqxLleq6LQP1Ecv@david-pc> (David Sebek's message of "Wed, 16
        Jun 2021 22:19:26 -0400")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::9) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR13CA0214.namprd13.prod.outlook.com (2603:10b6:a03:2c1::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Sat, 19 Jun 2021 01:55:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 439f43d5-fd3c-4a4f-f13f-08d932c543ba
X-MS-TrafficTypeDiagnostic: CO1PR10MB4692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4692FAC5AFE3C3FA2E2E63758E0C9@CO1PR10MB4692.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fAz4X5S593UIQAlZN5P4L/fguzIr80J8/SqCoCFQ69OSvQgTF2eZBKKqZadHxsEuxjeKKuiXDPaH3/xtEZ4AQ8QINxB8uzR9+BxLwU4oJlgprh+FWxPDDLh72y0S+fvCsfNSdnMPqWK4yWWjuF/SRrud4WNk6/TIRh/4Y+bgV8APAWDLG7kNcyyS4u65gs5f4T07lqYR1Nrh6lV7/85Mrp5b+5Y9vU4L8mSXuyKWDMXn6+dEWm1cl2bxqkZ45ffNX/UOVkndn39Fe+uAjruzz0Jg8QW1rVnEmkKQEPMyBakEloLTiVEBbeOVuHlCjKnVFviDyo8jkQkmJcxcv63txJjHFlefH22OIupsaMObBUZObjtNrMC5wojMy/lkS7Ku4SJv9/IyAcU+seka97BgOL7MPFO+dG8fY7wlJ99IA1D/9j2TcSrk1qVMtDCK8n/oR+9hEQZGQH6V0uWB7eE//qRei8P1cLO+wvlykmcbRasZszViCOvPGX+ekWVjvZxaV9o9oJS63D59Qb8XqrVthMfPkvibzk/qaWm1tg2k670w0JCcUHpj/JhpnWjt+QniCf+4G3VVPRQj8DrbcjMBWkqz9PYynSJsjjdDsGkxwyd55Nup3vIkvnFEQV8g20EeGn5wn70aWKecBzz0Qh7RHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(7696005)(36916002)(38350700002)(38100700002)(52116002)(5660300002)(8676002)(26005)(558084003)(16526019)(186003)(86362001)(55016002)(2906002)(478600001)(6916009)(4326008)(6666004)(956004)(66946007)(8936002)(66556008)(83380400001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BPxhJvU8oI5yMHj4+ejiXKK0PeUDZb8ewfAwQdwmt3l5rWcdA+73F5EN2pno?=
 =?us-ascii?Q?Q1Ty3govJKeinXZT926tVvczWeRvGLm9fSR10OZOAtE1eP9lyG1xrGehD+Tz?=
 =?us-ascii?Q?jGqY9niGtrfPHXRbFd+P4HsOjXyRpSdfDcwbeb9sNMazLshzMPMlYtfVUVPX?=
 =?us-ascii?Q?O6dXIQTs7YaKHlHLdq6pa6Lnw4OMKLIt36x0Rs/vtjYYsf654P/B3VPIv/Tl?=
 =?us-ascii?Q?FAa5YvH2G28ckylEM5/X/0WQupvYLDZPhdyMcp/KbMBemKfg7VUJPt4Bvkix?=
 =?us-ascii?Q?1SUX8C/Epq7vRoqEkx8qMuoaAn9YZ88qgoJYbeBJL//PtauthHlfTsopgKsY?=
 =?us-ascii?Q?0O3XWb1/uTJJIs3aRxWnQaN/bjDJRidf6lph0h/HjhBiKd643LXN9Momr/om?=
 =?us-ascii?Q?HONBTiG18bDGmyj1hLxHDx7bnKO5LzN10gAekKvNjdPN+75znKzyUPBbwLUn?=
 =?us-ascii?Q?PAnDDP7g3tXznT5rjq53MrBrw9HeBo8ZPWnj0DhgiEYZ0HwF0EFUPL3bJ1aY?=
 =?us-ascii?Q?kS4ft+Ojaejgtkxuxg9qzbBSRPjLo1GH9cZcESzZ+Dst3T9bnBhAmk0JnpDs?=
 =?us-ascii?Q?0UgoQzGKzKBXfsgO0ZnRVPxgyA98HO6RJ8Y9/gY3jLYMoGhFyHJNcIt4d9jx?=
 =?us-ascii?Q?gVgwhGoEkZXfct4ogGUOzZXVz01yxnQKjWo1piZ3WBBnrrQIEtCQ0CHnyN/q?=
 =?us-ascii?Q?H+nnGGiKTSnhY1QOyQmpXEU9HpfIp3zN36JYzuiRbWYOW/nmbo9YmT721cjb?=
 =?us-ascii?Q?wLqFB9HHxqpldb7vNz1+N3jjaaIvSWQWUDsJxbPj/4qD0CAF/SU1l7XvY8wX?=
 =?us-ascii?Q?+T2b5TU/SSTCqArsD9rvcIZwDx3n0XEhyfaFThWpKOFBRcv+Ej1BVGfY0LCB?=
 =?us-ascii?Q?Ij92fF1JR07nBaNit60QsgyRsDyR35VDguMxY9UWAhBN/JI4xhg6uSBr6Iia?=
 =?us-ascii?Q?/TmFNpaDOwK1AGQ4FDdDzeaIzTeZ9YJtVWlOE83RNQVTZ1aNJWWVUSMMQ6FZ?=
 =?us-ascii?Q?vHQo40BAXAFz6kwV2Ps/K0W0ID7O8zTbZYExjzvgjBCaHwSGc2wfU7O6Yg1/?=
 =?us-ascii?Q?aus8BvCJaHeIW2i5WHYfw1AnuZWsZbgZWXtW2t1J3o8xghgl0RgkrQRw0ZoX?=
 =?us-ascii?Q?MiYTIpwFA9k5HEUvUcOJLFDLdkNoh6C5pSd7BFjIq2YSgTZOlGMqist9Jpfz?=
 =?us-ascii?Q?ZfBZ34ZADJEfcyuPN+O7/IZMQyrsWM3B9CNyz5X2UAK8TRUktoemW1kUBKfF?=
 =?us-ascii?Q?/cwrbopZ5++/ACCcpwF3On15ZpZXJl4bTt4k3oTRvGfSrFHruRPuVp5Br+gs?=
 =?us-ascii?Q?trX3JCMqwba2fapIoDz0kA8q?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439f43d5-fd3c-4a4f-f13f-08d932c543ba
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 01:55:07.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xnBT2u1uuquOzbz/1wS5RGQ4ltz7CHixMsv1J2yvzq5W5Ufw5SPw1gPQLMC800vaDylSqSjSUXjbLLFZggDVa6g91O0r7FC21wv+7g29ayk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4692
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190007
X-Proofpoint-ORIG-GUID: ecIfySYe3aXO-AmDGTTb9IrpE8_0tnUD
X-Proofpoint-GUID: ecIfySYe3aXO-AmDGTTb9IrpE8_0tnUD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

> Here is the output you requested.

Great, thanks! Looks like my discard negotiation should work in your
case. I have a couple more corner cases to fix before I post.

-- 
Martin K. Petersen	Oracle Linux Engineering
