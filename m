Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631862FE592
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 02:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768618301; cv=none; b=QOSbnmnzKXlyI9DGmMhzTYmKIETJ7azqOg8YW1kuiJkEjh+VX3D5XLjisA1J6uDZp54OSu4/Rhdg0sMjN86shg8FEVM2hc9zbtoVRnjRXJTC84hsNQhkHqMf90HOEBUKjo75JsRNWEp+tDkQSoOpjwI/xZz7/gD1OYprizGZIys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768618301; c=relaxed/simple;
	bh=JR2lB6SpwQyYKrn3A+sb/GAiufPu5j/SZUDtKHTacRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oy6kJcqcGY8nuDN+U4d3vjJHd5pjKBDhT6HwiGUMyAMnbRAftJD1lvMHPpDlCJh5doSk3gpz88vRP0YSSNuri1R7SdHW0vcdpco+1iVwbGDa9PcHir8DqB82lczsvM6x28Nf0eRGRgq5S/wg9lBvWKFlGhk6hCYqnMPTtp44Wcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iei1Y9D1; arc=none smtp.client-ip=209.85.222.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iei1Y9D1"
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-8c59bce68a1so179175285a.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 18:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768618299; x=1769223099; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=g52RCNxKP5yWPLz6Ydp2XilgQT0ikaZD3cfRfzbViX4=;
        b=Iei1Y9D1hiBbSXQkhJ7pRvzkEU10RXKvJeHPQOp9PPInZ8tvYcE1TdRNaEHwuk6oN8
         t21rWkSnnNL6I4utjSmlyRM3IisRWFxXHu6yy0OO6rPMLquEgR0Ptv0bK4i6T+gYWdVx
         LE6d59KAKMpg6P7kXwdzFdoqbMDfWnAGHDIWazEjLatBLkpug4QYmEgVb4Cih1F/XKD5
         j1TMyQp7i6SO/GUqA+2mCtWpJG2rB+eVOqX1v5cehsD/cbjerRJ0qyZrmgV7VKvdSUAE
         7Z4nTLQsn5PkFz47fnymQ7qmXZGWyDC8dGSboAN+i1UpENeP5CXTrydvs4KopOR/RKif
         BPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768618299; x=1769223099;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g52RCNxKP5yWPLz6Ydp2XilgQT0ikaZD3cfRfzbViX4=;
        b=lt/CFKO6+ia7t3UqUGP1OcTlz4EQXAxYBnq/YoViFJsBmIP8ljwsZTDHciia3/Af27
         QXSgSUPdPpBBNOn3zSo5wWemX7Qmzd5URWIdoyznpRSQkIjSked3+jXChsI7ulbFOJgp
         i6w+XsFvEpTYY9RmzisI4WxmMzGdqdY2ScadscJoGHCJkjeoaJ1Dr3p3/rZoB2KfJZX/
         DQA9aNMmNIDBuJX705d2AHxxLUxDf3nS86aDIHtdw6oT3t6GsYPcFJIHgwhsG0RlnN0Q
         oYWsMTjR3EXHicLD1XyfP4wdAbeplaDPP92brs9YxNnoEjpFgy6vh8AlTIDMI3I3UM0E
         /jcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkbmHr/n7H4Emdi2aRYjsflkn5gS+gi3eBEDWjg7PkfN7mFAJc5SURCpCSiTa46hO/8gmPqGn5dcYZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc/pWvs8IBdGpZ6Ir5aW6Dl1cCTHkc3uzR9R1txjdMkZN4mukv
	+9RCKQKnUrRy17c4++qok8cjE8NO0sdARuVyXlbjUETIo+tcAPOIO1loaAUMb2sHZ7g=
X-Gm-Gg: AY/fxX5BrELrMEBv8osRD1WhHje9e+RzFx/BFov7XS82WhyDbQPxcqzuPwyBa8Yvvpw
	1/ZsWkeedbvdq8WrMKEvu/vH8xa5khEtbB2Qkqmfd5ZyP4WZhmU4WDwC6ZaQd/znFC6FEIWSjPl
	xapYGuFGOaFPgKNgwqjd62+9b4Kjf2RyA5C9vYL/D0AXi2WNbB7G4I2+0puRGS6OtpoHg5PA0vt
	stVgm+/EJ4RmBsnCQkYEYUlcjO+uXqm4l7K8ebwVZQWq4y5GXk+ErnkcXU37jGWVb1Hwfv6Or2o
	IBA7dObICn+SInxS7L3pDF+rTICBS2ITKnkMmyI3aNWqlQ2wzNgZ0Qk0lnzisL8stb19dJ6FfRC
	GBNzde+dqc7IvVm77kiMtnHrT0B4zIoq1/n9LQ4Y0yZsRUsILWOphpTjir+ApDEOqDE03eGQaIq
	q+4qt5mtv5bDayYl2SfuR3
X-Received: by 2002:a05:620a:254a:b0:8c3:6f44:46c0 with SMTP id af79cd13be357-8c6a66edbd8mr718053085a.16.1768618299277;
        Fri, 16 Jan 2026 18:51:39 -0800 (PST)
Received: from biancapradeep.lan ([2605:a601:a619:8500::8])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e603a8bsm37163326d6.17.2026.01.16.18.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:51:38 -0800 (PST)
From: Hithashree Bojanala <bojanalahithashri@gmail.com>
To: linux-block@vger.kernel.org
Cc: bojanala hithashri <bojanalahithashri@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BREGRESSION=5D=20fio=204k=20randread=3A=20=7E1=E2=80=933=2E5=25=20IOPS=20regression=20on=20linux-next=20=286=2E19=2E0-rc1-next-20251219=29=20vs=20RHEL9=205=2E14=20on=20PERC=20H740P?=
Date: Fri, 16 Jan 2026 21:44:07 -0500
Message-ID: <20260117024413.484508-2-bojanalahithashri@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: bojanala hithashri <bojanalahithashri@gmail.com> 


Hello,

I am reporting a small but consistent block I/O performance regression
observed when running 4k random reads across queue depths on a hardware
RAID device.

The regression appears when comparing a RHEL9 downstream kernel against
a linux-next snapshot.

System / Hardware
-----------------
CPU:   
      Model: Intel Xeon Gold 6130 @ 2.10GHz
      Architecture: x86_64
      Sockets: 2
      Cores per socket: 16
      Threads per core: 2
      NUMA nodes: 2
Memory: 
      Total: 187 GB
      NUMA nodes: 2
      Node 0: ~94 GB
      Node 1: ~97 GB
      Swap: 4 GB (unused during test)

Storage controller:
  Dell PERC H740P (hardware RAID)

Block device:
  /dev/sdh

lsblk output:
  NAME MODEL           SIZE ROTA TRAN SCHED
  sdh  PERC H740P Adp  1.6T    1      mq-deadline

Active scheduler:
  /sys/block/sdh/queue/scheduler
    none [mq-deadline] kyber bfq

Kernels Tested
--------------
Baseline (downstream):
  5.14.0-427.13.1.el9_4.x86_64

Test (upstream integration tree):
  6.19.0-rc1-next-20251219

Workload / Reproducer
---------------------
fio version: 3.35
Raw block device, direct I/O, libaio, single job, long runtime (300s)

Command used:

for depth in 1 2 4 8 16 32 64 128 256 512 1024 2048; do
  fio --rw=randread \
      --bs=4096 \
      --name=randread-$depth \
      --filename=/dev/sdh \
      --ioengine=libaio \
      --numjobs=1 --thread \
      --norandommap \
      --runtime=300 \
      --direct=1 \
      --iodepth=$depth \
      --scramble_buffers=1 \
      --offset=0 \
      --size=100g
done

Observed Behavior
-----------------
Across all queue depths tested, the linux-next kernel shows:

- ~1–3.5% lower IOPS
- Corresponding bandwidth reduction
- ~1–3.6% higher average completion latency
- Slightly worse p99 / p99.9 latency

The throughput saturation point remains unchanged
(around iodepth ≈ 128), suggesting the regression is
related to service/dispatch efficiency rather than a
change in device limits.

Example Data Points
-------------------
- iodepth=32:
    old: 554 IOPS → new: 535 IOPS  (~-3.4%)
    avg clat: 57.7 ms → 59.8 ms

- iodepth=64:
    old: 608 IOPS → new: 588 IOPS  (~-3.3%)
    avg clat: 105 ms → 109 ms

- iodepth=128:
    old: 648 IOPS → new: 640 IOPS (~-1.2%)

This behavior is consistent across multiple runs.

Notes
-----
I understand this comparison spans a downstream RHEL kernel
and a linux-next snapshot. I wanted to report this early
because the regression is consistent and may relate to recent
blk-mq or mq-deadline changes affecting rotational / hardware
RAID devices.

I am happy to:
- Re-test on a specific mainline release (e.g. v6.18 or v6.19-rc)
- Compare schedulers (mq-deadline vs none / bfq)
- Provide additional instrumentation (iostat, perf, bpf)
- Assist with bisection if a suspect window is identified

Please let me know how you would like me to proceed.

Thanks,
Hithashree
