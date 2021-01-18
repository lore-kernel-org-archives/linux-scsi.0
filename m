Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13314C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B12207C4
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394333AbhARUmT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:42:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38060 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437942AbhARUlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:41:10 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKdajE115903;
        Mon, 18 Jan 2021 20:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=U3FQH8ZHkbiS8ocDTrfmXg40L6zO5AbRj3cIYu5ACdw=;
 b=WUXZ3LDgn8VDXpNorf5OiY8cUlY4Yvh/+NGhM/NeMQ9KkV4nN853SQkgpohd6+kzD3hG
 /KaP6+kzDq7mxQrae1MtXRN7wjtRmnwHPsaDDFI+cCXqGUJqr8A5vyv/aC/kRXNYC+Im
 R+KulecHTiFtvkS16iZOdhqP15awUWgqfIcwLkmhSgSVPv2kMOcrL09nAQXz7CehFAy5
 cQhkQZek6dbiGPXMUWkzWY+ubV/Zb+EtAz6nqi3jgWjXJrP9AN9WZCjlnDZRAn9ZxcrL
 tncmtKAw8oDM+8CPE2l3bswv7CYTnj5+IVTm2+4LGJ09Y3SP2c/Kf7I8OoyehOKGpxya FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 363nnaer6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:40:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKbrCI072057;
        Mon, 18 Jan 2021 20:38:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3649wqetdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:38:10 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10IKYfoR021780;
        Mon, 18 Jan 2021 20:34:43 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:40 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 0/7] iscsi fixes/cleanups
Date:   Mon, 18 Jan 2021 14:34:23 -0600
Message-Id: <20210118203430.4921-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches were made over Martin's 5.12 branches because they are
mostly fixes, but there's also one cleanup that one of the fixes is
built on top, so it's probably more appropriate for 5.12 since its
later in the cycle.


V4:
- Add patch:
[PATCH 4/7] libiscsi: fix iscsi host workq destruction
to fix an issue where the user might only call iscsi_host_alloc then
iscsi_host_free and that was leaving the iscsi workqueue running.
- Add check for if a driver were to set can_queue to ISCSI_MGMT_CMDS_MAX
or less.
V3:
- Add some patches for issues found while testing.
	- session queue depth was stuck at 128
	- cmd window could not be detected when session was relogged in.
- Patch "libiscsi: drop taskqueuelock" had a bug where we did not
disable bhs and during xmit thread suspension leaked the current task.
V2:
- Take back_lock when looping over running cmds in iscsi_eh_cmd_timed_out
in case those complete while we are accessing them.


