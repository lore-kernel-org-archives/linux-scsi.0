Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8D6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 301D160240
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 02:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbhJ0Cym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 22:54:42 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:48464 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234535AbhJ0Cym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 22:54:42 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19R0mrxw015447;
        Wed, 27 Oct 2021 02:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=uEBSYscCH53Jbo44dFIVTlxQKvgT5J5sf/iwuaALoeM=;
 b=nC+LrxTTKM2BBoHQOdEWgxBWwWTyx0C9UFgGHtXrZaI+jSwdxO90FuYUQN/lQL8OwqEh
 snoqVrJ1dJb72m53aIrWlvyOLawfRHxAWQoAWK6E1BubkpveklWceziCCRAMlABP5qdY
 nAdpCv7/GCCfe8NWMTMPXQ7Gh+wga81w9NQpQYjGPBI2nN0tyuhwoK8ekeDfDKoieu2+
 ffl/9Tyia11QEXhdP4mmC+VuTg9FfKxkJlQeP5J53C0qIaUJCtiGfuEKysosWqET9hnr
 oHng3lkfETOaBp9EcFkWWVFQZIfoJt7QffMfRBeZoH0WvdKT7+p8PNzDQmrlwHail02j Vw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bx4fj0n4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 02:52:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19R2pWx1027817;
        Wed, 27 Oct 2021 02:52:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by aserp3020.oracle.com with ESMTP id 3bx4gc0tv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Oct 2021 02:52:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKr1TDX06i7GxGsvxsrwU7Z30maSRvclEfoMMHAPE71Alix6jbSueBPmTT02Ye2y1cmL8p1P24lzTOlNX70cUQqQbGCKBJwtl/492AmLaVVSr8aHZmBO4LZe+vZ2RKyazRRA9yqXFXdxxfceUB8QJ4RJ1+EOBi+CKvhmexsYovH+hO75I2niYwaNoiNRjrwpUmrOHeytXelDYAVndz88XeH1qNKT4nQiEnXWRWhNIfT0jNE1iiLqV1xAsXbpo35sRX1OZlx09UejAJI887jRotzb3x8d5gSpKEPYTrZ4549MNadkNUpH5RGHM/ZvG2PYqpEgb4sEC83pv6sgPetn5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEBSYscCH53Jbo44dFIVTlxQKvgT5J5sf/iwuaALoeM=;
 b=FKll3JJQY8Db+I5u9d6wK9ounAhkw1aYxFPOljiz0QQ/Iqa3HDdmBe3YK1eixhnzkmUQMHHFYznBPPcozU95pxajezgbe8SG1fcvSODMNih9qNUVwQvLuXlL0ItLkcY4IgTtbG9eGSquykkJMB5CvyKVHjWieRu3VHszLji9kEEHq0GofLNZfWgrjfVDUmuQqBKQEhceIrAzX2tiGi0gYM1zuiWtRRKu2ov83YKsUWTHHPYjUbHUP1DRJlBfXfTJDjWDKpfNoBHYBLC0Xl9oeJ7odKzsWPO0nLZ4dCg8ctpXvTAh5DR9XSSKN/uu2X0+RgoKyamN9+Oq9hs3dsbsZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEBSYscCH53Jbo44dFIVTlxQKvgT5J5sf/iwuaALoeM=;
 b=fG/zrAsTnVQUkLIwKC2pQAClxP3G5yRVrZnDrT7q4TAEFe+OPh83l7s4J6KjpZuYO/ZkWe9idEFLHAkxCYKKA4EcJ+1ogGigEbCIfIeTiuBwSyda2fkLIwX/UrKG5PDKvncJ3UnBVCpvK4jza2EHkV7bxjjKpqQNp+wd8u1E7ek=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 02:52:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4649.014; Wed, 27 Oct 2021
 02:52:13 +0000
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135on2n99.fsf@ca-mkp.ca.oracle.com>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
        <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
        <CH2PR04MB7078125DD9418A4B4410A485E7859@CH2PR04MB7078.namprd04.prod.outlook.com>
Date:   Tue, 26 Oct 2021 22:52:11 -0400
In-Reply-To: <CH2PR04MB7078125DD9418A4B4410A485E7859@CH2PR04MB7078.namprd04.prod.outlook.com>
        (Damien Le Moal's message of "Wed, 27 Oct 2021 02:46:24 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0017.namprd12.prod.outlook.com
 (2603:10b6:806:6f::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.42) by SA0PR12CA0017.namprd12.prod.outlook.com (2603:10b6:806:6f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 02:52:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 193f2b64-652f-4874-506c-08d998f4c77c
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-Microsoft-Antispam-PRVS: <PH0PR10MB5418B4E162E53F598C6843318E859@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PK2oCKSRaqmR0L8lXEKhGI/RNbPujnLymMHz1U+MWezz7t46eWi0W5A5PrvghdUHgxkmpiHZ0aKIBydjuMJyMBgsqzOZtYzoJZJRi4SiRjOQrTe5eg+8YyoxxJYA1bbkwRsPguhDAEpm1ZCJlpXQY1p2N/gCSrXzpfUyAMnWEnco7MJJpAqZf4AG3W3MPuug+Oe449atvrJLdG4I9xwk+T2Ebzy1pLwu3+qBRtFceVNd+9nRQ6Knu+BgZgR0kHdV8tTFyXmP8qeCABo9VzNXdvbqX0pAggvT9KqXuVFvXkRAgZlP7XP+CGh9V4B6wHuRtILg8/FsvZBPPAmxxl6maKrX5GO7/smOfzjXEVLhpgXwD1TZ1BX0mvrPTUBXtbDpj9UW1ukfxsWU1uahL2Y5f70AHN0ELWjCOMORR6WoS1rPT+4j13dWOvHOaWgvV0WXN36JMB0FjwtyJ1q025LmlhCKuYFpSXecivpX9Mr9n4BWEgR6PmJmHj9nWZUoDcfYEhZLUWQ8tzWtnopFykWvO5QO2xJ6sXzwI1m++E4t9kTjfrK73yW+YfZTw9/JFKqXQEhQ+WpRP6+sjlzAq0p1uwiu0pFqV5yqTnTWhuBU3CAF8vOsvGu1j1NOugE13LnMOlSDgzEiCTY8PwcE6NW7hxK2HtQoste+Y3pVk/aEHQOE6WBu0YKw1tbtmjK5l9OhApTuoG53AKAT0xL40dQ4CA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(7696005)(83380400001)(956004)(38350700002)(38100700002)(55016002)(66946007)(6916009)(54906003)(558084003)(26005)(36916002)(5660300002)(508600001)(186003)(4326008)(52116002)(86362001)(66556008)(316002)(66476007)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?acbJZl5BaCxpiu5lTYIMd1OcgAPcLc1JQgdWT2s/n5AdOnoCx+5LWIiDH1iN?=
 =?us-ascii?Q?mXRXMl2WgM+AeHj0tCNg906YsG8z6CfaecXwXIhiE8nya9O+hteJSH22H6wP?=
 =?us-ascii?Q?6NRiMmW6J8boBURFbqEnjCrYbo+2czPreMed5hwaOeyAwApogY0qfj2cF8Qm?=
 =?us-ascii?Q?Pv7LmRZCuk723lPTZmfTpVxeWPbA+DPRq4iNInX4vxmXEyV+jpRTv6k5FqtU?=
 =?us-ascii?Q?3JH/tNAmq1mNHKxOze1f/Qztzs74AE/NJcjr1wfc9khosoxmTyPig9ARydps?=
 =?us-ascii?Q?1nEFhH8AO41sUlkMNXm5XeQ0cPnYC6/jZFz7rM3uz3TC+AWO9TO+b57G9i/1?=
 =?us-ascii?Q?dJeHUluzomJwbjjwCxvYxz90QFpJyJwumRaxtCUtc8xYyBWbWd1DfO5Nd9nh?=
 =?us-ascii?Q?BNnZRaEzlcomCt3mukhPUQ2Freg6uGMXqypLmHLrEViD1VJW22eGhSyN1mfX?=
 =?us-ascii?Q?9AV/ldmR8zOeNnvGoXnaqgC8LlKd3r61bDXOnDd0kRnV5NFU04yoWLfCYe26?=
 =?us-ascii?Q?zPxoCZxHDt3vmjNmYNqqcS9MifBrgDSGJnuYUpfWiKYl/oIvxbj1qM1vPLsj?=
 =?us-ascii?Q?UkaLIbFdhbCcNIk+qXv/CUGjGTKJGVSpH4kogOfDJ0bSXasC2fxZchda/ZSb?=
 =?us-ascii?Q?hXrpTEzcm+3+5xXmJOCKhjyjWbwhiE/Tn4gTSkRa10dcAkArIU3EcQzetlPi?=
 =?us-ascii?Q?/Lud+fazIYssthWwwXQ0ikZpce38lks4wEuddrOE5UUFbnbloBeecAagyyUl?=
 =?us-ascii?Q?Wg1Bq1nRE7VOkwCmTWtVs9JU3joU+CtUSXj3mDWXPtLlLSS1C6YFtBsS7ozA?=
 =?us-ascii?Q?9CgXIY91RywWS7Zojej0jd3Z54OKsxMD8S7tOoiOOGrnaJsVtvjah+zCxVAW?=
 =?us-ascii?Q?K2KOBJuBEzFA+swhG6es1k6A5LhJVfkT45KJKIxA9yfn7InxlZkgeH6jml+I?=
 =?us-ascii?Q?J1SphRih9xz3ZDz7qd3i1akQFkc9UASSP/Ecui5XXcdJ3xe1eisEKr+EEZ+p?=
 =?us-ascii?Q?KQvga7SUR4Hvy9Df4jAMAM7BPw0yxcR38hGEtaP41GSLUe3mjYVw2abtqdpi?=
 =?us-ascii?Q?d2O8r6FNT02qq7FjcP5meEFQATOUH7U9T2atu3/DnCj7NtEDTKYggmE7aoMH?=
 =?us-ascii?Q?85W1+qZZMTRUgaeieSSKtt/ZgVpmWhrFQZNPlLgRL/pp4pEtUQNYyJhzaPB3?=
 =?us-ascii?Q?jX5cB/OR7+6HbLBQJ2U7VBdAvS/zs4TxBnIlZR5h4459NdKJL75t1ulmP4Ab?=
 =?us-ascii?Q?77YQFKffK/k8n19t216mOA9ykCjGFSiOG5V5J3N3OyUySpP3NKaMxzxKL5AE?=
 =?us-ascii?Q?go7dgNqjisi5YBfjHKFMAIcxoyIL4eAf1Sp2C9q0KkZqcMiqmBOs6Bg89Qd0?=
 =?us-ascii?Q?L2I11SpOTKvGe8y2VCfE3O5YppyLYw9L9dGYD3IK7e2L6AHGmLypYPJX7G1a?=
 =?us-ascii?Q?dNUXbfG/HXhzNen3vzXgL3ZI/28Cn6IH7H7x4lM5PTNdMiFuXSWqR37R0lo3?=
 =?us-ascii?Q?AxNyt4nX52vwDYq91w6/CvuOEzaNDG45gsR+cfrJPllCrj1mdJJDV3V2GbHr?=
 =?us-ascii?Q?gWS8FN4W693ECu4I3TI5wJ4w9j1cdENRXx2UZ0YvCQrKeDuP/viKgHjumj4C?=
 =?us-ascii?Q?X1eogdnE3FhFi57/ncaG8hijjhPku6si5qfCaovh/dJBiYgSynF1tfOLX8vB?=
 =?us-ascii?Q?+Q6U3w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 193f2b64-652f-4874-506c-08d998f4c77c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 02:52:13.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gX6m9TUr6EXnIh0f0x1twtZ6NT3DTz8OeSy/HODXc4BrNJ8LghLbAey9pXS0N5s75huSvaf//PUM2s/q5vBYghtXofiVo/Hv4PvmQz9MxjQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10149 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=916
 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110270014
X-Proofpoint-ORIG-GUID: koVOYptySKmXHvHhZdREMS8ZoFjMfIjI
X-Proofpoint-GUID: koVOYptySKmXHvHhZdREMS8ZoFjMfIjI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> As for patch 2, it applies cleanly to 5.16/scsi-queue so I guess you
> can take it too, but I will defer this decision to Martin.

Probably easiest if that goes through block too.

-- 
Martin K. Petersen	Oracle Linux Engineering
