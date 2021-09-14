Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42238C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261C4604D1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbhINDqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239360AbhINDpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:52 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E37X2j020352;
        Tue, 14 Sep 2021 03:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=PP1o+4VK2POeKkn8+5PS6xOwLpoyHiAs+2MUj54XVJM=;
 b=Sp8MM1tVuidFkZ0liNXMoF7EeyvfZubdWCmhm4qekF8SR8Safgz1UhfMq344UFh+EKNn
 GKIEY4sXkIF0Oa3r3seqjzBzvsMtQScII9ZjEQRJFpGi/pJbPVA4ThlEWtTc2guH0Jl9
 p/3c7L09SrmgImUzcu2z1YCPyrSqNKu85tDUyc0AdAJhpX7a3UOyOm9bJqV7RKhU8vuh
 35k2fBM5fIbLV/L+2udm5UTUBf1NKIJ0p/L9ihpApuaaxYeY/flUk03FYGyNrz/EpZ6e
 zYzRdiFpvByK/kZ/v/O+dQj7tJri64rMREMKs8mtxev5zyFRvwN6+OJ+1ui25QBNh9P1 iQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PP1o+4VK2POeKkn8+5PS6xOwLpoyHiAs+2MUj54XVJM=;
 b=GS8pvwcASI4dTBRarmx+nW4+tEoYGq6gLLOnKuFvsIdjGRRW3LGmNApCR8ZARiGE2gz/
 GKSyMh9Hrk2OZhZKS9S3fMjcTP8to5s/ooD48AVdqB3rRBFpAQG+rB8sbzfFnICVg+pV
 8Lx0Bj9Ji0zWSDrPQm01wfdgolgXvSh12tjelZ5+NQEVzBY0RglrJYn33aNXA6ISf0HM
 yrn2FSvtRmF6FNnXEAD7b1BjLPW/gSq3F/tkbgwKNP6lHSoXumntXk+qiE+FpscIBhfu
 LYhfwQYUBbJDudhpurkbmFP0EnSqWVghtH80hJCeF3IZOqmi/O864XCpLNY0EOFD/cfJ Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2kj5r2ej-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f6LJ097717;
        Tue, 14 Sep 2021 03:44:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3b0hjuesv1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XT4WM1B3po+V++/jLUAibjpbX/XqEWB3SrCnH2xBVIPZQn6NYBfDMqQr5/DGhwGPruEkV3pS2u2QomSxVr+QSDuASgiIY4IBsLIfJ2/rjJdC41vCq08B1WC6bE6TGzSuMsQ9zsVB0JTQwxbxYHtcywaIUK7Yb8KrwzYpzu+WIoVAb9gBRLSCA/z/yEb+37TyS8JrwndH57fWJHoEXdeexOIPsYgSnavPSpzkuXYc7IgQT2WnGpy2tzpOaXaXY1U59MoRmVTMU8QkG96mW2BmkumNXDQu6ciuxo0pGIi5Pq3p2SLpXwH2MZL2phd4KluawkGVtnvWupYaRkpmIGxAaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PP1o+4VK2POeKkn8+5PS6xOwLpoyHiAs+2MUj54XVJM=;
 b=bIN2AfVynKbnEYFFbFFS8D2w2g7baLzSnU4q80QpqqtVah8tadT5nKauXE+LSbgPHqYtYC3qY6PDybNvEWcaHP6dh4AyNnub2WF7j5Pr4cPdPUDg2S7kFpgMwzxk5NndzUVcSYYKsauEzteeJ3RBWEp36tN0/PNckcehFFMTSWF5JQZ6vdQPI/qZcVWagO106QQh12/1oKwvlf8L0tDdvz5r/kFc8WsgHnBZJ+gX99yrVohoxYBMbOoRr6eFaKWy7PjcDt1+HTJ6AbOTE1Eakl0A5yajxh3yaPOSlK0tuaQ0S+wbtqgcpoA1XVH+sR7FfSi9BVMtuVispqUZDShdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP1o+4VK2POeKkn8+5PS6xOwLpoyHiAs+2MUj54XVJM=;
 b=uXA0amxtRFeBEMuxpdNPhUnP+4PBZT8hphoBVdQzfo+Rb63TpoX/wC6oeqAiBQKOALfkSaJg1SKWErnwe+myFtFd64BiX0KSFWQwjrrT8WXll7t9+qVKvOx4Ib6pdTmjo0vDNngCZfOMBA/FbpJtBq744JtslLO1Xhw7qg4osU4=
Authentication-Results: kolumbus.fi; dkim=none (message not signed)
 header.d=none;kolumbus.fi; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Tue, 14 Sep
 2021 03:44:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Nathan Chancellor <nathan@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] scsi: st: Add missing break in switch statement in st_ioctl()
Date:   Mon, 13 Sep 2021 23:43:57 -0400
Message-Id: <163159094716.20733.10807423364906570646.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817235531.172995-1-nathan@kernel.org>
References: <20210817235531.172995-1-nathan@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e113acff-4ce6-443d-4d90-08d97731eefa
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4725CB46A3769578A5D5FB548EDA9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WxVMGnioZ7xdMDLl15RuqZpJp4imqQ2jTJK2EPIb0sCtaJmTu8dprPLQu2oRnhVBu9cz/zua8wjLIsnqGSMiUUwYPLN1oonp6Z4W/1GZpmC8KavfszQrGvStABGtIRh35wjvKTqd5aRDqkwy/wlLa0AJsQS3EvkUWPhGLDcItNgavUAv4TKr60aYL6NHBYzwx8VKWXQzf7RvDl+4E3yPtRWRElMyt90QQ96p8Ytf4LpsuLnYtxLFqT+8cp24ivB1ptZj63dUr0yMGbHlijRNRqmqhVyGoI9c1hALcsMu8KdwSSdvo6YxiV39CLvLAddZX4+Lj0m3skRgQzc+bubUNY+JAC9lgiy6X6Voq2iUhs+LrcUaOgfuKm0zT3ksy/NYV42GG+xgljNL4QrdbkWwDGAatwO27zAYzEgiAA0kkkFRwmY9jqaKgFd6oxPGiJQ3VQ6dPCptHlW4Q78Mf1+4LVh9IssG/gUa2R7f30VhmCg/ClQ67H+P/hhbamd7JZTSYR7TB9WfR2JJO/ztTAzw2lQzhsPUWmj0ES1QqcHqQcLVm01fJXRvPai+j8DkI+7CaOji+wXSERkS0Eu0V4uS2YOH7z0ZEmGG7TPYnklhdDA9D/Y12ztp8+e/jqEPVfKiSZz2D1sPg4ZMrzwQHRN0VrBIeVz23ppECyub/8sgUK/L8eoiAC3Ox6mDztj/LxkZ4DXszON+Ohzn1q31r8UMjsFctISo6RolyANcWQc0Yl/93NXMZS142iNbZvLIXOQsPDNVsXWxRD5LV3Zwmpp4+Qiur+J7f6YtdXmYM/P1dv0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(376002)(136003)(966005)(186003)(38100700002)(38350700002)(66476007)(86362001)(26005)(66556008)(83380400001)(110136005)(52116002)(6486002)(8936002)(54906003)(66946007)(6666004)(8676002)(36756003)(4326008)(5660300002)(316002)(7696005)(2616005)(2906002)(956004)(4744005)(103116003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ynpud0IzU2JCYnZNSXFHNldOaDdhcHg1b0xieEZmZVJmb3NnWCtVUlBDRjJG?=
 =?utf-8?B?MUlqaDJzWTFMVlo3WDBBdmdwOHN3NU9hMjZXcW8vbkw3UmhMVTlZRjZRTmRS?=
 =?utf-8?B?cjJ3d3FLS2dPaW12NmtraFd5eTRTVktjQ2tRVkFLUXhLZjh3WmlHdU5rd082?=
 =?utf-8?B?eXBROG5JVWppNWFJalRDejVMN1FheHo1RmNkYUpMN3RjUDJjYnB6R3pTWDBJ?=
 =?utf-8?B?bGUrODFXcGRySE5ROEVrY1NRZS9MYUN2bVZ6NGY0M1dUQUZ5dnQyUmxiMlIy?=
 =?utf-8?B?VFZlVVBLbjZJS1lab1c3ZnVxMnE5Zk1ybS8zMy96UmtYc0c3UG50bThUNEpE?=
 =?utf-8?B?ZnRnZjhoQzh1ZllKMnY5cDM4ZU1RbDg0ZUFwV0cxSUpyeStEWEdNb2Q0c2pD?=
 =?utf-8?B?TXA1NGZpUHMxNVhkK0hxblZvSXdCNEM0OU9VMmYvS29RUmtWUnFWSVRFZTF2?=
 =?utf-8?B?dzZ1STZRVlU0cnVBc29OYTdkcUxFWGZPdFFpUTVBSURHaCsxOUFMRlNvYjUr?=
 =?utf-8?B?VWxaeStJOE9kVUJpYkdCcllNZmlpd1k3cVZBMlRrbFBFMWZFOFRDeVhSck02?=
 =?utf-8?B?MllxWnphSUdLMytZTERpUWdsQVpDalZJbjlOLzNPKy9kOEl5YXJHZHBrVDEz?=
 =?utf-8?B?VVk3bUx0MTZRcjltVDArajJiTjEzSkRiSThLOVZNYXJCN01ZeG5uRUZkekVa?=
 =?utf-8?B?ekdITnl4dDVJc2lFYll4RTQwTUJjUWNpQzVGdGRwaWtkRG04MWg2RHpmUE1i?=
 =?utf-8?B?OU1jYmtwZitrc3hlcUxKL1FBYVpiVTNzODFqbndvcnpGQnVQbjNOdCt5SG96?=
 =?utf-8?B?TVlhby94ZU9SelEyUGxNZXRXNVI2RTk1NmV5T0k2a3VBZXBjQTZIcFJvOGI4?=
 =?utf-8?B?Wmk1bnB0ZFZ1MHBqT3RRcldsNE9KdzQxa0pwQW1CVGR1bnlQUDNzNDRxaGE4?=
 =?utf-8?B?TUN1WjhsV3ZVZkZzMFllMHpycUdqRnlUSG9TTVVOUHlnQml6UzcwZjhZYTYr?=
 =?utf-8?B?SDJ0OC85UjhTbjhJb3RRUUdRZUUrUFp0K3ZmeVdXTkZobVFvV2NuMXhiZGFP?=
 =?utf-8?B?NlpyOCs3QS9rRzJ1dk1wcm1aNjZrRk5kRC9BOEtwUHZ0ZlJidDZaVG1GdWpZ?=
 =?utf-8?B?cit4YS9DY3lBaHdZdmFDUm9jUmtzbytSSXd3ekkxK1hZNE96SDZuQWppNWZB?=
 =?utf-8?B?eTZZOXZlZTR0NkhodGh4akE3SnBYbEFHRXdlb3lqUitXaGYvVUF1eC8ySXRo?=
 =?utf-8?B?OEtIZnhxN1RkaXBhdWNwZFNUV2RyQVEyUUN2NW05dWkvYmJoRjhoTXphM084?=
 =?utf-8?B?SFNkZnVLQitzdzZPK3grVGdPdExFVUs5MGRFREp0Z3Y3TGkrd0RsclcrZHlB?=
 =?utf-8?B?OVR6QlVnWk9ab1ZBL2lUNFVuTXdTaGdZK09HbURaM0tyRk9La3hlaDlOTysv?=
 =?utf-8?B?ays1N29uSG1ORktaS2JablB1a2taYkFlUUdmNzRmc2NYeEZwQitnVXF6Rktx?=
 =?utf-8?B?d0lhTDFsWXo5TjFsZkJwbkRkaEtOR1pOZ2JZQk9XNUttL2toUkZmYXV4d1My?=
 =?utf-8?B?MVRQa29Nam5rS00vOVJZWjdEKzJFSE12LzIrMldCR2pMcHNJZlZyT1QzQWxM?=
 =?utf-8?B?Sm90azl0ci9PZGJuNnFyQlMySEo2SzRXUE52amJGZWs5WDBncDFuNWNKUkJN?=
 =?utf-8?B?dzZhblNFZGtqb2FqSWtEbnRUTmswYkp5VFZkWndGODd1aENQTmZpREZleWpm?=
 =?utf-8?Q?9wpf6G7/j0xdwt6+Ma1pI8QJlf+DBjqCg4K/WC6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e113acff-4ce6-443d-4d90-08d97731eefa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:19.7912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyHi6ChMCMUjc4SLig43+thkW5hxjPYYfecIXx73Rv8kpBL17MbwV93MwJjJT78uwpJOo9fchxrh21C8QdS6r1t3STE2GjwIfdmKyIFC7Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=985 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: -48xFlA6q05I8FFmgAX01dkP0RCEnyNG
X-Proofpoint-GUID: -48xFlA6q05I8FFmgAX01dkP0RCEnyNG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2021 16:55:31 -0700, Nathan Chancellor wrote:

> Clang + -Wimplicit-fallthrough warns:
> 
> drivers/scsi/st.c:3831:2: warning: unannotated fall-through between
> switch labels [-Wimplicit-fallthrough]
>         default:
>         ^
> drivers/scsi/st.c:3831:2: note: insert 'break;' to avoid fall-through
>         default:
>         ^
>         break;
> 1 warning generated.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: st: Add missing break in switch statement in st_ioctl()
      https://git.kernel.org/mkp/scsi/c/6a2ea0d34af1

-- 
Martin K. Petersen	Oracle Linux Engineering
