From: Tom Yan <tom.ty89@gmail.com>
Subject: Fluctuating "acceptance" on requested data length in SATA/AHCI
Date: Fri, 15 Jul 2016 03:10:40 +0800
Message-ID: <CAGnHSEkPkm3z3Aj+Aaj2p7ZK-UEo0dvXE+6Cj8SdKCt_L7Ei=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, dgilbert@interlog.com, Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

So I recently been doing some experiment on different storage hosts
(AHCI and UAS) to see how certain block layer limits in the kernel and
so matters on them. I notice some behavior in SATA/AHCI which bothers
me a bit.

I have been testing with `sg_raw` by issuing READ (10/16) commands.
But before that I needed to hack it a bit because it does a weird
check on the allowed data length, where the allowed value is
ridiculously small:

diff --git a/sg_raw.c~ b/sg_raw.c
...
-            if (n < 0 || n > MAX_SCSI_DXLEN) {
+            if (n < 0) {
...
-            if (n < 0 || n > MAX_SCSI_DXLEN) {
+            if (n < 0) {
...

First I tested on the drive connected with an SATA/UAS adapter. The
upper limit on the requested data length is CONSISTENTLY (I mean on
the same adapter) 8192 * 512 bytes:


[tom@localhost ~]$ sudo sg_raw -r 0x3ffe00 -o /dev/null /dev/sdc 88 00
00 00 00 00 00 00 00 00 00 00 1f ff 00 00
SCSI Status: Good

Writing 4193792 bytes of data to /dev/null
[tom@localhost ~]$ sudo sg_raw -r 0x400000 -o /dev/null /dev/sdc 88 00
00 00 00 00 00 00 00 00 00 00 20 00 00 00
SCSI Status: Good

Writing 4194304 bytes of data to /dev/null
[tom@localhost ~]$ sudo sg_raw -r 0x400200 -o /dev/null /dev/sdc 88 00
00 00 00 00 00 00 00 00 00 00 20 01 00 00
do_scsi_pt: Invalid argument


I had to hacked the kernel by changing SCSI_DEFAULT_MAX_SECTORS, which
currently determines "max_hw_sectors" of UAS device, from 1024 to
65535, otherwise the allowed length will be bounded by
"max_hw_sectors". See the sg_io() in block/scsi_ioctl.c.
("max_sectors" was hence allowed to bump to 65535 by the Optimal
Transfer Length reported in the adapter's VPD.)

However, when I test on the exact same drive (which is the "system
drive", btw), with it connected to a AHCI SATA port on my motherboard
(Intel H87), the allowed requested length would be fluctuating:

...
[tom@localhost ~]$ sudo sg_raw -r 0x140000 -o /dev/null /dev/sda 88 00
00 00 00 00 00 00 00 00 00 00 0a 00 00 00
do_scsi_pt: Invalid argument
[tom@localhost ~]$ sudo sg_raw -r 0x140000 -o /dev/null /dev/sda 88 00
00 00 00 00 00 00 00 00 00 00 0a 00 00 00
SCSI Status: Good

Writing 1310720 bytes of data to /dev/null
...


I hadn't been able to "locate" a sensible and/or solid point where the
fluctuation start, but I did notice that the chance of "failure" would
rise with the requested length. Also, if I boot with
`libata.force=noncq`, the failure seems to start off from a lower
point.

So is that an expected characteristic of SATA/AHCI? Or does that hint
that there is something wrong in the kernel? And btw, should any block
limit be set according to this? For example, max_sectors?
