Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1380A1386C9;
	Sat,  3 Jan 2026 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767443956; cv=none; b=VPD9jGc2Le7qQW2zMf6l/EZUWYQTzIVGEFKfeIwFBAxfikFkSZWvZH5IKZ+wmcDLV+FohysnJswaWkXj72F5Ooyw5F6zA+nCVWo55znD6y7Pw/SQ9awH9ueMddIoJU3r9cm2YGOJvCFulOJgclN+6EmBifeX/jG02uezo8MGqlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767443956; c=relaxed/simple;
	bh=XzMkQ8prbg4TZ3d/SoS9QkTkNUVaIv4ry0nvDr8YuuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EzlipsxbZzOLbRkkRuc7rYQgO2sokh1myyEcNE8VdNfliATJo4XfX/oJboN5vL3/2on+qcpFaqt//uXvNTMpizf/EzmQAxXgKsp0tQ9uTG6LxukqBk5OwOq8Y1u6XVlKHzv4wLgItBlH8WsJTcaZn2LSfBlfF8YrYz8iAAfWmNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=nLQXOaL6; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="nLQXOaL6"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f5c7891c;
	Sat, 3 Jan 2026 20:39:10 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: markus.elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	don.brace@microchip.com,
	jianhao.xu@seu.edu.cn,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	zilin@seu.edu.cn
Subject: Re: [PATCH v2] scsi: hpsa: Fix memory leak in hpsa_undo_allocations_after_kdump_soft_reset()
Date: Sat,  3 Jan 2026 12:39:10 +0000
Message-Id: <20260103123910.169563-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <c8571456-7306-4ada-bccb-ba5bd38625eb@web.de>
References: <c8571456-7306-4ada-bccb-ba5bd38625eb@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b83de697803a1kunm4bddd38e2642f1
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGRpDVhlCSx9CGUsYSEMeHlYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=nLQXOaL64nMCrmLGk2ZFMcqkn+lp50qJxhW00lSrD9EP/JKiSQfT0Kfo469yWfJAWqN3omrke+F/IofOd83gacOaOPoaEjQ4zLcvONAbrrE73EOVZLXxJlMSf/54BsiywXILMMLK00D0RPQhU92/ZbvpsNuLdRx/QyCfzWATSLQ=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=eV5girad+tyLghDYC7Wm+e2O+VGvlGknSyIiP4RmVEw=;
	h=date:mime-version:subject:message-id:from;

On Wed, Dec 31, 2025 at 05:25:23PM +0100, Markus Elfring wrote:
> …
> > +++ b/drivers/scsi/hpsa.c
> > @@ -8212,6 +8212,7 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
> >  		h->monitor_ctlr_wq = NULL;
> >  	}
> >  
> > +	kfree(h->reply_map);		/* init_one 1 */
> >  	kfree(h);				/* init_one 1 */
> >  }
> 
> I wonder about the alignment and relevance for these code comments.
> 
> Regards,
> Markus

Hi Markus,

Thank you for your review.

Regarding the alignment, it was an oversight caused by the inconsistency 
between my editor configuration and the Linux kernel's style. I will 
correct this in v3.

As for the code comment, it indicates that the memory being freed here 
was allocated during the first stage of initialization in 
hpsa_init_one(). I included it to maintain consistency with the existing 
kfree(h) line immediately following it.

Best regards,
Zilin Guan
