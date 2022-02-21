Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E459C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Feb 2022 15:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379676AbiBUPuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Feb 2022 10:50:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379555AbiBUPuk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2022 10:50:40 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E6924F19
        for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2022 07:50:16 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id c6so35279668ybk.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Feb 2022 07:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc
         :content-transfer-encoding;
        bh=D0WJ4EBeZkkbLtlCeWVpmkouqB1QZAU3gTPtgA4bq9Y=;
        b=UA/9O+x5p/iV9LrGR7l7s8KGtTTiCHHmXWdY87eUU7L8EURpiwk9qTRSDqMECnJDD1
         0tZhTqU3EI6Q+UPdCktYjlH50wDQkcHNGboKwWJQJkKfqSRCG4Wkuj7THwkibuUhZgBU
         EvPvgyB7cKfe7oZeoK04XvWM5NNIW2hNnLJdzLCS++rvKDYRmsmGBT1GElWo0rMRq+t/
         5/n6SeSb6Bz7BPqreQwuFntseD6CrA4ymseWIE4HJ/MZeZ11I7hqT74J7onWTOfsw6dt
         OHZKnCvetx3i5HyBMZ3gmgl4oKj3ngtr8VHM07509QgduX+H339n/8JIPdxcq6Cv/Rus
         S63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc:content-transfer-encoding;
        bh=D0WJ4EBeZkkbLtlCeWVpmkouqB1QZAU3gTPtgA4bq9Y=;
        b=hErIPMfCkHFXGQ2zjrD//Ea2sYLXOZ+XiH+pQZSliEyiverhqiwmeGPZXg2zeDUfbY
         EYdGAYO4Hk+EvRWDv66Tf5jG4NzawjwSguAO8V91rxd6PsHwWx4vDkKEYUsoPE6VOjWN
         /d3NiTNUROIMK1WqRJYXr8buO6i7SByQK76jboYPmYeoHX9vUXX90NGF1TdqpVynRyMN
         XBhGXSNE44d/zo6R3xnN/TVNHXGQ7C1lOch/GYQGrlYCnfBdtiAC1fATJp2aRRc52T78
         +LmE2HTEEhF6+eQ1nUQw2qs9elCgE/PsGnmCp+/q3ItQ/r3TWBdDkovi1mY6RtW150Qk
         wwsg==
X-Gm-Message-State: AOAM530x0DlIQBI8ToEXevgIUwIPfc6QJGHyDGBDO0hq1tgZxxVKdlAz
        27jL9N53hQOrcOitNzvVaqTb+CG/xVp2ZlhfS3e8q5KNgK8yWg==
X-Received: by 2002:a25:180b:0:b0:61a:a60:e7b0 with SMTP id
 11-20020a25180b000000b0061a0a60e7b0mt18989823yby.454.1645458616062; Mon, 21
 Feb 2022 07:50:16 -0800 (PST)
MIME-Version: 1.0
References: <CAJWTG89dq0-HDb=hSJMdT5WyArH3dy+SKZNXDEr9WOWsaUsMEg@mail.gmail.com>
 <20220221090558.yvkgw2lujwjodhfi@ws.net.home> <CAJWTG8-yrpLevVALX9ONnQGEgFcytYuhSk4ge_-qyi0tQS0keg@mail.gmail.com>
 <20220221130912.kboxxd2dga7edjkf@work> <YhOlbX0+0SxYl3Dq@T590>
In-Reply-To: <YhOlbX0+0SxYl3Dq@T590>
From:   Olaf Fraczyk <olaf.fraczyk@gmail.com>
Date:   Mon, 21 Feb 2022 16:50:05 +0100
Message-ID: <CAJWTG8-04u=-CWZ0yUcZXn-4kY2=qGBeEP_n4FMXQcOMiBAwZQ@mail.gmail.com>
Subject: Re: blkdiscard BLKDISCARD ioctl failed: Remote I/O error
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

You are right.
I moved the drive to onboard SATA controller and the problem disappeared.

As mpt3sas driver is from ELRepo (RedHat dropped support for this
controller in RHEL 8.x) I don't know if I should continue it here or
contact somebody from ELRepo?

Regards,
Olaf


pon., 21 lut 2022 o 15:45 Ming Lei <ming.lei@redhat.com> napisa=C5=82(a):
>
> On Mon, Feb 21, 2022 at 02:09:12PM +0100, Lukas Czerner wrote:
> > Hi,
> >
> > the problem is definitelly not in util-linux. In kernel there are check=
s
> > in place that would prevent proceeding with out of range BLKDISCARD ioc=
tl,
> > but that's not what we hit here.
> >
> > In the logs below you can see that the actual discard request failed,
> > but it appears to be well within the device range. I don't know what is
> > going on, maybe someone in the linux-block have a clue (adding to cc).
> >
> > Meanwhile please let us know what kernel version do you have and provid=
e
> > a blkparse output of the blkdiscard run. You can do this for example
> >
> > blktrace -a discard -d /dev/sdb -o - | \
> > blkparse -o output -f "%D %2c %8s %5T.%9t %6p %2a %3d %10S + %10U (%4e)=
 [%C]\n" -i -
> >
> > then run the blkdiscard and see the content of output file.
> >
> > Thanks!
> > -Lukas
> >
> >
> >
> > On Mon, Feb 21, 2022 at 01:34:57PM +0100, Olaf Fraczyk wrote:
> > > Hello,
> > >
> > > I had to put the disk in use, and I needed it in MBR format, so I can=
't
> > > create GPT now.
> > >
> > > Anyway, the reported size seems to be OK.
> > >
> > > I have created 3rd partition to go till the end of the disk, as below=
:
> > >
> > > Device     Boot      Start        End    Sectors   Size Id Type
> > > /dev/sdb1             2048    4196351    4194304     2G fd Linux raid
> > > autodetect
> > > /dev/sdb2          4196352 1874855935 1870659584   892G fd Linux raid
> > > autodetect
> > > /dev/sdb3       1874855936 1875385007     529072 258.3M 83 Linux
> > >
> > > I can fill it to the last sector using dd without problems:
> > >
> > > [root@vh3 ~]# dd if=3D/dev/zero of=3D/dev/sdb3 bs=3D1024 count=3D2645=
36
> > > 264536+0 records in
> > > 264536+0 records out
> > > 270884864 bytes (271 MB, 258 MiB) copied, 4.81622 s, 56.2 MB/s
> > >
> > > When I do blkdiscard:
> > >
> > > root@vh3 ~]# blkdiscard -l 264536K /dev/sdb3
> > > blkdiscard: /dev/sdb3: BLKDISCARD ioctl failed: Remote I/O error
> > > [root@vh3 ~]# blkdiscard -l 264535K /dev/sdb3
> > > [root@vh3 ~]#
> > >
> > > In the /var/log/messages for the failed discard I get:
> > > Feb 21 13:19:52 vh3 kernel: sd 1:0:1:0: [sdb] tag#2227 FAILED Result:
> > > hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE cmd_age=3D0s
> > > Feb 21 13:19:52 vh3 kernel: sd 1:0:1:0: [sdb] tag#2227 Sense Key : Il=
legal
> > > Request [current]
> > > Feb 21 13:19:52 vh3 kernel: sd 1:0:1:0: [sdb] tag#2227 Add. Sense: Lo=
gical
> > > block address out of range
> > > Feb 21 13:19:52 vh3 kernel: sd 1:0:1:0: [sdb] tag#2227 CDB: Unmap/Rea=
d
> > > sub-channel 42 00 00 00 00 00 00 00 18 00
> > > Feb 21 13:19:52 vh3 kernel: blk_update_request: critical target error=
, dev
> > > sdb, sector 1874855936 op 0x3:(DISCARD) flags 0x800 phys_seg 1 prio c=
lass 0
> > >
> > > I have the drive on a SAS controller - mpt3sas driver, LSI SAS2008
>
> Looks one target issue, CC linux-scsi and mpt3sas guys.
>
> > > > >
> > > > > I tried to trim entire drive but I get the following error:
> > > > > [root@vh3 util-linux-2.38-rc1]# ./blkdiscard /dev/sdb
> > > > > lt-blkdiscard: /dev/sdb: BLKDISCARD ioctl failed: Remote I/O erro=
r
> > > > >
> > > > > I have done strace and I see:
> > > > > ioctl(3, BLKGETSIZE64, [960197124096])  =3D 0
> > > > > ioctl(3, BLKSSZGET, [512])              =3D 0
> > > > > ioctl(3, BLKDISCARD, [0, 960197124096]) =3D -1 EREMOTEIO (Remote =
I/O error)
> > > > >
> > > > > When I do the same giving length explicitly I get the same error.
> > > > >
> > > > > However when I specify the length 512 bytes smaller, it works wit=
hout a
> > > > > problem:
> > > > >
> > > > > ioctl(3, BLKGETSIZE64, [960197124096])  =3D 0
> > > > > ioctl(3, BLKSSZGET, [512])              =3D 0
> > > > > ioctl(3, BLKDISCARD, [0, 960197123584]) =3D 0
>
>
> Thanks,
> Ming
>
