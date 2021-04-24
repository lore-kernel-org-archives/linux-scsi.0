Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD465C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E3D61462
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 22:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbhDXWS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 18:18:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57172 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhDXWSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Apr 2021 18:18:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMGBO0140004;
        Sat, 24 Apr 2021 22:18:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=hjOKuNxKLfC6eIVQ3dg5rcZnUJEGYOWBXn1V56i3T5Q=;
 b=DmhRf3GES/uFGENFZf3T83S0re2pp4EnCUBoHV7Bcjd8tUKkIAp+uD5O7eHvvE5YkIVQ
 h/J6pwN1lNCHmqUrtWsH170xWze0gu8O8rCqgq2cyQJJhLfxSj48FifCbP6G52kmTr/M
 SHe6AuK0/0+IPB5Npw4v7oKEvTJYHx+W/Lk/AO5encLQ052CeoXPrD7s9g7yavSnZvuw
 oC6kp/rsTMRBFHr3Wmw3IipYeOYtz5dSEd86dOhxwc9WnS7hGgacxTlKz4FLUt0UrjC1
 mRRgGJbEPfrwOwnSxYQX83Q+586EVE6FaVXaKQxgL94fWose16gYzIhLqD5qWxPyDEro yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 384b9n0snq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13OMAPi7148236;
        Sat, 24 Apr 2021 22:18:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by userp3030.oracle.com with ESMTP id 3848et2ejm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Apr 2021 22:18:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TM94CnAd8hQpWyB5iu93LYStfPscf2hcXkvtFLMz83PQ6+Vi1m2YBo2tOQyEGhIEO0b1HcdeD6AZ/XnSd0ZTQ+UE9/zAzpLIX5MTKaklw5Ckhs2rm96SeWfVtBU3oOJVQuTL30dSz8g9rKkCC2/2yb77UNYO1+rUud1/w7LkYwtcvj3fVIIaFQDkx9xZE3isUZxCFae6+m+dJVR2YYuaZojHf/Y7iZimSq1bn0mnbQeuSV0vhkp1kZCIJOKCOaVvXRA0KllKZC5m3F1Raoqf2ygeGjH3zyX5j3HY8aVjZxThKRwH41qd4icR7ljJZFhvqwrO0VRCgREQMBAnJHPrrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjOKuNxKLfC6eIVQ3dg5rcZnUJEGYOWBXn1V56i3T5Q=;
 b=GqHTgfKLv8cQtQQe94JVhc44FbZHOw8xt2WGtQzoecwcwdBdkOWMT4AAZEAKEulXrRos0xFF8WRI76n5QI72GpBblkVTtiut7AustpHYNaNi0f7Kn/HY3YRnfHEddKDUG9e62mTnUC5DRCyNk7MqIwTuUySKSHhnJH4QnS91zGOY5D28iA1Z7JRmLUsznPY6jWyjw3QbGGhZCqYrmfpy8V2QAKw7zuAyRv3cHp2C1BpjboDLSMgusEa39uzZRmsM/7W5tz+HoQBKD4R8rq8R8XMuqutoKSOl07mf+pi3MYawHOfl48N/xIbNFzZX01DGMzWoy2a43SM8jfsCBROVZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hjOKuNxKLfC6eIVQ3dg5rcZnUJEGYOWBXn1V56i3T5Q=;
 b=hRnKasAuBinCJkI9dOvG7W6cfSOIkF0mz/OP9Al3gXodjLRo7bMG3H7AfTaZqmB34ZPm6TGSaxUqWqNeaoSfRDXhU1qTlQVvhuSvQcSbEiai+0IDmUQyil0pid13yB0umixh7mKFc0CAbWywP8BuYr16jWf1n5b660/VMJuZTY4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2885.namprd10.prod.outlook.com (2603:10b6:a03:82::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Sat, 24 Apr
 2021 22:18:03 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4065.021; Sat, 24 Apr 2021
 22:18:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     khazhy@google.com, lduncan@suse.com, martin.petersen@oracle.com,
        rbharath@google.com, krisman@collabora.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH v3 0/6] iscsi: Fix in kernel conn failure handling
Date:   Sat, 24 Apr 2021 17:17:49 -0500
Message-Id: <20210424221755.124438-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:0:57::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM3PR12CA0079.namprd12.prod.outlook.com (2603:10b6:0:57::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 22:18:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 595eafbb-2567-4f91-791a-08d9076ed3cd
X-MS-TrafficTypeDiagnostic: BYAPR10MB2885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2885811B38CF7E70121B1993F1449@BYAPR10MB2885.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2MC8KL5l8is7tq5mUebv1Q+r13gHK1m/PuwwQIL1yucDN0tC0HomVMeCbBesOKGvx6nqpHRJRdK8M23EASUNbEM3cjYXQcyJH3DIdo2k9gjGVaM0Xk6X9tr+Df1T+fmxSqVfUJZEhI0ryoXbQzFFDeV9FXsOg6aWi3iGvmXMBuC3xmrtFezL0PurZECrtMywAphiHgX1uoJ8bNQWwTC78eD8PkWeuAORYEb9KzZHUkyWYBYoZJ+75Oyeb3qprevJZBQYsDC9qswJyBXS/7IGFMKdldGtUFfYPWbKSwIxOKXZotPhhkZdra3VKTZckK6DndPk0dQfYcGG3JpYHzDGhg9Elnsl8R+2B4LTQVhJDNr6plKO73zyFMvwf+of3g4sGDZzgQNaMolTakPeBSkntcPAY7XlmVNR4tE3QTl+BjfNUQvMI1ZYbq5BTL3c35P+AHjlgAkTQrpPsEa76Na5p99sdBpK3eYf1R78KfIfZReUpd08hlapa+AoVI536kaBNEudaV0ci09mjwVOeFZxn9QLnBsO2m5GopHx5//w4FOKKG5niaTiYK57qoxzvN2mCC5FV+QFfDaWKnKeUBAsRlUyh6CoSfP4mh3zF+ND3/mjOEy/VabLaEaEQ2oiFABZU6LaqdJGX9M8QbuBBPrvTPoAFs3B83cm52wKj8BO1aXnhfBErgLnq+oyFxanNeSF0ac8pTK9+5FxAR8oMbeemtAWyNUmpTrlJC5Cgt+JeExDDEYWNQhvsQwNHQEVWuVCZCVp2P4NasV7Gob1ZJ5YQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(376002)(396003)(366004)(83380400001)(6486002)(66946007)(66556008)(5660300002)(66476007)(38100700002)(966005)(6666004)(6506007)(478600001)(6512007)(2616005)(186003)(316002)(36756003)(52116002)(26005)(86362001)(2906002)(1076003)(956004)(8936002)(8676002)(16526019)(38350700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ikLOHZlsHO/ZK999rxRkxbqI2JqibDTufoIFfuJCOmrezdmdY7EJSGOBuG7I?=
 =?us-ascii?Q?Rnrt9/QegN5egWBM3pWHaVWEcanxMb4xNzNMKfm2fHNOypmBeK0pQNsSOBZZ?=
 =?us-ascii?Q?DxZIu+877Co9EZxsQmwa/yMHscP4siX7C1NyZ/ELWs3EDLv3kZJRWmD1/X+E?=
 =?us-ascii?Q?O1NfXrTpSbG973Yyy7f6RWo6r5kpiobSW39Jo4IkMbCKHq0UiVYy/Y/8rgv7?=
 =?us-ascii?Q?QI63wOb9R6/OY4Ga1kTQypb51mofuyoGIGq8nkIGpjgMdyBXML4S5UHV/N+W?=
 =?us-ascii?Q?ctSleSrXXLq3kJ4WYlwQthJJd2Tx9a3qmImJFls4TbDwOYsh46v7gyPopm+r?=
 =?us-ascii?Q?vdWJDYAjt3b46uwtNZC65Abijuh1Lei0cU1fXx3Vu8OvhRpLFM4taCTN0gia?=
 =?us-ascii?Q?s3hFNXAbalM//UnpvvyNQPyBZ4HsRzxk3lpHimSb9tY8X9Iv0HD/jgBkdvz7?=
 =?us-ascii?Q?g7gacD42Bfch/3L71lwkawh2WaNUGwYTmE4f5s8TZouMlY6SJoOylNA63etC?=
 =?us-ascii?Q?jmWjiNu/0AdF7kr/pUkuEOeJWwfYgY7o8NpTJgNVrnsz3S9NGM3k3N39TZ7s?=
 =?us-ascii?Q?UlNsIoJnVZMmOrcTozO/MKJWUvCMrsQlnQx8cnkaLAj9/Mz6oGMLh83BaDtW?=
 =?us-ascii?Q?0y1xl9hklz2hNqu8K2CEI5G/mxRYJbhcaF2cM4J2pA5AjmwaR7IgL3Wi6f94?=
 =?us-ascii?Q?H3WVj6YFAeLP5vDQBZoAaglCKDduvjaMELfU7u+eI20SbZjJVNsLHMDsw+Hb?=
 =?us-ascii?Q?GL67B85NQjk0PJ12Vf82jBApSDHoZJhuF2QsCWfTs2fwobGSlcuSJ75XGjdg?=
 =?us-ascii?Q?gRMflt/BkHBmE0aU7bcgZ5j+UJxuYOlbA7QBDu/J5meWIuDE4BiWl/gwSx7y?=
 =?us-ascii?Q?vcZqchWfLSX4bLG+WHXvt0pnXrxN43eXkEI8K7jteoY8CmJSv6fjVEvg/SbV?=
 =?us-ascii?Q?9kbsb51s/gvvHFtJrIGDTBckeuDtKrvaagH/N5zXs8WEWG0uPLIENKHW4+1w?=
 =?us-ascii?Q?yx1NT5g1linoEbGkLdRr5MmWUam6QAxzvJrRgdFG+vNnwK7l+3cobnYwBvm7?=
 =?us-ascii?Q?NvLrnOUA2tQQIOqqKa9Kli/uxQDRb2tOOjudTcXVwn6sxfpd8VT9pe9l7Rey?=
 =?us-ascii?Q?FJX7PLCxAUDpioaFle6wHDYlQFw3Pe9P9K5WOvAN6BbPdkFbWNYswhx/bfdx?=
 =?us-ascii?Q?bIkjvYzh/f7umc9GODVZe+Lb+Xe1AQqi4oeOyKmyvrwJF/PQ5FQ/dSBXaQnm?=
 =?us-ascii?Q?yxOal7qei82DHqnHNR/iJBD9Rynt2uNjGb/Y30dF2l8P52rulQr79RpN2lBw?=
 =?us-ascii?Q?i+MdXsu/sUhlITJ360NHSAgh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595eafbb-2567-4f91-791a-08d9076ed3cd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 22:18:03.2980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dNy22eisCdRFhXIwwk890ohsps3vgv1gfwr1WYFUH63laC09sOkrQ2jsAenyLbzEQe8COEVS3oi5mNC3wnbLLTI/J+whOZItSjvbk2goXZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2885
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
X-Proofpoint-ORIG-GUID: iPtf8-TtNyh3wBRb4KbJIDMv-vbW84x2
X-Proofpoint-GUID: iPtf8-TtNyh3wBRb4KbJIDMv-vbW84x2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9964 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104240169
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are made over the qedi/libiscsi TMF fixes:

https://lore.kernel.org/linux-scsi/20210424220603.123703-1-michael.christie@oracle.com/T/#t

The patch 0ab710458da1 ("scsi: iscsi: Perform connection failure entirely
in kernel space") has the following regressions or bugs that this patch
set fixes.

1. It can return cmds to upper layers like dm-multipath where that can
retry them. After they are successful the fs/app can send new IO to the
same sectors, but we've left the cmds running in FW or in the net layer.
We need to be calling ep_disconnect.

2. The drivers that implement ep_disconnect expect that it's called
before conn_stop. Besides crashes, if the cleanup_task callout is called
before ep_disconnect it might free up driver/card resources for session1
then they could be allocated for session2. But because the driver's
ep_disconnect is not called it has not cleaned up the firmware so the
card is still using the resources for the original cmd.

3. The system shutdown case does not work for the eh path. Passing
stop_conn STOP_CONN_TERM will never block the session and start the
recovery timer, because for that flag userspace will do the unbind
and destroy events which would remove the devices and wake up and kill
the eh. We should be using STOP_CONN_RECOVER.

4. The stop_conn_work_fn can run after userspace has done it's
recovery and we are happily using the session. We will then end up
with various bugs depending on what is going on at the time.

We may also run stop_conn_work_fn late after userspace has called
stop_conn and ep_disconnect and is now going to call start/bind
conn. If stop_conn_work_fn runs after bind but before start,
we would leave the conn in a unbound but sort of started state where
IO might be allowed even though the drivers have been set in a state
where they no longer expect IO.

5. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.


V3:
- Rebase over
https://lore.kernel.org/linux-scsi/20210424220603.123703-1-michael.christie@oracle.com/T/#t
- Add fix for if we are doing offload boot and hit a conn failure at the
same time userspace is syncing up it's state and doing a relogin.
- Drop RFC as google has tested.

V2:
- Handle second part of #4 above and fix missing locking
- Include iscsi_tcp kernel sock shutdown patch


