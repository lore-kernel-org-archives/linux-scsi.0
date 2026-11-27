Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795746832;
	b=AX1eDwXfEYAsmq54DHhfto0EFJ8uJwylOaWatI3dE8qPQARdgt7a2Yd9QICICH4m43Uk
	 3gXS+sIds7di34j9T9RT8U1QtLmm19oR1E4fQNGZYw4X/lhHdQ/q61dvfAfHPWN5AjH/f
	 2CwUb7NH1OUh0OVTpycjUUeP9RJNpqsOXNeLbDvSMT3nZYQmScCowfmh3lhqKWUDdjTXK
	 Xu84h8YdRYZAss785qsSjgVglLsZByuW3iTKZ2ekkn9897pA6R727UM3ptNfZtsGHN/61
	 WlldXFiyYe4fTWKS8lVKT9T1YHatt6j1+UIyezIM9xxFP/f+egzkTI3uIpWUzc7YP/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795746832;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rmA3UOVuwgHgrxYWncBFdcAQ5hkWLMJyTUaXd9VFA/4=;
	b=o2MqtUZpbc3z8swa3hvgxtmA1I97s/l0vpBYVO65E7eDKftsfCqtoVSKpWHIrPOeCOx6
	 9IO+WK2b0LE6sTVGmILMJCmhfgc8eBe1V6TvoqrHVPeB2j0EO0/Tu30VwpHKZKoO/eSi4
	 yKRHjTxV8ixZkSoJWboLZKoqAwAOhB+vSVoiKMAOEgfVH624MOJAXepYNGoOIo5C23fdo
	 DdUH6dXTMp0X/eJOQd2ecu4I2mLYIp/wpERBunviRPJpQ32JRep+j0KeZuq3SJsfkI5ke
	 CMw8X4MiYwIXNwAjTzqql92l3Ktk7ldrq6i1eaaH6jdoQbufaB/pylkb7Wqylt/IUog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p4kB1sGS;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD70C606A31C;
	Fri, 27 Nov 2026 02:33:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD70C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=p4kB1sGS
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795746827; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=rmA3UOVuwgHgrxYWncBFdcAQ5hkWLMJyTUaXd9VFA/4=;
	b=p4kB1sGSrZUl2oCwRdqgF2w8UVeRQv2qOgv0wUBj5+FU/yh6yxOiEUWbdWxQFJl7ARZa1b5FeIDRASNwoMW+Il5I/YCu5DFv/hOyd0A9aai6GcdGEZplX1MZ1619s99Rr4rSGXvDw7u0axoiLrmZg28yio7k03d01G5/1Nz3aPw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=zoutao@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0XFW9w4._1795746826;
Received: from localhost(mailfrom:zoutao@linux.alibaba.com fp:SMTPD_---0XFW9w4._1795746826 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Nov 2026 10:33:47 +0800
From: Tao Zou <zoutao@linux.alibaba.com>
To: Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Tao Zou <zoutao@linux.alibaba.com>
Subject: [PATCH 0/1] tcmu: Fix inode use-after-free in global data block pool
Date: Fri, 27 Nov 2026 10:33:45 +0800
Message-Id: <20261127023346.37933-1-zoutao@linux.alibaba.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

TCMU's global data block pool can dereference udev->inode after the VFS has
reclaimed the inode. tcmu_open() stores the pointer without taking a
reference, while delayed unmap work can still reach the configured device
through root_udev after the last UIO close.

I reproduced this on mainline using only user-space configuration and I/O.
On the unfixed 40212b29a6f718d4e7fb3275cede181cb8e137cf baseline, the
reproducer panics in down_read() through unmap_mapping_pages() and
find_free_blocks(). An earlier mainline build at
4dce97c6c265544342e716e62fd24bbb232590c5 produced the same target panic in
10/10 independent cold-boot runs.

Patch 1/1 holds an inode reference until the final tcmu_dev reference is
released. It replaces the pointer under cmdr_lock and drops the previous
reference after a reopen. The reference intentionally remains held across
tcmu_release(), since delayed unmap work still needs the inode after the
last UIO close.

With the patch applied, the unchanged reproducer survived its full trigger
sequence in 2/2 independent boots. The script's exit code 42 is its explicit
survival marker. Additional regression testing completed 20 tcmu-runner
restarts and 80 direct fio runs across four devices, followed by successful
destruction of all four devices. No BUG, Oops, WARNING, general protection
fault, or KASAN report was found after the regression run.

Using tcmu-runner 1.6.2 built from commit
1bdb239fa183c84d2ace6b52aa33476968a0cef7, the portable reproducer also
triggered the target panic once each on Debian 13 (6.12.118+deb13-amd64),
Ubuntu 26.04.1 (7.0.0-44-generic), and CentOS Stream 10
(6.12.0-284.el10.x86_64). Ubuntu was tested again after moving from 2 vCPU
and 4 GiB to 4 vCPU and 8 GiB, without changing the reproducer. These are
single-run portability checks, separate from the mainline A/B results.

The reproducer deliberately grooms shmem_inode_cache slab placement to make
the lifetime bug deterministic in the documented test environment; it is
not intended to estimate trigger probability under normal production loads.

WARNING: The reproducer is expected to panic a vulnerable kernel and must
only be run as root on a dedicated, disposable test VM with no data or other
workloads. Enable kdump before running if crash evidence is required.

The complete reproducer is included below as plain text. It requires
targetcli, tcmu-runner with its file handler, tcm_loop, fio, python3 and
udev. Test with init_on_free=1 panic_on_oops=1 on the kernel command line.

Thanks,
Tao Zou

----- BEGIN TCMU REPRODUCER: tcmu-inode-lifetime-reproducer.sh -----
#!/bin/bash
# WARNING: This script intentionally panics vulnerable kernels. Run it only
# as root on a dedicated, disposable VM with no data or other workloads.
# It requires targetcli, tcmu-runner with its file handler, tcm_loop, fio,
# python3 and udev. Test with init_on_free=1 panic_on_oops=1 on the kernel
# command line. Enable kdump before running if crash evidence is required.
set -euxo pipefail

DEVICE_COUNT=4
WWN=naa.5001405a11b22c40
IMAGE_PREFIX=/root/tcmu-userspace-page-zero
PARAM=/sys/module/target_core_user/parameters/global_max_data_area_mb
GUARD_DIR=/mnt/tcmu-page-zero-guards
MAX_GUARDS=4096
RUN_ID="$(date +%s%N)-$$"
RUN_DIR="/root/tcmu-userspace-runs/$RUN_ID"
mkdir -p "$RUN_DIR"
exec > >(tee "$RUN_DIR/reproduce.log") 2>&1

cat /etc/os-release
uname -a
[[ " $(cat /proc/cmdline) " == *" init_on_free=1 "* ]]
dmesg > "$RUN_DIR/dmesg-boot.txt"
grep -q 'heap free:on' "$RUN_DIR/dmesg-boot.txt"
[[ "$(cat /sys/kernel/slab/shmem_inode_cache/poison)" == 0 ]]
[[ "$(cat /proc/sys/kernel/panic_on_oops)" == 1 ]]
! grep -q '^spray ' /proc/modules
printf 'RUN_ID=%s\n' "$RUN_ID" | tee /root/tcmu-userspace-current-run
cat /proc/cmdline
cat /proc/sys/kernel/tainted
date -Ins
date +%s > "$RUN_DIR/start.epoch"
if command -v kdumpctl >/dev/null 2>&1; then
	kdumpctl status || true
fi
taskset -pc 0 $$

targetcli /loopback delete "$WWN" 2>/dev/null || true
for ((i = 0; i < DEVICE_COUNT; i++)); do
	targetcli /backstores/user:file delete "tcmu_page_zero_repro_${i}" 2>/dev/null || true
	rm -f "${IMAGE_PREFIX}-${i}.img"
done
udevadm settle

python3 - "$RUN_DIR/dev-paths-before.json" <<'PY'
import json
import os
import sys

paths = []
for root in ('/dev', '/run/udev'):
    for dirpath, dirnames, filenames in os.walk(root):
        paths.extend(os.path.join(dirpath, name) for name in dirnames + filenames)
with open(sys.argv[1], 'w') as output:
    json.dump(sorted(paths), output)
PY

mkdir -p "$GUARD_DIR"
if mountpoint -q "$GUARD_DIR"; then
	umount "$GUARD_DIR"
fi
mount -t tmpfs -o size=32M tmpfs "$GUARD_DIR"
mkdir "$GUARD_DIR/pre" "$GUARD_DIR/post"
printf '512\n' > "$PARAM"
systemctl start tcmu-runner
systemctl is-active tcmu-runner
taskset -apc 0 "$(systemctl show -p MainPID --value tcmu-runner)"
taskset -apc 0 "$(systemctl show -p MainPID --value systemd-udevd)"
if pgrep -x kdevtmpfs >/dev/null; then
	taskset -pc 0 "$(pgrep -x kdevtmpfs)"
fi

slab_count() {
	set -- $(grep '^shmem_inode_cache ' /proc/slabinfo)
	printf '%s\n' "${15}"
}

PRE_GUARD_COUNT=0
FRESH_SLABS=''

shopt -s nullglob
before_sd_paths=(/sys/class/block/sd*)
declare -A before_sd=()
for path in "${before_sd_paths[@]}"; do
	before_sd["${path##*/}"]=1
done

for ((i = 0; i < DEVICE_COUNT; i++)); do
	fresh=''
	for ((guard = 0; guard < MAX_GUARDS; guard++)); do
		old_count="$(slab_count)"
		: > "$GUARD_DIR/pre/g$PRE_GUARD_COUNT"
		PRE_GUARD_COUNT=$((PRE_GUARD_COUNT + 1))
		new_count="$(slab_count)"
		if ((new_count > old_count)); then
			fresh="$new_count"
			break
		fi
	done
	[[ -n "$fresh" ]]
	FRESH_SLABS="${FRESH_SLABS:+$FRESH_SLABS,}$fresh"
	image="${IMAGE_PREFIX}-${i}.img"
	name="tcmu_page_zero_repro_${i}"
	truncate -s 64M "$image"
	targetcli /backstores/user:file create name="$name" cfgstring="$image" size=64M
	udevadm settle
done
udevadm settle
uio_paths=(/dev/uio[0-9]*)
(( ${#uio_paths[@]} == DEVICE_COUNT ))
: > "$RUN_DIR/uio-stat.txt"
for UIO in "${uio_paths[@]}"; do
	[[ -c "$UIO" ]]
	stat --printf='path=%n dev=%d ino=%i mode=%f rdev=%r\n' "$UIO" | tee -a "$RUN_DIR/uio-stat.txt"
done
targetcli ls > "$RUN_DIR/targetcli-before-io.txt"

targetcli /loopback create "$WWN"
for ((i = 0; i < DEVICE_COUNT; i++)); do
	targetcli "/loopback/$WWN/luns" create "/backstores/user:file/tcmu_page_zero_repro_${i}"
done
for scan in /sys/class/scsi_host/host*/scan; do
	printf -- '- - -\n' > "$scan"
done
udevadm settle
new_sd_paths=()
for path in /sys/class/block/sd*; do
	if [[ -z "${before_sd[${path##*/}]+present}" ]]; then
		new_sd_paths+=("$path")
	fi
done
(( ${#new_sd_paths[@]} == DEVICE_COUNT ))
printf 'DEVICE_COUNT=%s\n' "$DEVICE_COUNT" > "$RUN_DIR/devices.env"
printf 'UIO_PATHS=%s\n' "${uio_paths[*]}" >> "$RUN_DIR/devices.env"
for ((i = 0; i < DEVICE_COUNT; i++)); do
	SD_DEVICE="/dev/${new_sd_paths[$i]##*/}"
	[[ -b "$SD_DEVICE" ]]
	printf 'SD_DEVICE_%s=%s\n' "$i" "$SD_DEVICE" | tee -a "$RUN_DIR/devices.env"
	properties="$RUN_DIR/scsi-device-${i}.properties"
	udevadm info --query=property --name="$SD_DEVICE" | tee "$properties"
	grep -q '^ID_VENDOR=LIO-ORG$' "$properties"
	grep -q '^DEVPATH=/devices/tcm_loop_' "$properties"
	printf 'running\n' > "/sys/block/${SD_DEVICE##*/}/device/state"
	timeout 45s fio --name="tcmu-userspace-page-zero-${i}" --filename="$SD_DEVICE" --direct=1 --ioengine=libaio --rw=write --bs=1M --size=64M --iodepth=32 --group_reporting > "$RUN_DIR/fio-${i}.log" 2>&1
	cat "$RUN_DIR/fio-${i}.log"
done
POST_GUARD_COUNT=0
SEALED_SLABS=''
for ((i = 0; i < MAX_GUARDS; i++)); do
	old_count="$(slab_count)"
	: > "$GUARD_DIR/post/g$i"
	POST_GUARD_COUNT=$((POST_GUARD_COUNT + 1))
	new_count="$(slab_count)"
	if ((new_count > old_count)); then
		SEALED_SLABS="$new_count"
		break
	fi
done
[[ -n "$SEALED_SLABS" ]]
printf 'PRE_GUARD_COUNT=%s\nPOST_GUARD_COUNT=%s\nFRESH_SLABS=%s\nSEALED_SLABS=%s\n' \
	"$PRE_GUARD_COUNT" "$POST_GUARD_COUNT" "$FRESH_SLABS" "$SEALED_SLABS" | tee "$RUN_DIR/guards.env"

systemctl stop tcmu-runner
systemctl is-active tcmu-runner || true
: > "$RUN_DIR/uio-holders.txt"
for UIO in "${uio_paths[@]}"; do
	if fuser "$UIO" >> "$RUN_DIR/uio-holders.txt" 2>&1; then
		cat "$RUN_DIR/uio-holders.txt"
		exit 1
	fi
done
systemctl stop systemd-udevd-kernel.socket systemd-udevd-control.socket systemd-udevd
systemctl is-active systemd-udevd || true
dmesg > "$RUN_DIR/dmesg-before-trigger.txt"
printf 'armed_epoch=%s\n' "$(date +%s)" | tee "$RUN_DIR/armed.env"

python3 - "$RUN_DIR/dev-paths-before.json" "$RUN_DIR/created-paths-removed.txt" <<'PY'
import json
import os
import stat
import sys

with open(sys.argv[1]) as source:
    before = set(json.load(source))
paths = []
for root in ('/dev', '/run/udev'):
    for dirpath, dirnames, filenames in os.walk(root):
        paths.extend(os.path.join(dirpath, name) for name in dirnames + filenames)
created = sorted(set(paths) - before)
with open(sys.argv[2], 'w') as output:
    for path in created:
        output.write(path + '\n')
for path in created:
    try:
        if not stat.S_ISDIR(os.lstat(path).st_mode):
            os.unlink(path)
    except FileNotFoundError:
        pass
for path in sorted(created, key=len, reverse=True):
    try:
        if stat.S_ISDIR(os.lstat(path).st_mode):
            os.rmdir(path)
    except FileNotFoundError:
        pass
PY
rm -f /run/rtslib_backstore.lock
python3 - "$GUARD_DIR" <<'PY'
import os
import sys

for group in ('pre', 'post'):
    root = os.path.join(sys.argv[1], group)
    for name in os.listdir(root):
        os.unlink(os.path.join(root, name))
    os.rmdir(root)
PY
umount "$GUARD_DIR"
printf '2\n' > /proc/sys/vm/drop_caches
grep '^shmem_inode_cache ' /proc/slabinfo > "$RUN_DIR/slabinfo-before-shrink.txt"
printf '1\n' > /sys/kernel/slab/shmem_inode_cache/shrink
printf '1\n' > "$PARAM"
grep '^shmem_inode_cache ' /proc/slabinfo > "$RUN_DIR/slabinfo-after-shrink.txt"
cat "$RUN_DIR/slabinfo-before-shrink.txt" "$RUN_DIR/slabinfo-after-shrink.txt"

sleep 15
cat "$PARAM"
dmesg > "$RUN_DIR/dmesg-after-trigger.txt"
printf 'survived=1\n' | tee "$RUN_DIR/survived.env"
exit 42
----- END TCMU REPRODUCER -----
