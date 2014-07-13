From: Douglas Gilbert <dgilbert@interlog.com>
Subject: sg_tst_async, scsi-mq testing
Date: Sat, 12 Jul 2014 20:52:38 -0400
Message-ID: <53C1D856.5040503@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55077 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaGMAwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 20:52:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Elliott, Robert (Server Storage)" <elliott@hp.com>, Christoph Hellwig <hch@lst.de>

scsi-mq testing has been temporarily sidelined by a
problem with the command injection test harness: fio.
To queue commands (e.g. to take advantage of SCSI
task sets and SATA NCQ) fio uses libaio which is the
focus of interest. Debugging is ongoing.

At a lower level the sg driver can be used to inject
SCSI commands in an asynchronous fashion. These pass
through the block layer (termed BLOCK_PC requests) and
then through the scsi-mq code. So the path is similar
to reads and writes issued by fio.

In the last few days I have added examples/sg_tst_async.cpp
to my sg3_utils version 1.40 beta2 which can be found
here: http://sg.danny.cz/sg/  [in the News section].

sg_tst_async is a multi-threaded C++ program that opens
up one sg file descriptor per thread. With each thread
it can issue thousands of commands but to a depth of
no more than 16 (a sg driver limit). Since multiple
threads access the same device the number of threads
acts as a queue depth multiply. In my testing this
works fine up to 8 threads, thereafter the sg write()
operation yields ENOMEM (from blk_get_request()). In
theory setting to <sysfs_scsi_device>/queue/nr_queue
to a value higher than its default of 128 should fix
that (but it made things worse in my tests).

sg_tst_async issues TEST UNIT READY(TUR), READ(16) or
WRITE(16) commands. The latter two use a fixed LBA or
a range of LBA from which a pseudo random LBA is chosen.
[The seed is taken from /dev/urandom.] Using a LBA range
of a whole SAS SSD, sg_tst_async yields a IOPS measurement
on READs almost matching that of the manufacturer.

The utility has been tested against a SAS SSD (LSI
9300-4i HBA) and the scsi_debug driver. Two machines
have been used, both running a kernel built from the
original scsi-mq.3 branch without problems.


The documentation is for now its usage message:

Usage: sg_tst_async [-d] [-f] [-h] [-l <lba+>] [-n <n_per_thr>] [-N]
                     [-q 0|1] [-Q 0|1|2] [-R] [-s <lb_sz>]
                     [-t <num_thrs>] [-T] [-v] [-V] [-w <wait_ms>]
                     [-W] <sg_disk_device>
   where
     -d                do direct_io (def: indirect)
     -f                force: any sg device (def: only scsi_debug owned)
                       WARNING: <lba> written to if '-W' given
     -h                print this usage message then exit
     -l <lba>          logical block to access (def: 1000)
     -l <lba,hi_lba>    logical block range (inclusive)
     -n <n_per_thr>    number of commands per thread (def: 1000)
     -N                no data xfer (def: xfer on READ and WRITE)
     -q 0|1            0: blk q_at_head; 1: q_at_tail
     -Q 0|1|2          0: favour completions (smaller q), 1: medium,
                       2: favour submissions (larger q, default)
     -s <lb_sz>        logical block size (def: 512)
     -R                do READs (def: TUR)
     -t <num_thrs>     number of threads (def: 4)
     -T                do TEST UNIT READYs (default is TURs)
     -v                increase verbosity
     -V                print version number then exit
     -w <wait_ms>      >0: poll(<wait_ms>); =0: poll(0); (def: 10)
     -W                do WRITEs (def: TUR)

Multiple threads do READ(16), WRITE(16) or TEST UNIT READY (TUR) SCSI
commands. Each thread has its own file descriptor and queues up to
16 commands. One block is transferred by each READ and WRITE; zeros
are written. If a logical block range is given, a uniform distribution
generates a pseudo random sequence of LBAs.


Doug Gilbert

P.S. The '-w <wait_ms>' does not really do anything significant, just leave
      it alone.


