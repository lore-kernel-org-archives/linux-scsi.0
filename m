From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
Date: 04 Sep 2003 16:36:02 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1062714962.5959.17.camel@lintel>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


> mount -w -t udf works with my dvd-ram ...
> mistakenly sees my dvd+rw as read-only ...

Besides that Andy Polyakov patch for mount -w of dvd+rw, the web has
Jens Axboe patches for mount -w of cd-rw, via the udf faq (Not via the
udftools faq):

http://sourceforge.net/projects/linux-udf/
udf-0.9.7.tar.gz
FAQ
http://w1.894.telia.com/~u89404340/patches/packet/

---

>From these two clues, kindly offline people have identified the Four
fragments of kernel source that cooperate to conclude erroneously that
dvd+rw etc. are not writable:

1)

drivers/scsi/sr.c understands only the CDC_DVD_RAM profile of the seven
standard mmc "writable" device "profile"s, because sr.c neglects to look
beyond the "Capabilities" mode page x2a i.e. does not look beyond the
mmc 1 standard of 1997.  Ansi did not publish an op x46 Get
Configuration standard until the mmc 2 of 1999.

2)

include/scsi/scsi.h does not yet #define GET_CONFIGURATION 0x46.

3)

drivers/cdrom/cdrom.c also understands only CDC_DVD_RAM: cdrom.c
erroneously claims all mmc profiles except CDC_DVD_RAM are not
FMODE_WRITE-able.

4)

include/linux/cdrom.h names only CDC_DVD_RAM.

---

Anyone have an idea of how best to patch this?

I've seen a few linux-2.6.0-test4/ and linux-2.4.22/ alternatives mostly
work.  Anyone interested in evaluating some of them?

Pat LaVarre
