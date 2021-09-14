Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F940C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624DD60F11
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 04:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbhINEGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:06:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:26204 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbhINEGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 00:06:53 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXvj5008709;
        Tue, 14 Sep 2021 04:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EL4lmwaU1NJcLd+T9Qyz0A36zAaL9jPg+cNc0jJdjjk=;
 b=l6oGrQJKvWS1WaOcg8JHHOsIpGOruV0vHupaJk92wHpMq19aMDFE9qe6OxzNRfLqWzY1
 P/HncBnWct18OFGgIpJWOQX78CPWuzGmiLVNXqRhwtKvmvDDqpZcz8HCDrmfxLGZbJ8+
 sp8sueJg7MNZ79G1Gi+1QFHix7IbKNnd/Orw8N8kldiAvZQKo+l4ewVGGXdLKpiQrLHl
 pYgaPLbw+NUaaGQWIa0XkRkejvMQfNX4zY3QQLbxTA2dR6NlLW7tTrl/9XYEml+wBJK1
 VBRIOHn8+pu77plY3aaTyDCrdtUMEcLftaiBH3OI1LHe/6s2QvLeJ1Od0+4qzuJU0fhK ZQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EL4lmwaU1NJcLd+T9Qyz0A36zAaL9jPg+cNc0jJdjjk=;
 b=0Liw2pJTXhuFQx3obmJpqaFbaN7N4u4lFl2cdL8ln2fCxqsQwmUbKX1PHR8OH7cx/x6Z
 NpryL+KEYC/3CkqfMFV0f7jzNiUWEPuU6eq0fS0POENHksV0mHS/vL9HrUZ+ao1ww3cS
 zAnp73PLlCWhlKmZ4cUmsCVJ+yRD6XUo6yKRA0GRsMgUetSUTvYrubAWW6tLHiSSfzP8
 Hnekz5MVm8D/FfIVgWTVWnHUoXjQeQfa43/ip8ukIJrab7OPorLj1uKfg3Q/OYaRIr4q
 ZXl2HQizt9lpnRjVvhguH6jtE+zobhjGpiVQXcbUZeZf3c8tu2WJaMbP/sKF722rKbwy /g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sd5fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:05:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E457mQ164934;
        Tue, 14 Sep 2021 04:05:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 3b0hjufbuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 04:05:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEbNw3IMAhp7rIWfgZfF16uMb9OjqzvfNEt8Tj3FdYlgUBfNxbNHBi2nWAlF+ZeBNxmDZIuyQ0ubNIPUAc7pl8G5V6vjJe/jz5lrnIBHjHQ/ZXE816LmZReQWrY0n1E+bBZQacJ722FLqXl2flFd172tMpNUO96uSMDSBlrGmjrLEHI457oKa4gWBnLdjaMLiYokz+RQsGYEJMxF3PaIaieCZRukvGB+PZ2w9eztHLVIan/j7BrTnmQDKLT9WKpex1DjKfwJ7Gt+042a5EW7CeF7LIXv4jAfjLcl+CV3ENNWjuqZU7PjIHvNQXRJBRWrV7CwJzS9ge58t4YMjP7WCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=EL4lmwaU1NJcLd+T9Qyz0A36zAaL9jPg+cNc0jJdjjk=;
 b=Gkrln55nRARpGR9slxKHCEPjSQrvOOh/zMVvMPlP6e2/aWbDDCGUQ/diiNay4QVNX5fFbwS1rhCpXUEgmJIoD3fyBoqPUBQXtpK/IjpCrSqe/PsiAO7d9u/2vILPGFbLdNIdy9Tp1NvKwTFegSoZrIj54htCapxj1gvHsSKomjxGr3rlPDa6FI3B6vTc6ngqDcBfJKWZ2NTv0NxSIxFWMNArE6DoneJy48amEy0qMFK7tYx/klCLMGblkJEX/Vo03bMy1zJcnqgxNOsKv37FUbVob1X8lh91H6whCQ07TCczJ2IATMAz+hXfOa5MOaw1uARWUc87IhWeEUtrK8KCXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EL4lmwaU1NJcLd+T9Qyz0A36zAaL9jPg+cNc0jJdjjk=;
 b=x8JwubDvSPRC16i/NkEF3B5Q13HdrNOGR7NX12pkeuWY/uOi6VCWA10bIOxe3pqPslCB3X92wcJL7ut1PaaXbdiPdQ4xGFGZ3b9pFg900vOUiw8FrnM33S101rra2KOHyG+/GqDDBxil2cXk9uCHD0wQ4Wi+B5g+TXkZcU2rhi8=
Authentication-Results: sangfor.com.cn; dkim=none (message not signed)
 header.d=none;sangfor.com.cn; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 04:05:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 04:05:22 +0000
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     lduncan@suse.com, cleech@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi: move init ehwait to
 iscsi_session_setup()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq18rzzztsa.fsf@ca-mkp.ca.oracle.com>
References: <20210911135159.20543-1-dinghui@sangfor.com.cn>
Date:   Tue, 14 Sep 2021 00:05:20 -0400
In-Reply-To: <20210911135159.20543-1-dinghui@sangfor.com.cn> (Ding Hui's
        message of "Sat, 11 Sep 2021 21:51:59 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0017.namprd12.prod.outlook.com
 (2603:10b6:806:6f::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.7) by SA0PR12CA0017.namprd12.prod.outlook.com (2603:10b6:806:6f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 04:05:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58716438-4cab-4a76-0d92-08d97734df61
X-MS-TrafficTypeDiagnostic: PH0PR10MB4693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46934BD540FEB8A411400F398EDA9@PH0PR10MB4693.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aR4c9eYja4DpgimrRmdSz6mEf58HdZ/qR1NuXTI4ppja4QHQUnyewe0+QCVbuz1sZNxQJcChw1nojEovD7eBaeZw2JVCWLoR7Rux7laxyxcOPEfuds3ajIcdfmH7Z/NP2DPscqNWEKYaM99GBMTXYIwv26ATmVWFzvNRRdxZacr8Jfzhihz5FlE2OMcgVRwmWOSa3Ig6EJvEZ4AU9vxIhB5LU3LYsWC1hzLxhVBsaFrko6a9iIVp/MRK4vRr4cZmxBqF0jR8nTh4zdd8t1CHw11wk2ZzjHr4YPnwMUfXJ8oJthwPLwz587t0eVRi69hA/3HAvvgz6Ll9UB0THTDu+Q7AQFJyyokcDllvmafSn7kcqyNssjiSjgP+iUk9mNez4AV+RtfgbEM38swj4QspANz5gRR8wK4j/Ejn2SduXygX5xP4CBNu2S+W6mssmTPdjKuD7KIyLWuAM9SUlhuNZqixbmtEIzOhl/A4Kf9GugwKCyCfAsJ9yleeM6fa2FJ/dEPWfrm4MiMVoOiVDczQYre5IBdRitSzZZobRFYgqQ9PvRcq1094ibK4nG2lpuAoo9pDkCh0a3bpZUMvKGCXh1WVfR60R8Xkc1gZPEXNRF741BbvT4yIOYp8O/VtICbt+rLzdIXMRi68gc3GfZDdwugknYeOB9xOF0ECHrJ7HCb6IIcWE1hr7gYNiYEKF2+E0jxUvFlKmxbtt7WfyeHWxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(376002)(366004)(136003)(86362001)(8676002)(26005)(36916002)(5660300002)(186003)(4326008)(478600001)(316002)(2906002)(4744005)(956004)(38350700002)(7696005)(55016002)(6916009)(66946007)(8936002)(66556008)(66476007)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xqja52klo5CDHznsrOMt3nyd+ZnXHvoiZ8ZQ2RpnQgAUNk44EuPJ4FXhaHPc?=
 =?us-ascii?Q?iZK1sy9vIdEE2qAa0BRjF7dF78R9m8glolJPnDuvK4AUZ6qWFLL3ad0nyJUj?=
 =?us-ascii?Q?dLz/VjO4s36DjShXwJ1zi7CtpEwJOaBue0AMpKeunv+9pg0mOfjUwwyFV5RL?=
 =?us-ascii?Q?8h7EpebNi4Hr+zL1y3c5AWG9ruEEJxWR8IooT68i6L8qZ2WHy7gx6Cy7WasX?=
 =?us-ascii?Q?o/It+zheWqK2a9udslUBJ0ON3GowMqMwZ2ox3kyw2aSgyzRf9E/0WRnUBrLd?=
 =?us-ascii?Q?7ccXgVyZXvlm6PTUmRhyRfCO4CeN0rt9w1Jt081I/SpiwbUCbmQiEbjRsxRs?=
 =?us-ascii?Q?XSLrs98VL/h6fEuzX+sKRFVUvcxwt6Rm3kYNFj83FI8RvPGARluVoZK5eKU2?=
 =?us-ascii?Q?6AZLiPStHSmfxYjuWqasnK3+YGnxu97RAMDp3YGDwiIm/5E0EmFO78nkcob7?=
 =?us-ascii?Q?ov9N2Vr5/ZBcrocVkiFU3w3ilubRlGAtpAZ0qqBaqAxqKtaZAg89wsLgw4po?=
 =?us-ascii?Q?3kbM3Ii0u0YXiHLRsrG5NcsOaYywSveOVxVIsnJQ9/ORhmVMUGRvnXt/PE2D?=
 =?us-ascii?Q?bEzodJ8mxOplhTfKpQ7ogIgfcQUU1mX3ZNXdEKzrTC8IdP/QR56Zi3Leagwk?=
 =?us-ascii?Q?KLsvqADW6Lnu6BRv+/jyfCSExh5YvwVDzZ6v2GcRvmEDBHSMYHCUcuYXQP4q?=
 =?us-ascii?Q?KH70NZYga5ja8WN4zKQ7bHyQK8+IOJFi3bvOcd5XUWRNX2Fldr0q0r+sP7QN?=
 =?us-ascii?Q?tgIFnFUU6mu0LEGWCZ2+08TP0fKRgdaa9mYJBMztXcyysG0Hr7Dp8W3udxdi?=
 =?us-ascii?Q?6A4gh2l4ZdVwUk7anunZ/TTAvQcaiHo+ss2aSjjNDzWKDd+ODmdNwPss74PN?=
 =?us-ascii?Q?ULhKcqw6ci1RwHvzy2KwzCTRImZ1qISk5zJwFvg77cxenrdrmfUl6g491f4m?=
 =?us-ascii?Q?JJSUYczIrLFbQIQuI5OzC48NaZx4iDXHo+iiWmltr76LNouzdKQMCSVtLQya?=
 =?us-ascii?Q?Q2g1lAImRmTz45nUiXutsso0EXnOcnWr+BkNX/DV17HsY33ySWHKFFPrdzTu?=
 =?us-ascii?Q?v0h3hs5GepHdo81tXw1HEqJd/mSekWimb95wIaZZEihPgH0h9j5NRs1+cdoh?=
 =?us-ascii?Q?A94nFZjNUUKMbANXRwHghANrCEgsGKe2Dh8CW5ynRRrq+Xn3soX2po7ZX5zE?=
 =?us-ascii?Q?jpjTRbIVzVutRW5kot2aOMNgQu1xTwE6e2zldEHjJYRefPC7repfHt8+TW0p?=
 =?us-ascii?Q?stzMqcIKQqWcYvgSxTrUkSYclS4TDYbMj0xmjNmWYyCkJ5uZ1OCEFdO7rfgS?=
 =?us-ascii?Q?3yf9Ky3z5lyKaJ1+6YIMNwgu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58716438-4cab-4a76-0d92-08d97734df61
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 04:05:22.0405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5U1Gv1zsNXo0qTMWQF7i6lDe/7oIzS91xTWU1SVpMadXwonywH1IdBjF+9JWxVyRYnhZllwVBemXRdgGz9Ir6Zyi9O34bwloW35dzIJ/xCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4693
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140023
X-Proofpoint-ORIG-GUID: usHY-KeTFbd77Q_xa4FwbT5kF67ID0bO
X-Proofpoint-GUID: usHY-KeTFbd77Q_xa4FwbT5kF67ID0bO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ding,

> The commit ec29d0ac29be ("scsi: iscsi: Fix conn use after free during
> resets") move member ehwait from conn to session, but left init ehwait
> in iscsi_conn_setup().
>
> Although a session can only have 1 conn currently, it is better to do
> init ehwait in iscsi_session_setup() to prevent reinit by mistake,
> also in case we can handle multiple conns in the future.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
