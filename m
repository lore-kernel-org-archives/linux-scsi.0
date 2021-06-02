Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFB7C4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 913CE613B4
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 02:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhFBC7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 22:59:19 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32386 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhFBC7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 22:59:18 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1522rLj9031041;
        Wed, 2 Jun 2021 02:57:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : subject : from :
 message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=8XeHTMkgPCu0eMGLgud0ohM/iCquZV1eO4wTGNG+h+g=;
 b=ETdwGAURYrzxs63OUxNABuOJGjshwL0FqyDp/w6wiJkld1qRrH82vvhTqphIDxOMx6rd
 xHIlX8VgzC5pI5ON9R8ktwmG61xQ2T0iL2OYOyellGlSN8A78PHjkJgjoZvBM214DC4A
 Z45AZup3+nVrmNysUi5gcSHnlQoIxXKqMu1gadJOCj811ovbFIyNWlhwQE6MKE+qhNHH
 mVJdTpcgnK5oawKIihW/APlVaHA8g09x84g4Fyj2uFN2inu3Rje0jbI/6NVHQrZeevM3
 HWb+VsA1rPj7u/SokIPeA61h81dKeCb+PxoH91k/ffi6lpv2KN7WdlBtqIQIvSiSsOGj cw== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wx9fr23b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:57:34 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1522rIu7058494;
        Wed, 2 Jun 2021 02:57:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 38uaqwvhf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 02:57:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSY77naBQSUHhO4CY3xcN4/gFUhcs2MRwCHf6vNpdCmpSRfHK076/n7haj/mepv4TKnV+MIGojlpePm/djy5q7N4sRkiLFaxolq324kkmrzFIXmhZUcd+dBAzLqNmSZVJZf2j7au5wtHB375L7oTQSLG1kJLwUPFKGksAlydmSBF0n2WT02iKBXgtC1YLO+n34SE48PPLF/5Bywww1kFiwigg7DEh4WO0yLNjg4qoTVfI7xxoqGOgaRbvjE6EGpO6blVNVMsz447OKSKPw+EnXBpoIusZpwxHGBmBQXjh4h+dWOWFg0PROnc8gBOnuApIVH6z7613mBNII3PGUUjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XeHTMkgPCu0eMGLgud0ohM/iCquZV1eO4wTGNG+h+g=;
 b=IsZFd6x53BiHNpaZK8OhvaFOjiH47ly6BOBzwNDvEy7GOncpfZiitRFVAp6/Fjp/Y9ObTUdruTUrYWrDHKkuaJnaXFOl6Mkn8fZrhTwGn/hYVqaeasN2mQKbZ4uCfq/MjKaknMqqA6rhKbd7eVmFSYHW1LoPsxNojsLWzW2BR6kzrMnrFZpNUEWF7lvyKf1qmNtBlv6I8bmcDA5v3YiychHuIn/kvDD9YlwEhM0FE3yXAa1L1Z3OrATcx5WqQYFgaz6N2x8IX+BUq2vgVGSlbnsymHWC2jTm5xtyKag808xfwgu6EPZ+YTt0lZoqmz+AWKDvVck31OI3GvnbPLxrkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XeHTMkgPCu0eMGLgud0ohM/iCquZV1eO4wTGNG+h+g=;
 b=cemMuQUxzyQG9gcxA4T/8kGskqLAGUVpVl2MwHJSzYOCi7QSkhScjUpry1gWz/MdYBDXZNA3TRTaZP7KN4mLIhW69XjCNQaZlZnHFqgGztIEGAThi6IY3dmrO8YajfBMkbI+kxhiZC4Gp5O5uG7SQpcOtOcjrFbLxiJgPgYYyo0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4424.namprd10.prod.outlook.com (2603:10b6:510:41::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 02:57:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:57:31 +0000
To:     David Sebek <dasebek@gmail.com>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com>
References: <YLVThaYJ0cXzy57D@david-pc> <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
Date:   Tue, 01 Jun 2021 22:57:28 -0400
In-Reply-To: <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Tue, 01 Jun 2021 22:53:35 -0400")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:806:22::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0048.namprd13.prod.outlook.com (2603:10b6:806:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 02:57:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaa1d72f-ad04-42ff-8c14-08d925722a4e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4424CA99E2C6BC9784D4A9038E3D9@PH0PR10MB4424.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTBkatewblN1/K83QfAU6ThGZay1OE80Ct41MnpV9LO8Q0DFmhIvagcn9WBMNKhRUdw4UoJEg+LYUZzM7U9jFFMwuW+387cMoUDgcZBRlZyercRtsgl9NYIWjy5Dn0eoIxd8FVf0xsjE+gZqYe+FET1frgMvissTieSqW/gQoCgpmNtQI9DvqzR9DL21cmIk7cktSZa5KsykYDY9THaINSwHUutWR8dOs/pZEjzkmYtQN7731mB8peFI9GaAJIity1CIlcTGAa/P213G2ahRhv9Rtd/l/2vGGm0ny4tW6ARbaopfAo82anENznbaD+suRm6p2dkz/0YkV8CvEnbze3fjcBLkTnj+ZGVP2AWVkUcKUZScj23Acs1iMkFvLJqZ8IOoZT0+Od3fHDpQijCxdgU+8yPA+f02JrrbHQUovnTvI7GmKXszeZQdJ1bR1QFmqYssWDpXKaWe96xLEwLuRciKucor5jpDm3PxGmQMhYc7GYntJwugjZ+KQxUp9Cx8nxsFLQsvnjqxJ6fz9dsk1CUjdqPl5dnGpHF0lX5UOhYZPGe86n8R8lFFX5QJ3yKv/r7cvb15pArTN0pYKIhOx08WT1dMa1gyyhyeh1AvWhzAz63ekOqTfcThta+K9MAatxRSzIc04YUiOHSYnW7+Q3BnsCXcOlOtobcwVgow+NI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(346002)(376002)(366004)(38350700002)(55016002)(956004)(83380400001)(6666004)(86362001)(66946007)(8676002)(2906002)(186003)(8936002)(478600001)(16526019)(316002)(36916002)(4744005)(26005)(66556008)(5660300002)(38100700002)(52116002)(7696005)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KChUhHug7Jhzw5ZMDC7e7507OP19Erri58pZNIoJoefheRAw1XScw8WDkD9N?=
 =?us-ascii?Q?976LdQd/tcKrXx1Xl55QHKqKAuD8kWavkZsOlqyit1jZdJn0z17iXni2s+ev?=
 =?us-ascii?Q?gZglTWef1vhYyn4OqTwANC6ohrbLV6dqsoGq8ZLyLoMPCDfAJu4/+4MkE97W?=
 =?us-ascii?Q?jDX5kYzusKN8Q/gGSVZb8GyXj6xCZIw/U/oVi820tSwjn/q13yVOqMJ3qnbt?=
 =?us-ascii?Q?Om5WzmbRhSLhoHgGzK+XWrQoAIYfzXEUXh3Qm0I26ZO/Xcsq09UqgTdABGvU?=
 =?us-ascii?Q?i7A3jPaOW/FhoHKe7AZw88zw+S6kyNfSZyAxxRCInPPGzMXzfE1oVguO+fLU?=
 =?us-ascii?Q?yVNQxMJpnr/DELKGyrjf3OYcFlbqEZDJLzC0pK8ZFEpM77L7v4MZFXsbNJCv?=
 =?us-ascii?Q?lUOooaJSs4KGdKENIMX2IzC6Jh4v+hkFMTLRD3D3bY0c2K1EKVTBNKpJx4nb?=
 =?us-ascii?Q?uMjKY07qayPWYrUi5ByXoWAFI8uTMMza+xEl2VGoIG9zkjwSKT+dGhb9g7am?=
 =?us-ascii?Q?p1wxjn/YIDVmEsfFtu/PqaCcAtUpXfY5kxTd/+vLF5KgmWW6fGSpp7fhOco/?=
 =?us-ascii?Q?eC+WB2y5lbUEwVRBSwNG9Xywmj6G/Hbil/WWzLUKhwQAUGFYkPfl2jOIvo4u?=
 =?us-ascii?Q?xNvoozaAkfHIPjEi5vhCfU5PcpLQqVUPRkRRwDx5cYrx6LQTD8ZIzQcJoEPo?=
 =?us-ascii?Q?Sil+Sy+PQh8O8Lxh+2W9u0v9omLfR4JoKT8KU9dO9QB6h9/EelvTAzXjnH7i?=
 =?us-ascii?Q?eOC+prb6458wCAcwXrMsIEyJjrMlEyORu2kiYhpHdEeTkoYo9+oBJbALkzTQ?=
 =?us-ascii?Q?HOrug7GAf6GDYu7KEywVuGGdDEpJoHKT/pHT4c7QcpjaZdg9fKHmDLsyPrQk?=
 =?us-ascii?Q?vO5wtfRc3as0sMXPXAly1iKGtFv69qRxujlmT7wCsN/uG9aYcK7x0YagqZqU?=
 =?us-ascii?Q?RD0CTKSfN+yY2bF57EkQWBdLLWrEyQgXk3k9Ms5U93LdTon5d8QOa11uA9Jl?=
 =?us-ascii?Q?gEjvAeZkLjhbIRWAGWfK70ZeUj86vrTn7fgfCHSBWzD9LgJMgNSwsGK8AJFG?=
 =?us-ascii?Q?P5Y7dVzgjYny+cldn4B+zcEWqODNYTX4A1j/WQ46yw6nv3J9x4vI5UP4uqlc?=
 =?us-ascii?Q?duVjFnh/TPaxZ84jZNrBWPS/9ciwC29JaWLp4CoiUJeIzuUz583N3fkZFq/J?=
 =?us-ascii?Q?AL3h+5egxQ1S9UF2gcBwKsg31Gm8egWXLbr/09rjEZV7F/Vek5FlEfzJ3exy?=
 =?us-ascii?Q?3m/3BqjNxcwUI+JQ3u2alvcP+ymjz9S2VWg/X3AgVzUUkFe3RCCdMN6uofVO?=
 =?us-ascii?Q?yojiOOrHvDs8QlrGM8gv7Lns?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa1d72f-ad04-42ff-8c14-08d925722a4e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 02:57:31.6712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7b5mQkpASQumAV8BC26TnjpuB8OAJ6H1J+9ig4altfQbz7gl9jYajX3mN0PmXVKkC/rrw82xH6Lf8n0b/YE30Av0T+LI7jMt7E21BcMpBpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4424
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020016
X-Proofpoint-GUID: _nycs-_KAC0cmbTSvk6f4HAiatl9NELy
X-Proofpoint-ORIG-GUID: _nycs-_KAC0cmbTSvk6f4HAiatl9NELy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


David,

Sorry for the partial mail, my VPN froze at an inopportune moment.

>> This patch adds this drive to the scsi_static_device_list
>> with a BLIST_TRY_VPD_PAGES flag. Although there are comments
>> in the code indicating that this list is deprecated and that
>> 'echo "WD:Game Drive:0x10000400" > /proc/scsi/device_info'
>> should be used instead, I haven't found a better place to
>> persist this information.

We just try to limit adding entries to cases where we fail to establish
a good heuristic.

>> +	{"WD", "Game Drive", NULL, BLIST_TRY_VPD_PAGES | BLIST_INQUIRY_36},

Is BLIST_INQUIRY_36 really needed?

-- 
Martin K. Petersen	Oracle Linux Engineering
