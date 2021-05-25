Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E831C47086
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826C4613F1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 18:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhEYSHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 14:07:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56444 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhEYSHu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 14:07:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6FlS108282;
        Tue, 25 May 2021 18:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=UEbR/TU4dfOwbxSAmJe7BU1RHfNXTBnDdOXBg+wT4iY=;
 b=oyOyZA0yD8VhSKGykfm3UIdQAfA0edDdBq5di5MzQjpBGv1Z/MCy0bVEiEQHz1J+pKu6
 exAG1yXKoFkfypQv2lB4Qtu4bhS2O/pRt48Agy2R2j31GNk6T0YaeMHRKSG9nshRTWYK
 gMW7ECZdEAeak0bFLoMYPrgLkTQWee8AGXZF6zWih3TsaTSKxdhgqIDmO8qmImEpayrT
 VDiYgVzKGW/dlRc760aEhYnYeuApVGJV7Wkb8V3QL3fZe52xFIDm6yIrSBN3EcDr9GwN
 MTDEpcX3UqA3DozsYCpgN2//H0WmVxLDhdie64wviRyPiK2EStWAjYaJO8f51gZY3oJh rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38q3q8xc00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14PI6D76185054;
        Tue, 25 May 2021 18:06:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 38qbqsga75-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 May 2021 18:06:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl3h7r20/lBbxpAHmrYpLn48cdxVDvYqFV+oJyeOD/h/IOyVWmMKuvBQSI0ZqdioPRJdgXL3W6bgpyPD7hjdOH5/h3eE5pjmxuvfSeKvT1mzU57kK8VFD0C1gAWEld9Zn45x0w6Man2f5hPrq2EDSTqSTFdjrR60bpmNBGz0toFjs7GamnisLkfcPZ3qbrfnwxEQkV8ADMNpX8xeOtxUyt+qSLjy44bkGOUrCA0Nsw/WxJWkw8a4iIhpC2LO3g6feb38iH9f0vZr4htfibpWtMIZH7K/oimP+dfq0yOZpPBizb5fW6hmc6q2gw5p0MXCQpofmRltLp+THfDj0V4gtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEbR/TU4dfOwbxSAmJe7BU1RHfNXTBnDdOXBg+wT4iY=;
 b=jRujViRTIbJdQWUuERGnic9fU1PdaXJXJApe1A7EGKA6zeeUI5EHdw3Jd06n8ToDJoBXSWPC3MCNn2om35aMopTY6/7ZQuyHVOw8P+MYnE5CmYiNewJMSLZLiLiOCWxkM1ulA3voB6VZP++V1/YTbLFl7vwZU2k7Olo+qXgfkBjnSyqPwxxe0DzbwTSKMfsV2ftIokJ663ugP5ORxAgkglcF6ifpeaYLAHrUk48PnpKeEqy75KlTGtsXpcX9chgv1GTvkD4eJF6QZCHa4Bnk+fk8EALdNBDbDZm3MMSUPMZFIDvIlm5l9bopjd1cAHJpT6Xm1clWEw+sO+ju609iMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEbR/TU4dfOwbxSAmJe7BU1RHfNXTBnDdOXBg+wT4iY=;
 b=eb8EfIJjRbG5duBdDQnRyO50iMPaK9Pu2+/abF6i9ndpDIpTKz5R97A1jGVIADo9lxv8vy71r0ZLSCJs4MCXvuf35p4ILApn3Qs4CugL0DoWLPk0nkXLSr9vl+s3RdVLoLhDjsOfZiiOa4zSr4wJC9zbmYrdDLPjleLpz8tNuYg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3431.namprd10.prod.outlook.com (2603:10b6:a03:86::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Tue, 25 May
 2021 18:06:09 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::b09d:e36a:4258:d3d0%7]) with mapi id 15.20.4173.020; Tue, 25 May 2021
 18:06:09 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: vhost: multiple worker support
Date:   Tue, 25 May 2021 13:05:51 -0500
Message-Id: <20210525180600.6349-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:5:bc::34) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR13CA0021.namprd13.prod.outlook.com (2603:10b6:5:bc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Tue, 25 May 2021 18:06:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4625d85-72ee-4cba-2f92-08d91fa7c619
X-MS-TrafficTypeDiagnostic: BYAPR10MB3431:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3431671D2BD00B8989BF8C88F1259@BYAPR10MB3431.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NltNexuM6qQ1/GTH1lRShhIWBn0tnE9n1FU7hVS55hOE08WqDa4dT4mH6ViWXxu0PmGmvlOwrBVZy2eoed7SFgr9SwEsTE9gHIfCjVbspJORHRhYEGJDVJXKKaiTa54oqz9Uit5wmqzkk/1QtNDswzoFwbklBNMorOSN54AZ1c0vAyEZ5o8fWfzwVd1T7jlMTi0pnOvSuayH6wFPvLef2k4NI5QkPDgVDEF/HY2rvzsme7X+34EupXZKBc9ElDeNPU6qzqVQCvEYNMAfxB4/d/GePpwnLvnTpRrtvZ9ixd3m5eEQdyt1KzancJeHdgoSBZPcl7kx2RCLSvajwhYgHC2/bQ6S+tyqMNiCrOLhrK25ZvBzli4rEMYtSeSzXNgQ1T5ooHr9eqsYCB7MuzUn0M69+sTUJ9HG7HBPZgYocRjImOUXAA5uaU1OpSYKJgDnVsr6kdDmGe7a/wpwMx9V4DTGQ/cFs254lczFVpbCudHHS46K+nAy8C9n+GDUf4COZsQTPd4HdTvC3upnG9W1QcSTfAUQw0QVehykakSjB8sC3g3tvkcFkidsy7NzOGEFErvZI7Sw42R7hdXgTMJmEox4iHEz8zAWyISQu7Eblf/NN6eyXGMisKcMQrJ2QJN/cCqMbeHKlm5JE1Fh/O6BwTUjxMbjTeala69gPsarPl43+g7L28s67rNQ8xoiSFedcuHPNEhnEFiBq4sIWAxzEkV2SQY4mri9txHzB978+GAtWrSvf/KWIqk/CxJ3YD+B8NGEgKELTS7hy4EUhqV+vUX/9MtNBogUnrGuAYPa9Iw0abLpXdqMhekPI+RLFl6c
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(6512007)(26005)(38350700002)(186003)(66556008)(66476007)(52116002)(2616005)(8936002)(86362001)(6506007)(38100700002)(83380400001)(956004)(66946007)(8676002)(966005)(5660300002)(2906002)(1076003)(6486002)(316002)(16526019)(6666004)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?sj38QGNzYKwbbpQuBnkh8gR6i8xE1gVwqv+AKCleLhBhXb3xV8ZiYXlRLVxq?=
 =?us-ascii?Q?N7UBNl2BUMDmFw5YvvvaeXXy2p2pC0n4UsoBBax7DBHpYXmt89yHk29xidl/?=
 =?us-ascii?Q?WV0iB8e3qXl1yzSVRapXZ9q/tQPXKHH6vUxiPA/lSRzjliT0RCInxUz3TdAP?=
 =?us-ascii?Q?K074/te5DAmv4HpQqfNhIE6d4sn6Xd9eg71kknWlFV7EEvliDhKEUeCTRRPG?=
 =?us-ascii?Q?chuOyGwk+NFY+TBo688nIjapkeG7Npaod1swGq89MNqf4cViognv9hs7lu+u?=
 =?us-ascii?Q?cWsYVdSyptO32AXe2A/544Pu9nhbHtVSX7GCPErul5NM1FVTujMt28ostCF3?=
 =?us-ascii?Q?WP4kVxO2Dh6lv/oG7TIF2e1bNezv4VhI35PWWbPdSpzMkSNmJwEH/QmY9lqP?=
 =?us-ascii?Q?ekD7VLl5Q9JRPLwHWqKlp0LWSfRHTRETiwPMsOXGNpPfZ98OZ37JXIINgBbA?=
 =?us-ascii?Q?25wCiPr0F/C9ymPn38v1htl/hvTyolFIz+bIA+nj2PY7t2BSo0aSJ3lsklI8?=
 =?us-ascii?Q?jusPB5REYVFSFjJtKiWqW/NKooPBAb/YqOhpflnVjpr8VNT5aUdFaZye2fIC?=
 =?us-ascii?Q?SNRfzuuCM6hGAHHGlmBk4hY3s9itMdrwAl57vy6t+ZeW1mfLPHAY2r0s6ZJ+?=
 =?us-ascii?Q?NhG3eKCBA7WKn+ZH8QpjwZQijizQzsARKKf3XM+b1CuH2cB/YhnLyYmF7WS0?=
 =?us-ascii?Q?oXSOCeRieinvuZAxw8TikiSEeeSQvZxUEw07xBGPWo6v8tHtNsYRAoKmAhtH?=
 =?us-ascii?Q?s8yBOl5S4qTFcWcnLSpHjMzkuCBwDAss3+C/484xMwG7nueWW6Wuaal86s/H?=
 =?us-ascii?Q?PMfOxYr+lQ+4tvUhrfUF/+nJVZiQMkIYEKpi0FfM5PDD8l+zvH63uiZZIjzI?=
 =?us-ascii?Q?nNT16KZjJwnriZ4Ygl+WM3xw5r/5d7jz6Kekq26ZWQInvwZE4Pbxx/35IXMN?=
 =?us-ascii?Q?Hq16Q66E0YmG5iLzM2WQkkC/Jhx0lNkGvLeBfDkWT/O30I2qR2CJqYIrWmY0?=
 =?us-ascii?Q?viad87hn9ILCTS199PtCzjGTE9xyZmoGolaUq/0MfpZsThPIL36DgYNGWS2V?=
 =?us-ascii?Q?Uf2da9AXJPIw4jLn7L2XWABpLxsvtlkqS3GTiqNexUXB3rBQyFEwOIBX/93U?=
 =?us-ascii?Q?8bljDqYr12hWNqwC4R9Gde500muyKQukffW6rBpNINZpoi7z0WmAIRhJ8a1G?=
 =?us-ascii?Q?cgy28IYkd7uOQ7FVbUpYTNcvII1ieZqzg8NCZS8kNmdbjezDRCqTkSGhfcbS?=
 =?us-ascii?Q?gpYtkJUCS7BpVg15QTNUlYNjnOkvCwhrRisMPux9LpQ13ccLpa1+mA8vTAwb?=
 =?us-ascii?Q?WWPWGAWHGZIRLoRkaDy88Zp8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4625d85-72ee-4cba-2f92-08d91fa7c619
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2021 18:06:09.5443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aA6Q97pGryhgeioutgtszRgvt2Fg8o40q6xafS8JkvO+ERHEvZhfrX17SkQ08+3AXpm6FMV/gugDaxUvqe/78U44ACxh3AKv0wKbR3WH5Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3431
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
X-Proofpoint-GUID: gwocdz04CyIYnozkLq5x7G6Fvfjs-sJW
X-Proofpoint-ORIG-GUID: gwocdz04CyIYnozkLq5x7G6Fvfjs-sJW
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105250111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches apply over linus's tree or mst's vhost branch
and my cleanup patchset:

https://lists.linuxfoundation.org/pipermail/virtualization/2021-May/054354.html

These patches allow us to support multiple vhost workers per device. I
ended up just doing Stefan's original idea where userspace has the
kernel create a worker and we pass back the pid. This has the benefit
over the workqueue and userspace thread approach where we only have
one'ish code path in the kernel during setup to detect old tools. The
main IO paths and device/vq setup/teardown paths all use common code.

The kernel patches here allow us to then do N workers device and also
share workers across devices.

I've also included a patch for qemu so you can get an idea of how it
works. If we are ok with the kernel code then I'll break that up into
a patchset and send to qemu-devel.

Results:
--------
When running with the null_blk driver and vhost-scsi I can get 1.2
million IOPs by just running a simple

fio --filename=/dev/sda --direct=1 --rw=randrw --bs=4k --ioengine=libaio
--iodepth=128  --numjobs=8 --time_based --group_reporting --name=iops
--runtime=60 --eta-newline=1

The VM has 8 vCPUs and sda has 8 virtqueues and we can do a total of
1024 cmds per devices. To get 1.2 million IOPs I did have to tune and
ran the virsh emulatorpin command so the vhost threads were running
on different CPUs than the VM. If the vhost threads share CPUs then I
get around 800K.

For a more real device that are also CPU hogs like iscsi, I can still
get 1 million IOPs using 1 dm-multipath device over 8 iscsi paths
(natively it gets 1.1 million IOPs).

Results/TODO Note:

- I ported the vdpa sim code to support multiple workers and as-is now
it made perf much worse. If I increase vdpa_sim_blk's num queues to 4-8
I get 700K IOPs with the fio command above. However with the multiple
worker support it drops to 400K. The problem is the vdpa_sim lock
and the iommu_lock. If I hack (like comment out locks or not worry about
data corruption or crashes) then I can get around 1.2M - 1.6M IOPs with
8 queues and fio command above.

So these patches could help other drivers, but it will just take more
work to remove those types of locks. I was hoping the 2 items could be
done indepentently since it helps vhost-scsi immediately.


TODO:
- Stefano has 2 questions about security issues passing the pid back
to userspace and if we should do a feature bit. We are waiting to hear
back from the list.

v2:
- change loop that we take a refcount to the worker in
- replaced pid == -1 with define.
- fixed tabbing/spacing coding style issue
- use hash instead of list to lookup workers.
- I dropped the patch that added an ioctl cmd to get a vq's worker's
pid. I saw we might do a generic netlink interface instead.



