Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC3AC48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:02:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A29611AC
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 02:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhFSCEy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 22:04:54 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhFSCEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Jun 2021 22:04:54 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15J1uNwD024196;
        Sat, 19 Jun 2021 02:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EgmMqMwI6B+QLdbfGf+VYUWzzd4xXvfG2au0XAUQxkQ=;
 b=QfMyYprvgNQ1UIBcnmc5+sl37ndtlseoqBk2+HAhoNU6udLnlJ4xnkkw5s+uuFL3i5DY
 R6LMb8fIc8U6qG65fvIfGfORwDYPDNBVQT+qjk6odhr244EngD8VqxlOuqEwIWxTKoHt
 yc5hzhmI/LQa77IRmd/cdGlPjH9P8bpGokKMKgDcmqZVTd/nObUKWd3rKAIE4Uuzkeii
 Xv4R3PpQ/UAlFlnlcjITDx4VFNlFqz3aDfxYnJYDLZzslRYpdAZFaE3GhGNAVXrkBpGC
 8sIijzgPjv6D7rUpy0nuPej98zIWIZ3rf3lpJEJrwyq34BnzEGMC8HjWrMg+cPqC/YWc CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3997c18036-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:02:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15J20wvF182268;
        Sat, 19 Jun 2021 02:02:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3030.oracle.com with ESMTP id 3995psa6xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Jun 2021 02:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlcbKJalSKhqdp/LksSi8aYRqBANOW0Yv1M/Qxba4VltXyzIQVB3+uNhBJWz1bl6GFgkCWwIhmJkprDFpSmDpeCFua/SAQkilCrorIRGVR7ZRRa9Bq7eL5wDEnv70v0oAaRDi1VZJ2AD60hDwhIHp5+SXEWNosKGriWGO+N01bjYBTJlfAW3Hme5XZMUIT6tpFWYMzd3UHp0YaA4DpqwtZlFpaXsEqwumqnCirXk70bf4PfmZgGw068Qgb1J9/VnYczrgPhWg9JXPKLqmVfWMqpVIZFAD4bkNRq09QeRdPHYDsp5Qv4/mx77VvjwFBqQBWELK6jHXRfOKA6pyQz9cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgmMqMwI6B+QLdbfGf+VYUWzzd4xXvfG2au0XAUQxkQ=;
 b=IB5dyvi6BjUlQnxQ6iSdQieWb7VGSakRrNYyHQY6nVHgPdJfJ/Vja7Ufu5DgsIsEeLPLERKTwznNq5aOGtpNXnHjsm6zKbpKkiLCiuLM7YI36XvNu/zf1iwEbuczFtCgbO3n4mYydgYrHkvUP+zq6uHpFcPCgYbvF4IZtyyQkKlmmOX9jucJaQaMsiaT7TbVFk/6TBOH64G5UoGHj5YmAM/aDh+nfnbWnv8mbfUk2amH/PXBcN7kalZqji/8leRC8OdInQcFZUiBeEFEos1+xeRnsojeuRmdkxEQHt9RIaN5eZyj927qXhs/5i4wrOuQN4NV2YO2XD2zH6igRzkClw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgmMqMwI6B+QLdbfGf+VYUWzzd4xXvfG2au0XAUQxkQ=;
 b=d45QULqsla65uSvgXXD8oJk4ipqsZ1wi2TZx8aYGr8V0RXNpbpqe990MUoLrF9Fjr0NbSfpW0aydKc1pPfbdUB1qtJF6hPi+WqOZ+R35yr0W1aOZqsOtfzWs5ezAZEhOcS7apsP0zTZnllAbVVOxlbv2gd0zyecO4FUDFp1ojSc=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1245.namprd10.prod.outlook.com (2603:10b6:301:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Sat, 19 Jun
 2021 02:02:33 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::89c5:ded8:9c91:30d2%4]) with mapi id 15.20.4242.021; Sat, 19 Jun 2021
 02:02:32 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: mpi3mr: Fix missing unlock on error
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im2a1uj6.fsf@ca-mkp.ca.oracle.com>
References: <20210603152803.717505-1-yangyingliang@huawei.com>
Date:   Fri, 18 Jun 2021 22:02:28 -0400
In-Reply-To: <20210603152803.717505-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Thu, 3 Jun 2021 23:28:03 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:806:23::15) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0070.namprd13.prod.outlook.com (2603:10b6:806:23::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Sat, 19 Jun 2021 02:02:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 361186fc-5ac4-49de-29cd-08d932c64d15
X-MS-TrafficTypeDiagnostic: MWHPR10MB1245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB124578D0C34955A767A4D0098E0C9@MWHPR10MB1245.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ipTFCiNKz9qyNzSYWOqivySpyHintKRT0mwxy/OVB2X1K8qBJAm+8yA6NN0n6P7GtOk8t3iZ1u/uqEfweI+Uu1yEQ2G5SBvMB4LRt0z0pN/3brHlCXegi+dYioxdF8gy1T/tgW+x1o7K3TVBuFgJG8qrZ9tkDcIpVQVdOIvvPLaBsLqWfIGUnh4Zy2uGxozaoPks04hG+CYE5YEDL0i4Bx0hP/axJ3jye+R3Sb0IKKus/9fytZHjgnX+SUXqEr41z/pUSQJsCqG2rFILA1NHGKZ6waZufVq7HBBos/0RRZYH9qKP07PD3RFSvA9tP3wLzriL+WM815xNI9+dn01JcIyf3nRVX0vpJhvzn26W5BHjIklEa54NGekzjhosAXIekMpJD2dXwEPjAD97ivCLGlCGfRVP9kD6OIbAOy9DQog2m8+L0rkgaXWc1R2fugrSbBD7hs5uzYoDag3cRJ2x/48joKJ0azqDIXjH/tFYuGdN3aPt3H6ha0ZtFtAGztaqfNGmxULUT8VZqaivEo9ohvHyqhw5/5ssmQW7WeKc2XCTTkUUQFf9AqgOSp/s4gy0VaRjNHhJkewlHuzqif6fTjv7kIWfyIwNXhF8pYn/NdnKDrwkKmtcvkm11f9GfyLSKwIQvsRokbN3Iz3NOEYWp3+eUdhuUilFYmQztRlcGWAnwiAUv7qy+hd3yiZhijlz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(376002)(396003)(136003)(956004)(26005)(6666004)(316002)(107886003)(8676002)(186003)(66946007)(66556008)(66476007)(54906003)(16526019)(38100700002)(38350700002)(6916009)(8936002)(4326008)(5660300002)(86362001)(558084003)(83380400001)(55016002)(52116002)(7696005)(36916002)(2906002)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cwYsMjtVok8qXIjiPYeQqOlZdqQN52WoQBx8Eu61U3g0IUWzsDJGG5XNHJTW?=
 =?us-ascii?Q?9fYwuC1HtTu4hrrhNo9KQHUgKaXR0qWiZWjUfj3TFnF6k6zgxCSWTIRhbA65?=
 =?us-ascii?Q?fli++0zjUsXWeSjt0Qb6wgMWCyiXrYd/w14Ls+j7A4b6yrnGAoGItV7LV7h6?=
 =?us-ascii?Q?I0gdmHQ9nK2AgTK56t2lZ1fxNSgn/pg7cLddy73g5G46sg7iWkkb8w57CY10?=
 =?us-ascii?Q?XE7U7+eOI4YGWnzHlQFsGKbW+dp2FUOBu8tBJ30nOVai4KuayQIrmu4IDC5s?=
 =?us-ascii?Q?FyfS3qwEjsKsi024P/NQqk+GrqyA8tIgDHjIIYunbelLwfpJVVouX6ShjnyX?=
 =?us-ascii?Q?dZFpSTOhnsQRHrDGsg4fR1FrD7roPI4iB6lqeAy2Ycr1ugV33bmuHGgm6OVL?=
 =?us-ascii?Q?Dj1vx1mNt+mMgWOitEVSjrUbJf2drhM8sR1mDNEDKgRvfD2jFM+thCJJdfdC?=
 =?us-ascii?Q?HLzitulSjAFMVYcGu8SMYklwnijiJsKrrwPWvrAIwLCJrtu+bGUyoXNTNKEm?=
 =?us-ascii?Q?UWGNhHCDL0ZiF986jyceKcqthpJ1crGcbDk4PlZKtzix4RHrrgDgAcOlZAh1?=
 =?us-ascii?Q?H1a6DnOVRG68i5swZCPJ17ga7ElFgutDJNuxBHSQlrQj3uAXAUwCZRAcnRJj?=
 =?us-ascii?Q?VGUsZGbccNBnhPySWXMhjrUcVn1+wto7cCZJ+xHpVTH+k5GT1gtZ6vqFj0d7?=
 =?us-ascii?Q?TPoS/D8XZgZHUp0S42zq3y3tE94uL8EZXKOFAuSsDcM8rMxtQ1mGZmdYFZ5E?=
 =?us-ascii?Q?iPa2AN87LIjZhKy7mmpvzt56zfjEN+jGOwXpYiyf9+H6TVMZR8e2zfebVDWY?=
 =?us-ascii?Q?cImle0STd7pRuxx28hak4ItJKV/FXajEG093OwruvonVrrKDvHrHJSxe+VAf?=
 =?us-ascii?Q?snewGTx2mXXfmdN6mzh2V/m5zibxsU6Hsai5Ag6qJd8BECvj0IHLHtZw99gw?=
 =?us-ascii?Q?mipj4ofUIEeAaolXQ2t0ehIVV0RsKe4TqCUFM5WEsIh+fwT4PEW7Sn09OA+u?=
 =?us-ascii?Q?/xo4UEutMhDI0IJimjRCBd8lMJwPSzkt6m3jELiRsFjzkwyVaDbQ6aaUgHcO?=
 =?us-ascii?Q?WiK1+dJefsglJeCOzAzcp8KS7NXqx9N+ojCOYX1TErfOYlyTThTOJllwzE2O?=
 =?us-ascii?Q?tjzaw3rN92aO6jLmYE2uV4/Tlm553mWJG5NkNrJUzq92S8NimwtfmR9O9O4m?=
 =?us-ascii?Q?YspCeHVMyto+fAvT2s55g52i4qLhyb8UHfM8j9lIKFEesG2/kJUqlGqbpnXD?=
 =?us-ascii?Q?tmzqHpAJeIJbVn4MPP/CW3A3AaWF8JyMTwHdcYbJFg8L0qBsGH6wLLUSqTkE?=
 =?us-ascii?Q?M7uH4DXVQyM/P//sjiCjLtca?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361186fc-5ac4-49de-29cd-08d932c64d15
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2021 02:02:32.8608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IoeHQ12x6lZ1utXjXYQGGKKFk7ZJ2rZjelIQwMlpqerffo+W8sa0q3I4YGM8qSrz/U7LtqXwZmuWbZisVnYcvCcklV5LmynPLPEVybg1q+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1245
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10019 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106190008
X-Proofpoint-ORIG-GUID: xnS7auwCPTO0PmzSLEw4tQVys9ZSXO3K
X-Proofpoint-GUID: xnS7auwCPTO0PmzSLEw4tQVys9ZSXO3K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> Goto unlock path before return from function in the error handling
> case.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
