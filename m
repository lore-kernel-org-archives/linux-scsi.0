Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9EF2C324C
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 20:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758315458; cv=none; b=CpPjSt9CGCL/kXX9cg9X8fcCyKH+PpGXZZGNKpONmqdNO31i4usd4sIORKElvPZ34vhyAxKqyhiLnIgCQCPqLluQWVEbaRD9xb5H3v5VhpioU4xdFuD8PxmfdB5xSFZxeLkhu3G23VkFTl1wjXbkxXwCpgX1v7mYfjIVvURRyIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758315458; c=relaxed/simple;
	bh=075ADIsmLahIbmAw7/wnG2nMH1uc7KsthP948Epyzug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jhEwDbW+2vbfvUtWrvTyWw5WTC6hgGrU4+vdaTVVnl1ywZT7vVrbIeddsZNXVkFEY7hm/kpJbdMLDSI6hdYijWYM6O9nnzfOTWLma0ZDKOC2N/Dq5Dhyhbno0fe8cn17grIQmoT+lto1u70TVzHEvkGjP+HQBRg5YVn+niDFzjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pebarhp0; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pebarhp0"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cT4Zl2Mtczlmm7p;
	Fri, 19 Sep 2025 20:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758315452; x=1760907453; bh=o9ku7JZxIEtLSd3q0U+dBteb
	+15Ur+wK9Hg4iSg4GiQ=; b=pebarhp07tHaXV7iah8FS+Dphi+FoWMxJvjTpYd6
	nEuyDmjDkZ6Q/sEedBsooJ6ynVliwSTuME+I8jMv+XohIiVUT7g7s+VQCnitjAEt
	OKcy1TfWmPCtl8lJ1Xho7vyJkSGZ+rs2sngYLo2GjPsggZkcZas9awQQww6MKCRf
	SRI7+WkKIfeYaE6szqeEvq3NypFJcjI75HmsSyFLoUcuVvE2kCJtJt0pbdktS9cU
	BHtGfVzmeYFvwf326T3/gpTRpzjEcHTxx6mlKE7leRaOcT0KEey1v3WFk5nuApHT
	YQrzfiBkxzMrCbrXg+UvMsxRJO53wGl0ZcGB3dp3c0ix2g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BlR3mNq9qd8M; Fri, 19 Sep 2025 20:57:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cT4ZS2SZ2zlgqW0;
	Fri, 19 Sep 2025 20:57:19 +0000 (UTC)
Message-ID: <bc612c10-a4eb-41ab-b8e5-726d22935518@acm.org>
Date: Fri, 19 Sep 2025 13:57:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
 <Chun-hung.Wu@mediatek.com>, =?UTF-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
 <Yi-fan.Peng@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-2-peter.wang@mediatek.com>
 <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
 <bdb6ee1402ae4c9ba8919011b1d8fcb9d984129f.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bdb6ee1402ae4c9ba8919011b1d8fcb9d984129f.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/19/25 1:11 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> An error occurred during the suspend process, causing IO to hang.
> This is because the error handler (eh) work is waiting for
> resume, while the suspend work is waiting for the error handler
> to finish before sending SSU.

If the suspend callback waits for error handling to finish and the
error handler waits until resuming has finished, isn't this an issue
that can occur for any UFS host controller and hence that should be
fixed in the UFSHCI driver core rather than in one host driver only?

Why is the hba->pm_op_in_progress variable not sufficient to prevent
this deadlock? Should this code perhaps be moved from
ufshcd_eh_host_reset_handler() into ufshcd_err_handler()?

	/*
	 * If runtime PM sent SSU and got a timeout, scsi_error_handler is
	 * stuck in this function waiting for flush_work(&hba->eh_work). And
	 * ufshcd_err_handler(eh_work) is stuck waiting for runtime PM. Do
	 * ufshcd_link_recovery instead of eh_work to prevent deadlock.
	 */
	if (hba->pm_op_in_progress) {
		if (ufshcd_link_recovery(hba))
			err =3D FAILED;

		return err;
	}

>> How can ufs_mtk_suspend() be called while the error handler is in
>> progress? ufshcd_err_handler() disables RPM before it sets the
>> UFSHCD_EH_IN_PROGRESS flag.
>=20
> This error is triggered by ufs_mtk_auto_hibern8_disable,
> As the comment description
> /* May trigger EH work without exiting hibern8 error */
> so it could happen during the suspend period.

That source code comment is confusing me, especially the "without
exiting hibern8 error" part. Do you really want to say that the device
is in a hibernation error state and remains in a hibernation error
state?

>> The UFSHCD_EH_IN_PROGRESS definition and also the
>> ufshcd_set_eh_in_progress() and ufshcd_clear_eh_in_progress()
>> definitions must remain in the UFS core private code. Please do not
>> move
>> these definitions into the include/ufs/ufshcd.h header file.
>=20
> Do you think we should check ufshcd_eh_in_progress in
> __ufshcd_wl_suspend? I'm not sure, because we don't see this
> error on all UFS hosts =E2=80=94 the vendor suspend operations
> (ufshcd_vops_suspend) could be different.

Why is auto-hibernation disabled during suspend? As far as I know the
UFSHCI standard allows to keep auto-hibernation enabled during suspend.

Thanks,

Bart.
