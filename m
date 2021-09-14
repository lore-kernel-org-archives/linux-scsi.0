Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99733C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F196610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239257AbhIND7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:59:25 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38280 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238979AbhIND7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:59:24 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXwOt005122;
        Tue, 14 Sep 2021 03:57:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=8yP3z0R54woYVZJrpc4LeXJI43DFvKstUQl5CvZJEl8=;
 b=LGkm04tojHSBNsnf7snRcslmEJj0dMdVuu7diwOgpQ9allaUUiYBEBsxTkI+u6ne5GFi
 j0jPQtwvPvUR0felP/81h1S5DcnV9VetUR/Qz5v63Oh099lhfuE4D5ivO/t34HSyfQKd
 L4LbI+AUQC2SzJMeXmPG/j476ApRN0ZiNgOJG+nVKQkdYRxfBswCd/VUSxRkzSDJgkmf
 nggk4wnGUDSEhmYqwNdYXKVKGNNPb64JmzBjVFm1LCHL5i2OyDFtrQYs9mN6Yull/DLc
 GUkv+hUJB9nVdyzLav7uaCnjnvld9IIx3cGyJ1/rK4UZ6ex+oBOxMn34l/z6JH6OjKjL 8w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8yP3z0R54woYVZJrpc4LeXJI43DFvKstUQl5CvZJEl8=;
 b=oZK6B0R6n4ykIb+xJd6GRefV2gH42rmyfCmgLppJUVlGl1unz6s66jU1bl+/sdZekPz/
 tx9URhiZpZlgxOvcJkmtfRujkBOQjCRYRkliauvZB2Ve7x+rQwrgW6oUkNzOmXqVo4xO
 7gbJgkA30m4yRtwA9OhlBuMaVbK55fOHG9CRlJJaxieOY53VqK4EyXbjT5mRr9u1wAbx
 4vJ7hgHVbbCrQwhqWL/+MoWKL/mv+gKEAzdrbZPGExxHdGi2MmXffioRhO2JfrKss9Zi
 v3HoUDqXXI8kq/G2Gfy76A6ijwPrBxty6TnRzepQO8WZtS1vPKjnw5dbo4QAGLJ2zpng dw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94xjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:57:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3oLeW130190;
        Tue, 14 Sep 2021 03:57:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3020.oracle.com with ESMTP id 3b0m95nj65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:57:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz2fmV6YvZoq66zjwarq6DxGL2OvojaCzFSgJWseaxauBQl6KBLUtMDBG9sAo0uslbPtGnBFL1yuLafKU6REbvciTz5Ue+f4J5KHzikEXL+T5bDqIEPP9vZ9TEThEkeofULKzVgjcjpbkJE0dO0vKeHj3THxEtTNLqyahinMpQCw63v59RNfWrUw6xU7rNbkcvYA6ebsCEPzCxR4hLFeZgVVYpL9Qt6zueJJTLE5QKCVvoD5zAdHR3WSy64h+TbycH6MSN/DBLMq90Ew35bzYAwoxck8iQJzoUT+6fz+BPu+2lgDGLZr11KhgSshRGoKCMVBOCATyK5nh4KyEj49XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=8yP3z0R54woYVZJrpc4LeXJI43DFvKstUQl5CvZJEl8=;
 b=TVaXS/4yUZCKzJD5H7KmxAWH6sp2WYUB84GZU7Hvwn3nB6cvYAHnIzfGgjHESJDYEWBSSuHx3v0MeBPuLUigBYhw0sb28Xe0MS/Sar7dsKa7YcpBQlFyPe69ZlGZHNnBlyVOeUztB9eftUpBT6hxWTJzYYB97IP1WxIeTaaWHGBKLeF+00Cy7k3Rk06SJjqQ2InotXOkC/goReMvbbDsiILevbnhEsO2iLhEWHK1RXg2JxlgpJg7BIvDDnD0TqIucdmXAzp7IJk7Or5kV+adM1A/bfuABNRFzaRwOGIL0yCnO6INVUaFc4l53VcTAOASt74m/mpqBCcpM8haSLYqiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yP3z0R54woYVZJrpc4LeXJI43DFvKstUQl5CvZJEl8=;
 b=zWy1Pu62NCiZEij/cUBxWRm4OA1FeS+GIeC2z/CuhvSWb/Kejmjo+YsNTBlCKuyTDmpAEQB6BNE4VL5Mo6DWozEUVL29pB8/9jGJXm5TNQ7jJgOOtSBrWgzNldGM9m7RqR24MbXsGFxLChZkgTraDUFbzLoUOs30uqDE3+H2l0g=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:57:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:57:54 +0000
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: Re: [PATCH v2] scsi: libsas: co-locate exports with symbols
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee9rzu4n.fsf@ca-mkp.ca.oracle.com>
References: <1631530296-32358-1-git-send-email-john.garry@huawei.com>
Date:   Mon, 13 Sep 2021 23:57:52 -0400
In-Reply-To: <1631530296-32358-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 13 Sep 2021 18:51:36 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0160.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.7) by SJ0PR13CA0160.namprd13.prod.outlook.com (2603:10b6:a03:2c7::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.8 via Frontend Transport; Tue, 14 Sep 2021 03:57:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea0bd1e9-5e7d-4956-b3c3-08d97733d498
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54524DC062B62962EEFAFC808EDA9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+FUiYHSQosY7FDcaznMgWb8Wf+QQtGL4kkh084IEPvGfwlwed7M4bWeStwFyZVzkzqEATfCKoUK9i6nXANp+6uW/Iuv6HOUVhRpdI2MoyifloV/0jlwJrPXlXHqJtQo8tv2gsP77iNErXEBlo6Fzs2btPk5T4nomNx1iNBj2PMGxnmcR5NZKLI4tk8vDcFSGkyEenihA325kZ4OptXf1wTCVXKb1PtwAlpG0DY9XotfbPdXsXs5oIK51b6GZcnJXimI2SnM2qfNa7dvfUTXbsDW38WJRY+nxJ/cikngeuqafZgPzkMFajfCkzAkJBCHeQyWiJJr5swLUccCGOqR1uP2/GKG5THJIs9PgvPzBht3SS6WK5JeKCMEpBUL2zXGnIJg+2RbGhA25e5aPicC4tnUmsNNZ5jFe3leaiD+kgF3CtmM4FzUI2Ekd/pD3f16RW6ORfw0gMRUz0jXHHfykZaVEL4DZICZqBA1s4RwtwxHawGFOSC2sBaofy0H6QV132qbZCIZD1rUSQ2Zkq4KYd4GurukM7wMUB6kA5puYV1FbvbAzLesjWh168lJ5PCZ6I/Svm6S+MMQZFZ9m2roMvonQkrpXOXMn9WiarDVA50ObeKsT8B3cnZFsu8DYqIJIHy9adV6YIGMlNmxMVFLLbdnCoGnCLPpqY5rBbIgRI6PJjMkmZ/974fSsrMjKJjjf+82elrD8OCG0B6G9H4y9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(346002)(39860400002)(366004)(6916009)(316002)(66946007)(66476007)(956004)(38100700002)(4744005)(2906002)(186003)(54906003)(4326008)(55016002)(5660300002)(36916002)(26005)(86362001)(8936002)(8676002)(478600001)(7696005)(66556008)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c0UNdNisfJimk/RcWVR1z8i5AqoYZEqzhc/zTPM5rfd/SD2N/dNpAlA0zBGU?=
 =?us-ascii?Q?3nzUqcdmexEyOGU4WsFOybhkIGMwWFCmu8Bfdt7LINZx9KRyHneSniF0g1A0?=
 =?us-ascii?Q?W+ZVO3+9WqRWeC+/Rvbs1tAtIo/bZ1jC0sNBpoBQHAjrbPHeQU9/2uKamzEi?=
 =?us-ascii?Q?4dvNpfBWPmeSpSza0vRpNKqfGINB1a33QeIl+8Ni3zWJLA6O2NWoDNI6yIGh?=
 =?us-ascii?Q?PgDoxZLY063lNYXdZPmjqM7zqQp4f49tKo/lGZgMXDMS4EVLtMNLHK93dvML?=
 =?us-ascii?Q?As5fUQxsNsSunxswKJs/9xsJsErYgQY76nWl5GxO7yABlO5SXdweaYefL2b9?=
 =?us-ascii?Q?fX1EXPs0SGwMrN+IfoEd/q8zDeZrUz0u4wXSr4AYkvmltbJ+4mEL7TgpNQcU?=
 =?us-ascii?Q?lGSR2WdlhztFFfrTobvx4LO8eC6rUw5PAY13P0aJBVTwWVh0M3gw0Cw38n3g?=
 =?us-ascii?Q?UK4dOL323u2yNzMkKwpi93w+4QyO61LHoFD2lUDrLQyqUtnLFOpxh9WSoDH2?=
 =?us-ascii?Q?8NKnkh6kieJ4tES9URJiUXXs32HaLjOQMwfsDdFRYS3ShZfWW+xCLJEK684v?=
 =?us-ascii?Q?m7rZekvPGT/jMF97JcGD7feQXXOItiqd9mNxYTiAjZ1RIGkSecHyPMXc+1y9?=
 =?us-ascii?Q?7caaQeo5/WvZ4fk5r+/t7SL37FTkNEbpmH17NVJhA70WNxogExZ5z+5s7IzS?=
 =?us-ascii?Q?2e1nwo/l17IgMZj9rRbag8rrykMI8fdiSZ4c/RHvfDUtOez592IPrxqn2AKv?=
 =?us-ascii?Q?eQVncB0LEy2wyXy1RVfBJCGi9OGVYBC1I/jAgmZcwo5yIRJax5PMuEU0fAM4?=
 =?us-ascii?Q?8UmdI9+ahlkgyK1OTdvd4xaHKY16vBIf445sfBNwOsuBhbUxA5grHpJNemE9?=
 =?us-ascii?Q?S1CyjS07OkEVaRqrqr1YBbCGEDP0Fab7+x8o9Y0wYhhmtz4HHSzwKaOCcB/W?=
 =?us-ascii?Q?r+thbt+1poWlkigAk3Ya4sYgOsqv1p2BTUlbDnZkIk9Xa1lDoFDYL8AIhJ3A?=
 =?us-ascii?Q?cJ48b25gCT7sLA/JQveCAA1TWeBgxSC3qlE4ngp2sP+yEmUklerrawUjlw75?=
 =?us-ascii?Q?RY+DCbZIK90XFL9e8dh48EvVrKrNhkY+vEnYW6cMNUq4r2Qr0Gjo6/qci6wo?=
 =?us-ascii?Q?G/seBcM1RC9wVgLPwZyVPrCtnNfADJ5Yx6Z1c1pOUj8b8DX82+XYmqcQTYtM?=
 =?us-ascii?Q?Q+A8lEWYTumAUK0uTmo4wNiOZia6s5RyIAyqa++kKpckKqVqIWjM7d//UGvx?=
 =?us-ascii?Q?q1spqXNZenW2vP1amGpgll7l5hVy4FmGVmuzsZNWE1/q1wxqjqNNhp3K5Y5U?=
 =?us-ascii?Q?hBbE4giM9elIAlIplS62yGZA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0bd1e9-5e7d-4956-b3c3-08d97733d498
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:57:54.5083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMqQ2oCaAyz+M2rhGshp97xprek19hcWrgz9JjAoh7KSbMNpTYLvG2wYpOBpNgu1E5GPCyxgg95zdpndyPvF27wV+Qza7v/pUFcFKxfHyQU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140021
X-Proofpoint-GUID: DtYVJgKciFu9EYr75pCIeTJn7TXRuPRo
X-Proofpoint-ORIG-GUID: DtYVJgKciFu9EYr75pCIeTJn7TXRuPRo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> It is standard practice to co-locate export declarations with the symbol
> which is being exported. Or at least in the same file - see
> sas_phy_reset().
>
> Modify libsas to follow this practice consistently.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
