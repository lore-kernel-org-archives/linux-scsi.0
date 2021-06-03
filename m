Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75738C47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 22:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BCEC613E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 22:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFCW0x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:26:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53257 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhFCW0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 18:26:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lovly-00033Z-H7; Thu, 03 Jun 2021 22:25:06 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Lee Duncan <lduncan@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: scsi: iscsi: Drop suspend calls from ep_disconnect
Message-ID: <c429f1a3-348d-2cc4-7652-68ea4a63067e@canonical.com>
Date:   Thu, 3 Jun 2021 23:25:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Static analysis on linux-next with Coverity has found an issue in
drivers/scsi/qedi/qedi_iscsi.c with the following commit:

commit 27e986289e739d08c1a4861cc3d3ec9b3a60845e
Author: Mike Christie <michael.christie@oracle.com>
Date:   Tue May 25 13:17:56 2021 -0500

    scsi: iscsi: Drop suspend calls from ep_disconnect

The analysis is as follows:

1662 void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
1663 {
1664        struct iscsi_session *session = cls_sess->dd_data;
1665        struct iscsi_conn *conn = session->leadconn;

    deref_ptr: Directly dereferencing pointer conn.

1666        struct qedi_conn *qedi_conn = conn->dd_data;
1667
1668        if (iscsi_is_session_online(cls_sess)) {
   Dereference before null check (REVERSE_INULL)
   check_after_deref: Null-checking conn suggests that it may be null,
but it has already been dereferenced on all paths leading to the check.

1669                if (conn)
1670                        iscsi_suspend_queue(conn);
1671                qedi_ep_disconnect(qedi_conn->iscsi_ep);
1672        }

Pointer conn is being checked to see if it is null, but earlier it has
been dereferenced on the assignment of qedi_conn.  So either conn will
be null at some point and a null ptr dereference occurs when qedi_conn
is assigned, or conn can never be null and the conn null check is
redundant and can be removed.

Colin
