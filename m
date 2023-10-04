Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7E8E7C4E8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 18:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243973AbjJDSMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 14:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243762AbjJDSMt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 14:12:49 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F5FF9;
        Wed,  4 Oct 2023 11:12:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CD5C433C7;
        Wed,  4 Oct 2023 18:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1696443163;
        bh=aHB26Dn9xFMRPa1pgn+27Z4IjU2PMvONyU6bWXS03Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBxF066fmZEBZhjq4RpXH41RgpwJFYooSIHh7T9thDRurrFzdhIqcBP/wtFhUiDiv
         U63C+Y5OEfCwPyoBw8HIewKyDxNAUdd6yts7n3kRfP5RcSFgXIMiZUu0F6jzPAoSY3
         X4rHFMOyZ5HRuiIftgn2o2OOMs5a6N7/3WWKR6/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/259] scsi: iscsi_tcp: restrict to TCP sockets
Date:   Wed,  4 Oct 2023 19:53:51 +0200
Message-ID: <20231004175220.090852970@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f4f82c52a0ead5ab363d207d06f81b967d09ffb8 ]

Nothing prevents iscsi_sw_tcp_conn_bind() to receive file descriptor
pointing to non TCP socket (af_unix for example).

Return -EINVAL if this is attempted, instead of crashing the kernel.

Fixes: 7ba247138907 ("[SCSI] open-iscsi/linux-iscsi-5 Initiator: Initiator code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Lee Duncan <lduncan@suse.com>
Cc: Chris Leech <cleech@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/iscsi_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 8009eab3b7bee..56ade46309707 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -724,6 +724,10 @@ iscsi_sw_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		return -EEXIST;
 	}
 
+	err = -EINVAL;
+	if (!sk_is_tcp(sock->sk))
+		goto free_socket;
+
 	err = iscsi_conn_bind(cls_session, cls_conn, is_leading);
 	if (err)
 		goto free_socket;
-- 
2.40.1



