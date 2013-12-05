From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 66611] New: Very Slow I/O performance on SAS1064
Date: Thu, 05 Dec 2013 14:23:29 +0000
Message-ID: <bug-66611-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:44922 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab3LEOXd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Dec 2013 09:23:33 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D10CD2051D
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2013 14:23:31 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 888C020519
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2013 14:23:29 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=66611

            Bug ID: 66611
           Summary: Very Slow I/O performance on SAS1064
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.12.2
          Hardware: Sparc64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: mar@kola.li
        Regression: No

Hi

I have a sunfire v245 with 4 Sata disks (TOSHIBA MQ01ABB2  0U)

my controller:
0000:0d:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064 PCI-X
Fusion-MPT SAS (rev 02)

[   86.909571] Fusion MPT SAS Host driver 3.04.20

Moduls load:
mptsas                 33574  2
scsi_transport_sas     21704  2 mptsas
mptscsih               17605  1 mptsas
mptbase                53658  3 mptctl,mptsas,mptscsih
scsi_mod              171548  10
sg,scsi_transport_sas,libata,mptctl,mptsas,sd_mod,sr_mod,mptscsih

The kernel is self compiled and i provide the config if needed
Linux hostname 3.12.2 #4 Wed Dec 4 13:45:28 CET 2013 sparc64 GNU/Linux
On Debian 7.2

Test with dd:
# dd if=/dev/zero of=test.dd bs=8k count=1000
1000+0 records in
1000+0 records out
8192000 bytes (8.2 MB) copied, 85.015 s, 96.4 kB/s

# dstat -cdr -D sdb
----total-cpu-usage---- --dsk/sdb-- ---io/sdb--
usr sys idl wai hiq siq| read  writ| read  writ
 11   1  36  52   0   0|  93k 5949B|0.58  0.96
  0   0   0 100   0   0|   0    25k|   0  3.00
  0   0   0 100   0   0|   0   225k|   0  37.0
  0   0   0 100   0   0|   0   528k|   0  68.0
  0   0   0 100   0   0|   0   224k|   0  29.0
  0   0   0 100   0   0|   0   130k|   0  16.0
  0   0   0 100   0   0|   0     0 |   0     0
  0   0   0 100   0   0|   0  8192B|   0  1.00
  0   0   0 100   0   0|   0    25k|   0  4.00
  0   0   0 100   0   0|   0    85k|   0  16.0
  0   0   0 100   0   0|   0    87k|   0  11.0
  0   0   0 100   0   0|   0     0 |   0     0
  0   0   0 100   0   0|   0  8192B|   0  1.00
  0   0   0 100   0   0|   0    25k|   0  4.00
  0   0   0 100   0   0|   0    26k|   0  5.00
....

Thanks

-- 
You are receiving this mail because:
You are the assignee for the bug.
