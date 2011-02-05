From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over
 10GbE?
Date: Sat, 5 Feb 2011 16:05:55 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan> <20110205214550.3cb0f0d1@galadriel2.home>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1696410560-1296939955=:8518"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110205214550.3cb0f0d1@galadriel2.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1696410560-1296939955=:8518
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 5 Feb 2011, Emmanuel Florac wrote:

> Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous =C3=A9criviez:
>

To respond to everyone:

> Did you try launching 4 simultaneous cp operations over nfs to get to=20
> 1.2 GB/s?
>  I've witnessed single stream copy performance with Samba being less than
> maximum due to Samba limitations.  Running multiple copy ops in parallel =
then
> usually saturates the pipe.


I tried 4 simultaenous cp's and there was little change, 250-320MiB/s.

Reader: 250MiB/s-300MiB/s
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu=
------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id=
 wa st
  0  6      0 927176  16076 2886308    0    0 206416     0 26850 40663  0  =
4 86 10  0
  0  0      0 925620  16076 2887768    0    0 261620     0 31057 61111  0  =
6 86  8  0
  0  0      0 923928  16076 2889016    0    0 328852     0 40954 102136  0 =
 8 90  2  0
  5  2      0 921112  16076 2890780    0    0 343476     0 39469 97957  0  =
8 90  2  0

Writer (its almost as if its caching the data and writing it out in
1.2-1.3Gbyte/sec chunks..
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu=
------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id=
 wa st
  7  0    232  13980    408 3746900    0    0     0 1351926 37877 81924  2 =
32 61  5  0
  6  0    232  12740    404 3748308    0    0     0 1336768 38822 86505  2 =
31 62  5  0
  4  0    232  12524    404 3744672    0    0     0 1295000 39368 91005  1 =
30 63  5  0
  6  0    232  12304    404 3748148    0    0     0 1332776 39351 86929  2 =
31 62  5  0

I also noticed this: 'FS-Cache: Loaded'
Could this be slowing things down?

********* [Desktop test below]
When I copy on my desktop (Debian) systems, it transfers immediately:

  0  0   9172  83648 2822716 3343120    0    0    52   320 4249 3682  2  1 =
97  0
  0  0   9172  86532 2822716 3343176    0    0     0     0 4362 3074  0  1 =
99  0
  0  4   9172  62924 2822716 3363572    0    0 94212     0 5083 3044  1  3 =
90  7
  1  7   9172  63444 2822708 3364008    0    0 360448    32 19058 8825  0 1=
5 48 37
  0  5   9172  61828 2821692 3367004    0    0 491520     0 26283 15282  0 =
24 43 32
  0  5   9172  59212 2821672 3373292    0    0 524288     0 28810 17370  0 =
27 33 40
  3  6   9172  57620 2821660 3355500    0    0 469364   128 25399 15825  0 =
21 42 36
********* [End of desktop test]

When I transfer using CentOS 5.5, there are a bunch of little reads, then i=
t
averages out at around 250MiB/s:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu=
------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id=
 wa st
  0  0      0 871088  16108 2942808    0    0  4091     3  552 1165  0  2 9=
6  2  0
  0  0      0 871088  16108 2942808    0    0     0     0 1013 2342  0  0 1=
00  0  0
  0  0      0 871224  16108 2942808    0    0     0     0 1031 2375  0  0 1=
00  0  0
  0  8      0 870864  16108 2942808    0    0   288     0 1071 2396  0  0 8=
6 14  0
  2  0      0 868636  16108 2943256    0    0   160     0 6348 18642  0  0 =
80 19  0
  0  0      0 868884  16116 2943248    0    0     0    28 31717 99894  0  4=
 96  0  0
  1  0      0 467040  16116 3343524    0    0 401444     0 40241 105777  0 =
 4 93  4  0
  2  1      0  12300   8540 3802792    0    0 482668     0 44694 116988  0 =
 6 88  6  0
  1  0      0  12412   3528 3805056    0    0 480124     0 44765 112272  0 =
 6 88  6  0
  0  8      0  17560   3528 3798900    0    0 388288     0 37987 68367  0  =
5 85 10  0
  1  7      0  17868   3528 3802172    0    0 323296     0 33470 38398  0  =
5 83 11  0
  1  7      0  17260   3524 3801688    0    0 299584     0 30991 35153  0  =
5 83 11  0
  0  8      0  17272   3512 3802208    0    0 304352     0 31463 35400  0  =
5 84 11  0
  0  8      0  17228   3512 3801476    0    0 258816     0 27035 30651  0  =
4 84 1

Is there a way to disable the VFS/page cache some how to avoid whatever
FS-Cache is doing?

> Ok, could you do the following:
> dd if=3D/dev/urandom of=3Dhugefile bs=3D1M count=3D<c>
> Where <c> is chosen so the resulting file is 2-3 times the RAM available
> in your server.
> Then redo the dd to null. Let's also check with the rsize from the nfs.
> /usr/bin/time -v dd if=3Dhugefile of=3D/dev/null bs=3D<rsize used by NFS>
I also have tried rsize/wsize of 65536 with NFS, no difference there, rsize
and wsize back the default, 8192 I believe.

221M    hugefile
223M    hugefile
226M    hugefile
229M    hugefile
232M    hugefile

Had to skip urandom, too slow (7MiB/s or so)..

# dd if=3D/dev/zero of=3Dhugefile bs=3D1M count=3D16384
16384+0 records in
16384+0 records out
17179869184 bytes (17 GB) copied, 14.6305 seconds, 1.2 GB/s


# /usr/bin/time -v dd if=3Dhugefile of=3D/dev/null bs=3D8192
2097152+0 records in
2097152+0 records out
17179869184 bytes (17 GB) copied, 14.7656 seconds, 1.2 GB/s
         Command being timed: "dd if=3Dhugefile of=3D/dev/null bs=3D8192"
         User time (seconds): 2.45
         System time (seconds): 8.70
         Percent of CPU this job got: 75%
         Elapsed (wall clock) time (h:mm:ss or m:ss): 0:14.76
         Average shared text size (kbytes): 0
         Average unshared data size (kbytes): 0
         Average stack size (kbytes): 0
         Average total size (kbytes): 0
         Maximum resident set size (kbytes): 0
         Average resident set size (kbytes): 0
         Major (requiring I/O) page faults: 2
         Minor (reclaiming a frame) page faults: 216
         Voluntary context switches: 57753
         Involuntary context switches: 1843
         Swaps: 0
         File system inputs: 0
         File system outputs: 0
         Socket messages sent: 0
         Socket messages received: 0
         Signals delivered: 0
         Page size (bytes): 4096
         Exit status: 0


procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu=
------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id=
 wa st
  0  1      0  17100    432 3758476    0    0  4607  1147  575 1051  0  2 9=
5  3  0
  1  0      0  16980    432 3758888    0    0 1064760     0 9344 10698  1  =
4 94  1  0
  1  0      0  17100    432 3758888    0    0 1081808     0 9520 10608  1  =
4 94  1  0
  1  1      0  16912    440 3758908    0    0 1136764    48 9899 11305  1  =
4 94  1  0
  1  0      0  16972    440 3758908    0    0 1112664     0 9756 11126  1  =
4 94  1  0
  1  0      0  17080    440 3759040    0    0 1140564     0 9943 11492  1  =
4 94  1  0
  2  0      0  16976    440 3759040    0    0 1134020     0 9910 11475  1  =
4 94  1  0
  1  0      0  17364    440 3758940    0    0 1132380     0 9865 11236  1  =
4 94


Justin.


--655872-1696410560-1296939955=:8518--
