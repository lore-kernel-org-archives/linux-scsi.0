Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72B436BCC5
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2026 20:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773089900; cv=pass; b=rE2O0vki94p6BxvD5/diPXTrRvZCqEotPdRBQLBL5QV5SBMPTInMzryfm0aN1mJBGyTLNpumTyJXBqzpCHytTBLL7Cey0XqL3008URXjPEyue6PakC0+YmuMD+7HPTBnt6DLhS7rZVKVz6AZNr258Mcp265mi3pXt94g2yB2Ls4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773089900; c=relaxed/simple;
	bh=7Nx3Cw7fhz0+aqb922GT0NQjG1X+I+4vXUbpdmCn2ow=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sMjcdsy+FRVZ5qeWArfHxxEJieANCACNQ3WQWb5h0oUYXnR0KY3Yade+37wa5TgwcdtMfYJyu9kegCgPukLuIdgMW/Hyr8GlIuUPfIaIMjYjNL6ZS9CRvyBOg7vOmSjusY89vtdvMW9C+Hp1fP992FlUO/kNZ/dyuDgFQeY1LY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=h29/2D5l; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=BcJ8Lo+D; arc=pass smtp.client-ip=85.215.255.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="h29/2D5l";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="BcJ8Lo+D"
ARC-Seal: i=1; a=rsa-sha256; t=1773089708; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=WrDPGfhCW5CKAausfIbZaFqciSkxBRfUaJrb9+5ayTxzlnfgosQpXDJc7I94uGi5PY
    4yrxBq+/KZ2Q2eofSNtSAzqMjgF0u2Yo3IfQfCxaV4tg5SM1IDWW/k87ixIY7NGxX/Ew
    eTop0vPBt0rccP+PtmxQPZYI2edphEnkSKhaQDtn7vTsxve/jTmQDQaNFIBr87rAnULb
    zzgk4xB4u+gQjnUuktxfmZ8il/7jXpjBG42jOQTTGnWyYka/sHY7ZOJagbG5NQ4mDjya
    6dr4OCR+4xd9Yq3/B7ZLnWIs0ELtfp1A8TZnvVf9gOg5Y0VWEwAdaPwxpUu5dIStD4X9
    i7Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1773089708;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7Nx3Cw7fhz0+aqb922GT0NQjG1X+I+4vXUbpdmCn2ow=;
    b=J00ZCVALbW+cJpI4Nd4HPl0+yhlx8LXpkECJzPzu1RXcAC2RXGJDDrokLX0/8jkPnu
    xsv3eDIgqPOUUYgPDqP2Zi+iBGf2i7B6NYNu/oqIRHROq3qXNYSC+r0dWEvQnGP+urA8
    V4a9P5KQBQZEo+HAdcUKzkntf0SI+qMt5n2andvpuFzfddHxgMRnnn3/n5qta3lbYpZz
    gFGuj+HUI3xoc49jKBy7D9MfFH8Eg06KkXuNSKMWC1QlEk1GEdYKRrxDSLHcIH0HND95
    IZfAFrdFQWdlLMkiPSlEQ4ITjh/hfRrQCJZw5oCzwvPXZD5maz/3KU/l4tflS+MyFs7I
    a/uQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1773089708;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7Nx3Cw7fhz0+aqb922GT0NQjG1X+I+4vXUbpdmCn2ow=;
    b=h29/2D5lkhfCsljWrP4ZDjZL9JMODithj1AwlIMjaTD3tmf4Sjwz+ODzn0TwOHQTG6
    8B8ZsxXitQR60tVwCEAWHIx3SBzDa7jvDlTxiU0HHssMcCkAfaKKYTuOaTnN4m4WCFBJ
    fWvrhNnTP99Yk+fiZcyUWNJqYhJxYpekSD51PJ1VDnSB1BdAhUToxPmRNXsulC4NyX98
    0fvFNQv77uyCxD3fK0MXXg55w3ZQw36ZEm1Ezs5sRUXOIbBroGEuaANlAr6nKI0JYNzW
    dEe5YfQl2aQ+TW62Pmp3jY+fNJmPLx1v6S8hCIYW8so0CVMHro1rJVBMnTa7hvCX1wcn
    gh6A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1773089708;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=7Nx3Cw7fhz0+aqb922GT0NQjG1X+I+4vXUbpdmCn2ow=;
    b=BcJ8Lo+DNnaWplZrSR2p4QXT55Ajsl6/3f1kM7lJG8uRybnNxYuseYE/OQ+d3kVFxI
    p5eMyLp2k/BtwgzI2GAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeSpI62kIxisdG/F54xTsAbbcU0wg8oAdFfzsk="
Received: from p200300c5873271304473e57c291a2e43.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.0.1 AUTH)
    with ESMTPSA id z79345229Kt6PIH
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Mon, 9 Mar 2026 21:55:06 +0100 (CET)
Message-ID: <b893ad484f1a78430993320f2d451957453e2cf1.camel@iokpp.de>
Subject: Re: [PATCH v3] scsi: ufs: core: Fix SError in ufshcd_rtc_work()
 during UFS suspend
From: Bean Huo <beanhuo@iokpp.de>
To: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>, Alim Akhtar
 <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
 Assche <bvanassche@acm.org>, "Martin K . Petersen"
 <martin.petersen@oracle.com>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, wanghui33@xiaomi.com
Date: Mon, 09 Mar 2026 21:55:06 +0100
In-Reply-To: <20260307035128.3419687-1-wangshuaiwei1@xiaomi.com>
References: <20260306072647.2991132-1-wangshuaiwei1@xiaomi.com>
	 <20260307035128.3419687-1-wangshuaiwei1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-03-07 at 11:51 +0800, Wang Shuaiwei wrote:
> Fix this by moving cancel_delayed_work_sync() before the call to
> ufshcd_vops_suspend(hba, pm_op, PRE_CHANGE), ensuring the UFS RTC work is
> fully completed or cancelled at that point.
>=20
> Cc: Bean Huo <beanhuo@iokpp.de>
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Wang Shuaiwei <wangshuaiwei1@xiaomi.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>

