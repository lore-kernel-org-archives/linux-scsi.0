Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 206FFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC68461955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbhC3D4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:56:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50960 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhC3Dzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3isW0088608;
        Tue, 30 Mar 2021 03:55:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bYgP2DRMeocQOefBWDGbY3EzLyoNJqbMXoDtQkLAU/E=;
 b=hTrxCJKsvLrK43P7mgWoaD6ePi2rcVBEzL9N7O1Fjw68uKd6rb3Ss+hwPZPRXdOdwR3n
 C4AxKJHHdMQhlywhbnJbUeFAO9e8MeULR1szKSim89f+KbL2+73KcNrX5J/n3ojN2fjn
 g2gjZLwtGhC4FV1kh3FMmPrE7CTLRYMKzeGrPX+2VsHjVdRCOdq7zCZTBBNnQfFQWXlL
 irqvntV547skTlbQDu9gcEKGtWuN+t6zGMDzUKVjVifp78xmUPZVJGkerMmcY5ATbqpu
 5yAkInXuMqf7XUxpaMzGInAA2/PQpoji+34ScHlXwtoguz1J5Uvtsb9+LHyWt1NS/HE3 ig== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 37hwbndj6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:22 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXVN039572;
        Tue, 30 Mar 2021 03:55:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 37jefrktmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJIM405SrK5B2uEEVzEqMTbyQVP/eqcLIohZ/zxWAR1y9NZeB5KdAwjGV3FR+JKW/8VNfF3hXP1wuZG7EH9zRkF5jIwLmKwJlwe2P5yi+JlycilYuHldRcHf710XwCNEJGfBkWkSjW/9HKhjIuZTpLTGiY6bNG1cSo0KUsIlQ3w364YoV1sgIbUG4y8W6tRZrXTarfCAJHkRsRCVstlpww2xm77u4ZMZktrRJMx1KhPYuAwF4CY/aYhby9wUIyGO+b2LmPmIQ83xiv6uaU0iH+i7RrZFKY6RKwPvYUaXZymOdDxnklIIrb++2k6f4VJflWzF4IONqtIdECxw7R11Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYgP2DRMeocQOefBWDGbY3EzLyoNJqbMXoDtQkLAU/E=;
 b=nJakQjnX02t/4EVW5Z1KL/wXbpyBX9poZ3fr7wR6eT6ThivuY8e1Pk+0WgJaZclD8KxHAxvlFeVbjcw1wOW81i0decTIVOYJ5K4axvz49lCLJ+TcJJZhuxZBd3nPoFC3GRLGjSix7uRnbDqkS5pWwElHPRvuDfUimlxUSNb3T9i8uxCnrthMzOIjJd+yIp4T6P5p5jL6ynOsN9cXJAJhrz43g3WQFLDIqd+9/xjkP71zaoW1inRVjw3BOr6K0CPHFbOunU4eCAfUVDr0U8Tx0npkw/rtSxc7JwCYtdgBQxMvJuHfcvGQ0WscFAngo3qSswXjvBq1dazlwRcj/Zlyqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bYgP2DRMeocQOefBWDGbY3EzLyoNJqbMXoDtQkLAU/E=;
 b=AHCU5+SxurpSpqP1u4tk6vN1xWEkTXvJHXXMZ8zI9I0wr1B7798AILAbz5pwLaGh8Ch3jWhNxFyLNz0oV3E7z3BogQ2CHf0rqXyR9tsgWu0uBI1c0BSmDvztsguPvlooSRT5V92Lmu5XLppdar7I0EXi+qXk/CiVaiIaAHK1/AM=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        Yue Hu <zbestahu@gmail.com>, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        huyue2@yulong.com, linux-kernel@vger.kernel.org, zbestahu@163.com
Subject: Re: [PATCH RESEND] scsi: ufs: Remove unnecessary null checks in ufshcd_find_max_sup_active_icc_level()
Date:   Mon, 29 Mar 2021 23:54:49 -0400
Message-Id: <161707636881.29267.4451416279079072222.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319070916.2254-1-zbestahu@gmail.com>
References: <20210319070916.2254-1-zbestahu@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc356cdc-3607-43b8-e2ce-08d8f32fa31d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760A84A0D2B4B6DF85352C68E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kb7CwOCH64QFeT8/EJPRisGDJtSWWc/AyQF5mnRB4ntacfZ7E96/SQ6OtaAhwjgpMF7j4swhZBegdk59HBMVFNn+Pmr1XL5ID32xDhGmxDgWpCdkvmwxjQYy55uzg8AptBWu8V7f0YG7P71Ebk5/74wqQqjCaMnFxZoSZvQM5MqtZxF6445kokYFlKfQmqgaKFUfChQIgdl7VEfwzVDl1lRgTTNlu2S//MJgOWtGZ2gn++YG5f7Z4Ey+9x0ytLad0522M6bd+DSqyKG7qyJhimaz7S+YHqpt10dUzDmmIAqhu26l6D/Qov9au+9rineLtiUHfpt67j2rz/cxJKGOGQKCCOemHY3/VzqnbL/rWSQ9U6JVevwf032b7SjsMGxA+quAqqaI8NB3DmPyfJJnyEo8VCGIfuRbqHwDj+OLJDjgvxeotZgw6oh7V9PtEl4m1Jp2NvvobuJzTPzNML5yT06iv2PELT62PXzjG0qGcesw1QVP2rDRiPEK8bB3w0OAgqrT5req/NNPg1HAE8uc6GV/A3YdwgexnvwLFk3P76VyYP4WfOfVIWfCsnl50c7Gkq+NeSIsj8Z7rgtH5PxjfgPhtyvJpUvtjpgeDy+HTSotIix9+mfUDZWptiJfUxVILGSBdG2Qnhr524qexom1Od2KwfiV21YDF2trxgsV/U3I3t4I9Q4yQOVV5mVhcLnvNP1B0sZKBFxSZGcCS6rGU8GXqD+mBjdR5RPel0crqh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(52116002)(86362001)(4744005)(66946007)(66556008)(6486002)(26005)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(2906002)(5660300002)(6666004)(2616005)(38100700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3E5Mk4rNmx0c1NGd05HZy9jNXJwWDVzRFBKaCtxMVpaUzB2OWh2TTYyQk9p?=
 =?utf-8?B?RFhNVU1KV1JPbjR3a0ZuQ3pPMUtqNVcvTityU1I2MXpaZkVyUUEySng0bTk5?=
 =?utf-8?B?cHk4amNzYzJFZlNVcHZrT2d5cHZMU0NUY0VHWWJUUkV1MkVQUHlpQmZkcHBB?=
 =?utf-8?B?K0RBSnBINWgrQ2dCU2lnSXB3YXRNSStJQWxZWUVoOFN3VG5lODdCbyt2L3dp?=
 =?utf-8?B?UGNOZVgrd3M2ODBEMkVsekhqRVN1Vm9GMGJCM2tMWStQTUgwUVNzMDNkZWV2?=
 =?utf-8?B?Z3hBV1ZJbFlBWEl4S01YLy92YzRpMXZrbExTZWZad3B4d3pDMDNpaE93RDJO?=
 =?utf-8?B?a2RodmUza3BYN25JaklTOFZoNSs0RW1JMUtNQ0pHRDVBTk1GaG1aeW4rV05F?=
 =?utf-8?B?eVBIbDQ2SWhTS1k5MVdqSDVGZ1JTei9xb29wMGltNzRGTTgvcEVxQldKMXJW?=
 =?utf-8?B?TzVIQnBUazB2Tml2ckF5NW9qVmhBTzRzNDhCKzlpV3lPVWhVVVlnN0U3YzZT?=
 =?utf-8?B?aHFURDdVU0dWelJnS1dLL0hBbVJ5NUNrV0lWNjdRRGhmUnI3RHhYRC84OTU1?=
 =?utf-8?B?eHhMYWU3b2c4UHRjQ2RybVhGaVlSVy92eFlhZXNOQU1FRjUrMytCSmVuZWU1?=
 =?utf-8?B?VVc0bHo1dlVyL2U3SUVsaG5rWmVQK014d0RvUjVDMWJ5MEZncE1PRlVNemtI?=
 =?utf-8?B?bWVyalM0dGo5SXlqdWRBRmpUZThHaXRpeUZRNkI2ZjY3WHlMTEZ4SllMREVv?=
 =?utf-8?B?YTRQRm5xS1Rza0RTM3BMQUZiMlI3YlF3anJ5TWNPSDJZeUUvZU4wT1JJQ2xV?=
 =?utf-8?B?NlhBYm9IWW90dEFuOW9Tb3R0M1NVVG02NWlUN2trWm5Hc0ZMa0lyNnVvVVFa?=
 =?utf-8?B?Tis5WFRVZ1VBZDhDbzF4bkpMUjYwa29oSGRZV1FCdUJxeWYyMTJVODB0TDZn?=
 =?utf-8?B?TU5ncUN6ek1FdXJEaHBsZDhhaERQeFQ5UFNaMHlyUWFGSGRsOEtrSWJLSXZp?=
 =?utf-8?B?MXA0OHk5NU9oRlBFWjNMdEdSOUxXZE9YdCswVFFmM1JUTUhxN2szRVBmMlpz?=
 =?utf-8?B?a1ZoWGRRNzRrczUxQ1hsa29IdVpzMTAwaG40OEFpNU1KOGlPbDRoTXh5aDFO?=
 =?utf-8?B?NlJaZG5lcXRyNjZoZXdPclFpbmFoRThWTU5RalpxWlh0WWxwbU9vVWlMeHJa?=
 =?utf-8?B?a3VGL2crRUJWS2F2T2ExK1YzYjFDR2I2anE1SUEwajVBRkE2UXBYMVFvQ2l0?=
 =?utf-8?B?ODVnVm9ZME56NWJSL3JMb3VUMmJ5Mjk2ZW91bGlQZ2gzUE42V1hqRUF6OUdh?=
 =?utf-8?B?bldQcHl6ZVdoU01QemprRXg2b2U3NWUxZktWcWlibUxtYVdLdnhqTldyZ1dT?=
 =?utf-8?B?WnJJOFN3dU5QRnI5MmRVdGhnVTdtaFFNeXV2cGwvaUgxZkRJMy83OTFQeHNW?=
 =?utf-8?B?Uk5relFSNzU4ZHVmUDNXdXNIN0hKSWFBalkrSm5iN1RmMkRaQmtGNnRBQlc5?=
 =?utf-8?B?Tk9aL0hXWld4MDdib1ZwNmFJN0ZNOXJ1d0k1Yk90THlsMjgvRUJPdzdzZWlM?=
 =?utf-8?B?ejVKOVhNQmRvelF3d2xUVnRIaUJaVG1GdS9CQ1VBTE1hOUxQUTAyeTBEc01P?=
 =?utf-8?B?MGRtQUg2SXJKQzdoK2tBSE5xd1pzT2kvSlBhOTlOUXEyVERQWFhBTmZ4dkJQ?=
 =?utf-8?B?azVqRHk1OTBzVThjRU9ZQXVKTUh0M3FkTzdITzVDR0l4OFhta1RwWEEvVGFE?=
 =?utf-8?Q?xnHDJXF32MWTlyqEpJTgvbYfXEMsuuDsad9fLzZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc356cdc-3607-43b8-e2ce-08d8f32fa31d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:20.1479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZUAtO12bHS1PNJC78ZYg9AABjzyqxBDa98daBKNXrMeNueOzURFRDg7+m6uURDLR/RGus4cxf2p5aw0Q1sDa3QWjbAxr+QN2UIctMj9T8Pk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: wUJnh7peEs4GzGFG0N0ci83jjhzpLBwy
X-Proofpoint-ORIG-GUID: wUJnh7peEs4GzGFG0N0ci83jjhzpLBwy
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 19 Mar 2021 15:09:16 +0800, Yue Hu wrote:

> Since vcc/vccq/vccq2 have already been null checked before using.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: Remove unnecessary null checks in ufshcd_find_max_sup_active_icc_level()
      https://git.kernel.org/mkp/scsi/c/0873045f63c4

-- 
Martin K. Petersen	Oracle Linux Engineering
