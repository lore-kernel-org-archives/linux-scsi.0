Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DB6C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCB0561007
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 07:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235095AbhDKH4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 03:56:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57048 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235084AbhDKH4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 03:56:32 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7nv6I096561;
        Sun, 11 Apr 2021 07:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=yKxeqEbmsvYGJ92ZzjyCv65HY11giQQfSPQfbx8Ttxk=;
 b=gEUONCrj5OHzx5hQr25xnRYcMC0jxdLsHWb3a8+Vx6laa6r+YCKiJ+6N52Zb5i0DHL5/
 fs1RxxUJJAjxqvng2lLxxszM6XhMhl2yelAEDUBZyJFx8MoiQsNFos5O70c2c1pb9Syo
 b6robiaCr16UXWgxiZLVZn4oTx+DddmD3uu1sExc4uq7ZOufRrdZVVSbu/tOh7qO3/Xu
 7pZjp/baMPoTr7OB2ckTrBdZRIh72EVeHd7hcw8sHFbbgYKRGdeacjb1FeCKc5UReGaA
 c6pDAvdlOubS671ijnYV5JvNqT64qv4xcY1b49u4EgUrXFmrshmWI7YBT4jWWHC2ypEl uA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37u1hb9dev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13B7tXbL017877;
        Sun, 11 Apr 2021 07:55:56 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2049.outbound.protection.outlook.com [104.47.73.49])
        by aserp3020.oracle.com with ESMTP id 37unww7qm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 11 Apr 2021 07:55:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K02Jeb0Rz7wl+sOvd26XWidSszuHeXC+2TUipS0wSIOrrgRiK4foCKGZbBqGmBINSj+7nC9kwEjH9+sNeVmOVv4e72SbAiO/KwFbVRDIHKe9U+ahuBZ8ReiJVmVnEMAJAL4wcUN+d0ryyRDfVVu4jenrfDM4vZ6X1hqMcIPOUIchIuJBesT8C+ZXd7FlYbqU1HQ9Kvd9QStMw9lkUTcSCKGrUS+dQNyQd0VNz7tn8I3sSKdXVTOYQiqTuWsPLllE+jb+xQ/o9LtOJYjrul7ZzA8GhPzG4Xus40NAPMHXsepVb7HNINnWsAo028vRK0Tc2+zyf5vp1mbYIC9GY4TReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKxeqEbmsvYGJ92ZzjyCv65HY11giQQfSPQfbx8Ttxk=;
 b=S+9fCd3FSAqEYxdku8cNrX6FmyGS71wEPXdGDIuFQ5nGgrh9sxrwZ4rFmiZVTFDm+5cul0mtf4UMhLqYCCgUG4r7p7Wk3sCt3iA1uQrtCxWQVxlzTSuYM/vKbBK0Y68vT8GL8ZQF0QH6O17w63A7Er3f+Vdw8/iRStzntPrh3eXEss4jcTJc1xl9oYRf6jqbl8sPYvym6Kzd2cbS/pP8y053h0DDin5pchYaV6dNySEKEVs9pqfQJIbbLaKinucxxlhUYcCzSADr7BOFaYSVr7Bz1dp1xa0BiGs2/6+qtPQuUe0mEQ/Yl2HndOeS9FR9um1kTw6DBFtDTt8FZURXmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKxeqEbmsvYGJ92ZzjyCv65HY11giQQfSPQfbx8Ttxk=;
 b=YN2mZfydPvlXZ6CWNGGreN0+xzGgqliwsfmsSawOFGaAcBONN5nRQnGmRMV7JCu5Sv6PIJrwG8BvaNOLeijVxecoOLf5MKvn0A4nzfWD2bf01GZIYSD5u6I6IcQaqGkEnk08EYSk8uZhhutl+wmzk+V+kMtuVUaCk4Gy2rLXClU=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB3842.namprd10.prod.outlook.com (2603:10b6:a03:1f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Sun, 11 Apr
 2021 07:55:54 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4020.018; Sun, 11 Apr 2021
 07:55:53 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [RFC 0/7] iscsi: Fix in kernel conn failure handling
Date:   Sun, 11 Apr 2021 02:55:38 -0500
Message-Id: <20210411075545.27866-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:5:15b::23) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (73.88.28.6) by DM6PR18CA0010.namprd18.prod.outlook.com (2603:10b6:5:15b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Sun, 11 Apr 2021 07:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1afbcf3-4645-4420-b70e-08d8fcbf3b23
X-MS-TrafficTypeDiagnostic: BY5PR10MB3842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB3842096B5D9A838D626F4104F1719@BY5PR10MB3842.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5dpG4c7jvk3uC6vl3adIiut2FXBEtd1XcNBMUErQQJsRGRw3lIahbftw2c1TvSqXXwrkLxtfWpxPufv+xpcfsdaJxg4OXWMQnqgyFGZOldpgBM5gBX6xDeG6+w0UaIXoKrHzfEX5jRoGY9wqPqpvSIFka30xI1Vvl6R8QDwgGFpd4GDfAIqCJQpZjfUfGIDbKRFpHRS0Tv25oFmuKM9Ki1PtACxtSFK5SH/b41ZWuzjrJAuHgkiiZu7na2rHcsl3N5rOf8RnF6Bp1kGjCX9yKeocEEENAAteYRF5sbY9/3nBmyf7LP9i+peJILXsloBJ8RAsrSPeuXTdEHJ2u/+HRJC0SyRfkFmatb0qXbU3a+LP+iEg2qiXNtf+wMSRiE+udZ9PvzZShoe7Kf5apyNVGGYooEMlvp8QDwyF8/cIVUjUNfpOVv+c1I52pymR2SBVsBt3RxrNLYFkNX6rY0dYg+Xs4+XkFRMTR0RTLZmnMNIRk/jMvkyn/72IZOi94i/0teJe1dZVtFHNz8pjcjS34GvOJ4UoC2cn3VssURriZl9wvZlJZhtf42rp843pJ3/mcstEMtkzUbjFrC69nMqd2uxnqIvFZ/bU3FhjiLDd0krNm4LQ1s7/SkR5rNV15/kfbN8hGogXruLmh6PivKMhQtaLhoQ7LVKVE9ZQi6GlSVrQz41q52Xm8fTT3paLNi+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(16526019)(6486002)(316002)(66476007)(6506007)(956004)(2906002)(8676002)(2616005)(26005)(5660300002)(6666004)(86362001)(38350700002)(52116002)(38100700002)(69590400012)(186003)(66946007)(1076003)(83380400001)(36756003)(6512007)(478600001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LejD+cZQJQa7J6qpWZ66qAq5kaKdDNuBlajv1owaFjX6eCdckY7CklIbJHm6?=
 =?us-ascii?Q?UQGr+a6vHeG64iRb1uulXRDl6S9+TfGUnxf4aUKGrDuwQciwtYoMgsPRUjo8?=
 =?us-ascii?Q?geP3vx+fGQ+6K64TqIwL+SyI9r8gyHaS/yEnLTUG3Sn3hhlZ5MxYn3eoSZYX?=
 =?us-ascii?Q?CYXqge+ErMMqzZw0AfdUYoyE27yHHqWtoiTyjn4xK54NMHMSQiRLN8G9A7iB?=
 =?us-ascii?Q?/AjiFgf6xmjD7NYlck5sxSCLUi3O6Z7OYjMG8UPke2x/XGQYweQBQRkU9oCU?=
 =?us-ascii?Q?5HkvZPwv8Zkz61S22KlLcPqIxVI2b/N5uMfZMySzh7xikKzRWqqn7KPRLLJa?=
 =?us-ascii?Q?1+cns+J/QBdzsn/qxWCi+Xc7iiYHTO31UZodB4ThFK7o74wnMviJHfm9qMDq?=
 =?us-ascii?Q?Gv+TM23TxsVz2NA+3D9V0xvfJm08DU56oM54dUlCLyyiohYVN5xR3GOFt1oV?=
 =?us-ascii?Q?yDKEa4HoYk2G7QNjROGlGnNVMcP1U1f7VLyvr7DVyIF+jbWcWFQcnSKc4JH7?=
 =?us-ascii?Q?Q3WyHxoX65qewf1N34DQmVEYSCj2XZAtrIP9Hptfz9cJymA2qs2D9M2md257?=
 =?us-ascii?Q?lY7hxLKJTf46W+2At1yKKYoclw0yb6+QmYO817eOaKi4MWiExTDsqaQjZh8/?=
 =?us-ascii?Q?Vn2dwRs9/SnGHgU64vckYLJuXj6lOJJSmGqdyc67HzrTfTf+KuPaMUTX82d+?=
 =?us-ascii?Q?2LHxT7TlXDietNu3DTckaAZHhF39U3/ifebph45iKhnLNFnewq8x3ISM0uxW?=
 =?us-ascii?Q?RjM+KdFCqcT5x7LS4ZlcYsyDgTP4OHYeLVYCCfk2wopFnNfp51jHKjZP6m3J?=
 =?us-ascii?Q?aBJ8r46x45iDsUMeSlqkdx1eGDUfsNZ2yMMhBb74jQIF3NKC7ZwVCHDVsS81?=
 =?us-ascii?Q?mIalF+k1DpUCB3K+aQz12YhQpQGb2XrjpjPs5s0AZxy6J6YY2cRVRCJzkY/2?=
 =?us-ascii?Q?kV51d0NQcEA5a/4tuZ9Ry+/Zrfu/EALmKIWRMUv6hvZvrh3OYkrdmZT2+Oc2?=
 =?us-ascii?Q?dpxLxwYOHks3DZjbfiNsXMjAgqi+GKxFSUyjapndSRL9MjPxYTbUYZ7J0d7A?=
 =?us-ascii?Q?38OnL+hWjOsLl/jtE70QF3yNwNj2+1fS1VmjCg0XkVhcakCD5+Jkc2l5+wUG?=
 =?us-ascii?Q?NsRoiXGySNV/VbyrsxbQ9EvY1eJKGga4EsJav8Ksl31qihq7f9fJ5YKnAJLk?=
 =?us-ascii?Q?LhrY88tWGH/0OM2OZueF4lEwR2FkQaCYa0nqJrRGks81wDbfYaELFjIa2pAg?=
 =?us-ascii?Q?xU8G4ul6a6GmjGRvi/pUdSlpO0WRj9OJIqRNUVmZB7RSyjh/RFEw/r6P3POg?=
 =?us-ascii?Q?lFSZtMFqs25eebdb1QKJ22O9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1afbcf3-4645-4420-b70e-08d8fcbf3b23
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 07:55:53.5853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pE49nUeqlAvn4L7Oj0dICTTiSWGiHyiiroWO/8RAXW+1CFY/vAL72D72TdIuN4OYFZCp1udFjMP1HVYAnOiG1aEvgaaV7MNOYU5ZkqaSsBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3842
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104110060
X-Proofpoint-GUID: gbGS-iBG1pG1q51ZYYW75s3-GlnJd7sh
X-Proofpoint-ORIG-GUID: gbGS-iBG1pG1q51ZYYW75s3-GlnJd7sh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9950 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1011 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104110059
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

When we add ep_disconnect we need to make sure they only exec once
and exec in order.

5. returning -EAGAIN in iscsi_if_destroy_conn if we haven't yet run
the in kernel stop_conn function is breaking userspace. We should have
been doing this for the caller.

The patchset should also maintain support for the fix in 7e7cd796f277
("scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim").
I'm not 100% sure about that though. This patchset allows us to do
max_active conn cleanups in parallel (256 default and up to 512). We
used to only do 1 at a time. I'm not sure if this will allow us to hit
the issue described in that patch more easily or it will be better
because we have a higher chance of cleaning up commands that can be
failed over to another path and free up dirty memory.

I'm still testing the patches, but wanted to get some feedback from
the google and collabora devs that made the original patches.



