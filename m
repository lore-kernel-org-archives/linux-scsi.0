From: Minh Tran <minhduc.tran@avagotech.com>
Subject: problem: connection teardown is always blocked because host is busy doing work on other connections
Date: Thu, 18 Jun 2015 18:09:48 -0700
Message-ID: <1434676188-2578-1-git-send-email-minh.tran@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33455 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbbFSGMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2015 02:12:50 -0400
Received: by padev16 with SMTP id ev16so78295827pad.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2015 23:12:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Minh Duc Tran <MinhDuc.Tran@avagotech.Com>

From: Minh Duc Tran <MinhDuc.Tran@avagotech.Com>

This blocking is ok if we use software iscsi or iser where each
connection has a separate host.  In the case of hw iscsi offload, one
host could have hundreds of connections and some connections may have
IOs running which makes host->host_busy is always TRUE.  Another
problem is the host_lock taken here is disruptive to other
connections' EH paths.  Wouldn't using target_busy a better choice
here?

void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
{
  .....
.......
        /*
         * Block until all in-progress commands for this connection
         * time out or fail.
         */
        for (;;) {
                spin_lock_irqsave(session->host->host_lock, flags);
                if (!atomic_read(&session->host->host_busy)) { /* OK
for ERL == 0 */
                        spin_unlock_irqrestore(session->host->host_lock, flags);
                        break;
                }
                spin_unlock_irqrestore(session->host->host_lock, flags);
                msleep_interruptible(500);
                iscsi_conn_printk(KERN_INFO, conn, "iscsi conn_destroy(): "
                                  "host_busy %d host_failed %d\n",
                                  atomic_read(&session->host->host_busy),
                                  session->host->host_failed);
                /*
                 * force eh_abort() to unblock
                 */
                wake_up(&conn->ehwait);
        }
