Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C15D40;
	Thu, 30 Nov 2023 11:31:44 -0800 (PST)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-35b2144232bso4110165ab.3;
        Thu, 30 Nov 2023 11:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701372704; x=1701977504;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mxLJlTok82d/1zMcS65wo+jr8X5sUKOoa4cY3ZrLgTM=;
        b=GvSBdYHiQGkPR3leO8FQneIGwPMk8+d6N3bwXEOk9YtbR09s+zjxJTYhgab7bJ5Bz6
         FlT/1Sxitd7KH1l093UoQGOfOCubu4zF09B3TzkP+HdH/j0DgiwrTKbY8Dgjxropp7hh
         bGI91SZP4z/zwEZgjlGBZdcRJ986DPTjOB0YzHj/owkmN16XaH81Tz+B7v3zVA+E8zVG
         lc6Ni57niboxRJ52JZAQlZrdOWHdx0UH+MYzoCkzE8CttfoSAS4KZdBe/f1D6Js+HZ4R
         nhWA8lDDVC5QdT7KqM181AQsUqPx8s98IQgC278ovwmGRWmLufqBj8xmBoh5por7SRbp
         jq4A==
X-Gm-Message-State: AOJu0YzEJuSnlRDbT6tvC6OyHRRQ3Qr7SC3/OwKvbGd/udcg5wgIyGZj
	ETeaMRf45xvpC3S5UDqp0Gk=
X-Google-Smtp-Source: AGHT+IHi0pafDk3YLVDOVMoWHPJlxf7kXDrWskKCWttJPITM/9LQOQgLGQr7MAD8igkiIMj98SUieQ==
X-Received: by 2002:a92:c566:0:b0:35c:e8ee:f7b7 with SMTP id b6-20020a92c566000000b0035ce8eef7b7mr14465458ilj.27.1701372703889;
        Thu, 30 Nov 2023 11:31:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:8572:6fe3:eaf0:3b9d])
        by smtp.gmail.com with ESMTPSA id m127-20020a632685000000b005c606b44405sm1635365pgm.67.2023.11.30.11.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:31:43 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/6] Disable fair tag sharing for UFS devices
Date: Thu, 30 Nov 2023 11:31:27 -0800
Message-ID: <20231130193139.880955-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jens,

The fair tag sharing algorithm reduces performance for UFS devices
significantly. This is because UFS devices have multiple logical units, a
limited queue depth (32 for UFS 3.1 devices), because it happens often that
multiple logical units are accessed and also because it takes time to
give tags back after activity on a request queue has stopped. This patch series
restores UFS device performance to that of the legacy block layer by disabling
fair tag sharing for UFS devices.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v5:
 - Request queues are frozen before fair tag sharing is changed.
 - Added a sysfs attribute to SCSI hosts for configuring fair tag sharing.

Changes compared to v4:
 - Rebased on top of kernel v6.7-rc1.

Changes compared to v3:
 - Instead of disabling fair tag sharing for all block drivers, introduce a
   flag for disabling it conditionally.

Changes between v2 and v3:
 - Rebased on top of the latest kernel.

Changes between v1 and v2:
 - Restored the tags->active_queues variable and thereby fixed the
   "uninitialized variable" warning reported by the kernel test robot.

Bart Van Assche (4):
  block: Make fair tag sharing configurable
  scsi: core: Make fair tag sharing configurable in the host template
  scsi: core: Make fair tag sharing configurable via sysfs
  scsi: ufs: Disable fair tag sharing

 block/blk-mq-debugfs.c    |  1 +
 block/blk-mq.c            | 28 ++++++++++++++++++++++++++++
 block/blk-mq.h            |  3 ++-
 drivers/scsi/hosts.c      |  1 +
 drivers/scsi/scsi_lib.c   |  2 ++
 drivers/scsi/scsi_sysfs.c | 30 ++++++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd.c |  1 +
 include/linux/blk-mq.h    |  6 ++++--
 include/scsi/scsi_host.h  |  6 ++++++
 9 files changed, 75 insertions(+), 3 deletions(-)

