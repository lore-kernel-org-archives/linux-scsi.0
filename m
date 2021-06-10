Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCFFC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:05:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D63BC61403
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhFJEG7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:06:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48148 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhFJEG7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:06:59 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A44VLj124104;
        Thu, 10 Jun 2021 04:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=EgfQM+2TVDfIR1Dz403KbCJGwObAC/sZIcqWNfg/ka0=;
 b=CfzlvD1J0kfYKt12azw9/RKHIIDi41CW7W4beNpwEqs93QQzCGzzH1BTJeTdsM3a857D
 cz6MOiCFm/zDqRFcMem1oZGOZjsSJOjXkdfaf9mZgIwi//EoBpMUKQ+wkyf4hoIS0agy
 dKYFOHAc4LJkGA50P3uPB/uL6CARO0UahPvBG3PUVpEoTHhfJhP98JmA0QhYDcxLJHPZ
 nmVJzp9yCboRo0zzR0BYYevFkMi1eS8BE3ICjjc9cqa/i049KloUey96tHQS23UlQ0IU
 1iIQ1EQ3e3QN9VCE1RuUygn6q92jJDhIbd9RmgtNCHrwxmHr7yBGcpYDR7NYNA+7FI/g Bw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3900psas5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 04:05:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15A3uTLS121593;
        Thu, 10 Jun 2021 04:04:59 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 38yxcw870g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 04:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I+jg7FdNd1kR/OqmvLPoZDNS9/TisbKA8BZuH0XvJfjaaBU1JAEOfQs4W8fxFFGaS0BJzQ83UP6voCyduleZNqnOvw/tIfmIsqerBAUf1hdHHu6hTVEwcIU+FV1GDrgsGCmj6qNIMzGvy/hqWKsovmR4hhOlvlRVSN2VxJjUO6UvmWxn9zJ+WGhisdbvmhDPfI+/Qh2Up+nr9PpslNISSyYCHuwbP3LKfOB1iuaIP11dTrzzKpK0V6535f2RHz7IV6Rw8dEwA2M8+stOxvuFAN9dPjMZcSPYIvIMtxgXaAkkZ7hA1Ldf1I0qIMqTI1fUIaPOBma3cWZDql1/wVMoUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgfQM+2TVDfIR1Dz403KbCJGwObAC/sZIcqWNfg/ka0=;
 b=I4AXbRPqkMdRo1QbesJNahDHx21piHI8oF4quS1JNhEEYpNS6MUx0mUt/fx+OA4d+kTrqmftUmbsplW9ouo5uPFFgJEx12bj3le/jlSdu32Wt+YIccCSXzZjNcrlC9LKmSTVpQGnHZiDo0ZFpSW5ok1fyTObGSB1u1PJNASU+eOcQ7C9t8AVTvamLnN4Xwvy2B1H6kwVFMM0f5S3l4a+6iNephVr/kxaO6F6siFPumGvurO26shnmULRQs5IR11buDjzqxwpuRWuXxETtlfFxrg2iB4VyMuW6an3JR4tf9rbgHMmN1fKTt/bY3U3fITUJ1hPZYeltLhSKJ0RBHbY/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgfQM+2TVDfIR1Dz403KbCJGwObAC/sZIcqWNfg/ka0=;
 b=yoVN5XYSSEDbAICgOgY57L2R7zpg2/PGLk/pUf2Hp0dQKgxsfs2yiZGNfJ49mvevG6kMNrDjBm83V61UQyanaxU22oOG7y2kNnQ9FChUwOXEWMMScbZDTlkqoYuCGmaQ1SJS9cXtyGCD9F+OcDLLgIkdDmhAj6hkJArt6b43Af8=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5435.namprd10.prod.outlook.com (2603:10b6:510:ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 04:04:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 04:04:55 +0000
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/5] scsi: FDMI enhancement
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r9afjq9.fsf@ca-mkp.ca.oracle.com>
References: <20210603121623.10084-1-jhasan@marvell.com>
Date:   Thu, 10 Jun 2021 00:04:51 -0400
In-Reply-To: <20210603121623.10084-1-jhasan@marvell.com> (Javed Hasan's
        message of "Thu, 3 Jun 2021 05:16:18 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0401CA0007.namprd04.prod.outlook.com
 (2603:10b6:803:21::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0401CA0007.namprd04.prod.outlook.com (2603:10b6:803:21::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 04:04:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a224482a-7aeb-442c-ae18-08d92bc4e7ee
X-MS-TrafficTypeDiagnostic: PH0PR10MB5435:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54353418D5F8312F950079768E359@PH0PR10MB5435.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMbtTdOkRfk78TH8dEPobIM/O0OqUpz/vgCqBOkvRtImhjtLhH582QSWusYonC0LN/8m2xYYZ0TeUs6pnclx7pkOuUBUqYlJ76WsQ16Dq9xZQEM1KJu/WQ/RZplhRro77vZs8M3w7WBsKBsw+qFdHik52ffSpkUfBHtY/3dHVF+7ghDw8WzAJKpVSGLhCb+hL4O6HJOpUD6XBCWRDMm791dDUIAZznhzCoCAyK7aN/mgxC07UtXGFVY5WRWz5Ob+muVQsDSMWaCKn4S7fLEZFRmJRxB1Kf9Ke7KSM7ZGekwfpEMvng31RqrKXO1uzD2jnU8k1JlP3kelF1SG/ayy2TlyHCBCcHi7iWN6MpRz2W17/3y0JL30He/SmlLNj1DZI0Dtemfp2L9caqXtWAAERyACyW7t+qzKxj68eigm6YMGEXhNZZZ0vpxr0afBfQZS7VseXqv3vMDXTO+eg1OWQsO9dno5N57Y7x/MKLeCTqIXYxyHKQPJgKA+qa7xf1bmMjVtWzg6E+0vwCqyewEsYSSOWF+f12oge4Zp3x1p7g/zYInLUFCOQv07ZjwFPc2ARIYCNHK6VSEWj5EyrZl3zd/7zzvhd33f8M8fEFWf6+arj+596UD1XDoSora/nIRLhHzagYThHbHsENMiaZMAbg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(136003)(396003)(7696005)(2906002)(316002)(6666004)(558084003)(52116002)(54906003)(5660300002)(86362001)(38350700002)(38100700002)(55016002)(478600001)(8936002)(26005)(186003)(6916009)(8676002)(16526019)(4326008)(66556008)(36916002)(956004)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xtZRX8O43xPIBIEciPYGtbmB/MUmOlXbJ2BUqwOfni6JZeAoiPCU/GL6TUJh?=
 =?us-ascii?Q?MP48lVaf+qB2hr1dOICUbK5cDbqmBzKSoNEbdAS+RXUk5f9zjUpJF/JrmXvY?=
 =?us-ascii?Q?+Lxe5tPx6tNGRzxhXnKYd+yD0wJiRWRuy9Z71nVIUB2rDqfQgaFy+EDNWLuX?=
 =?us-ascii?Q?W/6MOM7vusYtkFtoGYyfMvbL1e/6zsVZf3NnLpJC+QptaCnFSj+jto0D5Z7l?=
 =?us-ascii?Q?qq0xDKsxyHFo/ed5frL7miSA6IQ9eTr+eecayZuIxGr62CGGgCXISA7XDMiv?=
 =?us-ascii?Q?FDbhvlJ1M+ppmKbsvZ7M8TQpCJmei+zdRc491tdfEk4W7Qvnbkr1NZoy4t+m?=
 =?us-ascii?Q?urMTYV5LAH9tzdA4eKVEicVUyJnvq86ToIi4GNcx2GHQDvs2QoFmxX91Anw1?=
 =?us-ascii?Q?uhTNsVrIKVI6SRWsdqBs54eYV5KdQ1KYwmt5EghDnutLh2teIQBsFKbCBM+K?=
 =?us-ascii?Q?CQd0bcJuYwtoitP3X7+qiE0mLvW30hGagA/JLwAl+b1W1WYssgfkyfyfCHHv?=
 =?us-ascii?Q?zwP4y9Dw+P25AanJAcEsSeyrYrQNQ7x4HwSh15yHM0RnGDchYdKIToHKseEn?=
 =?us-ascii?Q?Mdtwk8AECItB07GOy2CTXf6Vz1FpksDeZxEdtRSg/TURJrW9PzxndkSpoIOT?=
 =?us-ascii?Q?SfFyowTjaSDZw3c69zqRB9dpDvPtNEqJflKIVtTVc3hls2/4oCW3/2Ltnfya?=
 =?us-ascii?Q?aBW9kV6oHN2YnJTIeGQzBTxM8KF3sUxBg8awBsw6Zafw8GhdPzJud9UUfNMs?=
 =?us-ascii?Q?JEhz2eAd+9Cmo3U8wuj96ocsppLXnNGb/ptDAnj6ozu8Ebak0QkNqH3caDFw?=
 =?us-ascii?Q?mTjOdzJHLy92FN3lhAM2n6f7WB++D+1C/9IFCY0ZX0G796nBdkjNgyHMYzyr?=
 =?us-ascii?Q?q/qZUVPWcsfS8DpsffvnRlMaApGJVb+Vkye5pNxIV3GtfFZKtj7HMxEHrCzb?=
 =?us-ascii?Q?smpgt7lBjLRfu2hpz4Q7nToK80+LxzfqrqQHyxbEok9iwkIcNZuq8mycSPWI?=
 =?us-ascii?Q?K2Fhy06C2BWf2+RizzyyPciI6x2B51t01vVkaEPkAck+Hhd0+B0bsygf3qn4?=
 =?us-ascii?Q?U9muhLBHmU0FUx3/Tk4McTUtd28pfSV673I0tsIsohd0pql84dWIA5Pss0KX?=
 =?us-ascii?Q?PmmRZkPvkDMGDxQf1+48sqxgpYCziPA3LQjPE1aM7NgKIs6JQA0dP63hZ5TG?=
 =?us-ascii?Q?4/TIisZuCF65MzgTofAVjn/K+2q7MRd/SB1rV616QO2SR2tjvq+bvr6awTfW?=
 =?us-ascii?Q?TM2q074vBsjwR0P6ntteUFnLd0aO0RKJYF8YFgSeNF42WiEgH/TQUi+6Dcgm?=
 =?us-ascii?Q?VtK/IsTGcKSdQ6zZ3vqJYHlA?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a224482a-7aeb-442c-ae18-08d92bc4e7ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 04:04:55.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZ/iW5b0OM67SeE5mQyKsoqga8RUdKqWfNHQtTHODimE862v9MkD8QmWQbFrXFjilRuwkb7hcCAuRmJgkEUDfs9GoLEgnN5t4jdGnrP44Ks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5435
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100024
X-Proofpoint-GUID: fCJZlymHnL13zvMBgrSx2jMW5BGTdf7R
X-Proofpoint-ORIG-GUID: fCJZlymHnL13zvMBgrSx2jMW5BGTdf7R
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Javed,

> This series has FDMI enhancement code.
> FDMI V2 attributes added for RHBA and RPA.
> If registration get failed with FDMI V1 attributes,
> than fall back to the registration with FDMI V2 attributes.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
