Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C080C6FA86
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 10:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiIVKHV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 06:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiIVKHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 06:07:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA22B6558
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 03:07:19 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28MA4uj2018946;
        Thu, 22 Sep 2022 10:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=xEpuLB+eMdMSvFlbppYNbgBuGvERTkYCXPGSEAVxOPs=;
 b=HB9wmjBo7f4fN7mH14VpjHyD6m9DTapllE2POx9XgAIjdmlM4+ki1umy4mexzvuX8o6/
 V343m9pNn88sx3ay83tupJ3tp5bVky9PQz1EZZXOInBSEMWUN0Y8v9FwDBd+4Xxo86vF
 KoCV0rTDyeFopoZLKrqvKo/LFp3lUk10+g7QNKiWrCc2jZRd0JHKs8r8ki7fZKbu/gFh
 8RF7V6IruY8rbgZgzcNoniUGEkkLZh3QTdgOIj3ZzMIaJWGSw21b/UgIOMM1mqRleGkH
 EnXMLNI6CZ/X8LRaNMWEJYr9StT7DlLW1KpqCKuPk2KMVix+Hkt4NGM3SyfvPCRWoWwR Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6stnaht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28M8lVkX033800;
        Thu, 22 Sep 2022 10:07:08 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39nednb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Sep 2022 10:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4RIGQxS/yl86/tqIXeRYUtZVlv7y06rS8TUltlGxUwPpfJjIictefFLJH0BXsX9VAzdeilaW2pYSaysJYlvxlwezu8f5QXzOX+M6+j7jGcajr2jQ+seb2U7jDa0Di+rAog+jPZgmc9BanqbGUA8tJINa7tmljSOayjOvEmJLmY4g2T/JU3bECWsGTNsTmt5U+jNIQO+QyxeCbxmGf3g82ZTKGsEzVTaw6TWevo+AdzKTk3uKHKyeT0enfO1imSr1C/a9kcLV4VSw0odVj+nxrnWnchcsVQr+10+zbGR8VYFVnSp8HZKw6y9+pHxTW3kmP/kDp35LjAwHk1dbkur1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xEpuLB+eMdMSvFlbppYNbgBuGvERTkYCXPGSEAVxOPs=;
 b=h3RlIYZl/veVMoXdNULaeta9/wqNK5Qu5fn19sR3BD10jv/1Vm8T+15I1A4lbMNKdA42FJm7LmZc++6fUDcYhYQG4qmovOJtlsuYGFBLwQtQoYSZ9yWEUnHFfORYBo7gfftbL2u62/LuBB590Q0t8FyWY57iT57bRKEXiS4wN1uHpPk70WBNbnudDllscZP8cJI4cRSvhLxECEjcv3XTvwR6/szK8W+TtdkppB7XShRFiaIbi/jxg4vTWLvvTzYMDrk6IhvQpl+qhAXTrgxg6wD6Jhdu8vGNY/uSK3E+GUckcJI0P2WEu5Tzv5T0P6Ai6qyQWqTmeumKGl5PCiBNZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xEpuLB+eMdMSvFlbppYNbgBuGvERTkYCXPGSEAVxOPs=;
 b=KgJlj+Wyb8B7yJKS12UgpdhubhAPLNHnQI9n4GCT47VuWxvExRihbpxGuQghZM46iPdXGoZrkiHV62Vo/p2ESjRBVdQ2EamqBb5xIV0eiBe9AhFXMwnCO8+/RDLOalWsslTSaGu4Zrn8fGCZlOel8FKCCGbOlvv9QgI10L0ewzA=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6243.namprd10.prod.outlook.com (2603:10b6:208:3a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 10:07:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::bd6a:7aaa:ecd6:c7c1%9]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 10:07:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH RFC 00/22] Allow scsi_execute users to control retries
Date:   Thu, 22 Sep 2022 05:06:42 -0500
Message-Id: <20220922100704.753666-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0023.namprd12.prod.outlook.com
 (2603:10b6:610:57::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 4af40c7b-e8be-457d-f051-08da9c8234c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9klb79g9LnGvKqpbjv0i/42UixXxSo4pdx1R/24ZH7LJaundA8jQMPk1hKik1KEYRYbVA99EeLqCp8r9eTuEfEZPj9GC4A+zR+KiYrYT5xUDREm0XwRQNaOK7uP1ExE2elO3P3EiUIrFwyXWUfKqCcfCZc2zyc6/ptPBTGlrz5Sfpbrfb8Buj6VsrxE+LYPZof3C9Sw6FoYZbYrW46R+kG8frPmFU3q5unCM8zmr16uG+7x3vJiogmEJ4DFY+UNIGfaXC9qVl6eHYAKDr2wcxDQgRLILJcB1Nf9LU4XTETJAYrMjW28sUfoWxXVsgILV5RYz4EzjZKKesLj1sfVxydAGdwQrGZ0a93oUtXdPVG8ceeFfrxFY3zwShSW95B6hL7+mrmG4Jw/Mzo8H1FfOpx+zXSeVXcgaJnzhGl5XcvZ/VRKdvXSpRZvmo6Ph0D0RQS3ZBkLDGZ0u4i9FkcUY+mJgnEnNbJhlje1sK9Ht5RRT0r2Itt/AjmQa3TI5E/fLHMW/8vQSsD2M/5fk5l+pX/wWyLTtddnk9TkibkOn+col6Wo5coOWn0YlK6vsstUPSLx+pqUYBSNyr9rp6+Tz4d6WHZjyRvIPVORUb7/JY79Grczlu3Jv7GW5RY7zzHUMJBK/dXrkEpX0cpL8ZEdRP617O2Gi5jk8Wrk4QErcp26GG6DxZpF9ER9tYySIPtceYj8+yXm7h8rPOyCgrJvefA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(39860400002)(136003)(376002)(451199015)(66476007)(38100700002)(66946007)(41300700001)(6666004)(316002)(8676002)(66556008)(186003)(1076003)(83380400001)(8936002)(2616005)(6506007)(36756003)(6512007)(26005)(86362001)(5660300002)(2906002)(6486002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wKWChfd2i1XOoG6RAKuAMUmIjVoQwjFPyIdEaWi/MibDBnLol0hkdx+8VAck?=
 =?us-ascii?Q?8mOI3RLtPcWgr/3CrA9VzV45wzdkYCsKcMkgQOJHa9JvBwtSImJjUrfxGJo+?=
 =?us-ascii?Q?TFJ4S4ScMX/xz0lIQBD9XbPQVbZh6D7Jab80poUHtzdJ3gE0vxNJm1axsgCm?=
 =?us-ascii?Q?tU0YsrQWOoWogSt6ohLpmt84WXJhWrKlaE6tA4DnF7WMc9ReY4FnBPnbKOfx?=
 =?us-ascii?Q?RzAWmQGkaKqQdN36jDC971UO8EJVQ9e/oxk2GvUgtBfTIUoc00t8dTGLb+Bk?=
 =?us-ascii?Q?exqD73I8YCLJ8v+NvInhQUO57KUcb8dzi+jz+RgornV1EisjZQKeDiPqlqbJ?=
 =?us-ascii?Q?Cp/+W3YEtZqJnjTLLhKa1Gx11zCxJMwbOFv2yFIg++/yNy0w2zynPGLZ5gYZ?=
 =?us-ascii?Q?YWmkRSX2kv6lTZwUTK/AeCSGiEHsFRF9SdoEZK8SzcKm/LF8Uv8utWbiEeAg?=
 =?us-ascii?Q?TxxhP0a6CdZhSgdok7cR0n8DoNOxKXuPl3/uHOl6+VPR4/aqeqL7OkThe6V3?=
 =?us-ascii?Q?BngqaUwKPGLO0HFr8/g3uEDMp6Uk4eDVr/slTha8p7MA2mdlYVHU/QG4ZZfe?=
 =?us-ascii?Q?ZporolD1nG5tdVmqg7IWyk23oflI16jExf46jZg0ZnZfBv+Y/2Kbi9odoHHS?=
 =?us-ascii?Q?COUiprKCB25zd6uQw2uw/0p21vdUXOuPUmh/SL6s7bnepiqfZx39oZ2zfDIq?=
 =?us-ascii?Q?RKC9m/G5OXjvF6GHlgYyO2XrRJQbZu96TPnk06WzIGl1eKIwNBvA6ALNZYOn?=
 =?us-ascii?Q?SQQIMz/RRd4r6dBPiFAfioNVGe5wMitkn8j9tt6cSc75Pl4GREPFV96znRWt?=
 =?us-ascii?Q?fZFajVrk5QgQ7qdlzH0oeMkE4IXclLBDNsuK+kxYYBhw9VN/cL8GqZ3UaPCE?=
 =?us-ascii?Q?cl5KTuSsmhoXL42c0R4RGrOywiqLRrjRBPw7/avRJ10r+gcU1p7K7UzfDo8T?=
 =?us-ascii?Q?EE7ucY8JyrMAS3jZt3DZBkuQxZeRyqSde6aRaySvLsYJ41Yz6ObMa2TbcbS+?=
 =?us-ascii?Q?9ZpTNu+cSzT+6u7X3OjGkYJBeK7v8BDmvQbUhk4vln9+egfVbTr1pPeqDsr0?=
 =?us-ascii?Q?zh+XRJovHMqrPmvx2CW0TA3a0F7rMTJmJSQ4KI8CPWRc2iczbgU0V/WigFRK?=
 =?us-ascii?Q?ILAz2S/3i57ie5Q+t9tQXG1tgYu7pNYdRBXzAVD03C3T5L73mhJMeeS18Q4Q?=
 =?us-ascii?Q?L05QVoreH60mFWc1i0AZ/eyxL6EVZyUZQ81kxNexToZaLGZ8Xiht5HFj7HPp?=
 =?us-ascii?Q?86zH/On4f8Lp+fnG2/XvVzE+YzU033si+9M2xxrKouJOJ8dQbzZaSWVA7FTH?=
 =?us-ascii?Q?BuDpjg3iNgOjJwJdSCBgzcmMWF7TfPN30uuj7D0El9g61pL8/YPp3gQAMKjC?=
 =?us-ascii?Q?EcVchPlSgQfaP5R4CJ9InwCGa4LPa1wQNGaj8yehZmdr/FWWT2W/Es57eYFh?=
 =?us-ascii?Q?IvIJQ6qMRwknF1XnjZVjDCMy8bJVNqHkZBHBPqyjNbe9krhbNEJw1N9ep8JI?=
 =?us-ascii?Q?HFnl7yOBZXWxw+a0PHu5em2Q7k91vm3S8O9pW2VEujFH+w1FyzCq19w5yu2r?=
 =?us-ascii?Q?pZFVnJkmbBwzgW0PmvBCwdDJB3xlBOV+F/P1w4NIiozRamMpw2dG615Mq5a2?=
 =?us-ascii?Q?Dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af40c7b-e8be-457d-f051-08da9c8234c6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 10:07:07.3043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcS97jZYGxCOMsyqxtp+isTUno9Tiy2p+bH0qFtV32Kpp3F1g4v0MZx33OZsC1XJiIwgetRPGnaLy2tFwWJlJSjvLsh8H6kP+T5k3r4t2IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6243
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-22_06,2022-09-22_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209220067
X-Proofpoint-GUID: QcE8qKW2L2AMnPl9XY7ntfg2CGaid9nD
X-Proofpoint-ORIG-GUID: QcE8qKW2L2AMnPl9XY7ntfg2CGaid9nD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches made over a combo of linus's tree nd Martin's
6.1-queue tree (the are both missing patches) allow scsi_execute* users
to control exactly which errors are retried.

The patches allow scsi_execute users to pass in an array of failures
which they want retried and also specify how many times they want them
retried. If we hit an error that the user did not specify then we drop
down the the default behavior. This allows us to remove all the retry code
from the callers except for a couple cases where the caller:

1. wants to sleep between retries or had strict timings (sd_spinup_disk
or ufs).
2. needed to set some internal state between retries (scsi_test_unit_ready)
3. retried based on the error code and it's internal state (alua rtpg).

These patches have only been lightly tested. I'm more looking for an
ACK on the idea because this is different than what I mentioned on the
list a couple weeks ago.

TODO:
1. There is still the scsi_cmnd->allowed/retries. I think I could just
add a default scsi_failure struct on the scsi_cmnd and make the code
more common.


