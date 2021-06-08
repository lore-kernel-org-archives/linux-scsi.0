Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAEA1C47095
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAB1461208
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 02:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhFHCZM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 22:25:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49978 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230209AbhFHCZL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 22:25:11 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1582Gcl4026651;
        Tue, 8 Jun 2021 02:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=0K33CaRBeqO+dIwY6c6A5e4lymy6g3PMKqKpAUunO0o=;
 b=xXH71itr94HSQvuLfRYlQnohctuej6vEGaczR1C5G7MB4hbO5jAaf6OeXIEkO7YW8lwV
 I+acTwpphU0T8nxhyt1lTWqLToak4sY/aHTV1nAnk+sDJgntstVBfZj0BcMECx52J35z
 RKrAZ7aOdphtNFeImPneoj//V5irWRVEoQhELdPjNmGQOXsmKMaqiiOQN0FPDXYshTLA
 /yFHSgiW108IlTFk39dT+M5pcdmUjdlDl4CRDPcY32q5Cu0oLFCQ/RGLmi80x0AOQ6RC
 Uk6EfO5doxgTysijWjzpbnK9ASCXMGhKsuUqkPINUTcgce4YctjyJhwbofdKThKR1Ery rw== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3917pwgffn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:23:14 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1582KuDM163889;
        Tue, 8 Jun 2021 02:23:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3020.oracle.com with ESMTP id 391ujwf3ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 02:23:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SzQnyysh+mpAV/CtBHLQkfEKatgj2v9y+2QF2sPKSyn6oiuTrGvY8sHary4NSpnSO0Uc50wM55G7iipMXugn6NZ4KYUbtD8PsF1WdQuNYR06ljBMYuvRtPfmor2wWPwaJjRCaHlmoqAdd4hVrvpF33WscIQi34DUDq/Tlwh59KEhzF9Z4X3MokHxVMNby5oUUDwKAwrDCUTtar0xv7YEix/hGSf0S9Sm/aYQ0aPMbA83ZWgdn7R81KEr6al2+wPmS0Bja3DLLs5DC76SI772lPs4b0C8WyFa2UszcIxGZHdpObj8A3V6vHn67PDJMPih1xqw7PvHlno9wNQU9lUdjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K33CaRBeqO+dIwY6c6A5e4lymy6g3PMKqKpAUunO0o=;
 b=cO7bxWbKoJaXifO/+bbnGu6RrjfYm6AhwKPiFamoQOSiFkNNyGyl5xFU8iNJro+x32bPSvxmzP6uwQcIq1YJmdYCJtunVa+wDdRpAVM9bcvlKCge+wmuXaSX4ngD68qcq4q2QDXzRGgPD4FN9yV//NMN5Oupd7kKRASpYH9D2eWexVo9rkIxTXJs9I0oA8o5nqlETr99aJgSjg/okFtlIEciqRO6SX4A7/ItxTZFb5aVeFd5rG4HXJJtlMg15/bGVSs5DEsLOCsYKaRzPjyup7xDvzwmC1gWKzT2XZ9Kl0zjrFw6kOn1kEVX2nXloPjl8ZyBl/bqVVn8K805kc1ljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0K33CaRBeqO+dIwY6c6A5e4lymy6g3PMKqKpAUunO0o=;
 b=r7ph0M9D4mz6xjXiGyxoF77weV3zXUbCpBgfjJXDU050I2aITRgbxRy0N8vHzR8N5QZvxzZ7w7OQcz/9alRW1ltg3GEC6rP0B5jxL43QKQmMWeyGRHIQS1KWUkZw2VGcArB+UsjmVbBXjX5ZF93nSs+Jq4rV2RDKEiG3VrMnXv0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5468.namprd10.prod.outlook.com (2603:10b6:510:e8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 02:23:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 02:23:11 +0000
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH][next] scsi: NCR5380: Fix fall-through warning for Clang
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v96pjdry.fsf@ca-mkp.ca.oracle.com>
References: <20210604022752.GA168289@embeddedor>
Date:   Mon, 07 Jun 2021 22:23:07 -0400
In-Reply-To: <20210604022752.GA168289@embeddedor> (Gustavo A. R. Silva's
        message of "Thu, 3 Jun 2021 21:27:52 -0500")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:806:d3::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:d3::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Tue, 8 Jun 2021 02:23:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd1c10cd-83b3-4c73-a7f4-08d92a245c9e
X-MS-TrafficTypeDiagnostic: PH0PR10MB5468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54684C50BBB460BF1001D7158E379@PH0PR10MB5468.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3CKiKzWv+g5R4Nd4Dstso8y1Ta/WqBn8uUxZH0Te+KCTD2aMcBhWkIB+zJm48ZgFlKpdfteD0rHn0PDREH5XTQqa4pjaMjPfFS2ma63njrewuhHJwg9Jkb4Wo/0WIrbcCVv9fLRB+E5GyUwyHumI+PuMiB4uTByTwsVSkkR0PjJR3YLAadxVL5Xbd/SW2nAdQh7wjYKElnzcoAgGrF2mLgdHv/OPfnY/90rv6QcJNvdU9gGksnN8mOdJwB2EchvJ+zwxubc19DjpMBDrRWowMizETDUPpvlgQEzMN1rTarupA2p2djBfDP6VvCiq182lLMGCzBpepT/fUW9g6vPEL4yD/tfCBdYVC5z1ARst7UdGmgm+aLnioqCjOhOHWRHMF0eYGSN9U9iNS63pQNu6Hjjf4vDPSAvWuOw05124HQoZDlG1X+MeZZDfW0/HqmhZM8+DTuTDEYV5zqoMu0oyp8YejhdefAuXIQxYOzwfvgqbcgL2l6zmJLTS4FiFWXgE3Gl9px+0zH/xD2DfTGeiO+wK+nPKqtXsg5+EEUnCAnRIvmD+sAAuDkOE/5LopdrfrbHzXFpEBXWhPTTBsPwY7GFil1PIRV0HgLlQ1oNYYuEgx48MAvg+6VcUZ1ofqdoyciP1L+5PeiDpRnA2L6uNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(366004)(346002)(136003)(83380400001)(8936002)(6666004)(8676002)(4326008)(26005)(956004)(558084003)(2906002)(16526019)(478600001)(38350700002)(54906003)(66946007)(316002)(86362001)(6916009)(7696005)(52116002)(55016002)(36916002)(66476007)(66556008)(186003)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lbGcfBfcIpRa5Teq4fLl405gcecMZ6nnckCpBIEJPcZ5OKrhMtDDSqeIm1fD?=
 =?us-ascii?Q?E0z81647z++vmba2f71XjHTexL9B64aqgdBqnk4hmWZt8lFxIHUHYOdzlDU2?=
 =?us-ascii?Q?xh6yrKV4sHXFHq9fH2RooODq18YEeFzcPgEsZnfr53KEZzO542Hh6xex3h8T?=
 =?us-ascii?Q?3xQ3OS0fikGPwrpqezXIJo57jWbKvYbOV8/BG0ZRAbevzXE6+zu+65BP9LZj?=
 =?us-ascii?Q?77Avb9kAlcRNNPUXpERaBCjrd+cC0SYmb7LqcLCIouOUfKJu62EZSJWM8DR+?=
 =?us-ascii?Q?lBDuAZ7ftfYAaZJMHrwTEoA8DA9RT3TGFoVSIrcuUWIUxGxyoGfXmxxtbIRu?=
 =?us-ascii?Q?tzO/5CY1kg3Rf6Ry03+fwJpMzMhZ/c+dDBwKbma0HsRW42rkdCNNWb7BGcs9?=
 =?us-ascii?Q?OLRgzLLoTA0nawv4gakVpR2gqMb6SltgyYrLETaUJX4F4tc05X78QtChfqcc?=
 =?us-ascii?Q?RW5CohEK0Y7goY2tptLgBxOyx0tIeJ0luYtRZPNGi4604/zA+toaW8GYXYLG?=
 =?us-ascii?Q?O5bEBVCwH5Xn9iM8c2pN5htqtr7na+PonR6PsJzjt4gbV7zmzom+gvFzTLWW?=
 =?us-ascii?Q?DoXJdDaRorMhuDF6Dg/oWTYBWrr2sPqwjYHl2FrIhl3MkRbbrK98LSd2HwsZ?=
 =?us-ascii?Q?Uga6eUry1S5vB0DBOQNR9nJCXz1dfdLScugIAV1KJmpdJRkShVDZBV2PnCJT?=
 =?us-ascii?Q?pVqytepQglwm0z3iKzT783q+6/iwyuS0jzcn5M+CVqz7ZQD+H82/E2C4ZS5T?=
 =?us-ascii?Q?/rVrKrymuUoT4VCuB5PFnCChw1snt3ZUHTnmoW9gbtVcTZpKXfqBCHcjhtOy?=
 =?us-ascii?Q?iCuV2qLjJ1xrG9whTk8H+ACTQA12UmR0EQrXCtRQ1ij6qzAY5zA7FrYwMD0a?=
 =?us-ascii?Q?nx5qNlU+VDmebp8VsUpDE1+XAKeHEOTkiTKFdI17TqJUtUr21rTV6k1k6aU4?=
 =?us-ascii?Q?+lTCBDx9l7zNgiFKWaYa+44IrrycNgk6gksAPImeyP24UCvOBgU/9j8tRCm0?=
 =?us-ascii?Q?US/PloUdlXMXRa7LgQSuPC0ZpKh5PBjKZHWE/iI4IJpffxFa8Bh5SOT+oxqe?=
 =?us-ascii?Q?usBYF8Pwx0Pxn83XwN8keQssc+58DX+Y/x3IsK7uGe031QN9M4MGraO41Amf?=
 =?us-ascii?Q?9qp6fTUFlQUdOwHzKHfNvk5BLYsNgapVxhLlsOIuCHdv6l2HGVkgnPIfaW2i?=
 =?us-ascii?Q?zz3FNifop74+9+4rup6pzejolI0Iv45tuLLA9fbUQ1UuByEN/KJlb4kvs7MC?=
 =?us-ascii?Q?VkLHx0aajh2nuPSGy935E+WeX7VaFEFXTdq9WWu61wOpCuyhW6d/gzcqzOvG?=
 =?us-ascii?Q?Pb+uROJjur4QBAWilpWfXlNN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1c10cd-83b3-4c73-a7f4-08d92a245c9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 02:23:11.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BnOh+Yjc43SogAuaJk5E2U/8lAuFrb0pfE5ac145k8UshvNtBH40u4zZOhUL4M5qtewdyZ5cNT8pfsmuc9b7KQT5+OdYsWcYoH1nbzovehY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5468
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080013
X-Proofpoint-ORIG-GUID: vvwwu6gekOmxOtFP8Oak9bMwJPKo_wrv
X-Proofpoint-GUID: vvwwu6gekOmxOtFP8Oak9bMwJPKo_wrv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gustavo,

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> fall-through warning by replacing a /* fallthrough */ comment with the
> new pseudo-keyword macro fallthrough;

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
