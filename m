From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
	different SCSI targets (SCST, STGT, IET, LIO)
Date: Tue, 7 Apr 2009 22:27:36 +0200
Message-ID: <e2e108260904071327u6b6c6e43tdc76f648be0302dd@mail.gmail.com>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org>
	 <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
	 <49D9D9A0.40106@wpkg.org> <49DA33EF.3020700@vlnb.net>
	 <49DA49AA.1060106@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36502 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760833AbZDGU1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 16:27:40 -0400
In-Reply-To: <49DA49AA.1060106@wpkg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org

On Mon, Apr 6, 2009 at 8:27 PM, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> Note that crypt performance for SCST was worse than that of STGT for large
> read-ahead values.
> Also, SCST performance on crypt device was more or less the same with 256
> and 16384 readahead values. I wonder why performance didn't increase here
> while increasing readahead values? Could anyone recheck if it's the same on
> some other system?

I have repeated the test for the non-encrypted case. Setup details:
* target: 2.6.29.1 kernel, 64-bit, Intel E8400 CPU @ 3 GHz, 4 GB RAM,
two ST3250410AS disks, with /dev/md3 set up in RAID-1 with a stripe
size of 32 KB, local reading speed of /dev/md3: 120 MB/s, I/O
scheduler: CFQ.
* initiator: 2.6.28.7 kernel, 64-bit, Intel E6750 CPU @ 2.66 GHz, 2 GB RAM.
* network: 1 Gbit/s Ethernet, two systems connected back to back via a
crossed cable.

Each test was repeated four times. Before each test the target caches
were dropped via the command "sync; echo 3 >
/proc/sys/vm/drop_caches". The following test has been run on the
initiator:

sync; echo 3 > /proc/sys/vm/drop_caches; dd if=/dev/sdb of=/dev/null
bs=64K count=100000

Results with read-ahead set to 256 on the initiator, in MB/s:

STGT 56.7 +/- 0.3
SCST 56.9 +/- 1.1

Results with read-ahead set to 16384 on the initiator, in MB/s:

STGT 59.9 +/- 0.1
SCST 59.5 +/- 0.0

Or: slightly better results with the larger read-ahead value, and a
performance difference well below 1% between the STGT and SCST
performance results.

Bart.
