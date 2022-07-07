Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 046FEC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 20:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiGGUmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 16:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiGGUms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 16:42:48 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63E51FCE3;
        Thu,  7 Jul 2022 13:42:47 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 267KCQsp003643;
        Thu, 7 Jul 2022 20:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=MsExKnRmdDXManyAY+uD/rAHZWqJ+l3juCQNyFd1Xlo=;
 b=OQtJ672pLa5dNVjJU3pbFC4zDPCBWbGEXYJI8JmLc3+bWUkQTaPOWlz1gwHTkhSne+16
 kEYB4T5Rgn9QUTuxHlgFb3DRaz5PWw65akDLJNs6+rVt8IFqpgcqNf5MMeEiic44o+1P
 1JX7LCHbPzuQ2JmXCU9/oDbNLchXHzozVUxMQoY3zVeP4sUfIaempr3n0Z11Jpx8D1LR
 j0KXsDqKet0ai0SAAw12DPeht6hqM6JysJKXroRAxxzk18xByFpV9Dy+MF/YgqAer3oj
 hvXF9uBTw2ovHfOfHJD9FMpMwqUyB5WiWiBL3x4qnTu1Dp/XBJ2sHR39FdqCppLcrH+s CA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h4ubye36m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:42:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 267KVvUH011956;
        Thu, 7 Jul 2022 20:42:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h4ud99cr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 07 Jul 2022 20:42:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O2+A6KiJ2bXGL09tFmAwLCL6N6KLjmRMV4coDryM+qgdApTkDmsq4J9tpqoLblCzTBieKG1bYUwt2hMF5UehqJXY0xpWFtFWllTUvidpdMjanPklp4RKBHiq5PHQrptGucMaYlbjKIWgKVPyh6S+47RzADaFsW1C1zdf9r/neU6LttMLeQNMngawXh0e47bfK1/qhBKDkuIu9SUK9LjwGdUv8mlO+P661Kz8z/0AEeka1+0pu2+pp+3snn+MrXGXQlfdftNC/ougCkSDOQg2u/OG6JwtOMLsZLEnp5nxXUllCkPHZ1LHh1rlcdqOejhVFFR+PWiEtNktwzYX5bNrUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsExKnRmdDXManyAY+uD/rAHZWqJ+l3juCQNyFd1Xlo=;
 b=FtTnXO0XHETN/GPgh7H1s/QchvPlmuPC5dnUt4ojQFbTHSpQ/5YbNFiOKGur7gPnV7l9HjCxHzEpHVCPy3OPWoSkF1OVihpPzlgVN/32E/rZwhD0JeX+eeiRK7Pqg2owTXnhW6yIcRLVS5nd5IUQgYokoclRSJURjXnxKEpuvqS/Y8EqqANu84Hv1MBpSphP/WnP4gjxuaIbA8waXIbNd4muIuDXboaym/XUZcPMxb3bKBysOdTCOE9SRWx76IYI0/dBKc/Wwh/DdBjV2jC3NO8x1x2TVJpJpSFpmbEhI802Ay2dtA3ruCRQ5ZCaTZ460cRLFZtPlNWma3193TQiCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsExKnRmdDXManyAY+uD/rAHZWqJ+l3juCQNyFd1Xlo=;
 b=X1e/Hhe+a/HU301yySbCiG4xY71YS8YlWv52BR5IE67DIVaiJShHhFhrHe2ApmuC2mrXiysw8usIPqebw4A0fFxY6SRQDiuCx95hAzYILeNfIqG6UcCmZNt4jHFcG6GfR6zQKiaRhrVWxL/7c+SiWTUQodfdZ/1ZutGH81nbNdw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY4PR10MB1574.namprd10.prod.outlook.com (2603:10b6:903:2f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.16; Thu, 7 Jul
 2022 20:42:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::6516:e908:d2bd:ca45%6]) with mapi id 15.20.5395.022; Thu, 7 Jul 2022
 20:42:40 +0000
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: target: Fix WRITE_SAME No Data Buffer crash
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtdk7j59.fsf@ca-mkp.ca.oracle.com>
References: <20220628022325.14627-1-michael.christie@oracle.com>
        <20220628022325.14627-2-michael.christie@oracle.com>
        <YrqJhyzhjaEkTJL/@infradead.org>
Date:   Thu, 07 Jul 2022 16:42:36 -0400
In-Reply-To: <YrqJhyzhjaEkTJL/@infradead.org> (Christoph Hellwig's message of
        "Mon, 27 Jun 2022 21:54:31 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:806:120::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff0e66f6-c305-4741-c789-08da60593bd1
X-MS-TrafficTypeDiagnostic: CY4PR10MB1574:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xk3zjqO744s5EmTUeh/h/r1vBfinAXBcyZeF+2ti+jgH86DVqSfhNgg9zsasY8AZOlngCNYewYp00oBLR2RuqrQuvXkBE731NHSw9/q+52X0jGKJMEDhP7zqYc6JyGW5azvPvXMvsy3L8/6XA5ciZJsmuaS1r0Xuf24ecqi2c58oChAgm5rubdvmTsUgBlxAe/Y1zsmDCoHVFLPAtNuJM/IJtyun/EoF25xwuMf6U/66h+iokeacpxAj2KPwR3llmTayfUVJr9k+KFU7AzYZgAa/lsc6M+ufcruItCt43qAn2sK2YQQYnsZvzVEsEN6AEt5tMVHI0w9B5XUHf9aIs+dm3Tv2ZkoAHf5Vn2sIGJP9Px8YNkBfPpxhAT/Ptt7ZGkuaP1+cul1GLuJIx9zJK5DYC0rpH3rTWql6muTxPi7nNFGXCo6FTmCBXu60G1Wf8Hl29+FMUL+kalhCWrqVbi+pyHlOI92CzjCIyad4kiDSxTQ0GA4TXk3AqsHlHtWt4+hQFCFlqNxFxq1ZtOCtTZMeJz+wXiOtojBc1GeGUFfWSHWgRA0Ytobkd8rC7dUV13J30OThy+ga2ETkC2GNQj0I4QRNLOeq3mEwNdyDif1X2gYbIePr98vqXa7r/K1GocJmaaQB4rTbinxN2uEhd4fynqlhNBjedpEKV00I5rDU6p5RIG/pDsa5pJZo11y2aEBeHpkz498Z/3lTFZE2octhUg64RrLD3FRt/Su4wlPuwFowa5PtJ8oXBaBeYIaPt5iOzV4mkTDmIo6TVBM8I6GO61d/J3r9I1AUaSIfwkbQfu3egQ2O5QYTBHTF8/tA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(376002)(39860400002)(366004)(136003)(66946007)(66556008)(66476007)(8676002)(316002)(4326008)(4744005)(6506007)(38350700002)(38100700002)(52116002)(6916009)(6486002)(86362001)(478600001)(36916002)(8936002)(5660300002)(41300700001)(26005)(2906002)(6512007)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bpXAc2PRVF9QmvoYeGcELOqSvB3GWrxQG4IkMx9zEWyPWj1kxbv8SWfFyVJw?=
 =?us-ascii?Q?lgOXFodvI8gbVpItYF04Z1Kl+ymJo6t2HAxEVCXm43KPbO/5lsIMjxw2+FOy?=
 =?us-ascii?Q?pqoZkHxw4zuR8++4MHWror+QrchkY5dCHCPAtZYAEnQvmvEngNv+P6YWqbWa?=
 =?us-ascii?Q?nagQbJfrOGActAsAMKM9hA8hrMq8+bOSdcfSuNBstuLqxhTNkEvvlaKizAjE?=
 =?us-ascii?Q?IY+IT5bxQQ+ZWod7cYdgs3EGrAo3wMHCqfrz87Z6a5pIiLJPs55c4Uu3u0Ba?=
 =?us-ascii?Q?QOxKnVZp43qy/0fmBGuE/kMMnPm/yKFE7xYlJcWhorB4sictsfctebmOX/b3?=
 =?us-ascii?Q?R1/5JjQK5pxYb2xe1WYtFRkTr6sUsz78nh3fnErjLgUcYVFW0nESv4vaIycu?=
 =?us-ascii?Q?TnHbjGg3Z59ezsZ9iOBDR3IXLtW8NEff5B5I/UQ6ISKeslPr0wpJ/67COgOa?=
 =?us-ascii?Q?IaUpT7jmrdYgzj+CbZwAslaW8Hr3GClo3PKhVZMsn8Wi3zEDo9zUsZdDw8EI?=
 =?us-ascii?Q?VqS0b8fRn26DMWKm2VY0q84gdWG+NDEYoSJ/DJbvAkB6HanyE78Zquz5F1U1?=
 =?us-ascii?Q?BA07OByrjHYJE3Ug0AmeZtOna1vPyxrpn2bAlS3sLdHxUAimp3GNloHQTlUf?=
 =?us-ascii?Q?6h+otiy5gY5GAGS+W10R22IE1J4BxG/CEVqprMJP5voaZTg3TSaIH8YJwFuQ?=
 =?us-ascii?Q?t792BUJyTd1sxHJt0+mCLHMTTrH7X2lO9aGs7qIUu7JmDGO1TxU3+HUYNUEk?=
 =?us-ascii?Q?QtWrOjPa20PowuMXFj5aDuEVlBWyziv3qaIGGgKQtz3YqQuT5FN3AHBGdW5x?=
 =?us-ascii?Q?SobfmcU12DohSB4WCeufdIPK6EAZMlcGYaGZGxc15c+E2yPwPV7ttoETFMnw?=
 =?us-ascii?Q?iSluSNrDW58EIwbcWhkdXP2gdPat94MNZhbOeOOx0n9cWLsTMXNuLPnDCOpK?=
 =?us-ascii?Q?Nx/PipGKX4OGZuasjfDQ5Pwuqnds40WZFa/4PMM2AfGkwCisrI7GHJdDhzdH?=
 =?us-ascii?Q?GJaw17MbG7cb69fFuPsPaUIqAJilrb2+FHHgd1ghV/sOlgZEAVtOeDoX37SQ?=
 =?us-ascii?Q?H2gWhxLG5dRSIjYotuOn75tr8vvTQJpdum/6ojbZ8+rgEcrr2yl0cJOufmFW?=
 =?us-ascii?Q?BQw7PT+HHekVOKlToHEuN7MKpcJRjGQDP39kI4cJ5Wqxry0yF7hQ/zvTQrRy?=
 =?us-ascii?Q?2LrTh+Yz5Y/4xzWtjwA1xABCB8f2NfTFOV93cwSHaUDmGg9SOCRfgOVV+RcH?=
 =?us-ascii?Q?iSh3XSUKkj7eBYJVjHCF2w3suQO6utzM1l3AO//NBldmR9IazAfUyZNhoiRR?=
 =?us-ascii?Q?KRj/cu95sG4yuBbmPUKGuMSRPtQMSSqyegpMVdd7JP0qEYM4el72q1BZW871?=
 =?us-ascii?Q?FcBrth1R4bNaJLu9+/J0dJ4qo8ToqwKEacN68MwTvTyB2fUl2XOe+7M1PLVB?=
 =?us-ascii?Q?8nRY+rg5wsGa8RazTq6C0Am7rpKbRjsadkNPMQIZGiv7AblqmxvwKLkiQwvc?=
 =?us-ascii?Q?EDYJdedWzt1sJFePf9aK3CjRhVGBYGUR6G3AcN2+8W5iCopL7YOx6XDR8FS8?=
 =?us-ascii?Q?rNJtiF6Y6i85Ul21p5TACTjoS2hTa/pQAB+aQvhTl/S3QTfelHU6IZ9ylYHA?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff0e66f6-c305-4741-c789-08da60593bd1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2022 20:42:40.1430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TX8NOXWivM/NzJXvu7s0sPLyyUjxKdz6QvxTU3IzWVXBY4NDF62ss/C/OamRYwkq4BfSTVI5BSMMT2VFwwguW6gt0zthx3HcC1aK7aJMxiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1574
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-07_17:2022-06-28,2022-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=981
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207070082
X-Proofpoint-GUID: lKRgNnG74o2rGR62Qcxkf-Na-vT0ov-O
X-Proofpoint-ORIG-GUID: lKRgNnG74o2rGR62Qcxkf-Na-vT0ov-O
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> (and I wonder if we have similar problems with other commands, the
> target code could use same targeted fuzzing..)

Yeah.

The USB gadget series implements initial support for RSOC. It might be
worth entertaining to augment that code with CDB masks for all the
commands we actually support. And then leverage these masks for command
validation.

-- 
Martin K. Petersen	Oracle Linux Engineering
