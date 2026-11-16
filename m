Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788419;
	b=gaguXHwpimtszu6iQ19flrgPRV72E+mYmSB8mEe7M/JppTXKheTJMEWCXjV6eu17/9uo
	 VeAagDM27ibkB0Bn5Ekzr5nsH0zkrkGUdFlyF+fLiJ4FXNJIJ1ldFmtUghROKlqp6zf11
	 iCbUwYE7dKYZYDYsOeKOHKxyyMSeDbFf0w1Rmv7DhqMopjb3P55WO75PN7trHDLtS/rzs
	 myHxjtHpCYoL0guDLRPnporDxsqIOXbXniw1zWtDy30r5mXQ9QC0R0w7G9EXaDXzRwi9N
	 c4wI+uohm0hyAz2M1nfH1XVufh/ciKE9Cya3B6JX0PYAmL1OcUSYiFUEvbAvzXThazQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788419;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=6s8/C1tvxzvgHmqGK3oZ/Y/d+6ogDdMftAFdojh64u0=;
	b=2vlWFtgs0tNpFy4clysDHPJiSe62W1l/jTCj/7n4HsPaKIRerehVkxdFQC63uyROXtrL
	 YrG/0InEnAKQPUcNxd5Ydpalxi6aadNIdfa7bUBOkVMJYGx2GRhXyVeoXqQjXIjdxjH2T
	 QxBQKeQ0VKDUtqyE2IwatAZlkNGvWjUvksP9V713mHkxp4Pw7e4ol5ndyjoUMWbWPjKW7
	 ZCUE+PRZkB0Uy4KS63qiEwQgpKHeTsWRlOobjbkPV6m3pJGe/hvx+w/rrsY3wdOQuD2A8
	 qnkz2SyoK8aE0NTL2bahIzSrdIE6bblVFXO47Haiv4n4ZZHfl8SZvG88ZryqnYuZXmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CWZnjj+M;
	arc=none smtp.remote-ip=95.215.58.225
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9E2606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D9E2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CWZnjj+M
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=JfUFJVlcWizmfQyeDPMJDRGV730ECZKJhBkx7XmCOFc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788416; v=1; x=1795393216;
 b=CWZnjj+MwGdHba+/UZGW8PxjWjN6r5OvCmD0IvMvBplNWr0koSFOrGKy+2HZ96V4ZPcxdgKj
 B14vRpWoRiKZzY22xDCek7zhVmwf174Q9dcexAnj8b5e8/69R0pdb8yO9i3oqrvzk8qffl5YyTn
 KMVuNUjzlxqQR46TVXYSFn20=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6bc4cf57d400e45e;
	Mon, 16 Nov 2026 00:20:15 +0000
X-Mizu-Trace-ID: 6bc4cf57d400e45e
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:10 -0500
Subject: [PATCH RFC 17/18] selftests: target_core_uring: Test a device
 exported through tcm_loop
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-17-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

tcmur_server can serve a target_core_uring device from a backing file.

Nothing checks that the backstore and the server work together.

Add a test that exports a device through tcm_loop and compares the SCSI
disk with the backing file after writes, reads, flushes, UNMAP and
WRITE SAME, with and without zero copy. Also check that a new server
takes over after the first one is killed, and that commands time out
without a server.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/target_core_uring/Makefile |   1 +
 tools/testing/selftests/target_core_uring/config   |   5 +
 .../selftests/target_core_uring/tcmur_test.sh      | 137 +++++++++++++++++++++
 4 files changed, 144 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 07c3719f8b04b..8e97d4b374a09 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -131,6 +131,7 @@ TARGETS += static_keys
 TARGETS += sync
 TARGETS += syscall_user_dispatch
 TARGETS += sysctl
+TARGETS += target_core_uring
 TARGETS += tc-testing
 TARGETS += tdx
 TARGETS += thermal/intel/power_floor
diff --git a/tools/testing/selftests/target_core_uring/Makefile b/tools/testing/selftests/target_core_uring/Makefile
index 438628fd1606b..202f174a17e08 100644
--- a/tools/testing/selftests/target_core_uring/Makefile
+++ b/tools/testing/selftests/target_core_uring/Makefile
@@ -2,6 +2,7 @@
 CFLAGS += -O2 -Wall -D_GNU_SOURCE $(KHDR_INCLUDES)
 LDLIBS += -luring -lpthread
 
+TEST_PROGS := tcmur_test.sh
 TEST_GEN_PROGS_EXTENDED := tcmur_server
 
 include ../lib.mk
diff --git a/tools/testing/selftests/target_core_uring/config b/tools/testing/selftests/target_core_uring/config
new file mode 100644
index 0000000000000..9115bf367c169
--- /dev/null
+++ b/tools/testing/selftests/target_core_uring/config
@@ -0,0 +1,5 @@
+CONFIG_IO_URING=y
+CONFIG_TARGET_CORE=m
+CONFIG_TCM_URING=m
+CONFIG_LOOPBACK_TARGET=m
+CONFIG_BLK_DEV_SD=m
diff --git a/tools/testing/selftests/target_core_uring/tcmur_test.sh b/tools/testing/selftests/target_core_uring/tcmur_test.sh
new file mode 100755
index 0000000000000..99f68e74c7cd0
--- /dev/null
+++ b/tools/testing/selftests/target_core_uring/tcmur_test.sh
@@ -0,0 +1,137 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Export a target_core_uring device through tcm_loop, serve it with
+# tcmur_server and check the resulting SCSI disk against the backing file.
+
+DIR=$(dirname "$(readlink -f "$0")")
+KSFT_SKIP=4
+T=/sys/kernel/config/target
+C=$T/core/uring_70/tcmur_test
+WWN=naa.5001405074636d75
+L=$T/loopback/$WWN/tpgt_1
+SIZE=$((256 << 20))
+IMG=$(mktemp /tmp/tcmur_test.XXXXXX)
+PAT=$(mktemp /tmp/tcmur_test.XXXXXX)
+server=
+dev=
+fail=0
+
+[ "$(id -u)" = 0 ] || { echo "SKIP: need root"; exit $KSFT_SKIP; }
+modprobe -q target_core_uring && modprobe -q tcm_loop ||
+	{ echo "SKIP: need target_core_uring and tcm_loop"; exit $KSFT_SKIP; }
+
+check() {	# <name> <command...>
+	local name=$1; shift
+
+	if "$@"; then
+		echo "ok $name"
+	else
+		echo "not ok $name"
+		fail=1
+	fi
+}
+
+# setup <control parameters> <serve|idle> [server arguments...]
+setup() {
+	local params=$1 serve=$2 before cdev; shift 2
+
+	truncate -s 0 "$IMG"; truncate -s $SIZE "$IMG"
+	mkdir -p $C
+	echo "dev_size=$SIZE,nr_queues=2,queue_depth=32$params" > $C/control
+	echo 1 > $C/enable
+	echo 1 > $C/attrib/emulate_tpu
+	echo 1 > $C/attrib/emulate_tpws
+	echo 1 > $C/attrib/emulate_write_cache
+	cdev=$(grep -o '/dev/tcmur[0-9]*' $C/info)
+	udevadm settle
+
+	if [ "$serve" = serve ]; then
+		"$DIR"/tcmur_server "$@" "$cdev" "$IMG" &
+		server=$!
+		sleep 1
+	fi
+
+	before=$(lsblk -dno NAME | sort)
+	mkdir -p $L
+	echo naa.5001405074636d76 > $L/nexus
+	mkdir $L/lun/lun_0
+	ln -s $C $L/lun/lun_0/tcmur_test
+	for _ in $(seq 40); do
+		dev=$(comm -13 <(echo "$before") <(lsblk -dno NAME | sort) | head -1)
+		[ -n "$dev" ] && break
+		sleep 0.5
+	done
+	udevadm settle
+	dev=/dev/$dev
+}
+
+teardown() {
+	rm $L/lun/lun_0/tcmur_test
+	rmdir $L/lun/lun_0 $L $T/loopback/$WWN
+	rmdir $C "$(dirname $C)"
+	# Wait for the server, which exits when the device goes
+	if [ -n "$server" ]; then
+		wait $server 2>/dev/null
+		server=
+	fi
+}
+
+same_as_image() {	# <offset MiB> <count MiB> <file>
+	cmp -s <(dd if="$IMG" bs=1M skip="$1" count="$2" status=none) "$3"
+}
+
+test_io() {	# <name> [server arguments...]
+	local name=$1 blocks; shift
+
+	setup "" serve "$@"
+	dd if=/dev/urandom of="$PAT" bs=1M count=8 status=none
+
+	dd if="$PAT" of=$dev bs=1M seek=16 oflag=direct status=none
+	check "$name write" same_as_image 16 8 "$PAT"
+	check "$name read" cmp -s \
+		<(dd if=$dev bs=1M skip=16 count=8 iflag=direct status=none) "$PAT"
+	check "$name flush" dd if="$PAT" of=$dev bs=1M seek=32 conv=fsync \
+		status=none
+
+	blocks=$(stat -c %b "$IMG")
+	blkdiscard -o $((16 << 20)) -l $((8 << 20)) $dev
+	check "$name unmap" [ "$(stat -c %b "$IMG")" -lt "$blocks" ]
+
+	if command -v sg_write_same > /dev/null; then
+		dd if=/dev/zero of="$PAT" bs=1M count=1 status=none
+		sg_write_same --in=/dev/zero --lba=$((32 << 11)) --num=2048 \
+			--xferlen=512 $dev > /dev/null 2>&1
+		check "$name write same" same_as_image 32 1 "$PAT"
+	else
+		echo "ok $name write same # SKIP no sg_write_same"
+	fi
+	teardown
+}
+
+test_io copy
+test_io "zero copy" -z
+
+# Check that a new server takes over after the first one is killed
+setup "" serve
+kill -9 $server; wait $server 2>/dev/null
+for _ in $(seq 20); do
+	"$DIR"/tcmur_server "$(grep -o '/dev/tcmur[0-9]*' $C/info)" "$IMG" \
+		2>/dev/null &
+	server=$!
+	sleep 0.5
+	kill -0 $server 2>/dev/null && break
+done
+check "server restart" dd if=$dev of=/dev/null bs=1M count=8 iflag=direct \
+	status=none
+teardown
+
+# Check that commands fail after cmd_time_out seconds without a server
+setup ",cmd_time_out=1" idle
+start=$(date +%s)
+dd if=$dev of=/dev/null bs=4k count=1 iflag=direct status=none 2>/dev/null
+check "command timeout" [ $? -ne 0 -a $(($(date +%s) - start)) -lt 30 ]
+teardown
+
+rm -f "$IMG" "$PAT"
+exit $fail

-- 
2.43.0

