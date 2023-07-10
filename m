Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D658BEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jul 2023 21:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjGJVou (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 17:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGJVot (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 17:44:49 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E551E0;
        Mon, 10 Jul 2023 14:44:49 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AJmcUT005734;
        Mon, 10 Jul 2023 21:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=rWlwasQGTQlTPJQMKWmIoVTSvahkeMDAQr3lm7cIeJw=;
 b=PPt88gJ/8mPRlPkXMUajxyxVGDi24j5gT0lqAgD55gFxtx7/w8wj9KbP89D72K3i+698
 z//ZD3b/u5KnZxNt+L2RCHDSMkd1b8Ba0cl1sLCPFcg5CKHeOexDgFNwU10g0WLXJpQq
 KIgKopdYBAoogwNdjgFHvNr9ifdQMUX9u5EXuUXazFitlu5qG+HwrxJwfkkvYFS591nD
 /Donor7gT/23ethvFENvm+Tf6HfFjlnVk8XvSp5Epk6s5XahROG2TUl/fRUzVIW4rDDL
 HeaRyBZUYWQCx1qm6nctFsWS7V+S3QDi+2GgAryg/TOVyG6tgwQLivxc+dANEAxjtVIK BA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrjmh94gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:48 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ALGsKV022906;
        Mon, 10 Jul 2023 21:44:48 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx841rpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jul 2023 21:44:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXwsueiGl8zJ5hHdWDHl6Jup5ObBkO7s584TPb/s6diq2MIQn+VOJK01FrdANadaEEtkdwq1MawCsw3P1y5salmVHPDmQsmdnvZfNfOiAWLzIki1Ddr/lBwsxgGn0hf8FyTFdAhn6/umY5aeHpNXKxrclCF+34A+XRdYceKdJzMhwi/BDv2PCEFNIFo8LfGOL0HLUAN4A7yWVAPqF7gP3slveyWNNs70ySoZQzaPq9KL++vBWQZ9hIbDANMLA7yCkugEuCbqi5kMi02XsgepBpNu4Fy4P3AKl9bD5dEt3B+95BvEyWaqi6fP3puuL1tklkgPMXKtLEXWD4blgWmsZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWlwasQGTQlTPJQMKWmIoVTSvahkeMDAQr3lm7cIeJw=;
 b=M2ClLt1fRUnXG1PL+qiMCoP8jzvlFdal9j3J7qtCop4MmYDdJ7eM4loSatKiXYPApIT9T7HB05/QKbVhTZGaaVS5Y1sK0pwNYr70qzifpxdNG+jb59P342L1/AMQPbJWdmsmXGb9vMKEt/Fhp4KFQ5jlqMvbKVwBrRn4CzzPqF7FFGjrdVGMngzqr0X3BWZolP9zIOY0pINuvtwWphlVZOrWONc+1jWLRidZUjGw8Owh9uiVKccfjUIaEvzseqmY+fzyDL+N86kOsxelq5icejUohVVbeXt/8Tjj02v7nVhe/Ey/++IrLBEIt6EUlTfqHAxel+pTFbULtTzFE0aylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWlwasQGTQlTPJQMKWmIoVTSvahkeMDAQr3lm7cIeJw=;
 b=IeZm+G1K+5jf8BcbeIoncGyLFDpsK1Xd95NoEXm+XZMammkNk4wbZ83m1hGKLsYxwDhenSsp1Hsi0+uVck7qiWyk/SyonwL/NgQ3mOvYUBTXzetgF9afeUKmxY4yTCmu1MZDHMyXQV8wB8cOwsdkM1r0ndeA00B3xZTfZlfzWfY=
Received: from IA0PR10MB7255.namprd10.prod.outlook.com (2603:10b6:208:40c::10)
 by CH2PR10MB4117.namprd10.prod.outlook.com (2603:10b6:610:ac::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Mon, 10 Jul
 2023 21:44:45 +0000
Received: from IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71]) by IA0PR10MB7255.namprd10.prod.outlook.com
 ([fe80::e2b1:1376:2375:ef71%6]) with mapi id 15.20.6565.028; Mon, 10 Jul 2023
 21:44:45 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 0/5] scsi: target: Allow userspace to config cmd submission
Date:   Mon, 10 Jul 2023 16:44:37 -0500
Message-Id: <20230710214442.6718-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0054.namprd07.prod.outlook.com
 (2603:10b6:610:5b::28) To IA0PR10MB7255.namprd10.prod.outlook.com
 (2603:10b6:208:40c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7255:EE_|CH2PR10MB4117:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a188051-eeaf-4f97-3495-08db818ee07f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26EJmROfEdSu4QXLFMao+16kWh039a4/1S02YkUEE/uUEFxI+mil3rVO/JMKAu7DmXV5gGL5lYN/q92BjBCNtUNa+NQWC0x0iAYLISn8pNHouT3s1XQJig0tGZEVHc3485I7UcfcNHijIh0RlFtq39hTVD7wH/6BiKSEd4L0spqhaRcXl79yIrix4crBBQIA6mxrP5lfwnYMzmVxACWUqugLoO07SgAJfg5P4Yuk/qbAGMeiQMaVf9ccU+QnfH6IhD98JpkrnnV7mOSvRpnZWNucyhELAbmk1ygfykRwfBbG1K0d3XKtMMSgwJZj+y1+YLzQkMinpG+tdUy3YlmGbfTaNmgzfdONVllGT0jFsEYsl/eOdQAfRxxNLqkzWAtsjKnOUUmOannHY2QutFYIzun6clI71aoHNrL6gYbtdUYYpcTfA+caEfPuqJmlXud+VQVhq8ibmZgYyQw8XBWR1RIVXNaxx4fDlGGzger53bGY6QGb2XZFDLGJNEhqcsXpQzfOJvwxC6W33PwzsQfpCdq1DCY/74pVVP06lQCrCNL9fpk3lkfBp4K1kSqxiAtm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7255.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199021)(6486002)(6666004)(478600001)(450100002)(6506007)(1076003)(26005)(186003)(6512007)(66946007)(4744005)(2906002)(66476007)(41300700001)(5660300002)(316002)(8936002)(66556008)(38100700002)(8676002)(86362001)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uX1Sud4hj4vzfViEwCcLdUf2k3f710BTQZ6ICUhBHms2inlo8TLdrApuw1er?=
 =?us-ascii?Q?vaXeb2NaQ5LL2FawR48FJxEOIVa9Au8p4s+qv4ZloB5aCdYX8ZCJbZEslysp?=
 =?us-ascii?Q?sY7VtMrGzTOjIWvYyKDAZmbJmEPY24/4AN+WEvyFj5CO3YBF3ELI95XFNeN3?=
 =?us-ascii?Q?s9VH/HciF4w/DFl60TwOK6gCp8u2RYoJu+nxvSdO7/TwSaLlrZ5SHmGjC2xN?=
 =?us-ascii?Q?Ke3YKyy0rcSBG/ESqRh8fjS+nsqiqbFgFqgTJOAQ3HKw4ekrAvWVTUWsKQS7?=
 =?us-ascii?Q?eNgZZY8evW9Z6JDR36Lbgtem6NNBhOLevPcVxSW3pkR7wCY71AYtuV2aRrhN?=
 =?us-ascii?Q?JvzZJBOM0phciHntyHGPWAaqr1A2GocXvHHOaHUN3T9F0vKD15r+xhz38kuU?=
 =?us-ascii?Q?5SFEQlg3xKAFXU0iQrUohoElADPhCrfGftKBzKOxhIdyAsYi2jjkFZiX/02o?=
 =?us-ascii?Q?Or1+XXtrrG69l81rPdvoSjRwFThDlfXuWPvkVjEw3Fm2CrZgtxe1JlcZTnIO?=
 =?us-ascii?Q?x0ZwGT9h9yxPWMPxoAf1SQY7WE89w9W42wyokDi3fmldre8Lj0uB7nKmiE9Y?=
 =?us-ascii?Q?bKtmZQ9cBbqy85d6Ss77fC5zITPVr4KzBwsF0JDp07h6vYXnDJjVI1roY3nw?=
 =?us-ascii?Q?EIF96O+TMZWWCiNc5m+uB63+CFA9hb8rR3q/gRxmV0AmG5IpSvBzquwabqeX?=
 =?us-ascii?Q?HM3Duva1g41LkI6VTMkdsveG4NmgSyxl47oAc8TrTHRNY+TCc0p+GlOHCvj6?=
 =?us-ascii?Q?vlgEfLm0B7QLOlmz38j6cYbcz3JHvE9uHZ+No0oxqcV8Gj46xc1L2z3ETUG5?=
 =?us-ascii?Q?pjgPTGJE335VA/P4BFVZKPRBbUF3AmN8FZaTv6Ta+nIggh3OWC2z4gV7Esfs?=
 =?us-ascii?Q?l+jXwIX6PEtJDHFlrokw9EKQ+fPt4nIWVcYnquNQQmqnuBTeM61+pVSeieCj?=
 =?us-ascii?Q?8NM1gO6epwxrNMrqn5FSMJAzxURGBCSANJIYjP2/gpfzfV1i5J7944AeAZI7?=
 =?us-ascii?Q?PztgHWgMJRjU2PYzD6jGj1OBZwfM/L0k257KN/vrI8RyVptRttewwhBjz50r?=
 =?us-ascii?Q?Zh+ecDoExMHbP3+zHIsjft6CgXjOYI9Tp3Obm3nfFYOwx5CHGNWU+w5kjZH3?=
 =?us-ascii?Q?c2LkN33YBE1V00PHzWWaEGKwsAv13glby/WrQiS56w8jTMImvkvuqc7/0kRj?=
 =?us-ascii?Q?8dK/pzWhVcTXcVXlzUivJoTIvbY8MZb4ylOnASbbfLcWxBQvcQEeYhoEPHRb?=
 =?us-ascii?Q?H70q+wKD5nUmXTMi4UFVSKcXoNdXBTb/+XejFSjZv80MsqcBXCaqFv5RUwyR?=
 =?us-ascii?Q?p1CehktQ+4K0HIO0PrO87Ihrg4SWpiqk8qLFSxhH4CmqYROXcdPJYJaOCTyA?=
 =?us-ascii?Q?cJ5iXNQz+s12FpUDzmgTK+7k7hhzcwcDBgGphO1D804ZJ7Isa3q64u7PjFeo?=
 =?us-ascii?Q?bkQunEp+kcXe/oZ/C+vu0QKGk0oeboo+J6zR1wojI+3PO5i9lLikwSMrwN6L?=
 =?us-ascii?Q?EvPHyRUYSgoAuwRwx1LX+HmeMKXRR3vLtiaYnPshLcM8v3oN9awzXA2TZKfD?=
 =?us-ascii?Q?1E/elPIpYISNsTxlw73m/iDuFw9LubBc/dkT8XPJuZgSj+wXCGKNrV+8t55C?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: k105yCQOXIxk64A648QS0ojcbv4RpeICNNtGbdTHXlEG9RHDPY1IHcb0jWXcz3X+PwfH+jX/A2gToce8/+Z9UnkE80nWEbgmwvGJJ+PcqpNz7LoO66EiOVG26yNR2QL3qEx3wMzA74lAhLZ7kqI5/nLYzIgj19PgN164AG/S5niPlCBDtWjvWk898iEm2xlRVPQ2mPfkPN1Tk5jVY82U/RIBKL5FnejdENOkSJNgbu+KSJazsdyhae9bPXrewD9L4R02PvK+jQZgz/T/7VHNvvJ6d1osWEDir/qC41dG1BZxKyjRQHdG5u4O/Iy+b9SVmIrD7K0BctiL94GDeppT6bDdYjvX8JjFK2d7mJeKoedOOZ+TK2Irdb1BTuGpMXyartjfXniwMVjXEIE7wvZfufmwh/1UpZdli9iu3WpAeu1MEaY3sr77RyQmHCGzI/5i5eSazEGclnxfDHR74diYaPnY8/J380x6Z1fCwh+DWUllm77cDObwrwghlwhUTfNBboDQAfSNJt/WRjGyRmjzT0vuXn68NxE+KFk4wc1/iQdkhP/jd56nuAZbRS2eYLErDrVCzJLEZpsw8n6tEjueEN3d7h/GxcjxYDliaEUuzBY0QpDhWcx+iyc0JCP64AoIGXPEDW91CnyoddEP2F2hunJxmxbRBX4PUs3aDgGqz+gaX6FFTKtR8Kr/6C7UxYbqko2AWzqzG8CctviF/urdT1o9MwJVwkoCqU99KdWVobYBDPxdHu0thu153mVKWX4qCqJb1XlQrGfmdrHV6ssq0A==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a188051-eeaf-4f97-3495-08db818ee07f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7255.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2023 21:44:45.6703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ORrIEuBT2kHFxaUgiDeC0p7tzlG0MDfYWifvFkpN18Hw9zzEjtMdnt1zX4X/ZVcjTIiu7ogbY8yzFMwSg6IQzyXJ7e2wO4pEb2lz9j46R34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4117
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_16,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307100198
X-Proofpoint-ORIG-GUID: dJI4Q8fago4-s7MiD4RTKWWxw3izJpc3
X-Proofpoint-GUID: dJI4Q8fago4-s7MiD4RTKWWxw3izJpc3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree but apply over Martin's
branches. They allow userspace to configure how fabric drivers submit cmds
to backend drivers.

Right now loop and vhost use a worker thread, and the other drivers submit
from the contexts they receive/process the cmd from. For multiple LUN
cases where the target can queue more cmds than the backend can handle
then defering to a worker thread is safest because the backend driver can
block when doing things like waiting for a free request/tag. For cases
where the backend devices can queue everything the target sends, then
there is no need to defer to a workqueue and you can see a perf boost of
up to 26% for small IO workloads. For a nvme device and vhost-scsi I can
see with 4K IOs:

fio jobs        1       2       4       8       10
--------------------------------------------------
workqueue
submit           94K     190K    394K    770K    890K

direct
submit          128K    252K    488K    950K    -



