From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Delete trailing full stop
Date: Fri, 18 Nov 2005 16:42:10 +1000
Message-ID: <437D77C2.3000908@torque.net>
References: <20051117181343.GD17171@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:16332 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932506AbVKRGlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2005 01:41:11 -0500
In-Reply-To: <20051117181343.GD17171@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> None of the other domain validation messages have a trailing full stop,
> so I don't see why this one should.

Speaking of domain validation messages I have noticed
that either the sym53c8xx driver or scsi_transport_spi is
getting noisier in this area.

After "hot plugging" a U160 disk on a unpopulated bus
and then scanning the bus there was lots of redundant
noise on my console and log. The disk had autospin off
so a START STOP UNIT command was needed followed by a wait
for the disk to spin up. This is what I saw in my log after:
  # echo 1 > /sys/class/scsi_host/host0/scan

  Vendor: FUJITSU   Model: MAM3184MP         Rev: 0106
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:3: tagged command queuing enabled, command queue depth 16.
 target0:0:3: Beginning Domain Validation
 target0:0:3: asynchronous.
 target0:0:3: wide asynchronous.
 target0:0:3: Domain Validation skipping write tests
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: Ending Domain Validation
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 2 times
sdb: Spinning up disk....<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.<6> target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 target0:0:3: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
 last message repeated 7 times
.ready
SCSI device sdb: 35885344 512-byte hdwr sectors (18373 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 35885344 512-byte hdwr sectors (18373 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 >
sd 0:0:3:0: Attached scsi disk sdb



Surely one "FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)"
message is sufficient?


The READ CAPACITY/fetching the caching mode page sequence
seems to be occurring twice. I also see this with scsi_debug
so it isn't a spi or lldd problem.

Doug Gilbert
