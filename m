Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8C9C4167D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 01:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjKNBiK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjKNBiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 20:38:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59651AB
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 17:38:05 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADNsUTr000814;
        Tue, 14 Nov 2023 01:37:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=w1MgbJKTtd2MmiMWk/dKXRGsR2epzY84Mg8Q4LR439k=;
 b=qp3CYYeR+SDgu4rl95ghQ/Iq1vUx3LNrRqU2Pgc07lu+433FTo280Xo5XwCbH04QeQd+
 f3wAMgTJm7RUczHVgiuwf3H9emo+a1uq2OQU4JGZaJVpjKpSAbFLf5T4BvgyT0NIAXVO
 drA65EYdMq7D+8Q+0payWehaig7cHnr6Tzb36Q/yacUWffxFFSdMucpStlME15mqC1tJ
 lOw/Ec2F6pudsjHaHLdno2XDf2PdzhQSG+yd0Mv/14KULg7wBIs5+QgIFdmr0CM7+0hR
 pey38eu52WRfuwT9S4eWQ/macvkIC4engL+ujtgfEYUSYOpnqjbqji3g41SOdzgQyuqb wg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2n3c3mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AE1ECRS029776;
        Tue, 14 Nov 2023 01:37:55 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqqsc1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Nov 2023 01:37:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZjy5V7CQPulZh5xWFAK01iyx0GLstebmrMBIbBEnUC9dyb6DO6x7TYiIbKqtTiC5S4WD5ihPB96/TdhnFMizL+Pl+Dg2ERebD4Z6kHTcKDuXUKw5VgrxWOH9UTvCjYZQ6GjEr9VkqqL5u6EohFGDu2bg9s7Uk0Fd5jp4OeIcUPeSN9ZkJsrZ7KJxOsQaYDtdRvtI0uoYLb3BcxELlMyQuzsJ/GvitInctqjMWgkNTogYJVNs+8HhmDENvaeej3iG9JLCR5L6l3tTIIKKnYVg3tKAFgqfVHz5zfv2lyzSm3niTv71t7FcWuH7F31YCDG0GhQ8P5rzVHH0ZF+Nw6yrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1MgbJKTtd2MmiMWk/dKXRGsR2epzY84Mg8Q4LR439k=;
 b=ahHDCh2vdhMi2MpEeZFy2rLLUUO/WWobLMxE38BjkUfFvufdZiEt4jzORe/24KDeNRHLJQXcs3P7+jMBXNs7HD/35/tSdSLY2fdmhs5LKRTxumX4yuwnvYKk6ZGfiF1EbPbhVtoUCeT6x7ds1sam2Ck/OFLuQ4fo5chNXOveZf7PgLyTuuIOgo6msrFqqaH00UbFNwcnnuCBPWhzuyiOiNqCMfFlZeuHQpjE73qrSlVf9EMvlcRHtBW3Dn4TErldEwbf03QOSPTiIZ9eUANAo8W+0oIta3bEDZ0mvvUoSrzFtU/tGFNhti8Uipvnzn/Duic+4PO9uLgIYFHh+tJdLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1MgbJKTtd2MmiMWk/dKXRGsR2epzY84Mg8Q4LR439k=;
 b=NDUT0ubtn9uhmMAIz8m5k8h/TMl3usgj5w67WOwQCz3npoyID6K19irL+p/r7cii8OE3u5EyITSkZYn1fDkeoBxYQCYARhmTOZ5L8HLIGZoHtp0g6IkywSeM3La09h2OUa1i9kP/2Iyd8zFRpF0Oag4pZWqPVPngJ8tPtBCv+KU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6752.namprd10.prod.outlook.com (2603:10b6:8:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 01:37:52 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 01:37:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, john.g.garry@oracle.com, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH v12 00/20] scsi: Allow scsi_execute users to request retries
Date:   Mon, 13 Nov 2023 19:37:30 -0600
Message-Id: <20231114013750.76609-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0009.prod.exchangelabs.com (2603:10b6:5:296::14)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e7d1cb1-933d-4100-ace6-08dbe4b25176
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQhPRQsBFDfmiIlDa0cerjnhMs9Kc1xbqeIOMxB61wGZf8Wj53IJwLFZ0ZNDO52Xc/3X1alKDC3fE9IyufI/nbDEZLzXeWn/LKAv9eOTyubljIaB331m4zcQcJk4KQfug6OwK4bcNZURMzLM9imJGQ1b17DNO3VNaZmqDjVvV6xlLGEQ1TvJNuKamlGa3kIIdNL5t2Z1xHvS/98hvYYzBvMn5S5VREvZokTuzpee7pmm04DOk/D8dm0fSr5/VnW1Ihb5FMfWqrjd5JYgLvwlqTDS/DOubXjF5Ca/ugrxe+wFAnh3VEVXJHPQ+kbCBj91yOKzHNo8kE8glYox8riEw3g+OQPTeWanC4ZQQRNoLUO3bgykjq3T0vHWpk6/YpBAwv1Npuw/97eh348ZQ+IoFz9QkZaVtoaryrwGxznFdMwlOOA1sAWcMGQjZZvE4eyMxC0PX/aM4eNOtG9nIaeY1LsJXvffhk2RX0LYvSG6Sqq6jlwOBeOW14r3MFK1oVnQMW8XG+GBc6kLFQzW0HCMiXxu6vUoJX9E/6D8GtBEX5Na1HjEziDyi8hk70aOTC/c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(1076003)(6666004)(6506007)(2616005)(6512007)(83380400001)(8936002)(5660300002)(26005)(8676002)(2906002)(45080400002)(6486002)(41300700001)(316002)(478600001)(66946007)(66556008)(66476007)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JK0BH97WmYGoV8zKq4fwoc2nDDHrreHPZGeuYyCK9qn2axNbTBspT0GbZr8X?=
 =?us-ascii?Q?yaaCK9waTFUiIn3pvmbk9/gAOe48kiRW6D+OMQoIfAQh3nJZf+JqpA5jJtKB?=
 =?us-ascii?Q?Z/rsl70zbGLW4DfME6wxl807yuqd4LUNeRHtfYCSPxriRN697xzdpyfKnOak?=
 =?us-ascii?Q?ri2QVkpKDtLgg2E9msA1MtVfBSpRBDfApxtHjWOCGM4D42qCG+xO2fCwgdTU?=
 =?us-ascii?Q?hEaZ8zHrYbRNxljRoDSM1kYM2YiL5nWjJecyAvEhD3z/oct+N7Wvcuibi/H7?=
 =?us-ascii?Q?SPxYfM7KeJt/7GFy/+zaI+w0NKSuewprhzSFLBuNNAFD6YSQgrXM1owcnyKf?=
 =?us-ascii?Q?+QqZNG6KwtdWeFrx/r6Aia7jyONal4ybgxH+5kjeNejvGz9tLR/xY/EYAJWC?=
 =?us-ascii?Q?MSMqiEzWWK7vMgBCrvlB9aTp0DKGAhbjDJoWHA8LzJlG8reWAVEGvwvsIzTR?=
 =?us-ascii?Q?FgAYvGFNE5999c2sLhu4t4UixkW36bibUf1P9t4PoV0sMnSFdZ9kdbldQ5s+?=
 =?us-ascii?Q?w7DpWf9l9Ut+eAONo8lJYMgjdMbX89Dx2SU/LLe65xEqvBZxeLXk47YI8Kgm?=
 =?us-ascii?Q?T8w+PzMyDIdTOXOS/c3qWgSl6sNQeRnqGTdxNWInGKjs6xcCwGjFTfs6D8ux?=
 =?us-ascii?Q?vgWRO4v7vzVMjpop4QgV0x2fFsn1AbSVRvyTlS+xT6PEK1LdChEzAe/lsdFA?=
 =?us-ascii?Q?GjgbAvZjcCpfEgOUnyANMgGKXWjabrVZQjmO4K0HA80to3cEILG2j+W4eOrq?=
 =?us-ascii?Q?8ZuVIJzJgRT7gn5yB1TC2AKuGcRuMP+O3nT0qpLf1FZZZNSV22ennJFA5BoL?=
 =?us-ascii?Q?d6bl6NoDfb3uf0kECvt7c4NjkuBMey8X085tc6hXaSxVJjHwzXT7boT50BWq?=
 =?us-ascii?Q?FgCHgqTQYz+Stl+IRcbtHJmNOOes94x1IVRBIaVwspNEwMkLt4QayizjRSUT?=
 =?us-ascii?Q?8W0c833FUKUTptUVewIkhyYjwsEHQVqSx0HK8FlcKK2MbzVy9AX/CwpJYuBP?=
 =?us-ascii?Q?THNCc51EFGwF8L+mfH5d6eVBzAm/KMwsYBEguMOqvcZNQjlCoMomLL0Mgvo4?=
 =?us-ascii?Q?FasgP9A4L5/rIK49dq1UfQE8rouWPLptRFFZU/yfoVcLJywnUbC6qxbtwN2D?=
 =?us-ascii?Q?meHmBTL2kTAhp5q1nSj97FTJEOQAlERnEm3oBHpZvjJttxcCzaWX8YJT/f4b?=
 =?us-ascii?Q?0I7hwYq9TcEp0YsJ6D20ZxiRb9c37FAkaqcLbF68ANz4AwaCQgw3Lh9i+g6D?=
 =?us-ascii?Q?UsgSwmCnrMfQPr+pROW0aCTHrmLRv0XWqE72xgXqt32BEVdvgw2IWVm931JY?=
 =?us-ascii?Q?jsxFU4e0vEesM5rbRjoBO/NkOuVYcGSqHjB00UQLHN75lsygXk1XNw0JLnNu?=
 =?us-ascii?Q?3yX/9mQaPzmLvp8/EH3z2W9LiZj+j4XeBlZ35GdkW5pZ/hDGEHxuX6kRwdaF?=
 =?us-ascii?Q?Fzqm5pAPPkkiSusDEz5cAEsGt0XAAX7M9ZD83V/5ncgTj8OqYdWxOZpDqdg7?=
 =?us-ascii?Q?9lXTzYzq6mxctLclbI9MFa7r64jNtoGTI59YdV/hOXaJM5C4BDhWguxOacZf?=
 =?us-ascii?Q?4b9QWYDYhHmK25ixOP7QdUZj2d6yPcNITT9cyt/Q1+08pkAgnCF+jSe7SU31?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DfcUb66epHcWm/AqYJqCS80z3g9adubpj2qy2/Wyqao5rsz5/Y2xl8U6aa+5JxH1CB4Qos9zLYk6ybnXhmgv5QZEyHvjXp58+H1Ha5sSrG9xjsapGL5KjnZdVHzC+dbDjMInf+qon8gFMK5/WLv75GKlDwTLlK3SV+fMsCxuH5DJdzObSEz6fvE/5Cjh4cITtsDYiMdRHi1QUpBzgdSqmqDPiwxuqZ54/nqaUcI1g4nrDJYBlZ5+6F72sk3c/m7Us44xUs/Xq5GILvSgC5T92w7xJYQqI447RHYvlIVL+nu0KKONQhTPwfmEyUHRJI5BkG1QRDUP3uCUsgSobeMWfZ2YNI5/ES3uEa1Ryf8l71eD+SPVghSnL+uACGSiLKrZk9IAI9YJyaRzv6+K7fj8hcAazUlGLmeAHkk1hMgCbs9AvjDunbUlkmpQlzzbNxlhC9F1fJ6JUfFi7frP8MjuQP0Y5Oxh7Y0vKYwXWGBVWGa1EDdKzfTYuHBZss28eRyz8KISoSbFnKrvmYD4UsUOC1h1V4tSMEJ+Z8wLO18gdpGdQLaESIBoN1Qft2d+xQGYSx57wxvnYP1jHue49U2XWK0ZCEN9uK7UNoz+81Yrv2DNWbomIhv0rxWLHIxTnND4qmQLNfx4WSVPTqBqb5NugP4PYEe6DyB6fwWnggRgfLXu1y/+icaoLM6XSeNRhqG/0s51Q0zQ40sM4ccg9LG+c5Cn5OnIxMMJaCYyU98Sm3vh6WysnJrIQYpPjibwtSIe9noM+NM9mn18z1Is5uyK7UbuYeHtJEM0e8HBGAN0OnOrYRb17hozpB2SCXwq6HCzs7w/3HIK6oFOQwchI1l/uCl+sHtSuofIZpRuT14sSBsb+GzpGfJ6HPd6blJTXc3/
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7d1cb1-933d-4100-ace6-08dbe4b25176
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 01:37:52.6398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zhBTITHSWa07NlUTdWKq3JM3A/Nu1DI9cL/3OfEocy60+9t68XFhBNejGnOUV5I7ZqMYSMMKNUsHeUDQAA9z+2VgYAc6nRSlduTzHD3lT4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6752
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_01,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140010
X-Proofpoint-GUID: ZzadRh4ASDiFrZwqcsbrHSIkk_AxJJUG
X-Proofpoint-ORIG-GUID: ZzadRh4ASDiFrZwqcsbrHSIkk_AxJJUG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Martin's 6.7 staging branch
which contains a sd change that this patch requires.

The patches allow scsi_execute_cmd users to have scsi-ml retry the
cmd for it instead of the caller having to parse the error and loop
itself.

Note that I dropped most reviewed-by tags, because the structs changed
where before we only had struct scsi_failure we now have the struct
scsi_failure that is in:

struct scsi_failures {
        /*
         * If the failure does not have a specific limit in the scsi_failure
         * then this limit is followed.
         */
        int total_allowed;
        int total_retries;
        struct scsi_failure *failure_definitions;
};

so we can limit the total number of retries. The setup for this is
then different and I'm not sure if we everyone will like it. The
other parts of the conversions patches have not changed.


 drivers/scsi/Kconfig                        |   9 +
 drivers/scsi/ch.c                           |  27 ++-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  49 +++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  84 +++----
 drivers/scsi/scsi_lib.c                     |  26 ++-
 drivers/scsi/scsi_lib_test.c                | 330 ++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c                    | 107 +++++----
 drivers/scsi/scsi_transport_spi.c           |  35 +--
 drivers/scsi/sd.c                           | 326 +++++++++++++++++----------
 drivers/scsi/ses.c                          |  66 ++++--
 drivers/scsi/sr.c                           |  38 ++--
 drivers/ufs/core/ufshcd.c                   |  22 +-
 12 files changed, 822 insertions(+), 297 deletions(-)

v12:
- Fix bug where a user could request no retries and skip going
through the scsi-eh.
- Drop support for allowing caller to have scsi-ml not retry
failures (we only allow caller to request retries).
- Fix formatting.
- Add support to control total number of retries.
- Fix kunit tests to add a missing test and comments.
- Fix missing SCMD_FAILURE_ASCQ_ANY in sd_spinup_disk.

v11:
- Document scsi_failure.result special values
- Fix sshdr fix git commit message where there was a missing word
- Use designated initializers for cdb setup
- Fix up various coding style comments from John like redoing if/else
error/success checks.
- Add patch to fix rdac issue where stale SCSH_DH values were returned
- Remove old comment from:
"[PATCH v10 16/33] scsi: spi: Have scsi-ml retry spi_execute errors"
- Drop EOPNOTSUPP use from:
"[PATCH v10 17/33] scsi: sd: Fix sshdr use in sd_suspend_common"
- Init errno to 0 when declared in:
"[PATCH v10 20/33] scsi: ch: Have scsi-ml retry ch_do_scsi errors"
- Add diffstat below

v10:
- Drop "," after {}.
- Hopefully fix outlook issues.

v9:
- Drop spi_execute changes from [PATCH] scsi: spi: Fix sshdr use
- Change git commit message for sshdr use fixes.

v8:
- Rebase.
- Saw the discussion about the possible bug where callers are
accessing the sshdr when it's not setup, so I added some patches
for that since I was going over the same code.

v7:
- Rebase against scsi_execute_cmd patchset.

v6:
- Fix kunit build when it's built as a module but scsi is not.
- Drop [PATCH 17/35] scsi: ufshcd: Convert to scsi_exec_req because
  that driver no longer uses scsi_execute.
- Convert ufshcd to use the scsi_failures struct because it now just does
  direct retries and does not do it's own deadline timing.
- Add back memset in read_capacity_16.
- Remove memset in get_sectorsize and replace with { } to init buf.

v5:
- Fix spelling (made sure I ran checkpatch strict)
- Drop SCMD_FAILURE_NONE
- Rename SCMD_FAILURE_ANY
- Fix media_not_present handling where it was being retried instead of
failed.
- Fix ILLEGAL_REQUEST handling in read_capacity_16 so it was not retried.
- Fix coding style, spelling and and naming convention in kunit and added
  more tests to handle cases like the media_not_present one where we want
  to force failures instead of retries.
- Drop cxlflash patch because it actually checked it's internal state before
  performing a retry which we currently do not support.

v4:
- Redefine cmd definitions if the cmd is touched.
- Fix up coding style issues.
- Use sam_status enum.
- Move failures initialization to scsi_initialize_rq
(also fixes KASAN error).
- Add kunit test.
- Add function comments.

v3:
- Use a for loop in scsi_check_passthrough
- Fix result handling/testing.
- Fix scsi_status_is_good handling.
- make __scsi_exec_req take a const arg
- Fix formatting in patch 24

v2:
- Rename scsi_prep_sense
- Change scsi_check_passthrough's loop and added some fixes
- Modified scsi_execute* so it uses a struct to pass in args



