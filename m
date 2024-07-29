Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB3578274
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jul 2024 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722222621; cv=none; b=nX5Hl/L3GsNHHtkl3wveatIFK2lhig6s+e3FfHn+jnVGOoxsnn9SeZZ1j+0Niqwv8Ttbztx5ChVHoOmQxptk+iwqPIQAVixOfjDjtfVfDp0Wg7Q33FWMOz9L1Tyw41lU2olK96jWp8Xuzxy+F1+J7HaqHHtrIpJ/nR6olVUzhLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722222621; c=relaxed/simple;
	bh=X3YvbGPnHmqXyyOIY9rCiM8z7Uo7y72bsX1HdMSJpL8=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=f2FiTcCgQ0QDLL/VW+NG7JUerF5up54E3erZFg7yAyfo/3TKfB58D4lTK2JJGmw2uQBf74r3QZ6iCaRSGIkyHkZqBPbdAQAtGJ+qZGZYOE5py5kTfiDMR6TtljGaWS5pp5pNCDFgxkopAL2UYY+s6Trx/3Nnnnfpe6xCxOVSrKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=h0PhiXvU; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="h0PhiXvU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1722222614;
	bh=naoDqaH5msGJgfAa3hIh/5ZvCgnlCMWfaGHi+flv0rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0PhiXvUBstcqTzX2X4MjIryFEI6GmkqIlS6S0csOtJiYrxni1OnU7nH9MvAIEe4D
	 +1+gUPCojqhfvgkcZTJX0pp2NX15WusV26nmzOhs7FoYIvSO3m84FLcKU9z7B5EzO/
	 1cLNniZr9VpUT3GZsBdDI6MFz5PPOFnTl7Rx9Wfs=
Received: from xp-virtual-machine.. ([111.48.58.13])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id E35B7037; Mon, 29 Jul 2024 10:56:53 +0800
X-QQ-mid: xmsmtpt1722221813tyvowzq7m
Message-ID: <tencent_8B6286FB808A0A72D3ABF0E4796ECB152505@qq.com>
X-QQ-XMAILINFO: N3wmAMAZ1e8MpZ0J1FOpUWkaVRlnNRg8xAWsxyAoJlxWgE9NlTwgaPGHh+WGKu
	 RzuSmTyMWoGbN4FVP7im5aUTWDmvlW1C+ND/Fce5l3vCLoWg7RyndsLuvLysBqANTmol95TwJ3+M
	 qS4IHlJCQQlOZtoD0oTrtvUTvEetgEwC6bu+4gmJRNtHFcpuJII5nfu0mIPrk7LxQkktYUymMveX
	 5wXz5SRmt2dv/pj2nenoPyfktx4YTSvURe9s4EHneuUm1AqkiU19/N+6hXiXO9rPFkjOEtJmc3qg
	 Gn+ZPqtCZ0CI98rybRVvwFfaW/HVPfiMggZFdJYNEJENOyG4hfyze8QDxZ3YVTlWbykKYNdkqf06
	 Um6OYR60xK2U9Rt0E+TRLmbHQ2HLwiKr+T2oCPMISRuHlOoqv/LNsPnO/V6oDFhXocT2kFRAxCRk
	 Wi9vHz1KVmvCBSq3YMXDoYV5+tZt3sQy6hPplnl/4d9AnAxaRsybo5MvaFJcc45qW2JCl+8X6TKh
	 wb9Sue2qnIclC+N/SDoJZbX3Qbcvkly12mdbSfdRgl0Ln6uUUZKc2XHHtHHWI/MYi5M/g3HY5zeE
	 /HGUx0AHvKVeoJ1VCiwEp4f/RA9bbM4e6qLr/sXjVzUwibeMfF4KVzfNru1+b+0uw+UkVehbTiTB
	 nKsn4+sX3jeRbVAuUOQK0iwkA5PKp8KP9/Ri8sulE1B/fk8Y6DmBB4XoK3YDQa3bJhEwAJaDbCT/
	 kN2SSnkYtyDgeWgS4b6IxlxMmntUly5rl6UaelEKNNLuiSGL8IhNRtk6AP5ZaJbbvVUP1yuyXMyx
	 tt8EfMbw03SEOA6kCui8lxZcMpI277R9XFgjfYx/jfuujd3V86yu/TxqzmmQcubXM4/RwRt7HmLQ
	 vHS4vwjGZaBj+UQUyn+1DuoDDf11PpUSX5yLauM35qRDjFlSa4egcXi/i6Y1wfjm0mAsW25Op8he
	 zODncJBsd+rf2GqOMCDoQ9V55j+iCN3CJKxxqrUPCjcgBveq2HjtrK7ncDHSnFJidNL82Q0ovELP
	 fwBm3F7YtZe9xAq45K3NiHA1SOgTnatqrzxNxprg==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
From: xiaopeitux@foxmail.com
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	xiaopei01@kylinos.cn,
	xiaopeitux@foxmail.com
Subject: Re: [PATCH] scsi: scsi_debug:Use min_t to replace min
Date: Mon, 29 Jul 2024 10:56:53 +0800
X-OQ-MSGID: <20240729025653.5974-1-xiaopeitux@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cbece1b3-08ff-4fcf-8ed3-71dab06aafaf@acm.org>
References: <cbece1b3-08ff-4fcf-8ed3-71dab06aafaf@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I am referring to this commit for my modifications: eb3b214c37ed.
Meanwhile,in the same function (resp_get_stream_status) where I made the modifications, 
have already used min_t(u32, alloc_len, sizeof(arr)),
but it's not used in another place, which looks awkward.
--
Thanks.

Pei Xiao


No virus found
		Checked by Hillstone Network AntiVirus

