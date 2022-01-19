Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160FDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 03:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351344AbiASDjj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jan 2022 22:39:39 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52820 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344436AbiASDji (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Jan 2022 22:39:38 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20INx5MD018370;
        Wed, 19 Jan 2022 03:39:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=GoyvOylD7WDAQzFIpj/ywit0N2b9feUURg3KTklo9FM=;
 b=eJ5CBWhjBOV1MeEzpowFSdVCsrANullRlnkvNpEF4rRvzlFuy0mxUIe6BFp4idlflXFk
 MzyTN6WaTwsL7F7wUz5CLYry4T9xlEE1Ogi5w+b5ifdS5lfdzLLMqy6rG0+uwxzeOA9C
 MpyllRVPA8bUagloUP2u+e+z4BONhROPc5hIFnFB6dOny6DaGiX0OeTjhmVJZCWbalwl
 A79deOSTw00Z+QmtXr0eDdICM9TCadZoLPqCF7zT9SsbfbfT8JGQMNqV38QYgHYYAURu
 9IqqXRtjRq+YKbRLQnTK22Tlpn5vR8zDPvVpe/8oYCDGvzdDzosI0rCYk3asRXClNbNp 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dnc51bprj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:39:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20J3Utbl029696;
        Wed, 19 Jan 2022 03:39:28 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3030.oracle.com with ESMTP id 3dkmad0gvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Jan 2022 03:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6XdLgREiFvHJBIrHGMASTLdwSSkOxND0KBDUCdT896OOFGANPiqgEu4kHmh/viDQ+bcyJxLeIXzpt2qJm22eVXSLzxWUCaSf+6OOt7Tn1Zhk+6ahbFldbIxQCcCg8XT3kRQ8WmfqBTblnZzrcpSILmDZkDrOhjjTEEeyrPdEdbXvUSsCpCfsHUZTnZI0q9mFxBkFzt2heo2UCBZMf3XVEiglxC7KK6srr7j7tEZusfgtxrVBLN9f8Dp9+Q6Mf0GoLSoZKEmAgvXoye5vRJ4uo3IF+gKRrJr8PcxgJ/+rxJC4FkwIq/o607mwgFrcg6wROaiu9jcj3tDC4q6cYoM2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GoyvOylD7WDAQzFIpj/ywit0N2b9feUURg3KTklo9FM=;
 b=BPyL3j/TdgQEDqqUR3HxzxvUe/sK+gflN425MSdQVSRsiGG71MlkwnODQHZKrc6YNpy7SG6oYNj55KZ0zhU2Msj9Ng8XHQOrSLluoaiw0es47RtekMDT1q3bVFf91KEXM4XMm7rSlNZAA31uFqtyn3nQq0UJlaYhtAwa9WiWkq/M662P215LjRXMzLhXdMPS+KBBVtIxS8+0TkWbz9JWjA6zY4VfZhS45CHwOSz4DUz/zX4tKuuv2pz50U54WVGP8giVUmFIT3qDdxL5sVDJ2skc5o/frYXoGN5tbsgnqlziYrWs9vnKCSlvAJR5QVIhwlsZMhx+u8M7knDMKuerIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GoyvOylD7WDAQzFIpj/ywit0N2b9feUURg3KTklo9FM=;
 b=h2Esr7/+fe3Vml/NzWmzOdQhm0MzaN9Smqmk3P2E22eM7JncfC0UEtsRYISdYsbRaBQSHbER1AgY9c628y5UB+xNNqHzs5eQnoLoDGx/DR2lpTNxNi2lTeh5o2BFmGJ3G7dCIutrnlEGGlZw66G+QsZQ+u0oti98D8HfqKH8oks=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2661.namprd10.prod.outlook.com (2603:10b6:a02:b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 03:39:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%7]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 03:39:26 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <loberman@redhat.com>, <jpittman@redhat.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/3] qedf misc bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dawmm1n.fsf@ca-mkp.ca.oracle.com>
References: <20220117135311.6256-1-njavali@marvell.com>
Date:   Tue, 18 Jan 2022 22:39:23 -0500
In-Reply-To: <20220117135311.6256-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 17 Jan 2022 05:53:08 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc3ce7b-a826-4d29-dabe-08d9dafd4a46
X-MS-TrafficTypeDiagnostic: BYAPR10MB2661:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB26611D6A6BA0B7EF131985968E599@BYAPR10MB2661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /3d3i2YUn1F6Avp5958GG9iPCBbO5JAJJHHXtP0Lo8CJ4ickH3lc/RWzxtEiHQ2q6zYrFpBE32s5faN3pOHIenB2XPnVPjWq28jzSeolL/MeWHtdCTP8OSHh96MKCFdE1j2iPD6YQg0eMSyqumvtEQ1pNXtq817GTUiZ9tCO+NDPGPbnqXcGC8yyZM0ysApVKW/hnrWtZJJaemJoUX2hsjHI6AYuFhTJ59h2I/dXYxHqXFqQqXa42X8fbFFfwaYq23nNjsWoUwOUBBhjpBR5TZVbLWITY+Zsu0KZQungBQqnrKeMES9RcR02xWoqzPVE0rsaaQo8tkmJec2cXOoxLKIh+DFabUakXl/pIa37ikywDuBfNcxCLk6HoUnYDxSnHzn7m8j9RDBx5mjQkyBWiiuyBuwcNEHMLGbTVlkW3CEb0JeQc2j3HoMAx2i/toIpdhsNcH3BmMCRvFdp1IbVG15up6N10ltgDq3ywB0ERQn15ciVzZ8POiQfFAxJGvRX/BnySh7ZGC/NB96hOz6Utufj7nEDLyWxEfPWAd/vumPrwf+I044SuAokTYmwzcgCeQJx96b3YColv1tRvqzWV2rTHWUv5Ol9X/tu9JQLyXvyLn2ueybKnhO6Ir/p4Y7QL/RJVFGx+fvcOgsG8mGaQJ+Wy0aABrlZtmuNQTcgA6OU2eYXORXLoU4Sz0NHz2Q1yX1h5VDFeNVv0S5GSCjlTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(4326008)(86362001)(6486002)(6666004)(38350700002)(8936002)(6916009)(66946007)(558084003)(66556008)(508600001)(66476007)(5660300002)(2906002)(54906003)(6512007)(26005)(186003)(8676002)(316002)(38100700002)(36916002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CNQa2No31lhLVVjSnNoDQ/lwtZo1U2Fgmh1CEd+e2fg0YCTb48VOnqOV0Snk?=
 =?us-ascii?Q?EAuga7dgFSCdNPmNdLUx1hLNsz1NCvooRzyJe9vVxYqVm0QxNkG2BzoGhv/A?=
 =?us-ascii?Q?J1W2fz3XD1sg3bCwzhhVFWdqcyuj8c0lCqf0DVKMQWrCv0UKvYM/RzqUu3L2?=
 =?us-ascii?Q?RIXTZ6JyE7njZIhJcfEtH1blUeadIZE38znBG4t+YWBqBLPcj+LgjMTR1BZQ?=
 =?us-ascii?Q?qATrMIoKANMcWGU0qhGWHI/h07w7Raxbq05diaX8rcq72HfjzxPStuGqIGH/?=
 =?us-ascii?Q?OC7Be6yasnW30aUZt5avCU7WU4CyC1zQJsEyucYdykGGn6mgP/XLMTPh2hna?=
 =?us-ascii?Q?MwleTL9buo9IMb1IsG3bQyZ7LV1aHRsPsYVcbwwZ7EGDrsiqwlPGTu4/01u4?=
 =?us-ascii?Q?NELgNe+/BoLkSNtaICH2dy387aC8p6Awoyzt+XfQeY8MzNx7M0woD3TZcIsL?=
 =?us-ascii?Q?IQQ8cFjm414Yk6a0N2kMZY5sFdg55u3oiMN48OhQt+6Ws1KqOmbbYBC0Xp+b?=
 =?us-ascii?Q?tH+F8okajv6qpwcIKXtZ6iImRhJol7yaxKraqfh/iR7x6GWnI489njmaTPbm?=
 =?us-ascii?Q?QC0Swqtk+K1Fvz9KTTqNi2Neaz0hKjNff3FHH3IT1Hn495Ekgo66TGilQVhY?=
 =?us-ascii?Q?H7q8wc9t+tthaTCaPVlM9D/l5NLHtLjK23yuYlErldyqFnoFw8kteeSg+beO?=
 =?us-ascii?Q?aEUnw4c8/ZqINcPodxu1XyqMHq1IJLdFKFqvpbTMUcT9ueKsPaeXSVGkARdw?=
 =?us-ascii?Q?BRlxxerKjZdsKdp+r3u6gdEY5I8kTBqlm68R6oB0VYnVrshcDZG4PrcRRzhM?=
 =?us-ascii?Q?JwnqrEmslTvwDWcldQvdRqUGMWD8ejVIsu2aLbXlG3361Yb3gQwjgVOVJOLq?=
 =?us-ascii?Q?+hybpbE4FJHUHDU55NHcWNXh6TShMEUGwvzp6nu4vxXMU9JYU1eoGeqpxaYB?=
 =?us-ascii?Q?UB4FgHKcRNev8tZGhJ1qT8YQoJWb/viaDxTUJ86WjuNUy8yVKN6ueE3eRRyC?=
 =?us-ascii?Q?IfuxnPyIy5GdD4XgyJnkRXIF+ov+JKvr1l5R+nwRwjuLB06lmiQuwG0U3a+V?=
 =?us-ascii?Q?aSToRILbasOgm7H30RDuoVXNZmdP8hlfs4wTwEwYrg9cPFv3x3mJQ8jRZ6YU?=
 =?us-ascii?Q?d2w7nlKG/Z4Ivt8KX9Yjf0RmcBL4nEvqyTYGinC9EObsKmd/72DwwMQKF7xd?=
 =?us-ascii?Q?322Kj3/ehiNLfX1dhz4GCxOH89Aqs5JGkGGaKRpZbeVrbcrKQ2hEsoiQ9w1D?=
 =?us-ascii?Q?85Tq7rysVUYG4bA4T3SMU2FsV7at4/98KigCwYEBG6PPHpJYI3rpVJj9+oEj?=
 =?us-ascii?Q?Y1eNUgAMXPc6wOIukZNNWwqIeATz8m1aCQozbic+NfEOQWgtKvmyw3ICL2cc?=
 =?us-ascii?Q?dy/3mHpxJPi1H3WM1qYwZbTUMhXUSXKj9k4KvB/iKNQlmtFnXzMzJG0MBQj0?=
 =?us-ascii?Q?Q8Vk6vtIoTFuOS09nAS9/iHOguIoj+nmSXIAQPhhZMZGtFQZNR0P8jNLCza0?=
 =?us-ascii?Q?Sneek01BncImQJfXnSv5IPSypWr6ZlbAwTLcv6ZBb8cI9BBOnppFxHI2J8fr?=
 =?us-ascii?Q?oTJ1ulAlfKbqwyAcn+ythIR+mGE5hSbMaSiX9+6+YQTpQAhra4+jCprUk07P?=
 =?us-ascii?Q?523VXaH9ESpTOnCYAGUfmk7l6Wm4kPzisoa1kbMK557Y+uUYwpgJTNAi/Wri?=
 =?us-ascii?Q?nb6JEg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc3ce7b-a826-4d29-dabe-08d9dafd4a46
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 03:39:25.9092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXpBCGtsqMX6Tb3DF+Y3vxkYvvG3hRMX89nM6VwxmQp4iCASZIGGcJUW38X57i9n3sr6EGCThgRa3GH9CpdJCuRZW/35JnB9jl0mQY4M+gU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2661
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10231 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=982 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201190015
X-Proofpoint-GUID: IPTXpbr-XptH-JTSDb5EBgsZeaOcnqcR
X-Proofpoint-ORIG-GUID: IPTXpbr-XptH-JTSDb5EBgsZeaOcnqcR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the qedf driver misc bug fixes to the scsi tree at your
> earliest convenience.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
