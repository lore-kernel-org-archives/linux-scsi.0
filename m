Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D76C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D190265081
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbhCPDS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:18:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:33628 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234796AbhCPDSb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:18:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39ocf168109;
        Tue, 16 Mar 2021 03:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IQp+MqOX3uXGZzdFNhMSfZSnQAWHStCWdN7iiMkzJ4k=;
 b=dVGktv+bQBVsjECaCjmu7Aq7Kwh5dTak70WNwx1tVhA24Ahu7z3ns7sIc2ExDqcgvHFG
 Q9NS2ZE2zw1wVjVah3UG+zeFdQYUxlEPTMEYYX1yreuSmK/8DuzC+o+kUoXZwQOvR3Oy
 hePCrthkNhyawlRiAiBCIwZvIrxvkOwbNlcB68PnYsBsMP87rrtJmk2cxHabesp0ahCQ
 tE56S3fbr9HypZaq4K1V90Q8Vuow1mXN98c9eaMgGDdZN8ArerkMEiBj2DLB8uo9MYAK
 AdX5hBqKecgFlrlYLg5opvSTNzMXN0QkemTBpobyJL53UuyXYgCTaNEQwTLlQOa8lxxQ ow== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 378jwbe7wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:18:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AabS193863;
        Tue, 16 Mar 2021 03:18:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by aserp3030.oracle.com with ESMTP id 3796yswd5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:18:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNNGmH5X8ZbjiNoA+l3vlupTk8IuEO08hgkkEOEKLeH6ZMsUmlQ1adXdep/l0BovoGQgDwQfhrj0cvIuANGJcSZhoPNiD3BfL/p49RAy66hXg8GscMeSpPc7jMrDACJ+NpCIpAZAAJ+bQaOMUW+VVz9aphUWytoYZCeZtVwXOxSU5AFql1PQNKLbLKyvCYsuAkwHBzuJUS6/gE/vGIv8IDbyrOgwlGG/vRcma0r3Bg3y1j9dPWa+WFERMzI4h5Ut4xTNih4s7wcrPnNr8qH5fZRJyx0rk7SMQz2EuYfQXh/oYewORlIZ0mF+ARaRB0VqCZmIsjrbY9QJzd9c/J4XVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQp+MqOX3uXGZzdFNhMSfZSnQAWHStCWdN7iiMkzJ4k=;
 b=fcrdoZoDYtMkLefq7iEc5XZqTYcQTp6D6Z5HZVZPxfHMoHnyCG6vJpTJRmi+Y6G1EcZXi+iL7WTWhUpKRXTdltxKGD2eie0J9d4GoLM4c9sUC9K7PMWPT62rgXhrA61JnENktyEdThwh535XwG+5i+7cslOTkYfvgqthzb8o/Mv+JMIEwKmnffAtpmDHWw2n//7e6+gmlSi4KV9J5JAeU9ylhGHxqUBwZnHkHIj1awtKAuLYakK0XVrGVJC/5sBdvG9H5dR+8Fs3PhNmfRUzw83SWNtANftk6N+RHcPCNa3GmF++9kRBTNeqTM1ML8OFpMdSqKyRFYdAX7WVjq2ohA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQp+MqOX3uXGZzdFNhMSfZSnQAWHStCWdN7iiMkzJ4k=;
 b=h+LDu1yKgjgY6E/4j4KZDqm1S7I2bDMrL621xbKF80BqONt+y/nUOZ4++eQqetjDLBcsfBIRxyWeVqCix4GkMBLOuWZCvCWT3oWHu8R50yh4s98gz7g/Gy6QQG3ciRZv+1ce1+kD4gfDzkIHK1hkHJu2v0kP5aLmOzejDLfZ7Nw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:18:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:18:27 +0000
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Adjust parameter in call to
 tcmu_blocks_release
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgz34whx.fsf@ca-mkp.ca.oracle.com>
References: <20210310184458.10741-1-bostroesser@gmail.com>
Date:   Mon, 15 Mar 2021 23:18:25 -0400
In-Reply-To: <20210310184458.10741-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Wed, 10 Mar 2021 19:44:58 +0100")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::42) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR06CA0029.namprd06.prod.outlook.com (2603:10b6:a03:d4::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:18:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9029afa0-1e8e-4669-f739-08d8e82a2aa6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4647E799E54F436EEAB08A1A8E6B9@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0GxW6/pJZ8ics372l/Lse1SWFMnOlkUDMEh3tjomyZ8yEaLqASxoyugnu7JEpPsiwLMhNgpRJtLXHhuuHtEANmPT0f+y9sfp83hgDKBuJ1L2XxZFqUkP3qKtWxgVM/ygre18JMzSo+9o/FGMCkQB06cEsgnFQNFPK2POyhtbfoj0zsy1oXB32UXBOZKuOyrCHW7ax36fzSatfFD3TA/bXQz1wyPVP3hqzT8XVWp/rvpkKVu9+nza1+JQFxyP9ZeRyOuWm5A+Jor67GRb7XHOtU02VBRZqkmCF+kpOmXkPlF06CNxeqtur4cKjk16hFKDubfs9u75qvXYsZLDXHuf5m1C773//Emcd9UXwJwCKAzP3Wx2BegDGa9N0F7vbVMRTC8XAiUetZ7cuymSOb7dAbw+5NOJtuvcjZwUnQ7+Xx15DOfC28iAUO6AdxOpO6lIpwVvSLzJ+SX4+oIV3eqXnCSxcMKEwCRuhqecYxLKNEr4NDWyRZpMewfjOMiI+rAkTA7/JaIf0p+uoW/BDYMwT419R1ncEUiKy2vQtyqXUfWmoEMgS6b6s3cER0TKXlG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(136003)(346002)(2906002)(5660300002)(558084003)(55016002)(4326008)(54906003)(478600001)(66946007)(86362001)(83380400001)(26005)(316002)(107886003)(956004)(8936002)(6916009)(8676002)(186003)(7696005)(16526019)(66556008)(52116002)(66476007)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Vj9npeywEsx2SmwDzICp+HsDaxTfo9OkV6y7OOVM5V4wp7FdXJcBZxeTFRrz?=
 =?us-ascii?Q?lj+TqYxhfKmJXkxrAv7cp0UUprWFtvWc5DGTpIwGec9Dnfbq6sqP+D+Uk1q6?=
 =?us-ascii?Q?KBKL9XAl0gT4zeNx7YUieiP5QhyPcjhZhhpEryMKZCJI0pABdsZjaUltVQ6J?=
 =?us-ascii?Q?DaO45JIkEUF+jCmly6mtj0PxEMFO3LEa20U79KiFgWWPD9UpAnQO3LpSsqpj?=
 =?us-ascii?Q?A00EINGn9EhqdsL4GDb5W0kRRv3F9vEHnw223q3mr8tXsDJMJLQjTg1j4yaQ?=
 =?us-ascii?Q?mmfZROPf0lhbwztcyj5ekvMpf1xNjcgMNC9X2T14087fUHny5xV3mL8dYcly?=
 =?us-ascii?Q?L+z0qVsg1eGX41d5ohfvVs36w9eohLRj7UiEyDdM0Eedr4Qolsm4FqT8yopI?=
 =?us-ascii?Q?yoOCWZx3G8EEcPbyaEWZdVFcq4qk8ZMBVQkQS76pAKI31zL5Tzf7cu1IFC0W?=
 =?us-ascii?Q?ifZAd2755cEjUgKadnd6GNdOXTHPY6+9poIUKl02xlOd9cSBCBYjixyR8eOl?=
 =?us-ascii?Q?7RSUfR/r8821AmLwi5ewKnHapmAtRB41tvHhI4z3zOC9soWsuvBkzD7070VK?=
 =?us-ascii?Q?SW7Csetz3QkDfwjAvzGDEpDJTHlFCxzstnBIQmcaPTcDzjiV0rn0zbbO2LDh?=
 =?us-ascii?Q?a3ujEXJ4za0k2REZDgyxteIba5vsAC1tNzIFnM7V5PwjCQ4EAq7BTPsdpOjz?=
 =?us-ascii?Q?XG+jsZRGY5fFq9kZiIaUX4CaCQyr9M+40OdAgXzkW4ru5B5DL6nEXGK6d1fI?=
 =?us-ascii?Q?ma+7YaTjeXo4iL1jNixuq13ICk+9LxG91Hb14PlC20n6y6faGPIpEcb0TuAB?=
 =?us-ascii?Q?iemWn4ko4Z2urOntt+2/jNQs1wbAM6gcmptPtde1vKEJ2WEvqL+e18hAH8EL?=
 =?us-ascii?Q?uHsEWK30UBvZItWGjqlc9tQ4m6SxuPLfX8zoQbJQbCeYj5jlSOe9yh6UGU31?=
 =?us-ascii?Q?IwlIbfaNqwgR2MWJ6H/EEE/+QdYnUqb9TpgYJ6UseLd/IG40W2585sJsc7ii?=
 =?us-ascii?Q?mGdsjoqVpVKw53wxuaeqWecv3PcgvHGgfsAFkGgMOKN0p/shLp2cxRpYCgHW?=
 =?us-ascii?Q?r129Wn1aWASn4ti/i8fwjp3pujHiQZnkQefqrzVYYzkBcL1/WxesCH02IYkS?=
 =?us-ascii?Q?enFhyKgVZhM5w2fsqzjnWdUt0PaR/sqo1wCjiUgppt2UP0/jLwkWbJrJmon8?=
 =?us-ascii?Q?1H4JnFyVkzTFOw60PfsYnCL8bS4oqYblGUQGPftUKAFJOPJn0V5eJShrtkkS?=
 =?us-ascii?Q?eVs8PIfeNgqrsQatZR5/V+6Itcepb848+hNj4OYuESM8JGptIUnL3t4JKS4S?=
 =?us-ascii?Q?sqXSzmaJp6Fk5ldV1chBNjMV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9029afa0-1e8e-4669-f739-08d8e82a2aa6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:18:27.5667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8u/IAAmL2Tv8LIePNdDGHuhOUX+a73rwXFSYhjoTg98UrU910P2ZA6WVw7Ih8JWBzQgX7lODEZNqd8tTr+Yp3hjvFY7Sc/z1tRBpKABdJqY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=822 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bodo,

> In patch "scsi: target: tcmu: Replace radix_tree with XArray" meaning
> of last parameter of tcmu_blocks_release was changed.  So in the
> callers we should subtract 1 from the previous parameter.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
