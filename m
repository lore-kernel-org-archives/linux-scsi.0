From: "Bailey, Scott" <scott.bailey@eds.com>
Subject: Bogus st failures from qla1280 timeouts?
Date: Mon, 8 May 2006 13:52:49 -0400
Message-ID: <F3598542BAC24B4783B7A440D45522FF04050571@usahm236.amer.corp.eds.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ahmler6.mail.eds.com ([192.85.154.80]:50341 "EHLO
	ahmler6.mail.eds.com") by vger.kernel.org with ESMTP
	id S932480AbWEHRxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2006 13:53:14 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes.Sorensen@cern.ch, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Bailey, Scott" <scott.bailey@eds.com>

I've been worrying around the edges of this problem for months without
really feeling that I understand it but I have formed enough suspicions
to make this quasi-informed plea for help... :-)

I manage an Alphaserver 4100/466 with 3 processors running Debian
testing/unstable (presently with kernel built from Debian's
linux-source-2.6.16-12 package). It is equipped with 3 KZPBA
(single-ended) SCSI controllers, for which I use the qla1280 driver with
ISP1040 support enabled. (I was never so happy as when this support was
introduced and I could say good-bye to kernel 2.4 and the
sort-of-not-really-supported Feral driver.)

One of these controllers is dedicated to an external TZ89 [DLT4] tape
drive. In general, this works quite well except for selected operations
that take awhile to complete -- such as positioning to end of data prior
to appending to a tape, or when doing file spacing prior to attempting
to restore data. In these cases, the command inevitably fails with
"Input/output error" and the following gets logged:

kernel: scsi(0): Resetting Cmnd=0x<very long variable number>,
Handle=0x0000000000000202, action=0x2
kernel: scsi(0:0:0:0): Queueing device reset command.
kernel: st0: Error 30000 (sugg. bt 0x0, driver bt 0x0, host bt 0x3).

I don't seem to have been very successful in translating the host byte
"3" into English. :-) My growing suspicion is that the I/O operation is
timing out (and causing a device reset) before it has a chance to
complete normally. For example:

# mt -f /dev/nst0 rewind
# time mt -f /dev/nst0 eod
/dev/nst0: Input/output error

real    1m1.834s
user    0m0.002s
sys     0m0.007s
# mt -f /dev/nst0 rewind
# time mt -f /dev/nst0 fsr 5000
/dev/nst0: Input/output error

real    0m30.661s
user    0m0.001s
sys     0m0.009s
# mt -f /dev/nst0 rewind
# time mt -f /dev/nst0 fsr 2000

real    0m12.741s
user    0m0.002s
sys     0m0.004s
# time mt -f /dev/nst0 fsr 2000

real    0m19.597s
user    0m0.001s
sys     0.0.006s
# time mt -f /dev/nst0 fsr 2000

real    0m12.566s
user    0m0.001s
sys     0m0.007s

etc. In general, amazingly :-), any "eod" command (on a tape with a
nontrivial amount of data already on it) always fails in just a tiny bit
more than 60 seconds, and other positioning commands either complete
successfully in less than 30 seconds or fail in just a tiny bit more
than 30 seconds, with the same syndrome reported above. If I am patient
and step far enough into the tape, "rewind" commands fail after just
more than 30 seconds of elapsed time.

I have stumbled my way through the mt.c code and it appears to be
setting and honoring the sttimeout and stlongtimeout attributes
correctly, except that setting either or both to any of a range of
creatively high values has absolutely no effect whatsoever on the above
behavior. (But a timeout of "-1" resulted in a kernel oops that halted
my system... don't try that at home, kids!)

Working through qla1280.c while looking for "timeout" I found this
suggestive snippet of code in both qla1280_64bit_start_scsi() and
qla1280_32bit_start_scsi():

	/* Set ISP command timeout. */
	pkt->timeout = cpu_to_le16(30);

I am at a loss to understand if this really corresponds to the 30-second
errors I am seeing, and if so is it overriding or running in parallel
with the st timeout, and how I would reconcile this hypothesis with the
60-second failures I see during end-of-data positioning.

Before I start hacking on this value and bouncing my system to change
it, can anybody provide feedback on whether this even makes any sense
and/or if there is a better long-term solution for this issue?

Thank you very much for your patience,

	Scott Bailey
	scott.bailey@eds.com
