From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media change and delay
Date: Wed, 18 Jun 2008 10:47:39 +0200
Message-ID: <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:11951 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYFRIrl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2008 04:47:41 -0400
Received: by fk-out-0910.google.com with SMTP id 18so188220fkq.5
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2008 01:47:40 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, David Martin <tasio@tasio.net>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

On Fri, Jun 13, 2008 at 7:33 PM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:
> On Fri, 6 Jun 2008, Geert Uytterhoeven wrote:
>> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
>> from it, we get:
>
> Apparently the fix didn't make it to all the CCed lists...
>
> http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0

Oh, that's in mainline ? I still have the problem of having to
 insert DVD / try accessing it and get errors / eject / re-insert
 and then it magically works... the messages have changed
 from what they were as reported here

http://bugzilla.kernel.org/show_bug.cgi?id=10116

 (see comments #8 and #9) to these ones, in 2.6.26-rc6-git4:

Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Result:
hostbyte=0x00 driverbyte=0x08
Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Sense Key : 0x3 [current]
Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] ASC=0x11 ASCQ=0x0
Jun 17 22:38:43 sandman kernel: end_request: I/O error, dev sr0, sector 232
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 29
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 30
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 31
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 32
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 33
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 34
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 35
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 36
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 37
Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 38

here I eject and reinsert the disc, and:

Jun 17 22:39:10 sandman kernel: UDF-fs: No VRS found

 lo and behold, no problem.

This does not, alas, happen every time. It might be at the first
 DVD access after booting the laptop, but I haven't investigated
 in this detail yet.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
