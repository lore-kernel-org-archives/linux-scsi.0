Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C105C49EA2
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74114613B6
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFPDva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:57990 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230515AbhFPDv1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:27 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3kaWx017184;
        Wed, 16 Jun 2021 03:49:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4o93UdE8GJeNS9iC9R+PtqQQXQWQqvyClP0bya1sQQI=;
 b=Kvx+5eu2gu82pVe9v5N4NwwFkGtOZXZIP9zM3fg6DmL6JFLjJ4svk8/xC++zc1OdSFUz
 AlZjJuFuTEPYTbKb2fiA6y3VKR6HpjpKrt/IDZZop+fIw1xXklmKB1NW1ZUk7oahFPpu
 8RyfEM2elhZoWkhiNG2YCOoopchWmGaMBpm9SoH1R7JVw4U78oESChomKSN6G7bpznlQ
 2iTnpet/eKCdS9zjgpOL4pUys+wvc5hI6ECVVJ93SM7I12+zU4PotYGOL2C4hPlrZpGK
 lxmhbjxx8BIVbxqF2ptkfqLnJ8HXlb8AoUXmTNO40iFTobRqv8TVRm5jQXzlpE1+IiLt xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1ksubt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3jFJX147416;
        Wed, 16 Jun 2021 03:49:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 396watxnr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlhHX+6I3j3x6B72v3a3bQrBDMTk6ssQc8odjkKyePQvs4zu58nsqYxiUFMhZ2Pcs1TJ3uasRtDdZxWjrO43hFOWsUQkKY4RVt5f6oxp1ZcOCgqb/n9h5Kp/5hA9YL7o69j4syKNsTcBJKS4GUdTuCnos6Fp61DHRBdD2l3MN9eIeFLliWGmJ5CUYQo1MgzJy+gYHa6JiYtVJV8QP8uttHrPk68YmQQud29N+ihnf7YsEeZykwveetqacUvWoG6NQfN/ULDqIr620Wp01lp+DGAMpj8NoxySxqHPlM19GDHZ0xvNKNHvNynOO4nvV9Dp2PnCSzrmui7fpIWl2APY5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o93UdE8GJeNS9iC9R+PtqQQXQWQqvyClP0bya1sQQI=;
 b=NNZQQrExXF8OZ+bTtYHbbSFRmKlrEtm47j27Zl/NzJqi1gmrniG6chXOPCLpgq/ShUTB6ClGXtNB3/tG7k6UF3MaL1j0bdLNi7xQwxDpZeXj0ASotyIvk6jHO0bcL6u/7ZrC9EhTdz9ukIdiomFBffTka/h7PPsZdkk2r4L9IzxLFR2Ez9JLkbcjJ7ArkSukzZQjfx5W4xtTsFxZs3r1JKPF6TRivilde/3I1PuC5fOgkNJ28B0UGOrT6V6azR0aO458+PqoRYyNlGQIaoxMb3scFyQp92U8zfrCoXOytesUI/RUPjy1Bb1RCx6z3YUufa9uep63Ocm6Uj6XcW0GdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4o93UdE8GJeNS9iC9R+PtqQQXQWQqvyClP0bya1sQQI=;
 b=QurTcsOWBAO0gqMmKV6i1HIZdLvXmqxCennKKLte0nuWQ0ak/evb9vyOaXnbOtZJMRrkldT70iL3hWUNznwvVCKKJl8rMRr2zShc3kgptEzaeyK7p54Todtwd7DNjW679i5rOy5mrDWGbeUGVPir2mZauBGdlcUS0+XwgslMFpE=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpi3mr: Fix fall-through warning for Clang
Date:   Tue, 15 Jun 2021 23:48:54 -0400
Message-Id: <162381524895.11966.1300969003907939445.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210604023530.GA180997@embeddedor>
References: <20210604023530.GA180997@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66c5c3b0-3453-42d3-8c99-08d93079b762
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466336EC207026456F59729E8E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +2TBwzd0m9gbUSIAUEU0j+FzAhqmaRCq1tdP1+STsqibuaeJ39W8EeAyR/nE+wO/2vW3ll3hcM1uCaJ/jo5JWA9IIwDxVvG6LAAd1ryFvfvloCwRG0xh0XMz0HnQmVA0BxKu+W7348VMcJoqCx3v+7Sr1Fpt01IQa4KrV7lXeKd1YBsGCVFUYu6mSdgU8USqfmP9klPEm0YFrgfeY2YpTxLrepzQT4wUAJgAKOKGXcktI4Rkc+3oT3sZ55qKEm3mW6DplQ3tUTOWX/eSSr5/l+3hwKf0pps01Ywy7jf5L/eDTWB0cfbVmvoDN8gqDA4ewaG6uqgMb4HPWsMohOSdRu8ZtKWItkJTDHVdfs1rQecLwlmGh/RXnoNx5lz7CELysJUVFbrvViVqkfcvcmYmmmZPNEkZCV3M0858IuqJONFAz6OfRliRvbspNpHY9DhreozVYkRxQ7RZKzV/bMHKJFfpPOsgbIB2nZAnrN9oWmlvQuXnYuUGeOSPuQ5gC1v+XnW7lBNsLTdiNL23dXgEZmzF5cVzvyyzAfQyNbZsNkwEWHhysvCnS5mVJ1pcy+pi/QLoGhwnQCW36ypXc/ZLq9Tx3+qJSM4SxrywX37CLnoX1/5vKDEim31FW3iXXbDYnHFpwnFCrsXt+4xsCA0MIb7/DVQzkNS++tmNeGzLPwxe0J/fGtGbuYLM+lLEKu4aR3GmgN/9VkQqY92YLTk5rlCUAt/r/6wb0irkpli0YRZJk510+lB8BM4epWCMh/XEw8tihGQOgZP+VSMzxppnpzlbewVnxir4/MyXpA9RMHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDlETDdoS2VjL2VkWDNmRThaRGliMGhIQUxNQUlJU2FQUzZwR09UUVNqcGVT?=
 =?utf-8?B?ak9vOG5WdWw3dDBZUENiOFdpYnlGWHZQUU1oVnpZN3FQdmlJT1kzTmJDTTQr?=
 =?utf-8?B?dXQ1MWplQnlOWmFRK3Q3bVZzSHdDc1FLSXgrUkdhRFNtdWRBUVJiOEFnTlVq?=
 =?utf-8?B?akJReFNoZUhMbHBzWmUxSHQ4TkowdUxRVmVjYzAvVVVjbkVGbGlhcGxNQUYr?=
 =?utf-8?B?eE1sV3lmd1l1TXYwYjIrenNVaGNqbFVSMUlqcFBpTTlrVmVNNWViMHhRcmxw?=
 =?utf-8?B?Qmg4N3Y3anBTTXNsMWlYWEdJZVlFUy9wZEkwdkNpejcwVUwwbVNKb3F6cDFE?=
 =?utf-8?B?dUhXdFR3TDBBNUJhQVBkVC9pbmlDMnk2aDlhNUkrejRKdWZ4ampPNCttM1FW?=
 =?utf-8?B?L055QnhnWTFJS3liQWVidnVvblZlMzk2YldibnRRQlhpUjkwRWxhd3BXbmVH?=
 =?utf-8?B?dTEvSExRTkpBV2pEWVBzbDdlQjJQK0FSbGJWQy9Za1djRU5HZ0xnc3psY09T?=
 =?utf-8?B?dDNhSnRUY3kxWHplZUdCNk9Xc1ZJaFM2bjdRcGdrMWJzQUloYzdzdGlLUUt2?=
 =?utf-8?B?RjB0bW1Cc2hEdUpDVk8xeWlRbzB6STZDaG0yYlkyK0NTRTVHNURVOVJ5VUVz?=
 =?utf-8?B?K2J0ZDBOaitoUHY2Z3JRV1JiQmZhNnNYMjJ3UW5yakRPcU8weVF5VElmSnRm?=
 =?utf-8?B?bFI0M2tBdUttNGVkSFFDTDN6Y2Q2d3dpQitqUVFHSVBod3dkZHJiTERZOFZK?=
 =?utf-8?B?d1NWNmFWODd5S0pxaE9TdW42d1IxcnZ2bXZzZHJPL0U2MlNQZVBkam5qZDYw?=
 =?utf-8?B?NlhNN0RWOWJtK2pFcCs3RnFMUUkzVFBNTWFHT1E1MXhKaXJPeU41VVRJb3pz?=
 =?utf-8?B?eVZ1YnZxR2dvQzA2SnNOQ1hTcW1ra1FkVTZsSzlEVDJJa3lIZkVoTlNXRXBi?=
 =?utf-8?B?TkdJUVQwbGd4a3ZSUVpKTVFVUDR6dHlNZjRCMXpRZG8xdmZ6STE2dExRVzBR?=
 =?utf-8?B?NUVWVlBCWlNMSjdEaUhaYlpndjViY0lZaUJRUkhzQ0FEU0daaXptZ3kvc2xi?=
 =?utf-8?B?VEJLRk9LcllFcWRwWXVtY0JCWUlTb29GNkFtVnJEVDJ2UXlGTzRkZStqZFZW?=
 =?utf-8?B?Qy9xdlpBT21GMFZXbkxMY29VZkNwbXB2TmUwT0lsVEdwajNiNitwWDJheDk5?=
 =?utf-8?B?Uk5VczI1VWxhZ1RTN0RsZ1pNM2QvaWsrLzNueTNqNks5RDVQcDRwRHFONVN1?=
 =?utf-8?B?enVPZUc2OFZBY1NmK2o4Nk8rcm1hcy9uWU55cjVNU2UwN2luYnRqMlM2L0tl?=
 =?utf-8?B?VW9MclZhOHRRRVYyVUViL2RTQ1lkUDZVaUY0WGJEYXBZeG9wQmdTNUhPZDQ3?=
 =?utf-8?B?RTY0R0xYQVJnSGdKUVNhRllBck9iN09KNCttZnpsVVpyWGF0RkVzdFJibEtW?=
 =?utf-8?B?ZEluZWxMcDRIVVpXOWhjbmNnQ2ZWK3lDZ0RRWG80OVlMYkNZSFFtdTNxYVJP?=
 =?utf-8?B?eEtPT3dtdjlXdWpldUtnbGU0Zi9lVjJXM1dyR0RJK1RSUFdWR2JPKy9kODdn?=
 =?utf-8?B?SWw2a0Y5bU1zRWxIYzF4Nk1nQjhHZXhvT3l0VENSejZvZ01hb1RaZEF1RDdP?=
 =?utf-8?B?bnFEUzNKUUQwQ1NCdDIySDFJME52ZHphM0lEczlkZUJiUTJKc09ycS9BaVYv?=
 =?utf-8?B?WXpaeHRNTGdteTIzRzNndWZUMTE5T3BONjRFR1JQQ1c5NlAyUW8vOWErK1R6?=
 =?utf-8?Q?OOPD4vKi0p+0Ge1DLj4rDEOrb9gjIBOc0zEqRIN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c5c3b0-3453-42d3-8c99-08d93079b762
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:17.7751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xTfjxsHdE62GzskC7EDYsv0MmQQNKP4X3G8P5m06vP/0g4xrJEmUmvYnYvRe5A/O5v9bLtWbhfFyf134bbFiRi8/gPCxiXOaVz0DxALmxjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=866 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: 8RWT62TIbnT-Z2Ta5n8ciOx4ac59wwrG
X-Proofpoint-GUID: 8RWT62TIbnT-Z2Ta5n8ciOx4ac59wwrG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Jun 2021 21:35:30 -0500, Gustavo A. R. Silva wrote:

> In preparation to enable -Wimplicit-fallthrough for Clang, fix a
> fall-through warning by explicitly adding a break statement instead
> of just letting the code fall through to the next case.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Fix fall-through warning for Clang
      https://git.kernel.org/mkp/scsi/c/7b8a49881b01

-- 
Martin K. Petersen	Oracle Linux Engineering
