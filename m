Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D12C433ED
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 00:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6172D611B0
	for <linux-scsi@archiver.kernel.org>; Sat,  3 Apr 2021 00:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhDCAec (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 20:34:32 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:36658 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234821AbhDCAeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 20:34:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1394E1280398;
        Fri,  2 Apr 2021 17:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1617410070;
        bh=rlNH0yVuAuGR2mrl4bZ9TjpwdheZ+lwL1j7b+0NZA3k=;
        h=Message-ID:Subject:From:To:Date:From;
        b=oFu7+dVfijfxPVLY+ziFCPwtVfS/UPyX+z0eaCHlwLgDUbSG9gtnyw01Q5AzILUHQ
         QoJTkto7EKS4vUFe3kGON+rsHyA08Y8awU6gKgizF06871zEY4sABUGiw2VjbdU7Ar
         M4oaFf1snCcY3fv+WWVQydPa4Hb6nQVl2VuwCTzM=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id R9DrTCxj4oc2; Fri,  2 Apr 2021 17:34:30 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id ABDC91280397;
        Fri,  2 Apr 2021 17:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1617410069;
        bh=rlNH0yVuAuGR2mrl4bZ9TjpwdheZ+lwL1j7b+0NZA3k=;
        h=Message-ID:Subject:From:To:Date:From;
        b=FKH8AKacgBWAV7/1CKc3eCOtL2eS4GNJ7FddLLndLdTwHblUQxr+GT9bP198uHwag
         yszAs9WbCSyOSUQMdxm4z4/81GbEfRVlxOrZKwGOIrFA/DnIz9M13rWf1YptdiQOEM
         yzaSfUSuHSuztbFrKzun3kPt3mEgn8WRopYWM4so=
Message-ID: <9aa8b614478d74ee0cb37dec9e20270c94d7f7c4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.12-rc
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 02 Apr 2021 17:34:28 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Single fix to iscsi for a rare race condition which can cause a kernel
panic.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Gulam Mohamed (1):
      scsi: iscsi: Fix race condition between login and sync thread

And the diffstat:

 drivers/scsi/scsi_transport_iscsi.c | 14 +++++++++++++-
 include/scsi/scsi_transport_iscsi.h |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 969d24d580e2..bebfb355abdf 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2471,6 +2471,7 @@ static void iscsi_if_stop_conn(struct iscsi_cls_conn *conn, int flag)
 	 */
 	mutex_lock(&conn_mutex);
 	conn->transport->stop_conn(conn, flag);
+	conn->state = ISCSI_CONN_DOWN;
 	mutex_unlock(&conn_mutex);
 
 }
@@ -2894,6 +2895,13 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
 					   data, ev->u.set_param.len);
+		if ((conn->state == ISCSI_CONN_BOUND) ||
+			(conn->state == ISCSI_CONN_UP)) {
+			err = transport->set_param(conn, ev->u.set_param.param,
+					data, ev->u.set_param.len);
+		} else {
+			return -ENOTCONN;
+		}
 	}
 
 	return err;
@@ -2953,6 +2961,7 @@ static int iscsi_if_ep_disconnect(struct iscsi_transport *transport,
 		mutex_lock(&conn->ep_mutex);
 		conn->ep = NULL;
 		mutex_unlock(&conn->ep_mutex);
+		conn->state = ISCSI_CONN_DOWN;
 	}
 
 	transport->ep_disconnect(ep);
@@ -3713,6 +3722,8 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 		ev->r.retcode =	transport->bind_conn(session, conn,
 						ev->u.b_conn.transport_eph,
 						ev->u.b_conn.is_leading);
+		if (!ev->r.retcode)
+			conn->state = ISCSI_CONN_BOUND;
 		mutex_unlock(&conn_mutex);
 
 		if (ev->r.retcode || !transport->ep_connect)
@@ -3944,7 +3955,8 @@ iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
 static const char *const connection_state_names[] = {
 	[ISCSI_CONN_UP] = "up",
 	[ISCSI_CONN_DOWN] = "down",
-	[ISCSI_CONN_FAILED] = "failed"
+	[ISCSI_CONN_FAILED] = "failed",
+	[ISCSI_CONN_BOUND] = "bound"
 };
 
 static ssize_t show_conn_state(struct device *dev,
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8a26a2ffa952..fc5a39839b4b 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -193,6 +193,7 @@ enum iscsi_connection_state {
 	ISCSI_CONN_UP = 0,
 	ISCSI_CONN_DOWN,
 	ISCSI_CONN_FAILED,
+	ISCSI_CONN_BOUND,
 };
 
 struct iscsi_cls_conn {

