Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49132C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 296DC610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhJLUia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:38:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8178 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234916AbhJLUiR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:38:17 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CKHGOg030657;
        Tue, 12 Oct 2021 20:35:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3cHIKIlIUhFzPtnQr2hdWSpw5GUpsHeJhyuTC8qWonM=;
 b=qele6jvGapVPKahD90yTOeMY3GWkBhowV2o7ZlWP43nlYegCGeC+wbn8V5GgzEgAM6Ur
 pko0KXqkEstetk6C9KEhIre7m2Fc0asO3mG0+p3OyjGdYhfwk+qcovCG/gnxDfKqw4eB
 A204+dCRNNP3NHKmTmWzGEonDAlwUMYFejN8Qu/HrANEq1IOGZkkTyp+U+R7htYaS9xw
 a229F0b0VYGN/j4jcNq8rSDev3hN1EJI7wHnKiokOwnO+RLTM1gAitx8zr6pTq11jGgf
 X8aBIwqkRB/BBMC+irrX6PzTaPA6seYcg2RorT9GqTTwnSxoMgRmf8vLhBZWXGeOo27N HQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3bjfqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKYjUD033850;
        Tue, 12 Oct 2021 20:35:29 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3bmadyndfa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT/lzWwB5Ddnvtz9dOmPFFjetmHuYgVqWKws05eitoeaHCWh7oNNMM0kYHobQwNtmJ8pA0RYL8qcU8Y3QeUeAXmZtLuSIdQvLqn1OijlnUkx+i8TldZvhtgzvPPp+Uovx5iyvybfSVmOfUW4hxhSxM0D18HNDxZpE2ozpz7WGBn8YpTyPJNAYkUkuFMiLdR1erXzoX4jqlMinD/kjzRXlLQ49/B60VLyMiG+NpaXPJbKAn/zuLrrBE7iweRg7jhJP+KOnXdgFFYANbQXLWMVIlZm+4Vx7cL1e5t9QrhXlj47JajECBa5o2gZijnL2BV2Ll3kiWmArQ54DrM0jwRu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3cHIKIlIUhFzPtnQr2hdWSpw5GUpsHeJhyuTC8qWonM=;
 b=h45Tlc5NFaa1czLNn5A72fCL+wxR9AigT6+lgow4h8OsXrpDxeOKsRhK4VapVloyoqaxftmA9rIn8kn4s8SkTkYvVCIy2aVtu1dqb86Os7Yt3jhgzqhWTEOWf62sld8yD32lL4WsrZU7nqGAQPwkK2QW8YHtv0bSzzU9QV97jq+5lYFNVU+ga2Nqxi9m/5kI73t2f71ZJ2Ebkn8KILBo4rURSyXLTCcXm5hXmrEoyeOIWjU1vbQ3J0j6dF9AsYPE0AlaRSf7oXmdQHl3mf+74dIhS5fjwPwrDR4nG1EKo0jvHeMvOUvDdV0nbMyOfJLE/zteLxRnPsGKkDendJbGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cHIKIlIUhFzPtnQr2hdWSpw5GUpsHeJhyuTC8qWonM=;
 b=rdJGp1Jcllsi6qHZm9zbRVOIWYQiXI+PBaVvZ4too09GOHajzktvoX+Z/Nz+FeH8we1/Q6NWMQSSIhnYky+jKESlms4qZV1e0p4Pb5yH2XsunNyO913+Gxu7dEhlSdlL6qRAlzzelsxRNpO5uzH4M+Gi13boHicdm1VikWyyBDk=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 20:35:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, Don Brace <don.brace@microchip.com>,
        hch@infradead.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        gerry.morong@microchip.com, linux-kernel@vger.kernel.org,
        balsundar.p@microchip.com, mwilck@suse.com,
        Kevin.Barnett@microchip.com, POSWALD@suse.com,
        mike.mcgowen@microchip.com, jeff@canonical.com,
        scott.teel@microchip.com, murthy.bhat@microchip.com,
        joseph.szczypek@hpe.com, scott.benesh@microchip.com,
        mahesh.rajashekhara@microchip.com, Justin.Lindley@microchip.com,
        pmenzel@molgen.mpg.de, john.p.donnelly@oracle.com
Subject: Re: [smartpqi updates PATCH V2 00/11] smartpqi updates
Date:   Tue, 12 Oct 2021 16:35:09 -0400
Message-Id: <163407081305.28503.12881597564561731203.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
References: <20210928235442.201875-1-don.brace@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e276045-3b4b-48da-c7ce-08d98dbfd315
X-MS-TrafficTypeDiagnostic: PH0PR10MB4486:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB448693F2CEB1954B5D273BBA8EB69@PH0PR10MB4486.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMPDPb1w5kpN9vQKc616j8pTiQb9K1YrIENocFpCilwpUtQZOVdoel5isaYO74eFR6qwwEEZvukVYfTYA8vlOLoWh6WfDKESY981SaV5aLc/T2cJsOhXrr0W9EMoY4pROBtwARYNBjFQ2JHvLDXhSJV43Csvucz7G5ZdG6mgngyOePxt+SFxrI3uJJFjkJFLS/baA8EzhvjDombVAY8TpRXXRrqULdikBZ4qiR09pIKKSJj7yXhuTjHMcymHA1yzh+moOVjl32T+xMPBQPqLZsM0jd/6UweUTFYXA4N/kutbC5xaAJPuuQDx2gfuUFVymRihoAVySvKaXn1c6xllQAOn0UDpno09vSMXCgxNR3wkfU3+dqSS9TMf6vqMkfZdieVRXVHqZLQKCVmc/vK7FYHW5r4oerQ1R8qLtvtcXbPlZZo3ucXt1rrdRcbc21MD3F9gzG6HS8z07vZfjigBS7bIcFJ2FGY07+0LDs8dj4DPswZlmtAskDzsfRC2kBYXNiPvlBLK/X68EohkXM20PVvbDSfR2sz/2/Lq02XADRpVVjftC8kZT6UeaCqr2BfdWVlpaf/BPLscp8k6DaTUkVxyuJe1q0Jb5x9WCnLFesHhEEOhvPpsYRX7r09NxFqF1rK2yI8Lil7YTd0C4+gGuo3195i4GEvRWpKdhmjP0R2721NdSBunmIXU+6BK2G5AW7znOSBPunZFleNUYOQmk23kVAEFjbKH/mq0neaFC6jxqVP05xfH4hzHhCr2/aN1fDNuVF2hjhTsINP4OalHN6DQHqjXcQcuNRUgFGFLcZIqpMz0uQU59vLaMMaYUOM5x6ZPk4OXri79uV8LI2n9PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(5660300002)(66556008)(66476007)(7696005)(52116002)(6666004)(38100700002)(15650500001)(956004)(316002)(2616005)(38350700002)(103116003)(186003)(4326008)(26005)(508600001)(36756003)(966005)(8936002)(6486002)(8676002)(83380400001)(107886003)(86362001)(66946007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlU5Rm9hdDZaYzA4K0VGNVpsdXdueUFJYWRWV0c5S2xDanRnZTdBbnpCSEhI?=
 =?utf-8?B?L1A1dWlXMWR1WVhmVE5VUXdjclVkT3gyaGw3cU9XTDZUaWJiSllWWlhUbzNS?=
 =?utf-8?B?Vjd6ZjM0bHphcDRIemw4ajI0c0N6cnkyS0daaVZJaTUxa1VHSFlVN09xeWVI?=
 =?utf-8?B?dXJ3eC9nRW0zU3ZCWmp2VWd2U3FkNkh5ZUZTOUxnRER0WnVwV0lxU2dLUkdv?=
 =?utf-8?B?RUtXNE1pZFljOVhlcVUyOGdnNWNUOUxpQXYyNXduMU5maVRCcHRwa21ieXE0?=
 =?utf-8?B?M2M0ZXRzUjJaKytuOXh2WC9FM045VVNPVjRuTnNlRGFlWm8vcDQwZStQV3BW?=
 =?utf-8?B?cjEyMEFtZ2s1S20zZ3V2dit4b1lPeTU3MUtUdFhTT0wya3piV2d5aml1ZnZH?=
 =?utf-8?B?VzhOV09MUWxyV1R6ZW44Y2FTa2ZvdEVDOXl3L1dQOWR6YUs5SWthMmVWL1k3?=
 =?utf-8?B?RUlzQ2xzT1lYOTk0MDVWL3cyMUhQUm9EaGhMZ0lLWC96bi9YSmdGaGNucG5w?=
 =?utf-8?B?VHhVZUJkbitPY0pVUEI4MUpZR1B6RFNjSGFReHM0dkgwN0RyRVVTeEpGSEpJ?=
 =?utf-8?B?NUhkYlhLRTB2WUhKUVdwK29VNldxYWNGSWtNTGJkQnVxOFJVVVVLTUhQb0hE?=
 =?utf-8?B?ZklPMGFBQktTUFFMbEFmUytSdS9XaGs2aW9Md0toZFY2c1ZLcWF3RUJ3Qng2?=
 =?utf-8?B?bFFZUHFaNlJreXdEZVpWck51WWZYRGhRcGxXT20ydElEd2JsbGF4Kzh1Z3ZO?=
 =?utf-8?B?alBZdVRKWGEwRmROUHVuKzlaNWVJdnJCREtRL3J4elhteFVuMU51WUZ5bTcz?=
 =?utf-8?B?UjRzeS9WeG9weGJEcVJyQzhpSUJSVXNhcCtOSVVMSW1oTlp0ejFPeTJzVjQw?=
 =?utf-8?B?VkozZXZYQ2lqM3FlUTVPWC9xemxveDcvU2piYXVKY1Y3SjdzSDdOZHM2NFBV?=
 =?utf-8?B?dVBEVWVUR1BvTzhTanArNmFtZHRQbUFLZGlVcUR0K1E4UHFyMHNuRlFIbDZ4?=
 =?utf-8?B?MHNXOTB0eG1XRm5uS1hqMlBibjlrclM2VVBMaW1kQ0gvdDFtKzlQb3diM0hJ?=
 =?utf-8?B?VCtpRi9SRDJWNnFqTm1VcVFZUXJ1Kys5SVFEaWx5TzEyejIyMThWd3VHbC9l?=
 =?utf-8?B?U1JGNzdiNmFHNmNKNmh4UDRiTWRMUWwzMGxrK0JDRkp6ZGdNUjhxbkZta1Yw?=
 =?utf-8?B?SVp4Zk5MVHVQY2RwSjFQTkRsOE5SbVRPUjkyaDR6T0swRUl0eVhvTWx1REtD?=
 =?utf-8?B?c2hxYU1hSVNvYTNXR2duVzBHNEJoTmZzcGNaM2ZVcmZjWmtHUW1ZeTFLenVx?=
 =?utf-8?B?dXcrZExpRGlSREpIRk9OTlFPN2orNzhrOFlxZmUwT0E0aVh6dWpKaGd2ZHJE?=
 =?utf-8?B?UjFYbmUzb2hzaHlDaWxRaXhIQTV1RW94R1I2T244V0crMmEybHhqZU9TTWdv?=
 =?utf-8?B?elVJeFoyOW54S21qdlJTdWF6WVFvaFJFRkVEK3RyRzRQQ2U5eEdUVlpJc1hK?=
 =?utf-8?B?cklKR2s5N0JYZ055ZWdwTVl6MmVvMEprUWw0WnNoSjBPTDhOOGZ6WDloWnJl?=
 =?utf-8?B?NlFtTlFvcHZjaFVRT0tlZWxZVXRZSmNzZGpBbHBsU2t6VHZCUGlEODdTZVR3?=
 =?utf-8?B?ZTZ0ZGFXRld2VkFvTlYzTEg3aTFNS2JMSGpmSlBQc0JNdURJOGhGMUp5RkJh?=
 =?utf-8?B?TEVIZWF0eHRrVklwNWRIZy9mUm5kRUVyak0ycmFjMFJxakI2MUdyVFdlR3g5?=
 =?utf-8?Q?D7Rs97B1IxRLAvPgEkxhsI+BF3N4lXXRAnlhxJp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e276045-3b4b-48da-c7ce-08d98dbfd315
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:27.1038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlUKxQp1TyeeKpkf2SSLxiTeEtmTKnRcDxWstyWby3ghV7Q7UM8qR7tkiXbnfd1ls/GCcrMR/9L2/sCiNc7FfyvSeiLwEPYqViG1PFAO5BE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: XMT_imLazJXQPU5r-uAVmDQt7uXCs-rH
X-Proofpoint-ORIG-GUID: XMT_imLazJXQPU5r-uAVmDQt7uXCs-rH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Sep 2021 18:54:31 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 5.16/scsi-queue tree
>   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>   5.16/scsi-queue
> 
> This set of changes consist of:
>   * Aligning device removal with our out of box driver.
>   * Aligning kdump timing with controller memory dump.
>     The OS was rebooting before the controller was finished dumping its own
>     memory. Now the driver will wait for the controller to indicate that its
>     dump has completed.
>   * In rare cases where the controller stops responding to the driver, the
>     driver can set reason codes to aid in debugging.
>   * Enhance device reset operations. The driver was not obtaining the current
>     number of outstanding commands during the check for outstanding command
>     completions. This was causing reset hangs.
>   * Add in a check for HBA devices undergoing sanitize. This was causing long
>     boot up delays while the OS waited for sanitize to complete. The fix is to
>     check for sanitize and keep the HBA disk offline. Note that the SSA spec
>     states that the disk must be manually re-enabled after sanitize has
>     completed. The link to the spec is noted in the patch.
>   * When the OS off-lines a disk, the SCSI command pointers are cleaned up.
>     The driver was attempting to return some outstanding commands that were
>     no longer valid.
>   * Add in more enhanced report physical luns (RPL) command. This is an
>     internal command that yields more complete WWID information.
>   * Correct a rare case where a poll for a register status before the
>     register has been updated.
>   * When multi-LUN tape devices are added to the OS, the OS does its own
>     report LUNs and the tape devices were duplicated. A simple fix was to update
>     slave_alloc/slave_configure to prevent this.
>   * Add in some new PCI devices.
>   * Bump the driver version.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[01/11] smartpqi: update device removal management
        https://git.kernel.org/mkp/scsi/c/819225b03dc7
[02/11] smartpqi: add controller handshake during kdump
        https://git.kernel.org/mkp/scsi/c/9ee5d6e9ac52
[03/11] smartpqi: capture controller reason codes
        https://git.kernel.org/mkp/scsi/c/5d1f03e6f49a
[04/11] smartpqi: update LUN reset handler
        https://git.kernel.org/mkp/scsi/c/6ce1ddf53252
[05/11] smartpqi: add tur check for sanitize operation
        https://git.kernel.org/mkp/scsi/c/be76f90668d8
[06/11] smartpqi: avoid failing ios for offline devices
        https://git.kernel.org/mkp/scsi/c/4f3cefc3084d
[07/11] smartpqi: add extended report physical luns
        https://git.kernel.org/mkp/scsi/c/28ca6d876c5a
[08/11] smartpqi: fix boot failure during lun rebuild
        https://git.kernel.org/mkp/scsi/c/987d35605b7e
[09/11] smartpqi: fix duplicate device nodes for tape changers
        https://git.kernel.org/mkp/scsi/c/d4dc6aea93cb
[10/11] smartpqi: add 3252-8i pci id
        https://git.kernel.org/mkp/scsi/c/80982656b78e
[11/11] smartpqi: update version to 2.1.12-055
        https://git.kernel.org/mkp/scsi/c/605ae389ea02

-- 
Martin K. Petersen	Oracle Linux Engineering
