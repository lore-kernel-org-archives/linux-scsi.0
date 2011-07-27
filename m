From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [smatch stuff] target: uninitialized variable in
	iscsit_handle_text_cmd()
Date: Wed, 27 Jul 2011 12:38:41 -0700
Message-ID: <1311795521.6931.11.camel@haakon2.linux-iscsi.org>
References: <20110727111230.GO3824@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:39737 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1G0TsB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jul 2011 15:48:01 -0400
In-Reply-To: <20110727111230.GO3824@shale.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Andy Grover <agrover@redhat.com>

On Wed, 2011-07-27 at 14:12 +0300, Dan Carpenter wrote:
> There is an uninitialized variable in iscsit_handle_text_cmd().  I'm
> not sure why gcc doesn't complain...
> 
> drivers/target/iscsi/iscsi_target.c +1899 iscsit_handle_text_cmd(46)
> 	error: potentially derefencing uninitialized 'cmd'.
> 
>   1898                  if (padding != 0) {
>   1899                          iov[niov].iov_base = cmd->pad_bytes;
>                                                      ^^^^^
> 
> "cmd" hasn't been initialized here yet.
> 
>   1900                          iov[niov++].iov_len  = padding;
>   1901                          rx_size += padding;
>   1902                          pr_debug("Receiving %u additional bytes"
>   1903                                          " for padding.\n", padding);
>   1904                  }
>   1905                  if (conn->conn_ops->DataDigest) {
>   1906                          iov[niov].iov_base      = &checksum;
>   1907                          iov[niov++].iov_len     = ISCSI_CRC_LEN;
>   1908                          rx_size += ISCSI_CRC_LEN;
>   1909                  }
>   1910  
>   1911                  rx_got = rx_data(conn, &iov[0], niov, rx_size);
>   1912                  if (rx_got != rx_size) {
>   1913                          kfree(text_in);
>   1914                          return -1;
>   1915                  }
>   1916  
>   1917                  if (conn->conn_ops->DataDigest) {
>   1918                          iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
>   1919                                          text_in, text_length,
>   1920                                          padding, cmd->pad_bytes,
>                                                          ^^^^^
> 
> Or here.
> 
>   1921                                          (u8 *)&data_crc);
>   1922  

Mmmm, it looks like this was introduced with the following iscsi-target
v4.1 cleanup:

commit e947358c9630777e51e0f123f70e4cd634aa13b1
Author: Andy Grover <agrover@redhat.com>
Date:   Fri May 27 10:16:37 2011 -0700

    target/iscsi: use pad_bytes in cmd over local vars

Re-adding the local scope usage of pad_bytes with the following patch.

Thanks!

--nab

---------------------------------------------------------------------
commit b632b3512263eb767aa6356fab5dfc79341fb88b
debian-amd64:/usr/src/lio-core-2.6.git# git show 6c1515b7d63d8
commit 6c1515b7d63d8038a6fbea172932369f87dd0cf4
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed Jul 27 12:16:22 2011 -0700

    iscsi-target: Fix uninitialized usage of cmd->pad_bytes
    
    This patch fixes an uninitialized usage of cmd->pad_bytes inside of
    iscsit_handle_text_cmd() introduced during a v4.1 change to use cmd
    members instead of local pad_bytes variables.
    
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9df7f08..1025b1a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1857,7 +1857,7 @@ static int iscsit_handle_text_cmd(
        char *text_ptr, *text_in;
        int cmdsn_ret, niov = 0, rx_got, rx_size;
        u32 checksum = 0, data_crc = 0, payload_length;
-       u32 padding = 0, text_length = 0;
+       u32 padding = 0, pad_bytes = 0, text_length = 0;
        struct iscsi_cmd *cmd;
        struct kvec iov[3];
        struct iscsi_text *hdr;
@@ -1896,7 +1896,7 @@ static int iscsit_handle_text_cmd(
 
                padding = ((-payload_length) & 3);
                if (padding != 0) {
-                       iov[niov].iov_base = cmd->pad_bytes;
+                       iov[niov].iov_base = &pad_bytes;
                        iov[niov++].iov_len  = padding;
                        rx_size += padding;
                        pr_debug("Receiving %u additional bytes"
@@ -1917,7 +1917,7 @@ static int iscsit_handle_text_cmd(
                if (conn->conn_ops->DataDigest) {
                        iscsit_do_crypto_hash_buf(&conn->conn_rx_hash,
                                        text_in, text_length,
-                                       padding, cmd->pad_bytes,
+                                       padding, (u8 *)&pad_bytes,
                                        (u8 *)&data_crc);
 
                        if (checksum != data_crc) {


