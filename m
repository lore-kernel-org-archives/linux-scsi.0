Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F244931AF2D
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762189401; cv=none; b=bcRKSFn2kMLSUqCzwLVCUF+POQd2A54HT/o6pJF9HVVYeF93G8L/jS/yQFPOdeW2kECD6m7Ancb2ORzPNcpKyUuBZ2bOVkyQTYwbDux78cqmHPaZUIDHag2lmqkfFKxzIx0NIBsK5K5ar79Dn99IWmEUy/G5XzHQXIEBu+7+vjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762189401; c=relaxed/simple;
	bh=4bjsKbSySZoag6DbG6yKeL0WVlW44Hfu9n1kFvBUiuM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=TmGu0mxFn2iy9MhHVO3ekVcbotG5x85Qkw3xhumH+D0QMRd2WFR4FZtyLduXc+q6plbbQ5ccH8EfF9EBzOdk6yyFFSSDqHxCvpkXQpKno6/4O03RNXk/dUfSnffQWuC4paTMmtrP4SEVN3hvwVVKPVQaPfIZt4LIYZeYtw3XTAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GbOxx1WJ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ipylypiv.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GbOxx1WJ"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a99a5f77e0so3501655b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Nov 2025 09:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762189399; x=1762794199; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zgwz91HH8FrCQPCQZHYghyqaicLvlJMRA6PNzprcFtw=;
        b=GbOxx1WJoe+hFCHPwTEnjYXNa668HDl3p+zt1A7J9KjBxpYRYnhQ7kXb+poaYdDJHQ
         exuMPIDisP3//Nh7fy/sUQTp5rbc407oTSRqhy9qjm0LKINU2R3kGHbh0xBJcQOaSzE0
         y3Gg8ObgtPACerSxrli0n6GXw38khI6QuG74QU7ckMAQWNiTQe0macP/2TrYvOn9huIg
         oTlSmFyhBqYh01FjqCmcCFVsdiKuEHI6f6D08so6LCq2XyyHVYFTDQmB+VxDILW+9WJi
         V0uzCVDd2cFzjBETkxIYFJeHFqDHcEAMFbcmaEAmBLfs2XzDIF7Ie9hAgUF5QJuOrd9Y
         5kYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762189399; x=1762794199;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zgwz91HH8FrCQPCQZHYghyqaicLvlJMRA6PNzprcFtw=;
        b=pD3UgICJbTZ1bSWZ2T1mpqnKp1RcRjrNV9vjlbzqrjMXvb2/BVtQ7pL1CcGU0NbkrU
         HWVoesyuA2s2RK5YtszxS1F1SA+6jKhxkq8f3okKxXftMawrX4lilR1qO27hWxSu/G/J
         wAAfOPfQyJOqtZrc9kEOIffaUELhKXirliJmMQyeFaB72n6X2f0LzvPTzJM8BvQKav/S
         wP4LWcfvgUBLKbaDsJPdCz1+HgaU5JjJSCBv5I9KGRzlr/9DARMdtI7aQv2t+ctWWaKe
         lhC9CpH32jhRNNq8J5czU2NSfb4pdY2PjeQGbY8VUH2ZSIZWLhX2vYbTDKSNIE0IgESD
         nkGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvwPTnhNxoWW5IEWJsRD7mlPZg2lyctkEC0YJd6CCh+CX2bV2NDFykGkJhgTmWAM8AOjOYVNndjmsp@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl0SLMPfDfF+wdtHYkhKyH/+du3kGKIhMWT7CYEXXo7sPdzas8
	tPkz2WaM5QVRPoRPBJQ5PDGKcRmY1Pvq1SzIk6ML8W8tgoq6MrAmBFuhgE8Xc1Hyx1YP9APG04d
	R0U/y25oMIa9FwA==
X-Google-Smtp-Source: AGHT+IH41Dl7hDmGgj7d7BxzapzK5R66sc/peGO073X46xDSp88OGy7LVCzfK2/dApFQoyv/KwYxK/D2JaBrtA==
X-Received: from pjblb16.prod.google.com ([2002:a17:90b:4a50:b0:33d:6d99:1ed4])
 (user=ipylypiv job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:914b:b0:334:9f66:5273 with SMTP id adf61e73a8af0-348cc8e3793mr16329585637.47.1762189396816;
 Mon, 03 Nov 2025 09:03:16 -0800 (PST)
Date: Mon,  3 Nov 2025 09:03:04 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251103170308.3356608-1-ipylypiv@google.com>
Subject: ATA PASS-THROUGH latency regression after exposing blk-mq hardware queues
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	John Garry <john.garry@huawei.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Jens Axboe <axboe@kernel.dk>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

I'm observing significant latency regressions for ATA PASS-THROUGH
commands that started after commit 42f22fe36d51 ("scsi: pm8001:
Expose hardware queues for pm80xx"). It looks like the libata's deferral
logic that relies on returning SCSI_MLQUEUE_DEVICE_BUSY does not work
correctly for blk-mq's multiple hardware queues.

Here's what I've figured out after some tracing:

ATA PASS-THROUGH commands get continously deferred because NCQ queue is
not yet drained. At the same time, other hardware queues (other CPUs)
keep issuing more data commands effectively preventing the NCQ queue
from draining. Since NCQ queue is not getting drained, ATA PASS-THROUGH
commands can get starved for a really long time e.g. ~5 minutes.

Steps to reproduce:
1. Run FIO workload to keep the NCQ queue full.

    ~# fio --name randread_4k --rw=randread --bs=4k --iodepth=32 --filename=/dev/sdb --ioengine=libaio --direct=1

2. While FIO is running, issue ATA PASS-THROUGH commands and check latency.

    ~# time ./sg_sat_identify /dev/sdb


NOK: v6.18-rc3:

~# for i in {0..20}; do { time ./sg_sat_identify /dev/sdb; } 2>&1 | grep real; done
real	0m1.533s
real	0m1.133s
real	0m6.431s
real	0m1.466s
real	0m5.551s
real	0m6.093s
real	0m9.104s
real	0m0.254s
real	0m36.142s
real	3m16.001s
real	4m50.856s
real	0m0.409s
real	0m22.833s
real	0m3.359s
real	1m3.895s
real	0m21.314s
real	0m5.180s
real	0m10.178s
real	0m2.251s
real	0m15.205s
real	0m0.206s  

OK: v6.18-rc3 with 42f22fe36d51 reverted:

~# for i in {0..20}; do { time ./sg_sat_identify /dev/sdb; } 2>&1 | grep real; done
real	0m0.223s
real	0m0.187s
real	0m0.199s
real	0m0.226s
real	0m0.229s
real	0m0.215s
real	0m0.212s
real	0m0.211s
real	0m0.193s
real	0m0.204s
real	0m0.202s
real	0m0.224s
real	0m0.223s
real	0m0.219s
real	0m0.194s
real	0m0.209s
real	0m0.211s
real	0m0.225s
real	0m0.197s
real	0m0.204s
real	0m0.189s


Reverting 42f22fe36d51 seems like a plausible workaround but I think that
driver might still benefit from using multiple hardware queues e.g. to
issue commands to different drives from other hardware queues. It seems
like there should be a way to drain/freeze all hardware queues before
issuing ATA PASS-THROUGH commands but I haven't yet figured out how to do
that.

If you have any ideas or suggestions on how to fix this issue and/or what
things to try, please share. If you happened to have patches that would
fix the issue I would gladly review and test the patches.

Thank you!

Regards,
Igor
