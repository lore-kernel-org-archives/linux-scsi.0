Return-Path: <SRS0=DHhn=XN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66FAC4CEC4
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 15:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6966320665
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 15:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=unipv-it.20150623.gappssmtp.com header.i=@unipv-it.20150623.gappssmtp.com header.b="WiBQRrIE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfIRP0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Sep 2019 11:26:04 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:55002 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbfIRP0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Sep 2019 11:26:03 -0400
Received: by mail-wm1-f52.google.com with SMTP id p7so587115wmp.4
        for <linux-scsi@vger.kernel.org>; Wed, 18 Sep 2019 08:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unipv-it.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:references:in-reply-to
         :user-agent:mime-version:content-transfer-encoding;
        bh=o1NiwpQlQxFIhsf58RvC/ULPrZbQtdSFpgyYFWJaHCQ=;
        b=WiBQRrIEUJeVM6cyYkZ0SmPJNWZVqPf/KNMohqc3PAK57lOwADgQ9BxJxpEByEqyyZ
         eeeXXHBfPgTZYkcFNT3a9vn075CBxJCI15Gj1cPvba7G8ErIPTehbfABQXBoRA0wfxjg
         /e76T5fekhRJs3EzzWa+yFGTm4//+aq2ttYOUnLZioy39GmjYr+JjWFcGKsm0YqC3a8G
         Nw2X2fMAcHd6vkDtwbnIv2hj2Ag7vZiivX7NGqHKyvAdgIIovTnlb1OMn5R5rLXijpQJ
         z6Vn5IzoL3rQJ+ZlpO2u/MgFXlLW+NzcvK5y91wxRWGgfikrfF5L3eYu0Covzf8XjEjG
         HDlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:references
         :in-reply-to:user-agent:mime-version:content-transfer-encoding;
        bh=o1NiwpQlQxFIhsf58RvC/ULPrZbQtdSFpgyYFWJaHCQ=;
        b=jEHco4Ixe0+zzeg78qrkBp/SzRNDx5/wB2vf1qGjcmpWTPse/s/ttdUcDNaYzVznoh
         sT6IUfXY5f4I6O5F9MW3s/zCqOUnzGmuZYjb2UAIo/OhUH1qOjDf4aAC+fZxgaZvplfD
         6zEj3sEifEb8lqDLQVTxATq6KCpvWngQxuxfegLyq7vdIEumhT/mrT7mLKZ6nvLei7Cw
         AS2U65ZHR4OJLHc9qv9c3oLq3rfxqIq//6CAc3Ub/onAOcAyvZNfmP0LBwsp6nXWv4on
         pG66dMF7FOTM6ETwdrD14Z/l5GzYoLDPhc6aKe0ksOBolE/a2kFPtgKsq+bGmH3fBH7O
         u0yw==
X-Gm-Message-State: APjAAAW21zVAx3kJFyZtmOBAwCb2twVBoqvQ+Cf+DUzhYzom0O2Sf/76
        oeWo2bmsrLffAcSsTwRZT7H8Ug==
X-Google-Smtp-Source: APXvYqyw+BlI4Ri0DL++5YpcsZEmmsrpnrj0lAwP7P7XMb2/knuTamZZd+9VxB8KQfqwRl7En6ZjnA==
X-Received: by 2002:a7b:c401:: with SMTP id k1mr3320554wmi.62.1568820360951;
        Wed, 18 Sep 2019 08:26:00 -0700 (PDT)
Received: from angus.unipv.it (angus.unipv.it. [193.206.67.163])
        by smtp.gmail.com with ESMTPSA id g24sm8402997wrb.35.2019.09.18.08.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 08:26:00 -0700 (PDT)
Message-ID: <2196cc828e6d0651e6502a6dedeaeb14444cfe19.camel@unipv.it>
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
Date:   Wed, 18 Sep 2019 17:25:44 +0200
References: <ba1d4fe53258c7a710174723c99e002a4d9eecb0.camel@unipv.it>
         <Pine.LNX.4.44L0.1908261219060.1662-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1908261219060.1662-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Il giorno lun 26 ago 2019 alle ore 18:33 Alan Stern <
stern@rowland.harvard.edu> ha scritto:
> [...]
> In fact, even the traces where the file doesn't exist beforehand
> show 
> some delays.  Just not as many delays as the traces where the file
> does 
> exist.  And again, each delay is in the middle of a write command,
> not 
> between commands.
> 
> I suppose changes to the upper software layers could affect which
> blocks are assigned when a new file is written.  Perhaps one kernel
> re-uses the same old blocks that had been previously occupied and
> the
> other kernel allocates a completely new set of blocks.  That might
> change the drive's behavior.  The quick way to tell is to record two
> usbmon traces, one under the "good" kernel and one under the "bad"  
> kernel, where each test involves writing over a file that already
> exists (say, 50 MB) -- the same file for both tests.  The block
> numbers
> will appear in the traces.

ok, I performed 10 tests for each kernel, so we have 20 traces.
 
> Also, I wonder if the changing the size of the data transfers would
> make any difference.  This is easy to try; just write "64" to
> /sys/block/sd?/queue/max_sectors_kb (where the ? is the appropriate
> drive letter) after the drive is plugged in but before the test
> starts.

ok, so I duplicated the tests above for the "64" case (it was
initially set as "120", if it is relevant to know), leading to 40 tests named as

bad.mon.out_50000000_64_TIMESTAMP
bad.mon.out_50000000_non64_TIMESTAMP
good.mon.out_50000000_64_TIMESTAMP
good.mon.out_50000000_non64_TIMESTAMP

where "64" denotes the ones done with that value in max_sectors_kb,
and "not64" the ones without it (as far as I can tell, it has been
always "120").

So, we have 40 traces total. Each set of 10 trials is identified by
a text file, which contains the output log of the test script (and the
timestamps), also available in the download zipfile.

Just to summarize here the times, they are respectively (number
expressed  in seconds):

BAD:
  Logs: log_10trials_50MB_BAD_NonCanc_64.txt,
log_10trials_50MB_BAD_NonCanc_non64.txt
  64: 34, 34, 35, 39, 37, 32, 42, 44, 43, 40
  not64: 61, 71, 59, 71, 62, 75, 62, 70, 62, 68
GOOD:
  Logs: log_10trials_50MB_GOOD_NonCanc_64.txt,
log_10trials_50MB_GOOD_NonCanc_non64.txt
  64: 34, 32, 35, 34, 35, 33, 34, 33, 33, 33
  not64: 32, 30, 32, 31, 31, 30, 32, 30, 32, 31

Finally, one note about the workaround proposed by Alan, "delete the
file before copying". My original problem occurred while using a
backup software (dar - see http://dar.linux.free.fr/). So, I tried now
to do the backup by deleting the existing file beforehand, and it
still takes a lot of time with bad kernel: a 900 file backup takes
~160sec with GOOD kernel, and >40min with BAD kernel. I also tried the
"64" tweak in the BAD kernel and it becomes ~300s. Then, I also tried
the "64" case with good kernel, and became ~140s. Detailed data:

GOOD (not "64): 155s, 151s
GOOD ("64"): 142s, 141s

BAD (not "64"): 47minutes, 43minutes
BAD ("64"): 315s, 288s, 268s, 239s, 302s

The command ran is:
$ SECONDS=0; rm /run/media/andrea/BAK_ANDVAI/aero.1.dar && dar -c /run/media/andrea/BAK_ANDVAI/aero -R /home/andrea/Musica/MP3/Aerosmith && umount /run/media/andrea/BAK_ANDVAI; echo "Ci ho messo: $SECONDS secondi."

Speculations:
- It seems the "64" value plays a role, more evident on "bad" kernels
(~halves the time) and less (but still existing?) on "good" kernels;
- dar with the bad kernel, with the "delete beforehand" action, is
still an order of magnitude slower than with the good kernel (so, it
behaves the same way as in the "overwrite" case). Maybe it depends on
the way dar itself writes data... I don't know if you can understand
it, or we should ask for a light to the dar developer(s) about it.

You can grab the traces at

http://fisica.unipv.it/transfer/usbmon_logs_2.zip

Thanks, and bye
Andrea

