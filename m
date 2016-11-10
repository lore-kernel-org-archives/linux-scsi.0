From: Hannes Reinecke <hare@suse.de>
Subject: Reduced latency is killing performance
Date: Thu, 10 Nov 2016 17:04:42 +0100
Message-ID: <72489f3f-d181-09a2-fc17-27ba36ad9620@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------608FE57BCAF481B909503E0C"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------608FE57BCAF481B909503E0C
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi all,

this really feels like a follow-up to the discussion we've had in Santa
Fe, but finally I'm able to substantiate it with some numbers.

I've made a patch to enable the megaraid_sas driver for multiqueue.
While this is pretty straightforward (I'll be sending the patchset later
on), the results are ... interesting.

I've run the 'ssd-test.fio' script from Jens' repository, and these
results for MQ/SQ (- is mq, + is sq):

 Run status group 0 (all jobs):
-   READ: io=10641MB, aggrb=181503KB/s, minb=181503KB/s,
maxb=181503KB/s, mint=60033msec, maxt=60033msec
+   READ: io=18370MB, aggrb=312572KB/s, minb=312572KB/s,
maxb=312572KB/s, mint=60181msec, maxt=60181msec

 Run status group 1 (all jobs):
-   READ: io=441444KB, aggrb=7303KB/s, minb=7303KB/s, maxb=7303KB/s,
mint=60443msec, maxt=60443msec
+   READ: io=223108KB, aggrb=3707KB/s, minb=3707KB/s, maxb=3707KB/s,
mint=60182msec, maxt=60182msec

 Run status group 2 (all jobs):
-  WRITE: io=22485MB, aggrb=383729KB/s, minb=383729KB/s,
maxb=383729KB/s, mint=60001msec, maxt=60001msec
+  WRITE: io=47421MB, aggrb=807581KB/s, minb=807581KB/s,
maxb=807581KB/s, mint=60129msec, maxt=60129msec

 Run status group 3 (all jobs):
-  WRITE: io=489852KB, aggrb=8110KB/s, minb=8110KB/s, maxb=8110KB/s,
mint=60399msec, maxt=60399msec
+  WRITE: io=489748KB, aggrb=8134KB/s, minb=8134KB/s, maxb=8134KB/s,
mint=60207msec, maxt=60207msec

 Disk stats (read/write):
-  sda: ios=2834412/5878578, merge=0/0, ticks=86269292/48364836,
in_queue=135345876, util=99.20%
+  sda: ios=205278/2680329, merge=4552593/9580622,
ticks=12539912/12965228, in_queue=25512312, util=99.59%

As you can see, we're really losing performance in the multiqueue case.
And the main reason for that is that we submit about _10 times_ as much
I/O as we do for the single-queue case.

So I guess having an I/O scheduler is critical, even for the scsi-mq case.

Full fio output attached.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------608FE57BCAF481B909503E0C
Content-Type: text/plain; charset=UTF-8;
 name="ssd-test.fio"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="ssd-test.fio"

IyBEbyBzb21lIGltcG9ydGFudCBudW1iZXJzIG9uIFNTRCBkcml2ZXMsIHRvIGdhdWdlIHdo
YXQga2luZCBvZgojIHBlcmZvcm1hbmNlIHlvdSBtaWdodCBnZXQgb3V0IG9mIHRoZW0uCiMK
IyBTZXF1ZW50aWFsIHJlYWQgYW5kIHdyaXRlIHNwZWVkcyBhcmUgdGVzdGVkLCB0aGVzZSBh
cmUgZXhwZWN0ZWQgdG8gYmUKIyBoaWdoLiBSYW5kb20gcmVhZHMgc2hvdWxkIGFsc28gYmUg
ZmFzdCwgcmFuZG9tIHdyaXRlcyBhcmUgd2hlcmUgY3JhcAojIGRyaXZlcyBhcmUgdXN1YWxs
eSBzZXBhcmF0ZWQgZnJvbSB0aGUgZ29vZCBkcml2ZXMuCiMKIyBUaGlzIHVzZXMgYSBxdWV1
ZSBkZXB0aCBvZiA0LiBOZXcgU0FUQSBTU0QncyB3aWxsIHN1cHBvcnQgdXAgdG8gMzIKIyBp
biBmbGlnaHQgY29tbWFuZHMsIHNvIGl0IG1heSBhbHNvIGJlIGludGVyZXN0aW5nIHRvIGlu
Y3JlYXNlIHRoZSBxdWV1ZQojIGRlcHRoIGFuZCBjb21wYXJlLiBOb3RlIHRoYXQgbW9zdCBy
ZWFsLWxpZmUgdXNhZ2Ugd2lsbCBub3Qgc2VlIHRoYXQKIyBsYXJnZSBvZiBhIHF1ZXVlIGRl
cHRoLCBzbyA0IGlzIG1vcmUgcmVwcmVzZW50YXRpdmUgb2Ygbm9ybWFsIHVzZS4KIwpbZ2xv
YmFsXQppb2VuZ2luZT1saWJhaW8KaW9kZXB0aD0yNTYKc2l6ZT0xMGcKZGlyZWN0PTEKcnVu
dGltZT02MApudW1qb2JzPTE2CmRpcmVjdG9yeT0vaG9tZQpmaWxlbmFtZT1zc2QudGVzdC5m
aWxlCmdyb3VwX3JlcG9ydGluZwoKW3NlcS1yZWFkXQpydz1yZWFkCnN0b25ld2FsbAoKW3Jh
bmQtcmVhZF0Kcnc9cmFuZHJlYWQKc3RvbmV3YWxsCgpbc2VxLXdyaXRlXQpydz13cml0ZQpz
dG9uZXdhbGwKCltyYW5kLXdyaXRlXQpydz1yYW5kd3JpdGUKc3RvbmV3YWxsCgo=
--------------608FE57BCAF481B909503E0C
Content-Type: text/x-log;
 name="megasas-sq.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="megasas-sq.log"

seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D256
=2E..
rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlib=
aio, iodepth=3D256
=2E..
seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio=
, iodepth=3D256
=2E..
rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dl=
ibaio, iodepth=3D256
=2E..
fio-2.15
Starting 64 processes

seq-read: (groupid=3D0, jobs=3D16): err=3D 0: pid=3D3715: Thu Nov 10 16:4=
8:49 2016
  read : io=3D18370MB, bw=3D312573KB/s, iops=3D78143, runt=3D 60181msec
    slat (usec): min=3D1, max=3D5664, avg=3D 2.33, stdev=3D 5.74
    clat (usec): min=3D30, max=3D1283.3K, avg=3D52320.04, stdev=3D114862.=
40
     lat (usec): min=3D37, max=3D1283.3K, avg=3D52322.47, stdev=3D114862.=
35
    clat percentiles (usec):
     |  1.00th=3D[  620],  5.00th=3D[ 1432], 10.00th=3D[ 2096], 20.00th=3D=
[ 2544],
     | 30.00th=3D[ 2608], 40.00th=3D[ 2640], 50.00th=3D[ 2672], 60.00th=3D=
[ 2736],
     | 70.00th=3D[ 2864], 80.00th=3D[14912], 90.00th=3D[284672], 95.00th=3D=
[342016],
     | 99.00th=3D[419840], 99.50th=3D[468992], 99.90th=3D[585728], 99.95t=
h=3D[634880],
     | 99.99th=3D[749568]
    lat (usec) : 50=3D0.01%, 100=3D0.01%, 250=3D0.20%, 500=3D0.47%, 750=3D=
1.07%
    lat (usec) : 1000=3D0.90%
    lat (msec) : 2=3D5.92%, 4=3D63.81%, 10=3D5.22%, 20=3D3.28%, 50=3D1.84=
%
    lat (msec) : 100=3D1.19%, 250=3D4.25%, 500=3D11.54%, 750=3D0.28%, 100=
0=3D0.01%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.65%, sys=3D1.42%, ctx=3D78762, majf=3D0, minf=3D=
9372
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
0.1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D4702738/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
rand-read: (groupid=3D1, jobs=3D16): err=3D 0: pid=3D3772: Thu Nov 10 16:=
48:49 2016
  read : io=3D223108KB, bw=3D3707.3KB/s, iops=3D926, runt=3D 60182msec
    slat (usec): min=3D2, max=3D1131.3K, avg=3D17217.00, stdev=3D95963.21=

    clat (msec): min=3D16, max=3D5492, avg=3D4255.60, stdev=3D671.40
     lat (msec): min=3D171, max=3D6020, avg=3D4272.81, stdev=3D675.11
    clat percentiles (msec):
     |  1.00th=3D[  717],  5.00th=3D[ 3195], 10.00th=3D[ 4080], 20.00th=3D=
[ 4228],
     | 30.00th=3D[ 4359], 40.00th=3D[ 4359], 50.00th=3D[ 4424], 60.00th=3D=
[ 4424],
     | 70.00th=3D[ 4490], 80.00th=3D[ 4490], 90.00th=3D[ 4555], 95.00th=3D=
[ 4752],
     | 99.00th=3D[ 4817], 99.50th=3D[ 4948], 99.90th=3D[ 5473], 99.95th=3D=
[ 5473],
     | 99.99th=3D[ 5473]
    lat (msec) : 20=3D0.01%, 100=3D0.02%, 250=3D0.24%, 500=3D0.40%, 750=3D=
0.40%
    lat (msec) : 1000=3D0.46%, 2000=3D1.61%, >=3D2000=3D96.87%
  cpu          : usr=3D0.02%, sys=3D0.04%, ctx=3D1929, majf=3D0, minf=3D4=
259
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.2%, 16=3D0.5%, 32=3D=
0.9%, >=3D64=3D98.2%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D55777/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
seq-write: (groupid=3D2, jobs=3D16): err=3D 0: pid=3D3790: Thu Nov 10 16:=
48:49 2016
  write: io=3D47421MB, bw=3D807582KB/s, iops=3D201895, runt=3D 60129msec
    slat (usec): min=3D2, max=3D3039, avg=3D 4.85, stdev=3D16.02
    clat (usec): min=3D95, max=3D794322, avg=3D20251.85, stdev=3D67558.84=

     lat (usec): min=3D123, max=3D794326, avg=3D20256.83, stdev=3D67559.5=
0
    clat percentiles (usec):
     |  1.00th=3D[  900],  5.00th=3D[  932], 10.00th=3D[  956], 20.00th=3D=
[  996],
     | 30.00th=3D[ 1048], 40.00th=3D[ 1112], 50.00th=3D[ 1160], 60.00th=3D=
[ 1224],
     | 70.00th=3D[ 1400], 80.00th=3D[ 1720], 90.00th=3D[ 2960], 95.00th=3D=
[232448],
     | 99.00th=3D[296960], 99.50th=3D[313344], 99.90th=3D[366592], 99.95t=
h=3D[489472],
     | 99.99th=3D[774144]
    lat (usec) : 100=3D0.01%, 250=3D0.01%, 500=3D0.01%, 750=3D0.09%, 1000=
=3D20.47%
    lat (msec) : 2=3D64.34%, 4=3D5.85%, 10=3D0.24%, 20=3D0.33%, 50=3D0.81=
%
    lat (msec) : 100=3D0.54%, 250=3D3.00%, 500=3D4.26%, 750=3D0.02%, 1000=
=3D0.03%
  cpu          : usr=3D1.41%, sys=3D5.44%, ctx=3D558403, majf=3D0, minf=3D=
12550
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
0.1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D0/w=3D12139774/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
rand-write: (groupid=3D3, jobs=3D16): err=3D 0: pid=3D3806: Thu Nov 10 16=
:48:49 2016
  write: io=3D489748KB, bw=3D8134.5KB/s, iops=3D2033, runt=3D 60207msec
    slat (usec): min=3D3, max=3D330352, avg=3D7843.31, stdev=3D43990.65
    clat (msec): min=3D65, max=3D3671, avg=3D2001.23, stdev=3D448.67
     lat (msec): min=3D68, max=3D3671, avg=3D2009.07, stdev=3D449.18
    clat percentiles (msec):
     |  1.00th=3D[  285],  5.00th=3D[  693], 10.00th=3D[ 1680], 20.00th=3D=
[ 1991],
     | 30.00th=3D[ 2040], 40.00th=3D[ 2089], 50.00th=3D[ 2114], 60.00th=3D=
[ 2147],
     | 70.00th=3D[ 2180], 80.00th=3D[ 2245], 90.00th=3D[ 2343], 95.00th=3D=
[ 2376],
     | 99.00th=3D[ 2540], 99.50th=3D[ 2606], 99.90th=3D[ 2704], 99.95th=3D=
[ 2737],
     | 99.99th=3D[ 2868]
    lat (msec) : 100=3D0.08%, 250=3D0.68%, 500=3D1.72%, 750=3D3.60%, 1000=
=3D1.28%
    lat (msec) : 2000=3D14.04%, >=3D2000=3D78.60%
  cpu          : usr=3D0.03%, sys=3D0.14%, ctx=3D11009, majf=3D0, minf=3D=
172
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.2%, 32=3D=
0.4%, >=3D64=3D99.2%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D0/w=3D122437/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6

Run status group 0 (all jobs):
   READ: io=3D18370MB, aggrb=3D312572KB/s, minb=3D312572KB/s, maxb=3D3125=
72KB/s, mint=3D60181msec, maxt=3D60181msec

Run status group 1 (all jobs):
   READ: io=3D223108KB, aggrb=3D3707KB/s, minb=3D3707KB/s, maxb=3D3707KB/=
s, mint=3D60182msec, maxt=3D60182msec

Run status group 2 (all jobs):
  WRITE: io=3D47421MB, aggrb=3D807581KB/s, minb=3D807581KB/s, maxb=3D8075=
81KB/s, mint=3D60129msec, maxt=3D60129msec

Run status group 3 (all jobs):
  WRITE: io=3D489748KB, aggrb=3D8134KB/s, minb=3D8134KB/s, maxb=3D8134KB/=
s, mint=3D60207msec, maxt=3D60207msec

Disk stats (read/write):
  sda: ios=3D205278/2680329, merge=3D4552593/9580622, ticks=3D12539912/12=
965228, in_queue=3D25512312, util=3D99.59%

--------------608FE57BCAF481B909503E0C
Content-Type: text/x-log;
 name="megasas-mq.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="megasas-mq.log"

seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D256
=2E..
rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlib=
aio, iodepth=3D256
=2E..
seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio=
, iodepth=3D256
=2E..
rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dl=
ibaio, iodepth=3D256
=2E..
fio-2.15
Starting 64 processes

seq-read: (groupid=3D0, jobs=3D16): err=3D 0: pid=3D12365: Thu Nov 10 16:=
34:03 2016
  read : io=3D10641MB, bw=3D181503KB/s, iops=3D45375, runt=3D 60033msec
    slat (usec): min=3D2, max=3D168902, avg=3D349.71, stdev=3D2179.65
    clat (usec): min=3D27, max=3D1046.3K, avg=3D89851.03, stdev=3D94205.1=
9
     lat (usec): min=3D921, max=3D1046.3K, avg=3D90200.97, stdev=3D94519.=
88
    clat percentiles (msec):
     |  1.00th=3D[    6],  5.00th=3D[   11], 10.00th=3D[   16], 20.00th=3D=
[   23],
     | 30.00th=3D[   32], 40.00th=3D[   43], 50.00th=3D[   57], 60.00th=3D=
[   77],
     | 70.00th=3D[  101], 80.00th=3D[  139], 90.00th=3D[  210], 95.00th=3D=
[  289],
     | 99.00th=3D[  445], 99.50th=3D[  506], 99.90th=3D[  644], 99.95th=3D=
[  709],
     | 99.99th=3D[  881]
    lat (usec) : 50=3D0.01%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.22%, 10=3D3.90%, 20=3D12.47%, 50=3D29.0=
5%
    lat (msec) : 100=3D23.95%, 250=3D23.49%, 500=3D6.38%, 750=3D0.51%, 10=
00=3D0.03%
    lat (msec) : 2000=3D0.01%
  cpu          : usr=3D0.38%, sys=3D1.53%, ctx=3D1261134, majf=3D0, minf=3D=
7465
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
0.1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D2724047/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
rand-read: (groupid=3D1, jobs=3D16): err=3D 0: pid=3D12424: Thu Nov 10 16=
:34:03 2016
  read : io=3D441444KB, bw=3D7303.5KB/s, iops=3D1825, runt=3D 60443msec
    slat (usec): min=3D3, max=3D5654.6K, avg=3D8705.16, stdev=3D98890.89
    clat (usec): min=3D499, max=3D54071K, avg=3D2020668.34, stdev=3D40665=
96.80
     lat (usec): min=3D534, max=3D54071K, avg=3D2029373.76, stdev=3D40806=
84.63
    clat percentiles (msec):
     |  1.00th=3D[   58],  5.00th=3D[   96], 10.00th=3D[  120], 20.00th=3D=
[  163],
     | 30.00th=3D[  219], 40.00th=3D[  310], 50.00th=3D[  482], 60.00th=3D=
[  881],
     | 70.00th=3D[ 1598], 80.00th=3D[ 2868], 90.00th=3D[ 5604], 95.00th=3D=
[ 8455],
     | 99.00th=3D[16712], 99.50th=3D[16712], 99.90th=3D[16712], 99.95th=3D=
[16712],
     | 99.99th=3D[16712]
    lat (usec) : 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.03%, 20=3D0.08%, 50=3D0.47%=

    lat (msec) : 100=3D5.07%, 250=3D28.49%, 500=3D16.49%, 750=3D6.91%, 10=
00=3D4.65%
    lat (msec) : 2000=3D11.35%, >=3D2000=3D26.44%
  cpu          : usr=3D0.03%, sys=3D0.10%, ctx=3D12943, majf=3D0, minf=3D=
4261
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.2%, 32=3D=
0.5%, >=3D64=3D99.1%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D110361/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
seq-write: (groupid=3D2, jobs=3D16): err=3D 0: pid=3D12440: Thu Nov 10 16=
:34:03 2016
  write: io=3D22485MB, bw=3D383729KB/s, iops=3D95932, runt=3D 60001msec
    slat (usec): min=3D4, max=3D25089, avg=3D160.99, stdev=3D186.82
    clat (usec): min=3D9, max=3D99208, avg=3D42511.29, stdev=3D8094.51
     lat (usec): min=3D285, max=3D99223, avg=3D42672.98, stdev=3D8120.87
    clat percentiles (usec):
     |  1.00th=3D[27008],  5.00th=3D[35072], 10.00th=3D[35584], 20.00th=3D=
[37120],
     | 30.00th=3D[37632], 40.00th=3D[38656], 50.00th=3D[40192], 60.00th=3D=
[41728],
     | 70.00th=3D[43776], 80.00th=3D[47872], 90.00th=3D[54528], 95.00th=3D=
[60160],
     | 99.00th=3D[67072], 99.50th=3D[70144], 99.90th=3D[76288], 99.95th=3D=
[78336],
     | 99.99th=3D[84480]
    lat (usec) : 10=3D0.01%, 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D=
0.01%
    lat (msec) : 2=3D0.01%, 4=3D0.01%, 10=3D0.02%, 20=3D0.33%, 50=3D83.21=
%
    lat (msec) : 100=3D16.42%
  cpu          : usr=3D3.17%, sys=3D19.97%, ctx=3D10291638, majf=3D0, min=
f=3D28791
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D=
0.1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D0/w=3D5756037/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6
rand-write: (groupid=3D3, jobs=3D16): err=3D 0: pid=3D12456: Thu Nov 10 1=
6:34:03 2016
  write: io=3D489852KB, bw=3D8110.3KB/s, iops=3D2027, runt=3D 60399msec
    slat (usec): min=3D4, max=3D7321.2K, avg=3D7849.80, stdev=3D103311.36=

    clat (msec): min=3D30, max=3D49117, avg=3D2007.24, stdev=3D3917.47
     lat (msec): min=3D30, max=3D49143, avg=3D2015.09, stdev=3D3929.12
    clat percentiles (msec):
     |  1.00th=3D[   73],  5.00th=3D[  120], 10.00th=3D[  147], 20.00th=3D=
[  194],
     | 30.00th=3D[  253], 40.00th=3D[  322], 50.00th=3D[  469], 60.00th=3D=
[  766],
     | 70.00th=3D[ 1352], 80.00th=3D[ 2704], 90.00th=3D[ 5473], 95.00th=3D=
[ 9372],
     | 99.00th=3D[16712], 99.50th=3D[16712], 99.90th=3D[16712], 99.95th=3D=
[16712],
     | 99.99th=3D[16712]
    lat (msec) : 50=3D0.18%, 100=3D2.31%, 250=3D27.05%, 500=3D22.01%, 750=
=3D8.03%
    lat (msec) : 1000=3D4.76%, 2000=3D11.62%, >=3D2000=3D24.04%
  cpu          : usr=3D0.05%, sys=3D0.16%, ctx=3D23792, majf=3D0, minf=3D=
181
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.2%, 32=3D=
0.4%, >=3D64=3D99.2%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued    : total=3Dr=3D0/w=3D122463/d=3D0, short=3Dr=3D0/w=3D0/d=3D=
0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D25=
6

Run status group 0 (all jobs):
   READ: io=3D10641MB, aggrb=3D181503KB/s, minb=3D181503KB/s, maxb=3D1815=
03KB/s, mint=3D60033msec, maxt=3D60033msec

Run status group 1 (all jobs):
   READ: io=3D441444KB, aggrb=3D7303KB/s, minb=3D7303KB/s, maxb=3D7303KB/=
s, mint=3D60443msec, maxt=3D60443msec

Run status group 2 (all jobs):
  WRITE: io=3D22485MB, aggrb=3D383729KB/s, minb=3D383729KB/s, maxb=3D3837=
29KB/s, mint=3D60001msec, maxt=3D60001msec

Run status group 3 (all jobs):
  WRITE: io=3D489852KB, aggrb=3D8110KB/s, minb=3D8110KB/s, maxb=3D8110KB/=
s, mint=3D60399msec, maxt=3D60399msec

Disk stats (read/write):
  sda: ios=3D2834412/5878578, merge=3D0/0, ticks=3D86269292/48364836, in_=
queue=3D135345876, util=3D99.20%

--------------608FE57BCAF481B909503E0C--
