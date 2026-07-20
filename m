Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC1B428821;
	Mon, 20 Jul 2026 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556739; cv=none; b=Ur9LI+mozZfq3Rt1kGRpV0V9DfmhiAlhUdcDJfDNyNuCE7Lz/pUvQBVqgANmBBMbVC/HOIPvj1Y91C3suf+Yx+QR8/fBud8nW9nil+bxAghjE/wxDE/uC0gyHVAImlWbUgk78/xUdyWzE6GYNEvwa3ZndCphFRQ373pUSc9KfNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556739; c=relaxed/simple;
	bh=wFyv4zCJCgfqciWKcDdi3wOMYZ3kDnDfVWiFqUF1LbY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bVgPFpn9VYwO/Lf3zOiGWzC6HFkLSdSFmKlZ9N4wRtwJjoJ9bz7/cgJcc+C6M1guAF6sC7v2y/kReHfqagkbF8JE8P9XZWjR5SjMsCxedW60rfi9vcu02ZJq+jm/x6+FPjVnSAnqaV5diJ410T8nm3KI5YfkEuWkoE5qMT4ujj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=XFUWoVho; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="XFUWoVho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=NK2C9evq85wkl4PEOcMxTR7CF33U9RN9RnpkiN3Uk2o=;
	b=XFUWoVhoKAR37L5jre0U4wdtYzIu5MtzWnWb/jYBuzAKfFLYfLx5LtDoHMGfEN
	9mKQntVcBVdHYRfmCQc/malxFv+wFi0c3NYwYfniXd3987fGosIOOfslApcyiN0t
	7rr27D+ERhzhnGczSJqJ0cQeZQkPJUy64hBfqP3BMeLp4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3Xw9gLF5qWUvpIg--.12525S4;
	Mon, 20 Jul 2026 22:10:43 +0800 (CST)
From: "rom.wang" <r4o5m6e8o@163.com>
To: mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	stefanha@redhat.com
Cc: virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Yufeng Wang <wangyufeng@kylinos.cn>
Subject: [RFC PATCH 2/4] vhost: host kernel support for SQ/CQ polling
Date: Mon, 20 Jul 2026 22:10:38 +0800
Message-Id: <20260720141040.181946-3-r4o5m6e8o@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260720141040.181946-1-r4o5m6e8o@163.com>
References: <20260720141040.181946-1-r4o5m6e8o@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3Xw9gLF5qWUvpIg--.12525S4
X-Coremail-Antispam: 1Uf129KBjvAXoWkGFW8tFy5uFy8JrW7JFWrZrb_yoW3tF1kKo
	ZavrW5uF4rJry3Kwn5tr1xJFyDJ3ykKF93JF4Y9ay5Wa17tay5XF97KwsxWa1fJF4rta17
	A347J34fXr4kJFnxn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4Rl2NKUUUUU
X-CM-SenderInfo: 3uurkzkwhy0qqrwthudrp/xtbC7wRWy2peLGQvcAAA3V

From: Yufeng Wang <wangyufeng@kylinos.cn>

Implement SQ/CQ doorbell polling in the vhost kernel backend:

  - vhost.c: per-VQ poll thread (kthread) that polls sq->idx for
    submissions and processes completions via poll_complete callback;
    need_resched() cooperative spin; round-robin CPU binding with
    modulo to prevent overflow; sqcq_poll enabled after poll_task is
    valid (NULL deref fix); get_user fault retry (3 attempts, 10ms
    backoff); EMA overflow-safe formula
  - vhost.h: vhost_virtqueue extensions (sq/cq pointers, poll thread
    state, EMA fields)
  - scsi.c: vhost_scsi_poll_complete() writes cq->idx and signals
    Guest; SET_ENDPOINT error path stops started poll threads (fallback);
    10s window diagnostic output
  - vhost.h UAPI: VHOST_SET_VRING_SQCQ_ADDR ioctl
  - vhost_types.h UAPI: struct vhost_vring_sqcq_addr

Signed-off-by: Yufeng Wang <wangyufeng@kylinos.cn>
---
 Documentation/compare-sqcq-results.sh         | 239 +++++++
 Documentation/run-sqcq-compare.sh             | 182 ++++++
 Documentation/virtio-sqcq-poll-spec.rst       | 617 ++++++++++++++++++
 .../virtio-sqcq-poll-virtio-spec.rst          | 355 ++++++++++
 build-riscv-kernel.sh                         |  26 +
 drivers/vhost/scsi.c                          | 187 +++++-
 drivers/vhost/vhost.c                         | 595 ++++++++++++++++-
 drivers/vhost/vhost.h                         |  29 +-
 include/uapi/linux/vhost.h                    |   4 +
 include/uapi/linux/vhost_types.h              |   6 +
 10 files changed, 2221 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/compare-sqcq-results.sh
 create mode 100644 Documentation/run-sqcq-compare.sh
 create mode 100644 Documentation/virtio-sqcq-poll-spec.rst
 create mode 100644 Documentation/virtio-sqcq-poll-virtio-spec.rst
 create mode 100644 build-riscv-kernel.sh

diff --git a/Documentation/compare-sqcq-results.sh b/Documentation/compare-sqcq-results.sh
new file mode 100644
index 0000000000000..85bb927fe91e5
--- /dev/null
+++ b/Documentation/compare-sqcq-results.sh
@@ -0,0 +1,239 @@
+#!/usr/bin/env python3
+"""compare-sqcq-results.py - Generate A/B comparison report for SQ/CQ polling vs baseline.
+
+Usage:
+    python3 compare-sqcq-results.py <baseline_dir> <sqcq_dir>
+    python3 compare-sqcq-results.py   # auto-detect latest results
+"""
+import json, sys, os, glob, re
+from collections import OrderedDict
+
+def find_latest_dirs():
+    """Find the most recent baseline and sqcq-poll result directories."""
+    base = "perf-results"
+    if not os.path.isdir(base):
+        print(f"Error: '{base}/' not found. Run run-sqcq-compare.sh first.")
+        sys.exit(1)
+
+    bl_dirs = sorted(glob.glob(os.path.join(base, "baseline_*")))
+    sq_dirs = sorted(glob.glob(os.path.join(base, "sqcq-poll_*")))
+
+    if not bl_dirs:
+        print("Error: No baseline_* directory found in perf-results/")
+        sys.exit(1)
+    if not sq_dirs:
+        print("Error: No sqcq-poll_* directory found in perf-results/")
+        sys.exit(1)
+
+    return bl_dirs[-1], sq_dirs[-1]
+
+
+def parse_fio_json(filepath):
+    """Extract key metrics from a fio JSON output file."""
+    with open(filepath) as f:
+        d = json.load(f)
+
+    jobs = d.get("jobs", [])
+    if not jobs:
+        return None
+
+    j = jobs[0]
+    rd = j.get("read", {})
+    wr = j.get("write", {})
+
+    # Determine which direction has data
+    if rd.get("iops", 0) > 0:
+        data = rd
+    else:
+        data = wr
+
+    iops = data.get("iops", 0)
+    bw_mib = data.get("bw", 0) / 1024  # KiB/s -> MiB/s
+
+    # Latency
+    lat_ns = data.get("lat_ns", {})
+    avg_us = lat_ns.get("mean", 0) / 1000
+    min_us = lat_ns.get("min", 0) / 1000
+    max_us = lat_ns.get("max", 0) / 1000
+    stddev_us = lat_ns.get("stddev", 0) / 1000
+
+    # Completion latency percentiles
+    clat = data.get("clat_ns", {})
+    pct = clat.get("percentile", {}) if isinstance(clat, dict) else {}
+    p50 = pct.get("50.000000", 0) / 1000
+    p95 = pct.get("95.000000", 0) / 1000
+    p99 = pct.get("99.000000", 0) / 1000
+    p999 = pct.get("99.900000", 0) / 1000
+
+    return {
+        "iops": iops,
+        "bw_mib": bw_mib,
+        "lat_avg_us": avg_us,
+        "lat_min_us": min_us,
+        "lat_max_us": max_us,
+        "lat_stddev_us": stddev_us,
+        "p50_us": p50,
+        "p95_us": p95,
+        "p99_us": p99,
+        "p999_us": p999,
+    }
+
+
+def pct_change(old, new):
+    """Calculate percentage change. Returns None if division by zero."""
+    if old == 0:
+        return None
+    return (new - old) / old * 100
+
+
+def fmt_pct(val):
+    """Format a percentage change value."""
+    if val is None:
+        return "N/A"
+    sign = "+" if val > 0 else ""
+    return f"{sign}{val:.1f}%"
+
+
+def fmt_int(val):
+    """Format integer with comma separators."""
+    return f"{val:,.0f}"
+
+
+def fmt_f1(val):
+    """Format float with 1 decimal."""
+    return f"{val:.1f}"
+
+
+def main():
+    if len(sys.argv) >= 3:
+        bl_dir = sys.argv[1]
+        sq_dir = sys.argv[2]
+    else:
+        bl_dir, sq_dir = find_latest_dirs()
+
+    print(f"Baseline:   {bl_dir}")
+    print(f"SQ/CQ Poll: {sq_dir}")
+    print()
+
+    # Collect all test labels
+    bl_files = {os.path.basename(f).replace("_best.json", ""): f
+                for f in glob.glob(os.path.join(bl_dir, "*_best.json"))}
+    sq_files = {os.path.basename(f).replace("_best.json", ""): f
+                for f in glob.glob(os.path.join(sq_dir, "*_best.json"))}
+
+    all_labels = sorted(set(bl_files.keys()) | set(sq_files.keys()))
+
+    if not all_labels:
+        print("Error: No *_best.json files found.")
+        sys.exit(1)
+
+    # Define metric display columns
+    metrics = [
+        ("IOPS",        "iops",        fmt_int,  True),
+        ("BW(MiB/s)",   "bw_mib",      fmt_f1,   True),
+        ("Avg(us)",     "lat_avg_us",  fmt_f1,   False),
+        ("P50(us)",     "p50_us",      fmt_f1,   False),
+        ("P95(us)",     "p95_us",      fmt_f1,   False),
+        ("P99(us)",     "p99_us",      fmt_f1,   False),
+        ("P99.9(us)",   "p999_us",     fmt_f1,   False),
+    ]
+
+    # Per-label comparison
+    results = []
+    for label in all_labels:
+        bl_data = parse_fio_json(bl_files[label]) if label in bl_files else None
+        sq_data = parse_fio_json(sq_files[label]) if label in sq_files else None
+
+        entry = {"label": label, "baseline": bl_data, "sqcq": sq_data}
+        results.append(entry)
+
+    # Print grouped by workload type
+    groups = OrderedDict()
+    for label in all_labels:
+        # Extract workload type from label: e.g. "4k-randread-od1-nj1" -> "4k-randread"
+        parts = label.rsplit("-od", 1)
+        wl = parts[0] if len(parts) > 1 else label
+        if wl not in groups:
+            groups[wl] = []
+        groups[wl].append(label)
+
+    print("=" * 100)
+    print("  SQ/CQ POLL vs BASELINE COMPARISON REPORT")
+    print("=" * 100)
+
+    for wl, labels in groups.items():
+        print(f"\n{'─' * 100}")
+        print(f"  Workload: {wl}")
+        print(f"{'─' * 100}")
+
+        for label in labels:
+            r = next(x for x in results if x["label"] == label)
+            bl = r["baseline"]
+            sq = r["sqcq"]
+
+            # Extract iodepth/numjobs from label
+            m = re.search(r'od(\d+)-nj(\d+)', label)
+            od = m.group(1) if m else "?"
+            nj = m.group(2) if m else "?"
+
+            print(f"\n  iodepth={od}, numjobs={nj}")
+            print(f"  {'Metric':<14} {'Baseline':>12} {'SQ/CQ Poll':>12} {'Change':>10}")
+            print(f"  {'─'*14} {'─'*12} {'─'*12} {'─'*10}")
+
+            for metric_name, metric_key, fmt_fn, higher_is_better in metrics:
+                bl_val = bl[metric_key] if bl else 0
+                sq_val = sq[metric_key] if sq else 0
+                change = pct_change(bl_val, sq_val)
+
+                # For latency, negative change is improvement
+                line = f"  {metric_name:<14} {fmt_fn(bl_val):>12} {fmt_fn(sq_val):>12}"
+
+                if change is not None:
+                    marker = ""
+                    if higher_is_better and change > 2:
+                        marker = " *"
+                    elif not higher_is_better and change < -2:
+                        marker = " *"
+                    line += f" {fmt_pct(change):>10}{marker}"
+                else:
+                    line += f" {'N/A':>10}"
+
+                print(line)
+
+    # Summary table - just IOPS
+    print(f"\n{'=' * 100}")
+    print("  IOPS SUMMARY (all scenarios)")
+    print(f"{'=' * 100}")
+    print(f"\n  {'Test':<30} {'Baseline':>10} {'SQ/CQ':>10} {'Change':>10}")
+    print(f"  {'─'*30} {'─'*10} {'─'*10} {'─'*10}")
+
+    for r in results:
+        bl_iops = r["baseline"]["iops"] if r["baseline"] else 0
+        sq_iops = r["sqcq"]["iops"] if r["sqcq"] else 0
+        change = pct_change(bl_iops, sq_iops)
+
+        marker = " **" if change and change > 5 else ""
+        print(f"  {r['label']:<30} {bl_iops:>10,.0f} {sq_iops:>10,.0f} {fmt_pct(change):>10}{marker}")
+
+    # Latency summary
+    print(f"\n{'=' * 100}")
+    print("  P99 LATENCY SUMMARY (all scenarios)")
+    print(f"{'=' * 100}")
+    print(f"\n  {'Test':<30} {'Base(p99)':>12} {'SQ/CQ(p99)':>12} {'Change':>10}")
+    print(f"  {'─'*30} {'─'*12} {'─'*12} {'─'*10}")
+
+    for r in results:
+        bl_p99 = r["baseline"]["p99_us"] if r["baseline"] else 0
+        sq_p99 = r["sqcq"]["p99_us"] if r["sqcq"] else 0
+        change = pct_change(bl_p99, sq_p99)
+
+        marker = " **" if change and change < -5 else ""
+        print(f"  {r['label']:<30} {bl_p99:>12.1f} {sq_p99:>12.1f} {fmt_pct(change):>10}{marker}")
+
+    print(f"\n  *  = notable improvement")
+    print(f"  ** = significant improvement (>5% IOPS gain or >5% latency reduction)")
+    print()
+
+
+if __name__ == "__main__":
+    main()
diff --git a/Documentation/run-sqcq-compare.sh b/Documentation/run-sqcq-compare.sh
new file mode 100644
index 0000000000000..3a5928bfaef2a
--- /dev/null
+++ b/Documentation/run-sqcq-compare.sh
@@ -0,0 +1,182 @@
+#!/bin/bash
+# run-sqcq-compare.sh - A/B comparison for SQ/CQ polling vs baseline
+#
+# Usage:
+#   1. Boot Guest WITHOUT  VIRTIO_F_SQCQ_POLL:  ./run-sqcq-compare.sh baseline
+#   2. Boot Guest WITH     VIRTIO_F_SQCQ_POLL:  ./run-sqcq-compare.sh sqcq-poll
+#
+# Results saved to: perf-results/<mode>_<timestamp>/
+#
+# IMPORTANT: CPU pinning uses --cpus_allowed (NOT taskset).
+#            Verify with: ps -eo pid,comm,psr | grep fio
+#
+set -euo pipefail
+
+MODE=${1:?"Usage: $0 <baseline|sqcq-poll>"}
+DEV=${2:-/dev/sda}
+PIN_CPU=7
+RUNTIME=60
+RUNS=3
+
+TIMESTAMP=$(date +%Y%m%d-%H%M%S)
+OUTDIR="perf-results/${MODE}_${TIMESTAMP}"
+mkdir -p "$OUTDIR"
+
+# Verify CPU pinning mapping: PIN_CPU -> hwq -> single Host vq
+echo "=== CPU/mq mapping verification ==="
+echo "PIN_CPU=$PIN_CPU"
+for d in /sys/block/$(basename $DEV)/mq/*/; do
+    dir=$(basename "$d")
+    cpus=$(cat "$d/cpu_list" 2>/dev/null || echo "?")
+    echo "  hwq $dir: CPU $cpus"
+done
+echo ""
+
+echo "=== Mode: $MODE | Device: $DEV | CPU pin: $PIN_CPU | Runs: $RUNS ==="
+echo "=== Output: $OUTDIR ==="
+echo ""
+
+# Collect Host dmesg marker (for correlating with Host-side vhost stats)
+dmesg > "$OUTDIR/guest-dmesg-before.log" 2>/dev/null || true
+
+# Test matrix: label rw bs iodepth numjobs
+TESTS=(
+    "4k-randread-od1-nj1    randread   4k  1  1"
+    "4k-randread-od32-nj1   randread   4k  32 1"
+    "4k-randread-od32-nj4   randread   4k  32 4"
+    "4k-randread-od32-nj8   randread   4k  32 8"
+    "4k-randwrite-od1-nj1   randwrite  4k  1  1"
+    "4k-randwrite-od32-nj1  randwrite  4k  32 1"
+    "4k-randwrite-od32-nj4  randwrite  4k  32 4"
+    "4k-randwrite-od32-nj8  randwrite  4k  32 8"
+    "128k-seqread-od1-nj1   read       128k 1  1"
+    "128k-seqread-od32-nj1  read       128k 32 1"
+    "128k-seqread-od32-nj4  read       128k 32 4"
+    "128k-seqread-od32-nj8  read       128k 32 8"
+    "128k-seqwrite-od1-nj1  write      128k 1  1"
+    "128k-seqwrite-od32-nj1 write      128k 32 1"
+    "128k-seqwrite-od32-nj4 write      128k 32 4"
+    "128k-seqwrite-od32-nj8 write      128k 32 8"
+)
+
+for entry in "${TESTS[@]}"; do
+    read -r LABEL RW BS OD NJ <<< "$entry"
+
+    echo "=== $LABEL (iodepth=$OD, numjobs=$NJ) ==="
+
+    BEST_IOPS=0
+    BEST_FILE=""
+
+    for run in $(seq 1 $RUNS); do
+        OUTFILE="${OUTDIR}/${LABEL}_run${run}.json"
+
+        # For numjobs=1, pin to single CPU; for numjobs>1, let fio distribute
+        PIN_ARGS=""
+        if [ "$NJ" -eq 1 ]; then
+            PIN_ARGS="--cpus_allowed=$PIN_CPU --cpus_allowed_policy=shared"
+        fi
+
+        echo "  run $run/$RUNS ..."
+        fio --ioengine=libaio \
+            --direct=1 \
+            --rw="$RW" \
+            --bs="$BS" \
+            --iodepth=$OD \
+            --numjobs=$NJ \
+            $PIN_ARGS \
+            --time_based \
+            --runtime=$RUNTIME \
+            --group_reporting \
+            --percentile_list=50,95,99,99.9 \
+            --filename="$DEV" \
+            --name="$LABEL" \
+            --output-format=json \
+            --output="$OUTFILE"
+
+        # Extract IOPS from JSON
+        IOPS=$(python3 -c "
+import json, sys
+with open('$OUTFILE') as f:
+    d = json.load(f)
+jobs = d.get('jobs', [])
+if jobs:
+    rd = jobs[0].get('read', {})
+    wr = jobs[0].get('write', {})
+    iops = rd.get('iops', 0) + wr.get('iops', 0)
+    print(f'{iops:.0f}')
+else:
+    print('0')
+" 2>/dev/null || echo "0")
+
+        echo "    IOPS: $IOPS"
+
+        # Track best run
+        if [ "$IOPS" -gt "$BEST_IOPS" ]; then
+            BEST_IOPS=$IOPS
+            BEST_FILE=$OUTFILE
+        fi
+    done
+
+    # Copy best run as the canonical result
+    if [ -n "$BEST_FILE" ]; then
+        cp "$BEST_FILE" "${OUTDIR}/${LABEL}_best.json"
+    fi
+
+    echo ""
+done
+
+# Collect dmesg after
+dmesg > "$OUTDIR/guest-dmesg-after.log" 2>/dev/null || true
+
+# Generate summary
+echo "=== Generating summary ==="
+python3 - <<'PYEOF' "$OUTDIR"
+import json, sys, os, glob
+
+outdir = sys.argv[1]
+print(f"\n{'='*80}")
+print(f"  RESULTS: {os.path.basename(outdir)}")
+print(f"{'='*80}\n")
+
+header = f"{'Test':<30} {'IOPS':>10} {'p50(us)':>10} {'p99(us)':>10} {'p99.9(us)':>10} {'BW(MiB/s)':>10} {'lat_avg(us)':>12}"
+print(header)
+print("-" * len(header))
+
+for best in sorted(glob.glob(os.path.join(outdir, "*_best.json"))):
+    label = os.path.basename(best).replace("_best.json", "")
+    try:
+        with open(best) as f:
+            d = json.load(f)
+        jobs = d.get("jobs", [])
+        if not jobs:
+            continue
+
+        j = jobs[0]
+        rd = j.get("read", {})
+        wr = j.get("write", {})
+        iops = rd.get("iops", 0) + wr.get("iops", 0)
+        bw = (rd.get("bw", 0) + wr.get("bw", 0)) / 1024  # KiB/s -> MiB/s
+
+        lat_ns = rd.get("lat_ns", {}) or wr.get("lat_ns", {})
+        avg_us = lat_ns.get("mean", 0) / 1000
+
+        # Percentiles from clat_ns (completion latency)
+        clat = rd.get("clat_ns", {}) or wr.get("clat_ns", {})
+        pct = clat.get("percentile", {}) if isinstance(clat, dict) else {}
+        p50 = pct.get("50.000000", 0) / 1000
+        p99 = pct.get("99.000000", 0) / 1000
+        p999 = pct.get("99.900000", 0) / 1000
+
+        print(f"{label:<30} {iops:>10,.0f} {p50:>10.1f} {p99:>10.1f} {p999:>10.1f} {bw:>10.1f} {avg_us:>12.1f}")
+    except Exception as e:
+        print(f"{label:<30} ERROR: {e}")
+
+print()
+PYEOF
+
+echo ""
+echo "=== Done. Results in $OUTDIR ==="
+echo "=== After running both modes, compare with: ==="
+echo "    diff <(python3 summarize.py perf-results/baseline_*) <(python3 summarize.py perf-results/sqcq-poll_*)"
+echo ""
+echo "=== Or paste both summary tables side-by-side for comparison ==="
diff --git a/Documentation/virtio-sqcq-poll-spec.rst b/Documentation/virtio-sqcq-poll-spec.rst
new file mode 100644
index 0000000000000..523bb3e3a1963
--- /dev/null
+++ b/Documentation/virtio-sqcq-poll-spec.rst
@@ -0,0 +1,617 @@
+Virtio SQ/CQ Polling Mode — 技术规格书
+==========================================
+
+Host Kernel vhost 端已实现。Guest Kernel 端已实现。QEMU 端已实现。
+
+1. 概述
+-------
+
+传统 virtio 使用 MMIO kick (Guest→Device) 和 MSI-X 中断 (Device→Guest) 通知，
+每次涉及 VM exit。SQ/CQ polling 借鉴 io_uring SQPOLL 模型，在 split ring 旁引入
+SQ/CQ 门铃结构，由轮询线程检测变更替代中断，消除 VM exit。
+
+- Guest→Device：Guest 更新 SQ.idx，Device 轮询线程检测
+- Device→Guest：Device 更新 CQ.idx，Guest 轮询线程检测
+
+SQ/CQ 门铃仅做通知信号，实际数据仍通过 desc/avail/used ring 传递。
+通过 Feature Bit 协商，未协商时零开销。仅支持 split ring。
+
+1.1 地址传递架构
+~~~~~~~~~~~~~~~
+
+::
+
+  Guest Kernel          QEMU (userspace)       Host Kernel (vhost)
+  PCI config space      GPA → HVA 转换           VHOST_SET_VRING_SQCQ_ADDR
+  (写入 GPA)            ioctl (传入 HVA)            (接收 HVA)
+
+1.2 通知路径
+~~~~~~~~~~~~
+
+::
+
+  活跃路径（零开销）：
+    Guest 提交 → SQ.idx → Device 轮询检测（消除 VM exit）
+    Device 完成 → CQ.idx → Guest 轮询检测（消除 VM exit）
+
+  休眠唤醒路径：
+    Guest 提交 → SQ.idx → MMIO kick → QEMU → eventfd → vhost 唤醒
+    Device 完成 → CQ.idx → eventfd_signal → QEMU → MSI-X → Guest 唤醒
+
+
+2. Feature 协商
+---------------
+
+``VIRTIO_F_SQCQ_POLL = 42``（``include/uapi/linux/virtio_config.h``）。
+
+``VIRTIO_TRANSPORT_F_END`` 从 42 更新为 43。
+该 bit 属于 transport feature range (28..43)，需同时被 virtio_ring 和 virtio_pci 接受。
+vhost 端将该 feature 加入 ``VHOST_FEATURES`` 宏，在 ``VHOST_GET_FEATURES`` ioctl 中对 Guest 可见。
+
+**协商流程：**
+
+1. Device 设置 bit 42 → Guest 接受 → finalize_features
+2. Guest 在 find_vqs 阶段分配 SQ/CQ 结构
+3. Guest 在 vp_active_vq 阶段将 SQ/CQ DMA 地址写入 PCI config space
+4. QEMU 读 GPA → 转 HVA → ``VHOST_SET_VRING_SQCQ_ADDR`` ioctl → vhost
+5. vhost 在 ``VHOST_SCSI_SET_ENDPOINT`` 时启动轮询线程
+
+任一方不支持则回退传统中断模式。
+
+
+3. 数据结构
+-----------
+
+3.1 SQ/CQ 门铃
+~~~~~~~~~~~~~~~
+
+定义于 ``include/uapi/linux/virtio_ring.h``：
+
+.. code-block:: c
+
+    struct vring_sq {
+        __virtio64 idx;             /* Producer position: Guest 更新 */
+        __u8 sq_need_wakeup;        /* 1 = Device 应被 kick 唤醒 */
+        __u8 reserved[55];
+    } __attribute__((aligned(128)));  /* 128 bytes, cache-line 对齐 */
+
+    struct vring_cq {
+        __virtio64 idx;             /* Producer position: Device 更新 */
+        __u8 cq_need_wakeup;        /* 1 = Guest 应被中断唤醒 */
+        __u8 reserved[55];
+    } __attribute__((aligned(128)));  /* 128 bytes, cache-line 对齐 */
+
+- ``sq->idx`` 对应 ``avail->idx``，``cq->idx`` 对应 ``used->idx``
+- 128 字节对齐覆盖 ARM Neoverse N2/V2、Apple M 系列等 128 字节 cache line 的 CPU，
+  消除 SQ 与 CQ 之间的 false sharing
+- ``sq/cq_need_wakeup`` 为 8-bit 直接赋值字段，用于 NEED_WAKEUP 协议（见第 6 节）
+
+3.2 PCI Config Space 寄存器
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+追加到 ``struct virtio_pci_modern_common_cfg`` 末尾（offset 62 之后），
+定义于 ``include/uapi/linux/virtio_pci.h``：
+
+.. code-block:: c
+
+    #define VIRTIO_PCI_COMMON_SQE_LO    64
+    #define VIRTIO_PCI_COMMON_SQE_HI    68
+    #define VIRTIO_PCI_COMMON_CQE_LO    72
+    #define VIRTIO_PCI_COMMON_CQE_HI    76
+
+    __le32 sqe_ring_lo;    /* offset 64: SQ DMA 地址低 32 位 */
+    __le32 sqe_ring_hi;    /* offset 68: SQ DMA 地址高 32 位 */
+    __le32 cqe_ring_lo;    /* offset 72: CQ DMA 地址低 32 位 */
+    __le32 cqe_ring_hi;    /* offset 76: CQ DMA 地址高 32 位 */
+
+受 queue_select 约束。UAPI 已定义，Guest 已实现写入，QEMU 已实现读取。
+
+3.3 vhost UAPI
+~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    // include/uapi/linux/vhost.h
+    #define VHOST_SET_VRING_SQCQ_ADDR _IOW(VHOST_VIRTIO, 0x27, \
+                        struct vhost_vring_sqcq_addr)
+
+    // include/uapi/linux/vhost_types.h
+    struct vhost_vring_sqcq_addr {
+        unsigned int index;
+        __u64 sq_user_addr;    /* SQ doorbell HVA */
+        __u64 cq_user_addr;    /* CQ doorbell HVA */
+    };
+
+QEMU 调用时机：在 ``VHOST_SET_VRING_ADDR`` 之后、``VHOST_SCSI_SET_ENDPOINT`` 之前。
+
+3.4 写入时序
+~~~~~~~~~~~~
+
+Guest（vp_active_vq 中）：queue_select → desc/avail/used 地址 → sqe/cqe_ring_lo/hi 地址
+QEMU：组合 GPA → address_space_map 转 HVA → VHOST_SET_VRING_SQCQ_ADDR ioctl
+
+
+4. 字段读写所有权
+-----------------
+
+.. list-table::
+   :header-rows: 1
+   :widths: 20 20 20 25 15
+
+   * - 字段
+     - 写入方
+     - 读取方
+     - 内存序
+     - 对应
+
+   * - sq->idx
+     - Guest
+     - Device
+     - Guest: smp_store_release; Device: get_user + smp_rmb
+     - avail->idx
+
+   * - sq->sq_need_wakeup
+     - Device
+     - Guest
+     - Device: smp_wmb + put_user + smp_mb (double-check)
+     - NEED_WAKEUP
+
+   * - cq->idx
+     - Device
+     - Guest
+     - Device: smp_wmb before put_user; Guest: smp_load_acquire
+     - used->idx
+
+   * - cq->cq_need_wakeup
+     - Guest
+     - Device
+     - Guest: smp_store_release; Device: get_user + smp_rmb
+     - NEED_WAKEUP
+
+
+5. 核心协议
+-----------
+
+5.1 Guest 提交请求 (SQ 方向)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    // virtqueue_kick() 中 sqcq_poll 模式
+    smp_store_release(&vring->sq->idx, avail_idx_shadow);
+    need_wakeup = smp_load_acquire(&vring->sq->sq_need_wakeup);
+    if (need_wakeup)
+        virtqueue_notify(vq);  // MMIO write，仅在 Device 休眠时
+
+**关键：** Guest 仍写 ``avail->idx``（``virtqueue_add_split()`` 完成）。
+SQ idx 是额外通知信号，让 Device 快速检测（读一个 cache line vs 读 avail ring 两次）。
+Device 的 ``handle_kick()`` 通过 ``avail->idx`` 定位 descriptor。
+
+**virtqueue_kick_prepare() 守卫：** sqcq_poll 模式下直接返回 ``true``，
+不检查 ``used->flags``（vhost 不维护该 flag）。
+
+5.2 Device 处理请求 (vhost 轮询线程)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+独立 kthread ``vhost_sqcq_poll_thread``。直接调用 ``handle_kick`` 处理提交，
+通过 ``poll_complete`` 回调处理完成，单线程闭环。
+
+主循环伪代码（drivers/vhost/vhost.c）：
+
+.. code-block:: c
+
+    while (!poll_stop):
+        // 0. 处理 pending completion
+        if (atomic_read(&vq->completion_pending) && vq->poll_complete):
+            atomic_set(&vq->completion_pending, 0)
+            vq->poll_complete(vq)  // copy resp, add used, 写 cq->idx, 检查 cq_need_wakeup
+
+        // 1. 读 SQ idx
+        ret = get_user(sq_idx_val, &vq->sq->idx)
+        smp_rmb()  // acquire
+        new_sq_idx = (u16)sq_idx_val
+
+        // 2. 有新提交：同步调用 handle_kick
+        if (new_sq_idx != vq->last_avail_idx):
+            vq->handle_kick(&vq->poll.work)
+
+        // 3. 自适应休眠（EMA 动态超时）
+        should_sleep = (last_avail_idx == last_used_idx)
+        if (!should_sleep && ema_ns > 0)
+            should_sleep = (active_io_vqs > 1) && (ema_us > SQCQ_SLEEP_THRESHOLD_US)
+
+        if (should_sleep):
+            timeout = ema_based_or_fallback(SQCQ_IDLE_TIMEOUT_US_MAX)
+            // 设置 NEED_WAKEUP + double-check idx
+            smp_wmb(); put_user(1, &sq->sq_need_wakeup); smp_mb()
+            if (idx changed): put_user(0, &sq->sq_need_wakeup); continue
+            // 注册 kick eventfd，带超时等待
+            kick_register(vq)
+            wait_event_interruptible_timeout(poll_wait,
+                poll_stop || kick_received || completion_pending, timeout)
+            was_kicked = READ_ONCE(kick_received)
+            kick_unregister(vq)
+            put_user(0, &sq->sq_need_wakeup)
+        else:
+            cpu_relax()
+
+5.3 I/O 完成路径
+~~~~~~~~~~~~~~~~~
+
+Poll 模式下 completion 不经过 vhost_worker：
+
+1. **TCM 完成**（中断/workqueue 上下文）：``llist_add`` + ``atomic_set(completion_pending, 1)`` + 条件 ``wake_up``
+2. **Poll thread 步骤 0**（poll thread 上下文）：``poll_complete`` 回调
+3. **poll_complete 内部**：``llist_del_all`` → ``mutex_lock`` → copy response + ``vhost_add_used`` → ``mutex_unlock`` → ``put_user(cq->idx)`` → 检查 ``cq_need_wakeup`` → ``eventfd_signal``
+
+设计要点：单线程闭环（handle_kick 和 poll_complete 顺序执行，共享 mutex 不会死锁）；
+CQ idx 单写者（仅 poll_complete）；条件 wake_up（仅在 poll thread 非 RUNNING 时）。
+
+5.4 vhost_enable/disable_notify 在 poll 模式下
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- ``vhost_enable_notify()`` → ``return false``
+- ``vhost_disable_notify()`` → ``return``
+
+通知控制由 sq_need_wakeup / cq_need_wakeup 承担，used ring flags 不再有效。
+Guest 端对称：``virtqueue_kick_prepare()`` 直接返回 true，``disable_cb/enable_cb`` 操作 avail->flags 但 vhost 忽略。
+
+5.5 Guest 接收完成 (CQ 方向)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Guest 轮询线程（``virtio_sqcq_poll_thread``），每 device 一个线程。
+
+主循环要点：
+
+1. ``while (cq_poll_has_work())`` drain 该 vq 所有完成，callback 后 ``do_softirq()``
+2. 有工作时重置 ``last_io_ts = ktime_get()``，不 yield，快速轮询
+3. 无工作时基于 ``last_io_ts`` 时间窗口自旋（``busy_spin_us`` = 1ms）
+4. 自旋中使用 ``need_resched()`` + ``cpu_relax()`` 协作让出（io_uring SQPOLL 模型）
+5. spin 窗口过期后设置所有 vq 的 ``cq_need_wakeup`` + double-check ``more_used()``
+6. 无新工作则 ``schedule_timeout(idle_timeout_us)`` 休眠（1ms）
+7. 醒来后清除所有 vq 的 NEED_WAKEUP，不重置 spin 窗口（超时唤醒不 re-arm spin）
+
+**CQ 完成检测：** 直接使用 ``more_used(vq)`` 检查 used ring，不再轮询 ``cq->idx``。
+``cq->idx`` 仅由 Device 写入，保留用于 NEED_WAKEUP 协议的 ``cq_need_wakeup`` 字段，
+不再作为完成检测的 fast path（消除了 cq->idx 与 used ring 之间的竞态）。
+
+**CQ 访问器函数** (virtio_ring.c)：
+
+- ``cq_poll_has_work(vq)``：``more_used(vq)`` — 直接检查 used ring
+- ``cq_set_need_wakeup(vq)``：``smp_store_release(&cq->cq_need_wakeup, 1)``
+- ``cq_clear_need_wakeup(vq)``：``WRITE_ONCE(cq->cq_need_wakeup, 0)``
+- ``cq_recheck(vq)``：``smp_mb()`` + ``more_used(vq)``
+
+5.6 Device 唤醒路径 (kick eventfd 桥接)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+::
+
+  Guest MMIO kick → QEMU eventfd write → eventfd wq →
+  vhost_sqcq_kick_wakeup() → kick_received=true + wake_up →
+  poll thread → clear sq_need_wakeup → process sq->idx
+
+休眠前通过 ``vhost_sqcq_kick_register()`` 注册到 kick eventfd wait queue。
+关键：``vfs_poll`` 可能因 stale counter 返回 EPOLLIN，必须验证 ``sq->idx``
+确实有新工作才触发回调，否则所有 poll thread busy-loop。
+
+QEMU 端无需额外操作，现有 kick eventfd 路径即可。
+
+
+6. NEED_WAKEUP 协议（核心，必须严格遵守）
+-----------------------------------------
+
+双向对称，SQ 和 CQ 各一套。避免死锁和丢失唤醒的核心机制。
+
+6.1 SQ 方向
+~~~~~~~~~~~
+
+**Device 休眠前：**
+
+.. code-block:: pseudo
+
+    smp_wmb()
+    sq->sq_need_wakeup = 1
+    smp_mb()
+    new_sq_idx = sq->idx           // double-check
+    if (new_sq_idx != last_avail):
+        sq->sq_need_wakeup = 0     // 取消休眠
+        goto process
+    wait_event(kick_received)
+    sq->sq_need_wakeup = 0         // 醒来后清除
+
+**Guest 提交后：**
+
+.. code-block:: pseudo
+
+    smp_store_release(&sq->idx, new_idx)
+    need_wakeup = smp_load_acquire(&sq->sq_need_wakeup)
+    if (need_wakeup)
+        virtqueue_notify(vq)       // MMIO kick
+
+6.2 CQ 方向
+~~~~~~~~~~~
+
+    **Guest 休眠前：**
+
+.. code-block:: pseudo
+
+    smp_store_release(&cq->cq_need_wakeup, 1)
+    smp_mb()
+    if (more_used(vq)):             // double-check used ring
+        cq->cq_need_wakeup = 0     // 取消休眠
+        goto process
+    schedule_timeout(idle_timeout_us)
+    cq->cq_need_wakeup = 0         // 醒来后清除
+
+**Device 完成后（两阶段）：**
+
+1. release_cmd：``llist_add`` + ``atomic_set(completion_pending, 1)`` + 条件 ``wake_up``
+2. poll_complete：copy resp → add used → ``put_user(cq->idx)`` → 检查 ``cq_need_wakeup`` → ``eventfd_signal``
+
+6.3 为什么需要 Double-check
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+设置 NEED_WAKEUP → 重读 idx 之间存在竞态：Guest 可能在 Device 读 idx 后、
+sleep 前提交。Device 在 sleep 前重读 idx，如果变了则取消休眠。
+此时 Guest 的 kick 可能已到也可能未到，但 Device 已在处理新工作，不影响正确性。
+
+6.4 内存序总结
+~~~~~~~~~~~~~~
+
+- idx 更新：写入方 store-release（Guest: ``smp_store_release``；Device: ``smp_wmb`` + ``put_user``）
+- idx 读取：Guest 使用 ``more_used()`` 直接检查 used ring（不再轮询 ``cq->idx``）
+- sq_need_wakeup 读取：Guest 使用 ``smp_load_acquire``（替代 ``smp_mb`` + ``READ_ONCE``）
+- NEED_WAKEUP 设置后 ``smp_mb()``，然后重读 used ring / sq->idx
+- NEED_WAKEUP 清除在 sleep 唤醒后立即执行
+- x86 上屏障为 no-op（TSO），ARM/RISC-V 上生成实际屏障指令
+
+
+7. QEMU 实现指南
+----------------
+
+7.1 Feature 协商
+~~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    virtio_add_feature(&vdev->host_features, VIRTIO_F_SQCQ_POLL);
+
+7.2 GPA → HVA 转换
+~~~~~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    hwaddr sq_gpa = (sqe_ring_hi << 32) | sqe_ring_lo;
+    void *sq_hva = address_space_map(&address_space_memory, sq_gpa, sizeof(struct vring_sq), false);
+    // ... cq 类似
+    struct vhost_vring_sqcq_addr addr = { .index = idx, .sq_user_addr = sq_hva, .cq_user_addr = cq_hva };
+    ioctl(vhost_fd, VHOST_SET_VRING_SQCQ_ADDR, &addr);
+
+7.3 ioctl 调用顺序
+~~~~~~~~~~~~~~~~~~
+
+启动：
+
+::
+
+  1. VHOST_SET_VRING_ADDR (desc/avail/used)
+  2. VHOST_SET_VRING_SQCQ_ADDR (sq/cq) — 新增
+  3. VHOST_SET_VRING_KICK
+  4. VHOST_SET_VRING_CALL
+  5. VHOST_SCSI_SET_ENDPOINT — 触发轮询线程启动
+
+停止：
+
+::
+
+  1. VHOST_SCSI_CLEAR_ENDPOINT — 自动停止轮询线程
+  2. VHOST_SET_VRING_KICK (null_fd)
+  3. VHOST_SET_VRING_CALL (null_fd)
+
+7.4 call eventfd 处理
+~~~~~~~~~~~~~~~~~~~~~
+
+收到 eventfd signal 说明 Guest 设置了 cq_need_wakeup，需注入 MSI-X 中断。
+使用现有 ``virtio_irq()`` / ``virtio_notify_irqfd()`` 即可。
+
+即使启用 polling，Device 仍需保留中断能力（CQ NEED_WAKEUP 唤醒、config change、fallback）。
+
+7.5 内存序
+~~~~~~~~~~
+
+QEMU 用户态需使用 ``atomic_store_release`` / ``atomic_load_acquire`` 或 C11 ``stdatomic.h``。
+
+
+8. Host Kernel vhost 端实现
+----------------------------
+
+8.1 vhost_virtqueue 扩展
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. code-block:: c
+
+    struct vhost_virtqueue {
+        /* ... 现有字段 ... */
+        /* SQ/CQ polling mode */
+        bool sqcq_poll;
+        struct vring_sq __user *sq;
+        struct vring_cq __user *cq;
+        struct task_struct *poll_task;
+        bool poll_stop;
+        wait_queue_head_t poll_wait;
+        struct completion poll_started, poll_stopped;
+        bool kick_received;
+        atomic_t completion_pending;
+        void (*poll_complete)(struct vhost_virtqueue *vq);
+        wait_queue_head_t *kick_wqh;
+        wait_queue_entry_t kick_wait;
+        poll_table kick_pt;
+        /* 10s 统计窗口和 EMA */
+        u64 ema_latency_ns;     /* EMA of cmd processing latency */
+        u64 ema_interval_ns;    /* EMA of cmd-to-cmd interval */
+        /* ... lat_*/stat_* 统计字段 ... */
+    };
+
+8.2 ioctl 处理
+~~~~~~~~~~~~~~
+
+``vhost_vring_set_sqcq_addr()``：copy_from_user → 验证地址/对齐 → access_ok（backend 已配置时）→ 存储 sq/cq。
+另含自动启动逻辑：当 private_data && sq && cq && !sqcq_poll && poll_complete && feature 时调 ``vhost_sqcq_poll_start()``。
+
+8.3 独立轮询线程
+~~~~~~~~~~~~~~~~~
+
+kthread ``vhost-sqcq-<pid>-<vq_offset>``，通过 ``kthread_use_mm(dev->mm)`` 绑定 QEMU 地址空间。
+直接调用 ``handle_kick`` 处理提交，``poll_complete`` 处理完成，单线程闭环。
+
+API：``vhost_sqcq_poll_start(vq)`` / ``vhost_sqcq_poll_stop(vq)``。
+start 时先创建 kthread 并等待 ``poll_started`` completion，然后才设置 ``sqcq_poll = true``，
+确保 ``vhost_signal()`` 看到 sqcq_poll 时 ``poll_task`` 已有效（消除 NULL deref 窗口）。
+stop 后清除 poll_task、sqcq_poll、sq、cq，flush 残留 completion。
+
+8.4 策略常量与 CPU 绑核
+~~~~~~~~~~~~~~~~~~~~~~~
+
+策略常量（编译期固定，``#define``）：
+
+.. code-block:: c
+
+    #define SQCQ_IDLE_TIMEOUT_US_MAX    1000U   /* sleep 时长上界 (us) */
+    #define SQCQ_SLEEP_EMA_MULT         2       /* sleep 时长 = N * ema_latency */
+    #define SQCQ_SLEEP_THRESHOLD_US     20U     /* 快于此时长的后端选择 spin */
+    #define SQCQ_SPIN_EMA_MULT          2       /* inflight spin 窗口 = N * ema_latency */
+    #define SQCQ_ACTIVE_TIMEOUT_NS      1000000U    /* 无 inflight 固定自旋窗口 1ms */
+    #define SQCQ_STALE_TIMEOUT_NS       1000000000ULL /* sq_was_active 兜底清除 1s */
+
+**CPU 绑核**：round-robin（``sqcq_poll_cpu_rr`` 全局原子计数器 ``% num_online_cpus()``），
+分散到不同在线 CPU。计数器取模确保重启后不会溢出到 fallback（全绑 cpu0）。
+
+**协作式自旋**（io_uring SQPOLL 模型）：两条自旋路径均使用
+``need_resched()`` / ``cond_resched()`` 协作让出——自旋时若调度器标记需要让出，
+主动 ``cond_resched()``，避免饿死同核其他任务。线程保持 TASK_RUNNING（轮询
+``sq->idx``），不进入 sleep 路径、不设 ``sq_need_wakeup``，从而消除 Guest kick
+（VM exit）。仅在无 inflight 且超过 1ms 无新提交时才真正 sleep。
+
+**TCM 完成 CPU 导向**：``sqcq_poll_active_cpu_mask`` 记录忙 poll 线程占用的 CPU
+（跟着 ``sq_was_active`` 翻转）。``vhost_sqcq_pick_completion_cpu()`` 从空闲 CPU
+中选一个给 TCM 完成，避开忙 poll 核；全占满时回退到 next-CPU。
+
+8.5 vhost_signal / notify
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+- ``vhost_signal()``：poll 模式下设 completion_pending + 条件 wake_up。SCSI completion 不经过此路径
+- ``vhost_enable_notify()``：poll 模式下 return false
+- ``vhost_disable_notify()``：poll 模式下 return
+- ``vhost_dev_stop()``：仅对 sqcq_poll vq 加锁停止
+
+8.6 vhost-scsi 集成
+~~~~~~~~~~~~~~~~~~~
+
+``set_endpoint`` 中对 I/O VQs（index >= VHOST_SCSI_VQ_IO）：如果 feature + sq + cq 则 start。
+``clear_endpoint`` 中先 stop 再 clear backend。
+
+8.7 call_ctx.ctx NULL 检查
+~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+``poll_complete`` 中 ``eventfd_signal(call_ctx.ctx)`` 前做 NULL 检查。
+QEMU 必须在 SET_ENDPOINT 之前完成 SET_VRING_CALL 设置。
+
+8.8 空闲策略与 EMA
+~~~~~~~~~~~~~~~~~~
+
+系统维护两个独立的 EMA：
+- ``ema_latency_ns``：cmd 处理延迟（submit → process_completions）的 EMA，每次 ``poll_complete`` 后更新 ``old - old/8 + avg/8``（溢出安全）
+- ``ema_interval_ns``：cmd-to-cmd 间隔的 EMA，每次检测到 sq->idx 变化时更新 ``old - old/8 + new/8``
+
+**无 inflight 自旋**（io_uring SQPOLL 模型）：固定 ``SQCQ_ACTIVE_TIMEOUT_NS``（1ms）
+窗口 + ``cond_resched()`` 协作让出。线程持续轮询 ``sq->idx`` 接住下一条提交，
+不进入 sleep 路径、不设 ``sq_need_wakeup`` → 消除 Guest kick（VM exit）。
+仅在超过 1ms 无新提交时才 sleep。
+
+**有 inflight 自旋**：``spin_ns = SQCQ_SPIN_EMA_MULT * ema_latency_ns``，
+``cond_resched()`` 协作让出。超出窗口或多 VQ + 高延迟时 sleep。
+
+Sleep 动态超时：``timeout = ema_latency / (1000 / SQCQ_SLEEP_EMA_MULT)``，clamp 到 [10us, SQCQ_IDLE_TIMEOUT_US_MAX]。
+多 VQ 休眠决策：有 inflight 时仅在 ``sqcq_active_io_vqs > 1`` 且 ``ema_latency_us > SQCQ_SLEEP_THRESHOLD_US`` 时休眠。
+
+8.9 统计与诊断
+~~~~~~~~~~~~~~
+
+10s 统计窗口，打印 cq/fail/sq_hits/enters/wkick/wcomp/avg/kick_pct/wait_pct/cqw_pct/spin_pct/wake_avg/wake_n/interval/ema_lat/inflight 到 dmesg。
+Stuck 检测：wait_event 超时或窗口内无完成但有 inflight 时告警。
+
+9. Guest Kernel 端实现
+-----------------------
+
+9.1 SQ/CQ DMA 分配
+~~~~~~~~~~~~~~~~~~
+
+``virtio_alloc_sqcq()``：``dma_alloc_coherent()`` 一次分配 256 bytes（sq+cq 各 128 字节），
+在 ``vring_create_virtqueue_split()`` 中分配，``vring_free`` 时释放。
+
+9.2 地址传递
+~~~~~~~~~~~~
+
+``vp_modern_queue_address_sqcq()``：在 ``vp_active_vq()`` 中，通过 PCI common config
+的 queue_select + sqe/cqe_ring_lo/hi 写入 64 位 DMA 地址。
+
+9.3 提交路径
+~~~~~~~~~~~~
+
+``virtqueue_kick()``：``smp_store_release(&sq->idx, shadow)`` → 如果 NEED_WAKEUP 则 MMIO kick。
+``virtqueue_kick_prepare()``：sqqcq_poll 下直接 return true。
+
+9.4 CQ 轮询线程
+~~~~~~~~~~~~~~~~~
+
+独立 kthread ``virtio-sqcq/<device_name>``，每 device 一个线程（``struct virtio_sqcq_poll_data``）。
+
+**CQ 访问器函数** (virtio_ring.c)：
+
+- ``cq_poll_has_work(vq)``：``smp_load_acquire(&cq->idx) != last_cq_head``
+- ``cq_poll_consume(vq)``：snapshot cq->idx（callback 前）
+- ``cq_set_need_wakeup(vq)``：``smp_store_release(&cq->cq_need_wakeup, 1)``
+- ``cq_clear_need_wakeup(vq)``：``WRITE_ONCE(cq->cq_need_wakeup, 0)``
+- ``cq_recheck(vq)``：``smp_mb()`` + ``smp_load_acquire(&cq->idx) != last_cq_head``
+
+**线程生命周期：** ``vp_modern_find_vqs()`` 中启动（``virtio_start_sqcq_poll(vdev, 1000, 1000)``），
+注册所有 poll 活跃的 vq。``vp_del_vqs()`` 中停止（``virtio_stop_sqcq_poll`` 内部释放所有 vq node）。
+
+**启动参数：** ``idle_timeout_us=1000``（1ms sleep 超时），``busy_spin_us=1000``（1ms spin 预算）。
+不绑核（调度器自由分配），无指数退避（固定 1ms sleep）。
+
+**config 空间大小检查：** ``vp_check_common_size()`` 验证 common config 至少 80 字节。
+
+
+10. 与现有机制的关系
+---------------------
+
+- **EVENT_IDX：** 可协商但对 polling vq 无效，被 sq/cq_need_wakeup 替代
+- **virtio-net NAPI：** 可共存，NAPI 可直接检查 CQ
+- **blk-mq iopoll：** 互补（iopoll 同步快路径，SQ/CQ 替代异步中断路径）
+- **Live Migration：** reset 时回退中断模式，迁移后 Guest 重新协商
+
+
+11. 文件清单
+------------
+
+**Guest Kernel：** ``virtio_config.h`` (feature bit), ``virtio_ring.h`` (vring_sq/cq),
+``virtio_pci.h`` (PCI offsets), ``virtio_ring.c`` (分配/SQ提交/CQ accessor),
+``virtio_sqcq_poll.c`` (CQ 轮询线程), ``virtio_pci_modern.c`` (feature/queue激活/线程生命周期),
+``virtio_pci_common.c`` (vp_del_vqs), ``virtio_pci_modern_dev.c`` (PCI config 映射)
+
+**Host Kernel vhost：** ``vhost.h`` (ioctl), ``vhost_types.h`` (sqcq_addr struct),
+``vhost.h/vhost.c`` (轮询线程/ioctl/signal/生命周期), ``scsi.c`` (vhost-scsi 集成)
+
+**QEMU：** ``virtio-pci.c`` (feature/config), ``virtio-pci-modern.c`` (BAR/GPA→HVA)
+
+
+12. 验证方案
+------------
+
+**功能：** QEMU 带 VIRTIO_F_SQCQ_POLL + virtio-scsi → Guest 读写验证正确性。
+
+**性能：** fio 对比中断模式 vs polling，观察 IOPS/延迟/VM exit 次数。
+
+**正确性：** 24h+ stress test；idle/wakeup 验证；NEED_WAKEUP 边界条件；ARM/RISC-V 内存序验证。
diff --git a/Documentation/virtio-sqcq-poll-virtio-spec.rst b/Documentation/virtio-sqcq-poll-virtio-spec.rst
new file mode 100644
index 0000000000000..26ae41860a8e5
--- /dev/null
+++ b/Documentation/virtio-sqcq-poll-virtio-spec.rst
@@ -0,0 +1,355 @@
+SQ/CQ Doorbell Polling
+======================
+
+This section describes the SQ/CQ doorbell polling mechanism
+(``VIRTIO_F_SQCQ_POLL``), which allows the driver and device to use
+shared-memory doorbells instead of MMIO writes (notifications) and
+interrupts, eliminating VM exits on both submission and completion paths.
+
+This feature is only supported with split virtqueues. A driver or
+device that negotiates this feature MUST NOT also negotiate
+``VIRTIO_F_RING_PACKED``.
+
+
+Feature bit
+-----------
+
+``VIRTIO_F_SQCQ_POLL (42)`` — SQ/CQ Doorbell Polling.
+
+This feature is in the transport feature range (28..43). Both
+``virtio_ring`` and ``virtio_pci`` MUST accept this feature for it
+to be negotiated.
+
+
+Data Structures
+---------------
+
+SQ Doorbell
+~~~~~~~~~~~
+
+The SQ (Submission Queue) doorbell is a cache-line aligned structure
+written by the driver and read by the device:
+
+.. code-block:: c
+
+    struct vring_sq {
+        le64 idx;
+        u8   sq_need_wakeup;
+        u8   reserved[55];
+    };
+
+The structure MUST be aligned to the cache line size of the platform
+(minimum 64 bytes; 128 bytes recommended for platforms with 128-byte
+cache lines such as ARM Neoverse N2/V2).
+
+``idx`` corresponds to ``avail->idx`` and is written by the driver
+using ``smp_store_release()``.
+
+``sq_need_wakeup`` is a single-byte flag written by the device,
+indicating whether the device's poll thread is sleeping and needs to
+be woken by an MMIO write (kick).
+
+CQ Doorbell
+~~~~~~~~~~~
+
+The CQ (Completion Queue) doorbell is a cache-line aligned structure
+written by the device and read by the driver:
+
+.. code-block:: c
+
+    struct vring_cq {
+        le64 idx;
+        u8   cq_need_wakeup;
+        u8   reserved[55];
+    };
+
+The structure MUST be aligned to the same alignment as ``vring_sq``.
+
+``idx`` corresponds to ``used->idx`` and is written by the device.
+
+``cq_need_wakeup`` is a single-byte flag written by the driver,
+indicating whether the driver's poll thread is sleeping and needs to
+be woken by an interrupt.
+
+
+PCI Configuration
+-----------------
+
+The SQ and CQ doorbell DMA addresses are passed through the PCI
+common configuration space. Four new registers are appended to
+``struct virtio_pci_modern_common_cfg``:
+
+==============  ========  ========================================
+Offset          Field     Description
+==============  ========  ========================================
+64              sqe_ring_lo  SQ doorbell DMA address, low 32 bits
+68              sqe_ring_hi  SQ doorbell DMA address, high 32 bits
+72              cqe_ring_lo  CQ doorbell DMA address, low 32 bits
+76              cqe_ring_hi  CQ doorbell DMA address, high 32 bits
+==============  ========  ========================================
+
+These registers are scoped by ``queue_select``. The driver writes
+the SQ and CQ doorbell DMA addresses for each virtqueue during
+``vp_active_vq``.
+
+The device (QEMU) translates the guest physical address to a host
+virtual address and passes it to the vhost backend via
+``VHOST_SET_VRING_SQCQ_ADDR`` ioctl.
+
+
+Allocation
+----------
+
+The driver allocates SQ and CQ doorbells as a single
+``dma_alloc_coherent()`` call (contiguous physical memory):
+
+.. code-block:: c
+
+    size_t total = sizeof(struct vring_sq) + sizeof(struct vring_cq);
+    void *buf = dma_alloc_coherent(dev, total, &dma_addr, GFP_KERNEL);
+    vq->sq = buf;
+    vq->cq = buf + sizeof(struct vring_sq);
+
+Control and event virtqueues MUST NOT use SQ/CQ polling. Only request
+virtqueues (index >= VIRTIO_SCSI_VQ_BASE for virtio-scsi) negotiate
+this feature.
+
+
+Submission Path (Driver → Device)
+---------------------------------
+
+When the driver has new requests available:
+
+1. The driver writes descriptors to the avail ring as usual
+2. The driver updates ``sq->idx`` using ``smp_store_release()``
+3. The driver reads ``sq_need_wakeup`` using ``smp_load_acquire()``
+
+If ``sq_need_wakeup`` is 0, the device's poll thread is actively
+spinning and will detect the new ``sq->idx`` value without any
+further action.
+
+If ``sq_need_wakeup`` is 1, the device's poll thread is sleeping.
+The driver MUST perform a traditional MMIO write (kick) to wake it.
+
+.. code-block:: pseudo
+
+    smp_store_release(&sq->idx, avail_idx_shadow)
+    need_wakeup = smp_load_acquire(&sq->sq_need_wakeup)
+    if (need_wakeup):
+        mmio_kick(vq)
+
+The ``virtqueue_kick_prepare()`` function MUST return ``true``
+unconditionally when SQ/CQ polling is active, bypassing the
+``used->flags`` check.
+
+
+Completion Path (Device → Driver)
+---------------------------------
+
+Device Side
+~~~~~~~~~~~
+
+When the device processes completions:
+
+1. The device writes completion entries to the used ring as usual
+2. The device's poll thread writes ``cq->idx`` to signal completion
+
+The device's poll thread is a dedicated kernel thread that processes
+both submissions (via ``handle_kick``) and completions (via
+``poll_complete`` callback) in a single-threaded loop.
+
+Driver Side
+~~~~~~~~~~~
+
+The driver's poll thread (one per device) detects completions by
+checking ``more_used()`` — directly comparing ``used->idx`` with
+``last_used_idx``:
+
+.. code-block:: pseudo
+
+    while more_used(vq):
+        consume_and_callback(vq)
+        do_softirq()
+
+Note: The driver polls ``used->idx`` directly rather than ``cq->idx``,
+because ``cq->idx`` may lag behind ``used->idx`` (the device writes
+the used ring entries before updating ``cq->idx``). Polling
+``used->idx`` ensures the lowest-latency completion detection.
+
+``cq->idx`` is retained for the ``cq_need_wakeup`` sleep/wake
+protocol (see below) but is not polled as a fast-path completion
+detector.
+
+
+NEED_WAKEUP Protocol
+--------------------
+
+The NEED_WAKEUP protocol prevents lost wakeups when either side
+transitions from polling to sleeping. It is symmetric: SQ uses
+``sq_need_wakeup`` and CQ uses ``cq_need_wakeup``.
+
+SQ NEED_WAKEUP (Device sleeping)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Before the device's poll thread sleeps:
+
+1. Set ``sq_need_wakeup = 1`` (via ``put_user``)
+2. Execute ``smp_mb()``
+3. Re-read ``sq->idx`` — if it changed, cancel sleep
+
+After waking (via eventfd or timeout):
+- Clear ``sq_need_wakeup = 0``
+
+The driver checks ``sq_need_wakeup`` after writing ``sq->idx`` and
+performs an MMIO kick only if the flag is set.
+
+CQ NEED_WAKEUP (Driver sleeping)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Before the driver's poll thread sleeps:
+
+1. Set ``cq_need_wakeup = 1`` (via ``smp_store_release``)
+2. Execute ``smp_mb()``
+3. Re-check ``more_used()`` — if work found, cancel sleep
+
+After waking (via eventfd/interrupt or timeout):
+- Clear ``cq_need_wakeup = 0``
+
+The device checks ``cq_need_wakeup`` after writing ``cq->idx`` and
+sends an eventfd signal only if the flag is set.
+
+
+Memory Ordering
+---------------
+
+The following memory ordering rules MUST be observed:
+
+====================  ============================  ============================
+Field                 Writer                       Reader
+====================  ============================  ============================
+``sq->idx``           ``smp_store_release``         ``get_user`` + ``smp_rmb``
+``sq_need_wakeup``    ``put_user`` + ``smp_wmb``    ``smp_load_acquire``
+``cq->idx``           ``put_user`` (with ``smp_wmb``) Not polled (see note)
+``cq_need_wakeup``    ``smp_store_release``         ``get_user`` + ``smp_rmb``
+``used->idx``         Device (via ``vhost_add_used``) ``more_used()`` (plain read)
+====================  ============================  ============================
+
+Note: ``cq->idx`` is written by the device but is not polled by the
+driver's fast path. The driver uses ``more_used()`` (checking
+``used->idx``) for completion detection, which is the authoritative
+source of completions.
+
+On x86 (TSO memory model), all barriers are no-ops. On ARM64 and
+RISC-V, ``smp_store_release`` generates ``stlr`` and
+``smp_load_acquire`` generates ``ldar``, which are lighter than full
+memory barriers (``dmb ish``).
+
+
+Poll Thread Behavior
+--------------------
+
+Device Poll Thread (vhost)
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+One kernel thread per virtqueue. Each thread:
+
+1. Polls ``sq->idx`` for new submissions and ``completion_pending``
+   for completions
+2. When active: busy-spins using ``need_resched()`` + ``cpu_relax()``
+   for cooperative yielding (io_uring SQPOLL pattern)
+3. Spin budget: fixed 1ms (``SQCQ_ACTIVE_TIMEOUT_NS``) for no-inflight,
+   or ``2 × ema_latency`` for has-inflight
+4. After spin budget expires: sets ``sq_need_wakeup``, sleeps via
+   ``wait_event_interruptible_timeout``
+5. Sleep timeout: adaptive, based on EMA latency, clamped to [10us, 1ms]
+
+CPU affinity: round-robin across online CPUs
+(``atomic_counter % num_online_cpus()``).
+
+Driver Poll Thread
+~~~~~~~~~~~~~~~~~~
+
+One kernel thread per device (serves all registered virtqueues). The
+thread:
+
+1. Iterates all registered virtqueues, polls ``more_used()`` for each
+2. When active: busy-spins within a time budget (``busy_spin_us = 1ms``)
+   from ``last_io_ts``, using ``need_resched()`` + ``cpu_relax()``
+3. After spin budget expires: sets ``cq_need_wakeup`` on all VQs,
+   double-checks ``more_used()``, sleeps via ``schedule_timeout``
+4. Sleep timeout: fixed 1ms (``idle_timeout_us = 1000``)
+5. ``do_softirq()`` called after each completion callback (no hardware
+   interrupts means softirqs must be explicitly flushed)
+
+Parameters (configurable at thread creation):
+
+- ``idle_timeout_us``: sleep timeout in microseconds (default: 1000)
+- ``busy_spin_us``: spin budget in microseconds (default: 1000)
+
+
+Feature Negotiation
+-------------------
+
+1. The device offers ``VIRTIO_F_SQCQ_POLL`` in its feature bits
+2. The driver accepts the feature during ``finalize_features``
+3. The driver allocates SQ/CQ doorbells in ``find_vqs``
+4. The driver writes SQ/CQ DMA addresses to PCI config space
+5. The device (vhost) receives addresses and starts poll threads
+6. ``virtio_features_ok()`` MUST reject
+   ``VIRTIO_F_SQCQ_POLL | VIRTIO_F_RING_PACKED``
+
+If either side does not support the feature, traditional MMIO kick +
+MSI-X interrupt mode is used with zero overhead.
+
+
+Mutual Exclusion
+----------------
+
+``VIRTIO_F_SQCQ_POLL`` and ``VIRTIO_F_RING_PACKED`` MUST NOT be
+negotiated simultaneously. The driver's ``virtio_features_ok()``
+function rejects this combination.
+
+This restriction exists because the SQ/CQ doorbell implementation
+accesses split-ring-specific fields (``avail_idx_shadow``,
+``vring->used->idx``) unconditionally in ``virtqueue_notify()``.
+Packed ring support is a future enhancement.
+
+
+Relationship to Existing Mechanisms
+-----------------------------------
+
+- **EVENT_IDX** (``VIRTIO_RING_F_EVENT_IDX``): may be negotiated but
+  has no effect on polling virtqueues. Notification suppression is
+  handled by ``sq_need_wakeup`` / ``cq_need_wakeup`` instead.
+
+- **blk-mq iopoll**: complementary. iopoll handles synchronous
+  polling from the submitting task; SQ/CQ replaces the asynchronous
+  interrupt path.
+
+- **vhost-vDPA**: vDPA provides its own doorbell mmap mechanism.
+  SQ/CQ polling is specific to the vhost-scsi kernel backend and
+  does not require vDPA hardware support.
+
+
+Performance Characteristics
+---------------------------
+
+Benchmark results (fio, 4K random I/O, arm64 with 8 vCPUs):
+
+============================  ============  ===========  =========
+Test                          Baseline      SQ/CQ Poll   Change
+============================  ============  ===========  =========
+randread od1 nj1              22,427 IOPS   28,289 IOPS  +26.1%
+randread od32 nj1             89,910 IOPS   75,665 IOPS  -15.8%
+randread od32 nj4             186,763 IOPS  379,549 IOPS +103.2%
+randread od32 nj8             199,967 IOPS  550,633 IOPS +175.4%
+randwrite od1 nj1             21,912 IOPS   27,261 IOPS  +24.4%
+randwrite od32 nj1            85,349 IOPS   81,389 IOPS   -4.6%
+randwrite od32 nj4            190,443 IOPS  355,811 IOPS  +86.8%
+randwrite od32 nj8            196,552 IOPS  566,640 IOPS +188.3%
+============================  ============  ===========  =========
+
+Multi-queue workloads (nj4/nj8) see 87-188% improvement from
+eliminated VM exits on both submission and completion paths.
+Single-queue high-queue-depth workloads (od32 nj1) show a
+minor regression due to polling overhead vs. the VM exit savings.
diff --git a/build-riscv-kernel.sh b/build-riscv-kernel.sh
new file mode 100644
index 0000000000000..2ace46278369e
--- /dev/null
+++ b/build-riscv-kernel.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+
+# 设置变量
+export ARCH=riscv
+export CROSS_COMPILE=riscv64-linux-gnu-
+export KERNEL_DIR=$(pwd)
+export OUTPUT_DIR="${KERNEL_DIR}/output"
+
+# 清理
+make mrproper
+
+# 配置
+make defconfig
+# 或使用特定配置
+# cp ${CONFIG_FILE} .config
+
+# 编译内核
+echo "开始编译内核..."
+make -j$(nproc) || exit 1
+
+# 编译设备树
+echo "编译设备树..."
+make dtbs || exit 1
+
+echo "编译完成！"
+echo "内核镜像: ${KERNEL_DIR}/arch/riscv/boot/Image"
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 1c22880e72267..4d65205fcb23e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -142,6 +142,7 @@ struct vhost_scsi_cmd {
 	struct llist_node tvc_completion_list;
 	/* Used to track inflight cmd */
 	struct vhost_scsi_inflight *inflight;
+	ktime_t tvc_submit_ts;
 };
 
 struct vhost_scsi_nexus {
@@ -234,6 +235,7 @@ struct vhost_scsi_virtqueue {
 
 	struct vhost_work completion_work;
 	struct llist_head completion_list;
+	ktime_t stats_window;
 };
 
 struct vhost_scsi {
@@ -490,9 +492,18 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
 		struct vhost_scsi_virtqueue *svq =  container_of(cmd->tvc_vq,
 					struct vhost_scsi_virtqueue, vq);
 
-		llist_add(&cmd->tvc_completion_list, &svq->completion_list);
-		if (!vhost_vq_work_queue(&svq->vq, &svq->completion_work))
-			vhost_scsi_drop_cmds(svq);
+			llist_add(&cmd->tvc_completion_list, &svq->completion_list);
+			if (READ_ONCE(svq->vq.sqcq_poll)) {
+				smp_wmb();
+				atomic_set(&svq->vq.completion_pending, 1);
+				smp_mb();
+				if (!READ_ONCE(svq->vq.poll_stop) &&
+				    READ_ONCE(svq->vq.poll_task) &&
+				    !task_is_running(svq->vq.poll_task))
+					wake_up(&svq->vq.poll_wait);
+			} else if (!vhost_vq_work_queue(&svq->vq, &svq->completion_work)) {
+				vhost_scsi_drop_cmds(svq);
+			}
 	}
 }
 
@@ -678,15 +689,11 @@ static int vhost_scsi_copy_sgl_to_iov(struct vhost_scsi_cmd *cmd)
 	return 0;
 }
 
-/* Fill in status and signal that we are done processing this command
- *
- * This is scheduled in the vhost work queue so we are called with the owner
- * process mm and can access the vring.
+/* Process completion_list: copy responses, add used entries, release cmds.
+ * Returns true if any completions were signalled.
  */
-static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
+static bool vhost_scsi_process_completions(struct vhost_scsi_virtqueue *svq)
 {
-	struct vhost_scsi_virtqueue *svq = container_of(work,
-				struct vhost_scsi_virtqueue, completion_work);
 	struct virtio_scsi_cmd_resp v_rsp;
 	struct vhost_scsi_cmd *cmd, *t;
 	struct llist_node *llnode;
@@ -726,6 +733,9 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 			signal = true;
 
 			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			cmd->tvc_vq->lat_scsi_ns +=
+				ktime_to_ns(ktime_sub(ktime_get(), cmd->tvc_submit_ts));
+			cmd->tvc_vq->stat_completions++;
 		} else
 			pr_err("Faulted on virtio_scsi_cmd_resp\n");
 
@@ -737,10 +747,70 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 
 	mutex_unlock(&svq->vq.mutex);
 
+	return signal;
+}
+
+/* Worker-path completion (non-poll mode only) */
+static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(work,
+				struct vhost_scsi_virtqueue, completion_work);
+	struct vhost_virtqueue *vq = &svq->vq;
+	bool signal;
+
+	signal = vhost_scsi_process_completions(svq);
+
 	if (signal)
 		vhost_signal(&svq->vs->dev, &svq->vq);
+
+	if (vq->stat_completions > 0) {
+		u64 now = ktime_get_ns();
+
+		if (!svq->stats_window)
+			svq->stats_window = ns_to_ktime(now);
+
+		if (now - ktime_to_ns(svq->stats_window) >= 10 * NSEC_PER_SEC) {
+			int vi;
+
+			for (vi = 0; vi < svq->vs->dev.nvqs; vi++)
+				if (svq->vs->dev.vqs[vi] == vq)
+					break;
+			pr_info("vhost-baseline: vq[%d] cmd=%llu avg_lat=%lluns\n",
+			       vi, vq->stat_completions,
+			       div64_u64(vq->lat_scsi_ns, vq->stat_completions));
+			svq->stats_window = ns_to_ktime(now);
+			vq->lat_scsi_ns = 0;
+			vq->stat_completions = 0;
+		}
+	}
 }
 
+/* Poll-thread-path completion: write cq->idx and signal Guest directly */
+static void vhost_scsi_poll_complete(struct vhost_virtqueue *vq)
+{
+	struct vhost_scsi_virtqueue *svq = container_of(vq,
+				struct vhost_scsi_virtqueue, vq);
+	bool signal;
+
+	signal = vhost_scsi_process_completions(svq);
+
+	if (signal && svq->vq.cq) {
+		__virtio64 cq_idx_val;
+		__u8 cq_need_wakeup;
+
+		smp_mb();
+		cq_idx_val = (__force __virtio64)READ_ONCE(svq->vq.last_used_idx);
+		put_user(cq_idx_val, &svq->vq.cq->idx);
+		smp_mb(); /* Ensure cq->idx is visible before reading cq_need_wakeup */
+		if (!get_user(cq_need_wakeup, &svq->vq.cq->cq_need_wakeup)) {
+			smp_rmb();
+			if (cq_need_wakeup && svq->vq.call_ctx.ctx)
+				eventfd_signal(svq->vq.call_ctx.ctx);
+		}
+	}
+}
+
+
 static struct vhost_scsi_cmd *
 vhost_scsi_get_cmd(struct vhost_virtqueue *vq, u64 scsi_tag)
 {
@@ -1060,9 +1130,25 @@ static void vhost_scsi_target_queue_cmd(struct vhost_scsi_nexus *nexus,
 	}
 
 	se_cmd->tag = 0;
+	cmd->tvc_submit_ts = ktime_get();
 	target_init_cmd(se_cmd, nexus->tvn_se_sess, &cmd->tvc_sense_buf[0],
 			lun, exp_data_len, vhost_scsi_to_tcm_attr(task_attr),
-			data_dir, TARGET_SCF_ACK_KREF);
+			data_dir,
+			TARGET_SCF_ACK_KREF |
+			(READ_ONCE(cmd->tvc_vq->sqcq_poll) ?
+					TARGET_SCF_USE_CPUID : 0));
+
+	/* Poll mode: steer TCM completion to next CPU to avoid
+	 * starvation behind poll thread. Skip if fabric has
+	 * custom cmd_compl_affinity (-2=UNBOUND or specific CPU).
+	 */
+	if (READ_ONCE(cmd->tvc_vq->sqcq_poll) && num_online_cpus() > 1) {
+		struct se_wwn *wwn = se_cmd->se_sess->se_tpg->se_tpg_wwn;
+
+		if (!wwn || wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
+			se_cmd->cpuid =
+				vhost_sqcq_pick_completion_cpu(smp_processor_id());
+	}
 
 	if (target_submit_prep(se_cmd, cdb, sg_ptr,
 			       cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
@@ -1346,7 +1432,6 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		ret = vhost_scsi_chk_size(vq, &vc);
 		if (ret)
 			goto err;
-
 		ret = vhost_scsi_get_req(vq, &vc, &tpg);
 		if (ret)
 			goto err;
@@ -2070,6 +2155,15 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
+			if (i >= VHOST_SCSI_VQ_IO &&
+			    vhost_has_feature(vq, VIRTIO_F_SQCQ_POLL) &&
+			    vq->sq && vq->cq) {
+				ret = vhost_sqcq_poll_start(vq);
+				if (ret) {
+					mutex_unlock(&vq->mutex);
+					goto stop_poll_threads;
+				}
+			}
 			mutex_unlock(&vq->mutex);
 		}
 		ret = 0;
@@ -2086,6 +2180,19 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 	vs->vs_tpg = vs_tpg;
 	goto out;
 
+stop_poll_threads:
+	/* VQ at index i failed to start. Stop poll threads for all
+	 * previously started VQs (indices i-1 down to VHOST_SCSI_VQ_IO).
+	 */
+	for (i = i - 1; i >= VHOST_SCSI_VQ_IO; i--) {
+		vq = &vs->vqs[i].vq;
+		mutex_lock(&vq->mutex);
+		vhost_sqcq_poll_stop(vq);
+		vhost_vq_set_backend(vq, NULL);
+		mutex_unlock(&vq->mutex);
+	}
+	/* Reset i for full vq cmds cleanup */
+	i = vs->dev.nvqs;
 destroy_vq_cmds:
 	for (i--; i >= VHOST_SCSI_VQ_IO; i--) {
 		if (!vhost_vq_get_backend(&vs->vqs[i].vq))
@@ -2163,9 +2270,17 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	/* Prevent new cmds from starting and accessing the tpgs/sessions */
 	for (i = 0; i < vs->dev.nvqs; i++) {
 		vq = &vs->vqs[i].vq;
-		mutex_lock(&vq->mutex);
-		vhost_vq_set_backend(vq, NULL);
-		mutex_unlock(&vq->mutex);
+		if (!READ_ONCE(vq->sqcq_poll)) {
+			mutex_lock(&vq->mutex);
+			vhost_vq_set_backend(vq, NULL);
+			mutex_unlock(&vq->mutex);
+		} else {
+			mutex_lock(&vq->mutex);
+			vhost_sqcq_poll_stop(vq);
+			vhost_vq_set_backend(vq, NULL);
+			mutex_unlock(&vq->mutex);
+			vhost_sqcq_poll_flush(vq);
+		}
 	}
 	/* Make sure cmds are not running before tearing them down. */
 	vhost_scsi_flush(vs);
@@ -2221,6 +2336,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	bool is_log, was_log;
 	int i;
 
+
 	if (features & ~VHOST_SCSI_FEATURES)
 		return -EOPNOTSUPP;
 
@@ -2321,6 +2437,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 		vhost_work_init(&svq->completion_work,
 				vhost_scsi_complete_cmd_work);
 		svq->vq.handle_kick = vhost_scsi_handle_kick;
+		svq->vq.poll_complete = vhost_scsi_poll_complete;
 	}
 	vhost_dev_init(&vs->dev, vqs, nvqs, UIO_MAXIOV,
 		       VHOST_SCSI_WEIGHT, 0, true, NULL);
@@ -2415,6 +2532,45 @@ vhost_scsi_ioctl(struct file *f,
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
 		return vhost_scsi_set_features(vs, features);
+	case VHOST_GET_FEATURES_ARRAY: {
+		u64 count, copied;
+		u64 farr[VIRTIO_FEATURES_U64S] = {};
+
+		if (get_user(count, (u64 __user *)argp))
+			return -EFAULT;
+		copied = min_t(u64, count, VIRTIO_FEATURES_U64S);
+		farr[0] = VHOST_SCSI_FEATURES;
+		if (copy_to_user((u64 __user *)(argp + sizeof(u64)),
+				 farr, copied * sizeof(u64)))
+			return -EFAULT;
+		if (count > copied &&
+		    clear_user((u64 __user *)(argp + sizeof(u64) +
+					     copied * sizeof(u64)),
+			       (count - copied) * sizeof(u64)))
+			return -EFAULT;
+		return 0;
+	}
+	case VHOST_SET_FEATURES_ARRAY: {
+		u64 count, copied, all_features[VIRTIO_FEATURES_U64S] = {};
+		int i;
+
+		if (get_user(count, (u64 __user *)argp))
+			return -EFAULT;
+		copied = min_t(u64, count, VIRTIO_FEATURES_U64S);
+		if (copy_from_user(all_features,
+				   (u64 __user *)(argp + sizeof(u64)),
+				   copied * sizeof(u64)))
+			return -EFAULT;
+		for (i = copied; i < count; i++) {
+			u64 tmp;
+			if (get_user(tmp, (u64 __user *)(argp +
+					sizeof(u64) + i * sizeof(u64))))
+				return -EFAULT;
+			if (tmp)
+				return -EOPNOTSUPP;
+		}
+		return vhost_scsi_set_features(vs, all_features[0]);
+	}
 	case VHOST_NEW_WORKER:
 	case VHOST_FREE_WORKER:
 	case VHOST_ATTACH_VRING_WORKER:
@@ -2424,6 +2580,7 @@ vhost_scsi_ioctl(struct file *f,
 		mutex_unlock(&vs->dev.mutex);
 		return r;
 	default:
+
 		mutex_lock(&vs->dev.mutex);
 		r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
 		/* TODO: flush backend after dev ioctl. */
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2f2c45d208832..68fb53c40b2e6 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -42,6 +42,20 @@ static int max_iotlb_entries = 2048;
 module_param(max_iotlb_entries, int, 0444);
 MODULE_PARM_DESC(max_iotlb_entries,
 	"Maximum number of iotlb entries. (default: 2048)");
+#define SQCQ_IDLE_TIMEOUT_US_MAX	1000U
+#define SQCQ_SLEEP_EMA_MULT		2
+#define SQCQ_SPIN_EMA_MULT		2
+#define SQCQ_ACTIVE_TIMEOUT_NS		1000000U	/* cap active-VQ clear at 1 ms */
+#define SQCQ_STALE_TIMEOUT_NS		1000000000ULL	/* backstop EMA/active clear at 1 s */
+
+static atomic_t sqcq_poll_cpu_rr = ATOMIC_INIT(-1);
+static atomic_t sqcq_active_io_vqs = ATOMIC_INIT(0);
+/* CPUs with a BUSY poll thread (actively processing cmds); TCM completion
+ * steers away.  Idle (sleeping) poll threads don't occupy their CPU, so
+ * their bit is cleared via the sq_was_active transitions in the poll loop.
+ */
+static cpumask_t sqcq_poll_active_cpu_mask;
+
 static bool fork_from_owner_default = VHOST_FORK_OWNER_TASK;
 
 #ifdef CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL
@@ -390,6 +404,20 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vhost_disable_cross_endian(vq);
 	vhost_reset_is_le(vq);
 	vq->busyloop_timeout = 0;
+	WRITE_ONCE(vq->sqcq_poll, false);
+	vq->sq = NULL;
+	vq->cq = NULL;
+	vq->poll_task = NULL;
+	WRITE_ONCE(vq->poll_stop, false);
+	init_waitqueue_head(&vq->poll_wait);
+	init_completion(&vq->poll_started);
+	init_completion(&vq->poll_stopped);
+	WRITE_ONCE(vq->kick_received, false);
+	atomic_set(&vq->completion_pending, 0);
+	vq->kick_wqh = NULL;
+	vq->stat_completions = 0;
+	vq->lat_scsi_ns = 0;
+	vq->poll_cpu = -1;
 	vq->umem = NULL;
 	vq->iotlb = NULL;
 	rcu_assign_pointer(vq->worker, NULL);
@@ -1168,6 +1196,15 @@ void vhost_dev_stop(struct vhost_dev *dev)
 {
 	int i;
 
+	for (i = 0; i < dev->nvqs; ++i) {
+		if (!READ_ONCE(dev->vqs[i]->sqcq_poll))
+			continue;
+		mutex_lock(&dev->vqs[i]->mutex);
+		vhost_sqcq_poll_stop(dev->vqs[i]);
+		mutex_unlock(&dev->vqs[i]->mutex);
+		vhost_sqcq_poll_flush(dev->vqs[i]);
+	}
+
 	for (i = 0; i < dev->nvqs; ++i) {
 		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick)
 			vhost_poll_stop(&dev->vqs[i]->poll);
@@ -2051,6 +2088,535 @@ static long vhost_vring_set_num(struct vhost_dev *d,
 	return 0;
 }
 
+static int vhost_sqcq_kick_wakeup(wait_queue_entry_t *wait, unsigned int mode,
+				   int sync, void *key)
+{
+	struct vhost_virtqueue *vq = container_of(wait,
+		struct vhost_virtqueue, kick_wait);
+
+	if (!(key_to_poll(key) & EPOLLIN))
+		return 0;
+
+	WRITE_ONCE(vq->kick_received, true);
+	wake_up(&vq->poll_wait);
+	return 0;
+}
+
+static void vhost_sqcq_kick_ptable_func(struct file *file,
+					 wait_queue_head_t *wqh,
+					 poll_table *pt)
+{
+	struct vhost_virtqueue *vq = container_of(pt,
+		struct vhost_virtqueue, kick_pt);
+
+	vq->kick_wqh = wqh;
+	add_wait_queue(wqh, &vq->kick_wait);
+}
+
+static void vhost_sqcq_kick_register(struct vhost_virtqueue *vq)
+{
+	init_waitqueue_func_entry(&vq->kick_wait, vhost_sqcq_kick_wakeup);
+	vq->kick_wqh = NULL;
+
+	if (vq->kick) {
+		__poll_t mask;
+
+		init_poll_funcptr(&vq->kick_pt, vhost_sqcq_kick_ptable_func);
+		mask = vfs_poll(vq->kick, &vq->kick_pt);
+		/* eventfd counter is never consumed; verify stale EPOLLIN
+		 * against sq->idx before acting; real kicks wake via
+		 * the registered wait queue.
+		 */
+		if (mask & EPOLLIN) {
+			__virtio64 sq_val;
+
+			if (vq->sq && !get_user(sq_val, &vq->sq->idx)) {
+				smp_rmb();
+				if ((__force u16)sq_val != vq->last_avail_idx)
+					vhost_sqcq_kick_wakeup(
+						&vq->kick_wait, 0, 0,
+						poll_to_key(mask));
+			}
+		}
+	}
+}
+
+static void vhost_sqcq_kick_unregister(struct vhost_virtqueue *vq)
+{
+	if (vq->kick_wqh) {
+		remove_wait_queue(vq->kick_wqh, &vq->kick_wait);
+		vq->kick_wqh = NULL;
+	}
+	WRITE_ONCE(vq->kick_received, false);
+}
+
+static int vhost_sqcq_poll_thread(void *data)
+{
+	struct vhost_virtqueue *vq = data;
+	struct vhost_dev *dev = vq->dev;
+	u16 new_sq_idx;
+	__virtio64 sq_idx_val;
+	__u8 sq_need_wakeup_val = 0;
+	ktime_t ts2;
+	ktime_t last_io_ts = 0;
+	ktime_t stats_window = ktime_get();
+	u64 stats_cq = 0;
+	u64 stats_lat = 0;
+	u64 stats_inflight_sum = 0;
+	u64 stats_inflight_n = 0;
+	u64 stats_multi_cnt = 0;
+	u64 stats_sleep_cnt = 0;
+	u64 stats_wake_kick = 0;
+	u64 stats_wake_complete = 0;
+	u64 stats_wake_timeout = 0;
+	u64 ema_ns_val;
+	u64 spin_ns_val;
+	unsigned long _timeout_jiffies;
+	u64 _timeout_us;
+
+	kthread_use_mm(dev->mm);
+	complete(&vq->poll_started);
+
+	vq->stat_completions = 0;
+	vq->lat_scsi_ns = 0;
+	vq->ema_latency_ns = 0;
+	vq->ema_interval_ns = 0;
+	ts2 = ktime_get();
+
+	while (!READ_ONCE(vq->poll_stop)) {
+
+		stats_inflight_sum += (u16)(vq->last_avail_idx - vq->last_used_idx);
+		stats_inflight_n++;
+		stats_multi_cnt += ((atomic_read(&sqcq_active_io_vqs) > 1) ? 1 : 0);
+
+		// 10's output windows.
+		if (ktime_to_ns(ktime_sub(ktime_get(), stats_window)) >=
+			    (s64)10 * NSEC_PER_SEC) {
+			if (stats_cq > 0) {
+				int vi;
+
+				for (vi = 0; vi < dev->nvqs; vi++)
+					if (dev->vqs[vi] == vq)
+						break;
+				pr_info("vhost-sqcq: vq[%d] cq=%llu avg=%lluns ema_lat=%lluns interval=%lluns avg_inflight=%llu multi=%llu%% sleep=%llu wk_kick=%llu%% wk_cmp=%llu%% wk_to=%llu%%\n",
+				       vi, stats_cq,
+				       div64_u64(stats_lat, stats_cq),
+				       vq->ema_latency_ns,
+				       vq->ema_interval_ns,
+				       stats_inflight_n > 0 ?
+				       div64_u64(stats_inflight_sum, stats_inflight_n) : 0,
+				       div64_u64(stats_multi_cnt*100, stats_inflight_n),
+				       stats_sleep_cnt,
+				       stats_sleep_cnt > 0 ?
+				       div64_u64(stats_wake_kick*100, stats_sleep_cnt) : 0,
+				       stats_sleep_cnt > 0 ?
+				       div64_u64(stats_wake_complete*100, stats_sleep_cnt) : 0,
+				       stats_sleep_cnt > 0 ?
+				       div64_u64(stats_wake_timeout*100, stats_sleep_cnt) : 0);
+			}
+			stats_window = ktime_get();
+			stats_cq = 0;
+			stats_lat = 0;
+			stats_inflight_sum = 0;
+			stats_inflight_n = 0;
+			stats_multi_cnt = 0;
+			stats_sleep_cnt = 0;
+			stats_wake_kick = 0;
+			stats_wake_complete = 0;
+			stats_wake_timeout = 0;
+		}
+
+		/* Backstop cleanup: drop sq_was_active and reset EMAs once a VQ
+		 * has been idle (no submission) for a fixed interval.
+		 */
+		if (vq->sq_was_active && last_io_ts > 0 &&
+		    ktime_to_ns(ktime_sub(ktime_get(), last_io_ts)) >
+			    (s64)SQCQ_STALE_TIMEOUT_NS) {
+			vq->sq_was_active = false;
+			atomic_dec(&sqcq_active_io_vqs);
+			if (vq->poll_cpu >= 0)
+				cpumask_clear_cpu(vq->poll_cpu, &sqcq_poll_active_cpu_mask);
+			WRITE_ONCE(vq->ema_interval_ns, 0);
+			WRITE_ONCE(vq->ema_latency_ns, 0);
+		}
+
+		/* complete*/
+		if (atomic_read(&vq->completion_pending) && vq->poll_complete) {
+			smp_rmb();
+			atomic_set(&vq->completion_pending, 0);
+			vq->poll_complete(vq);
+			if (vq->stat_completions > 0) {
+				u64 avg = div64_u64(vq->lat_scsi_ns,
+						    vq->stat_completions);
+
+				if (vq->ema_latency_ns == 0)
+					vq->ema_latency_ns = avg;
+				else
+					vq->ema_latency_ns =
+						vq->ema_latency_ns -
+						vq->ema_latency_ns / 8 +
+						avg / 8;
+				stats_cq += vq->stat_completions;
+				stats_lat += vq->lat_scsi_ns;
+				vq->lat_scsi_ns = 0;
+				vq->stat_completions = 0;
+			}
+		}
+
+		if (get_user(sq_idx_val, &vq->sq->idx)) {
+			int fault_retries = 3;
+
+			while (fault_retries-- > 0) {
+				if (!get_user(sq_idx_val, &vq->sq->idx))
+					break;
+				schedule_timeout_idle(1);
+			}
+			if (fault_retries < 0)
+				schedule_timeout_idle(HZ / 100);
+			continue;
+		}
+		/* Acquire: see all prior Guest writes (descriptors). */
+		smp_rmb();
+		new_sq_idx = (__force u16)sq_idx_val;
+
+		if (new_sq_idx != vq->last_avail_idx) {
+			vq->handle_kick(&vq->poll.work);
+			ts2 = ktime_get();
+			if (last_io_ts > 0) {
+				u64 _interval = ktime_to_ns(ktime_sub(ts2, last_io_ts));
+				if (vq->ema_interval_ns == 0)
+					vq->ema_interval_ns = _interval;
+				else
+					vq->ema_interval_ns =
+						vq->ema_interval_ns -
+						vq->ema_interval_ns / 8 +
+						_interval / 8;
+			}
+			last_io_ts = ts2;
+			if (!vq->sq_was_active) {
+				vq->sq_was_active = true;
+				atomic_inc(&sqcq_active_io_vqs);
+				if (vq->poll_cpu >= 0)
+					cpumask_set_cpu(vq->poll_cpu, &sqcq_poll_active_cpu_mask);
+			}
+			sq_need_wakeup_val = 0;
+			smp_mb();
+			put_user(sq_need_wakeup_val, &vq->sq->sq_need_wakeup);
+		}
+
+
+		if (vq->last_avail_idx == vq->last_used_idx) {
+			/* Spin for a fixed window to catch next submission via
+			 * sq->idx polling; need_resched+cond_resched prevents
+			 * starving other tasks on this CPU.
+			 */
+			spin_ns_val = SQCQ_ACTIVE_TIMEOUT_NS;
+			if (last_io_ts > 0 && ktime_to_ns(ktime_sub(
+			    ktime_get(), last_io_ts)) < spin_ns_val) {
+				if (need_resched())
+					cond_resched();
+				cpu_relax();
+				continue;
+			}
+		/* Clear sq_was_active to keep active_io_vqs and
+		 * cpu mask fresh. Has-inflight path keeps the
+		 * flag for TCM completion steering.
+		 */
+			if (vq->sq_was_active) {
+				vq->sq_was_active = false;
+				atomic_dec(&sqcq_active_io_vqs);
+				if (vq->poll_cpu >= 0)
+					cpumask_clear_cpu(vq->poll_cpu, &sqcq_poll_active_cpu_mask);
+			}
+		} else {
+		/* Spin within SQCQ_SPIN_EMA_MULT * ema_latency (with
+		 * cooperative yield), then sleep.  cond_resched handles
+		 * multi-VQ fairness without a separate yield heuristic.
+		 */
+			ema_ns_val = READ_ONCE(vq->ema_latency_ns);
+			spin_ns_val = ema_ns_val > 0 ?
+				(u64)SQCQ_SPIN_EMA_MULT * ema_ns_val :
+				2 * NSEC_PER_USEC;  /* fallback when EMA unknown */
+
+			if (ktime_to_ns(ktime_sub(
+			    ktime_get(), last_io_ts)) < spin_ns_val) {
+				if (need_resched())
+					cond_resched();
+				cpu_relax();
+				continue;
+			}
+		}
+
+		ema_ns_val = READ_ONCE(vq->ema_latency_ns);
+
+		if (ema_ns_val == 0) {
+			_timeout_jiffies = usecs_to_jiffies(
+				SQCQ_IDLE_TIMEOUT_US_MAX);
+		} else {
+			_timeout_us = div64_u64(
+				ema_ns_val,
+				(u64)NSEC_PER_USEC / SQCQ_SLEEP_EMA_MULT);
+
+			_timeout_us = clamp(_timeout_us,
+				10ULL,
+				(u64)SQCQ_IDLE_TIMEOUT_US_MAX);
+			_timeout_jiffies = usecs_to_jiffies(
+				_timeout_us);
+			if (_timeout_jiffies == 0)
+				_timeout_jiffies = 1;
+		}
+
+		/* Set NEED_WAKEUP, then double-check sq->idx before sleeping. */
+		smp_wmb();
+		sq_need_wakeup_val = 1;
+		put_user(sq_need_wakeup_val,
+			&vq->sq->sq_need_wakeup);
+		smp_mb();
+
+		if (get_user(sq_idx_val, &vq->sq->idx)) {
+			int fault_retries = 3;
+
+			while (fault_retries-- > 0) {
+				if (!get_user(sq_idx_val, &vq->sq->idx))
+					break;
+				schedule_timeout_idle(1);
+			}
+			if (fault_retries < 0)
+				schedule_timeout_idle(HZ / 100);
+			continue;
+		}
+		smp_rmb();
+		new_sq_idx = (__force u16)sq_idx_val;
+
+		if (new_sq_idx != vq->last_avail_idx) {
+			sq_need_wakeup_val = 0;
+			smp_mb();
+			put_user(sq_need_wakeup_val,
+				&vq->sq->sq_need_wakeup);
+			continue;
+		}
+
+		++stats_sleep_cnt;
+		vhost_sqcq_kick_register(vq);
+		wait_event_interruptible_timeout(
+			vq->poll_wait,
+			READ_ONCE(vq->poll_stop) ||
+			READ_ONCE(vq->kick_received) ||
+			atomic_read(&vq->completion_pending),
+			_timeout_jiffies);
+		/* Wake reason stats: snapshot before unregister clears kick_received */
+		{
+			bool _kicked = READ_ONCE(vq->kick_received);
+			bool _completed = atomic_read(&vq->completion_pending);
+
+			if (_kicked)
+				stats_wake_kick++;
+			if (_completed)
+				stats_wake_complete++;
+			if (!_kicked && !_completed)
+				stats_wake_timeout++;
+		}
+		vhost_sqcq_kick_unregister(vq);
+
+		sq_need_wakeup_val = 0;
+		put_user(sq_need_wakeup_val,
+			&vq->sq->sq_need_wakeup);
+	}
+
+	complete(&vq->poll_stopped);
+	kthread_unuse_mm(dev->mm);
+	return 0;
+}
+
+int vhost_sqcq_poll_start(struct vhost_virtqueue *vq)
+{
+	if (!vq->sq || !vq->cq || !vq->handle_kick)
+		return -EINVAL;
+
+	vhost_poll_stop(&vq->poll);
+
+	WRITE_ONCE(vq->poll_stop, false);
+	reinit_completion(&vq->poll_started);
+	reinit_completion(&vq->poll_stopped);
+
+	int vi;
+
+	for (vi = 0; vi < vq->dev->nvqs; vi++)
+		if (vq->dev->vqs[vi] == vq)
+			break;
+	vq->poll_task = kthread_run(vhost_sqcq_poll_thread, vq,
+				    "vhost-sqcq-%d-%d",
+				    task_pid_nr(current),
+				    vi);
+	if (IS_ERR(vq->poll_task)) {
+		int ret = PTR_ERR(vq->poll_task);
+
+		vq->poll_task = NULL;
+		if (vq->kick)
+			vhost_poll_start(&vq->poll, vq->kick);
+		return ret;
+	}
+
+	wait_for_completion(&vq->poll_started);
+
+	/* Enable sqcq mode only after poll_task is valid and the
+	 * thread has signaled readiness.  Before this point,
+	 * vhost_signal() routes completions via eventfd (old path).
+	 */
+	smp_mb();
+	WRITE_ONCE(vq->sqcq_poll, true);
+
+	if (vq->poll_task) {
+		int cpu;
+		int start = atomic_inc_return(&sqcq_poll_cpu_rr);
+		int target_cpu = -1;
+		int online = num_online_cpus();
+
+		if (online > 0)
+			start = start % online;
+		else
+			start = 0;
+
+		for_each_online_cpu(cpu) {
+			if (start-- <= 0) {
+				target_cpu = cpu;
+				break;
+			}
+		}
+		if (target_cpu < 0) {
+			for_each_online_cpu(cpu) {
+				target_cpu = cpu;
+				break;
+			}
+		}
+
+		if (target_cpu >= 0 && target_cpu < nr_cpu_ids &&
+		    cpu_online(target_cpu)) {
+			int vi;
+
+			set_cpus_allowed_ptr(vq->poll_task, cpumask_of(target_cpu));
+			for (vi = 0; vi < vq->dev->nvqs; vi++)
+				if (vq->dev->vqs[vi] == vq)
+					break;
+			pr_info("vhost-sqcq: vq[%d] poll thread bound to cpu%d\n",
+				vi, target_cpu);
+			vq->poll_cpu = target_cpu;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vhost_sqcq_poll_start);
+
+void vhost_sqcq_poll_stop(struct vhost_virtqueue *vq)
+{
+	if (!vq->poll_task)
+		return;
+
+	WRITE_ONCE(vq->poll_stop, true);
+	smp_mb();
+	wake_up_process(vq->poll_task);
+	wake_up(&vq->poll_wait);
+	wait_for_completion(&vq->poll_stopped);
+	vq->poll_task = NULL;
+	WRITE_ONCE(vq->sqcq_poll, false);
+	if (vq->poll_cpu >= 0) {
+		cpumask_clear_cpu(vq->poll_cpu, &sqcq_poll_active_cpu_mask);
+		vq->poll_cpu = -1;
+	}
+	smp_mb();
+
+	if (vq->kick)
+		vhost_poll_start(&vq->poll, vq->kick);
+	vq->sq = NULL;
+	vq->cq = NULL;
+}
+EXPORT_SYMBOL_GPL(vhost_sqcq_poll_stop);
+
+/* Flush residual completions after stop.  Must be called outside vq->mutex. */
+void vhost_sqcq_poll_flush(struct vhost_virtqueue *vq)
+{
+	if (WARN_ON_ONCE(!vq->poll_complete))
+		return;
+
+	atomic_set(&vq->completion_pending, 0);
+	vq->poll_complete(vq);
+}
+EXPORT_SYMBOL_GPL(vhost_sqcq_poll_flush);
+
+/* Pick a CPU for TCM completion: prefer a free CPU (no poll thread),
+ * searching from hint_cpu+1 with wrap. Fallback to next-online
+ * if every CPU has a poll thread.
+ */
+int vhost_sqcq_pick_completion_cpu(int hint_cpu)
+{
+	int first, cpu, target = -1;
+
+	first = cpumask_next(hint_cpu, cpu_online_mask);
+	if (first >= nr_cpu_ids)
+		first = cpumask_first(cpu_online_mask);
+
+	cpu = first;
+	do {
+		if (!cpumask_test_cpu(cpu, &sqcq_poll_active_cpu_mask)) {
+			target = cpu;
+			break;
+		}
+		cpu = cpumask_next(cpu, cpu_online_mask);
+		if (cpu >= nr_cpu_ids)
+			cpu = cpumask_first(cpu_online_mask);
+	} while (cpu != first);
+
+	if (target < 0)
+		target = first;
+
+	return target;
+}
+EXPORT_SYMBOL_GPL(vhost_sqcq_pick_completion_cpu);
+
+static long vhost_vring_set_sqcq_addr(struct vhost_dev *d,
+				       struct vhost_virtqueue *vq,
+				       void __user *argp)
+{
+	struct vhost_vring_sqcq_addr a;
+
+	if (copy_from_user(&a, argp, sizeof(a)))
+		return -EFAULT;
+
+	if ((u64)(unsigned long)a.sq_user_addr != a.sq_user_addr ||
+	    (u64)(unsigned long)a.cq_user_addr != a.cq_user_addr)
+		return -EFAULT;
+
+	if (a.sq_user_addr & 7 || a.cq_user_addr & 7)
+		return -EINVAL;
+
+	if (vq->private_data) {
+		if (!access_ok((void __user *)(unsigned long)a.sq_user_addr,
+			       sizeof(struct vring_sq)) ||
+		    !access_ok((void __user *)(unsigned long)a.cq_user_addr,
+			       sizeof(struct vring_cq)))
+			return -EINVAL;
+	}
+
+	vq->sq = (struct vring_sq __user *)(unsigned long)a.sq_user_addr;
+	vq->cq = (struct vring_cq __user *)(unsigned long)a.cq_user_addr;
+
+	/* SET_ENDPOINT may run before SET_FEATURES/SQCQ_ADDR, so poll-start
+	 * can fail there; this is the canonical trigger. Skip VQs without
+	 * poll_complete (ctrl/event VQs) — they stay interrupt-driven.
+	 */
+	if (vq->private_data && vq->sq && vq->cq &&
+	    !READ_ONCE(vq->sqcq_poll) &&
+	    vq->poll_complete &&
+	    vhost_has_feature(vq, VIRTIO_F_SQCQ_POLL)) {
+		long ret = vhost_sqcq_poll_start(vq);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static long vhost_vring_set_addr(struct vhost_dev *d,
 				 struct vhost_virtqueue *vq,
 				 void __user *argp)
@@ -2244,6 +2810,9 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 		if (copy_to_user(argp, &s, sizeof(s)))
 			r = -EFAULT;
 		break;
+	case VHOST_SET_VRING_SQCQ_ADDR:
+		r = vhost_vring_set_sqcq_addr(d, vq, argp);
+		break;
 	default:
 		r = -ENOIOCTLCMD;
 	}
@@ -2256,7 +2825,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	if (filep)
 		fput(filep);
 
-	if (pollstart && vq->handle_kick)
+	if (pollstart && vq->handle_kick && !READ_ONCE(vq->sqcq_poll))
 		r = vhost_poll_start(&vq->poll, vq->kick);
 
 	mutex_unlock(&vq->mutex);
@@ -2938,8 +3507,12 @@ int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
 		*ndesc = c;
 
 	/* Assume notifications from guest are disabled at this point,
-	 * if they aren't we would need to update avail_event index. */
-	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
+	 * if they aren't we would need to update avail_event index.
+	 * In SQCQ poll mode, vhost_disable_notify is a no-op so
+	 * VRING_USED_F_NO_NOTIFY is never set; skip the check.
+	 */
+	WARN_ON_ONCE(!vq->sqcq_poll &&
+		     !(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 	return head;
 }
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
@@ -3167,6 +3740,16 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 /* This actually signals the guest, using eventfd. */
 void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
+	if (READ_ONCE(vq->sqcq_poll) && vq->cq) {
+		atomic_set(&vq->completion_pending, 1);
+		if (!READ_ONCE(vq->poll_stop)) {
+			smp_mb();
+			if (!task_is_running(vq->poll_task))
+				wake_up(&vq->poll_wait);
+		}
+		return;
+	}
+
 	/* Signal the Guest tell them we used something up. */
 	if (vq->call_ctx.ctx && vhost_notify(dev, vq))
 		eventfd_signal(vq->call_ctx.ctx);
@@ -3213,6 +3796,9 @@ EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 /* OK, now we need to know about added descriptors. */
 bool vhost_enable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
+	if (READ_ONCE(vq->sqcq_poll))
+		return false;
+
 	int r;
 
 	if (!(vq->used_flags & VRING_USED_F_NO_NOTIFY))
@@ -3249,6 +3835,9 @@ EXPORT_SYMBOL_GPL(vhost_enable_notify);
 /* We don't need to be notified again. */
 void vhost_disable_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
+	if (READ_ONCE(vq->sqcq_poll))
+		return;
+
 	int r;
 
 	if (vq->used_flags & VRING_USED_F_NO_NOTIFY)
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 4fe99765c5c73..b9c15961f5a18 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -111,6 +111,7 @@ struct vhost_virtqueue {
 
 	/* The routine to call when the Guest pings us, or timeout. */
 	vhost_work_fn_t handle_kick;
+	void (*poll_complete)(struct vhost_virtqueue *vq);
 
 	/* Last available index we saw.
 	 * Values are limited to 0x7fff, and the high bit is used as
@@ -164,6 +165,27 @@ struct vhost_virtqueue {
 	bool user_be;
 #endif
 	u32 busyloop_timeout;
+
+	/* SQ/CQ polling mode */
+	bool sqcq_poll;
+	struct vring_sq __user *sq;
+	struct vring_cq __user *cq;
+	struct task_struct *poll_task;
+	bool poll_stop;
+	wait_queue_head_t poll_wait;
+	struct completion poll_started;
+	struct completion poll_stopped;
+	bool kick_received;		/* Set when kick eventfd wakes us */
+	atomic_t completion_pending;	/* Set by vhost_signal, poll thread atomically clears */
+	wait_queue_head_t *kick_wqh;	/* kick eventfd wait queue head */
+	wait_queue_entry_t kick_wait;	/* Wait entry on kick eventfd wq */
+	poll_table kick_pt;		/* poll_table for kick eventfd */
+	u64		stat_completions;
+	u64		lat_scsi_ns;
+	u64		ema_interval_ns;
+	u64		ema_latency_ns;
+	bool		sq_was_active;
+	int		poll_cpu;	/* CPU this VQ's poll thread is pinned to, -1 = unpinned */
 };
 
 struct vhost_msg_node {
@@ -256,6 +278,10 @@ void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
 void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 bool vhost_vq_avail_empty(struct vhost_dev *, struct vhost_virtqueue *);
+int vhost_sqcq_poll_start(struct vhost_virtqueue *vq);
+void vhost_sqcq_poll_stop(struct vhost_virtqueue *vq);
+void vhost_sqcq_poll_flush(struct vhost_virtqueue *vq);
+int vhost_sqcq_pick_completion_cpu(int hint_cpu);
 bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 
 int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
@@ -294,7 +320,8 @@ void vhost_iotlb_map_free(struct vhost_iotlb *iotlb,
 	VIRTIO_RING_F_EVENT_IDX, \
 	VHOST_F_LOG_ALL, \
 	VIRTIO_F_ANY_LAYOUT, \
-	VIRTIO_F_VERSION_1
+	VIRTIO_F_VERSION_1, \
+	VIRTIO_F_SQCQ_POLL
 
 static inline u64 vhost_features_u64(const int *features, int size, int idx)
 {
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index c57674a6aa0db..dacb0e1fdc4bc 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -123,6 +123,10 @@
 #define VHOST_SET_BACKEND_FEATURES _IOW(VHOST_VIRTIO, 0x25, __u64)
 #define VHOST_GET_BACKEND_FEATURES _IOR(VHOST_VIRTIO, 0x26, __u64)
 
+/* Set SQ/CQ doorbell addresses for polling mode */
+#define VHOST_SET_VRING_SQCQ_ADDR _IOW(VHOST_VIRTIO, 0x27, \
+					struct vhost_vring_sqcq_addr)
+
 /* VHOST_NET specific defines */
 
 /* Attach virtio net ring to a raw socket, or tap device.
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 1c39cc5f5a31b..6514c1b5be20b 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -47,6 +47,12 @@ struct vhost_vring_addr {
 	__u64 log_guest_addr;
 };
 
+struct vhost_vring_sqcq_addr {
+	unsigned int index;
+	__u64 sq_user_addr;	/* SQ doorbell HVA */
+	__u64 cq_user_addr;	/* CQ doorbell HVA */
+};
+
 struct vhost_worker_state {
 	/*
 	 * For VHOST_NEW_WORKER the kernel will return the new vhost_worker id.
-- 
2.34.1

