Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 965A9C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 10:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C442233A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 10:40:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="vy3pLSR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733288AbfHWKkJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 06:40:09 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43439 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbfHWKkI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Aug 2019 06:40:08 -0400
Received: by mail-wr1-f52.google.com with SMTP id y8so8168025wrn.10
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 03:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=38x9sYxmrUrxzTsoHeKR33Vu19XABcai3LfO1v6FfvA=;
        b=vy3pLSR49Dj4/Aw9n2hN43RfUBEox+aJLvICuMkkppJFOcHtGo23MCUjQ0i4lWcDHM
         pJdbsw95Jtuag72+tPh/GNyWx7kDdLz9KKepqvUdsjfBVtw7Wi/t1x3VmVHACTH7OHGA
         VuMfu1/gmBWwxM5whgagPI1yjWwDT7AZ1tBrDnZQq6z0XVGkvYqEAi51ldg9KKbjMEwi
         c7GPm9UFFRwRUGcuVqX+K+F5/+7I7lljw0d5FJEdzCvzfzBJruscy65QAjm0WqLxVXFB
         nTgABtldtUy0he5rxz67fsnQtO4AAIIaBg6XZK4G8wSq8EH3GSM3XnRuJ9IozUXAf+1q
         g2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version;
        bh=38x9sYxmrUrxzTsoHeKR33Vu19XABcai3LfO1v6FfvA=;
        b=XUlIaCrgrSV8DEQNEV/ZSwBeP5BuDsBh90j7ibcPEtwx13N1mFpmvEDZWdg36pJepj
         IrD4wp7Ovscupu3MkJBKAht5mEkFlZEVNX4sNR6348Cw6eaTxDmShbunWFaaFtQqj883
         1M8JYrcpMg+1LsDqc1QRusIWzQ54vGXEGtw+nx654pT2m65swTi3b41FySiKaTSE1CsI
         sRZdYUEGKlYTFxgw66tqsHyftCBnbZZadwRj40kU6BKPZnhO3UpesaDoJyOQtEsr1hPN
         Di4nCz2m9qCMNUu7OqO7eMgo2lAlD/D2Y7c86nNUU42mQUe608r/XPgKV0yDG5NgnZFq
         7MDQ==
X-Gm-Message-State: APjAAAXLX3cp3AfB2jSdhDTzSVJvo0nf+LzGjYBMfWWBlWuw5W0E+4C9
        VJp1ZT8+iK+P4VcURWxTnwb2vhkiUrPH7g==
X-Google-Smtp-Source: APXvYqwfZZGHkmJ+BZ8lW0PXHjJWg0kLouehZ6p5xP8GIMeYkjLvusGlgoQONxWi2OM+MLe4Dxbwdg==
X-Received: by 2002:a5d:4ec6:: with SMTP id s6mr4186745wrv.327.1566556805430;
        Fri, 23 Aug 2019 03:40:05 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id x6sm2639577wmf.6.2019.08.23.03.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 03:40:04 -0700 (PDT)
Message-ID: <9b06f6f469ea535d336945992242e32b6524cb2b.camel@unipv.it>
Subject: Re: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
From:   Andrea Vai <andrea.vai@unipv.it>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date:   Fri, 23 Aug 2019 12:39:51 +0200
In-Reply-To: <Pine.LNX.4.44L0.1908201307540.1573-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1908201307540.1573-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed; boundary="=-/gSDmaPIaOWv7ywMbimM"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--=-/gSDmaPIaOWv7ywMbimM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Il giorno mar, 20/08/2019 alle 13.13 -0400, Alan Stern ha scritto:
> On Mon, 19 Aug 2019, Andrea Vai wrote:
> 
> > Hi Alan,
> >   I attach the two traces, collected as follows:
> > 
> > - start the trace;
> > - wait 10 seconds;
> > - plug the drive;
> > - wait 5 seconds;
> > - mount the drive;
> > - wait 5 seconds;
> > - copy a 500 byte file;
> > - wait 5 seconds;
> > - unmount the drive;
> > - wait 5 seconds;
> > - stop the trace.
> 
> Still no noticeable differences between the two traces.  They both 
> include a 1.2 second delay shortly after the writing starts, and
> the 
> initialization sequences are the same.
> 
> I really don't know where to look for this.  The only thing I can
> think
> of at this point is to repeat this test, but using a file large
> enough
> for the difference in writing speed to show up plainly.
> 
> By the way, it would be best to run the tests with the smallest
> possible number of other USB devices plugged in.  None at all, if
> you
> can arrange it.

Thanks, I went some steps further on this.
The following considerations all apply to the "bad" kernel.

Increasing the filesize lead me to find out that using a file sized
less than roughly 10MB the problem does not happen.

I found these results by making sets of 10 tries for each filesize,
using a filesize of 1kB, 10kB, 100kB, 1MB, 10MB, 100MB, 500MB (so, we
have 70 usbmon logs on these). If we define "fast" a copy that takes
(roughly(*)) no more time to complete than all the other tries in its
set, and "slow" elsewhere (=one or more tries in its set are
(sensibly(*)) faster), I noticed that in each set with a filesize of
10MB or more the behavior can be very different: sometimes the copy is
still "fast", sometimes is "slow". The frequency of the "slow" copies
increases with the filesize. Also, among the "slow" copies in a set,
the time can be very different.

Also, I found that if the file is not present on the target location
(i.e. the USB pendrive), the problem does not happen (I have ten
usbmon logs here, taken in the worst scenario (500MB filesize)).

Tell me which log(s) would you like me to send you: I can sum up here
all the sets of tries, and the time their copies took to complete (in
seconds):

1kB: 26, 27, 26, 26, 27, 26, 26, 27, 26, 27
10kB: 27, 27, 26, 26, 27, 26, 27, 26, 27, 27
100kB: 26, 26, 26, 27, 26, 26, 26, 27, 27, 27
1MB: 26, 27, 27, 27, 27, 27, 27, 27, 27, 26
10MB: 27, 31, 37, 27, 38, 27, 39, 27, 30, 28
100MB: 32, 32, 144, 32, 145, 32, 123, 32, 153, 123
500MB: 56, 1396, 747, 131, 795, 764, 292, 1021, 807, 516

Also, note that the first copy is always "fast", because each file was
initially not present on the pendrive. As said, I did one test of 10
tries by deleting the file on the pendrive before copying it again,
and the results are

500MB: 56, 56, 57, 57, 56, 56, 60, 25***, 55, 56 (***Note the "fake"
25s, doesn't matter because I forgot to plug the pendrive :-/ )

I have made a script to semi-automate all the tests I have done. I
attach the script here, so anyone interested could check it for any
mistake (remember I am not very skilled so I may have wrote buggy
code, done wrong assumptions, etc.). Please note that I decreased the
time between the trace start and the drive plugging from 10s to 5s
(simply to reduce the time needed to me to look at the countdown). Of
course I can do again the test(s) you need with a bigger amount of
$wait.

The script has been run with the command

# for k in {1..10}; do size=1000; ./test_usbmon $size && ping -a -c 5 8.8.8.8 ; done
(example for 1kB filesize)

or, in the set of "delete before copy",

# for k in {1..10}; do size=500000000; ./cancellaTestFile $size && ./test_usbmon $size && ping -a -c 5 8.8.8.8 ; done

The ping command is there just to have a sound alarm when finished.

I also attach the script to delete the file ("cancellaTestFile").

I took care to plug the pendrive exactly at the end of the countdown,
to keep the times in the logs more simple to detect and manage by you.

I have also logged all the terminal output log of the script.

Last note: I ran all the tests without any other USB device connected
but the pendrive (well, actually there is a card reader connected to
the internal USB connector, but on another bus. I didn't want to open
the case and disconnect it but of course I can do it if needed).
Thanks for pointing it out.

Thanks, and bye
Andrea

(*) as an example, on a set that shows the total elapsed time in
seconds being

26, 27, 27, 27, 27, 27, 27, 27, 27, 26

I have assumed all of the copies to be "fast", while in the set

32, 32, 144, 32, 145, 32, 123, 32, 153, 123

I have assumed 5 of the copies as "fast" (the ones that took 32
seconds) and the other "slow". Not going to deepen in some standard
deviation evaluation, etc., but if you'd like to I can provide some
more scientific detailed data :-)


--=-/gSDmaPIaOWv7ywMbimM
Content-Type: application/x-shellscript; name="test_usbmon"
Content-Disposition: attachment; filename="test_usbmon"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCiMgc3RhcnQgdGhlIHRyYWNlOwojIHdhaXQgNSBzZWNvbmRzOyAjTkIgRVJB
IDEwIQojIHBsdWcgdGhlIGRyaXZlOwojIHdhaXQgNSBzZWNvbmRzOwojIG1vdW50IHRoZSBkcml2
ZTsKIyB3YWl0IDUgc2Vjb25kczsKIyBjb3B5IGEgMTAwTUIgZmlsZTsKIyB3YWl0IDUgc2Vjb25k
czsKIyB1bm1vdW50IHRoZSBkcml2ZTsKIyB3YWl0IDUgc2Vjb25kczsKIyBzdG9wIHRoZSB0cmFj
ZS4KCgpkaW1lbnNpb25lPSQxICMgaW4gQllURVMhCndhaXQ9NSAjIFNlY29uZGkgZGEgYXR0ZW5k
ZXJlIHBlciBpbnNlcmlyZSBsYSBwZW5kcml2ZSAjTkIgRVJBIDEwIQoKdGVzdGZpbGU9L05vQmFj
a3VwL3Rlc3RmaWxlXyRkaW1lbnNpb25lCmVjaG8gLW4gIlVzaW5nIHRlc3RmaWxlICR0ZXN0Zmls
ZS4uLiIKaWYgWyAhIC1lICR0ZXN0ZmlsZSBdCnRoZW4KICBlY2hvICIgZmlsZSBkb2Vzbid0IGV4
aXN0ICh5ZXQpLCBjcmVhdGluZy4uLiIKICBkZCBpZj0vZGV2L3VyYW5kb20gb2Y9JHRlc3RmaWxl
IGJzPSRkaW1lbnNpb25lIGNvdW50PTEgaWZsYWc9ZnVsbGJsb2NrIHN0YXR1cz1wcm9ncmVzcwpl
bHNlCiAgZWNobyAiIChmaWxlIGlzIGFscmVhZHkgcHJlc2VudCkiCmZpCgplY2hvICJTVEFDQ0Eg
VFVUVEkgR0xJIFVTQiEgQU5DSEUgTEEgUEVORFJJVkUhIgpyZWFkIC1wICJQcmVtaSBJTlZJTyBw
ZXIgY29udGludWFyZSwgbyBjdHJsK0MgcGVyIGFubnVsbGFyZS4uLiIKCnRpbWVzdGFtcD0kKGRh
dGUgKyIlWSVtJWRfJUglTSVTIikKZWNobyAiVGltZXN0YW1wOiAkdGltZXN0YW1wIgpTRUNPTkRT
PTAKCmNhdCAvc3lzL2tlcm5lbC9kZWJ1Zy91c2IvdXNibW9uLzN1ID4gYmFkLm1vbi5vdXRfIiRk
aW1lbnNpb25lIl8kdGltZXN0YW1wICYKZm9yICgoaT0wOyBpPD0kKCgkd2FpdC0xKSk7IGkrKykp
CmRvCiAgZWNobyAiUGx1ZyB0aGUgZHJpdmUgaW4gJCgoJHdhaXQtJGkpKSBzZWNvbmRzLi4uIgog
IHNsZWVwIDEKZG9uZQplY2hvICJQbHVnIHRoZSBkcml2ZSEiCnNsZWVwIDUKZWNobyAiUHJpbWEg
ZGkgbW91bnQ6ICRTRUNPTkRTIgojIG1vdW50IFVVSUQ9IjA1MTQxMjM5LTRlYTUtNDk0ZC1hYTkx
LWFjZDY3ZGI4OWNlNSIgL21udC9wZW5kcml2ZSAjIEVWRU4KbW91bnQgVVVJRD0iNmE5ZDNjMDUt
Njc1OC00OWMwLWE0NmUtNmNlMjIxNDc4ZWIzIiAvbW50L3BlbmRyaXZlICMgT0RECmVjaG8gIkRv
cG8gbW91bnQ6ICRTRUNPTkRTIgpzbGVlcCA1CmVjaG8gIlByaW1hIGRpIGNwOiAkU0VDT05EUyIK
Y3AgJHRlc3RmaWxlIC9tbnQvcGVuZHJpdmUvCmVjaG8gIkRvcG8gY3A6ICRTRUNPTkRTIgpzbGVl
cCA1CmVjaG8gIlByaW1hIGRpIHVubW91bnQ6ICRTRUNPTkRTIgp1bW91bnQgL21udC9wZW5kcml2
ZQplY2hvICJEb3BvIHVubW91bnQ6ICRTRUNPTkRTIgpzbGVlcCA1CmVjaG8gIlByaW1hIGRpIHN0
b3AgdHJhY2U6ICRTRUNPTkRTIgpraWxsYWxsIGNhdAplY2hvICJEb3BvIHN0b3AgdHJhY2U6ICRT
RUNPTkRTIgplY2hvICIuLi5yZW1lbWJlciB0byB1bnBsdWcgdGhlIGRyaXZlLCBpZiB5b3Ugd2lz
aCB0byBkbyBhbm90aGVyIHVzYm1vbiB0ZXN0LiIKIyBzcGQtc2F5ICJBbmRyZWEsIGhvIGZpbml0
byEiCmV4aXQgMAo=


--=-/gSDmaPIaOWv7ywMbimM
Content-Type: application/x-shellscript; name="cancellaTestFile"
Content-Disposition: attachment; filename="cancellaTestFile"
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCmRpbWVuc2lvbmU9JDEgIyBpbiBCWVRFUyEKdGVzdGZpbGU9L21udC9wZW5k
cml2ZS90ZXN0ZmlsZV8kZGltZW5zaW9uZQoKIyBtb3VudCBVVUlEPSIwNTE0MTIzOS00ZWE1LTQ5
NGQtYWE5MS1hY2Q2N2RiODljZTUiIC9tbnQvcGVuZHJpdmUgIyBFVkVOCm1vdW50IFVVSUQ9IjZh
OWQzYzA1LTY3NTgtNDljMC1hNDZlLTZjZTIyMTQ3OGViMyIgL21udC9wZW5kcml2ZSAjIE9ERAoK
cm0gLXYgJHRlc3RmaWxlCgp1bW91bnQgL21udC9wZW5kcml2ZQoKZWNobyAiT0ssIHNtb250YXRv
LiIKCmV4aXQgMAo=


--=-/gSDmaPIaOWv7ywMbimM--

