Return-Path: <SRS0=IeCF=WW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB3CC3A59E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E4C22190F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Aug 2019 06:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="eFHNk5zj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfHZGJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:09:35 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38571 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbfHZGJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2019 02:09:34 -0400
Received: by mail-wr1-f41.google.com with SMTP id g17so14083050wrr.5
        for <linux-scsi@vger.kernel.org>; Sun, 25 Aug 2019 23:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=SgNWo4yqA+qnnjTONuQt0z8uirv+Xr2PXPunzuDLHBA=;
        b=eFHNk5zjRXISWvGDiiNbeHUjB1+9I95SwFmrhHMulGY0z2P8F+7DXVTaleuWVNQq6L
         MNeesK1fIzp8pXCy8v+pLraWhPytcc9qSPJDdRMtYCKyy8HQIHDChy8v5K6ib+KHT7Q4
         g7y7acYcNgd84nd/zrEvi8C6g4JKm0Q6+PiM2cUgUakVt/KfE79Wtjr8uzQIE1BDBN6j
         Ss8NKVO7kyAHIz3yuOQIGj+kkyPzGuKa8dQPcs5sLrzGeQ9pHZo8l2RCaPLxSuVDefTA
         6yUPbMJ78eOPSI/wkafu9gFzsd4Qedg4+JE2hTcfXyXZGly0syHHILK3GXyteMUkBdMe
         iadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=SgNWo4yqA+qnnjTONuQt0z8uirv+Xr2PXPunzuDLHBA=;
        b=IZIff9SFWEa7iAycWePH6iTXJ53206+SBWl6K2Za+BphtpQ5Mh0m3JtAj/iDf6X8ij
         EMfHQw1vPi5+jrnJyn2d396X2S9iINB9FvxIiIIRdkalYE/lcOBghC4JcKWN9y/6R+UW
         wRprzT+Bvdn1ec3WNC8UZtbQccm6SbKB5GUQnsXGeqCcHs8pzBGnMFnIUWURBe0f+MWs
         dquBDD6zUAiNh3v7NRvOcxGmGeycRXRbuxs0jp4RYXE5wpt8i2at+LYApURjAophDuEC
         GEiOmkZSQ4xwVJyaTe4jIGk2UOdop4i4/IdI5i0e+mJfVBk1zS9g4XqwKf7VvG/IcVgi
         B2Gg==
X-Gm-Message-State: APjAAAUuxiVExzNBk/LiZcpqRI4v78sLoXyYPfsSQQdUVeFmCEQEQTzM
        Dco0RTnLFZkm+m+XWDpSFy4uMw==
X-Google-Smtp-Source: APXvYqweXD6XROjAcH8b1jJY/xyPKxtcyfSy0les0fwjFSJWqAe6p8tt1F3KP7spVN+fBTqWTVkwZw==
X-Received: by 2002:a05:6000:1041:: with SMTP id c1mr18904614wrx.99.1566799771403;
        Sun, 25 Aug 2019 23:09:31 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id e9sm10417439wrm.43.2019.08.25.23.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2019 23:09:30 -0700 (PDT)
Message-ID: <ba1d4fe53258c7a710174723c99e002a4d9eecb0.camel@unipv.it>
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
Date:   Mon, 26 Aug 2019 08:09:26 +0200
In-Reply-To: <Pine.LNX.4.44L0.1908231449390.1628-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1908231449390.1628-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[Sorry, I had previously sent the message to the list but has been
rejected. Sorry for any duplicate]

Il giorno ven, 23/08/2019 alle 16.42 -0400, Alan Stern ha scritto:
> On Fri, 23 Aug 2019, Andrea Vai wrote:
> 
> > Il giorno mar, 20/08/2019 alle 13.13 -0400, Alan Stern ha scritto:
> > > On Mon, 19 Aug 2019, Andrea Vai wrote:
> > > 
> > > > Hi Alan,
> > > >   I attach the two traces, collected as follows:
> > > > 
> > > > - start the trace;
> > > > - wait 10 seconds;
> > > > - plug the drive;
> > > > - wait 5 seconds;
> > > > - mount the drive;
> > > > - wait 5 seconds;
> > > > - copy a 500 byte file;
> > > > - wait 5 seconds;
> > > > - unmount the drive;
> > > > - wait 5 seconds;
> > > > - stop the trace.
> > > 
> > > Still no noticeable differences between the two traces.  They
> both 
> > > include a 1.2 second delay shortly after the writing starts, and
> > > the 
> > > initialization sequences are the same.
> > > 
> > > I really don't know where to look for this.  The only thing I
> can
> > > think
> > > of at this point is to repeat this test, but using a file large
> > > enough
> > > for the difference in writing speed to show up plainly.
> > > 
> > > By the way, it would be best to run the tests with the smallest
> > > possible number of other USB devices plugged in.  None at all,
> if
> > > you
> > > can arrange it.
> > 
> > Thanks, I went some steps further on this.
> > The following considerations all apply to the "bad" kernel.
> > 
> > Increasing the filesize lead me to find out that using a file
> sized
> > less than roughly 10MB the problem does not happen.
> > 
> > I found these results by making sets of 10 tries for each
> filesize,
> > using a filesize of 1kB, 10kB, 100kB, 1MB, 10MB, 100MB, 500MB (so,
> we
> > have 70 usbmon logs on these). If we define "fast" a copy that
> takes
> > (roughly(*)) no more time to complete than all the other tries in
> its
> > set, and "slow" elsewhere (=one or more tries in its set are
> > (sensibly(*)) faster), I noticed that in each set with a filesize
> of
> > 10MB or more the behavior can be very different: sometimes the
> copy is
> > still "fast", sometimes is "slow". The frequency of the "slow"
> copies
> > increases with the filesize. Also, among the "slow" copies in a
> set,
> > the time can be very different.
> > 
> > Also, I found that if the file is not present on the target
> location
> > (i.e. the USB pendrive), the problem does not happen (I have ten
> > usbmon logs here, taken in the worst scenario (500MB filesize)).
> > 
> > Tell me which log(s) would you like me to send you: I can sum up
> here
> > all the sets of tries, and the time their copies took to complete
> (in
> > seconds):
> > 
> > 1kB: 26, 27, 26, 26, 27, 26, 26, 27, 26, 27
> > 10kB: 27, 27, 26, 26, 27, 26, 27, 26, 27, 27
> > 100kB: 26, 26, 26, 27, 26, 26, 26, 27, 27, 27
> > 1MB: 26, 27, 27, 27, 27, 27, 27, 27, 27, 26
> > 10MB: 27, 31, 37, 27, 38, 27, 39, 27, 30, 28
> > 100MB: 32, 32, 144, 32, 145, 32, 123, 32, 153, 123
> > 500MB: 56, 1396, 747, 131, 795, 764, 292, 1021, 807, 516
> > 
> > Also, note that the first copy is always "fast", because each file
> was
> > initially not present on the pendrive. As said, I did one test of
> 10
> > tries by deleting the file on the pendrive before copying it
> again,
> > and the results are
> > 
> > 500MB: 56, 56, 57, 57, 56, 56, 60, 25***, 55, 56 (***Note the
> "fake"
> > 25s, doesn't matter because I forgot to plug the pendrive :-/ )
> > 
> > I have made a script to semi-automate all the tests I have done. I
> > attach the script here, so anyone interested could check it for
> any
> > mistake (remember I am not very skilled so I may have wrote buggy
> > code, done wrong assumptions, etc.). Please note that I decreased
> the
> > time between the trace start and the drive plugging from 10s to 5s
> > (simply to reduce the time needed to me to look at the countdown).
> Of
> > course I can do again the test(s) you need with a bigger amount of
> > $wait.
> > 
> > The script has been run with the command
> > 
> > # for k in {1..10}; do size=1000; ./test_usbmon $size && ping -a
> -c 5 8.8.8.8 ; done
> > (example for 1kB filesize)
> > 
> > or, in the set of "delete before copy",
> > 
> > # for k in {1..10}; do size=500000000; ./cancellaTestFile $size &&
> ./test_usbmon $size && ping -a -c 5 8.8.8.8 ; done
> > 
> > The ping command is there just to have a sound alarm when
> finished.
> > 
> > I also attach the script to delete the file ("cancellaTestFile").
> > 
> > I took care to plug the pendrive exactly at the end of the
> countdown,
> > to keep the times in the logs more simple to detect and manage by
> you.
> > 
> > I have also logged all the terminal output log of the script.
> > 
> > Last note: I ran all the tests without any other USB device
> connected
> > but the pendrive (well, actually there is a card reader connected
> to
> > the internal USB connector, but on another bus. I didn't want to
> open
> > the case and disconnect it but of course I can do it if needed).
> > Thanks for pointing it out.
> > 
> > Thanks, and bye
> > Andrea
> > 
> > (*) as an example, on a set that shows the total elapsed time in
> > seconds being
> > 
> > 26, 27, 27, 27, 27, 27, 27, 27, 27, 26
> > 
> > I have assumed all of the copies to be "fast", while in the set
> > 
> > 32, 32, 144, 32, 145, 32, 123, 32, 153, 123
> > 
> > I have assumed 5 of the copies as "fast" (the ones that took 32
> > seconds) and the other "slow". Not going to deepen in some
> standard
> > deviation evaluation, etc., but if you'd like to I can provide
> some
> > more scientific detailed data :-)
> 
> Wow, that sounds like a lot of work.

just a drop in the ocean, compared to yours :-)

> Let's start with the 39-second run for the 10-MB file.  If you can
> put 
> the trace files on a server somewhere, available for downloading,
> that 
> would avoid sending a lot of uninteresting data to the mailing list.

ok, so you can grab them at

http://fisica.unipv.it/transfer/usbmon_logs.zip

(they will be automatically removed from there in a couple of weeks).

For each size there is a .txt file (which contains the terminal
output) and 10 bad.mon.out_.... trace files. The file suffix "NonCanc"
means there has not been file deletion before copy; while "Canc" means
the opposite.

Each trace file name is identified by a timestamp that is also
referenced inside the txt, so if you want to get i.e. the 39-sec trial
for the 10MB filesize you have to open the ...10MB....txt, search for
the 39 seconds total time string ("Dopo stop trace: 39"), look at the
beginning of that trial, a dozen rows before, take note of the
timestamp, and open the corresponding bad.mon.out file (of course, if
there are more trials with the same time, you have to identify it by
counting its position (7th in the example above)).

To make it more simple:

$ seconds=39; size=10MB; grep -B14 "Dopo stop trace: $seconds" log_10trials_"$size"_NonCanc.txt

should show you more straightly the part(s) you need.

> Odd that the delays never occur when you're writing a new file.  (If
> nothing else, that gives you a way to work around the problem!) 

Thank you, didn't realize that :-) I will try it.

Thanks, and bye
Andrea


-- 
Andrea Vai
University of Pavia
Department of Physics
Via Bassi, 6
27100 Pavia PV
Tel. +39 0382 987489
Mob. +39 328 3354086

http://fisica.unipv.it
http://www.andreavai.it

