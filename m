Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2497DC38159
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Jan 2023 00:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjASAPE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 19:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjASAPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 19:15:02 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5008451430
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2023 16:14:58 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30ILmt6j003547;
        Thu, 19 Jan 2023 00:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=BR/LWn+haQvkmOkle8Xs/5LVXkxruCEZhtAoajpj0v4=;
 b=0ug1iDC4JrxFohfaLit1OicDkbYt3x8sdATfhrmdy8OB5hIikSKxONp30x1ZE/c2redv
 FWj+vIXVRvYDcREAh1O3ALju+PTJp76xQQOn0/hy2li2rJDiJvRk7R1kfte3udSqrVQF
 HWdb/QZVsUxnNw6ECrG1mKqYNRb0/kgOzI835ZPqJXXPcqSuNEqUbGvQnNYsg7IGD1qM
 tMNOAz8S3dXo3UPtoSdXoEQl0inrM1KR59OlWCvFrs+8UQCcCOM+9SxQvVXMVAsiKISD
 F3O9VkjKIA14IzC58H3D0bFx7cJw7TGmS0V50+zgHG7fUouJqHZaoFWMCCCBHOLiYVuL pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3k011200-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:06:14 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30ILxFgN029155;
        Thu, 19 Jan 2023 00:06:13 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n6qufxk22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 00:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4P32KmZyEOfu78S1+WMXEKIiuii8IWOdp9wp5hF+ncC8V1Vjf901CcaZlflrwhkaA9cuvy+r4k4AGwhi8D/XPcjr/PsxZHn88Q1itJhdaJnsARMoaf0VOz/LEL81cNA/1P0BxAXqUH2rjcu0Zc8puUmnTPgOx7l9GONGW3z15MmSsY10vCLFauWDLtV2Br4z6RrxrzVJIDH53aODmK+0XqS3oPPjWSF4zoxxBbMGCGBLVUXtDb17rGXs7IJ/wDGzB+1S+RluvOUQJmZf3Rejy2X7ljopMBm1413xBJxbv96pMziag3nuaHWnPk8ANvjDLtFIbiXsohl3JK4ZYQIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BR/LWn+haQvkmOkle8Xs/5LVXkxruCEZhtAoajpj0v4=;
 b=FIAaE/1aO8IB09V3132utjH9hng0eZF0tdZa/XWZNkjh35/bUz6Ai6J1LVMzSqThk3223ue+kC35aIkPKBpjCUFF/mFsOPiH29LVQda8jNCrmEQxvinIpiJja9KULBVm96aITZqY8UaCgGOE5ED1yLfCfhj5hH35svHKbEuoeLayjFkCh3uSB2eWY8M8D8uU0mMXZ+/dPcdr///RoGx2ed8gTGwh6tiZHRtQELvteiyfaClr19YQIq9OlpMJM+9vpUCbGSG1HEPq490rCcaFnCDJwuPVIgv77G/go9tGDM9v7IWgkbyLrg4CMqvFF9TNXshm4HyQpYNNV6iatSG/SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BR/LWn+haQvkmOkle8Xs/5LVXkxruCEZhtAoajpj0v4=;
 b=a2baLjaru6h4yh9u61F/935Br84A90BJFnxpVByws2FRLacK/E8E3xZ/nKxcJnHBnQHVLxRHY+KwVULOHf1ZyZgLiUEOC99LpUf/fwxrwGdnnB601eFsIdEUb9us55o4z/VH4ovLXA8U6neiZnnyDOfdPUyIkl5Poe17AaijiI8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4237.namprd10.prod.outlook.com (2603:10b6:208:1dc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 19 Jan
 2023 00:06:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 00:06:11 +0000
To:     "Alexey V. Vissarionov" <gremlin@altlinux.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: hpsa: fix allocation size for scsi_host_alloc()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lelzo0kt.fsf@ca-mkp.ca.oracle.com>
References: <20230116133140.GB8107@altlinux.org>
        <39006233-ff6f-82ad-b772-e00e789375a5@acm.org>
        <20230117095644.GA12547@altlinux.org>
        <30d3e555-4fb0-23df-abeb-e1c3dc41543e@ispras.ru>
        <20230117211201.GD15213@altlinux.org>
        <531f3f82-712c-eb0b-d22d-710e8a36b3c2@acm.org>
        <20230118031255.GE15213@altlinux.org>
Date:   Wed, 18 Jan 2023 19:06:09 -0500
In-Reply-To: <20230118031255.GE15213@altlinux.org> (Alexey V. Vissarionov's
        message of "Wed, 18 Jan 2023 06:12:55 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:806:120::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a28dd7f-3079-4359-8aec-08daf9b0f8e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rVNF8puyEQV1jt409b6Gor7mBKh/37YZG+bdvUurAYN506Fn6i3yD5UzFlAH/lFTai46IIM+LnIC9mKJFWUI6mYBPOnzxXB6P+E7rGYsu8Zs6BfQH/ICuSKYYTCXX6bcSTFqpooZQDkzWO3PuzGUbnbJO/246yJDx43A4juKTBGSsqJXUIQIohSKvE1mZpNkrvznnmzj6r9FhPkjetHuAwhPRhN/kYTbF4jpvPi4dpBFG96EYRsqwCeRB6NkUdEfBu9uc5WNv2qMQFOOdoSyN9GGai38vugczDyVrknd9SYi0ijurtQWlyCdrw6gFuWqjjakV6ptq3I7ehRFID4O9+7drOvCz02k110RkbekiKnTdnfWy6Yep9fmi0zXzyleV8QBDqbiqPvlIglKK4A/55jrYZOl0lrpM5c6GkxhbptmAug7LwKo9q2qLxHPzl3Pn1RbwPCL/0jUe5TugJg3RCwFSKWN6KeQC4j9cThvtFpbwjYfzvFUw44L8ZepY6/pRxF/3TIrDhSmj2yMCJNUtdDOJ6VP6Yo3XYKQ1LSh2pFNCAWMGInmwPaszKhVKB8AjIqoTTa/gqvRpDTKSPnpyPuqyVcybH6fF1zTxGoBDm2lRdPpcauPk2vovWFV9amw+S5T8ivs5BxL6XIIRyFBNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(136003)(346002)(396003)(451199015)(36916002)(316002)(83380400001)(6486002)(54906003)(38100700002)(478600001)(86362001)(26005)(4744005)(186003)(6506007)(53546011)(6512007)(2906002)(4326008)(6916009)(5660300002)(8676002)(8936002)(66476007)(66556008)(66946007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z/wUoQU8LScCdOb/19pGd5fFWzMCtuJpP+2uUvpNhzStoXrdixoHIcAtF/Fg?=
 =?us-ascii?Q?L0DYu09qH3cXY24bD/aNCgOVELLDEnBN8ppHy6ky7lE+gM95zYiT9e7zvhUe?=
 =?us-ascii?Q?OPXqYcas4RWJM5CTY4gMSeDHFQLMA7DRYWlYG1Of7wWehSzJ5t+EVoAwNNw6?=
 =?us-ascii?Q?POrxItkmCQcV1ZS5+M8QWW9jwmZyvlzOtphYgu3hVQLBLIkup/a8I0YqO9US?=
 =?us-ascii?Q?S6Udj0Qm0+04KIfXnFG5TLuVglUTiXn6Gsh+0x6p29AcjhdktgmK1Rhw913G?=
 =?us-ascii?Q?J2avldbHD72vfpAM+tjW+QbQGjvxxQY454bMKH5JvLCDJuelD69Zt1crPC5K?=
 =?us-ascii?Q?tX4Kd7zxIcoaiXAZTlF1VQjVXa35Glwxj6tS2YPz8CCVB3onTERGLa2zIFOi?=
 =?us-ascii?Q?zdO8fGXM3bO+lKEPTl1HbAlOWWBzarYO3Ede1DhBC3So/ydYXHL9zZBXHUsF?=
 =?us-ascii?Q?A/AblWr+fZHGlRpI6b2lChR/sEnTVXYoe61PEGkjoCJbC6r4jcLkSy4aZFXE?=
 =?us-ascii?Q?U6mCCsMJyYF0jpRqZc61AjNVbnbc1NJV1pvS1E/srV2xstxyWxV/mRihr7zB?=
 =?us-ascii?Q?7a4V9eh9Azfrbdcm5a7DmyScSWGhIJOSEeubNf8ARTepcdKnBPf+ALaLyet9?=
 =?us-ascii?Q?MxplNZgEWlR6mInXKfyrAdIqYZ8rI4/YxR0oYQogQqe+Q7WuGZkjETotKn4y?=
 =?us-ascii?Q?zFOIcRDaZU+BNMB60+4fJrSP5NbKG8aEX7m/LoIvIYkAe7jsmQEHxFVQqBVu?=
 =?us-ascii?Q?wbEQJ8krVGRsqDTa6ABlaxcwbNXJXvGmfk7Lf8FGAVA9tGv87Ef5t9KcrXC/?=
 =?us-ascii?Q?kq1Q2q5vlcRKbeklrN9SC9Ra7TaHqaj1YO6GtVxeBxgOTj7WyC+oUPcpgKr+?=
 =?us-ascii?Q?75LyFtBco6QIZRbJcuX28MdhYxcbds4YyAXr+60cCr2lKWLdgaGChE2zQqiM?=
 =?us-ascii?Q?7YLqcIlNjtpYlLa9sEE0IXQshRe1ZKtTfG9Sk3a+KTN/ixLnIw0ZH2QMenRG?=
 =?us-ascii?Q?DzsW0u899MmcKmCKlCdrtXfuyLEidRz5ETfDuor0DDhlj6zfeXnQnmOR+1P+?=
 =?us-ascii?Q?H4IWQAe04U35NJLa9RVa9dhCDYqhS1h7bqLWpJ/nHMrG46WP6gAN6muDPDcq?=
 =?us-ascii?Q?fVTaWP2mQPnrI3ID1kja98jPPSTvtxOrXNKtBaqDOCbfEhxzrI4Rsf2L5Yip?=
 =?us-ascii?Q?s9xzwVSj651kkHL3xWvWjaignPBzSyCrg+xrkiKBZR9LBt5BOePMqD1mDTX0?=
 =?us-ascii?Q?Q1Y5VEzl+n9e9o/6djxuDaeXS1jTEYhoBePUoxZEgC5OAK0xGkIxvA9e1EWb?=
 =?us-ascii?Q?je3WOlxCZcJaRVvqLfFXXkKv6ami+2igXlOA4dCptAS+F6+pQgB0SyyolcX2?=
 =?us-ascii?Q?+ecC/thoojYhcj9Un9uvdcpqVnh9UbonPF5EeLhzs9NgYs9u3+eU24PiTJUb?=
 =?us-ascii?Q?zZaEHdyZ5IK1yPj7qPR70+Y1kQIag5d9KNC9o/LHcfEq1pE8z+GrKiCTbANq?=
 =?us-ascii?Q?NELD/fXmfSSjvUb6xTJiW8SQfUOOPRhenOQOMaWZSiNVBPLybtaY1/hazYnn?=
 =?us-ascii?Q?sXiI/Gt3K7YvzdyR3PB8t2xiURC4+vQEaAsznvqMwWirEF17IswStghvS1jk?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?HaVB3UXjqJAa5V7yV79+DTg3otDKAKTMeA197bm6jRqPuxD7ZTqPgEoLSqLz?=
 =?us-ascii?Q?dWZlYfz4LQjX91JpbJHNHtsPDd6iQYUu0AYrD6ihIgF2Zr4EVojTa1sy6FSD?=
 =?us-ascii?Q?6GE/sdLMypGLftgXFTOHq9NxukBTncl099N5ZVD6tsPn0gJ5SIYVocX9CHBa?=
 =?us-ascii?Q?clrCpkf5KeFU+OoDtC95whAQcuc2iVpbqJQGefnaOducVxEwfUt5SJb+RYt/?=
 =?us-ascii?Q?sFqjx4pG2k9Hbj5GvCBj0kHxFlBf7ygo5AP+DCD81Bn7VqpIF7dvZTmKT5sC?=
 =?us-ascii?Q?9799zu7xIWfpvtS94/hh64yWU/8Q2BSAeNq1AVrR+4sfQsPtKfExYbKsXkeN?=
 =?us-ascii?Q?MmoT72R4bIqxZj4tQnlcm52cQ+oLX8yvl8H0xsMMaykhWGH5DUDugVlzM4qo?=
 =?us-ascii?Q?c0ErWMOZZXSB2w7o5FDmYdov5Eby2j/VDo+y9WjYZ959319XDlFHdo0eJBVP?=
 =?us-ascii?Q?qlPJodFZdV5s5td7r2jQb2nk2LVLK8OqKhwL+XV67vUWMIsAybe0AiEA8IzZ?=
 =?us-ascii?Q?jPBZM9aVae/wUzgPCqZHLuWagQ3xIXAdpxy2dfc0o8jGVWLIegO3A7ZCFZO1?=
 =?us-ascii?Q?RsR9SFgn5IsDrwUcJqz/2HzjJ36aaRcARNSxVXiqhWLtkNnaB27lb+F/U9Tv?=
 =?us-ascii?Q?WEVnjMbQHXr6eWnovPnmiLCLwjCgNRraBLOVIc7JLoHo1G4Ugm0eK+F2I5vN?=
 =?us-ascii?Q?a1CgLPvF8zhXqtcO8i/JDplcsa9SmamgN+rqhTwcp9vnnxfKykTQN5azqwPz?=
 =?us-ascii?Q?wSXeB94S1GSK5lc4I562IlrOghaBXDLM5nSsFUR7lmC0Vo29l3Vkej6xACA+?=
 =?us-ascii?Q?nPmyhNlzwornL23niFi/+rciIXU7aMf3Lj8ka616ivjfX45sWvLGPx0mj59x?=
 =?us-ascii?Q?bP6Z0/F5SZqj+iMEPcKVIMir9auMM5sXkjbdUQQzovGvpARrpUguiNokCbWL?=
 =?us-ascii?Q?h8Fpt4v74ZU7Qp5I1pfKMe+1NnHHTXpNZo7bsfeArBBpgYJa3O1gSUntoeKr?=
 =?us-ascii?Q?ys2/9BN/X0tGyoYzw0tTjBPmFQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a28dd7f-3079-4359-8aec-08daf9b0f8e9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 00:06:11.4930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyUedHdph1rzk1kCKeWBF0HqaQWhkjAaUwmst8yVNinWoBpNpJHnNa7js5ntcTekS6s5V09gFp+lG3+dz+kjKNtpxA30cY5KtTuDKu9q4fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4237
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=770 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180200
X-Proofpoint-GUID: fNhtcerwxqMY6P7oy6evnONfGYlwXPSa
X-Proofpoint-ORIG-GUID: fNhtcerwxqMY6P7oy6evnONfGYlwXPSa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Alexey,

Next time please use -v2 instead of replying when you post a version 2
of a patch.

> On 2023-01-17 13:23:19 -0800, Bart Van Assche wrote:
>
>  > My understanding is that you used an incorrect commit hash.
>  > Hence, it is up to you to fix the commit hash.
>
> ACK. Resending:

Comments such as this ACK must go below a '---' separator to avoid
ending up in the commit log.

And finally, the updated commit hash now no longer matches the commit
description:

> Fixes: edd163687ea5 ("[SCSI] hpsa: combine hpsa_scsi_detect and hpsa_register_scsi")

$ git log --oneline edd163687ea5 -1
edd163687ea5 [SCSI] hpsa: add driver for HP Smart Array controllers.

I fixed these up and applied to 6.2/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
