Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386FFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 00:40:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244171AbiCHAlZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 19:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiCHAlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 19:41:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5092E3C736
        for <linux-scsi@vger.kernel.org>; Mon,  7 Mar 2022 16:40:21 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227L6kcR002124;
        Tue, 8 Mar 2022 00:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=EyF4KfhwMgBP/g9NSJbTKhv24ufB2RDw0n3UH2HublY=;
 b=Gneiv4Tc8Gb3tDYkAsTym81jmEMPA2zKrx/C+x+mAzQfagScSe8f6ZDzwiQUAr5Co5LN
 l88H0Kv9fEoQpFQ4Q4Ib3m9JOo3KGIygdStBlDpvbcGpXYfpW8Q//gGIY3GEToeDT7Np
 gm7YDp+5+wU9rFQJHgZl9VywkWUdkuN7RUCnM+m52msclKu2LXdN5uwuo6T3KQNBoRLZ
 1X2TcySxIkmQ6eQbguwDOawwKD2s5//SegmDGoZdLFu4JepxzRnoqWk5cxVazmAm9m6/
 I2madk5N/V9BNOiaAJy8fR8Blqn3sOQPMsUTQV8dhKZlCqNGV7mxsg4Z+0JydOxRZwZ4 mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyfsdh9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2280alEA119127;
        Tue, 8 Mar 2022 00:40:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3020.oracle.com with ESMTP id 3em1ajmyke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Mar 2022 00:40:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqSAYut+Q/v51ijy2RCiJmzKlSKA2nuR0rwiQg65JMbJcgq1L3n5k2kLqbV6dP4lwD4DxSVcN5PvMEdLcVF9Hwps82wia79l8K9fD4A90kgm39Q+4BQ2i7k4VstpKp59n+SqlNHbaAb6udq/Ef31PXJ1xK3xtPHLilrVqiTMbvnKEeK/5ZFl4M/LubaHksnG42yVxP46qr4OLygUk8s8uahNpWeTenbDGSC7F8L5FznQDaf7v5h7LIeS+J94453MIipndrd6HBUA/R4sTUQ/lPzygP5kQk3QjeyAPaQuv/bmxI+jWydy9tX32Ucosbmt3JmF19IQrn9elxg9AkGVEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EyF4KfhwMgBP/g9NSJbTKhv24ufB2RDw0n3UH2HublY=;
 b=mwnaNjntpI+irwep6JN0vEo9HNRCpsOMLC+FvExEhBU+ts30X3QPSADg8bsUOXgoG6jIaqPK32YKe/HCeNJ+VWYfiuCwRzC5Aiz/0CTR+1GQ8+F+c2LZEcs5OXXYpA+S+S1rimCbR1QDAcbRJQyMPDAivwHKpiObWVzxg1SxvOxHbnUywAqpeATZVOwQyvzxxWZI01GtIibCSKduW2nX2LYmJ53dN6TwOolfcftAXuHnlX9pHGBJO7jeNT/UQQ29LHwamo3cshBvs01W9gfYDZcAsjYjFC872MJ9+vg7YlrwaW67wabm2iWk4AGAOzEOs9nIh126kGytOh6toA7sCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyF4KfhwMgBP/g9NSJbTKhv24ufB2RDw0n3UH2HublY=;
 b=IMVul/4NSDuvdie7UQigN4djvKIYMPH22QzITXcqileXXHo3Wunjpkv0jpVTAyu6q7LSsnO4T5yGasNIYdX9r2fmbRYFEwsPo2eJ2yODRRXPMVeheX6JFkBt1vLSL2qELU3TR4xM3jdHqNfMPMjMe388dxe8RV7NHSW71mnTQWg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (10.168.103.135) by
 MN2PR10MB3680.namprd10.prod.outlook.com (20.179.98.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Tue, 8 Mar 2022 00:40:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 00:40:05 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 0/4] scsi/iscsi: Send iscsi data from kblockd
Date:   Mon,  7 Mar 2022 18:39:53 -0600
Message-Id: <20220308003957.123312-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:5:40::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5778d4ee-f416-48f1-a175-08da009c302f
X-MS-TrafficTypeDiagnostic: MN2PR10MB3680:EE_
X-Microsoft-Antispam-PRVS: <MN2PR10MB368094F8D655A8DC29EE768EF1099@MN2PR10MB3680.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hHHS0dGOxqdSbFfZIZcpvFlQSrj1tqf28o4OY3tNoWBwR5VSaYULHUiIg3vgRSS5Ko1C0qPa1XehamEat/ddYjiHjmOWMbNKW6pgtvR2HwMQsjwJHtoYT4ToJiPcBkugwFoZpA3FbQNZVNUFFJnmvpHx1oOGXoNK9q9zzFxLzFQ8oyogqWEODA3Nor4svdrwn48jR5QPt1xC/8/5Ts5bZ4BNT9e4f6NLHgZjScVd1i6SmCoxyCBMXrSBcGs+UHoY4IPLyf3W4rBzNFQyiZX4U9wb33uvo7aAtwiWBbwnJlrCgXdu8K7PohKQdj93PzppxMb4TgWV6SUIlf9qpSdhFmf7hqORBAx7qR76pVaktf03LVpEY8MrSpO7YITrgwORNkilrck+s3QAmvzgwV4BN7Wm3WDjqZX9QddHYah53nGdTlmH7iUjMBtdF464okXMsB8PFxxJ5GvT6Tt4uLKJ3K3VsyfcBU4NHdXZ/WvK5sDqgvTObfVfs2QgviwddaClCLcc7v/pKiBjjvHr2IhKPxUyufDpjV+m7xoQ05PW3oNLsjNcfbeZ2Lx696hcPXXrtXLT3cdtdgraVkJvQVEhzBv8NOf3yYzMeqnr8J8yzSmWBoysMnmMtiR4ouKwsuEr6OcvylgZ2GA2W79rF+ir6/HGUjXfzb4z/xSIGSgh7+jerydbByiIDt1eFuiG8udMXfe7Ns2EQFaJgdsvoN7CbojnHnqErUOPY5aAyXA54wEj+tAT6A4TNuXtcHY+U1DNX2DiXKKlEkbtJrZFXcmJY6qKnxh/37kmMEVIALN+0r4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(508600001)(6506007)(52116002)(86362001)(8936002)(66556008)(6666004)(8676002)(66946007)(6486002)(6512007)(1076003)(2906002)(26005)(186003)(66476007)(966005)(38100700002)(38350700002)(316002)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5N8vHpwekvRWV6JnQeDEDCg6enM6sn4J85oxgdIj3RiNPky8xZUOtHjT1ExT?=
 =?us-ascii?Q?MYite5wz6kNdCJpQuOfGwwDHVZNW7eDThqEgHtZemobJZwXTW6Z11iZdKeZo?=
 =?us-ascii?Q?VRbmludF/YZutCMd9BhOF0/mBAjUHmWmdqNU3Yj3V1yUNUBIgm++PArA5qXe?=
 =?us-ascii?Q?QvxDsQ7Q/YYwYZx83NPPQk0FNJvWZH4fW8KWziecMBsQ44MdOx7fDtDN4LJ6?=
 =?us-ascii?Q?gNDt4cfeqG/43dHuLZop0vVzOhstzbbv/ZJc7xRrsMvlVkYjyhLZbib0ZPvf?=
 =?us-ascii?Q?7qAU9eu7vBfYNSqtRbEAXiTBETtgniW46W+g/ZJMceF4XhIBILhydcWiTcmO?=
 =?us-ascii?Q?NH47CjD6nMvWGTAebg6ReHehDqwY2TWuvncuiHNmy5hL/DFxgmy3fWodruOc?=
 =?us-ascii?Q?DIywR4NhxTwqoxBUx5Ei9JcRChVK4h6UzksOE4/D4KqPJ+MGbqTLQWpJCEfB?=
 =?us-ascii?Q?TU/zRvz3EENtx8/XNxCgHndHcGiwF2MmKLmq+d1RW+OuJYf2jhrpr9inrbgo?=
 =?us-ascii?Q?4CuKeXXFkg08+4XccNts7GOP10mRrqLyDM/dU1hJUqoyYH+TMnX+ZHfG8To+?=
 =?us-ascii?Q?1otEoOJEBdGPVJQEOx1jwuswmkcavu89Vy4pomAJyHZaO1Bs+sShPhcP8Kmp?=
 =?us-ascii?Q?WqIAtzJYvHL/mwbWZHVdyEHzDqDgfAsQ3n71HjyBJjAQFyX44xOoGowQ9FuV?=
 =?us-ascii?Q?WGf1CIe5tVzzpahpIj2+hSD0Ekz+r/O52qoXVyl35Ae2JzjqossFTg85sEQ4?=
 =?us-ascii?Q?f4UiFq8QWvQ04CefMKNmzLQBmXwtsjBkJz0mA+yigQeV7a2uxT5sQr/EHhhw?=
 =?us-ascii?Q?zJ2itrwP6xfCRPw/n4lacV4EBy4S4FhejYgGlTh8RZHBwMLT4YWM7xhqWJTO?=
 =?us-ascii?Q?zLH8I305G/HGOLvZloQA7vE/IRS5+Qzs24rrbAodj5q+3mEP4aBvwls8rxSo?=
 =?us-ascii?Q?aNCxDDXlqER+sc+riT0SJj5IUBaQJGkfS4ZnI2ygazaJ+jePAgCOu/n3XDkS?=
 =?us-ascii?Q?iLa8YgkshqRTyYLApryorftPmmi5RSi3sBJdhzKvZu5BlG8+rYsPauKXCCmv?=
 =?us-ascii?Q?RQv5gAuYrYgGPJjym4BToPZ5D5F9lNrIrFGTxGSzcUxS8911MbxJ0ZIkw/FT?=
 =?us-ascii?Q?1Q8+vSDj6QnGgxzZ+otFGWZzy+PvzC3CPDmd7+KghOI34psCLvvD2kOkwTix?=
 =?us-ascii?Q?EwNZGehuKVD/36/zHuavBqDvvr5bodXDGESsWDveqxANVnCUUeS7waa8lkte?=
 =?us-ascii?Q?dkcITcbjoYCd9/TKYFaT9uJ/Wj5mYunHdSzG6u9CzBNr5sApTyraBKGcvhO+?=
 =?us-ascii?Q?jpBE2MT3s68+7s7FE5Ylke0qKq8ribVmzX/tEfWuMnsOKVh6CMQSdhQHxxz1?=
 =?us-ascii?Q?+fv51ZugADGt1nbOG3pS9B9jkvhJrNRatIy2aJOHpU+BfF5BEIecdEymop/v?=
 =?us-ascii?Q?TfmtV1H4vO5dTdOJB9pxlDnzt12rce1nH017FBWb8rwCVx2itqCdc3DEi129?=
 =?us-ascii?Q?F9QjcHs5Iex6CVafsSaj8Lsx/qfZnhWVXFqTWONdxO4EDbc+lv7ivjc4eIpa?=
 =?us-ascii?Q?gnIyvKmjVBw6Fg2BBiQygWiJXNMRjAvMnh8VsKher+Lf/QOhip1yiQnnP/iu?=
 =?us-ascii?Q?Jmk0f+gwIwWjinBXIf5/KdE8yiXAd6P+wKbQhvm+WS+Yhf0RoS2/mdTFaYEQ?=
 =?us-ascii?Q?RYNSyA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5778d4ee-f416-48f1-a175-08da009c302f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 00:40:05.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVxK7lsmne5r8MkNmmm3fteKjnuuo5uBkaVoHnWUzjyhRMpDSWLHiie4BlS6P0adEZ6lhAWs+eN4UAF0CRpYEfkycABJEbnAa37RWGjhW18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3680
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10279 signatures=690470
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxlogscore=900 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203080000
X-Proofpoint-GUID: -xMOV-azPyF8MpXfM8-KJB-AbnI0oWUS
X-Proofpoint-ORIG-GUID: -xMOV-azPyF8MpXfM8-KJB-AbnI0oWUS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches allow iscsi to transmit the initial iscsi PDU and
data from the kblockd context similar to how nvme/tcp does it. This has
the benefit that in a lot of our setups, we run
number_of_sessions == CPUs, so the apps performing IO share the CPU with
the iscsi layer. Right now, a lot of times we end up going from kblockd
to the iscsi workqueue which just adds an extra hop. By running from the
kblockd workqueue we see improvements of 20-30% in IOPs and throughput.

I made this a RFC and cc'd Ming and Bart because I wanted to get some
extra feed back on the first patch:

scsi: Allow drivers to set BLK_MQ_F_BLOCKING

because you guys know that code. For example the iscsi layer doesn't use
scsi_host_block so we won't run into problems there. But I wanted to make
sure there were not other possible issues.

The following patches were made over this iscsi patchset

https://lore.kernel.org/linux-scsi/20220308002747.122682-1-michael.christie@oracle.com/T/#t

the scsi patch applies over Linus or Martin's tree.


