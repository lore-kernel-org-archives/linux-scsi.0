Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC211B0F1C
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730719676; cv=none; b=MC/l+p7C5ajC2AAws2xnj64YMiQ3vlP6m/W0oX8bYVUK1eTPYDymMsTvM3ti/7Ybi8uo1zLj0FuriEpyOcUO7t5Rof6n6Ko27wABvjwj9rd2ZyPrElfCL1lAO3ob6+cqGwqqO/3y7QdgTXd1vEO3LZR3UOJ7gJ0giNgAPOYIK6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730719676; c=relaxed/simple;
	bh=uLWXsjAY/qJfjcPXAHa2FsHQcyAA1xiTaMUlpn3gXWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VVLpDu4BxJ9BNmwXvY0km1/QJGV5HJCe9sM2b6r36i9jiqN4MAtHLoyK37WMSyeUsqixb/ewt814ul1o5BjCSXTOtTnreDyFDjHC8yJx2CCSD+YaLT9QwWHeBNQNZDzB7FU710mkBDSp+t8O6mFusRV2YUg2uFHcuTVKuTRk6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=p8CfUdWf; arc=none smtp.client-ip=62.142.5.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="p8CfUdWf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=UuIe0zaPSwBV+JJ2fESp3SXw6hBM8P0UFYlV080tmUI=;
	b=p8CfUdWfgB6LqclAyLvtgCMGaDK1VSXqkAydP2sPEDzqPzBNiBPcX/bfUifbmT/OWEDDKAQden2YE
	 wV+ehheC4WkK7fWVlzcKIfENjrOndr61NzU0hqATMLZ9gP8dFPPLvF7p2lQjFz49xPzleUamPUIGi6
	 fhmJAn+MMFvWj4F0yFIaUU7Elr09tRZdr3jPOJDjlzkkw1A6olMqaGNBUoBIkIYMtAvW+s0xhbAAJp
	 6v+z7FAIL+/7Ax3p8pzTmfNWeo/uSgt+MPhfda7X5GlIRad8rym3bF5C3Vl6JBxqYDynJPJCcVf3H0
	 9UBqeFrriu4qEnNXL1ap3v36UkQnF9Q==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
	id aa70ec24-9a9f-11ef-8872-005056bdd08f;
	Mon, 04 Nov 2024 13:26:42 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	loberman@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 0/2] scsi: st: Device reset patches
Date: Mon,  4 Nov 2024 13:26:21 +0200
Message-ID: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These two patches were developed in response to Bugzilla report
https://bugzilla.kernel.org/show_bug.cgi?id=219419

After device reset, the tape driver allows only operations tha don't
write or read anything from tape. The reason for this is that many
(most ?) drives rewind the tape after reset and the subsequent reads
or writes would not be at the tape location the user expects. Reading
and writing is allowed again when the user does something to position the
tape (e.g., rewind).

The Bugzilla report considers the case when a user, after reset, tries
to read the drive status with MTIOCGET ioctl, but it fails. MTIOCGET
does not return much useful data after reset, but it can be allowed.
MTLOAD positions the tape and it should be allowed. The second patch
adds these to the set of allowed operations after device reset. 

The first patch fixes a bug seen when developing the second patch.

Kai Mäkisara (2):
  scsi: st: Don't modify unknown block number in MTIOCGET
  scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed after device reset

 drivers/scsi/st.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

-- 
2.43.0

