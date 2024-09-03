Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91511C9DCE
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 20:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725395100; cv=none; b=pfVT3uu25I5dA6g5wNz4Fqbr9MDjeBScO2Vxmzo2CQjBq7mIYn73N3lBJn6qjlaLfjwvyB7/HoWV/K9aJ0vM4kr0jeO6zcAYAWnOCIekbdln4mbd5VTVgvxPFRLvgiKSPM3KJ41mt94O9VksKl/55bH7sF7O0kB/ZZCevKB7xz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725395100; c=relaxed/simple;
	bh=I3xbcbxx9QxpkZbNCu6wZEVexUSJLUsOPYCiQfZj4c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UiyPG5nAsAXZ3UyIjaBtK1/wTyC7oITEV6YUtB2uAEK5JOCMjTxZ6+OSJk4bYlC59YotEA5Yv8JdEMqCNZASYLYLqRzdBkVpGhnpUViCdF9F1IGYIjVJaHmWtz1FHcFyk5Y9AVupGVGlGCtZCbXNAEqPxlipQWN0De2Ohi+IcTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cRE1dp9b; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cRE1dp9b"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wyxty0WDZz6ClY96;
	Tue,  3 Sep 2024 20:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725395094; x=1727987095; bh=lufYU5dpxfofX3PsLuu+tc/b
	4MEpbhQEL8iIj1DHoEs=; b=cRE1dp9bbBHx+OFAAxM7GM6Z1X7+xS6fADQQu9do
	1obg+EySPrUgU11qNppNPIPfwseUtrADEVkbmNi9IsHma+d8pWyOLPiZHwFREOVO
	GUzHprYVCpmGLzue845X8SUZ1ve0NjxFCxBUIBU919bjjdkB7ckBQTyNG4fKezLI
	0e+TguyrttQhmoJRul9pfd4mJhjckFcQsfFGIaQpYktuUpHrqxT0CkCmM+zzCV5R
	NL/zH8XDSNDrQWrx2L0LQjDL/IchBtf8Bye9u2f9zF7Ndid28P2fGWpbWlW5VnFu
	AJcxgkY/ziXR3qaXGcQK2qnSaIW/D3zuGi5CruEURiIw+g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s98yWPcUzRPk; Tue,  3 Sep 2024 20:24:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wyxts0H2jz6ClY93;
	Tue,  3 Sep 2024 20:24:52 +0000 (UTC)
Message-ID: <5d4cbde3-51a0-4c2a-a86d-fb8c3661f8ee@acm.org>
Date: Tue, 3 Sep 2024 13:24:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 9/9] ufs: core: Remove the second argument of
 ufshcd_device_init()
To: Bean Huo <huobean@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Bean Huo <beanhuo@micron.com>, Andrew Halaney <ahalaney@redhat.com>
References: <20240828174435.2469498-1-bvanassche@acm.org>
 <20240828174435.2469498-10-bvanassche@acm.org>
 <70c5f2620d57091be28c735765df4f7fed02ae04.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <70c5f2620d57091be28c735765df4f7fed02ae04.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 12:25 PM, Bean Huo wrote:
> It's inconvenient to review them one by one, so until the last one. I
> understand the main purpose is to remove init_dev_params. Why not merge
> all the preparation patches into the last one?

The main purpose of this patch series is to combine the two
scsi_add_host() calls into a single call (see also the cover letter).
Something unfortunate about the current MCQ implementation is that
adding MCQ support introduced a new scsi_add_host() call far away from
the original scsi_add_host() call. Hence, there is a risk that the two 
code paths for adding a SCSI host in the UFS driver would start to
diverge. This patch series eliminates that risk by combining the two 
scsi_add_host() calls into a single call.

Removing the 'init_dev_params' argument is only a secondary goal of this
patch series.

I'm afraid if I would combine all nine patches into a single patch that
it would be very hard to review that single patch. Additionally, the
patch description would become very long. The kernel documentation says
the following about long patch descriptions: "If your description starts
to get long, that's a sign that you probably need to split up your
patch. See :ref:`split_changes`."

Thanks,

Bart.
