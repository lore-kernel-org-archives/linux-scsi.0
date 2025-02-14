Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3936267706
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739553145; cv=none; b=Zt63nfsJ5MrM5wJbHcHtHTUTtrW9UIFBhx+wnpnnvibO3m0ZUg/a/VaSEoGLzL7n269kaRTTW8zEvriwg0jYCaEY/c+wUzMRiSBJ6PS0JXXObL+1aMiSLSm69IoXUgtOrIsMzFp1kLXNRmHg83Y162Lo+ww6wtyn9qu9pw5MF4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739553145; c=relaxed/simple;
	bh=ERJOKrkPTqG54cRHxFMcIcDN+46bus5YIHhkbkRGCME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=plGJipEz/oPkS75A3XScH8pDe6vK4p3mZtmifYfXuV/gNJIUy9UH4yv6NdgukWI0Qcf0updr0MkajKm+4/7nRBq0umK5byYAmE7kh6SVTbAceKE8PMX3b1EIgYGPLP5LpVB/VngrQpgTX69ZlLIvvC8yGUJQPlg3/j0cUQbnDlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TYlKQLtB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TYlKQLtB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Yvds31cl9z6ClRNk;
	Fri, 14 Feb 2025 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739553140; x=1742145141; bh=ERJOKrkPTqG54cRHxFMcIcDN
	+46bus5YIHhkbkRGCME=; b=TYlKQLtBnPAVn5caFBR+Ja8IFEAJ5csNKWk/2hBz
	Yt8jk7sukLgZpop4H9I9vAVUFkJ2juTQ5sTmqyUVTWUUv9Sm359f4kvrlN3kP7o+
	R5pINrQfZJob0l0mkdpeYgFHPMqBhZKVNir6codEGOoq/xybcl0rw6ZzIM51AYCC
	AtmZ5P1ORM1F3X5qgYIS/KzOWLOQVV03a5Yl1NuK0T2cTQ5AutVnVheUfev2tKCX
	T2K7hrNzrrl/SwfHOiHSnF6DU+9efgbscN/0vkbSeGxS7yIzcBrH/D8nFl2sI8eq
	n/xeXgb7Qi7XWTos0TaQd0ubeaFhLw1Xa3OAkud3qCktbw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d-mvZBhj0FZx; Fri, 14 Feb 2025 17:12:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Yvdrs683Vz6Ckh6m;
	Fri, 14 Feb 2025 17:12:13 +0000 (UTC)
Message-ID: <88680b95-97b8-41aa-a39b-b1d03f93669b@acm.org>
Date: Fri, 14 Feb 2025 09:12:11 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250214083026.1177880-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/25 12:29 AM, peter.wang@mediatek.com wrote:
> Included the ufs_hba structure as a parameter in various trace events
> to provide more context and improve debugging capabilities.
> Also remove dev_name which can replace by dev_name(hba->dev).

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
