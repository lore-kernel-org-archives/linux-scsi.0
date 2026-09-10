Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4451037A841;
	Thu, 10 Sep 2026 02:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789007955; cv=none; b=Gcs+to7IytXMC+ApYCccHVRMgD4LLKx+tq7ZTelCQsFUOY3ZS0epyBtszxla7lPUhqFarUm8oNjfk2x5K6t4oH7lthgzKB78L5WTe1Bt3SrUHxc9eGj1oiDv1LXjayfvvW6jXYaf3A/T5X/7QoYNtg/AojhLcwjjP7HULQaNNNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789007955; c=relaxed/simple;
	bh=3Rt5XZxZMXvxve0JJoXTpXKQPDBu78q9YkIhK80J8Gw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Teh0PCijXwb7nOBXvcU0xuYaD0H8jZxOVnHw6bsinbmz2MhvYsqASLH3d/xQN6RIQx0hxRwe0vn4jRlYIbL0b3WdZK/4VxI2l7Hy08yiBSGQnB75aWl8Zv3xt9cLGKC6F4GJyfvgjVeOYNUrHrJa3/oHeUEaQ0fCenUDWbSpSL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=radxa.com; spf=pass smtp.mailfrom=radxa.com; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=radxa.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=radxa.com
X-QQ-mid: zesmtpip4t1789007894t75f9c366
X-QQ-Originating-IP: A0rt413Ujb470P1a1KbdvKLSTH0sDKyRuwh7lGjqd98=
Received: from [192.168.30.32] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 10 Sep 2026 10:38:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 13822099932689461020
EX-QQ-RecipientCnt: 8
From: Xilin Wu <sophon@radxa.com>
Date: Thu, 10 Sep 2026 10:38:07 +0800
Subject: [PATCH] scsi: ufs: core: Disable timestamp for Kioxia
 THGJFJT2T85BAT0A
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-kioxia-ufs4-fix-v1-1-ac796423057a@radxa.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM3QpAQBCG4VvRHJtam/9bkYPFLEOhHaTk3i0On
 6++9wIhxyRQBhc4Olh4mT2iMIB2MHNPyJ03aKVTVUQKJ15ONrhbidHyiV3eZLowcZokFvxrdeT
 nr1jVv2VvRmq3NwP3/QC6MDTxcwAAAA==
X-Change-ID: 20260910-kioxia-ufs4-fix-d8b729a4655f
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Xilin Wu <sophon@radxa.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1431; i=sophon@radxa.com;
 h=from:subject:message-id; bh=3Rt5XZxZMXvxve0JJoXTpXKQPDBu78q9YkIhK80J8Gw=;
 b=owGbwMvMwCVmdFg0fe08Iz/G02pJDFmLJASPXlqz/03fq/sRnJP/sCTLWDC+920vaI/ap/taz
 K9Rtcixo5SFQYyLQVZMkUUhnmEue2XutadipXowc1iZQIYwcHEKwEQU3jEydOy4nSV++nPD7T+3
 t+6sPC3+bkWfzdFtb51PJ34Q9d6UuJDhf+VXrX8iXiJhameebGo6J7u4w+3jMjnFnvOWOubyC/M
 +sAAA
X-Developer-Key: i=sophon@radxa.com; a=openpgp;
 fpr=205F009D07796DD6E516752E32C31567AD9E324E
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:radxa.com:qybglogicsvrsz:qybglogicsvrsz3b-0
X-QQ-XMAILINFO: MKP/ykXjBfbuuseeF1dgy62ADwriVvQi3Ifs3TSVyhiLYfvEjh9QcyMO
	UxgXnEH/nYqxm8PFNKZDcjxrFPvd+MuKfoY/oF7AgGAqPveWl2xCKiCBx+O7pHeVlvH1KDV
	mD7eFY72SJn1hIII9VJc57nQlIFsHcFKffbmSAOsDMvJIMAx7CtVk2s3hTXp+71apG83x/3
	rreTH9x3FWh7svbKcRXMvP98GQ4FzStujXxpKXm+EAmYV8Ow/L+qTw9A9//Cy4l24dR1jvY
	H8bZXEH8LdRvujVDZgub3jZPoBihOOXGcxj7A8V1ILwspvpciybYmnF0JcCit4TfSSZ8Lk+
	POJd9ddKsWXA3Yh4p/wpKxS4KX+CbLWJsl1lZqIlQjxBdxxA4LfEg1h/ocWWd1YypIdzEc7
	nQksFpE+jolBKa45pN3tGIRcfO0lE6hI1Xo7kwne2S22n4zHmsxi2CXY9HFAx3l+ozNrg/q
	kFaJCC0sYneA4/Whra6k1yhi2d1HkquhuFXaol37/C6Phu01wyOb+kZ2Vq54M5SFRwbkM1E
	Glmnyqqhgdd/MG92hGr3Bi1Cu4HlQZuhFwzJmxd4naJ8ZSBN7wWTTD7f5Gnab2vcw4YUqsI
	tmrtCI8GF17eocRzyWSWzvqZHSSmHQ40WfrUzgPudcLiud3fE5YmVZWgtHRuHdxBzwasfbn
	JvQNylf3MiJNxcGYksyTeTvi7iNTXVrnhqG+hIEamP3+ewb4z0GjXsxYZqBDsuk+/yHhk/j
	bLuUZ94HTW0iV+Xuk781PJUUR1XXJHoJ71ZxmvgT+aKNDuZZKHMVq7Qc7BBUVqfl/T/i55Z
	cBebTTt+j2VitOzUQvPJWiHkJOvnZL2omZO/Y2uhJqmyzAtpy2c9FUruhWt5ikyy5rORMYG
	U0Mv+SGu7IBqC1DOYeBTfjl65bLKqzxIMwd3wM26Qh3Q9tHF7aP7APhtm8bGyOg8TumUx05
	CLvfjarnAe/3rc3YTCh1uRRZ/u5Ze8WG0SYKryajk1sAmRUROBETGj45mpFD/yEkDymZpBl
	tvJnBTwA==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
X-QQ-RECHKSPAM: 0

The Kioxia THGJFJT2T85BAT0A with firmware revision 0002 reports UFS 4.0
but rejects writes to the qTimestamp attribute with
QUERY_RESULT_INVALID_IDN. This causes errors during device initialization
and whenever the device resumes from runtime suspend:

  ufshcd_dev_cmd_completion: unexpected response in Query RSP: fd
  ufshcd_query_attr_qword: opcode 0x04 for idn 48 failed, index 0, selector 0, err = -22
  ufshcd_set_timestamp_attr: failed to set timestamp -22

Add UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for this model to skip the
unsupported timestamp writes, as for the other affected Kioxia devices.

Signed-off-by: Xilin Wu <sophon@radxa.com>
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..b0fea67d1585 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -321,6 +321,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGJFJT1E45BATP",
 	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGJFJT2T85BAT0A",
+	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{}
 };
 

---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260910-kioxia-ufs4-fix-d8b729a4655f

Best regards,
--  
Xilin Wu <sophon@radxa.com>

