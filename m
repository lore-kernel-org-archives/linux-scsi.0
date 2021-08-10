Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1B4C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52BFD60551
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhHJFVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:14 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11076 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236140AbhHJFVN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:13 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5AfMf011974;
        Tue, 10 Aug 2021 05:20:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=W62n/HI8+NqhxvJQcP3tzLtGKY6xwYT+cHIj0WWTBZ0=;
 b=D9Nnp89PJsmS/OX6E0m1y14IibKP6zW/KNmI5RDKqadNi79irXQkMM7oW85Sdnpf3uQO
 UZpldoLBzq6bxbWhY0gXbXuGB4VWVeJ5cdNM4yrrUS9H8XdEt5u+Ks2qKiD9DPjS/dKt
 smyT5CqZTCesdO5ZcZhJamAGBnQbZEqEJMXheBv78I9XcrH5/SB1cAnvppB/IW7ESWok
 WOSCpzADdGFADBzBaZPdJ8axj8uA2J4DTxrhMWAntbe83oYtPgz44NPsco/+xr8jElIV
 avVejOjyDD60XcTikGZGCmGfW66qg7Q58OUDcJeEZ6cICVooPGjDSbPEHo5a7d2oHPcF 0g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=W62n/HI8+NqhxvJQcP3tzLtGKY6xwYT+cHIj0WWTBZ0=;
 b=a9V54dpSM1P92iE1y4Sq3bXLYb6Dc839JI7ieflscgs/Hah1QHGDrltojhsHEPLBlCLd
 vJA3EZkUPSkkYa1FQCS4kMQzX+LMey0Mok0BSZ3rnEicFX3f/KUmP4jz1juU6LV0mvTX
 LbIVY4Sa/HqaLla1krBHfz33LBbxTAaad+cbVuSTRPeTUyloxYNdoyLAJ3NIT3NaMDOY
 +YQWSXN/2CvLdELXBrNq6sOgpV7Dne7YQgwe9dNYF3V9+maJR+4obhIorUZJ/m3JRYz0
 KxDEeJ4RkkbIRnkG6qfcnVy5EOkFXxXtm/0l4GdbSsBOhqmDHbOmNRuwdJR/q2BglVVj Yg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab17dt9ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5A3x8149341;
        Tue, 10 Aug 2021 05:20:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3abjw3rsqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KEyognd2VpYvH8dFdXGIoRFr8jBpv13r2do88d4gIvjcDS0CZDy2q/m06AMQlRRXzLXOVRA2q50MM7rPqRoXtVdDpMeiUmC0uNlDxx0GB3XG8ZyOf+d/v3ZHq5K9RRxy8kDvtF+cs3Nt70ijwZAIehXK1qU7HM6hGX8zw5h7/GqEZbe0S/2i+3q13q6+jsCHDSPm/+OObAqukPyhE4s4zQwLfgJX/iu7t2gYwazs36GSE6Mo9/I7acJk6GR5jde/1Oi+9fJXAskevTdB8XJa60kv10uz5cakrTeh0znB6RYpooN5cfRtbaIBBEKzn5BZrkgN2Ezt40aHbny0223rpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W62n/HI8+NqhxvJQcP3tzLtGKY6xwYT+cHIj0WWTBZ0=;
 b=M6PvkhtTjOGEllOkalGlsAqStj+0dKjrm4wXTmAHNpWGFQhzi7uM8wLiptlr96qsfaIl2Q2M0qGuVgE047m0D6hs4Q3oI0UnE6AEguh+F9vnEXP7TkFsbp01YE51cJmFliJGAc8C/6wnf9iUkzc+6763gpAwB68EFki/FU4BZv0GiwqvhloelsgXcsMaESTMgHFJpKoew18JJ/wMRJFSSrtXFc09KmST36ZiiJpK0D28QsKWZIZCnmpPmrNIETH2Znf6E0VKgLQwriczpPFyzNTwTjBWh80Y3gqJaFkNLW+CjKXTH+75N8f7GsG1+KFNptEU0z99vj/QkYTRFUfmAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W62n/HI8+NqhxvJQcP3tzLtGKY6xwYT+cHIj0WWTBZ0=;
 b=qZQ2uDSdDuDf4Q6dMbGI7CDDGrORtl1xk1/D1LsvL8CzZW51lcCeSmcR9Zwz3OaYu7lsJtDXIPkyp6oV9l8ygTPGHKpJ0uO4xe6b50sfFJNTUC3+SiCd8tGx668ivhdWxRxeeL1cdklfGCpUGip1fcDGGChuyhuvS/ggcFmXA5U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:47 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:47 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Bodo Stroesser <bostroesser@gmail.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [Resend PATCH v4] scsi: target: tcmu: Add new feature KEEP_BUF
Date:   Tue, 10 Aug 2021 01:20:39 -0400
Message-Id: <162857263913.15955.13645346032166577282.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210713175021.20103-1-bostroesser@gmail.com>
References: <20210713175021.20103-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5ef369-5842-4a1b-8833-08d95bbe9c2e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45972C5F2A042FEC874BDFE28EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kB+gvd0nec10fmHOiyF/DvEMU2oOpKESEtuQvRJS8sw/M6JxewTfo635mgxiHJIUFEVctJIt9bIFey3yB0/am0OqKl5qv6JxsSXqK9LdtxC6J/dCs6aAIBuQr4XMu5bwzIYlfmIEOdM93E5XYjUkHkYqt0OHt8qQvZ3/HIDLFdS7xBs9Dz2E3k3niVp/mcQIMyqLhX1rKEDGgpwaPUIPyv2QmfHTvFwM80WtQCvqIrCD6P9wMUi64HTXT7iLnoTKB16hvaUnnLSyJP+C8VWsj0y/rPbG7hkKze+33yvKtcJ3onRjG1N9NimjK53M9ujvcIXJpZZNLoXpjsKCyeHhEg1bwrn9ep8Rmw2P0JggBXEdoxkPPk3zdldaBPJqWiC2cL2kpTJ4jLH0ibGUIrlyxvcCWC5YUIzmL5W/JO427Ll9wsmbguk6bLhgCr21XMDckWQHixoxdJdcFSr+N7a7vsr5inHH/e3VG6oznM+7lg1S6NvtIxKpio/jp5PwDGije9gZ3DXiJHkt6HW8PErLU+JkgUiaCniaZUB69J0EUSc9aX7KVHxeBXItbOPy4Q2ve9Y8ijEspAVH+VdTRvY1C0EYaOs45w8w8gNGY+m2kOopRLP5F0q5rCdYQFg2p4cqshc8Qoqv0uT//uSB7+B/FdWvXdMyPmWdjl/Nqj60Zbz+6t3zEViAyhc8HkytCLeQZRY2lgx2ccIDDsMhbpTi5w88oAqYJm9wiJo7tCa3bVAGxRcKOJ/I8ooF65HFVLhQICgHUhwiwUUuUIh1GS40kQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(107886003)(2616005)(38350700002)(38100700002)(103116003)(316002)(966005)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2ZJK2Z6dllDN0NqQnBWN3BwWmY4Qkowdzh5c3J0V2tBaUNEZS9LcTUrb0ZG?=
 =?utf-8?B?YWpsbGorc0VOVFpKNDdKT1hKbm0yWDQwV2dZVHE2RnIzOFhmOW1wdWlkS3py?=
 =?utf-8?B?WlF0eElORG9BTnc4SnVsK054VnpkL3F0OS9TZ1VSd3VMZW4vSUQ3MHhJSkxU?=
 =?utf-8?B?bXpRMUtzTmdGWDRkaXgxVU8zVDhVaEFTWURoUEJZa09iR2tXdkhKUXAxTzF0?=
 =?utf-8?B?Vmg0SDB0eUFXTzZDL3p3cUp5RVZQcmFxWkRHQ2ZrVTNTZjZtOTdBRnpVeHhr?=
 =?utf-8?B?YU1KRkQ4MkMyNU5VMTkrZGZlRWVRbEZMdm9zRXF4Nk5tMUVqaGk4UXF3YlVT?=
 =?utf-8?B?S1BoVy9mY1hKaDJ0MFd3OUlmVkM3RVVRdjFaODBUU0RvUTZnb25ZaFlHWHVK?=
 =?utf-8?B?L3NrcWk2RWpvNXNBd2VTdTRFWDFQTW5sY3JmMlJpQytZbEFTczdiTGdaR3Iz?=
 =?utf-8?B?aUNHaEU3NFdHd3d4YjNXNHJ6UGxOeGRRYlVEaUNNKzNWSEU5dE9CSVdJTHoz?=
 =?utf-8?B?MU9LL05qbnBZTXYyKzdDQkRMdUIwN0J1VG1GS1ZFL2tJb1JPNkZZNTA4ZUt2?=
 =?utf-8?B?NWpmTU9QNk9tNklqWmVock4wK1MvRGxDdXB0WnMyVE9lMWw3a2hJWWEvdXpI?=
 =?utf-8?B?allWcFZjamlYYUVpeVU4YWU3TEptV2N3RTJRYzNZN0ZSRCsrbzUvTURHQmhG?=
 =?utf-8?B?ZXhBdUlwMTd6Y3BUZTNaOTluczRYL00zeXJNUnB4SUlQVVNJVXMvcDlZay9E?=
 =?utf-8?B?blRNUmJzMlFPU05NUXVtUVpSUzlrUTU3K29RWHBPUEdRQnJFem9kRTRwZEIy?=
 =?utf-8?B?RUJVdmtLazFINkh1WmpLb21JTlJ2UFVYOEgwblg0bGt3OTdDdHRkZVduUmR3?=
 =?utf-8?B?MC9WbCs3L2EvUStiQUt5ZGNScUcxOEJqaEIrTEZ5T01BKzRlL1ExMUVZaER6?=
 =?utf-8?B?Q29EK2JvNk9jN2hiMEd2UThMdzhSNk8rTTdPYVFZTSswRUlUejdzUlZDSWZq?=
 =?utf-8?B?OStJaFdCQjUxelRMZDZlSnY2Q0N3czBTYmJCVVVCS3FaNjN1bzJwK0o0MExM?=
 =?utf-8?B?UkVubkJLMDc1bzNBb2dDZUNmS0ttZkt1MEtSRzVMdjVNUkZISEptay9wMVNk?=
 =?utf-8?B?MjdGR2hLWXArQkY2UXl5NFZaUVFWREtuZTJsckd3SzhVSHhhQ3d2YXJ4c3U3?=
 =?utf-8?B?eGh6QXpQNXQ1SjlmWTBYSE40a1Fvd0pqcENUVG1LVG5xLy9qTHE2KzFhMDhV?=
 =?utf-8?B?WVJRTlMrYW9ocFBha3o1aXZPRHhUZmxBMzhpOUlrL0Y1a3daUUZwRXdITHBs?=
 =?utf-8?B?Q0x4RVBINlRKN1pweUVSWklMeDlrNEhCUXorWTRwWi9PYjZna2dua3hFMlkx?=
 =?utf-8?B?ZW02cENNcDZBM0M0KzliUDJCN1lMRHJYUHp2VjZzZElPenhWYmFyaDFKNDRq?=
 =?utf-8?B?cHdYWjlQMHhRYmM4K3BVOVNSUFEreXRpcHRJSTQwdDQ0Z3JZdjRyZTFSaTdz?=
 =?utf-8?B?aVNQQUVLOE1RZktERGI0M1J5d0xDWUZsWXhGUXc5T01qMnZ1cVBmMFRTM3Bn?=
 =?utf-8?B?aVUvaXF6V1ZqLzlBWVlSa0JKZkozSHhyK29IWXhWZGVLQjJwdXY1RXY3Y01u?=
 =?utf-8?B?ekdyQ0JCcmFKVHZ3a1YwU25WbHkvd3ppbU9mT25oUURMUDhoZjQwdFhQcE9Y?=
 =?utf-8?B?MFBHZDhhK1dyS0M2cHowLzdpNzJFUFJBcER1QUZpYkQ5TFhWUUJTN09pNjE5?=
 =?utf-8?Q?5aDOHM+/mkoed0qeGzH2BGlsdQrV2BQjMyAT5/j?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5ef369-5842-4a1b-8833-08d95bbe9c2e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:47.3696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25EiiitJ69rzp3O31OXGd+pMKJ8UU/QWfCfBDVBRcpPajunka8wyoRrKDOis6qKZBiN/Bl6DBhcCc7FsJpuABQbf7B8A47x2PDqFbTdGm2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=800
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-Proofpoint-GUID: J3aY2hAEk9d4lOjKIxWvk7gEBfXEP1YD
X-Proofpoint-ORIG-GUID: J3aY2hAEk9d4lOjKIxWvk7gEBfXEP1YD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Jul 2021 19:50:21 +0200, Bodo Stroesser wrote:

> When running command pipelining for WRITE direction commands,
> (e.g. tape device write) userspace sends cmd completion to cmd
> ring before processing write data. In that case userspace has to
> copy data before sending completion, because cmd completion also
> implicitly releases the data buffer in data area.
> 
> The new feature KEEP_BUF allows userspace to optionally keep the
> buffer after completion by setting new bit TCMU_UFLAG_KEEP_BUF in
> tcmu_cmd_entry_hdr->uflags. In that case buffer has to be released
> explicitly by writing the cmd_id to new action item free_kept_buf.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Add new feature KEEP_BUF
      https://git.kernel.org/mkp/scsi/c/018c14911dd7

-- 
Martin K. Petersen	Oracle Linux Engineering
