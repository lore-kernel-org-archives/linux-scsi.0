From: Dan Carpenter <error27@gmail.com>
Subject: [bug report] target: stack can be smashed
Date: Tue, 9 Aug 2011 15:28:08 +0300
Message-ID: <20110809122808.GI7659@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:65223 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab1HIMaP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2011 08:30:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>

Sparse prints the following warnings:

drivers/target/iscsi/iscsi_target_util.c:1435:32: error: bad constant expression
drivers/target/iscsi/iscsi_target_util.c:1436:30: error: bad constant expression
drivers/target/iscsi/iscsi_target_util.c:1563:32: error: bad constant expression
drivers/target/iscsi/iscsi_target_util.c:1564:30: error: bad constant expression

Here is the offending code:
  1430  static int iscsit_do_rx_data(
  1431          struct iscsi_conn *conn,
  1432          struct iscsi_data_count *count)
  1433  {
  1434          int data = count->data_length, rx_loop = 0, total_rx = 0, iov_len;
  1435          u32 rx_marker_val[count->ss_marker_count], rx_marker_iov = 0;
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1436          struct kvec iov[count->ss_iov_count], *iov_p;
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1437          struct msghdr msg;

  1558  static int iscsit_do_tx_data(
  1559          struct iscsi_conn *conn,
  1560          struct iscsi_data_count *count)
  1561  {
  1562          int data = count->data_length, total_tx = 0, tx_loop = 0, iov_len;
  1563          u32 tx_marker_val[count->ss_marker_count], tx_marker_iov = 0;
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1564          struct kvec iov[count->ss_iov_count], *iov_p;
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  1565          struct msghdr msg;

To me it looks very dangerous (and potentially exploitable) but I
didn't follow the logic all the way to see what caps are on
->ss_marker_count and ->ss_iov_count.

regards,
dan carpenter
