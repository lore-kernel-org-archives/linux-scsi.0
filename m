Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B132C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 15:01:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C2E020665
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 15:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="mNDWyUpB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfK0PBg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:01:36 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45561 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfK0PBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 10:01:34 -0500
Received: by mail-wr1-f48.google.com with SMTP id j42so1203416wrj.12
        for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2019 07:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=DNtJfauRBjFymYT75xk9xDJ5e1t0+VIC2tL8E64Wwmg=;
        b=mNDWyUpBm4o5wr3Yxmhc9+VvHho9d0e6U6uQ+fvdgX9eH1rvYpznP6bW/3KlFczztc
         Xrq5fUtzuMGoFYv7LKy6XF+MHt4LeCQeqbkLfdHvrIYCPaqd+Y/hQ+/QEiU0UXDFFvmY
         zjMHVb80hKDMpC25zlDpdUKGkjVRh9vqGXGBr+L5RFHac+kb+8GPX/aqiEAuBres8fjm
         uzJxido8ezFW30zke+hqJs/2asHkbwSFinOtUMQr3jOWTcB5SNJZ3XU34NewdTGnMYWO
         NsQA7OzHCSJf4uPr1ah3a/7wrNiga39gx3cleL9JnpeLI6bBIorpTMTbLiJZvtM3D6mz
         heJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=DNtJfauRBjFymYT75xk9xDJ5e1t0+VIC2tL8E64Wwmg=;
        b=gBI+uYzzlr7HqBRYXEKedkkSHzULw5UzALi0Oj5/ipdQQLIJqVjHNpFYDyGhjqqZD6
         FMHpOitW3B9foUq8LuffndXY1MhLjRCJsyT/2ep+a1EW4zFlyUVgAWAOE/0nKbOviddI
         +Dj6Ptb15U0vET3SebsrzFPD16ym60AF8azdnNnJV948Ow/QqcyXwEGo165xZtLmXum3
         5/suVwVncb5FMQUHZzWk7x6n1UOB0trfG2lmswp+Ax5Sy73mnCJY7owwpJet/NCMEJ4I
         h8v4pw4zj4CKnwwsm2RxpmcUnM4XSZLxLY6f84XCgTB10uBKOvuUrlk65M79VI/VYCtf
         VgUQ==
X-Gm-Message-State: APjAAAUt9XSTVVaB79gCfYAhxnNIEznANeRQfYBJoIG8kLCThnxc8E7H
        duOJy5P/xRUyTe+y3Bzis/Jy0w==
X-Google-Smtp-Source: APXvYqzWWLOCz/LwlGp5T9LK4jRya8X6hKqCVK3/+ryFCO6besvGDPKn1GlAwoUcKy2c0iMvLW3MIg==
X-Received: by 2002:a5d:4692:: with SMTP id u18mr6157318wrq.206.1574866890252;
        Wed, 27 Nov 2019 07:01:30 -0800 (PST)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id z6sm20213883wro.18.2019.11.27.07.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 07:01:29 -0800 (PST)
Message-ID: <f9c04d802c99fca3886c6d46215f39a4ba171eee.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Date:   Wed, 27 Nov 2019 16:01:28 +0100
In-Reply-To: <20191127130854.GA12140@ming.t460p>
References: <20191125102928.GA20489@ming.t460p>
         <e5093535c60fd5dff8f92b76dcd52a1030938f62.camel@unipv.it>
         <20191125151535.GA8044@ming.t460p>
         <0876e232feace900735ac90d27136288b54dafe1.camel@unipv.it>
         <20191126023253.GA24501@ming.t460p>
         <0598fe2754bf0717d81f7e72d3e9b3230c608cc6.camel@unipv.it>
         <20191126091533.GB32135@ming.t460p>
         <e852331e72532dbfdc7981d958b1cd05ded41317.camel@unipv.it>
         <20191127020533.GA7190@ming.t460p>
         <3af3666920e7d46f8f0c6d88612f143ffabc743c.camel@unipv.it>
         <20191127130854.GA12140@ming.t460p>
Content-Type: multipart/mixed; boundary="=-DgnQFQ4zgEplvIMKoKcv"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--=-DgnQFQ4zgEplvIMKoKcv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Il giorno mer, 27/11/2019 alle 21.08 +0800, Ming Lei ha scritto:
> On Wed, Nov 27, 2019 at 10:39:40AM +0100, Andrea Vai wrote:
> > Il giorno mer, 27/11/2019 alle 10.05 +0800, Ming Lei ha scritto:
> > > 
> > > 
> > > It can be workaround via the following change:
> > > 
> > > /lib/modules/5.4.0+/build/include/generated/autoconf.h:
> > > 
> > > //#define CONFIG_CC_HAS_ASM_INLINE 1
> > 
> > Thanks, it worked, trace attached. Produced by: start the trace
> script
> > (with the pendrive already plugged), wait some seconds, run the
> test
> > (1 trial, 1 GB), wait for the test to finish, stop the trace.
> > 
> > The copy took 2659 seconds, roughly as already seen before.
> 
> Thanks for collecting the log.
> 
> From the log, some of write IOs are out-of-order, such as, the 1st
> one
> is 378880.
> 
> 16.41240 2   266     266     kworker/2:1H    block_rq_issue   b'W'
> 370656 240
> 16.41961 3   485     485     kworker/3:1H    block_rq_issue   b'W'
> 378880 240
> 16.73729 2   266     266     kworker/2:1H    block_rq_issue   b'W'
> 370896 240
> 17.71161 2   266     266     kworker/2:1H    block_rq_issue   b'W'
> 379120 240
> 18.02344 2   266     266     kworker/2:1H    block_rq_issue   b'W'
> 371136 240
> 18.94314 3   485     485     kworker/3:1H    block_rq_issue   b'W'
> 379360 240
> 19.25624 2   266     266     kworker/2:1H    block_rq_issue   b'W'
> 371376 240
> 
> IO latency is increased a lot since the 1st out-of-order request(usb
> storage HBA is single queue depth, one request can be issued only
> if 
> the previous issued request is completed).
> 
> The reason is that there are two kind of tasks which inserts rq to
> device.
> One is the 'cp' process, the other is kworker/u8:*.  The out-of-
> order
> happens during the two task's interleaving.
> 
> Under such situation, I believe that the old legacy IO path may not
> guarantee the order too. In blk_queue_bio(), after get_request()
> allocates one request, the queue lock is released.  And request is
> actually inserted & issued from blk_flush_plug_list() under the
> branch of 'if (plug)'. If requests are from two tasks, then request
> is inserted/issued from two plug list, and no order can be
> guaranteed.
> 
> In my test, except for several requests from the beginning, all
> other
> requests are inserted via the kworker thread(guess it is writeback
> wq),
> that is why I can't observe the issue in my test.
> 
> As Schmid suggested, you may run the same test on old kernel with
> legacy io path, and see if the performance is still good.
> 
> Also, could you share the following info about your machine? So that
> I can build my VM guest in this setting for reproducing your
> situation
> (requests are inserted from two types of threads).
> 
> - lscpu
attached,

> - free -h
              total        used        free      shared  buff/cache   available
Mem:           23Gi       4,2Gi        11Gi       448Mi       7,0Gi        18Gi
Swap:         3,7Gi          0B       3,7Gi

> - lsblk -d $USB_DISK

NAME MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sdg    8:96   1 28,8G  0 disk 


> - exact commands for mount the disk, and running the copy operation

I attached the whole script to this thread, I attach it again to this
message and copy the relevant lines here:

  mount UUID=$uuid /mnt/pendrive 2>&1 |tee -a $logfile
  SECONDS=0
  cp $testfile /mnt/pendrive 2>&1 |tee -a $logfile
  umount /mnt/pendrive 2>&1 |tee -a $logfile

Meanwhile, I am going on with the further tests as suggested

Thanks,
Andrea

--=-DgnQFQ4zgEplvIMKoKcv
Content-Disposition: attachment; filename="lscpu.txt"
Content-Type: text/plain; name="lscpu.txt"; charset="UTF-8"
Content-Transfer-Encoding: base64

QXJjaGl0ZWN0dXJlOiAgICAgICAgeDg2XzY0CkNQVSBvcC1tb2RlKHMpOiAgICAgIDMyLWJpdCwg
NjQtYml0CkJ5dGUgT3JkZXI6ICAgICAgICAgIExpdHRsZSBFbmRpYW4KQWRkcmVzcyBzaXplczog
ICAgICAgMzkgYml0cyBwaHlzaWNhbCwgNDggYml0cyB2aXJ0dWFsCkNQVShzKTogICAgICAgICAg
ICAgIDQKT24tbGluZSBDUFUocykgbGlzdDogMC0zClRocmVhZChzKSBwZXIgY29yZTogIDEKQ29y
ZShzKSBwZXIgc29ja2V0OiAgNApTb2NrZXQocyk6ICAgICAgICAgICAxCk5VTUEgbm9kZShzKTog
ICAgICAgIDEKVmVuZG9yIElEOiAgICAgICAgICAgR2VudWluZUludGVsCkNQVSBmYW1pbHk6ICAg
ICAgICAgIDYKTW9kZWw6ICAgICAgICAgICAgICAgNjAKTW9kZWwgbmFtZTogICAgICAgICAgSW50
ZWwoUikgQ29yZShUTSkgaTUtNDQzMCBDUFUgQCAzLjAwR0h6ClN0ZXBwaW5nOiAgICAgICAgICAg
IDMKQ1BVIE1IejogICAgICAgICAgICAgMTY3NC43MjcKQ1BVIG1heCBNSHo6ICAgICAgICAgMzIw
MCwwMDAwCkNQVSBtaW4gTUh6OiAgICAgICAgIDgwMCwwMDAwCkJvZ29NSVBTOiAgICAgICAgICAg
IDU5ODYuMTYKVmlydHVhbGl6YXRpb246ICAgICAgVlQteApMMWQgY2FjaGU6ICAgICAgICAgICAz
MksKTDFpIGNhY2hlOiAgICAgICAgICAgMzJLCkwyIGNhY2hlOiAgICAgICAgICAgIDI1NksKTDMg
Y2FjaGU6ICAgICAgICAgICAgNjE0NEsKTlVNQSBub2RlMCBDUFUocyk6ICAgMC0zCkZsYWdzOiAg
ICAgICAgICAgICAgIGZwdSB2bWUgZGUgcHNlIHRzYyBtc3IgcGFlIG1jZSBjeDggYXBpYyBzZXAg
bXRyciBwZ2UgbWNhIGNtb3YgcGF0IHBzZTM2IGNsZmx1c2ggZHRzIGFjcGkgbW14IGZ4c3Igc3Nl
IHNzZTIgc3MgaHQgdG0gcGJlIHN5c2NhbGwgbnggcGRwZTFnYiByZHRzY3AgbG0gY29uc3RhbnRf
dHNjIGFyY2hfcGVyZm1vbiBwZWJzIGJ0cyByZXBfZ29vZCBub3BsIHh0b3BvbG9neSBub25zdG9w
X3RzYyBjcHVpZCBhcGVyZm1wZXJmIHBuaSBwY2xtdWxxZHEgZHRlczY0IG1vbml0b3IgZHNfY3Bs
IHZteCBlc3QgdG0yIHNzc2UzIHNkYmcgZm1hIGN4MTYgeHRwciBwZGNtIHBjaWQgc3NlNF8xIHNz
ZTRfMiB4MmFwaWMgbW92YmUgcG9wY250IHRzY19kZWFkbGluZV90aW1lciBhZXMgeHNhdmUgYXZ4
IGYxNmMgcmRyYW5kIGxhaGZfbG0gYWJtIGNwdWlkX2ZhdWx0IGVwYiBpbnZwY2lkX3NpbmdsZSBw
dGkgc3NiZCBpYnJzIGlicGIgc3RpYnAgdHByX3NoYWRvdyB2bm1pIGZsZXhwcmlvcml0eSBlcHQg
dnBpZCBlcHRfYWQgZnNnc2Jhc2UgdHNjX2FkanVzdCBibWkxIGF2eDIgc21lcCBibWkyIGVybXMg
aW52cGNpZCB4c2F2ZW9wdCBkdGhlcm0gaWRhIGFyYXQgcGxuIHB0cyBtZF9jbGVhciBmbHVzaF9s
MWQK


--=-DgnQFQ4zgEplvIMKoKcv
Content-Type: application/x-shellscript; name="test"
Content-Disposition: attachment; filename="test"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCnRlc3RmaWxlPS9Ob0JhY2t1cC90ZXN0ZmlsZQpsb2dmaWxlPS9ob21lL2Fu
ZHJlYS90cm91Ymxlc2hvb3RpbmcvMjAxOTA0MThfbGVudGV6emFEYXIvMjAxOTA0MThfbGVudGV6
emFEYXIudHh0Cm5Ucmllcz0kMSAjIE51bWJlciBvZiB0cmllcyB3ZSBkbwoKIyB1dWlkPSI2YTlk
M2MwNS02NzU4LTQ5YzAtYTQ2ZS02Y2UyMjE0NzhlYjMiICNPREQKIyB1dWlkPSIwNTE0MTIzOS00
ZWE1LTQ5NGQtYWE5MS1hY2Q2N2RiODljZTUiICMgRVZFTgojIHV1aWQ9ImNjYjdlZTZjLWNmOGQt
NGI4Ny1hZTlmLWEyZTEzZjVjMDBlOCIgIyBTU0QKdXVpZD0iZjg3NTQxZjAtZmM3Mi00NTQ0LTlm
MWMtZTNlZTUyMTJkYWY5IiAjRzMgYmlhbmNhCgplY2hvICJTdGFydGluZyAkblRyaWVzIHRyaWVz
IHdpdGg6IiB8IHRlZSAtYSAkbG9nZmlsZQp1bmFtZSAtYSB8IHRlZSAtYSAkbG9nZmlsZQpscyAt
bGggJHRlc3RmaWxlIDI+JjEgfCB0ZWUgLWEgJGxvZ2ZpbGUKYmxraWQgMj4mMSB8IHRlZSAtYSAk
bG9nZmlsZQplY2hvIC1uICJjYXQgL3N5cy9ibG9jay9zZGYvcXVldWUvc2NoZWR1bGVyIC0tPiAi
CmNhdCAvc3lzL2Jsb2NrL3NkZi9xdWV1ZS9zY2hlZHVsZXIgMj4mMSB8IHRlZSAtYSAkbG9nZmls
ZQpmb3IgKCggaz0xOyBrPD0kblRyaWVzOyBrKysgKSk7IGRvIAogIGVjaG8gLW4gIkluaXppbzog
IiB8IHRlZSAtYSAkbG9nZmlsZQogIGRhdGUgfCB0ciAtZCAiXG4iIHwgdGVlIC1hICRsb2dmaWxl
CiAgdG91Y2ggaW5pemlvIDI+JjEgfHRlZSAtYSAkbG9nZmlsZQogIG1vdW50IFVVSUQ9JHV1aWQg
L21udC9wZW5kcml2ZSAyPiYxIHx0ZWUgLWEgJGxvZ2ZpbGUKICBTRUNPTkRTPTAKICBjcCAkdGVz
dGZpbGUgL21udC9wZW5kcml2ZSAyPiYxIHx0ZWUgLWEgJGxvZ2ZpbGUKICB1bW91bnQgL21udC9w
ZW5kcml2ZSAyPiYxIHx0ZWUgLWEgJGxvZ2ZpbGUKICB0ZW1wbz0kU0VDT05EUwogIHRvdWNoIGZp
bmUgMj4mMSB8dGVlIC1hICRsb2dmaWxlCiAgZWNobyAtbiAiLi4uZmluZTogIiB8IHRlZSAtYSAk
bG9nZmlsZQogIGRhdGUgfCB0ciAtZCAiXG4iIHwgdGVlIC1hICRsb2dmaWxlCiAgZWNobyAiIC0t
PiBjaSBobyBtZXNzbyAkdGVtcG8gc2Vjb25kaSEiIHwgdGVlIC1hICRsb2dmaWxlCmRvbmUK


--=-DgnQFQ4zgEplvIMKoKcv--

