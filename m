Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC22380FEC
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 16:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786639689; cv=none; b=jWNU0bLuJBewV0nQ+m1BtnvckXM8PsM85AX18lorolSeLrh0MkQR320rP9onbLzDTJmi7waXeGibrGwnpVlzF+vfRjQsvfUXfsh0k6wokSSoYcFk9OkDkuXPjhguLdXYXVGhIB9l11fD1Haspp/Aq1rPp1kvawr6kt2/5VReldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786639689; c=relaxed/simple;
	bh=RjirvaYauxVNnKQ9Sm7lMDoG/zwS4TOrS8VhL2NRLmU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RqUboJr0n+Io3EZjMynm8lfdJKbtNyMHb+Hpwk7ErtCdozIer+Tuso0SfsKIKHL2yTxM/tSbjuTaMFnZqQvBzb3O694LMUp/lCsuzO/nTXfb1eCIF5fJHxsyo+FFhtu/JhV4eeA+MgAnhCy4Yh0crhLLvD8+gIufXrNLomNXkdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EJoAxz8P; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJoAxz8P"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b2a3166398so2831332e87.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 09:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786639686; x=1787244486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i8hy0E4lhP7WDoKHe7j5IKSOB/O53La4NbbAqCepIP8=;
        b=EJoAxz8PpcP+WIBIFVgsIYCvp6Cks5PnmUHgyQCA4VWsZBy2CtqxoD1iCPsYuA1q8F
         NmXG8Ayln/n8U2CqP4XamFWlLJ0ZJ5NXHjLhFb+JVBrtwR6awxS4CEfku4Hs2eosDf5o
         r6CsxfrwRUkrxld2fLzHC2U4IjW5RGdrK4p+M9ow31lFEEG/ZpxbGvQ7ZV1vNeWPKLvI
         X95UeJGr+h10UEFF05YGihjKavQrkvNA/vlxQh+hKPpJIlOr4kmoqRSkiuxxBk5uTfuO
         bjlSFcJEmZnTcclY+MckPmak5DuQ18yJPYxGGsddRmYQYak/U7qkVwz4b7bfKSal0+Lp
         Q0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786639686; x=1787244486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i8hy0E4lhP7WDoKHe7j5IKSOB/O53La4NbbAqCepIP8=;
        b=Rv7pybwBey17Am6c+k66qFRSeADXcQjVVTZ6doCQIDiyBcxYp62LXNN3LnSjOXQWkA
         rKzqZFF64tB9cgLbVYiDQH6+/CNp1Ngjmm/QGRddt8vBpc6KIU/cTUeYvdvgFxOn4KeC
         QpYe8cahlr2ZJ2i8aPJ/V0O4NjG0K8ntpULCuZxaiyG06F9VEF6gTsORUtdd1g7dGRkh
         DvKI7Rw/sgVdyoSVctEdURe7CPMMWYEJ5TfiHzB5bUntwD8SM8glthr1cArAL1gMZoFv
         vDdG21EzIyE5QHLz31NLbi9pJQRzjMm4pcHWwH2QEZ+/SHHD7gKWOYiuph7w5KbtRwbU
         VCiA==
X-Gm-Message-State: AOJu0Yy4FryQgIWSrfsyzDoAgyI2e5UpmFA9uEKKyYB6VT0GrsoIs25v
	2O3OI1HjqEDNbDPW8x2RXLRh/lXQkk9hy3cY8BZDSD5GYa3iyIT+RaG8F4yk7OAE/pAQu8vb
X-Gm-Gg: AR+sD10cn+w5vNM7/2cu/jJqsckz00JVPFf1xZNU1pJ/vgQmUGj7xJYap+JNrYzqHS+
	QeefvVPeqVzw34JpU5GxxlXHfV+NtY9qh1U+92g7HSIylZA1yRg0OK9dJlFDlgKIUpWaHKpL2yR
	C/NzYbi4l1QvQrFQDiqP997tbl+3snQu1Ym0FKDHqxqSnY05iH2Sa/FjXuu723kBRhJiG193VOn
	FjtzWhRb+C2v1RZRPuAvNrQIkB7q1t+5Ps2riRs5h/+FYv3+x4bfUQSSlMw03HE+raMuyQkK4+8
	VG3ffNGvOtBHAKtM9RBydMBaZLyLVXQ7Qqfs6yjF4ayioHR24hR84g+nzy+UgNeiNdXoFo1nwty
	zSk7MyHLYyRcvN5gaVbu7g8DXHDdl4qTMI9dtCt6Q4Jc2fG3+KAlVNzLu5+6ebFuo/fMD2L+rl0
	PGnzTEM0nbfj7bzQMqhplqPi0Fyosnz2PWPKt4HH15YwCZ3Dkk7BphhNxqLbeIDxqs+Wn5uXy7V
	06ONI11X6osY4YD7rFeZx23skRZlBBbyIM=
X-Received: by 2002:ac2:4bc8:0:b0:5b4:5352:e2db with SMTP id 2adb3069b0e04-5b453f4dd4emr1247188e87.20.1786639685746;
        Thu, 13 Aug 2026 09:48:05 -0700 (PDT)
Received: from NB-9797.corp.yadro.com (mail.xsysdesign.com. [87.239.190.198])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b458bedfcdsm2782e87.42.2026.08.13.09.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 09:48:04 -0700 (PDT)
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
Subject: [PATCH] scsi: mpi3mr: check the SMP passthrough reply status
Date: Thu, 13 Aug 2026 19:47:57 +0300
Message-ID: <20260813164757.1610-1-khomyakovilya@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello. 

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
expander attached through an x8 wide port at 22.5 Gb/s. In that
configuration the controller refuses SMP passthrough requests submitted
through the BSG interface. Over roughly one hour the driver logged 109
such requests, every one of them as

  mpi3mr0: sending SMP request
  mpi3mr0: SMP request completed with ioc_status(0x0001)
  mpi3mr0: SMP request - reply data transfer size(0)

ioc_status 0x0001 is MPI3_IOCSTATUS_INVALID_FUNCTION. All 109 were
reported to the caller as successful transfers.

Test the reply status and return -EIO when the controller did not complete
the request successfully. The new exit uses the existing unmap_in label, so
the DMA buffers are released exactly as before, and reslen is still zero at
that point, so the length reported to the block layer stays consistent with
the error code.

On an error path the BSG completion path replaces job->reply_len with
sizeof(u32), so the MPI reply structure that today carries ioc_status to
user space is no longer copied out. That structure is driver specific and
is not examined by smp_utils; returning a proper error code is the more
useful result.

The change was tested with a mpi3mr 8.17.1.0.0 build on the
adapter described above. Before the change every refused request reached
the "reply data transfer size" trace and completed successfully. After the
change 21 refused requests over a four minute window all returned early:
each was logged with ioc_status(0x0001) and none reached that trace, which
is the expected signature of the new exit since it precedes the trace.
During the same window mpi3mr_report_manufacture() issued one SMP request
that the controller completed with ioc_status(0x0090),
MPI3_IOCSTATUS_SAS_SMP_REQUEST_FAILED; that path already tests the status
and was unaffected.

This does not modify discovery, I/O or link management behavior. It changes
only the result reported for an SMP passthrough request that the controller
did not complete successfully.

Signed-off-by: Ilya Khomyakov <khomyakovilya@gmail.com>

---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -3320,6 +3320,11 @@ mpi3mr_transport_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
 	dprint_transport_info(mrioc,
 	    "SMP request completed with ioc_status(0x%04x)\n", ioc_status);
 
+	if (ioc_status != MPI3_IOCSTATUS_SUCCESS) {
+		rc = -EIO;
+		goto unmap_in;
+	}
+
 	dprint_transport_info(mrioc,
 		    "SMP request - reply data transfer size(%d)\n",
 		    le16_to_cpu(mpi_reply.response_data_length));
