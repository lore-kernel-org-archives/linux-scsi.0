Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B611CA84
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 20:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752871746; cv=none; b=Cx2lDyl63qAQMyCDIkpmoSUoOSh6snEjEUgp7c6J1Zdxt4wEq3C8gazcSrvY8499fWVL7PQhC+D/I5hy91Qf71m6U8vW0LVsMr6J5YZ/XGwGcDYIK+zdSXasHGI9h9/iY3FcQROyHR5arfbTkw3TeSXH0ArQmSMdeCMbidHd/tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752871746; c=relaxed/simple;
	bh=ywfnmPDbJaGdqsPkk2OCswGoEZF/NYJjWd76VuRdvNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OnTCRlnVwMOLaO9GhJOhz96tDW88bStxDz8ZWTqL7aBI1s4NRclkZQraYAhj3aRNGefg1wiyYRZes/Pt+lofTnUSkH0/ht6GTFO4rftZI+vSq1mt2jxzH4JJByAq2QrgsUYzWfjxpeU1O5bXvj9/mOAWyootjpmBuXg0ETJZ1RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jHAszgtN; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jHAszgtN"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkMMz3FrTzm174H;
	Fri, 18 Jul 2025 20:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752871742; x=1755463743; bh=xw0uKMT0iiOWrBiS0giYR+zb
	xWP8VE2hyOSweEDb1GM=; b=jHAszgtN7pUb7sTkudL2IGtyrWSlCUy+Mm2U85BL
	pcqWGvYtN5/68C8S1LO7G/5F6i+EUhLlXl71FIsXpEjeGZ86MQ3IQn7A27hMWxCa
	R/36DgFBmxBLJjKM4zOhg7CnHURERBWQ7XBrEvMK35TMpEmQxfUDwP5eiNK9i1BN
	1nRUTjU20X+3C69uPKjCPcrrs/XM4zRQP0BqsNw8xn8bq+/+Oyu1U3N4nsSQeyTl
	QBQNP8Y02jr/IUSekIB8LmyAYN/r94MFTyzLqwO/qeH7Cg+IaKZX6h2S6LJjmCTE
	myxWvyqh1ypU6HdzZHr/nblu+bzBSHiafYVrUZBogbAZxQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PlK7auImWnyJ; Fri, 18 Jul 2025 20:49:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkMMs6G9wzm174Y;
	Fri, 18 Jul 2025 20:48:56 +0000 (UTC)
Message-ID: <e2cbc581-55cb-4918-9a66-9d04cb1f5211@acm.org>
Date: Fri, 18 Jul 2025 13:48:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
To: Seunghui Lee <sh043.lee@samsung.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 sdriver.sec@samsung.com
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
 <20250717081213.6811-1-sh043.lee@samsung.com>
 <2743ce40-72fa-4c87-a2cc-528b51418aec@acm.org>
 <000401dbf7b1$81b61ef0$85225cd0$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000401dbf7b1$81b61ef0$85225cd0$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/25 11:59 PM, Seunghui Lee wrote:
> I've checked multiple calls to ufshcd_uic_pwr_ctrl().
> I think that follow cases looks okay.
> (using rpm get/put, init sequence, synchronize with PM operation sequence)
> Do you have any better idea to cover this issue?
> 
> 1. ufshcd_send_bsg_uic_cmd()
> ufs_bsg_request()	// using rpm get sync, put
> 
> 2. __ufshcd_wl_suspend() / __ufshcd_wl_resume()	// runtime sequence
> 
> 3. ufshcd_change_pwr_mode()
> ufshcd_dme_get_attr()
> 	ufshcd_get_max_pwr_mode() from ufshcd_device_init()	// init
> 	ufshcd_disable_tx_lcc() from ufshcd_link_startup()	// init
> 	ufshcd_is_pwr_mode_restore_needed() from ufshcd_err_handler()	// using rpm get sync, put
> 	ufshcd_quirk_tune_host_pa_tactivate()	// init
> 	ufshcd_quirk_override_pa_h8time()		// init
> ufshcd_config_pwr_mode()
> 	ufschd_scale_gear()	// synchronize with __ufshcd_wl_resume() / __ufshcd_wl_suspend()
> 	ufschd_err_handler()	// using rpm get sync, put
> 	ufshcd_post_device_init()	// init
> 

Hi Seunghui,

Thank you for this summary. The call I was most concerned about is the
call from ufschd_scale_gear(). You are right that these calls are
already serialized against runtime power management. In other words, I'm
now fine with this patch.

Thanks,

Bart.
