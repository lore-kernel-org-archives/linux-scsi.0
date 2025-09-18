Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8335947
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223784; cv=none; b=ueGehrbpTzO0DjpwwWEju8q7jW2TPBgrQM/HrFkHF8UMCsaO8YYr4B15fetrY62EsxnRMJh8zmATtHqNUscU1oIebupoefu/8Qqp7UqdBAy4JXSc8+AGI3Ah9v6o4NA0F5n6bAXrZ0YETTzrzdrxnX/ujLv5wYoVpGhcVPgQ1C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223784; c=relaxed/simple;
	bh=j3d9LgivSXMoLNKcbETWiE+fGRhYxj5rbwvQIJLHYVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kpa0zjDKbVbpLIU7LlgaFiXFtHw9NNpLeKKvAGRYXkaa5iHkcnpySBtRktXlFIpndbNpkkgOFdhk/XOpH2XYGBUJCbUBJu5IKAlqFWYC4Ed70AAwekfgFdIsc/B6EByUU1ZA7sZojsk0MRgK6xgVlxA/im3DUgLOYNyDUULtKUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B5xP7BHh; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B5xP7BHh"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cSQgn54qGzm0yVF;
	Thu, 18 Sep 2025 19:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758223778; x=1760815779; bh=j3d9LgivSXMoLNKcbETWiE+f
	GRhYxj5rbwvQIJLHYVA=; b=B5xP7BHh3TR1JY17//FlGJwBErXzcNqHgVCamrif
	MHIkGFLftk5XeHQENrxpm1wVXfelyqAjfSJcUtbjjKhxaI7YX5UCoS6gkNqckPrA
	Ell08reLHgs0MVM8qI5nW+z6Xq0xgZIJ+H7n8l47HBGfiM8M4gLetYbgM3Q9Zn5p
	2yKyYBTunO3e0xAvVnHmlh3I/wDqUFHdtv4MaosEj0Js8lRG5kHRGM8EEVRWSib5
	pYNE0BEGlZQOBY5n2Me9FDC2OJytIF+715+yfBHfT5B3k0Vz9iaxUxXftEC3ja+D
	1skhGdh/VcCigGua+89u/n9us+KuFgHiD1NajFkvyuXFRQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ssvqe8TAYQZm; Thu, 18 Sep 2025 19:29:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cSQgW0XCbzm0yTF;
	Thu, 18 Sep 2025 19:29:25 +0000 (UTC)
Message-ID: <c1b426cc-f45b-41dc-b4e1-145c1af5b138@acm.org>
Date: Thu, 18 Sep 2025 12:29:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/10] ufs: host: mediatek: Remove duplicate function
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-9-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-9-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> Remove the duplicate ufs_mtk_us_to_ahit function in the UFS
> Mediatek driver and export the existing ufshcd_us_to_ahit
> function for shared use. This change reduces redundancy
> and maintains consistency across the codebase.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
