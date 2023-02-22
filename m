Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F03C6379F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Feb 2023 01:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBVBq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 20:46:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBVBq1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 20:46:27 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499A632E5A;
        Tue, 21 Feb 2023 17:46:26 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMi3bZ003907;
        Wed, 22 Feb 2023 01:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=bfifxPLvj0YP1aQGzaRaGFo1K1wr2gCibK+Nv1EHOu4=;
 b=zL51IYtddb/VIgd29B9K0uxQIyBYj5Aje4kCmz/05WF6mlrV/bB2QlswxEamI7D2TJPj
 yN5fIq0WUKfGt2iFwoxt14SgQBpBnG7b/qWz8JS1ODsJ/Y3OwTC1DA5hMf+rRybV4zli
 PlLtmxnAHCSG8Sbj6APZG0qACR4uK2vnd0Ef5stbCSsk9aOn7slHmHOcpp58aeqkr6wA
 tOaAkuiZwfuaIeK3uW0CsWZT9JO9yt32t8ePGvOf6ajMIXVjvTI7vSUqHDOoRJuMpCs/
 sio1wyAk6XUIVggYn7BrHgjwHDEjfpc4Ws59eHflFvVueJlJCGr0ZPkPWLz8T8lIHByc AA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9tpsnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:46:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31M0Pb3i012896;
        Wed, 22 Feb 2023 01:46:23 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn4d9322-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Feb 2023 01:46:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiraCKgKXyZIKlJb5OSarVuXPMC9ezV1chV2QOhSqTw96b0LqtskexUQv3EPWoZ9IyvvOHmlxEw+JJD1O/pub7FbkAsyaHdljaXh59L19WgFUWFbxm4nOj5O1QmjihMCRpcleOGHs3PDwOV3CuJz0rZ0p3kE2W6nXYqHa3knNJ8FlC8DBMLw3PHWrdX4KSeVfv1JdZxIB2ERoqZzYg47SAAgUiUy98FxPUuei2iKrtbT5Dqyaa+ZhkjG+IU9tU4XTWybTjX7n6LmWCTQ0luhqeCWIb+FZIVc+0M4a5Z7cvGCofe/w2qS7eI++ZAJ+IInE5casX9BZJoZfszRFeeRTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfifxPLvj0YP1aQGzaRaGFo1K1wr2gCibK+Nv1EHOu4=;
 b=T0uTDvF8pI8gOhzcdn1DXvvcF833ahiwXwjgmEVI770mqO+4L4qroD9nIkgb4/NB5irmCHL6ptLfiNDyzFpqaiP5QRdKCAGEQoTUaQf5MHiNZ1K+qs6CTVUo5a0Tcrt2SrTulB6POUVMgyU1yEPsC8ENyokdVTqDKKM+K+MWRfsTIq46+jolICLeVqKdI6xbqSaMtNwNnAO3WnWrwqVp67PTd8lUdiix7gz2/QjFg42luxI4ORDbJ4NFefato37GOc7qIykyMd+P9AcZGR9WuBb74HMKOVjWHvpUK1D6/6n57OVTiJmItbcIwIDn7gkYYPWvcUQeF5CWAfJf/3YLfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfifxPLvj0YP1aQGzaRaGFo1K1wr2gCibK+Nv1EHOu4=;
 b=QrMqF3qNFQ30FqiLXr5koj8iA1RhxqkR4rsdOiaKwI2nImGf0l6RRtF/Aw+bCCVEoKBIkpbqUdP8Y8b+iY8lv6TXQkvqejhbXpIpGnT20B05lMJgzgpLhEfzRj8QNx0/kXmEllhi186UcZ7fPEGiR1agYDpBt4TpMFrxnVupPCo=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH3PR10MB7393.namprd10.prod.outlook.com (2603:10b6:610:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.17; Wed, 22 Feb
 2023 01:46:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%7]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 01:46:20 +0000
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Steffen Maier" <maier@linux.ibm.com>,
        "Fedor Loshakov" <loshakov@linux.ibm.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: zfcp changes for v6.3
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz62pj7t.fsf@ca-mkp.ca.oracle.com>
References: <cover.1677000450.git.bblock@linux.ibm.com>
Date:   Tue, 21 Feb 2023 20:46:17 -0500
In-Reply-To: <cover.1677000450.git.bblock@linux.ibm.com> (Benjamin Block's
        message of "Tue, 21 Feb 2023 18:55:57 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:208:32f::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH3PR10MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: ecc3f0db-99ef-4fc8-445a-08db14769862
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6fvMJhRTrikwpqU5op/77AOG1RpPKpn6HZTxVPNsIBvhfZcUGObyvC+O4fDix16t4g1EzoPcIUQLb4K2iM5fh36FRi9hDIUblBXWQrgQ+SEk+FS0M5vfCcLYl/mEJ0ek+W3IhQmt+iPDvNteXgwciNPauEl3fbmx7sKQsnEMf89grG0TTTakTswscoIkIvc1omDUAZeHsZZ2Yyr3iQ+CL7/l29KIJI7mqhU44Tp5F4eM/i48U9ZzC65DnMHaNP04iW1lszglcbbZ3xTJ0DnCX4LJRkyCop09CxgfrNTQZPPlPAkf6zsimHm84u5MC8bVdyjyo6dkrghOy7XSkf9nveukHuTzbossmIw1jhfR4iDYRazC35vt+rsAaKpYv/gYhzDQyn2P3gOt3r4evYYt+Vnu/xwGMSIJJQQIgYgX1tpjWMHR3DSlMl8Epakmv3fky5FpJN6CA84uSYgV+/F/rswFthHw5z+Re+7yDE1lmNERCBC/IPLn4SXAZ0h9PbbhhRdZ42f/458Y2jW5KngNWg9j6XuXZNPMD02ToCFc5Yxbxojr9+66ohdjGEA2d04QP1oykohCTo4uLHLDKJMCgQCDTGzkEuWjNwrC/QgGSnKLcSjk8yxspcshuNq4s5KH1nHqije73LDZgHHh7P1zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199018)(36916002)(8936002)(2906002)(86362001)(5660300002)(4744005)(38100700002)(83380400001)(54906003)(4326008)(66476007)(66556008)(8676002)(66946007)(316002)(41300700001)(6512007)(186003)(478600001)(6506007)(6666004)(6916009)(6486002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M4IB+ml6dYJLE+f6KXMRw/Ftn/DdUGtKj49GEHxkUaOLOT5gSEIGG0Az7jbq?=
 =?us-ascii?Q?8nLicqPJJdSU8uwNc0ogVeaRAHxTTdetAVJ/59t6+1gFyaVXm0ooB4LnuqSZ?=
 =?us-ascii?Q?cnv/9mI/mgoC5KGQLZykEI4EBAJagUXcozhaG2fkhuXxwd+tNUxrzGKGdmFR?=
 =?us-ascii?Q?w0AdRDdnMm+xqFGdu3p0tM9dsPHa9KBBXcrLzICVqpxrIINI3t+4oFB1OrP5?=
 =?us-ascii?Q?ENKXqHZpigZSjNaSXHTjQoTigcx+2A4WvZdkYSdB3cpQug1cTRv+d6yZ+euw?=
 =?us-ascii?Q?ctWDh7QsbFWrFngDLcUck1QjFZ1vK839pWoQEjGucw0Iorceg7urvyErrojm?=
 =?us-ascii?Q?uMA3jcmmnKKrmNaUGmP2ISIVtMXkBrg5cZjkUH9e+42TF7vwzj/FbzS5caeZ?=
 =?us-ascii?Q?y/DbPU+0evEbeWUbiH3hVtWmTeA0Ua8D85kEVX4xzSLrRWkZLpuf/5jKATB7?=
 =?us-ascii?Q?pq+VgAMAUro8B5y9FkKj3E5Fy5Va6ER8qCQ3ozoVLlkskIqocYcTmTWs3Kex?=
 =?us-ascii?Q?xZBH3qUZNq3GzR7P5JMPNv5CBcjKsJnIek734Vd9Qa3L9d8jtXfMQCaOvAju?=
 =?us-ascii?Q?r1GMUus5ycLC29qkMcdJmI4wYC2AkvhINHMGNalP28LOTRu+7nnpsbeQXAme?=
 =?us-ascii?Q?Z5/ezxCx3zZ2+l6zZFDuok5Yr+nBDDXYXsWMuZMBo6pEt+5B5azZvUflQk8O?=
 =?us-ascii?Q?wkBpl9RQFK95ckqRe8u6+NbLLQbsW+bGVD7hQPAsYZaimm4m7h8DUgl6ZEad?=
 =?us-ascii?Q?o7uu9Ss//TpSuvblMQ798VCpbEpNmyUywuyHwbAFzFHVymBCqI+0dd2Tq4lQ?=
 =?us-ascii?Q?7x0FK5Tv8xjJ5ONoTWB8KwhPZbnA2J+he+gFq0GqIEEUXT68UTQ25v9650Zh?=
 =?us-ascii?Q?pyoc+41hsqCQ3LkR5MT7JucJs2guEgZbech4cJwy5fEAjzAh3jd7EkPd9QzH?=
 =?us-ascii?Q?zsZ643Hcf+I0XzF/QERw5fiMZQJ7AoeLIBu43fQRoDYkvERcV11372Mjk+rq?=
 =?us-ascii?Q?TP+I1ZhsAnKDxUbDCefhOqgaWyBs8d+eeYm2rubNEs032PjERUavMetR+f48?=
 =?us-ascii?Q?opCgTbRBNDbxqrKNcYQFeJkEw3qW6Kp8Czvm/eHtrCweZmtpfsYpN/N2fRbp?=
 =?us-ascii?Q?nO5PtVKRMxj3K1kfL7sDd/fmXN2Xws5oBOF22P+hzwDG4+xvJZEyPdygLIP/?=
 =?us-ascii?Q?dCm6WcUBnxZ1HFXMBUHFwSMlyGlBq0eBKkhtWSYUoTb0c8v5gRwiR3MP1qxn?=
 =?us-ascii?Q?BK4+K0y14GDi1q5keiZW2blY/y5BTjSYGRS0W6JbXeHuL6e1UK3DICMRE5Xj?=
 =?us-ascii?Q?feQg5XJzmSl3KfXaZwbEo581Rsir9ys+pXbftW8jIbyZexNxUhAUHKp2d3qG?=
 =?us-ascii?Q?86UvNQpEtPK8RRWyvvIErGT+tOSaC4fyDFvnDz1GNkIk/2Bsni0bz+HHA/Io?=
 =?us-ascii?Q?999pk0WMmiG4EYBLn7h+p/G0fUvH5q1cfDTqlSh1IYkOdMmU6OLEX/suYmJ9?=
 =?us-ascii?Q?Y18ltILAoP7+aFnBaYCo91NTZAAB3Q5HmXaQr+HmHoQb2hgBKkIqgdRCoGOO?=
 =?us-ascii?Q?Rip+gw1TvHQGgUcsqsa7PRAtsnmAPuE1LZADUnRE9atMz6foaTh7n5EcGE4/?=
 =?us-ascii?Q?xg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Hh6bunyBbgDa8TdnJKritaWx59gJ3iHkBA7q5ElvmnBPzWRG/0JKuCFXgFWWy9Vtrc5Pf6/8gVrQB7ZTxTetzJ5D48POVHEqHCUICao/tqyaJoxjCRMUSUwQGL5faiVaPrY0h5v0DXmbDKtURyj9M1Q2at7KYV1YwphO7ek92SXzHub5+GIyuk0ncGBMK8VMQ3fkRK7JzM+dEoTrv+AGHNAMTtoXfEuE3PLhlIeRto7R5TxTAgxnnIk0dx0LTHqv/QNagAmszSKzsbmJFg4d0H0dVUSAiA+p1sQ+r6hGsnVNs9V6VuJI01hPE2mLcJ7aPRCC7Jaef+v3X61AcE13eZ/xP9LlTbT3RvHO8765O60QRP9GIBUHvnlYVnzT0ft+451quBH059Uk/rif5CxrhiZ6CtwFiChUgP32DJhU0cPOwwncy9lRnib/boTQSfnHCPOqxV20CaUapk4mdXxKsIEoJAsKhcNEvaDQ/C/wAreocnZbqf3Bva/zCqg8jxNJ/3W0r94S8jHdb6uQ6pfj5AgwhGgKKK1qcpOeGtVwbCl+Oh7ebOP5UfS8/sAOKCd7GLxUUGJF4N6LzsWduqeMcDIWaXL72ReViiAecAR0pSTNjcAuljNo/hXO0W9SQxMmHZCZlqVyaOQOYGwIpOdNY52gyot8lwnCFjfptcBgov1KgdjAf44poMK0OKvRNgiU2E15e2tqfLcYge/UdRjG9YU6HhU+xCDm3oj6tO3JHIGe+zLef5oDVwSG3tlTfdkIb7Q0pyFKYTgrrx+qmommg88DM4Em3oCAVkfpGV1LBC4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc3f0db-99ef-4fc8-445a-08db14769862
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 01:46:20.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0V7rjFR/hFPYlodAM5wfxUYEcmtJ9/vTloo7ur+dU6hOGD102t7yo4tx/HxG2IWkhz27eaDjzLRl9iZhukgxQgKeuo3INZK9NQfDcgbMEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_14,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=972 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302220009
X-Proofpoint-GUID: ALT7gPcgq5ZUdWD2U52E6CPNa2dqflpx
X-Proofpoint-ORIG-GUID: ALT7gPcgq5ZUdWD2U52E6CPNa2dqflpx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Benjamin,

> here is a small set of changes for the zFCP device driver. These are
> basically follow-up changes I made after the fix I send in
> <979f6e6019d15f91ba56182f1aaf68d61bf37fc6.1668595505.git.bblock@linux.ibm.com>
> that refactor some related areas in the driver, and add some
> additional tracing if we ever should run into a similar situation
> somehow.
>
> It would be nice, if you could still include them for v6.3. Not sure if
> I'm too late already.

It's a bit late. I merged them to 6.3/scsi-staging for now but may defer
to 6.4 depending on how busy the various code checking robots are.

-- 
Martin K. Petersen	Oracle Linux Engineering
