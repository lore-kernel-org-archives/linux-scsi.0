Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9968AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 03:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242265AbiC3DYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 23:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242255AbiC3DYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 23:24:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B879D0D5
        for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2022 20:22:55 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22TKminl011958;
        Wed, 30 Mar 2022 03:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OSXs/WCEsxZQho65LFZiN9bf97fkMwV2tabm0kJEL6w=;
 b=Fwas8xBR0rvj6F9okPEVtDryn5s7SiLbAzYctvs+rks8OcG4cOm45NdMx0b8dQ2D7DeE
 blUHNtvWcHy8azcFptJ05y+5O/wyhm+EgpKvAdYiQUnllDVBFp4FGQ9rNwL4NI6/IL4d
 0dCOSt4R19bnsjdsHPs9jdGHPv1NamUtdytmHV9to9J6l1UKYqK4+DsDumX4kE19/Iy7
 Ikifnz87k6LC3yOE+oRZCKpjcFEtlPnA/d9JFD6RqjnklDwzFNB3IxsVHnwy9xLb1IN6
 1M+8Ml1kfofvd7qp8tKTePL8B0wzk0KOVkXCDfqJY9Y3wZl6ByaWOrydHwMy0vdGYFbo Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2ga2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:22:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22U3Gat7035546;
        Wed, 30 Mar 2022 03:22:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3020.oracle.com with ESMTP id 3f1v9fjtqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 03:22:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OePAbFOtxxjhZI0/BA7yDXoe1T0waKWNYlp/8oziwPQk5i4mnhm3sb5JYpoPHMKKD8+6Gl+H6UaRfYanRESBWjeDEtLNberc+hFHYN9k3+wLZ+fhuQx1abwSqLsNZcyZqAKteFvaQG020aVUPafndmddSsed2lEXUoiTgU94kOTacjLHCkLYwk/6VwCYEoP8hlkA/D8IY8bDoMrAF45Qf88RMP9VzfsIO1V3UyyAYxjbLgT+QLIObiGJFSexihBZdagqUeIDr2DN7DFfpkeWYPjwz+P+l0+48MZN+TzzxMjTT32JWDAr8izXZG3JE0alHZCojTy7X1hUQ+I0yOcr6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSXs/WCEsxZQho65LFZiN9bf97fkMwV2tabm0kJEL6w=;
 b=Ra2eBl409TUjSp/c3RX6S+jxFXX/W/mER89LHHkfn5DJ+W8f3i6E7nFQ3pPXXF/rNiY+Uz9578KLxIyzXijck2/+W0FdZWJQH9zBSdCh6b74g158Q+Aan4YFji3A4cWhw8QTh4bSX6rdf4ncn79UxvvrheAjGSu3wiN79hn9fgHy/WtKLTSA9AOzXNzXtzQI3VkLaSEjqrUmyJazc06/MpBvuduQUndgrD6YAefhBXpV3ifRgOf1M6b6tmTqWTBhLl36Xc3CrFLgCrNh9ePGXqakuzHSRiHlET22XvhVYEd23CAIdJBWIxqODgYUVBpOMddKKJ46i33iSB5tTrcJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSXs/WCEsxZQho65LFZiN9bf97fkMwV2tabm0kJEL6w=;
 b=kg7zfJFasACeFc8wr9YMFZt1vo/v1vukYMOSOhrEJMhXpk9nT0YtGQuW4TS/E4G3IqUfFMgNpN9qeK+I9y4S78vTxlsozDA/4KMY9qy6IFzbVz8frSRNOOEIwMYv4eb3bQWe/qefxMXu4tqYL9o5EEsOYuMp08OI1m24ZEjrW1Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2645.namprd10.prod.outlook.com (2603:10b6:a02:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 30 Mar
 2022 03:22:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::48e3:d153:6df4:fbed%4]) with mapi id 15.20.5102.023; Wed, 30 Mar 2022
 03:22:50 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] lpfc: Fix regressions in 14.2.0.0 refactoring
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ilrww2da.fsf@ca-mkp.ca.oracle.com>
References: <20220323205545.81814-1-jsmart2021@gmail.com>
Date:   Tue, 29 Mar 2022 23:22:48 -0400
In-Reply-To: <20220323205545.81814-1-jsmart2021@gmail.com> (James Smart's
        message of "Wed, 23 Mar 2022 13:55:43 -0700")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0323.namprd03.prod.outlook.com
 (2603:10b6:8:2b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d299043-661c-4aaf-130c-08da11fc921c
X-MS-TrafficTypeDiagnostic: BYAPR10MB2645:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB26453737D0728441568E45828E1F9@BYAPR10MB2645.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sDlGQ2WQ0UYj6St7Ba40cviE8tSjuXrQvtpLPaIvOjYnX6I7tvnAfg4Pou3z2qV8i/ttIZRL2BAW69ibyLgA6ym7pnuc/8I1cNwrjBTuQXucTy55U4JtMkN3C0ONqMiMGnVP833Xu+kcfwnxvAaVptuTc7fafZ4PXillY2nYbbUSuBDcAOYV1l/QcFU7t4tC7d1/qDNykugSh8fNbxHHMrHJpEaad9HXPELSdcThkQJZRrMrsmhrtiL2X138XMd5DsVdgep6jT1nnPi1BDG/EKAYbIu3aW+OIX64D2MjG46EuPof+CKCTPvEu+AU/pYq9YMFr4F//tBPlvkjBPPZS/NsKJQkXUmLLxG36NfhdEYq6FCZtC3pRn7wozPzSDL6YfNXhUbTQkPDTWrr+V9PGdHv8H3asKRoQpQWy0qkS7Oa9VbR4lMzoJ3y6FyqrlTR3UslZxKeJlrGFeAUGcHOUnIS7iO9QcZylAoSrZlRSTDfQALRw0y1BXVME5jbUBF2k5dqZMBut+8pBncq1ByyB8w6BleW2a2xRQomvITaTlRky+DTK9KUGNtkzttMX/9HNUW/i6u6Fi7ilnPUbTh78YFqzaPVzPHFnObKsqnAqoSa8qcJ7bkvOuf2nZA6YcKvjvF+xNxV1TZlxQb+8qmv2y3mLb5WZM1WRKVWikMXVxhkusnxZyZLcyGAN96tjScnhqlL4Dubzy+x9PLE3pYDQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(508600001)(6486002)(8676002)(5660300002)(86362001)(6916009)(36916002)(66476007)(38350700002)(26005)(316002)(38100700002)(6506007)(66556008)(558084003)(186003)(2906002)(4326008)(6512007)(52116002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ox/tAM+gV2lCj97KbMsxxz3rLA3GTn+2py1TFW3PPWItphQhdIKyXMlaGbLp?=
 =?us-ascii?Q?CKOLi+rEsjcZVcsHh6OfrZ/e6IZT63HNAJofJv9WYGTonf1OH9OuVV0jqs0R?=
 =?us-ascii?Q?R3q5KuLahCau6JWYh8Ma6V2mZZ7R1brexb4Di9xKHwKIhB71NHb1I7Rbzi0b?=
 =?us-ascii?Q?8pVMRG44tI+dL7gcaX/ld8OO2r0pbiHkdLJxbkaGdAXfb2xE+J1DGbZLg/ub?=
 =?us-ascii?Q?OrmhzYQVbnU6GNe9rJtCx2Rc7tO5khFV9g93buRPq3/wBIH9EsmXvmpvDdb5?=
 =?us-ascii?Q?73gTdXcRW59mHPLrxBpZSiNCU0xcjRPfw+IMJyIObRyAKPBevc91aApiSLoW?=
 =?us-ascii?Q?HtnOV6TmJTeh5fmNBhhKkO/sPSjGdNnPmrtrOHSdhLMoeo5Ha6lbz63Xx6qI?=
 =?us-ascii?Q?oHrNRhwERriv6r0FhJzgdki9t8TKMSEticvSospHCYnA9p07FZbAb4sNfj7S?=
 =?us-ascii?Q?zwFJH2eUDlAx78HQeryFAQNFnu+Gx9PfjPoKKnIi3XMwtnDKkl9SRZR10D8U?=
 =?us-ascii?Q?JCzwMeCYElpwJLMY/cfupIPFSNu6KhmfBKl4lpRzzyzeVMERlF+pdsGP8BYT?=
 =?us-ascii?Q?On8vT7LvKz2jzl2PcedmN/kmPXiLwdJgmqS4zhnevZZOcb6oqZUgN3e5HlC4?=
 =?us-ascii?Q?+TJoG7X35hZrhsD2RtVZewcXOzd5F+vkFbBklW2xX/lpG0ASwI6i7CdjNxeJ?=
 =?us-ascii?Q?LCxTsIWHNM1OwMWQbO/SMmg6clvQOIfSVWhFORuS9wrNSwupiMRfoPHxnT1Z?=
 =?us-ascii?Q?yW5IbaygDXEl84P9RpTgYbQpEIJG+ZWETUxm8LslXpgVyJQlFxTzWze9ojD7?=
 =?us-ascii?Q?R4eX+NErOpPVtJ8NuRos++NOx5MKBSLSascJya8hY3BOvlDHJREfTwTj/Beu?=
 =?us-ascii?Q?U5WI9bXnj0Av1WGTUqH0yp5ZLo5IehCgeim23c5If2tiXXgFxIv17ayaMGYH?=
 =?us-ascii?Q?6jF+4H2KVWOtexutGiosStCAt6IjoIBwxvJgIOvEN9Q9KS/YUXbqYWeMgYvH?=
 =?us-ascii?Q?xUcMnwgV9M2D+rvue+icvlXOg05OtkDu85G8Vhgm2FQDI0enlSWPwttAaZo8?=
 =?us-ascii?Q?sZ0TcjuvnyNYSdb99uDSySzXDT9CAimbiP+wd8vMvi3wOwlJtJCW63D2NZzy?=
 =?us-ascii?Q?Xq+f5Cq64sakNXuTjb7x6UW5Xflg3v8mmwAv2INEEFEaGMHIQAP3IDGvm+bs?=
 =?us-ascii?Q?StnS7wcFINxT1+GHKH1udGMTSHBjXkAXHSVKyaoqPY+W3CAWlkylnisk4uLm?=
 =?us-ascii?Q?F864WJcF9biLZdo1lKg2cEG5oEBbwVH6YDX2PhJ79Ngy3ZpGFERw09RufS6s?=
 =?us-ascii?Q?giJs6kW73GDYa99NvTIT2/WBRPwJfzyKadIR6Wnb1lCqxuYDk3PZZuTqqg8K?=
 =?us-ascii?Q?Yv3bdVtj12XGjxwfLIE97KsTIICFMYqUnPTO7icE9HlgMGkkQrppUkRjwlrj?=
 =?us-ascii?Q?5QOfNKOKoE0DIkog1nNUSx/VkVGXJPQbbAEveyY5KQ8AUuM3mpfyb+Bgwh3L?=
 =?us-ascii?Q?9kMKSka3/1kJrW4F4KPCt8iHaHbeMIhmqT+hrTNwaz/gr+3ZcYsqkdifbV1E?=
 =?us-ascii?Q?34+umVgFGGJoG2OrBzR9Wy2Y1mRg8Cnmx6RN6Q48fF7AxIKZsvF0elIdqcUB?=
 =?us-ascii?Q?7J75NZN6A6pFPKBFX24E1qUUDHlnRDO49LIXMmWEI9MLs2GtubxN986MsIWp?=
 =?us-ascii?Q?iph10M33WOVn7U3pFBfhNS1fuvuPIt5JPCm6ZVkfmxVm4I79EdfQsJYOJnlA?=
 =?us-ascii?Q?YK3voQcqsg5o9qBE9KIX3mFm64yGi4k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d299043-661c-4aaf-130c-08da11fc921c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:22:50.8184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +vrub5DVL9+87VKoPXVBimT5FVfckZsW0d6Z8h6Yj2OffxpCLApHImMS9CtvgIWLbvY4IH4gq7moE1/1cgR1TKOIGDbfjunClM9tbPM6mK0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2645
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10301 signatures=695566
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=749 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300014
X-Proofpoint-ORIG-GUID: m3V_ZmRle3scHnRAhZpz9cK87tkFm-pW
X-Proofpoint-GUID: m3V_ZmRle3scHnRAhZpz9cK87tkFm-pW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Two regressions were found in further testing of the refactoring
> work done for the 14.2.0.0 driver rev.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
