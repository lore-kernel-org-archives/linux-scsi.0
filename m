Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7354C48BE6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51B3613C2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFPDvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:36 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16906 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231215AbhFPDvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:32 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kUTl028393;
        Wed, 16 Jun 2021 03:49:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=HE64Z0yY6hTs7rfabG+WQyFRwJ5RLz5v13HOSgaPtqc=;
 b=QICaBTehzUoXetXkPtvjZKpm7buCpvemzSLE48P+/5SM9j7OqY/OFFk2ChPOsVE+2njK
 yrvAeH25Lf0OhQT3ybenQ7OFA7dw29ytANEqFn65WtR/ST2qUT1azSunCamrjyk1QkE0
 lAeofxbhv3GfJmF3O4gTbZV1vDO4HKlHnNVP1kPWK+p4OziDYlde+HN4gsrqfliBYH97
 GItlcnYGn3910BzQo/jQMXH9h4zfCFyrp7VI8FQrfN5RhSmjRXEt5lSTDKq8Pdt3fm7j
 ubyiegum8NXX9Vu2brYOl82Y1bxALrADqDidhjtig+mPhP+MkaBSXkbr4LohWIAfV2EZ Cw== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39770h857x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:21 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15G3nK9v157530;
        Wed, 16 Jun 2021 03:49:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by aserp3030.oracle.com with ESMTP id 396watxnrd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAYwVmzw2N6vQiVLMs8YSd4zKQ4eXarIVw4F+JoRCNVYhCRSFFvxq5yat10AHvUdCGJiSody95AZ2IFj4XEFKB4ik4vqndTKuZqDWebaHqAJ/EubQabkhYIicmmzFrFNf3zlq/XPw1AO8xzsQ7gVy0o4uakJ+tVaLrj7CQplYUweck6QEmegQsqWkwpv1u/vf58l8ue6s0Wq94q87sxLXaIeEuu3skb6Jy7p93zI2tEV68icOmDmfqxV6Kt6EiNIJ2Jh6djfH4pd0WZcKdGDRxOVntXefNclp6qHVE+oByf4MU8JvqsOcZDarOPUEc0j7MhBjb7Oyc15gYC/X9pjpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE64Z0yY6hTs7rfabG+WQyFRwJ5RLz5v13HOSgaPtqc=;
 b=as0+qUXXs+i9PqgncwVSfrH7/+0jgUUA38PdmRx8fxy8T4tdn7dIia4xYdP5Q0EQ5xoagLcKlIhS5qqUSY3k5kHJ4BOZIAyXjR+ydcldsrFgQIf9Ki2ULV1O4ISZEHBzSJzCazZ9oVanXv55+QOj0+3w2NZ3uIQchuH0mXfe8/88KalAnJv46K1AnUe/Y4lGaiPzJZqBvnghKmgTbYdd9eUzB2ooUJ/ylc/VI6CdQcUkGTNRwZJ7W0EaZoCFwgr23fLlkM6BQ7S4S5p7PfISYJ1R2o06z3fqSuxKePJUdQIZck5TqPNwMy80WKMAUObtPjCkpezGW+3UndYVBa192Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HE64Z0yY6hTs7rfabG+WQyFRwJ5RLz5v13HOSgaPtqc=;
 b=dju7zlauAozy9iSIncBDb+DXVz0OvxzKx24IssshUDTF8PrG6jcjfqUGkeErUxOHgU0nCgRusqs0gFmdNkEYnWWFp3/JCOFSe3tzXG7VLyBKEXOz3RR1hhZsKLpUBAangVDXZcKaCup7E7EMlVE7pIqBJ+/Nnkt+2yZW85Mhiw4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: NCR5380: Fix fall-through warning for Clang
Date:   Tue, 15 Jun 2021 23:48:55 -0400
Message-Id: <162381524895.11966.16368537862737001047.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604022752.GA168289@embeddedor>
References: <20210604022752.GA168289@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 292260de-7a96-43a7-7104-08d93079b84b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663F79661750E3C1BB41E658E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4P1zEEZ8hUkA/Df+35dfiJGeE3zVOInXLtTc1Rf+kpkXJ+Q9PC29LwUmoaRZmpZk0nYdw31JacfnQo+exZqt/V00dNVHkILfDcJr++TRkbwGTKlRWz65WcAEOkfv96fDShvg6627BZkQcPws5PqRJXjDyh/WhjCm/9zh/1aLqIjInwnVw1wxQrmpHBjxXHroakNA8p02rlYob4zlrTErtm71vUuohYob5gwfn/CNi/LIbanF4zMIJs09SM56gBsZYl1w+Cfld0qwBbI7i14ooTeuB9wiCWJPsdz6Rchim6IkdkiDG+E03jT1qXbeD7sn3F4DksCsgEpWaneUD/hfg7QUcqFWANDOS9CKFOGskxHJLqVA7tmVDOnaCuQ71ye3iwzhbAlbm+iSpITeXtOV2vrrbuMk0DYzbAehhbnAfp/oMgCfLJMG5oh4nWpKFWmD1EFpuFWRXaT+gQ6T/Z9EEFGldowKQxVW+0fdqR5IRKtVxHCpS7Az5TKZB9eRuHdV/rqerMX56nBZsCB9FJkROsRH/G/HS3GLoloxVi5uabekL0Cp2E1CJkEw/bB2jH3vao/J366UkLZtkm8HUtxf+xvgF2/ARmeFs7F7WiUrwQZHKRQvscg14XbK7JlBQ2KkPWVyspJ4ItXENYs8h7ANW85nlpm1EEXccl/NHbZPMxtXNICSgev3YK9XuFacEPRm75zL8g5YP+njy03XmWUMgVdFH+hhy+mFRfNz/C4hHN0SIOXuZ0Yf8RRR6sKirnSPHxcrKI6IRjHNWYKCcXFf7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXFXOHJRUFh5WkJxNnR1emJBcThmeUhhSVY1Zmk1WFVwQnBWcnpnQ3RPZUpW?=
 =?utf-8?B?TnJJbVVvZ1lvRXRUVU1Eb3ZDWlY1MlA5ZFlCbjYwekllVm9QY3l0VVpxY0JZ?=
 =?utf-8?B?SU5pUHhhQWdkT0h3VGJZV1o1bnMzU0JoZWhudkdzcWhVREtEOUFDNTJiYlBT?=
 =?utf-8?B?RkpGZ2lKU1FkUUVIc1MxSXVKR2tpbUp5Y2lOZi94RHNYbFg4WTJydTlOdmN4?=
 =?utf-8?B?cEN0czBkMnlNT1N6Q2M4bEIxa3Nub1VwcXNNYlNxQ21mL3c1MmNudTVmVnpS?=
 =?utf-8?B?N0lSSVgxcGptT0ZlQWlFV3UzdSs2eFlPTElBRS9NRmcrN2FxMkZrdEN2eHE1?=
 =?utf-8?B?SDF4Yjlad3F0eFNIYW16aWJyREtGcW5nQ1lpWURUSytucmNaeEhVaTBxZG1p?=
 =?utf-8?B?NEdDakZqemxIaVFveWhYWHlnVmF5MVdjVzljTHI0UDYwWmFLOFlCYUUwc29z?=
 =?utf-8?B?ejFSTVZvUjB0SksyMXlybmRINTRzbXIvWFhxeGRUNmVpVm50Q3hhcHhwZUtH?=
 =?utf-8?B?cFJITDhYbnQyODI2Mk1vQ0tQbEZ2RE96MjhwTVhrZDhmRkNBK08wT2RJRWF1?=
 =?utf-8?B?L0plL2E5UXcxUWZydE5KZEJmVmZyZlV5anI0RzNtVkxqR0VVb256bmdDQ0ts?=
 =?utf-8?B?Q3R6eTd4NzBLY3p4N0Z2RU8wRnZaS3pIR2lXU2QrQjNjNHVScHBIM2tmRDNI?=
 =?utf-8?B?WVMrMzg4YUc1cnBYMW9xcXd5Slpjelc5RmN2dWJSSkkwVzR4dTc5ZzBMZHBs?=
 =?utf-8?B?QWhaUU1ic2VYcUZNd1psS0tlWlM0THR6YWlXYVRYcEVMT05NcWhlcm82bWZy?=
 =?utf-8?B?SUpSZW9UT1UxSWdTMmN1TTJDcHhDTXlSalhHTHUrbU1uaWd5Z0FweFJCNzJF?=
 =?utf-8?B?dHF2RzBGUFVjVFk1dTg0Nms4REg5TjZZY2pyNzBpRlVzWTAzMU5xUncvL1dT?=
 =?utf-8?B?aGpuVldhOTVDQ1B1M3BjMFE2cTBidjR0QzhZTnAyMWVQQWFsbE12UzNCajI3?=
 =?utf-8?B?NFdraTdGV0tqaTcxaXJyN1I2TXA5RTAvZnM2WXpsaUlmVVUzSzkwSkYrU2ZR?=
 =?utf-8?B?cjlYbzRGUWlCMEFsRVVuUWxxMWhvMGpZRWxicXFldUsycmgwTkhKM2c1bE5y?=
 =?utf-8?B?MGhqcDl3bEtHMjRvTlNuRWI3aFlCczlaWjdOQS9GeWJhVlJGTHhhYVRvcFRC?=
 =?utf-8?B?V1Y4Z2o3R2hvaUZWQXQ0OFlERytRU1lMYjVScU5Hc1J2VEh4M1p5NGdMVm1N?=
 =?utf-8?B?U3Vpd3RFTW1vb0ZBL0xOUWEwTTB0N2s3NkgrSkxrVFVoL0xTcGpKY3o0QS90?=
 =?utf-8?B?VkM3d012VEFnV1ZMMExzU2hWdWx2ZEZTVWpRSnA2ZkRlV0szcVFXa2lZYmQy?=
 =?utf-8?B?TFhOQmRHTGthQkFnU2VRNzlYVGQ2OGJSRDM4QUNHcEo5V0FaQTFHSEtWMmhL?=
 =?utf-8?B?UDVlaUhkQkIyZmZDRWFzMUlGUy9oL0lrTVB6RmNhb2VDUUJsa3RrV1U5dTFN?=
 =?utf-8?B?NzBKT3VIM2FtcnBmdUgyaWkveUx1RVhXQlNDUXVwOTdMRUF0WEpranJBamxj?=
 =?utf-8?B?R2dtMkl6TmxRQlJ0RFlLWGJxNkMvQmc5dHhJZmZraWtYYkM5UnBmZHRKdkVX?=
 =?utf-8?B?aHFwUU1ONzZ1NUpTTmVNNkt4T3ZmVzUwanVBVnl3Mm8zeHdlWk9WMzU0NGhE?=
 =?utf-8?B?UFdUSU82dzBiTDNQbGszaEhrTmZYQ2kyUWUrclVobytjRXV4VG13c3hSV3ph?=
 =?utf-8?Q?7P8Rz4KyMvWiaiOFaiL1Psd3DK7L0N1PF8aDpce?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292260de-7a96-43a7-7104-08d93079b84b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:19.2715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3f7UzHz8UARoLWPTUOyRsRPCjtTBSaqXveJ8MLQu1oGYEKX+ArrWq3b/NZnBqpABE4qX5egZ1Txq+iy+uMRYUOM5Q5NwaOxcYjhLbwx7/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-GUID: _j-OsC0j2KjpBF-PcclGAHV81jqJGMhG
X-Proofpoint-ORIG-GUID: _j-OsC0j2KjpBF-PcclGAHV81jqJGMhG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Jun 2021 21:27:52 -0500, Gustavo A. R. Silva wrote:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> a fall-through warning by replacing a /* fallthrough */ comment
> with the new pseudo-keyword macro fallthrough;

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: NCR5380: Fix fall-through warning for Clang
      https://git.kernel.org/mkp/scsi/c/61f4f11b48f9

-- 
Martin K. Petersen	Oracle Linux Engineering
