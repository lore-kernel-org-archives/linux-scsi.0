Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B795D32D7E6
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770748923; cv=none; b=lQkhCHRg3+CNq9T0VgTkI2Dx7awbewbblcNQuqnhnuICUWsxhfHAw+GNjNzeD1WWpJzijdiqDh93T21a0jGuaDM/v2ewOd/h74kYzYwIj9PyBTDjc7KK7W4/g6QnGRobBJ+W/v/jOnej2qmkVBHOMOA7876pBRJaDKuvjRbnJtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770748923; c=relaxed/simple;
	bh=qA7I/kJYrPEzo77yMTNNn8uGOXpGSKO6msM5RGhG9Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RVHTBlI/oQinAJ7x1rxh2kKXFx5q2/1JDtn0dORLdkg+XxkG+vglavrPuLhwTSk5ZOrqnVMkpdBghyRBNXlyZ7PDnNfTcq4NE/x7rzKa0vlhcWaAO0pD/SCYpkZCcfZ3SPbkFngbR/7CVLnxlSvvJMMnKsO/z0QEZ2q9pVz7JaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DnNkr2Rf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DnNkr2Rf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f9Vlt2v2Rzlfvq4;
	Tue, 10 Feb 2026 18:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770748919; x=1773340920; bh=qA7I/kJYrPEzo77yMTNNn8uG
	OXpGSKO6msM5RGhG9Gc=; b=DnNkr2Rf6RkNeryW7z6+17Xjx2KmqtOyLxk2knAa
	FmHdtc18I6YI5oV2orxOy1HKZpHmcMYo3FVCDGc8PF/U3vBkEyuj4Cplz7XwQzy2
	p/hXqyRLxzEzhglE9E1whAqUc7nTJzwTzYOShHZn82twgKHc6OeylG/iMCtfBBEH
	1Ei5kPEDlUSlYmfB6/IHZ48eTwpDhp3TBNISH7+9unGL9sDrn7KNGSBRmrODk5m5
	TZEQJzLsxJFvr1IxXDEJaHkcjpl+AAooviGsD+ijs0po4zTLpWroNwGdT3qrg/5O
	GK890ifIz0sT+R0fEoffOOnFvb1ssCfkcjSAGKQ4v24CVg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MPqQywuOkm4f; Tue, 10 Feb 2026 18:41:59 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f9Vll3136zlfvpH;
	Tue, 10 Feb 2026 18:41:55 +0000 (UTC)
Message-ID: <21c0f687-ce78-4720-b29e-fca35f7f85e1@acm.org>
Date: Tue, 10 Feb 2026 10:41:53 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] add debug log for command timeout
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260210070837.1820710-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260210070837.1820710-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/26 10:41 PM, peter.wang@mediatek.com wrote:
> Add some logs to make it easier to debug after a command timeout.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
