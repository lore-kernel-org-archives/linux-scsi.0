Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3127B23E324
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 17:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=81.169.146.217
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792346272; cv=pass; b=TSYivWJnyuSvM38rfSHHPlvrG6paRgp+OBGG2r9ACq8sW1Ar/7Uh02YhTcX4Nu0BCFCMhlXWp/yvpO/uGTN3UhzhloD7WiGX3Ea3Q6xR8opZ5Dc8Co8FTmJ9dRe+Ei3JuMtwkqPJDsrWF75h+F1/aXH2t54uf15dYDUkL5TzICE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792346272; c=relaxed/simple;
	bh=/konr65BUaCFfTUmlxs8nhcJcf/UycQGHWBgOSx7KSw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fx8ANI37fKv7zupItHXJG/26t38wM4+5KsXGqD9cXoSOt+sjReLOj9QBPkdJnr1IYMaD0PxnxyhPOAX6Hcd4sGfQ0jFZkDkLNncmXg2hCVX1s44pRY+UrCoTRfqifY67mFIjkszU1rr/V0+llUi+WIKq3QyT0WMFcdvfUpwicAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de; spf=none smtp.mailfrom=iokpp.de; dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=Z7dzhef9; dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b=icQieSAU; arc=pass smtp.client-ip=81.169.146.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iokpp.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=iokpp.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="Z7dzhef9";
	dkim=permerror (0-bit key) header.d=iokpp.de header.i=@iokpp.de header.b="icQieSAU"
ARC-Seal: i=1; a=rsa-sha256; t=1792346261; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OmxENQgWADPCeP+uciPQlxA/ZK7LDbr6jxz/DixYrvw15G5VQbrKwX1cPjGsU1Zj1z
    NiPbetQ0fv0WYZ4FFOJ8+SjJ7kDlFF07s+uJ1PW7reRbC/2uRYJ1gdfsPnhSZkSdpL6x
    pWTzaozf/WLdnrI53Z5Qtp3p/HbIS1veMqIsM8v6AoV598aUJPvA0k2VQRUM5xpRsNeK
    LMyxwoHeiqL25WyjCnw6zU/+6E8lf+MaxycT6sas6FK54+DCtrcUOYE1LMhofwsWNhGM
    ZP7m6bFoFQnX+69WjRP/Y6IANESZXYNDAKZSVP1L4rob1PH3MDvc05FrQ1KHBEjpjC3f
    8JxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1792346261;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/konr65BUaCFfTUmlxs8nhcJcf/UycQGHWBgOSx7KSw=;
    b=OD+BUJGvaJzZH8jhwqdudygYf3Qr+keX0deCfietNEkx57Ev0DI+Sj8U1+Ypim9wCd
    M2D2UEdMt5veY1DmrOo7uPULpXPxH9f6Q1uaPC6qmfQGjStSksJlGrY3OuWVTHXyMPvM
    Z8llm0MM0Uxyja/dUJDzcNuP/s9+sbPYG1KmH0kNtvlIBhdMSNJA3aBM5EJk14GQsnNB
    mxcSjtJPcj47VX2ad328GM4LQVFsSthPfjIOZGPBECqVEuuEqgmNFMQBPgpby2IHcFfl
    xalDGkqHugbPaLgRWBvC6B1+Yi+ohpGSFEc/jYoq6AQLdop9pBOx+Ar56PGpvpC/LOYy
    TiWw==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1792346261;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/konr65BUaCFfTUmlxs8nhcJcf/UycQGHWBgOSx7KSw=;
    b=Z7dzhef936ewGSZMUrn17av5Nvqy7NrlHpP4yjGfqHQYUNw8b/fVWcH0m7WAR1i7+3
    tgNiYr8A0sgHk6AjibkRHkqxZRS3ze90ebXMDBQzzZ6Y1ok8u2TALXNtIgZxngxSiRtJ
    RRrpZOstdeWxOF/sjVQo0Bc5DT/CU36ogh1Z2r3qR9sfE6aKEsrswVKZJVIJhNrsntB3
    yMgyysHcONHmaOekbQt8nJ3oJZEkUNRB4hocsoN81+MJ29COK3tiWbRis3x+t2Q1+1/z
    nEvc32NABo+gwPgW0YGm6nNvnRA2gMIQ3rl+83/VaoddWQHkg27NyunJc9BcNGrd+Lb4
    wB4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1792346261;
    s=strato-dkim-0003; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/konr65BUaCFfTUmlxs8nhcJcf/UycQGHWBgOSx7KSw=;
    b=icQieSAUU3n/EJJEyB9AJEsr72M1dHwyQq8+L+Wb9n8LTrUOg6W1+KjhA1djdCW+DR
    DzIBpqNIhPF/G1PKERAQ==
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSe9tgBDSDt0V0zNriHg+YfT0rGeWpIGzZge/Z0bJo/ZKBs7IP24cD2xnjN93xVc="
Received: from p200300c5873684d949ea70d47c97a062.dip0.t-ipconnect.de
    by smtp.strato.de (RZmta 55.6.3 AUTH)
    with ESMTPSA id z831ad29IHveHHR
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Sun, 18 Oct 2026 19:57:40 +0200 (CEST)
Message-ID: <8cd5e3da3afeea23d6b5714beea3420cf0f6a794.camel@iokpp.de>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix stale comment in
 ufshcd_mcq_config_nr_queues()
From: Bean Huo <beanhuo@iokpp.de>
To: Shawn Lin <shawn.lin@rock-chips.com>, "James E . J . Bottomley"
	 <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Stanley Jhu
 <stanleyjhu@google.com>,  linux-scsi@vger.kernel.org
Date: Sun, 18 Oct 2026 19:57:40 +0200
In-Reply-To: <1792200069-141213-1-git-send-email-shawn.lin@rock-chips.com>
References: <1792200069-141213-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sat, 2026-10-17 at 09:21 +0800, Shawn Lin wrote:
> The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
> has such a member (it was removed when the dedicated hwq for device
> commands was dropped). Reorder it to describe the actual requirement:

it is not "reorder", it is "reword"?

> the queue is a host controller capability and it serves both non-polled
> SCSI commands and UFS device management commands.
>=20
> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>

Reviewed-by: Bean Huo <beanhuo@micron.com>
