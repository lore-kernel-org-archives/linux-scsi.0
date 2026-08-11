Received: from outbound.st.icloud.com (st-2001g-snip4-5.eps.apple.com [57.103.76.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D53C09F2
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 16:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.76.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465367; cv=none; b=sTye9028B6aQVZp3BZmUZwSQsVmJdbb/b+DA292GCyrBgUv8Yy/zxBjgnquTDbpIXFWX5LB5Exm2dXz2JBHc2vothFYy9OCjT7ZxLQ1gcjoHcVjsVWu37UAL3QIdzDUXuifMd1JOPPxGhL7OUBvNnhZA5WWh6++r2gIR2r//uYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465367; c=relaxed/simple;
	bh=5+KshFGHOKwhJsQBhMK5i8klUhW9Jw0m7w5vhhtRQrI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZmr4JKQJRBzwIJuPAn2QwdcmKdFhg5jtBT4br8CEHf77Q6J6dgJVf8smRo2CaOKlnLG2raXeonLhbG8tq+AQ9BkfIPIAqaDqS0FcKjyqUwnMoNjBza3nA3x5Xui7kju2wUozeLa+A+6FhHOmHLds5btm7zb7XZjlIgi0tsnQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=059kR/gP; arc=none smtp.client-ip=57.103.76.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="059kR/gP"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPS id 6741718000A3;
	Tue, 11 Aug 2026 16:22:42 +0000 (UTC)
X-ICL-RepId: 019ff1a2-21ab-7071-b50f-2414846601a9
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQ1PHVwPUxxGClYCVAFLVxQEHUAFVgpcQglLAi1eCF4fTBwdDlgGEhZdRVoOWwRHFBcbXAAXGVFNDlhbCFsEDx9MDFECQgVWXkoMHQRUB10FXVZQAlpLQgRLRWhcBVwcQBdIHV9qS1YUBBFQAVgeVl5aF15NWgJWTQVKA18BWwpBCEkFXwVZAV4NSQJdAlkfQRQdQAVWClxCCUsCLV4IXh9MHB0OWAYMUE0BQwgKAlEcVg1X
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786465365; x=1789057365; bh=DBNg9HDmdQBOqzIDgu5mG4vVs/uuY/4QrgB307lb6yY=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=059kR/gPfrNAWnm02ic73+Dsl4MnLYBre+kUzQ9DhyjY9/tV4aWwOj2Rsh6vnj1NprGUgHN9xpxC/JhHUmtrMZTYEFS6lqQqdZp4HWLk8kVs+dct3xcgTRSioPjn8k3TsJMCU7F49jwMdx6WKGmjci/wrRyyqsBN82EhXW9ECWVQK0Cw/dpELDiSWClWJbRRBFi9ZRGeFS/XBxBAyUhfxZz8qIhVGfxWiPv5TdUx1HrV3GLP5PGXFyEaqqoysAomhPWf90ytBEqPVjT34dO9iXjEkQYuFf/QJzhAfdTdouSHfDiedE5xc64aCevqyeLv5gb6B0ssp0M7xxENum7vZg==
Received: from machine (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-10 (Postfix) with ESMTPSA id 0FE4718004C6;
	Tue, 11 Aug 2026 16:22:40 +0000 (UTC)
From: Eshaan Deshmukh <eshaan2031@icloud.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eshaan Deshmukh <eshaan2031@icloud.com>
Subject: [PATCH v2 0/3] scsi: libsas: Handle errors in 3 functions
Date: Tue, 11 Aug 2026 11:22:20 -0500
Message-ID: <20260811162223.411052-1-eshaan2031@icloud.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDEzNyBTYWx0ZWRfX/s5Ns2gUpsVX
 90kc4WSbXp3s3pKwP2VsWN1R2Eyueugui3atAfgpGS2kLUN7f4bSM6OlMG85/rXdjeS5nQwHUjZ
 dtVZ5NR5jbyil4rIHTNC+qoUGscAyYd0mSzScrvGRXKvOFB/6J2NA9GTX7MzPjlCNMmqx98lPV0
 diDzTEsjudPAE8zYEoqaNoIRqxVccf9E9b2ADnZP/gYWXaSLZqo61KRj7q7WYrvFpqFmtwWAAQN
 u2SZj6+MvLaB0TQnUh59c3YnMWcC0HPS00UKWd57InXecHqUeDsIKNJSsWaZrcKKFhtLHd3z7/T
 VXcefm0trzP2tC4NYxb7OUJ6YFGgsC/ptE8ISgZiWHqDSPIXD28GJOtObCeYd8=
X-Proofpoint-GUID: r-LdeItg_OtpdY8NJ0Y0WhKUvzMOgr_G
X-Proofpoint-ORIG-GUID: r-LdeItg_OtpdY8NJ0Y0WhKUvzMOgr_G
X-Authority-Info-Out: v=2.4 cv=LuOfC3dc c=1 sm=1 tr=0 ts=6a7b4c52
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=ea8ixM18I5MA:10 a=VkNPw1HP01LnGYTKEx00:22 a=p5nTp-o6oSFkd0WaucIA:9

These 3 functions include several uses of BUG_ON() and lack error
management. Change all 3 functions to handle their errors in better
ways.

Eshaan Deshmukh (3):
  scsi: libsas: Handle errors in sas_ex_add_parent_port()
  scsi: libsas: Handle errors in sas_set_ex_phy()
  scsi: libsas: Handle errors in  sas_ex_discover_expander()

 drivers/scsi/libsas/sas_expander.c | 71 +++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 22 deletions(-)

-- 
2.55.0

