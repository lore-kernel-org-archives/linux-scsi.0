Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F38E82CA1
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 15:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjI0PPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjI0PPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 11:15:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0C5F4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Sep 2023 08:15:05 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RDSn1Y017472;
        Wed, 27 Sep 2023 15:15:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=nHbYZT32mVlnZWcU953hdveeLHv4sB+OzUORWuBrEs8=;
 b=mj5qteGmgtGvMvjzzNA2/MAB1Gqk320vlL4JRqc/BDWAQaN8KPPqZPXEh7D1HISwvd5N
 5D1qjGSZt1NbJ/ug31TamAYQClF/OjxIFHHk0qLcC2//yZGWRgvJiorhKHIZ5DvXGxA4
 A/mfnghKBGsfsQ27oMhhASEJxMphfnu6s9Rnnssramx44Iaz3jeoa5pN1ok86NDdx9f0
 Zn7sgxCoQUTwXgy4VLpwSXG94QcIvq/N/tuGdsZAaeogEeLg34Ys02U0XprvGqeXJRdS
 AZa6Bkrfb+b4ZKGvDk90IYNyJqF74plN6a3sryShLOraeRNbVrO46e4D+QKs9FJb+xOZ 2Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmuhtxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 15:15:01 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RE8SFi039347;
        Wed, 27 Sep 2023 15:15:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfe52y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 15:15:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdeEGfP7ul0G9burAljAugrxKWzExLncd930s/r+ZT/+egkc7h3nGrBd+dLk4rHZApdOBAfAH41KDqnUJ6HuNpMc6Kje+rbAEBxD+gJuTfQ/mZktR68/DNdJVpRrekzE37CitPEPj7D7GynTTAXHXrRCS7W/wOPHQDMZrAlDm9ULRX8vRP7XnmnagqvsSU+H5LzT07FRhLAUhifa0X8swwbtPaZ+dVvvAgfFW8s0sM5kAkTEcbCgcH6eQq3ZMh8ObsYJYFtubvfsrkuLmfKqXOThd5ymH7S0YBgg+5WuGA4zhNyCJF0cb7euY+pno5gBgbzabqSw9YFt3C4hso2QPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHbYZT32mVlnZWcU953hdveeLHv4sB+OzUORWuBrEs8=;
 b=U2T0/vILgjykGINjXMJc2lSSGOsIcl8St+76uenmiOHc6KQqtI+2efio9fgFuYjTCEQOTq3dCMUAk7xQmombqB20WudOGtjzzhZz2Th8Pj8nnWGD9Hx0GFczhNIKwOvU2xHPE6u2bn++ElPYjZkiO4ukyDVvMVw6SKDockJkx8xvBsvu0+zbTx2ZCHP4Rqz2MjqnR6h3ngO+fa29pnwlXdQQomf6GmGpi5HkQEL7ehoQYtMnFG47PwtnFgYX9f5OKG+gYT60Yg6GdKnKeazaJG9XaYeejj/N52JEdBFnCZW4wLHqUJuJHOf1zLhKMCgs9RQqNZSXlErsWj7IGjykVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHbYZT32mVlnZWcU953hdveeLHv4sB+OzUORWuBrEs8=;
 b=ky2B2nkHPYDR8e8s3VWZ730JgS5fK9Z0yo7y3yGI+LoODjAXV06TGBPo8VLWDBZtf0TqhfAh11iob2cyn/t2WCa0BVf3MPGtq3/Q2NVXZ0lmHDmkwoJfcNvAxMqmVVIMewaTJHYyiaPYzZhfIFh6KUJIQURq3kNJ9FpdoG8k6B8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH8PR10MB6671.namprd10.prod.outlook.com (2603:10b6:510:217::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.30; Wed, 27 Sep
 2023 15:14:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 15:14:58 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/4] UFS core patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bkdn1wd5.fsf@ca-mkp.ca.oracle.com>
References: <20230921192335.676924-1-bvanassche@acm.org>
Date:   Wed, 27 Sep 2023 11:14:53 -0400
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 21 Sep 2023 12:22:45 -0700")
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0458.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH8PR10MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 7436a5dc-031e-4fe7-b260-08dbbf6c8383
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eWBVfbYvPG+FeBas9zPypPi6UfXfAO05kWnPftlDENz/r7RsR1bd9AoP1foKkz7WRb5dj68NA0HEjq2ElrYRJ7DK6HaOiGDp/9bwH2duMNBEe2V8HCEbObRpOM8QCHiXJ2w+kET6sRoG5KaOa6XNkznXvbINluPaKSXanzXoEVchHfYP+UCDDuKj8YkzRFPevzKvWGVxz4Vu8kzQkjzVmNtm1C3X2M1FA0a/uyWu8Dk+8E7gav6YKfx5f/4RE92p7ZUmnuCer+ZdyrnPj89h0TlK1viOqRb2TM7GqT5zXpYpZp2ieh5ZVdglxil0D7B5xJFIPYJR03n5BbVnTDI+nYidxCVokYMUUE+DYqlqSpYOyTVNfaEeWHa+oIHd+N5YP+CknGXdiDf2h+Rauc7HymKgLsa6/qbYdpo6cepZmVK3NbqiavqTiL3RUqYVXL0lVmQO/p01JucVQmkFGaS2bEVaK40zMN4XAm5erQZmWgcLU2dQZOxSNq/NSYGBmRQV/t4b5if57yU5QWRlcxQoJisnPKRVTr2UDVbqeAA58UdOAxkRAAi2W9u4liUSTRJE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(366004)(396003)(346002)(39860400002)(230922051799003)(1800799009)(451199024)(186009)(4326008)(8936002)(6506007)(6486002)(36916002)(6666004)(478600001)(66946007)(41300700001)(66556008)(6512007)(316002)(26005)(6916009)(8676002)(5660300002)(66476007)(38100700002)(2906002)(86362001)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14AHoZM2wnDMoP2j7hXIXF0fPolxh5Wu1VszPsh2OKKPvXYZfNlDumWCQgcX?=
 =?us-ascii?Q?aCmQxkDr88ZjWZNy0uHEjc5VUQ/osQCPxYgj7OyFbyfCJUGfadDlP/0TWWRf?=
 =?us-ascii?Q?iRUEM0V38gH37mrdg8dn/CGOPewZlQsZOmhdFfNGr2qJvSOTPG/GEk2oBsGj?=
 =?us-ascii?Q?IqAu3KclFk8HF77yFoUEV/LXug18BBKHD9ZIAJ2j4NpMHEkadznD4BMkDI5L?=
 =?us-ascii?Q?sgxy6BeEsC7wtoUsokmepV8PCy4Zp1SDjC9asec0oWiVoMVckkJ0hoQG4bvh?=
 =?us-ascii?Q?/IeDIrniWP8Xdw+dWvAn3D8madylyv4w28nE6yyOQWUVsOVB/LUNLOL3J7J6?=
 =?us-ascii?Q?0VuZDl8xQZw2HYDJ78cJSTmYEU//UsLtny+uCt/zvWOIuwgK9PO32x+j1nN9?=
 =?us-ascii?Q?nCkxvsM2OB2UVKQ584T2QEqvsK5/hYUqvmIWmDVzpKr1IxW+s9qBgbamf1ia?=
 =?us-ascii?Q?19NWmY7RVFkSL1GgbvgFElPqDWb2QaSMjOq0Jj7KIwUgQyy5dXuNk6ss0uLu?=
 =?us-ascii?Q?qi2OUzcI4U2xcwlgMD91n+ukZ+L5OBTCkdKng4nvXuOzEUXxaLmZoqVro0s0?=
 =?us-ascii?Q?uXWQHq3N8sKvtqdqWPWmJGjnNHRkT+LC09krA+HlWSFRFYOZkE/1uM328Q6+?=
 =?us-ascii?Q?Psa3Em847p4nUhLZug4Farw/wbyjcnkQpOuudWfapCJGvhfPJE+rLgfEhCKD?=
 =?us-ascii?Q?zVQkGqRRyn0VHlFj5Di9Q0/+RyHbmkhbEz0WQhbLGFaHtwxvfzRmMTJXU10z?=
 =?us-ascii?Q?cnRIzPO2v43GFSIP0nF9JeA4Lo2lltYulEbwCbm04WRq/Q+ThJ7dVKlffx4D?=
 =?us-ascii?Q?rB9OgE1meyoktB1F1amol3ffk9H2qCpifX4Lei5qe1s81DpJYG4zlDSx/kxB?=
 =?us-ascii?Q?veKY/WiNGXkveC6LXajofyAGvHTItp9MlLVplbmTxCzpoNBWxOulvMcH7E3D?=
 =?us-ascii?Q?onr8eOsKcXKHUGJpQ8xoxtdTjT1lH25dPJdLRItscZ4Zg+p66sujoBMD+3m2?=
 =?us-ascii?Q?ig6+45sYENRZRbn2OCuZ+bnF7qV/iSw1Idh0HsjaI5uPcvb7kmprNZFzPj63?=
 =?us-ascii?Q?PSpOhOTNmI59xFEofmMuS3r1+ThJSS6mtjLkGPwpAmG/HHecOTIzsffV7X+t?=
 =?us-ascii?Q?ZobLLdUfp4pT2EkHEVJLznVaahacIbWrEbSfHtX0aJSxuA9cza2jAW1L2C4i?=
 =?us-ascii?Q?eM7/ek52bDM5+Uj+A7ZQFG1E21ebWI4KrgvenOKbCa42SoPBr37z8L0QZ1CE?=
 =?us-ascii?Q?YyHp2eEH7NdrsJmHqbV176VAeCQc9FdEksWgJdHXlQVOtJUKSiypqnQur9Nl?=
 =?us-ascii?Q?l+pSTkjOrvJ8s2H3u6sjzaGenDl0NBGSxiVfkKNyKlcVbPC15JY1wWNyS95u?=
 =?us-ascii?Q?2I4mI0J8wOmBLU81K4GMYqx1NwYx3BVMAhlU2QiWdTLoQ/JObND6OenbxOif?=
 =?us-ascii?Q?xrIIABIfpXMYxLIPNvxtqmdmR1XEzeQlidLnnQm0cykxxfVwvSXadG4syvu/?=
 =?us-ascii?Q?NQLFM2rzRAYyqvh4Uu1IWWBtCSOF13Uj6bNA2lLHr3NonN7AxiCUWUIkMz3Q?=
 =?us-ascii?Q?7egZMYGoth7KUAmsj44LB/xy8c/B5/2J6MJikqV1zSj5/Y61WGrgn2Czv93m?=
 =?us-ascii?Q?2g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AksaVCDgSL9vT+/6T/oUjwY4YVmmtTLhGsHDaNuDXLoGkq/85yVw9VyAxXU7PQfJjurd6p2EWADQFCh8r4F5OkRYgppmHD4cMyQruRvKnJ+GIXtIn9qB0pIFyjXD2fKjPmY9vE5EzdBc84wO5C5pWEXud63ndcP+gNCBTV+gMF2KPy0PUfBncEu1n5QHGc6KbdDfZRxMqTxszSw0UREFK17UWVd8vbs4cqCa5JUaZz60vEC/CEhOx1+OP80dUSsCLbSWrJVBEGkdMvZSZTJN9ZBWUbY2ynKX+Rpa/8CqjzhGCgttuFee/pWtpNoUOkPaEcAyccMaA+H+1P4XkPWPu7cIvmOpyFdstAC6E3GwC/MJPfD+lpmhojgmKN020Sm+uG8MTALJ5Hi1KFT1xFLO7/PqHLQXglmrmobdipUVmf9vIANg6YbspigGmPw+Aw4RoGk+ujA/f0jveY8PrxrNcWV6XhZQ+MNrXoACWD0fNTgVmoQHaqW0GRDXHIBtF245OB5GgWq9OuH03OEJxiSrSpzy+C6oVcJlqI3wHS5qtIurRSSm16SuvoW1kHHvWoZ2JkKmPZxqrMw227hLMgJ7gu8TGSRAUgfeBpBqcpVuOA5E8DbFdk/q+vr+1z2Esc79gBKGLBmfxqTMWAK555GEU2LPb0EdGjierAKaEzaU0ReuEpEudX/fAP9nDcKM+R/pnpKPbT21AmhfOBTsyBBKsga5/tkR9hX3/fFlVZqygawTgGYx9K0gt3w5+F03WqVN86xOtFqcS8szroxqHzRmd+HfVFtJ5tVRbfvnVaEi6og=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7436a5dc-031e-4fe7-b260-08dbbf6c8383
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 15:14:58.7979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+w+VWB8bcEDWvS/BV2Ij6gP7d4RMRTSH3W2lsEzuqUn20iFwJA+K/aRkwMXycDf8PAkEeChy59ZtY+eux/i/CHpkNBxyfKI+M/GtjDY9UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6671
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_09,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=806 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2309270129
X-Proofpoint-GUID: E1LpwlkzD6SPu1e6BhOWxWzXiVoBXcLJ
X-Proofpoint-ORIG-GUID: E1LpwlkzD6SPu1e6BhOWxWzXiVoBXcLJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider these UFS core patches for the next merge window.

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
