From: Dan Carpenter <error27@gmail.com>
Subject: [smatch stuff] target: uninitialized variable in
 iscsit_handle_text_cmd()
Date: Wed, 27 Jul 2011 14:12:30 +0300
Message-ID: <20110727111230.GO3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45202 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1G0LO1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 07:14:27 -0400
Received: by yia27 with SMTP id 27so922851yia.19
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jul 2011 04:14:27 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>

There is an uninitialized variable in iscsit_handle_text_cmd().  I'm
not sure why gcc doesn't complain...

drivers/target/iscsi/iscsi_target.c +1899 iscsit_handle_text_cmd(46)
	error: potentially derefencing uninitialized 'cmd'.

  1898                  if (padding != 0) {
  1899                          iov[niov].iov_base = cmd->pad_bytes;
                                                     ^^^^^

"cmd" hasn't been initialized here yet.

  1900                          iov[niov++].iov_len  = padding;
  1901                          rx_size += padding;
  1902                          pr_debug("Receiving %u additional bytes"
  1903                                          " for padding.\n", padding);
  1904                  }
  1905                  if (conn->conn_ops->DataDigest) {
  1906                          iov[niov].iov_base      = &checksum;
  1907                          iov[niov++].iov_len     = ISCSI_CRC_LEN;
  1908                          rx_size += ISCSI_CRC_LEN;
  1909                  }
  1910  
  1911                  rx_got = rx_data(conn, &iov[0], niov, rx_size);
  1912                  if (rx_got != rx_size) {
  1913                          kfree(text_in);
  1914                          return -1;
  1915                  }
  1916  
  1917                  if (conn->conn_ops->DataDigest) {
  1918                          iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
  1919                                          text_in, text_length,
  1920                                          padding, cmd->pad_bytes,
                                                         ^^^^^

Or here.

  1921                                          (u8 *)&data_crc);
  1922  

regards,
dan carpenter

