Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FB0C2B9F2
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EDCB6135C
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhEVEmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:32906 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbhEVEmN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4YvaR019858;
        Sat, 22 May 2021 04:40:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uOWfNIOVKt3xjJGbfw/oT68tAT0SGN2xU1hl1nufUvQ=;
 b=D8ZsoH2tdakTyiplI1UFDW79qE7tiY/2U99bKg96BcScpHbZvSbF5mSja40En1ugA9X9
 hHCCAySK96F9Xv4xLSDES5i6JRncVdMq31CNUdcMZ17Kir/Qh+/q1y7Ec4u8SCzs7tRY
 NvQ+iOMCXCV8/G8X+UreccmSA841r+uVe2M3pmuwZ9AMb39o6IPcdIeMR7Ui0GxCANxM
 cUpWTwFsJmhew0IzKB94w3gETZyhkx60tpW9dsQ6HjV00eS37OOT2Fu427I0II1sZ+rR
 ELJdJgNWN7vH6ClBajr1ytARpI4NYpAnpjmIygEDXt1ZKk89CyLJwktB4lFJ0YMEKV/9 LA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38pqfc846t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZiRm168410;
        Sat, 22 May 2021 04:40:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 38ps9j32fa-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCteN7TbieDwij5bBi9PDz90Imampwq7dgGTSNhy21Sidj0AUy2cqha9zkjiHWITN6sfu/KSLPBnkP47T/cixfz2XeprbvdIPFD2nLAzktJ8VEIYnA6OhFAKLptbXjwzL++KnouOLWdNlwulOGk45kJ8AwtUncnkDbbB10zeeeYNIdaa6reOnhZP9x66a+8PVZ23vJ9MIYsW0asXXWX1W5puZZhAQIiWqkFPtoas+ND6jaf0QPco25czBIxH3xAWlUGK6rPEadp4Vp7NG7dOOh+be4KQeM45wt3aHUc5cxYCueHl/hAYtNmiQ6yXnkn+Uf9IRcpOAxwzsuoevrZSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOWfNIOVKt3xjJGbfw/oT68tAT0SGN2xU1hl1nufUvQ=;
 b=NJoa1AO76AwEsMO3la3S1PddVE3sef96Dz6rHVBV5zjfLrixFaJ6Gi0jHhgHKXK6GmynJdTStYO4+ivDzYAHr4MrHgUa4iiujDaev1keNwBasQdjBSjdUBSDI3moAdOhwjygdsjSWmz1SHdp+dAig3ZS39R6IUXrx8hnIaYAKws2GP1GRTj2LelBwJAq43s43nCW0GA46MB1NTP7kKI8vZF8vYEAi6DOh6vJVTyS3FjU8xb0NpRUiMTUQ7+n912/QP02pmaWQekHX/lRqasJj4TStp0MF6NubCDa2zUCpZar4YKO6epngIHliqvMcq09TQg6vSgWKW6n71DbhI98IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uOWfNIOVKt3xjJGbfw/oT68tAT0SGN2xU1hl1nufUvQ=;
 b=qW9bULVmyP1WbuD+B2BzuJg/VR4cIipjQ0e4dUORKSixzkwRat3ghJg1LncA0Kb+me5XA45qlXR8gL5gg+Eluw3tiBYyIOL8fzH37byFHWOI+br+J3nbwKMQn1ELfqhAY4KqjbyfPD65UA5a7uRyNWJ7kdt7oJFDBF0Wn3mDVGM=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:45 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] bnx2fc: Return failure from bnx2fc_eh_abort() since io_req is already in abts processing
Date:   Sat, 22 May 2021 00:40:32 -0400
Message-Id: <162165838887.5676.11478116885820160239.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519061416.19321-1-jhasan@marvell.com>
References: <20210519061416.19321-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0eba77-149a-424c-7f7b-08d91cdbc343
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54816BC727E5E31D026100BE8E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CK5W2Qo5gOTE/gnXyA6Y2aoGBP6HKQQFU2tgYvGJNhlfb7KwgtJAXZzZv12figyZ0clsbg7O13Kg3DsWzGSQEb23lRs0Rn/7x6vq/Jr+qTnABp3vsVdd9qKaGGL8OiY6DUd2CMd8EcGygeOHzzJBJjX2qjU8ZET6c1/WamRt5kHoV539Qs9eUtebGM7PYNXjMvRqj9ZlTQrTtqvSWgP82t6lyE1Dt+LJLMZDBdUs6COLuGSt79DOkTmO40M1VUrKjOChGN3hcgk7rgvvzIrQcr+MnUYwcBOEydVAedfSLSN0DLSPb1Bb7BZ3DITAUalFpcdxUNdBYA1Rexeb8LTXX13IucM4j9ZppDr2TYERCZlQhslcQAUnM71A7EMJOoKtPZCdDHg57PHTFWd2Io6vZOpV1aELE/xvfqI+Cy8LbWMeQR7j6hRTi6YI+LjrF+ki1LWgVTc2aBg8nIPGbwD3RT+FDL2KVebhZsuKmR5UoT5WahX2qOkliqwuUGPwOjieVTW/IigK8xBn5hxKTDDSrjSC6+u8hO+p19zi85LS4la36sFUk9cOtFtbAyEzKYwdei+wVUTVFzpogZYkZ1siKn8V+DKeuR6bRX7oCTb1J9pysruDFnWwqelgKnnI99TCjvujRWd6cREglasDIbkazy1XRgjVm5+kQ2pncCtpqGFImXrwNYRbAnn2r64F44P0J+VJHSdoP3yWUIYRoBjkC/BJg7yOJO9fA7WN9GupnmisAQPttTIc1txpQ6SHuUWNc2IfvMvNt1qbNdZ1nXLyLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(6916009)(38100700002)(38350700002)(66556008)(66946007)(8936002)(5660300002)(2906002)(83380400001)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S3RhMFJ4aG1oQTYwY2VMRUtHeVExdm12NkN3YnpOTlJ3NFpjRG94ZEJSSnl6?=
 =?utf-8?B?bnpFdmRjOUNrZ1hiRVJRamZPeS9PTkJRMDR2NnhSZE5lRi9lajhHdWRZT2hj?=
 =?utf-8?B?dEdBcWZGOEpUclBCT2J3bUpBcnRJSklwZzgwdzRJYm1uWHg0Zmw1VVk4QzRx?=
 =?utf-8?B?dzdKYzJ5MTVNMzVyTFlBT081T1NYalNpa3FsbG5iTXJQem1wMWovOThGQUls?=
 =?utf-8?B?ckJGbFpUaFBpaGJMYUZuK0JZVDAvajlFL0RJTGw5TTdDSDFtU2owWjBDUmo2?=
 =?utf-8?B?NGdyT3o2WkJjaitzOHFEOVFVMVhFWm9tVnA3bkJVY3MwRWZia2JWdVRhckRJ?=
 =?utf-8?B?cTh4d2ExYkpVUThhKzJCY2ROYnBUOGRDNHkwNkNmV3BXbDBpRGNnb3RBaHV6?=
 =?utf-8?B?bklGNzdURkFYVlZRYkp1VVJlUk5FVnZPNkw1dVYvZDhLSGp6ek1CQlNXZFlq?=
 =?utf-8?B?V2JUSVliMVlObFdJdUNqS1AydDF2OTR2d3krSXArdWVUd2U4YzJkYWNzelNF?=
 =?utf-8?B?Qi9VNEFyUk5Yd0RvalphWlBTajhsc29XRlJ5WFZNc1ZnUWZ3cWFwbXh5c3lV?=
 =?utf-8?B?azJsVWg0blJoeXkzem9yeUlvUG53WDVvdVdibGdrTWlhMXNtTW9KdlgrbHRo?=
 =?utf-8?B?eDdWamtQazNPc29nRkVpS0ZieExrdjFibUFZc1RWTXZ1a0duUzF0RXZyUzYv?=
 =?utf-8?B?WGxSb3gvSmVva3gxZHFJb3pzSDdCeFZtQlVQMjN3K3h0eFBtSHZMSlU5cUxO?=
 =?utf-8?B?VlBUUFdPdDJBMVZZVXB3aUpXR1A3T2tqd281aUZadkk3dE9DSnVnMXZzS2Q0?=
 =?utf-8?B?WVRnWDNGd0c1ZTFZcXFYbjdFT3NzMEdMRVBjQzA0dEdNWkFGTHlYUm1LbUpN?=
 =?utf-8?B?cjgvYjByZjFHZHVSQmZxa2xGRm1yNCs2RC9RK3JwRVZaT2pEZ2lTMk9URzJ2?=
 =?utf-8?B?NXJzYlVqYVRVUmMxUkJUSUdBb1VrQ2RXbHhkT3B2Qzh5OThVMjA0TGZmbzRZ?=
 =?utf-8?B?c2JBN0dBL25zREZDZzZyQU15ODhpS3E0Rk1rZHArYlY1YXI5T0duTWc2RDJy?=
 =?utf-8?B?THJkcUFqdlo4d0trekdnZDNXZUxZSlVrNUF2TzhYTlZCSnNmK3VFMDBXTmU0?=
 =?utf-8?B?TFZRQ015MzRTSnZqVHNQU1VGcmtGM0ZYQm5YR0JRQnBVdDRyZWhMMGw3dXR2?=
 =?utf-8?B?VjFyNjZCM1lMWmU1cWhoOWcweE9PTytWWTdtd1ZpanlFaE1UQzhkZ1NYdUUv?=
 =?utf-8?B?ZXExR2kvZjV5d0FtNU40UWZGb1lYOHZkbHdNTzA4M2ZCS0RLZXJRWDZmVkRW?=
 =?utf-8?B?RDNnM0ptNnZNQ2tjQzRlQ3RROHBvOVFOMDlSd09CcG9EdWdqSi9QTS83MVNY?=
 =?utf-8?B?MFoyTTdhYWdkSzE1TDBGckhwUk1TV2VDSWwwVy9JbjVKTVk0R013cEdsSzdE?=
 =?utf-8?B?Yk1WcDQzc1dvM25GWUV0K0FjdWJQV1dSNWYvZkxSRnQ0a0taM3VTRERiWi9C?=
 =?utf-8?B?SlZOWlFGajhBNGcyNHpqQlRnT2RxOVVsd3MyWHVkR08rZXVnL1VwZk5uRk0w?=
 =?utf-8?B?SU5ra25iRnhsUHUvWjlra1E1MFIwOGpsRFowYXk2RkJFQTg4UFJNaDRyS0ww?=
 =?utf-8?B?MnkzYXNWTzV0ZDQ0N1diSkpMTlBhZGhWUWtWeWo0engxdG1WQ2RnQUVpbnNQ?=
 =?utf-8?B?QzZpK2FYNW51V2NkdTBTbGc3SWREU0N4VDVyR3RzeFF3SFN1dUxSVTBWODlm?=
 =?utf-8?Q?ckEsyEWYbSISTQgSMDts0S0TNV7ZeYzXAp90PzJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0eba77-149a-424c-7f7b-08d91cdbc343
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:45.0724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q24cUnqsQxbg1VYAB58ATW9CQvgEWLDupq4eU/LYLx/n0J8NkuMNrN6eHYHVl6oPMcLhBf+g/d2NtY5LduWk+TMSJztV6QO0T5zIDJQzOOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=826 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: xdYMdSSuXRDMZFA7e1-v8AbGw8cIjIZN
X-Proofpoint-GUID: xdYMdSSuXRDMZFA7e1-v8AbGw8cIjIZN
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 18 May 2021 23:14:16 -0700, Javed Hasan wrote:

>  -Return failure as abts is already in processing.

Applied to 5.13/scsi-fixes, thanks!

[1/1] bnx2fc: Return failure from bnx2fc_eh_abort() since io_req is already in abts processing
      https://git.kernel.org/mkp/scsi/c/122c81c563b0

-- 
Martin K. Petersen	Oracle Linux Engineering
