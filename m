Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B23C465
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 23:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769210864; cv=none; b=Y/w2+6rjqzXT/oZ/hZI6W38rPAYrqV9+FL4iZ4EkjXplz+H6Z83KLSxl9F06qkz3oun4GA+6SZ1+NVDXmhw6QT5KNiJwuaghMm2n/JTXUyt9BV77zKN6SRYdEFXeXzetYeh0d1ck8tjnak3+vSsKlex+uLne4qK65HANP/a3YQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769210864; c=relaxed/simple;
	bh=0yHKi/SfehmI5ly8TqagPPXsMCPQmel79bFkf1Jnsi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZsoFc/9Re50SjzE6CxJnQp3DZh5K5fKXTRR4k8sDcHzAQ1fvJ1OVzOifl8EJQ3pzWyNGhCCXtt3Wv5xbMKy/Gs0XKqiy8ljmod+6WMYVZqyhB42t2o/pTYMrIO5mWYEMsuQQ1n7W14dhIP2PSOqZghcWOhB3J3Yo6cFNtL6J8nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1XHY/Yoh; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1XHY/Yoh"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dyYxp1pLbzlh1Wk;
	Fri, 23 Jan 2026 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769210860; x=1771802861; bh=FKwgNZ6SWyfqJruujQPeeiUM
	ncRRGjM9EzlbcysISnk=; b=1XHY/YohmOU6E5EyteAjxaUgA/Bocor92tgH3LcZ
	zOyaZCtZBjzLY5PdCTLtUo0tkoUKuYnTEY4ozXKpGj1Oz2J8mGas6RGlUP3h8ika
	5VpP8b2/VZrYdJ0JldZdKhh7LWB76FHzB2SsEZIMP9LqjrX+3O0cp/EYqd7aGebG
	CAnPUGXrQxdz4I9REsRmMRDvWYNBTbNwMI9c3rp1UJACs+CEQPX7DGGXs0x1iVMm
	0nXrjnvnMLN0GwjTXmRqBOWYZHNCBmAugyp2UxoU9Xm5fAhRh41hgx0upWl9NIRo
	MyEzMcb1uA4OkBUFGeoqdk7TLpOqGdSWLpHA8kEj+5s84w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6d2165tTgt4S; Fri, 23 Jan 2026 23:27:40 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dyYxl3lm2zlgyFw;
	Fri, 23 Jan 2026 23:27:39 +0000 (UTC)
Message-ID: <1ebc9a1e-c36e-4d9b-a695-a6153a32e0c0@acm.org>
Date: Fri, 23 Jan 2026 15:27:38 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] ufs: Remove the clock gating code
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "mani@kernel.org" <mani@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20260116182628.3255116-1-bvanassche@acm.org>
 <r3upegmcqg5fxo22u63dwtwrlc7qpwi57drlvujtw4jkbinx7f@xluie2klyr55>
 <cb72534c1eac0740e24eed7ca4207371f55bb273.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cb72534c1eac0740e24eed7ca4207371f55bb273.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/22/26 11:26 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> 	hba->rpm_lvl =3D ufs_get_desired_pm_lvl_for_dev_link_state(
> 						UFS_SLEEP_PWR_MODE,
> 						UIC_LINK_HIBERN8_STATE
>
> The default RPM level is different from clock gating,
> so it should not duplicate the behavior.
>=20
> RPM also sets the device to sleep mode and powers off unnecessary
> voltages,
> whereas clock gating only controls the clock on/off state and
> hibernation maybe.

My conclusion from the above is that RPM has the advantage over clock=20
gating, namely that it switches to a lower power state.

> There=E2=80=99s also another situation regarding whether auto-hibern8 i=
s
> enabled.
> If auto-hibern8 is not enabled, manual hibern8 will be triggered along
> with clock gating. If the clock gating removed, the impact should be
> even greater.
Are there any UFS host controllers used in mobile devices that do not
support auto-hibernation? If so, how about adding clock gating support
in the runtime suspend and resume code? For my own reference: this
involves calling ufshcd_setup_clocks().

Thanks,

Bart.
