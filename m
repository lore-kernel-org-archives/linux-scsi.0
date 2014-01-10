From: Jan Kara <jack@suse.cz>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Fri, 10 Jan 2014 10:36:23 +0100
Message-ID: <20140110093623.GD26378@quack.suse.cz>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org>
 <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
 <20140108152610.GA5863@infradead.org>
 <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
 <20140108205524.GA15313@quack.suse.cz>
 <CA+QCeVQuq4hM+kVfb8a2iMAUtF6QrR4sy=O-AuAgMoCWUsDg4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+QCeVQuq4hM+kVfb8a2iMAUtF6QrR4sy=O-AuAgMoCWUsDg4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu 09-01-14 12:11:16, Sergey Meirovich wrote:
> Hi Jan,
> On 8 January 2014 22:55, Jan Kara <jack@suse.cz> wrote:
> >
> >> So far I've seen so massive degradation only in SAN environment. I
> >> started my investigation with RHEL6.5 kernel so below table is from it
> >> but the trend is the same as for mainline it seems.
> >>
> >> Chunk size Bandwidth MiB/s
> >> ================================
> >> 64M                512
> >> 32M                510
> >> 16M                492
> >> 8M                  451
> >> 4M                  436
> >> 2M                  350
> >> 1M                  256
> >> 512K               191
> >> 256K               165
> >> 128K               142
> >> 64K                 101
> >> 32K                 65
> >> 16K                 39
> >> 8K                   20
> >> 4K                   11
> >   Yes, that's expected. The latency to complete a request consists of some
> > fixed overhead + time to write data. So for small request sizes the latency
> > is constant (corresponding to bandwidth growing linearly with the request
> > size) and for larger request sizes latency somewhat grows so bandwidth grows
> > slower and slower (as the time to write the data forms larger and larger
> > part of the total latency)...
> 
> Why these latencies are not hurting random 4k on XtremIO so much? It
> gave 451.11Mb/sec 115485.02 Requests/sec
  If you are doing random IO (or any IO which doesn't update file size),
the IO is really asynchronous. So you have lots of IO requests running on
the storage at once. And you also have even more IO requests waiting in the
block layer which are sent to the storage at the moment when it reports
completion of some IO. So latency of a single request is *much* smaller.

> I've done preallocation on fnic/XtremIO as Christoph suggested.
> 
> [root@dca-poc-gtsxdb3 mnt]# sysbench --max-requests=0
> --file-extra-flags=direct  --test=fileio --num-threads=4
> --file-total-size=10G --file-io-mode=async --file-async-backlog=1024
> --file-rw-ratio=1 --file-fsync-freq=0 --max-requests=0
> --file-test-mode=seqwr --max-time=100 --file-block-size=4K prepare
> sysbench 0.4.12:  multi-threaded system evaluation benchmark
> 
> 128 files, 81920Kb each, 10240Mb total
> Creating files for the test...
> [root@dca-poc-gtsxdb3 mnt]# du -k test_file.* | awk '{print $1}' |sort |uniq
> 81920
> [root@dca-poc-gtsxdb3 mnt]# fallocate -l 81920k test_file.*
> 
>              Results: 13.042Mb/sec 3338.73 Requests/sec
> 
> Probably sysbench is still triggering append DIO scenario. Will say
> simple wrapper over io_submit() against already preallocated (and even
> filled with data) file provide much better throughput if your theory
> is valid?
  So I was experimenting a bit. "sysbench prepare" seems to always do
synchronous IO from a single thread in the 'prepare' phase regardless of
the arguments. So there the reported throughput isn't really relevant.

In the 'run' phase it obeys the arguments and indeed when I run fallocate
to preallocate files during 'run' phase, it significantly helps the
throughput (from 20 MB/s to 55 MB/s on my SATA drive).

								Honza
> 
>  ======================== iostat -x -t out ================================
> 01/09/2014 02:00:29 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.02    0.00    1.22    0.20    0.00   98.57
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.10  168.30     0.80  1346.40
> 8.00     0.07    0.39   0.39   6.56
> sdg               0.00     0.00    0.10  168.20     0.80  1345.60
> 8.00     0.06    0.34   0.34   5.66
> sdo               0.00     0.00    0.10  168.30     0.80  1346.40
> 8.00     0.07    0.41   0.41   6.97
> sdp               0.00     0.00    0.10  168.20     0.80  1345.60
> 8.00     0.07    0.41   0.41   6.88
> 
> 01/09/2014 02:00:39 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.08    0.00    1.03    1.69    0.00   97.20
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  903.90     0.00  7231.20
> 8.00     0.36    0.40   0.39  35.69
> sdg               0.00     0.00    0.00  903.90     0.00  7231.20
> 8.00     0.29    0.33   0.33  29.38
> sdo               0.00     0.00    0.00  903.80     0.00  7230.40
> 8.00     0.31    0.34   0.34  30.98
> sdp               0.00     0.00    0.00  903.90     0.00  7231.20
> 8.00     0.36    0.40   0.40  36.14
> 
> 01/09/2014 02:00:49 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.05    0.00    0.89    1.62    0.00   97.44
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.10  962.00     0.80  7696.00
> 8.00     0.36    0.37   0.37  35.85
> sdg               0.00     0.00    0.10  962.00     0.80  7696.00
> 8.00     0.31    0.32   0.32  30.57
> sdo               0.00     0.00    0.10  962.10     0.80  7696.80
> 8.00     0.35    0.36   0.36  34.56
> sdp               0.00     0.00    0.10  962.10     0.80  7696.80
> 8.00     0.38    0.40   0.40  38.39
> 
> 01/09/2014 02:00:59 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.05    0.00    0.93    1.99    0.00   97.02
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  914.00     0.00  7312.00
> 8.00     0.34    0.37   0.37  33.78
> sdg               0.00     0.00    0.00  914.10     0.00  7312.80
> 8.00     0.30    0.33   0.33  29.92
> sdo               0.00     0.00    0.00  914.00     0.00  7312.00
> 8.00     0.31    0.34   0.34  31.00
> sdp               0.00     0.00    0.00  914.00     0.00  7312.00
> 8.00     0.37    0.40   0.40  36.65
> 
> 01/09/2014 02:01:09 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.07    0.00    0.99    1.58    0.00   97.35
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.10  982.70     0.80  7861.60
> 8.00     0.36    0.37   0.37  36.36
> sdg               0.00     0.00    0.10  982.60     0.80  7860.80
> 8.00     0.32    0.33   0.33  32.21
> sdo               0.00     0.00    0.10  982.70     0.80  7861.60
> 8.00     0.33    0.34   0.34  33.01
> sdp               0.00     0.00    0.10  982.70     0.80  7861.60
> 8.00     0.40    0.41   0.40  39.76
> 
> 01/09/2014 02:01:19 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.04    0.00    0.80    2.01    0.00   97.15
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  767.60     0.00  6140.80
> 8.00     0.33    0.43   0.43  32.75
> sdg               0.00     0.00    0.00  767.60     0.00  6140.80
> 8.00     0.30    0.39   0.39  29.57
> sdo               0.00     0.00    0.00  767.60     0.00  6140.80
> 8.00     0.30    0.39   0.38  29.48
> sdp               0.00     0.00    0.00  767.60     0.00  6140.80
> 8.00     0.34    0.45   0.45  34.37
> 
> 01/09/2014 02:01:29 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.07    0.00    0.76    2.12    0.00   97.05
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.10  762.00     0.80  6096.00
> 8.00     0.32    0.42   0.42  31.86
> sdg               0.00     0.00    0.10  762.00     0.80  6096.00
> 8.00     0.30    0.39   0.39  29.86
> sdo               0.00     0.00    0.10  761.90     0.80  6095.20
> 8.00     0.32    0.42   0.42  32.07
> sdp               0.00     0.00    0.10  761.90     0.80  6095.20
> 8.00     0.34    0.44   0.44  33.59
> 
> 01/09/2014 02:01:39 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.05    0.00    0.82    1.79    0.00   97.34
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  779.40     0.00  6235.20
> 8.00     0.35    0.45   0.45  34.87
> sdg               0.00     0.00    0.00  779.40     0.00  6235.20
> 8.00     0.32    0.41   0.40  31.53
> sdo               0.00     0.00    0.00  779.50     0.00  6236.00
> 8.00     0.32    0.41   0.41  32.11
> sdp               0.00     0.00    0.00  779.50     0.00  6236.00
> 8.00     0.37    0.47   0.47  36.43
> 
> 01/09/2014 02:01:49 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.06    0.00    0.94    1.57    0.00   97.44
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.10  837.80     0.80  6702.40
> 8.00     0.33    0.40   0.40  33.25
> sdg               0.00     0.00    0.10  837.80     0.80  6702.40
> 8.00     0.28    0.34   0.34  28.46
> sdo               0.00     0.00    0.00  837.80     0.00  6702.40
> 8.00     0.32    0.38   0.38  31.77
> sdp               0.00     0.00    0.00  837.80     0.00  6702.40
> 8.00     0.34    0.41   0.41  34.25
> 
> 01/09/2014 02:01:59 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.05    0.00    0.97    1.82    0.00   97.16
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  871.80     0.00  7081.40
> 8.12     0.34    0.38   0.38  33.21
> sdg               0.00     0.00    0.00  871.80     0.00  7090.00
> 8.13     0.31    0.35   0.35  30.30
> sdo               0.00     0.00    0.10  871.80     0.80  7128.40
> 8.18     0.32    0.37   0.37  31.86
> sdp               0.00     0.00    0.10  871.80     0.80  7129.40
> 8.18     0.36    0.41   0.41  35.78
> 
> 01/09/2014 02:02:09 AM
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.03    0.00    0.46    0.83    0.00   98.69
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s
> avgrq-sz avgqu-sz   await  svctm  %util
> sdh               0.00     0.00    0.00  400.40     0.00  3203.20
> 8.00     0.17    0.42   0.42  16.80
> sdg               0.00     0.00    0.00  400.40     0.00  3203.20
> 8.00     0.14    0.36   0.36  14.25
> sdo               0.00     0.00    0.00  400.40     0.00  3203.20
> 8.00     0.15    0.37   0.37  14.67
> sdp               0.00     0.00    0.00  400.40     0.00  3203.20
> 8.00     0.16    0.40   0.40  16.05
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
