From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 193041] New: iSCSI initiator: mkfs.ext4 + mount triggers kernel
 oops
Date: Sat, 21 Jan 2017 00:06:13 +0000
Message-ID: <bug-193041-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752244AbdAUAGT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 19:06:19 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id CD8C320361
        for <linux-scsi@vger.kernel.org>; Sat, 21 Jan 2017 00:06:17 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id D3064202F2
        for <linux-scsi@vger.kernel.org>; Sat, 21 Jan 2017 00:06:14 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=193041

            Bug ID: 193041
           Summary: iSCSI initiator: mkfs.ext4 + mount triggers kernel
                    oops
           Product: IO/Storage
           Version: 2.5
    Kernel Version: v4.10-rc4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: bvanassche@acm.org
        Regression: No

Created attachment 252661
  --> https://bugzilla.kernel.org/attachment.cgi?id=252661&action=edit
netconsole output

The following command sequence worked with previous kernels but triggers a
kernel oops with kernel v4.10-rc4:

./restart-lio-iscsi
iscsiadm -m discovery -t st -p localhost
iscsiadm -m node -p localhost -l
mkfs.ext4 /dev/sda
mount /dev/sda /mnt

gdb translates the crash address into the following:

$ gdb ./drivers/scsi/iscsi_tcp.ko
(gdb) list *(iscsi_sw_tcp_xmit_segment+0x84)
0xf54 is in iscsi_sw_tcp_xmit_segment (drivers/scsi/iscsi_tcp.c:272).
267             struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
268             struct socket *sk = tcp_sw_conn->sock;
269             unsigned int copied = 0;
270             int r = 0;
271
272             while (!iscsi_tcp_segment_done(tcp_conn, segment, 0, r)) {
273                     struct scatterlist *sg;
274                     unsigned int offset, copy;
275                     int flags = 0;
276

-- 
You are receiving this mail because:
You are the assignee for the bug.
