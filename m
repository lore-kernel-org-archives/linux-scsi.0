Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C7E8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C984E23120
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 05:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhAMFfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 00:35:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:56792 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbhAMFfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 00:35:08 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5PAJG085179;
        Wed, 13 Jan 2021 05:34:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=G5v/qmT/xgVHnL+evF1/S9IbZAp+X+dAoRkZ2QVNEFU=;
 b=YBijB3bdla1jiNDtqb3G535r9uI9E9kM0F1o4K2Mx6NXuxsQ11lKoyu7L4T3SiYrhCOs
 Kc6/vMbPo2o7LNJZ/jxQ3H9eDU5PR1UOV1wCIk8zCP8efcBDPXb7MFI3wPcsd2IMi7JA
 G8fmBSNx5pTF958QqHT9AvKR60rUICr6zIfuNhNqGi+Tj/paeg/2Lc6tXoxwM+aRlKOZ
 vWh9Lcjfg1RtvN0indog+OwYi/t/tSUbsQD9JXrsL9BSl9/YIze/n0pZUmossh88bflR
 CMQ/Z90b48mPvtKOv+jNuikaS6fNH9GBDIPSdK0W/2+M5qoX1NW7IpCnUO4xZI01M8i5 IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvk1j0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D5PdWR127648;
        Wed, 13 Jan 2021 05:34:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 360ke7qx2x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 05:34:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2BxREtjbDzD53G4vGS7L+6pjCCEZydiTwAQVoyYLL0eh6EwgkITXGC6ey58YbewojJpN2NqLaLvTsbbqIcIo/SAXi1tKN5qIMAkL4uFvbuo1SmXSEGn3kCrvmtEDvVaLBnIDtPVqy2oUNSyTAKwmTswoYawa7hRPVKG+0avXidLrrpN6K/10bdkDmPDhR3RN+Y+RInE/9TV9VbjUJ7WDelCrU+4Q4Ebs0D4925koiSCJ7QZKOibeL3ihp9WyrA0UyqT5vFV6FbNyf8ewitYWHIA+cZxaroQJxJk5oN0RcJuZSewYA6YhzESk1iWHvFts5tgbQR9dy7dBUoSHE28Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5v/qmT/xgVHnL+evF1/S9IbZAp+X+dAoRkZ2QVNEFU=;
 b=SuDdCW1Kb+rczJjAUiVMeRSQ0GyXBRj2FJ+D1YBU/wj4IJPRPodtBqMWY33UQzzWbSDCFpRBGQ7wsp7tgfYMAkd1LIxNYIUumF0JDDFNTHbmxQexeojg1mpa8SEPp6A1AS7tSOMjpU2W7wV857Yz+dJi41joqW4PDMjYZwROgvHvlbkFomK2/5aCAXZhJsC1M7Ht6XC19ehcqo7EuhT72rZakRNrZp4Ow0mqUqL6iK57ytGAsqASSyYR6wQ22+lxQEZdaQ5krh5ZTfTRE2Bps6SpfBRNKYM4954WD1GBSskUkkAWbEFyjMk+3s9ijZqmyaVZeFqLFVPBYy0Vrzr1rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5v/qmT/xgVHnL+evF1/S9IbZAp+X+dAoRkZ2QVNEFU=;
 b=uc+OuoMKjT5NlNXMBXS/r/P/zx8LlgM6UTKBVzA8oxyNKtD6HyYNbM/9Z7ze4yUWYD+1xdxu5Qs1Z6Ix+WvzPCB5oOHQwQdjkvn9iMDFX0rYkeV5vonktf93Tx3aOVzqom9yiDfI+v3glLUsr/GGogigyJo/xtf92RkGhBgcnBE=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 13 Jan
 2021 05:34:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 05:34:17 +0000
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH] scsi: ufs: A tad optimization in query upiu trace
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v9c11ju7.fsf@ca-mkp.ca.oracle.com>
References: <20210110084618.189371-1-avri.altman@wdc.com>
Date:   Wed, 13 Jan 2021 00:34:14 -0500
In-Reply-To: <20210110084618.189371-1-avri.altman@wdc.com> (Avri Altman's
        message of "Sun, 10 Jan 2021 10:46:18 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN1PR12CA0086.namprd12.prod.outlook.com
 (2603:10b6:802:21::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN1PR12CA0086.namprd12.prod.outlook.com (2603:10b6:802:21::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Wed, 13 Jan 2021 05:34:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 172f657d-d8f7-4bf2-dd21-08d8b784ded4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584D84A55A49FB28070E6CD8EA90@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yGkR64lJlDGCGalg41oEbNDTQIeNLsX2RjEebzwpzGq8mPukgUJ1OpWhsyV9TkoIsoQuAj1fmBBzNvVptDKv4qZcpFjDDzAeDonTBHbI//CBLRtmnIn0ob/Ao0uWDWBACCNJfK6Q6xECBG4dIE8K3ycsKolrWJzpRpwrNpjMYj1eKo7JDXRllhvb7wLUAjpMXlTOdT0FOpBqneXNFZln9nPVmy0AJf+5qWrDgzKDb7C6OEYEQJ3kUKtsFxLmP8vrKpcqwqpnb8NX7j7gCc86zAMBi/4czBCrYAEEHJu/Adr+vWGEQIU1B42o99XdxtIjWpmYvmKGl23XljXxf3M2/xO1K32Etavo/muhlCdvPTlv6ptTopsKe/1tOhsU+6Lxm4qoDMSXBhdpYX383sbcvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39850400004)(376002)(396003)(346002)(52116002)(956004)(4326008)(8676002)(558084003)(7696005)(316002)(478600001)(36916002)(66476007)(26005)(55016002)(6916009)(8936002)(5660300002)(66946007)(66556008)(2906002)(186003)(86362001)(54906003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YphY+t6OX0nJ0678RqVCPumMHCobGWR4eAtrDq0kxNthIHKx0sTUqrOFoKn3?=
 =?us-ascii?Q?iOfQ+uRfZaUOAQ26vLAtAczOFAUAjFUz9T7pFqQDu+cXDEhqfNFDa/zxsMgJ?=
 =?us-ascii?Q?qCs1y65knXET+QicJ9J/+TKabUv6TeBUwYukf0fJtZ7r+is6tnvW4BZuYsZQ?=
 =?us-ascii?Q?6SxOv4KczjCuP6sVBu5gCl09/nmDH7trBvooHYAhVun45Pk10VwR+wpLFgpg?=
 =?us-ascii?Q?84JxSYjWSWr3nL7IT4cGopLY6a78fn9dNPlGtwMxkEKgVB5HibU1lPHv/XED?=
 =?us-ascii?Q?cS6OxZ8G3pq0AckyPx94NHWj4JuxbvgsQrXJs9uj6Fqr9kRj5pjr1aHtvy/2?=
 =?us-ascii?Q?zs/vRx6mheovkqK1K7rJXofzdVIFPsGn5QsCZIbwV4EOFXkz83iwuzmmrXd5?=
 =?us-ascii?Q?ZnYk2ZetqBSejxg42OpqJAMYPVja/j7qL7oYgYIyVQnV7FbeFG95Fo1rJFWA?=
 =?us-ascii?Q?zNNmGne/5SHJtqnxv5wUv1Md7xyi9xqbm0IyjWGhKpASdLS4aXL0jsahLm3D?=
 =?us-ascii?Q?q7+1lzEpAb56ieJ02A+MrwonroitrOwgpq8XN09TH5lVJzGm6m7tVj0k8Dza?=
 =?us-ascii?Q?PpKOrtJ39LStXZzNVndvnbSw5UQ1iwqg6f+RDxY0moTBWYDBL7BdFUKQy0P3?=
 =?us-ascii?Q?nCGhRQFyr/OjT+fLhIaN3fECeNjXupEEHHlR7qCrTaKNzeZkZIgNYmWZ5bkD?=
 =?us-ascii?Q?d0mIPukO37kgO4meXr7TqkwKlEbTO9JtaVWkvQca1LPwhILAZSivOUeuCIHY?=
 =?us-ascii?Q?J3ieogojRWHnDMOgl/lMUyt50CgtIO/MtP8wRWWPH0HcBYwCh/1HigsYeckf?=
 =?us-ascii?Q?9vmXEE+Fp0LYyBwnOtYQw23P6nj5JeyLUxpvwWj2PQn6gOx+gSJEN0Dud3RV?=
 =?us-ascii?Q?qSKtxvXETdxJKYtXb16warzIBqGdlcGR5VZm2lmPMR+4kob3/zADQKNmVtDc?=
 =?us-ascii?Q?NHXIX6GHvHbFAP7/c53Kz/lSn5TSIjToQgCuG4U0cqjjsl/wuY7YdSfuOwLP?=
 =?us-ascii?Q?0Zcq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 05:34:17.3709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: 172f657d-d8f7-4bf2-dd21-08d8b784ded4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tU6eQDFqhi9c1jVJh4PvvrE5VX95MVVm/e2R/68JF+1RJ7RJW70Y+++WwDVpRn60yYM0QlCUL/jM2/2F1LpEBYrdvem8dKp+97fCPjmdGqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130032
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130032
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Avri,

> Remove a redundant if clause in ufshcd_add_query_upiu_trace.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
