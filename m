Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702E36AB43;
	Fri,  6 Mar 2026 03:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772766347; cv=none; b=V7B8gORt5HE2Yrixwf4qlJG1f0mGXCF9hL8lfsu91NJB/byGvi6tgh3TMjVPmevXciexEmfhxR72jIHR8nCHsBGDIaGWKJaRxZl8WGnRQRPKoEigLZBXmIblVW2SwWs0+A9REwIMYe8lbY+DqL8Fi2PcIiUJJ+CJtEnUEOF6rdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772766347; c=relaxed/simple;
	bh=OmYa+X/DNW7chfKmbZbgrvnTrLdaONANn760yE1VtNU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CEhFr6e4r5AY8UOL/+USSopeleQ1am4NrqoOSnrcpLV+MhgSok3SIpjkD+YWHTmRcIFLMp5AL94g2lZtXvU/UkqLsVzaDgNFSSfYmp1qgaKCMNJR7FVsYRn2r/aa0hKgPc/bd1Htgy08AF+PksMgvsIRSgsnXpVuFPYXt9Amwl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=HdzWAZ3Z; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="HdzWAZ3Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=vc
	p9TahfoyZvSe9UJSTHk5cS73XVBlxcflDVDwURl5Y=; b=HdzWAZ3ZTENS53tLhF
	exfEpGQK+FnF2N6N1Cl8b37kez3B5LqE6aWyZZknaezATo7liS+15fHIAgoF5usv
	NYewSzlzu23UM/0T+mp9mRnHq00HtYjKQhIkbVPcv3BdIi5XSAb4Elk/oVxYQrJm
	+8QEnebMFvefv5Nu4EjNAD0aE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wAX0wBMRKppbqiLOQ--.53622S2;
	Fri, 06 Mar 2026 11:04:45 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yangxiuwei@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] scsi: bsg: add io_uring passthrough handler
Date: Fri,  6 Mar 2026 11:04:44 +0800
Message-Id: <20260306030444.84715-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b3d4d3c0-3992-44be-827b-e9089ab4471c@acm.org>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-4-yangxiuwei@kylinos.cn> <b3d4d3c0-3992-44be-827b-e9089ab4471c@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAX0wBMRKppbqiLOQ--.53622S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZryUCFW8uryfGr17JryUAwb_yoW3KwbE9w
	1Du3s7Cw47uFsFyF4rGan7JFyaga4v9FyUua9Yqry3ZFyIqwsxJw1kXr1IvF1kXay7Kwnx
	Crs0yayY9r909jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREOzVDUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6g0puWmqRE1LLgAA3Y

On 2026-03-05 15:39, Bart Van Assche wrote:
> Why separate members for device_status, driver_status and host_status 
> instead of storing the SCSI result (scsi_cmnd.result)?

You're right. Since scmd remains valid until blk_mq_free_request() is
called in the task work callback, we can extract all status information
directly from scmd->result in scsi_bsg_uring_task_cb() instead of storing
it in the PDU. This approach is cleaner and follows your suggestion to
read from scmd->result directly.

> Please remove the superfluous " & 0xff" from u8 expressions.

Done. Removed all unnecessary " & 0xff" from u8 expressions.

> Please use the status_byte() macro instead of open-coding it.

Done. Using status_byte() macro instead of open-coding
(scmd->result & 0xff).

Will include these changes in v7.

Best regards,
Yang Xiuwei

