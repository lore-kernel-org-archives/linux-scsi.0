From: Michael Renner <michael.renner@geizhals.at>
Subject: Bad SCSI performance with 2.6.14 and Fusion-MPT
Date: Thu, 10 Nov 2005 20:18:29 +0000 (UTC)
Message-ID: <loom.20051110T204455-697@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:31198 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S932209AbVKJWdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Nov 2005 17:33:10 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1EaKwd-0006R0-HD
	for linux-scsi@vger.kernel.org; Thu, 10 Nov 2005 23:30:59 +0100
Received: from das.geizhals.buero.ist.geiler.at ([213.229.14.38])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2005 23:30:58 +0100
Received: from michael.renner by das.geizhals.buero.ist.geiler.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2005 23:30:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm seeing really bad scsi performance with 2.6.14 in combination with Fusion
MPT and amd64. The same behavior was seen in 2.6.14-git13.

The controller in question identifies itself as "LSI Logic / Symbios Logic
53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 07)", PCI ID 1000:0030.

Starting with 2.6.14 (didn't test the releases between 2.6.13 and 2.6.14) the
resync rate of the software raid dropped to about 2mb/sec on a raid1 array over
two scsi disks (normally I get around 60-80mb/sec), doing a dd from one disk to
the other supported those values. I can't give exact measures since a "sync"
call hangs since half an hour (was a bit too much data for testing) but vmstat
shows:

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  5      0 23873224 8198000  24288    0    0   463   259   71    23  0  0 83 17
 0  5      0 23872968 8198000  24288    0    0     0  4096  273    48  0  0 75 25
 0  5      0 23873340 8198000  24288    0    0     0     0  271    50  0  0 75 25
 0  4      0 23873084 8198000  24288    0    0     0  4096  270    49  0  0 75 24
 0  4      0 23873120 8198000  24288    0    0     0  4096  274    54  0  0 75 25
 0  4      0 23873120 8198000  24288    0    0     0     0  270    44  0  0 75 25
 0  4      0 23873136 8198000  24288    0    0     0  4096  272    51  0  0 75 25

which is bad.

Any ideas?

best regards,
Michael Renner

