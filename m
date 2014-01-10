From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Fri, 10 Jan 2014 20:14:05 +0200
Message-ID: <CA+QCeVSC60xV3L6QfyeYdqTxiqCughXvpfHoidmDnmxrAka5xw@mail.gmail.com>
References: <20140107155830.GA28395@infradead.org> <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org> <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
 <20140108152610.GA5863@infradead.org> <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
 <20140108205524.GA15313@quack.suse.cz> <CA+QCeVQuq4hM+kVfb8a2iMAUtF6QrR4sy=O-AuAgMoCWUsDg4w@mail.gmail.com>
 <20140110093623.GD26378@quack.suse.cz> <CA+QCeVSen0d4=Yx1QWoH-TZ1c=g7jdG=rLq+FKg_ejBxFsR0sg@mail.gmail.com>
 <20140110104837.GG26378@quack.suse.cz> <CA+QCeVSC_tmB0_ka3fad-J+4GkYrDXUF1149oQ3HBTFwxfm4xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+QCeVSC_tmB0_ka3fad-J+4GkYrDXUF1149oQ3HBTFwxfm4xw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On 10 January 2014 16:32, Sergey Meirovich <rathamahata@gmail.com> wrote:
> Hi Jan,
>
> On 10 January 2014 12:48, Jan Kara <jack@suse.cz> wrote:
>> On Fri 10-01-14 12:36:22, Sergey Meirovich wrote:
>>> Hi Jan,
>>>
>>> On 10 January 2014 11:36, Jan Kara <jack@suse.cz> wrote:
>>> > On Thu 09-01-14 12:11:16, Sergey Meirovich wrote:
>>> ...
>>> >> I've done preallocation on fnic/XtremIO as Christoph suggested.
>>> >>
>>> >> [root@dca-poc-gtsxdb3 mnt]# sysbench --max-requests=0
>>> >> --file-extra-flags=direct  --test=fileio --num-threads=4
>>> >> --file-total-size=10G --file-io-mode=async --file-async-backlog=1024
>>> >> --file-rw-ratio=1 --file-fsync-freq=0 --max-requests=0
>>> >> --file-test-mode=seqwr --max-time=100 --file-block-size=4K prepare
>>> >> sysbench 0.4.12:  multi-threaded system evaluation benchmark
>>> >>
>>> >> 128 files, 81920Kb each, 10240Mb total
>>> >> Creating files for the test...
>>> >> [root@dca-poc-gtsxdb3 mnt]# du -k test_file.* | awk '{print $1}' |sort |uniq
>>> >> 81920
>>> >> [root@dca-poc-gtsxdb3 mnt]# fallocate -l 81920k test_file.*
>>> >>
>>> >>              Results: 13.042Mb/sec 3338.73 Requests/sec
>>> >>
>>> >> Probably sysbench is still triggering append DIO scenario. Will say
>>> >> simple wrapper over io_submit() against already preallocated (and even
>>> >> filled with data) file provide much better throughput if your theory
>>> >> is valid?
>>> >   So I was experimenting a bit. "sysbench prepare" seems to always do
>>> > synchronous IO from a single thread in the 'prepare' phase regardless of
>>> > the arguments. So there the reported throughput isn't really relevant.
>>> >
>>> > In the 'run' phase it obeys the arguments and indeed when I run fallocate
>>> > to preallocate files during 'run' phase, it significantly helps the
>>> > throughput (from 20 MB/s to 55 MB/s on my SATA drive).
>>>
>>> Sorry, Jan. Seems that I presented my findings in a previous mail in
>>> ambiguous style . I know that prepare phase of sysbench is
>>> synchronous/probably buffered (because I saw 512k chunks sent down to
>>> HBA)? IO. I played with blocktrace and have seen that myself during
>>> prepare:
>>>
>>> [root@dca-poc-gtsxdb3 mnt]# sysbench --max-requests=0
>>> --file-extra-flags=direct  --test=fileio --num-threads=4
>>> --file-total-size=10G --file-io-mode=async --file-async-backlog=1024
>>> --file-rw-ratio=1 --file-fsync-freq=0 --max-requests=0
>>> --file-test-mode=seqwr --max-time=100 --file-block-size=4K prepare
>>> ...
>>>
>>> Leads to:
>>>
>>> [root@dca-poc-gtsxdb3 mnt]# blktrace -d /dev/sdg -o - | blkparse -i -
>>> | grep 'D  W'
>>>   8,96  14      604    53.129805520 28114  D  WS 1116160 + 1024 [sysbench]
>>>   8,96  14      607    53.129843345 28114  D  WS 1120256 + 1024 [sysbench]
>>>   8,96  14      610    53.129873782 28114  D  WS 1124352 + 1024 [sysbench]
>>>   8,96  14      613    53.129903703 28114  D  WS 1128448 + 1024 [sysbench]
>>>   8,96  14      616    53.130957213 28114  D  WS 1132544 + 1024 [sysbench]
>>>   8,96  14      619    53.130988835 28114  D  WS 1136640 + 1024 [sysbench]
>>>   8,96  14      622    53.131018854 28114  D  WS 1140736 + 1024 [sysbench]
>>> ...
>>   Ah, ok. I misuderstood what you wrote then.
>>
>>> That result  "13.042Mb/sec 3338.73 Requests/sec" was from run phase
>>> and before it fallocate had been made.
>>>
>>> blktrace from run phase looks very different. 4k as expected.
>>> [root@dca-poc-gtsxdb3 ~]# blktrace -d /dev/sdg -o - | blkparse -i -  |
>>> grep 'D  W'
>>>   8,96   5        3     0.000001874 28212  D  WS 1847296 + 8 [sysbench]
>>>   8,96   5        7     0.001213728 28212  D  WS 1847304 + 8 [sysbench]
>>>   8,96   5       11     0.002779304 28212  D  WS 1847312 + 8 [sysbench]
>>>   8,96   5       15     0.004486445 28212  D  WS 1847320 + 8 [sysbench]
>>>   8,96   5       19     0.006012133 28212  D  WS 22691864 + 8 [sysbench]
>>>   8,96   5       23     0.007781553 28212  D  WS 22691896 + 8 [sysbench]
>>>   8,96   5       27     0.009043404 28212  D  WS 22691928 + 8 [sysbench]
>>>   8,96   5       31     0.010546829 28212  D  WS 22691960 + 8 [sysbench]
>>>   8,96   5       35     0.012214468 28212  D  WS 22691992 + 8 [sysbench]
>>>   8,96   5       39     0.013792616 28212  D  WS 22692024 + 8 [sysbench]
>>> ...
>>   Strange - I see:
>>   8,32   7        2     0.000086080     0  D  WS 1869752 + 1024 [swapper]
>>   8,32   7        7     0.041126425     0  D  WS 1874712 + 24 [swapper]
>>   8,32   7        6     0.041054543     0  D  WS 1871792 + 416 [swapper]
>>   8,32   7        7     0.041126425     0  D  WS 1874712 + 24 [swapper]
>>   8,32   6      118     0.042761949 28952  D  WS 1875416 + 528 [sysbench]
>>   8,32   6      143     0.042995928 28952  D  WS 1876888 + 48 [sysbench]
>>   8,32   5      352     0.045154160 28955  D  WS 1876936 + 168 [sysbench]
>>   8,32   6      444     0.045527660 28952  D  WS 1878296 + 992 [sysbench]
>>   ...
>>
>>   Not ideal but significantly better. The only idea I have: Didn't you run
>> fallocate(1) before you started the 'run' phase? Because 'run' phase
>> truncates the files before doing io to them. Can you check that during run
>> phase (after fallocate is run) the file size is constantly at 80MB?
>
> Jan, I believe your initial theory that append AIO is equal to
> Synchronous DIO is absolutely correct. I've given up  sysbench and
> written simple dirty wrapper around io_submit() and run it against
> preallocated file.. XtremIO is doing online deduplication so results
> were wonderful
>
> 694.25 MB/s  177728.84 Req/sec

And with this simple patch to the wrapper
--- 4k.c.orig    2014-01-10 10:09:34.059797854 -0800
+++ 4k.c    2014-01-10 10:07:43.377184860 -0800
@@ -25,7 +25,7 @@
     io_context_t ctx;
     int ret;

-    int flag = O_RDWR | O_DIRECT;
+    int flag = O_RDWR | O_DIRECT | O_CREAT;
     int fd = open(FNAME, flag);
         if (fd == -1) {
             printf("open(%s, %d) - failed!\nExiting.\n"


To tirgger append DIO results are indeed much worse:

root@dca-poc-gtsxdb3 mnt]# rm -f 4k.data
[root@dca-poc-gtsxdb3 mnt]# /root/4k
io_submit() accepted 524288 IOs
io_getevents() returned 524288 events
time elapsed (sec.):    172.203561
bandwidth (MiB/s):    11.89
IOps:            3044.58
[root@dca-poc-gtsxdb3 mnt]#


>
> [root@dca-poc-gtsxdb3 mnt]# dd if=/dev/zero of=4k.data bs=4096 count=524288
> 524288+0 records in
> 524288+0 records out
> 2147483648 bytes (2.1 GB) copied, 5.75357 s, 373 MB/s
> [root@dca-poc-gtsxdb3 mnt]# ./4k
> io_submit() accepted 524288 IOs
> io_getevents() returned 524288 events
> time elapsed (sec.):    2.949932d
> bandwidth (MiB/s):    694.25
> IOps:            177728.84
> [root@dca-poc-gtsxdb3 mnt]#
>
> ...
> [root@dca-poc-gtsxdb3 ~]# vmstat 1
> procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu-----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  0  0      0 260598160 260540 1896032    0    0     3    24   11   12
> 0  0 100  0  0
>  0  0      0 260598256 260544 1896032    0    0     0    16 1106  378
> 0  0 100  0  0
>  0  0      0 260598288 260544 1896032    0    0     0     0 1093  373
> 0  0 100  0  0
>  1  0      0 260499536 260544 1928368    0    0     0 293820 2782 1438
>  0  1 99  0  0
>  2  0      0 260484816 260544 1928804    0    0     0 820152 5575 3146
>  0  3 97  0  0
>  1  0      0 260481680 260544 1928804    0    0     0 710028 4844 2947
>  0  3 97  0  0
>  1  0      0 260548384 260544 1928804    0    0     0 273168 2187 1744
>  0  2 98  0  0
>  0  0      0 260549088 260544 1928804    0    0     0     4 1156  426
> 0  0 100  0  0
>  0  0      0 260549472 260544 1928804    0    0     0     0 1082  328
> 0  0 100  0  0
> ^C
> [root@dca-poc-gtsxdb3 ~]#
>
>
> ========================== io_submit() wrapper =============================
> #define _GNU_SOURCE
>
> #include <errno.h>
> #include <libaio.h>
>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <fcntl.h>
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
>
> #include <unistd.h>
> #include <sys/time.h>
>
>
> #define FNAME           "4k.data"
> #define IOSIZE          4096
> #define    REQUESTS    524288
>
> /*  gcc 4k.c -std=gnu99 -laio -o 4k */
>
> int main(void) {
>     io_context_t ctx;
>     int ret;
>
>     int flag = O_RDWR | O_DIRECT;
>     int fd = open(FNAME, flag);
>         if (fd == -1) {
>             printf("open(%s, %d) - failed!\nExiting.\n"
>             "If file doesn't exist please precreate it "
>             "with dd if=/dev/zero of=%s bs=%d count=%d\n",
>             FNAME, flag, FNAME, IOSIZE, REQUESTS);
>                 return errno;
>         }
>
>     memset(&ctx, 0, sizeof(io_context_t));
>     if (io_setup(REQUESTS, &ctx)) {
>         printf("io_setup(%d, &ctx) failed\n", REQUESTS);
>         return -ret;
>     }
>
>     void *mem = NULL;
>     posix_memalign(&mem, 4096, IOSIZE);
>         memset(mem, 9, IOSIZE);
>     struct iocb *aio = malloc(sizeof(struct iocb) * REQUESTS);
>     memset(aio, 0, sizeof(struct iocb) * REQUESTS);
>     struct iocb **lio = malloc(sizeof(void *) * REQUESTS);
>         memset(lio, 0, sizeof(void *) * REQUESTS);
>     struct io_event *event = malloc(sizeof(struct io_event) * REQUESTS);
>     memset(event, 0, sizeof(struct io_event) * REQUESTS);
>
>     for (int i = 0; i < REQUESTS; i++) {
>         io_prep_pwrite(&aio[i], fd, mem, IOSIZE, i * IOSIZE);
>         lio[i] = &aio[i];
>     }
>     struct timeval start, end;
>     gettimeofday(&start, NULL);
>     ret = io_submit(ctx, REQUESTS, lio);
>     printf("io_submit() accepted %d IOs\n", ret);
>     fdatasync(fd);
>
>     ret = io_getevents(ctx, REQUESTS, REQUESTS, event, NULL);
>     printf("io_getevents() returned %d events\n", ret);
>     gettimeofday(&end, NULL);
>
>     double elapsed = (end.tv_sec - start.tv_sec) +
>               ((end.tv_usec - start.tv_usec)/1000000.0);
>     printf("time elapsed (sec.):\t%2f\n", elapsed);
>         printf("bandwidth (MiB/s):\t%.2f\n",
>         (double) (((long long) IOSIZE * REQUESTS) / (1024 * 1024))
>             / elapsed);
>         printf("IOps:\t\t\t%.2f\n", (double) REQUESTS
>             / elapsed);
>
>     if (io_destroy(ctx)) {
>                 perror("io_destroy");
>                 return -1;
>         }
>
>     free(aio);
>     free(lio);
>     free(event);
>
>     return 0;
> }
>
>
>>
>>                                                                 Honza
>> --
>> Jan Kara <jack@suse.cz>
>> SUSE Labs, CR
