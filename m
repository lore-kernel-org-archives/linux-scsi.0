Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAC71A680B
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977536; cv=none; b=YmHVxj8ye8Nr6dcIvFR57XxoztAwRHpn84K7OiPY0iH2okKPcpyriK92bCKGQFMXHYPpzT1tvBd6yR1eSBKlfI2lJz8y9JH8eyRmIa/aMyTG0dOFQCFr9ekRNT8/1gd8ExKHUU7k3zb7qPith1o+6IO86rfzVfPgFr0ERmR6CLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977536; c=relaxed/simple;
	bh=YspoImzdksERxhmOh2NPi//ob9ir146hFN4OI2Rirts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M6ZoFo/+kixd4UDBHMP0bjK3ZoxiWomRtGtW/gSp8ayra0fQGCRdR1SEAHMyFJOnxRsHczePUfxVNoZ94wajIWDtfls3DvH1Z99PbzTwPVZSv4CtesqlG/vOSqEeKYGRQN3q8tEwl9a7qsF+9eHQivbWMsBt7pcp33/M8JsD5l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XkBSvIve; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XkBSvIve"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-39c9a3acd40so23651471fa.3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 07:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786977532; x=1787582332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oCSrzv/x/EsDEu6lQig8HJGuanj/sQwHpZ8VXFCo6c4=;
        b=XkBSvIvenoMmfHiGMFSiLk8LAnx5fIA8K2BmN/Apq+90rlifglrm7Om0LZ3jTJHxyz
         gX6uhdjidjSB4LRNzEmukromDO5BqGEWbB2o1+MXwmkw3d+CGQpX0YBl7yJK8vDYp5ar
         /gJ9XDbTP2BnDkUXhZPLEGlXJNmXT/JX4yAF+2K6DK8VBLxZLZ0+7FIIfApz5scH+dnK
         mYtHPUXVOfU04QdOzd+gIktrhOFexC7kKRUGlH128dXLgE6GN7uMQwc/ddmSLPQ5MCo1
         HXoeBiIwIswOfGETnri9lQ33bJDYmrADhi2rvyENy97f+sxzOFFE5LTtLZgzTqyxTr1S
         +45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786977532; x=1787582332;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oCSrzv/x/EsDEu6lQig8HJGuanj/sQwHpZ8VXFCo6c4=;
        b=XknpBKgKm1FrnY0VBlaoYJDmvFV0sypCYKA5f6NGgKqgRyEu5gidrtUg/QvsZh/a6d
         HZw31EEDpfMxLaDzAlG8S6QJCHDzzzYUYpJVUYD6VvPTEnezkz/O0rTJpA4s73f9LaQ+
         LeuD2jU0+CG5GW7Ti0Fgvg/Gq9pg7SRMRlUQlNKhoBjb0TzxkRxAjsgwXWd03kuCBUm5
         J3Zg5r3dr7FcUPjNYTspsNOCdi1XyfH8m2T53je9dKdomvW4H+C2v8eD7dg0l1inLsRF
         qThrvWkbJxH9v9eoOEH35nWVDZfcsj44Y6CJ64qFZTKGt5e6OTRBaltBqDJ46o2ntVOW
         za1Q==
X-Gm-Message-State: AOJu0YwsUZeSXbhTQLKCa8jqeNy+5vDT0ShmTqcx4YPWWYkPV5VNskA4
	Mxtazwqi6ZtrMrsnpi+TNRWek0i8cyMZnclcZ5+ecg40gJUoScnWdnEE8/rtSO1vN0m2lsBk
X-Gm-Gg: AR+sD10IQatXxyVN/T5GPPuQAjM+nEh5yPXxzmEQ+pdP0SN8L0td3AQpb4LPROI5kIL
	lFe+5As7b5dRzrV/+L6VrN6qGl+QEdUD4VItrioFMQD6QhNBaEBiWDsqu33Qcg5vDaIpsgJXtMg
	HERHjbLjngMDW06iXMSXZKPhRAAWk5rQlBDkr8odPreFh1zJ14CqoWIW1IACDHpI3daRNg+Jl1B
	Tm0nXVnLKdABFyTRep8t/vSqA98XtiAbfHLOi5XI8c9WsF3zgM4e8+4cm5F3BmeUXmq6m+y7DCA
	KS6nUvJ4uocNJhj40ZqasexbecrtkRTP5avbWrWvWrCp3oV+vsuCoNouHndDnehGVi3enKYyXIe
	Gjpet98Gh0rw2icU4QPVxjGaLtot8x2PDACtsNj9lP0wcQqu0n5VpA0d6ZehjC/qU+Pgx4e98Jz
	HvzW/9xKdiKDlgTRFzq5z2v1RGlMOgiGW9twIkgxyWB+XoBlSuxw4QK9T2d+91Ag/qSwCNxY63m
	hAvhbxf37yPph9wVowjGSqK
X-Received: by 2002:a05:651c:a207:20b0:39c:628c:15ec with SMTP id 38308e7fff4ca-3a17521aad3mr300611fa.23.1786977532212;
        Mon, 17 Aug 2026 07:38:52 -0700 (PDT)
Received: from NB-9797.corp.yadro.com (mail.xsysdesign.com. [87.239.190.198])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a16b0e1f18sm5412881fa.12.2026.08.17.07.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 07:38:50 -0700 (PDT)
From: Ilya Khomyakov <khomyakovilya@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	Ilya Khomyakov <khomyakovilya@gmail.com>
Subject: [PATCH V2] scsi: mpi3mr: check the SMP passthrough reply status
Date: Mon, 17 Aug 2026 17:38:41 +0300
Message-ID: <20260817143841.1856-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpi3mr_transport_smp_handler() obtains the controller reply status from
mpi3mr_post_transport_req() but never examines it. The status is written to
the debug log and then discarded, after which the reply is copied to the
caller and bsg_job_done() is called with a success code.

mpi3mr_post_transport_req() returns zero once the request completes,
regardless of the reported ioc_status. Its return value only reports a
command already in use, a failure to submit the request, or a timeout. The
existing "if (rc)" test therefore never observes a request that the
controller refused.

mpi3mr_report_manufacture() issues its SMP request through the same helper
and tests ioc_status before using the reply. mpi3mr_transport_smp_handler()
is the only caller that passes reply data to user space, and it performs no
such test.

As a result a refused SMP request reaches user space as a successful
transfer of zero bytes. The BSG completion path derives the sg_io_v4 status
fields from job->result, so with a result of zero device_status,
transport_status and driver_status all read as zero and SG_INFO_CHECK is
not set. The only remaining indication is din_resid, which stays equal to
din_xfer_len. A caller that does not compare the two accepts the empty
buffer as an SMP response frame and parses it.

This was observed on a 9600-16e (SAS4116) running firmware 8.17.1.0 with
personality 0 and profile id 3, that is PerfIT SAS Only mode, with an
expander attached through an x8 wide port at 22.5 Gb/s. A user space daemon
on that system issued SMP passthrough requests that the controller refused.
Over roughly one hour the driver logged 109 of them, every one as

  mpi3mr0: sending SMP request
  mpi3mr0: SMP request completed with ioc_status(0x0001)
  mpi3mr0: SMP request - reply data transfer size(0)

ioc_status 0x0001 is MPI3_IOCSTATUS_INVALID_FUNCTION. All 109 were
reported to the caller as successful transfers.

The driver's own SMP requests to the same expander complete normally on the
same system, for example

  mpi3mr0: report manufacturer SMP request completed with ioc_status(0x0000)
  mpi3mr0: report manufacturer - reply data transfer size(60)

so a status other than success here describes an individual request that
the controller declined, not a controller that lacks the function. Besides
MPI3_IOCSTATUS_INVALID_FUNCTION the firmware can report BUSY,
INSUFFICIENT_RESOURCES, INVALID_STATE, FAILURE, SAS_SMP_REQUEST_FAILED and
SAS_SMP_DATA_OVERRUN on this path, and all of them are currently returned
to user space as a successful transfer.

Test the reply status and return -EIO when the controller did not complete
the request successfully. The new exit uses the existing unmap_in label, so
the DMA buffers are released exactly as before, and reslen is still zero at
that point, so the length reported to the block layer stays consistent with
the error code.

Move the reply copy above the new test. When a job completes with a
negative result the BSG completion path shortens job->reply_len to
sizeof(u32) and returns those four bytes to the caller. job->reply points
at a buffer that is allocated once per tag in bsg_init_rq() and is not
cleared between requests, so leaving it untouched on the new exit would
return four bytes left over from whatever command last used that tag.
mpi_reply is zeroed before the request is submitted, so copying it
unconditionally makes those bytes describe this request. The error paths
that precede the request submission have the same property, but they are
not reached by a completed request and are left alone here.

The change was tested with a patched out-of-tree build of the same driver
on the adapter described above. Before the change all 109 refused requests
in a 64 minute window reached the "reply data transfer size" trace and
completed successfully. After the change all 141 refused requests in a 73
minute window returned early: each was logged with ioc_status(0x0001) and
none reached that trace, which is the expected signature of the new exit
since it precedes the trace. The daemon that issued the requests behaved
the same before and after the change. No warnings were reported by the
driver or the block layer during either run.

This does not modify discovery, I/O or link management behavior. It changes
only the result reported for an SMP passthrough request that the controller
did not complete successfully.

Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -3320,12 +3320,18 @@
 	dprint_transport_info(mrioc,
 	    "SMP request completed with ioc_status(0x%04x)\n", ioc_status);
 
+	memcpy(job->reply, &mpi_reply, reply_sz);
+	job->reply_len = reply_sz;
+
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		rc = -EIO;
+		goto unmap_in;
+	}
+
 	dprint_transport_info(mrioc,
 		    "SMP request - reply data transfer size(%d)\n",
 		    le16_to_cpu(mpi_reply.response_data_length));
 
-	memcpy(job->reply, &mpi_reply, reply_sz);
-	job->reply_len = reply_sz;
 	reslen = le16_to_cpu(mpi_reply.response_data_length);
 
 	if (addr_in)
