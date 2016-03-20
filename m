From: Helge Deller <deller@gmx.de>
Subject: Re: [BUG] "block: make generic_make_request handle arbitrarily sized
 bios" breaks boot on parisc-linux
Date: Sun, 20 Mar 2016 19:12:44 +0100
Message-ID: <56EEE81C.4080302@gmx.de>
References: <227C05EC-5A1C-4FAF-89D8-4A45AF600EC4@bell.net>
 <56E03E2A.5020208@bell.net> <56E093B6.4040206@gmx.de>
 <4070811.QJ02MzEnrO@caliban.sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <4070811.QJ02MzEnrO@caliban.sf-tec.de>
Sender: linux-parisc-owner@vger.kernel.org
To: Rolf Eike Beer <eike@sf-mail.de>
Cc: John David Anglin <dave.anglin@bell.net>, Ming Lei <tom.leiming@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-block@vger.kernel.org, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-parisc List <linux-parisc@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Eike,

On 10.03.2016 08:04, Rolf Eike Beer wrote:
>> Right.
>> I just succeeded in reproducing the bug with moving blk_bio_segment_split()
>> into an own file (and with "extern" instead of "static" in blk-merge.c).
>> When compiled with -O2 it still crashes. So, next step is to analyze what
>> gcc does wrong when compiling this function. It should get easier now to
>> find the reason, since we have a smaller reproducer now.
> 
> I have a ton of compilers here on my C8000 and a few even on my C3600 which 
> drive nightly CMake dashboards. Could you send the testcase so I can pass it 
> through the list and see what breaks?

Thanks for the offer!
Sadly it's not a stand-alone testcase, just the original source code extracted
which can be manually compiled and then the generated assembly can be compared
to what it should be.
That said, I think this specific testcase is not really usable in your test environment.

By the way, the bug was just fixed. Details are in bugzilla:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70188

Thanks,
Helge
