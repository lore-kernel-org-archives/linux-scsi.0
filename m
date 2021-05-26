Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3F2C2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 225A961438
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhEZEJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53558 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhEZEJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q4188v115997;
        Wed, 26 May 2021 04:07:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vVP+BjlF0eaWcEGUo4xvQ8/icQNad5nd0uOAcUftATo=;
 b=BOFZnlVAcsbHYn6PIRW98NpEZfVv7g4/8hKgZre64mqpH9PIz6pEorRYDNxtd0KQD+9P
 3uYHHlrmXTmHfZAjaJg34EYCAvdM8SFmmQym6WI7xz2/3gRETaE0JhhxJ/8o+zf3jcxQ
 U26daY9n+QAeRU15ViZ8gAJwp/Mt+ZmsAJIqB7JV8gcDeuiMjIirrHanstKCX2LsswtQ
 F+txd8/vc4lYWPF9Jczpy/uyDhGp39No4dVCvuTx5jBYJOP04j/5+o+CMZBublUYZywU
 J/l/Cm1P/fRB5JznfEuZ3z6s+d/lZ3tdYkVHgxOOyuDTqHj//NAUstncuNxLDffusjEQ 6Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38rne43bd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q45I3q142537;
        Wed, 26 May 2021 04:07:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3030.oracle.com with ESMTP id 38pq2uvw7d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAbNwXeXx91aJhnyhuEcZT5GDi7jC35MazXSWnqHu+JTMhBWOW6hm26ErmCfi4Umh/wqnrKQm9fs/YVyvLv+mpwGJsLganUeAyNhaXkb3+22/UnjBv80IG9IQLy3Gxxn0Z23zMs8Oo0NhuTRIrMhuXRrR5Zd9v5sE/RtJRiMHdZ6p5ag9yPkYqf5xR8siUaqgaR48Gh49f8qtoeQ7FaQuaZumMdJFfpTpeMNSBsc4iwkJu/pm9hmFe+Gaah0IkWuEGOmLsLqCChqrHIkDtnVtBNa3xRaj/yuOtHmQzb8MOgOb/PdMnA8UUQNEKXySLtKn1Hd4m35wfKUcn3O46zQgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVP+BjlF0eaWcEGUo4xvQ8/icQNad5nd0uOAcUftATo=;
 b=jsGoWZcEBQ8Gl+c9KMv3jRwcYMwSNziMVOZ7csxCxWy6JLRaPNHTySXXFNkwq23R8GLtg2IBjnA+rPRYe/SaqUNwrngVtsj1oF+hyMwXzwts479OmY/g0+Hh6mM6Vo+aQ3s+41DO7eY/QGplpXUvjaGbGp1zF6Mq6CfqtQrbvDHkehe3kypVeG5KGE11TFBTEdCDcRJANR7QSHABNM7XVuCcQ5ID1s9xBm7lYUA7Eqr+K9aV7Yc+J6ghfk0+a3sDrnHZgB+icpIlRn4htsxOgROb7oLJDjyIrgRK/tBLwVqQ/cE9siLwFbE5J2fQJyktRImYCB4YrJFFbbmUq/IVWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVP+BjlF0eaWcEGUo4xvQ8/icQNad5nd0uOAcUftATo=;
 b=wgksQKjjtVfv68UTQVSMiAed4CBeds946nkNkBwgXXlQqjUk21w3xETX9FaBpNaCTxVD1v4d4tNOh/R6PoWjmc+CSb8GYl4hXU0b5CK+U2qg6ai17c5lcOQriHUA/aP4cG5xgn6LOqDiXPEabDtHTcTxFU7y7UVkxQU9xO+mE6E=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        juergh@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: Remove leading spaces in Kconfig
Date:   Wed, 26 May 2021 00:07:26 -0400
Message-Id: <162200196242.11962.6891429224689951159.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517095835.81733-1-juergh@canonical.com>
References: <20210517095835.81733-1-juergh@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf8c2fb9-376f-4a16-cdd5-08d91ffbd2ac
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB446987E8730738594460A1F78E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D/4MKBxAF0X58Rb1iDw/SaP86R57gE7CO18jxM3zdBJ6EF/Ysn0VhJ818AvC4ex9UMXTjSEmP2zFH0sm98rYSRDJZGy6Um5ghwf8A5LJqwLRyh7PxMjBh7eC4g68XWDAvFUWokiqYVxlJ+nacj4G2VH24DVl178CFghMx5Z/U6MuqlRyunTuuBJjobrVrFs8rjJj7XTHPWHZViBQPWBhFWbw9zd1RNSqDul6SYaoog7dnEb1OFyMtbeSxysMWDiMJX018aNhEN2xxlA8RQGrCo9SNEvDhqoJjfUyTjVGwRDVlrjo7Fh3a7J3eVcCIe/5MaWE/Cj8iP4HQ6JKySCM1528HZwCO2n/EkwCUORoH0RRbUg1gkz+2pWaEnkoT/TDbpH89PGUsI4hXhMk7CHjd1pj2dGqz7Z5yJtipBYnQvWXhQ6C2lHslOJjcwolJLRSMLbKMCk6eUjvatL1ECiw2Vm4X1FSSnM8tOVg1pAICxoyW8iT2PzrzHl8It5a0kxgFpK+L7DNH1jABQM6zSJq1Givo6G0FIrDTOdraAtK/iCzqjVv8Su41fDRciurxqwrrPe4D8azAyVb5dIDe2EpYSryn5dP9eMu7LqcrTbyrYsx3wPHic4CJShE90NsB5NZBFbgPLPMfH1ozOcuQXPQKQX3n6bxHBAYMrLFumZhnuw+mAzd56kcAOIvw4o6bFQ9y/y3tjfGZYPMFGSZhbGwKrdyAFCbhRDUm87yFMo0evkr6h8PrI5ezPsqzhprZyBOmJ6zlBlb3rYhzfTsn/2tvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGl0STZkNmNjRmFjZENlMlIvRWVocEljQnpVcGJnbWlPc0c2c2pZMkdOVnEw?=
 =?utf-8?B?REg2VHZtNzNxSWxvSy9ZN2l6Sk5JV3grZ1Z2TEZEQjRJVUw2ZXdIRmZkUTJt?=
 =?utf-8?B?Z1Y2VUw3ejZsNzU4RGkrVldEQXpuVWRXTTA3dGhGeXV5WmdwdWtvenRBOW1p?=
 =?utf-8?B?Yi96dUdyeUllY2FQTmM2S2J0alJxdnRSaExvelM0bTlzdVhJNW05THNIMDNm?=
 =?utf-8?B?Q0VhU25YcWJxRXdWYzNXWmczMjdSKzJmbU1SWExJTFRBVjE5U3VsaDlqUU9R?=
 =?utf-8?B?QUtWTGVrcGo3OFFwOVpyUkF1b29kakhIT28vL0QwVmJZNyt3WHRtUDkwYk5z?=
 =?utf-8?B?Ti9qSGZZaUJKVWg2dTdDc2kyNURvZm5FbThsa2lWd0tCVFJTbkZMSWhFL0R0?=
 =?utf-8?B?UFJSNG16UmYxcnAzWHZtUGVIQXJSNUNBQmE1d3h1RDB6TnJsVFpGbVBLNWZC?=
 =?utf-8?B?MVo1b0NnR05ic28rNWxMNExuSVBVY09VVnB0aFVOMDN6dTdOUFJUc3phSXZE?=
 =?utf-8?B?Qy9MSlFVQ1QwSEF2TW5JSjhZcENTREVKL3l0ZmZPOXdGRnYwWk5tU0poSVBn?=
 =?utf-8?B?UnIvYUtrZjR6c3JzRjlRZ2V6clBVVTEyZm9VSUM3YTBKN1hGZnJHSW0vakFl?=
 =?utf-8?B?Q3l0c3k5R3FicEk4MGZwL2pmc0hWMExtTGtlQzNBaUZDUGdIeVRMRkE5SlVz?=
 =?utf-8?B?UEc3SW9RUzhVZkVuUXcxcThtTmRqWVgrZUlYYjNrbHVMWnBNWFp3Wmt0V0sx?=
 =?utf-8?B?a0hXL2xlZENMaWNrWDRRSURHUzhzeW9JWG1qeUtudTdnRGNOUEF3SWxscFRh?=
 =?utf-8?B?VVpLRFZ0ZTU4SThkR3U4SlRvby9qTXJFNk9KUEdNQjl1OElRMHJtcnowK2w1?=
 =?utf-8?B?RVppUTlxN3VyR3Fmc0JOazBuckkzaTQ5Z0s4WCtBTUY4M0pJaTdHTkx6N2gy?=
 =?utf-8?B?ZjdOVUd6bnd6WEl4ZGFpTmdjRHF4UWxFVktYeTR2ZkZVdFdZSGoxYXhIcGhL?=
 =?utf-8?B?K2d0TTFTS2RZS2UwTG00S0NMR2hLclBqNFN6NTlWc3ZLNEV3bU04U0ZSbHNr?=
 =?utf-8?B?NDdoMGJ2M1IwcXVXR2gzNlpJNlZBRUNWSzUvb0lEaDdJd2FNVDJFWXZEd1dK?=
 =?utf-8?B?a24xV2RTN2Q1TkFJWVMyZ0dDSkdIbTBkdnNQRGxyTVBhbmlFWHBFN0RldFlG?=
 =?utf-8?B?UExockNMbzJmZ0FKSmF6Tis4c0hyeUpUdEJVUFlNaHY5MFFlUHY0dTBQVENC?=
 =?utf-8?B?RFBZSjFzTHpGTmxTaG16dlFJb1E3bUtUdkpUV3hCLzBsUXJOQ3FIdE9tSUZj?=
 =?utf-8?B?YlFxNGtxc0N0bGd1bEZuQnc4dyszN3h4VWZJbkVSSWd1c2VkTDl5UHh1M3dr?=
 =?utf-8?B?ZGxNL0VlNmhTemFVUFJyM0tLb1dWaEdvL0VYTkFzL2VxS2VYYWR4TlFxZWMv?=
 =?utf-8?B?UE12YjJDVVlWK2FBWHlydjdud1ZXbElXcDIzcUFnNkw1VCszdWVVMW5Ldzc4?=
 =?utf-8?B?SHBXZWMvY2RsMG5YdlVlZVROL3ZoTFZLWTZDSmhmVVVEN2sxUS84Nm42N3NX?=
 =?utf-8?B?Q3dFSzZxOEJ6QkRONzVldm5rbkl2a251T3U0VjFBNG9sQ2dzc2pZY3QrTU5E?=
 =?utf-8?B?a3ZsQTYzQnNrbHo0eVVEZ3FBemQ1ZEN3QlhxcVdrT3RGN015TTU1OGhXWlNq?=
 =?utf-8?B?WWFDbnNtRGFMRTRPYnZyU21YNU5pd09RK2Vhc0hxWG5JUC9qdzZiajIwVEYw?=
 =?utf-8?Q?aA6fYSJ0oTEn4/yMChhb9tL4ZMSbMY3YX1cJ9im?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf8c2fb9-376f-4a16-cdd5-08d91ffbd2ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:48.3419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T37H8ExfbYVNX2bEbNJUnyD+3p4DGNtHWqwVtOS9IXze7NA4TETJOIaXn469ll1Vp8CJYhg5XmHO+6oSYi2fXTme1eUVu4jRuvFaJnKwXEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: M8lgWWb7SCZBtZz1Ys3zJK7DQukxNgf6
X-Proofpoint-GUID: M8lgWWb7SCZBtZz1Ys3zJK7DQukxNgf6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 17 May 2021 11:58:35 +0200, Juerg Haefliger wrote:

> Remove leading spaces before tabs in Kconfig file(s) by running the
> following command:
> 
>   $ find drivers/scsi -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: Remove leading spaces in Kconfig
      https://git.kernel.org/mkp/scsi/c/98f92dff1412

-- 
Martin K. Petersen	Oracle Linux Engineering
