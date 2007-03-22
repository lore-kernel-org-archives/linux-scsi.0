From: Douglas Gilbert <dougg@torque.net>
Subject: RFC: sg driver addition: SG_FLAG_SHARED_MMAP_IO
Date: Wed, 21 Mar 2007 22:37:09 -0400
Message-ID: <4601EBD5.8040406@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020505070501020708050400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37633 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXCVChW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2007 22:37:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: pw@osc.edu, michaelc@cs.wisc.edu

This is a multi-part message in MIME format.
--------------020505070501020708050400
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I mentioned this idea a few weeks ago on this list: namely
to allow a sg pass-through request to use the mmap-ed
reserve buffer associated with another sg file descriptor.

In my experience mmap-ed IO using sg's reserve buffer mapped
into the user space is faster than direct IO schemes. However
one shortcoming is that if you try to copy between two devices
using this technique then you end up with two separate mmap-ed
buffers in the user space program. Then the user space program
needs to copy between the two buffers which would defeat much
of the advantage of the mmap-ed IO. You could (and sgm_dd in
sg3_utils does) use mmap-ed IO on the read side and direct IO
on the write side (or vice versa).

I used the sg driver as found in lk 2.6.21-rc4 as a baseline
(and I don't think sg has changed since 2.6.19). A gzipped
diff is attached. There is also some test code (a modified
sgm_dd) in the sg3_utils-1.24 beta on the www.torque.net/sg site.

Here is an example of a disk to disk copy:
  sgm_dd if=/dev/sg0 of=/dev/sg1 oflag=smmap bs=512

The new flag is 'oflag=smmap' which instructs the write SG_IO
on /dev/sg1 to set SG_FLAG_SHARED_MMAP_IO and it passes
the mmap-ed buffer used for /dev/sg0 in dxferp. [Add a
'verbose=1' option and it will indicate how many times shared
mmap IO was requested and how many times it was actually done.]


Features:
  - allow both side of a copy like operation to dma into
    and out of the same user space buffer
  - minimal per command overhead (i.e. building of
    scatter gather lists and pinning pages)
  - could copy a single source to multiple destinations
    efficiently
  - if shared reserve buffer unavailable (or not big
    enough) then fall back to indirect IO transparently
  - new info bit SG_INFO_SHARED_MMAP_IO indicates whether
    shared mmap-ed IO was done

Restrictions (enforced by the sg driver):
  - confined to file descriptors in the same process
  - there can be only one user of a reserve buffer
    at a time
  - low_dma is honoured

Complexity
  - it does have a few more corner cases than usual. For
    example in above sgm_dd invocation: closing /dev/sg0
    while /dev/sg1 is sharing its mmap-ed reserve buffer ...


Here are some timings copying between two ramdisks. It is
assumed the 'bs=8k' given to dd is equivalent to 'bs=512
bpt=16' given to sgm_dd.

# lsscsi -g
[4:0:0:0]    disk    Linux    scsi_debug       1.82  /dev/sda  /dev/sg0
[5:0:0:0]    disk    Linux    scsi_ses         1.06  /dev/sdb  /dev/sg1

# ./dd_tsts.sh
Usage: dd_tsts.sh <ifile> <ofile> <times> <bs>

# ./dd_tsts.sh /dev/sda /dev/sdb 50 8k
Indirect IO with dd
dd if=/dev/sda of=/dev/sdb bs=8k
real    0m7.448s
user    0m0.080s
sys     0m7.046s

Direct IO with dd
dd if=/dev/sda iflag=direct of=/dev/sdb oflag=direct bs=8k
real    0m4.529s
user    0m0.114s
sys     0m3.799s


# ./sg_dd_tsts.sh /dev/sg0 /dev/sg1 50 16
Indirect IO with sg_dd
sg_dd if=/dev/sg0 of=/dev/sg1 bs=512 bpt=16
real    0m6.304s
user    0m0.171s
sys     0m5.268s

Direct IO with sg_dd
sg_dd if=/dev/sg0 iflag=dio of=/dev/sg1 oflag=dio bs=512 bpt=16
real    0m4.246s
user    0m0.135s
sys     0m3.395s

Mmap read, indirect IO write with sgm_dd
sgm_dd if=/dev/sg0 of=/dev/sg1 bs=512 bpt=16
real    0m4.023s
user    0m0.127s
sys     0m3.259s

Mmap read, direct IO write with sgm_dd
sgm_dd if=/dev/sg0 of=/dev/sg1 oflag=dio bs=512 bpt=16
real    0m4.057s
user    0m0.164s
sys     0m3.264s

Mmap read, shared mmap write with sgm_dd
sgm_dd if=/dev/sg0 of=/dev/sg1 oflag=smmap bs=512 bpt=16
real    0m3.871s
user    0m0.131s
sys     0m3.111s


Don't expect drastic improvements in real IO unless it is
in the gigabyte per second range.


Doug Gilbert

--------------020505070501020708050400
Content-Type: application/x-gzip;
 name="sg2621rc4smm2.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sg2621rc4smm2.diff.gz"

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
--------------020505070501020708050400--
