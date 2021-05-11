Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2ECC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF2661623
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhEKD04 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:26:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41124 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhEKD0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:26:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3EdYd149481;
        Tue, 11 May 2021 03:25:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=r+6kWF2Pd3o1G1snf0oVFwCda+zB1zaR03YHsGinjGY=;
 b=PFTi4Vv+BK+x+uuAByHB6UG3AwAQlpb+H5tK55cras7fe3Hq11g9oZ/s2uD4h/r1rr09
 29WmLAct9Dtg+/6+bqRB6wh53gyoXpJ6RSb/EPic3rZQKLQDu7Ied5onQw9xhyScj/mg
 SJ0ySZll7ODWQo63z+88EZ23YyePZeUEZYCOtSxCI4MNJI0gfVBn3t0cCL5JCxIhrQBT
 3EcYJ6CdLG6czG8qMuCJiXNE784R+zZRmWfiY8jwlJOZOogoeEwuKn2TJl+ZTBk4saTC
 U4DqiL9/fIJ4eGdOtPo6MlS9oqt4Uw42TsZYUGz1fYoe7WKc2SZusx8baPAPzFZJXZr4 Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38dk9nd7bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Gd1N153264;
        Tue, 11 May 2021 03:25:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 38djf87ky6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lciQ21y1eUrOg7ObY46Wj60ks08Bs9PoyledwC7FIGKZXiZKVZIO55bWMajN8ege7f3FiHW1MF4SBS3n5bqRw2NsCWYyd4U95racmQkLVefPvgEuMVZQeF5Cnb0ZzysuYa3xu5jypybkGjzkCS2esAhVvyNXWtSYasaaAbLbldNIVMYBfa1Hj3+2wJZ/uhnhiyVWN2BNODzcprPQ4zJlBobcZAKO0UBLfCbQ0j4snvVsqjnHzf+5UHJxrWIjRRsi5Y3KOE8GqcC3pAaq/TsgQgF/UMAxMRsTVg5j1DMZW1ct8WK7fuO5vrfjhmUS0ljllPoVab2MIHkJz/FoPxM6ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+6kWF2Pd3o1G1snf0oVFwCda+zB1zaR03YHsGinjGY=;
 b=kzFIRHcMTp5z6cxNPsG/Doi+6FBmYb+8nUtvgXmz25iqbly0jg/Tc+CdASsfMcaSULG+SUV42B2MkVEoJxOn67u9c107VRieJ2TYBV0iuTQuL5CatowjgScSNzplECb65v2hJbonjmi2CB/Mey7hcyFkx2Ugtd04H0zmcPxa+3EbvU2lzDqgLb3hpCwnkPeSPS6bXSlBBzyFNXN7y+gYhMD+eOU54FBZ6ntzLufPegOXgF/igeS66L2svoF4ym0e22T4SYtFjuTdxnmtpxjhhY9nPzyT2HoDljJG3/m2nVTjKVC0JMjcNH4aGwQm2XFUlD7CgKS/ClxSoEM9K+LHCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r+6kWF2Pd3o1G1snf0oVFwCda+zB1zaR03YHsGinjGY=;
 b=IUp5aeO1QGhmvvURxwEmHne6CLRcINfpFamFaqBJxBIoB3Ff2R18rlVH+fn76MsSFz+BqEweOqN6aAAB71z7wi9Y0qSU5X885s4u0s/6ZLh5EW3MVsPxxkApUDE8wjKLj/owGBTm83D2EBvVJ82gqJ4QLJGGI5o3noqE9Cdc+0s=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Colin King <colin.king@canonical.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: remove redundant assignment to pointer temp_hdr
Date:   Mon, 10 May 2021 23:25:26 -0400
Message-Id: <162070348783.27567.9866090695685780934.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420104123.376420-1-colin.king@canonical.com>
References: <20210420104123.376420-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3fde5b-eaae-452c-16c9-08d9142c74ab
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440871DBD0312359EC3F5DEE8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkqZbmKFqdhtgWAFgEDI2g/6qPqfdUYxIugmfFpOAuV34qhG11jSXGgbRIlhQhRkzLkYV0P0sGwVhAtIXgHaCffWKrJn7krZMSdDzK+4mjUN3VHBrCl32BqG8K1aXlXxSjYriXBN4cKVk3HeJkVm86OiwiUPsIDgF0TikaTHK5eg9aYfn03TROeR5nachn3SqmP548tFB0hIMgo3u2uUassV30IoEoBWWwl2MrEQoEczQt+7ao9xsKvPzxEEwKtykXbFN0oIewtIg7XQ0f8ESVR/75eS5fxneDHNq3lbjHw6+ao4kTQhp5An35NEWxCCcC4bZgzNo346Twli/Tt+SwnCDXEyaDDDBtvE8Zy8RQ+S/yJwC4qKBk8hT8AvZXQXgfbY6tiuAo+jpohYjUzE/98zXE6XDXuKnVaUOx+buqtfPTA5wu+WydebWc6N8j412iYnoJ3PR2KTlV3E7oy9H4MXEItXMFTEo0JC/0yHhM0MM8RP0abtLDAb0pL6N18WcFopYMIJkp9HShgYJpek6jOSJ4h88C/er+nOXGKG25t+hu5cyLPfsgCFrFhWknBXfgOY+KxdmcBy9RwDpJfrKnZpqywqiXsJT5hRTCr9pKE3y9WckNODqNQAZFrlmttKDhv4ZrlubAe4dNiH+AXOxTAT58P/ZYw0/iPQIfr7RRIUFH6dMSB8d0Bp2cTPvWW1ltkl4kr8X4Q1EBhsqEvccO15KD6fmPysEBKwXWDxuy4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(5660300002)(66476007)(16526019)(110136005)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TUFxdy80QllkRUdIQUx2UzZMOWpTNko0UVp2a2tBbmlERVkrSzVKc1ZnTjhU?=
 =?utf-8?B?T0FCZWxKZUk2Z3RCRE91MGZPWmVmcVlGNitXY2N0V2dtQWgvS1NXNUR4eXAw?=
 =?utf-8?B?ZmpWNE0zUzVrcDA2WXIvRlJmaFFvQkt1b1BkQ2ovQVlTdFhXY0R5bUI3cjNk?=
 =?utf-8?B?YzR5Q0ZoVGNBejdOdjNNdGhNS2tFZk44RitEWElCQ1V2TkxhMjZNekhldTBt?=
 =?utf-8?B?VFBNeFZLN0ZMYzJuSnVjd2gwaG9RdkdoTURkRlltV2MxOFhnRTJkM3hvQkNl?=
 =?utf-8?B?RUowV1JEUFFWank3WE9xRmFjbEZEWUcxbFZZdGo1bVdUWkl2bUtPd0RFTWpV?=
 =?utf-8?B?WjMzWittQ2ZKcnhlRWdXZUM5bllndnFHOS9WNFBwUFFVSmxaUTBjb3lhYWVr?=
 =?utf-8?B?VU15QnBqQ2s1VjFDekZLbDN6WnVWeTJqeTRLdndUdWhwczdYcjdnYitnOEht?=
 =?utf-8?B?Tmdpdk9iTTFSZ2VoaGJxNS83cTkvL3duSDYxaEM1N2NWK0sveEhwTlpFbm5o?=
 =?utf-8?B?V0VMVENZSjYzd2d6ZlNkanNFYlJzWnpWc3VCKyttZzU1dTlqUFJsejJ4bVpW?=
 =?utf-8?B?TjgyemNwOE1GUmNGT1hJZGUwVzIvVGVnaUM3R09xWGs1bGtZWSttcU9oR2FR?=
 =?utf-8?B?Y3FZbXQ4VTF4TUtMc2J1UmlKa1ArWnp2ODN4amVSZnNVNEZydTVnT3lBVWZE?=
 =?utf-8?B?cktJOWRGR1hEd1BOYTl1RXR1ajZ5T1BBcGRHckFuTy9QZzc0MGx6aUpqTFFu?=
 =?utf-8?B?Mk5kTzB6VTBISk9RZGF6SFhoQ1AwOW9EWnE0c21tdXlwTGZ0cjl2Ykl4YTd2?=
 =?utf-8?B?US9IREoyZ3JUbHZ3LzBsMDkxTDBXQnJtQ3RmSXZNOUpDK2wvdC9LazEvMGw2?=
 =?utf-8?B?NUhyWU14UXdLaHMyaVJEVEg3aDVueUx4VkxINEt3Y0RDQnBZZHpiSVdYMjVm?=
 =?utf-8?B?bklmUEZBYVc2MzIvR1JnQ1VSOEJxZmxzVUd3SkxMZFMyQjZKU3pYSE55UTFp?=
 =?utf-8?B?UC9jZmNtbFp5UWFwNFFsNWgySHdPZTRjSnNKLzM0eml3NFNEUGcxalIvSW8r?=
 =?utf-8?B?RzdvOTB4VlRZbzVWYzJqVkJ1YlkrSnJ4dkF4Vkp5dzJkczlHSEtYRnQ4UUpk?=
 =?utf-8?B?cmx4MEpITXpBSVAzL1hQVVVaWk1qK0VLZVU3R3p0V0F6MS9ndEF6clRqNnlv?=
 =?utf-8?B?bitOQkJEalVmZHU3MUhYWWw2OTNKTllRd2t3TVg1andSdzlObzc5ejc3TU1v?=
 =?utf-8?B?L2dzK2FDQ0NuL3dJSm9WZU1vRTVHcy9jdzdiRVl0cWNpdExkOEZpTzZ6ZUk0?=
 =?utf-8?B?bFg1QlJnenIrdG40VThDUlJMQjNwdXhqYXJpUmhETjhjbUlPNERuMkpiVXZW?=
 =?utf-8?B?dnNTMXNBYzZjN3E3cGMxZ0h5bDYwV3pKRkgzb2c5VFRGL2tSVWwvMG5BSDhH?=
 =?utf-8?B?aGJqRFZmbGJTeTNhdk5QTkZNL2dPM2llOUNyNmJxc1lldFkzeXFUNnpwclN2?=
 =?utf-8?B?TnJFaEZRWUwydy9xbFFLb2Y0czBkQ2I5SE1kK0FRaHFURzdsZ0FpeVRkRGlW?=
 =?utf-8?B?OE14TnJyNmFhV0k3NHZRN1hpaFI3dlhyT2N2UEpXUEJuWlVFVGZkejRucCsy?=
 =?utf-8?B?MUZGVkhaM0JQa1crRDlKYVhjSnJnZGFTVCtpQUROZ2llOXB2a3NiRFFFOGoz?=
 =?utf-8?B?bWtCTVNkZzludWEzczVYTlFJWTNxVnFKVnZCS1Z2Z3kvZy9CeUMxUHZwTmRQ?=
 =?utf-8?Q?aPQ1LbbwLAa5EQfbzhxfczhqzoAi/JKQKpRfW4B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3fde5b-eaae-452c-16c9-08d9142c74ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:41.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2hxHMGEQR/UWkRNCduESw4xotj3lcAVujnbqw5dckTNgyCEBI4qn8ImC1L/zQ3QhZCgMD2M/YAVXVRf/3GxGIX4BIKbd7P115kjV94nOcpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-ORIG-GUID: IrwnpLqQtYsua-39wbeLBhPBPh04Zl7v
X-Proofpoint-GUID: IrwnpLqQtYsua-39wbeLBhPBPh04Zl7v
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 clxscore=1011 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2021 11:41:23 +0100, Colin King wrote:

> The pointer tmp_hdr is being assigned a value that is never
> read, the assignment is redundant and can be removed.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: lpfc: remove redundant assignment to pointer temp_hdr
      https://git.kernel.org/mkp/scsi/c/52b259908114

-- 
Martin K. Petersen	Oracle Linux Engineering
