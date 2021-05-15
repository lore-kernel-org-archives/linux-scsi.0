Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422E9C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB95610E6
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 22:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhEOWRB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 18:17:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58194 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbhEOWQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 18:16:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FMEpoO093534;
        Sat, 15 May 2021 22:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VDl9cYNWOsFKuFM7vQCebYI1wUOVgmWMoz1h87Im76c=;
 b=A72xfNzTQsWSYCQ2ELYTR2jBAZ9LxwS+8+nivwh2X3ScaRWCVN6X0vO+XbcPeqGWODtq
 6j8I5qj28RSRJ/7sqwONgbjCASXD+QmTOvw72ahiLNbcONu5hiw4NsROOPooybzM03Wi
 pG6jo1ZMVIXx3Q9W5dotQkZIjbhSN1Su5Gy9BYEXasnLW2oDyF2RGV3KfXO5FVNdeuXo
 yxqOkZfe3qAiCIXWaEYNBzeypEoeTvAabcuG13SvRKUUJ2ZrckF+7aS40g7uHK+MF+4n
 yf8ejOmdVynYELbyptN8u5VC/2+qMVCIw9UJfnj1qTm1YGIXbXo/CV6CHhEvo2Bk/yst HA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38j5qr0rkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FM6Y8C033122;
        Sat, 15 May 2021 22:14:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by userp3020.oracle.com with ESMTP id 38j5mjqnef-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 22:14:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEA8bbjHDsGGoEliYPsmgN19uTM5O00dggXDR/e9Dpi0fT0m2nTQLCoLx/pfqZyH7rwGs10DonB/7hhTwaj6Kfl9gQHe9HAYarF/aDK/TDMxo1ttQokNAVRlsNWzjBuLebG6Ez+EQnzEAX5IZRYZr7JnuA1RzaJ3jwiHVfrHMV6WDBj8Qi9+cJTNuqA74MLtQ63DPdXQ92IMZ797r21fh730uUKM9/a9RBHjJ7vgpquzlyxfHmfci370dL43ase8OmMlMM3i3a/rZSpIrESz6MQS8QMrb6qLwoSLFr+KjaGymNuPHDxIzqh49GGPuPjbg2F718MEhPYXu3hLuG3J5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDl9cYNWOsFKuFM7vQCebYI1wUOVgmWMoz1h87Im76c=;
 b=HNthPIrgPHSIeVFUETafu4zs5PPUTG1TQ5hUikdLXbkKRhWb/NDOfd/clICl9YMScJV1HqzsdS+IDheHbTzxPgMRO7RKu0lz43d5X/lTZ/NI/fH5Lg9OJYTswuutoEkYUOJE5W2mmceo1PlO0PEzMI33pIvzjaf469wN+BpqqYWazwxam4TgNBWVPDMNrXNnSZsaTDmrHj/geg63I391TB9qI+jCkJDkGB0GUD+Ry6qYwkgyP2rCsyG+JQsTWRVf4FhuXg1TX5mjGlAHB0sng5dmjJ/iwISph7QrcU+pzpbGuH2ghjrQjstLe1qSziQHpezN8U74n9edsLrlGqdrwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDl9cYNWOsFKuFM7vQCebYI1wUOVgmWMoz1h87Im76c=;
 b=RwHatfsa8/FL4ngTfVGwRxTQ8lT4dUV0txA0lH2rPQPPizftkXNC6c9kdUGArKp+sgJWBtFGAw07gkEdZEL5I2Cxn+d55kuOAE1XW/o37eReTHZJAKTPT3gw8/2twwSE6fIBFH8plexOP6SGlL9npbVkZbTj2cP+NR2eDtfA1IQ=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4583.namprd10.prod.outlook.com (2603:10b6:510:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 22:14:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 22:14:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()
Date:   Sat, 15 May 2021 18:14:42 -0400
Message-Id: <162111686571.18985.2027451209611091232.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210514090952.6715-1-thunder.leizhen@huawei.com>
References: <20210514090952.6715-1-thunder.leizhen@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 22:14:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab0b9a96-5080-425a-ba12-08d917eed9f6
X-MS-TrafficTypeDiagnostic: PH0PR10MB4583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45832B26533D2C3DDDEFBFD98E2F9@PH0PR10MB4583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +xv04CVakp5xjKcTeslOHaq15AVnv5soSUwXinkLbMFgiGwq/eSz9t7tNdLRLHIElbe1rjF/AsZYmX2D4eCRfB571Hc9JdfHqZq+VhV50ll2SBjIfd8CTFKl2WKu0iVMc+gaAJA7jSZiQQPWxXq/7mDvNiiStm0derxBzXacnDkeDMzOQo8GjXVQ/MPkaBG9O3WfNtpo9gj3wxXFwcEblw0Q4wc/kntKLRk28PnSK7q8zdyCvRmBHP8E6Ah7KASD7a3NbF4VduBSb5t8fA1rf1MuyyAZlAE+y9TVYKUeWxol2nsqFlmSrjeVup/piObzR7big6jsrXjh6C6fHT4hqGne+gxO33rMdnlPB9G7uRUx47M1tpRLNG1sAjJNeylgDD5vSLdds2r4mhaPiKVvJlCJnGezsCGVKQKEmvoE8nbP2UIaEDq8LWTAHGnGeseGNsb+1GJcZarZizZLSlT5f7Mb9c09kx+wq9T0kowdRDY6oXEHfkiFknAJX3EuhlNYuTJRbMyYt7uQ8jIPEBZZjVaVeIk1qxYL07GywXF31Mu12tNLU5CA4SuRSVbxw7q4tLEN3DMUvBiiD+gQbLx0gNvNn+cJvZceaQ0LjW5dhfRssvCgoJANRxLzZnqdfkNz1N5VRoKvAYSOTMpzf2u+n2lAzWDBUlyDGmfvGZZ1lasHrqRakF7eb/R5MhV07EsPVZ/Fz1OAdlhYg4pBwoDxVa3K+I9fS8/jP9frCbAf+inXahJQJF7gxwsdrK3RzOikxU1hJ7kbhOHLMtjGcym3Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39860400002)(136003)(346002)(366004)(8936002)(2906002)(478600001)(7696005)(66556008)(36756003)(966005)(66476007)(4744005)(8676002)(5660300002)(4326008)(38100700002)(316002)(110136005)(6666004)(956004)(2616005)(186003)(16526019)(66946007)(26005)(38350700002)(86362001)(6486002)(107886003)(103116003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V2JhRDBxdmRKWE1LZzhIWklhS1FKSVNJdXAvZ1gzOWx0RFJrTlBxdmdtMzhV?=
 =?utf-8?B?d3FSNUlKUGZnYUVwOXZTZXpCY1U4cE9QUlprWURIZGtLMlNsdnJZSFptdmZm?=
 =?utf-8?B?dkxjaFRQQldzRS9PTjJUN3pYeHN6WjYwMUJxUVhLK3IyUnFkK29TMXhCYm9Y?=
 =?utf-8?B?VWFNSUhMY2hqSGgxVnVOSFp5NzE0MEtyaW1aV0R2NkxwS243WkQyblBFQTNB?=
 =?utf-8?B?b1BVbXRqOVd1QzQ3Vi9BMTNpUlptV0JRV1NYdmJIMytqdkpCenRNT3ExeTZl?=
 =?utf-8?B?Ti9FRVBZa0dkVFptWnRoM2RXT0VXRVFSU1RkcFBSenlzRjBDU0RXYk41eE40?=
 =?utf-8?B?TjVrclVCSFNuWE8rRmZ5bnNrWHFzUWlpcjdzOEJ5UjhPQ1NRNEhTckFoMFRl?=
 =?utf-8?B?bHpXNGQycDZKSngvUVg4ZysxdkIzVWY2WTBFQmtQK3dQUTJxUkNpRi85YWt3?=
 =?utf-8?B?WXB2N3R2TGlwZU9JYXNhQzlvNWg2ZW1OWk41ZGJ2K3NxQjNJeXNIUlVLakhv?=
 =?utf-8?B?RVZKc2dtR213akhtVEZiY05ZZ2NMMnQxZHJCOHdFNXRBQUVNVXdBclQwQXlh?=
 =?utf-8?B?U2hnbjlldkw5ZkRUeThJRWZ3YzJBSCtUQUNaa0wwNnZuMWdkNkFWOXVjYytG?=
 =?utf-8?B?ek5Zb04xR0hvZzMvdG1JR3lxdENxcVdyR2J0R2JwTTdiVDJkYjFveFg4TXZm?=
 =?utf-8?B?aWVLeXExdUg0VXhKWWk1NEkxeTJQN0hhQ3BsOE9UT2c4eVZPeWFsMkxnbSs2?=
 =?utf-8?B?dDFaZHkwQld5WjEyWDlOOWdIREM2aGZtL0dkYytIMVk2WG96WHprNS9RSzhO?=
 =?utf-8?B?OC8vTWJIS05YdjBlSk9IY3ErVEgrQnlaSWJvU2Y0dEI5NEc4SE5KWFZtclpo?=
 =?utf-8?B?NlBqYytheTFhS01SNkdBZFpWejc0cnY1SzBwbFZtSkw5d3Q3dVErN3kyZldn?=
 =?utf-8?B?TUF3VWdUelBpZHpmdFdSUGY2eEE1MTN2MHNXelhSSFdzaElHWFNSMktYcXhm?=
 =?utf-8?B?Q0diSGwwV2c1dGpwb2N3Lzl6OFd3ekdRaTQweVJFNEI4Qko1dWZ3bjYrRXBV?=
 =?utf-8?B?Mk9PY2pNeHNzb3FOb3dKQ2h0Rjl0Y25IQ1dsT3VaQStkVDFPODUvOUxzNmpp?=
 =?utf-8?B?ZEdXdzVuYngrNEtVVW44RytKUno4SHRMeFIzRjA3Q00yK1NsZmJqT3NJU0hq?=
 =?utf-8?B?TjZJTlhLVUVLSUErNm5IVXhNL3hKVTA2L2QwbnAxTHIzWHh4bDVVNktzZnpK?=
 =?utf-8?B?ZWRPOWhCT3A5RDZvTHBwV0JqVEV5Y1pkVmxveGllN1pkdUFjQjc1SWcyMUsr?=
 =?utf-8?B?NnhHY09ZdHFYU1hkdXcyM21Wc0tUSTVGMzYvQnpQbGlDc1lQT1NaeTBSc1RO?=
 =?utf-8?B?cmFudUFZUXdTT0JGcUVPZDB4UlpSZUtYNHpxdUlUQnYzczhQTURCZGc3R3NL?=
 =?utf-8?B?YTg1dWtHWHpFL0RyRGVKblY3SFhVbjE2NzNoNEQvdHp5V1J0ZG9SYjNrMURC?=
 =?utf-8?B?a1hrd0t3TUJtTE9rUUVvbXpzUCtpTE9rTUd0MmV2OTR4d1NrdzlKc0pRbUJi?=
 =?utf-8?B?YzFMdjNHbFhYSW15cGdkVzlGQnFSY09oRm5iM1dBSkllNHhqVDZKY1hPcnE0?=
 =?utf-8?B?dXcrczg1NjFaMmtiSm9tMng0UE9qTmhwZXBJcG1neVNaOFMwb2tqRUlXUUJR?=
 =?utf-8?B?U04wSWI1ZEJNNzcvZjdlM1Y5OE5STEZ3cnZNVHVHdndLdEhVNE9HSVVSdTdu?=
 =?utf-8?Q?ObcFRImMWYIIUhqAz4NLqaIDWgVi1x1t16LqBoH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab0b9a96-5080-425a-ba12-08d917eed9f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 22:14:47.7609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWu1yn7yWzvTMIAEq9SGTtTUl93Q5wyuqsViP13zlqwmltiRo7vkpDLjyHWJA7hmlzawXz3uaf9TEcYZY0be/QDrWUU0wAJkp8QFZO5PEx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4583
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150169
X-Proofpoint-GUID: Lzao9ctNRT849Qaq1ZonaFKcTVoiUvI8
X-Proofpoint-ORIG-GUID: Lzao9ctNRT849Qaq1ZonaFKcTVoiUvI8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150170
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 14 May 2021 17:09:52 +0800, Zhen Lei wrote:

> Fix to return a negative error code from the error handling case instead
> of 0, as done elsewhere in this function.

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()
      https://git.kernel.org/mkp/scsi/c/5cb289bf2d7c

-- 
Martin K. Petersen	Oracle Linux Engineering
