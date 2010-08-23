From: "Billich Heiner" <Heiner.Billich@psi.ch>
Subject: srp target - write to raw block device like /dev/sda ist fragmented into very small requests
Date: Mon, 23 Aug 2010 20:16:54 +0200
Message-ID: <AD99CE4B84C4D3468F69B0E4FB345D5805FDEB45@MAILBOX0A.psi.ch>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa02.psi.ch ([192.33.126.172]:48718 "EHLO esa02.psi.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262Ab0HWS0n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 14:26:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

we employ Infiniband SRP storage. For basic tests I just did write/read
with dd to the raw block device like /dev/sda. I tell dd to use 1M sized
blocks, but I see very small few KB sized requests only. To make this
tests of real value I would need to read and write with large 1MB sized
requests. More important I'm not sure whether this points to some
misconfiguration.

Example: 
Read 1M sized blocks from /dev/sdh - iostat shows 8*512byte average
request size, which is very small, I would expect 1M sized requests:
 
# dd if=/dev/sdh of=/dev/null bs=1M &

# iostat -xk /dev/sdh 2

Device:         rrqm/s   wrqm/s   r/s   w/s    rkB/s    wkB/s avgrq-sz
avgqu-sz   await  svctm  %util
sdh               0.00     0.00 8253.23  0.00 33012.94     0.00     8.00
0.90    0.11   0.11  89.95

Performance counters on the srp target show the same small request size.

Is this expected behaviour if I write or read from/to a srp block device
file? Does anything limit the request size if I access the storage via
the block device file like /dev/sdh? 

Using a mounted filesystem on top of the block devices I get perfectly
1M sized i/o requests, hence I think that the storage (DDN S2A9900) is
o.k.. 

Kind regards,

Heiner Billich
