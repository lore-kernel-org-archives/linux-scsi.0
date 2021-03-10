Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34E5C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF76864F83
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 02:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhCJCfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:35:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47524 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbhCJCfL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 21:35:11 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2YevV005012;
        Wed, 10 Mar 2021 02:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=7bz4zK5e1mu+KDdWtzrzEONuk9/0y5GV18NdT3oVe7o=;
 b=Y4cI59JBMOdZY6yHDTm9Wd4Wu5VcN9WIDgcc2pa+PthvH6V5XO3jqTi5CrucqdXQEjgv
 cuVcRnHlQm5CcPv+KlmPp0rReeaH+a5gCklbDDqjgRftgcB4prQC6AiKa6b2HnQriLc7
 xdQeWiiIyxXJ9CfkuOrqz0gQXFKf142UP4rz2wjgcX7r6H7nmQO4maNB4mpf4y7R+/hd
 RevC7NkJP6Ah50+Xp/OcFdIL3ohFoqBWiu1H2+qd5cfpQZ+QldZcsV8DLtSKZGem/ipY
 1qERe3ujKx3RbbJQ2DijjVwr3VYHhKI+JoBYxLUnB7FxtJEXJPsecKmQqHo87kYnBrgb 3Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3741pmhfbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:34:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A2PU4b163029;
        Wed, 10 Mar 2021 02:34:36 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 374kn09p16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 02:34:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCdeaDIe0y5QU+81RUmh960BsOUal71t8s0ZofIXzSDqoHZUfJDn5KWkjJQoXXjz0BXzEEL3eT6scP/Ocy+xaWZasYJgZI4zH9GyCo9D1Z0uEEizm34PXiQCqkgu7AdhHwkSmEnCpe8n/lYuXcJLLkQm+v2Ba7l/IWb7eCZIQTDZkbeHnaOv/oG+K8tRIhb3Qh6gi0Qk3hLoSS0LXgb/ncXYVNed2K7XkI8fZ0DHYTaN0VZoryKZn0NfNRJdUj42LB/Qh3//j71d0KAsdmqJ4OR42i9tlkrqE3SSselu/C8ATvsOKcRQkRoLz71Ts2IB7DFYeDZmAE5YJwi0zWltVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bz4zK5e1mu+KDdWtzrzEONuk9/0y5GV18NdT3oVe7o=;
 b=fm38eydYr+vdY7XHnu+XRg7CSXG64xDP81NZDC6PdBpMQD87GN9HPLW/cRzA9DIAvh0LFM4ouqVI0Cb/4S66z4qxOXT/a9OlmpIdkvk1yxZqpabu2YrG+OfV39TigohNHQgcOsOHTQ5eceZdQIixxvwXOIfx21pLB/ZjU0Xbyt4/QxOv+oMfGV7huma7aowF1MtxJDmpjddeZA1OUguy2UCWKesJwil5PbaoMnk8phPcULzFps2cLYAnsX2350BRRvnJRJZGq7FM1Z2NeXXoEGs7YDU/zltRq8OTbxegH2XbUf2opksqGsROahnZdghu+VEhz3AlytfoJh2v1j9hVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bz4zK5e1mu+KDdWtzrzEONuk9/0y5GV18NdT3oVe7o=;
 b=pGivDdJteWbsGqLgZ/kVJCF3wTOLPtTSeIart51iSABst7SL5vZmuoZlsN96+CG99UbQgE8D9eppY064r1mK19OeGzs91dnCMFQrCpH6u2oIiq8ycwyUgiw002B+jcgqLPTyv5ack1MfLGPzg1iTIRrycyJkQzF+NPsxmzvQeMw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4710.namprd10.prod.outlook.com (2603:10b6:510:3e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18; Wed, 10 Mar
 2021 02:34:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 02:34:34 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with
 XArray
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg53buu6.fsf@ca-mkp.ca.oracle.com>
References: <20210224185335.13844-1-bostroesser@gmail.com>
Date:   Tue, 09 Mar 2021 21:34:31 -0500
In-Reply-To: <20210224185335.13844-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Wed, 24 Feb 2021 19:53:33 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR05CA0088.namprd05.prod.outlook.com
 (2603:10b6:a03:332::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR05CA0088.namprd05.prod.outlook.com (2603:10b6:a03:332::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Wed, 10 Mar 2021 02:34:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1258185-c8fd-45a8-ac5f-08d8e36d0ad3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4710:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB471027D7323E4B68DBA20E718E919@PH0PR10MB4710.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hnqx15QBVEct5us+NrZaR8YFbzOW+2UhlQ69X/riBZtSVTWUf6/uTLkkFGszkWrup3UpJUO+PuLRY7AT9myHmBsFZ39/z3caeSrPk0hBfSMjGz6rzo+UgLe2z6dRM7b+dtDzFtvbe4siDAbcfz/KdE+otkCye0DxjN37cIJBaZxpB0/WVonxJEmzBpofz0sUAtP5FZnDgXKcemG5QBzgPZtaR+CyiFzRmNTK7sUBiMxcLObTDeq6Z/5q6nKJ5YtSKfCNUA87nkwKDMyKO3jCAbVLzwtEnn0rRGmqcIR5GJzJJH1aNjXqDGeERcjbV3QyYy0c+B5QY9udAb0AgRylqF/JAM9Gcn7UzoNPGysihrAVn4WebHDQNepDrZ8I2f2HNDtW4CrJ3jt6krDWgxn8dUiFK3o6NUFbZ7srIy26glaVWLF7NOAFUphejyuPFx8N4oAl9xdo4GULQNpP0io6M4Bjl6bPB9a2Uo21EyFWitExcyIbN+OFH6A6+spPaKQQy5XODE2WDbRiAqelbYDDVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(4326008)(4744005)(86362001)(52116002)(2906002)(8936002)(5660300002)(36916002)(66556008)(7696005)(6916009)(55016002)(66476007)(66946007)(26005)(6666004)(316002)(16526019)(54906003)(478600001)(956004)(186003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cLkVRs8+7G6inml867nC7S6rrEPcuz6txgad18TtgbeTB1BaodQ59Gy41T1N?=
 =?us-ascii?Q?R2DERjwlEK25G9ciIsY4MQzhJsQjlpQW4ei3PBVr0guZ0rQTTG0B1UikiFgd?=
 =?us-ascii?Q?nSgq2m5ViDZR0PpqLgH7YeFOMzcqDnVR7kJKHQJZ76B8ISvJFHrAPaxHjcG/?=
 =?us-ascii?Q?j9PZlhXiukP/7AJvN5JupSgsuYQUMvSIP6ykg0KxYWnS4KKuzkcKlAXBC30f?=
 =?us-ascii?Q?+9ITglxwDKvSkhPI3BwFpgTMk2RV/wWAXxLXKRnvXjX2P/KDgF28WTwKuf3r?=
 =?us-ascii?Q?wDlce1HoPGhojERn/FSnNAtkOBVmgR3KJcIQ0Jp6Dg8VgUy96DjfHxacuwvS?=
 =?us-ascii?Q?6CpmkMhPcJUoDGQut9p0M3QG6E+/hows5APdWFCnPNKVCCvX1EVDR08YbuLP?=
 =?us-ascii?Q?5ehPEZ1MZyWgusY3UZJXIrXKQC2iLajBRMbp4zq9S+wBe2/rI+KOKTkn0p9L?=
 =?us-ascii?Q?6naeVtz/qUx4pF04Yq/OMFaEO7mtCWkKTzIiqddDTrWmQYt9lz0Y45cn9GtU?=
 =?us-ascii?Q?lnQRrTFLRY8QMkWsnAXVxJDuJBbjmjiz+QUNUa8NaqWQRu81fr8NZt+Q3S/O?=
 =?us-ascii?Q?wFoSMnlhYZqs4XvkHAwF4HKbwq0NuZPNyM4Iy24MeWm9vkl5xE/vf/KfQAIs?=
 =?us-ascii?Q?RvvDKlhCFWWrooqxtouZcfqFCbUu4pl6T272fl5yiTJtxipHGM95Y4H7BY6c?=
 =?us-ascii?Q?rcvstjIXFkMN+E0aFir0YdFEKuLq7znOs0k2XdjlCObj82GEJAznyFYSKnLQ?=
 =?us-ascii?Q?WkAHKrM8yUCLIlTol/5Dj+UTlgtuTYfHcx03NjPM3PJDHtDjvZVzEa+A8Uk5?=
 =?us-ascii?Q?bbXveI0yrd7MBcslxr/SutOrb4ExdeaOyj4K55PKm77eUNR2j0+Eeh5g5oW4?=
 =?us-ascii?Q?ILL2q5MoxdGgj5uXujAOG8ba3bNfvt4qLyOJNyG7R0a6EQrF5i6OOo/9HcaF?=
 =?us-ascii?Q?5QvgailQvQghmzEWTm7aU2tLoUmZr2agnpikDUTJTLQ7fO/5C6rOJzqkZTDa?=
 =?us-ascii?Q?0jK/6YohJ9hk+OiCQptHuYjcDM+81csMzrVKcIi+FjW33i+8jp8NZlalqgZP?=
 =?us-ascii?Q?tZJ/4sQLbwMeJDK/ff8/naSE+L8tmZMtST2opOFPzQSgf68ZPFDkOGHFZvEh?=
 =?us-ascii?Q?t1oavtDa3M8Ztw/Q2bBjyR6RrqVOya89B27wAnZhvqhJ7jCFR80WF9iR3u1K?=
 =?us-ascii?Q?YOJkeWvNuww9NovUDZ1LtG4lXHXa+0UMtbGlACY/LZtdvZgK68qwHylUnWAW?=
 =?us-ascii?Q?O7FRgQAw86QbffI22ItmZPKnaupRHdkWKyiH33l7LTzo6Q5vRilAFJ243SQm?=
 =?us-ascii?Q?ROTPHORcULsrUCQDhoT+EjKm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1258185-c8fd-45a8-ac5f-08d8e36d0ad3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 02:34:34.7083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aY64KARkpPTBUBPE4XgeDvTwBW0kv31bQLP4r234CFmdfMzI0ZLqn1YXVB7QwtBktxy/fERqQ/hKcgxgXeOV2mvz6FpR9GcVT1CfUqIRwIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4710
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100010
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 priorityscore=1501 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100011
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> Future patches will need something like the - meanwhile removed -
> radix_tree_for_each_contig macro.  Since general direction is to use
> xarray as replacement for radix_tree and IDR, instead of
> re-introducing or open coding the removed macro, with this series we
> switch over to xarray API.  Based on xarray a future patch easily can
> implement an analog to radix_tree_for_each_contig.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
