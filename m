From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 13:33:08 +0100
Message-ID: <e2e108260801220433t33cf52feka52520b0023763e3@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu>
	 <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	 <4795D4A7.5000105@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:50567 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbYAVMdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 07:33:10 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1306353wxd.4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Jan 2008 04:33:09 -0800 (PST)
In-Reply-To: <4795D4A7.5000105@vlnb.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Pete Wyckoff <pw@osc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, James.Bottomley@hansenpartnership.com, erezz@voltaire.com

On Jan 22, 2008 12:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>
> What are the new SRPT/iSER numbers?

You can find the new performance numbers below. These are all numbers
for reading from the remote buffer cache, no actual disk reads were
performed. The read tests have been performed with dd, both for a
block size of 512 bytes and of 1 MB. The tests with small block size
learn more about latency, while the tests with large block size learn
more about the maximal possible throughput.

.............................................................................................
.                           .   STGT read     SCST read    .    STGT
read      SCST read    .
.                           .  performance   performance   .
performance    performance   .
.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB,
MB/s)   (1 MB, MB/s)  .
.............................................................................................
. Ethernet (1 Gb/s network) .      77             78       .        77
            89       .
. IPoIB    (8 Gb/s network) .     163            185       .       201
           239       .
. iSER     (8 Gb/s network) .     250            N/A       .       360
           N/A       .
. SRP      (8 Gb/s network) .     N/A            421       .       N/A
           683       .
.............................................................................................

My conclusion from the above numbers: the performance difference
between STGT and SCST is small for a Gigabit Ethernet network. The
faster the network technology, the larger the difference between SCST
and STGT.

Bart.
