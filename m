From: Jeff Layton <jtlayton@poochiereds.net>
Subject: Re: Qlogic ISP 1020
Date: Tue, 23 Mar 2004 16:00:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080075653.2457.11.camel@localhost>
References: <1080004793.5848.34.camel@localhost>
	 <20040323062912.B29405@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rdu26-93-067.nc.rr.com ([66.26.93.67]:9192 "EHLO
	salusa.poochiereds.net") by vger.kernel.org with ESMTP
	id S262834AbUCWVAz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 16:00:55 -0500
In-Reply-To: <20040323062912.B29405@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2004-03-23 at 01:29, Christoph Hellwig wrote:
> https://verein.lst.de/~hch/qla1280-isp1040.diff.bz2 has my current patch.
> 
> So far I only kno it works with 1040B's on SGI Origins.   If you want to
> give it a try apply the patch and make sure you have the qla1280 but not the
> qlogicisp driver in the kernel.
> 
> I'll try to split the patch into reasoable chunk soon and feed it to Jes.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I tried this out today, and the results were mixed. Here's the lspci
output for this card:

00:0f.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI
(rev 05)

When I built a patched driver and plugged it in, here's what I saw in
dmesg:

qla1280: no version magic, tainting kernel.
qla1280: QLA1040 found on PCI bus 0, dev 15
scsi(0:0): Resetting SCSI BUS
scsi0 : QLogic QLA1040 PCI to SCSI Host Adapter
       Firmware version:  7.65.00, Driver version 3.25
  Vendor: Quantum   Model: DLT4000           Rev: CD3C
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi(0:0:2:0): Sync: period 10, offset 12
st: Version 20040213, fixed bufsize 32768, s/g segs 256
Attached scsi tape st0 at scsi0, channel 0, id 2, lun 0
st0: try direct i/o: yes, max page reachable by HBA 1048575

Looked pretty good, other than it seems to think that my card is a 1040
and not a 1020. I then tried to do some operations with my tape drive:

jtlayton@salusa:/usr/src/linux-2.6.4% sudo mt -f /dev/nst0 status
SCSI 2 tape drive:
File number=-1, block number=-1, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (1010000):
 ONLINE IM_REP_EN

I then tried to use tar to write a file to the tape and it failed almost
immediately:

jtlayton@salusa:~% sudo tar cvf /dev/nst0 ./wolf-linux-1.33.x86.run
./wolf-linux-1.33.x86.run
tar: /dev/nst0: Wrote only 0 of 10240 bytes
tar: Error is not recoverable: exiting now

These errors seem to cause these messages to pop up in dmesg:

st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).
st0: Error 70000 (sugg. bt 0x0, driver bt 0x0, host bt 0x7).

Please let me know if there's any info I can provide that might help, or
if you need me to test another patch.

Heck, I'll even offer up a case of beer (or an equivalent reward) if we
can get it working!

Thanks,
-- 
Jeff Layton <jtlayton@poochiereds.net>

