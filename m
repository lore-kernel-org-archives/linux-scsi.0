Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A163732D0C4
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762530170; cv=none; b=Hk9dYpRJ5+KUJQdm0sAazQGcf0DcmXbYn36mu+xNWB+CpaByDij5/slFa3YuLZYQfx9Vy8UO4mXp3HphEvSpe5srzIdOqEEv2sWV4vJQ2BCRkwgtan8AVjYNiSxKPWJKEM65/fn4CgDeh36HN9S5AuG51BsPlWb4mgyztFvPw3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762530170; c=relaxed/simple;
	bh=FllVlbWS4MtLkyQNg1oOoXS8Gv/IymNyRvTVHqi2Ks4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jSNS1WkBpwbyg5kXNx+ajroakq7TinJuSacd9qLzZzM1x2ezwtabhJbLRmyHLrXJheIX3hMw8Aw8rEycrKCthoM3kVkA+2cUBb8bRtDVFtFoO1vLWCDthbEbe0GD8Rhpu8v8SXhqlJNF/MOx4CafACzThfi2rCH14isgeO1Qzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I0ZDTvDd; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I0ZDTvDd"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso847607f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 07 Nov 2025 07:42:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762530166; x=1763134966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EEllDksTQmdd3u8PyFwFKXQ1ssazmQ/lfWRUKOA18nI=;
        b=I0ZDTvDdZasUnpUiGcBtTCkw79yxoN3lP8jisbYQfWrYhOBDmOe/+DqiwXEnCjT/Fr
         Ywj9Goc3m1tMGbX4CVGUqlPGakpxl/HCS/j48ZgWsMLSwmytZadPTVXS5sVlUpIpF1oU
         hSLaPwvoea5DKYZ8sAo6rhB7DqsVkekaLWkDYR2wmanaG0RcsnADWO6IpBGnFpAr6kLJ
         1x1+/4Cj1OxmgOCxkPA5vJX7OlGY2xrHDWHzcKfX2RLk9yjr03eFVqF0m0ZHm+nwa3Si
         L7ovxpYUW5Lc5BnUrxWNxLr4STTrrk7YkDtVCShjcFG/XzS6aCWpyd80dvr/SeYpB9Gc
         HqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762530166; x=1763134966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEllDksTQmdd3u8PyFwFKXQ1ssazmQ/lfWRUKOA18nI=;
        b=aqF5ge6JGfGR/FcCKudpGOFZBuAB8rP3ZSi2grTR13TsJKhgy4PYdP+wl/X3sYnr64
         n2rZJCWIv5uhhLxolwFIS0TFvMJOTic6U/aCgxQiI2TI56QpMAjD3/5IJ6f8gpiN5LLK
         Xdd0cfz5N1ZzX/yShXe+nHLUwAOOWObKB5lqdKdgi1zuAv2yz7a+gdCDGTFp0XVcojlQ
         E2SFMIi+gFjAiuQo63FZ/2YqTN2aTQ9XH4yZOSQlURDJx97+r4BfTjND4C9JCW0VDz+D
         4NvhFymnFeHXE9T7QW7KdrNR/7j+P6a3Z/JkQlIS1tlhS68EwhiWxXbmDEQeHx0FE0iw
         4jNg==
X-Forwarded-Encrypted: i=1; AJvYcCXPT7uD+6euUSpZMyUWVv+ez6Gq2hZrIfKmDOh/BxqHtu38QnqvIyea60PO6mj6NAwhKecpyEWOMyPB@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4Pg+x9Qffh3nrtSXwHrn6zShOUs52PCclf7ExKEhkXkHmVc/t
	l3erDqMeqOR8E172y9EF/7TnNhp5VfvSD6Vh/jg2vcupjKo5TwLrLKAH5CsE4sDh+5E=
X-Gm-Gg: ASbGncseMM00hQbAUIa6rHOFrQ3YiWdfYYtLUe5Q8v3I5B0nJvIdt7C+Z3GQ+sNqFBt
	FI5biXVa6fYVQG6NG/B61LCbyR897ZiEsUzUSxvFNXCNz+Jzw42MNkGbyzR4Xq434zSh2tHhR6r
	nqQwYAzwlcTILRnkzZmF1sCSk4ooNbkGMPnwdJyCS2msyPtEyCVqapmjI/FGxGEgRiCBVlmmEVD
	3JG0pYrv4G3Chy24gI1FRneFECoUgxd6FV5aNJQwYjDXXqzdLULYwHg3onXwsOYWSelvQOESTpA
	QpQeRak2m6h5eEoWEEpWJ3FiG/azuY9Np0B0g5/SPgfqWQPcSEKDjrAwL5//T8ndzAn20z05GgI
	Rj2J6FFObSX9FsnpB5i2bQewsUg4g1xZ2YObB7dva1AYA3bt8LcMhNABO2G1UQX15Q8tgvJSi6C
	PdUIW9C2ta/7GdNE1q5cT5+CtspqyoGGVsC4I=
X-Google-Smtp-Source: AGHT+IFBda1EcsHmddpDO9LOEIIrlJYCTDL5Rlz+CdU/5vjVJjQIDVH1r/dzDG/W3yb8c7vMr4OskA==
X-Received: by 2002:a05:6000:1867:b0:429:d19f:d922 with SMTP id ffacd0b85a97d-42adc6895b6mr3593700f8f.11.1762530165930;
        Fri, 07 Nov 2025 07:42:45 -0800 (PST)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac67921c3sm6213783f8f.40.2025.11.07.07.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 07:42:45 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] usb: uas: add WQ_PERCPU to alloc_workqueue users
Date: Fri,  7 Nov 2025 16:42:36 +0100
Message-ID: <20251107154236.306620-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Currently if a user enqueues a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.
This lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they’re needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

This change adds a new WQ_PERCPU flag to explicitly request
alloc_workqueue() to be per-cpu when WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/usb/storage/uas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4ed0dc19afe0..0657f5f7a51f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -1265,7 +1265,7 @@ static int __init uas_init(void)
 {
 	int rv;
 
-	workqueue = alloc_workqueue("uas", WQ_MEM_RECLAIM, 0);
+	workqueue = alloc_workqueue("uas", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!workqueue)
 		return -ENOMEM;
 
-- 
2.51.1

