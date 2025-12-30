Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E1822301;
	Tue, 30 Dec 2025 03:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767063939; cv=none; b=GGN3uEzcaigPcPLCWkOaLfu8SWBVb1ndh+UQaJLglL6GNfB4g9zaITjSKo/j8g9egylBwCHeIVEasW/BHB7WLkZqT26490tsEYJCD1Rjbke+XYoT5ySUhXQcee/nBKiFKiWuKcYdKzAVhZQdmu+D7dtpa+vcy9PLi97+Y2gS8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767063939; c=relaxed/simple;
	bh=LuxA1dtUSJM7h4o5DZAfDHEkROaYV5/pXK1PDCtFd3w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WeA+p1C8HDG0jWS9jf/5RvfiNor7HatiRwFxvd4vpRs8aJHbP4xuVRxyfRS6bMnaaQhDjV9uQBnCIj/zTs0Yzw48BNwBYiz2DvRuiUUAg4QVaJazcObXluqeHzNwnCHjxlLdL8KFb65rTHM5huSJRoiaetLHL5D4byOQyoGnahg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=M445vChF; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="M445vChF"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2ef81f525;
	Tue, 30 Dec 2025 11:05:31 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: justintee8345@gmail.com
Cc: James.Bottomley@hansenpartnership.com,
	jianhao.xu@seu.edu.cn,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	zilin@seu.edu.cn
Subject: Re: [PATCH 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Tue, 30 Dec 2025 03:05:30 +0000
Message-Id: <20251230030530.904219-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CABPRKS8=__+4TcW9wjzHuVSZa7wKhJpzT4VGubBHet4TSc-u7w@mail.gmail.com>
References: <CABPRKS8=__+4TcW9wjzHuVSZa7wKhJpzT4VGubBHet4TSc-u7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6d37c93803a1kunm38ed9bf814326a
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSkMeVk5NHh9MT0NOSBoYT1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=M445vChFuY9Gils/toefazjPGZdP+npeFNRulnuWZRm0xdfwYUf11iZfVSwRqBtwtSAZVMyodk4dYMPKBwdXtPOBLfoaBXIBHoUke9uPOOxqpZYPJuyiVpkOJw/PFOwqb4ZA/AQM4xK6rW2wdCY7Q9G8r6fM80nDLMkGgQ+EmfM=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=bONxW4amIthPu9XwMq0joiXDlKCnR2su92b+SGT71uI=;
	h=date:mime-version:subject:message-id:from;

On Mon, Dec 29, 2025 at 06:04:01PM -0800, Justin Tee wrote:
> Hi Zilin,
> 
> For this patch set, please see and attend to Markus’ comments.
> 
> Regards,
> Justin

Hi Justin,

Thanks for the reminder.

It seems Markus' email was accidentally filtered as spam by my mail 
server, which is why I missed it. I have retrieved it now and will 
address his comments shortly.

Best regards,
Zilin Guan
