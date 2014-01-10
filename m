From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Fri, 10 Jan 2014 12:36:22 +0200
Message-ID: <CA+QCeVSen0d4=Yx1QWoH-TZ1c=g7jdG=rLq+FKg_ejBxFsR0sg@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org> <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
 <20140108152610.GA5863@infradead.org> <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
 <20140108205524.GA15313@quack.suse.cz> <CA+QCeVQuq4hM+kVfb8a2iMAUtF6QrR4sy=O-AuAgMoCWUsDg4w@mail.gmail.com>
 <20140110093623.GD26378@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48406 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaAJKgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 05:36:44 -0500
In-Reply-To: <20140110093623.GD26378@quack.suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>

Hi Jan,

On 10 January 2014 11:36, Jan Kara <jack@suse.cz> wrote:
> On Thu 09-01-14 12:11:16, Sergey Meirovich wrote:
...
>> I've done preallocation on fnic/XtremIO as Christoph suggested.
>>
>> [root@dca-poc-gtsxdb3 mnt]# sysbench --max-requests=0
>> --file-extra-flags=direct  --test=fileio --num-threads=4
>> --file-total-size=10G --file-io-mode=async --file-async-backlog=1024
>> --file-rw-ratio=1 --file-fsync-freq=0 --max-requests=0
>> --file-test-mode=seqwr --max-time=100 --file-block-size=4K prepare
>> sysbench 0.4.12:  multi-threaded system evaluation benchmark
>>
>> 128 files, 81920Kb each, 10240Mb total
>> Creating files for the test...
>> [root@dca-poc-gtsxdb3 mnt]# du -k test_file.* | awk '{print $1}' |sort |uniq
>> 81920
>> [root@dca-poc-gtsxdb3 mnt]# fallocate -l 81920k test_file.*
>>
>>              Results: 13.042Mb/sec 3338.73 Requests/sec
>>
>> Probably sysbench is still triggering append DIO scenario. Will say
>> simple wrapper over io_submit() against already preallocated (and even
>> filled with data) file provide much better throughput if your theory
>> is valid?
>   So I was experimenting a bit. "sysbench prepare" seems to always do
> synchronous IO from a single thread in the 'prepare' phase regardless of
> the arguments. So there the reported throughput isn't really relevant.
>
> In the 'run' phase it obeys the arguments and indeed when I run fallocate
> to preallocate files during 'run' phase, it significantly helps the
> throughput (from 20 MB/s to 55 MB/s on my SATA drive).

Sorry, Jan. Seems that I presented my findings in a previous mail in
ambiguous style . I know that prepare phase of sysbench is
synchronous/probably buffered (because I saw 512k chunks sent down to
HBA)? IO. I played with blocktrace and have seen that myself during
prepare:

[root@dca-poc-gtsxdb3 mnt]# sysbench --max-requests=0
--file-extra-flags=direct  --test=fileio --num-threads=4
--file-total-size=10G --file-io-mode=async --file-async-backlog=1024
--file-rw-ratio=1 --file-fsync-freq=0 --max-requests=0
--file-test-mode=seqwr --max-time=100 --file-block-size=4K prepare
...

Leads to:

[root@dca-poc-gtsxdb3 mnt]# blktrace -d /dev/sdg -o - | blkparse -i -
| grep 'D  W'
  8,96  14      604    53.129805520 28114  D  WS 1116160 + 1024 [sysbench]
  8,96  14      607    53.129843345 28114  D  WS 1120256 + 1024 [sysbench]
  8,96  14      610    53.129873782 28114  D  WS 1124352 + 1024 [sysbench]
  8,96  14      613    53.129903703 28114  D  WS 1128448 + 1024 [sysbench]
  8,96  14      616    53.130957213 28114  D  WS 1132544 + 1024 [sysbench]
  8,96  14      619    53.130988835 28114  D  WS 1136640 + 1024 [sysbench]
  8,96  14      622    53.131018854 28114  D  WS 1140736 + 1024 [sysbench]
...

That result  "13.042Mb/sec 3338.73 Requests/sec" was from run phase
and before it fallocate had been made.

blktrace from run phase looks very different. 4k as expected.
[root@dca-poc-gtsxdb3 ~]# blktrace -d /dev/sdg -o - | blkparse -i -  |
grep 'D  W'
  8,96   5        3     0.000001874 28212  D  WS 1847296 + 8 [sysbench]
  8,96   5        7     0.001213728 28212  D  WS 1847304 + 8 [sysbench]
  8,96   5       11     0.002779304 28212  D  WS 1847312 + 8 [sysbench]
  8,96   5       15     0.004486445 28212  D  WS 1847320 + 8 [sysbench]
  8,96   5       19     0.006012133 28212  D  WS 22691864 + 8 [sysbench]
  8,96   5       23     0.007781553 28212  D  WS 22691896 + 8 [sysbench]
  8,96   5       27     0.009043404 28212  D  WS 22691928 + 8 [sysbench]
  8,96   5       31     0.010546829 28212  D  WS 22691960 + 8 [sysbench]
  8,96   5       35     0.012214468 28212  D  WS 22691992 + 8 [sysbench]
  8,96   5       39     0.013792616 28212  D  WS 22692024 + 8 [sysbench]
...
