From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 69201] New: qla2xxx: Low-latency storage triggers lock
 contention
Date: Wed, 22 Jan 2014 09:45:44 +0000
Message-ID: <bug-69201-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:42847 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbaAVJpr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2014 04:45:47 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 645342016C
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 09:45:46 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 6A2C320170
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2014 09:45:44 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D69201

            Bug ID: 69201
           Summary: qla2xxx: Low-latency storage triggers lock contenti=
on
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 3.12.7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: enhancement
          Priority: P1
         Component: QLOGIC QLA2XXX
          Assignee: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
          Reporter: bvanassche@acm.org
        Regression: No

Running a fio test on an initiator system with an 8 Gb/s QLogic FC adap=
ter
revealed a bottleneck in the qla2xxx initiator driver - lock contention=
 on=20
ha->hardware_lock.

The test that revealed this is as follows:
- On a target system with 4 CPU threads (Intel i5), an 8 Gb/s QLogic FC=
 HBA and
kernel 3.12.7, download the SCST trunk r5194, build it in release mode,=
 load
the brd kernel module and configure SCST such that it exports /dev/ram[=
0123]
via the vdisk_blockio driver. Set the vdisk_blockio parameter threads_n=
um to 2.
Export these four RAM disks as LUNs 0..3.
- On an initiator system with 12 CPU threads (Intel Core i7 with hypert=
hreading
enabled), an 8 Gb/s QLogic HBA and kernel 3.12.7, run the following fio=
 job
(where /dev/sd[cdef] corresponds to the SCST LUNs):

fio --bs=3D4K --ioengine=3Dlibaio --rw=3Drandrw --buffered=3D0 --numjob=
s=3D12 \
    --iodepth=3D16 --iodepth_batch=3D8 --iodepth_batch_complete=3D8   \
    --thread --loops=3D$((2**31)) --runtime=3D60 --group_reporting    \
    --gtod_reduce=3D1 --invalidate=3D1                \
    $(for d in /dev/sd[cdef]; do echo --name=3D$d --filename=3D$d; done=
)

- While this fio job is running, run the following commands:

perf record -ag sleep 10
perf report =E2=80=93stdio >perf-report-fc.txt

The perf report shows that quite some time is spent in the spin_lock_ir=
qsave()
call invoked from qla24xx_dif_start_scsi(). Does this mean that this te=
st
revealed lock contention on ha->hardware_lock ?

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
