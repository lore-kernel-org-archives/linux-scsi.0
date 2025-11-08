Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD9027CB02
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762590613; cv=none; b=nA5xl/30jBZumjdPUF3Wc5cOjMaS03AYFtl7CiOKqv1JHqBdSVPUymxAhq1EJiV5AkBwuiB9iLa4W/aJVFTj2czPrRDcZ+d4NKSyOWMeotCojW55pCeZlc/QvMoeh3NZMPq8GvaULeo/WwD/2L87G0eUqqTANSnO8Du4kZ5D+qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762590613; c=relaxed/simple;
	bh=lTzV9kwsQweK/tM7f+TUsFXPDcPiecB1qGXFeY6vtEQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ErOlFSaklFrCr3fzoN5n3Iub1K1F6Q3Kz0sP+Wqgo4EV52LR2aBocfGEx0Bs+sl7M3HjMhQAyRU8GudRudLEYJQ2Nkzn05jgRmtw1btQOVOk1oKUz48Z6uVVYCBIBKfWrrfPXq9rik+Md+VMT9svHKas87SOAPkrd5vIqQ0/n5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=JfiHnMSh; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="JfiHnMSh"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lTzV9kwsQweK/tM7f+TUsFXPDcPiecB1qGXFeY6vtEQ=;
	b=JfiHnMShxcDBEzmXIEI4eU7J9SOqY5oXbWTyv/ZpJ4/DWikseVrY1ew5mozMBRTFPrJR8qu7N
	EW5a1hp0m1kp/ky70HIcvbvNZ+/UOaIET8JfWos9dTt4fd51otVrM/mosXymI9hAJWpEkWLB1JM
	62gt+y9At+TDfBa3zYITYBg=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4d3Tb93r4nzcb4C;
	Sat,  8 Nov 2025 16:28:21 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 951CB180B73;
	Sat,  8 Nov 2025 16:30:03 +0800 (CST)
Received: from DESKTOP-4VUP2L6.china.huawei.com (10.174.187.123) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 8 Nov 2025 16:30:02 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Sat, 8 Nov 2025 16:29:59 +0800
Message-ID: <20251108082959.1831-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <8d4247f6-2772-4f2e-aef7-32c1b0dc8091@oracle.com>
References: <8d4247f6-2772-4f2e-aef7-32c1b0dc8091@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

> When we get discard the command, we get a timeout, and the scsi error =0D
> handling kicks in eventually. The first thing that the scsi error =0D
> handler tries to do is abort the command. All that the scsi_debug abort =
=0D
> handler can do is ensure that we no longer have a reference to the =0D
> scsi_command, which may mean cancelling any pending completion (if =0D
> possible). Is your problem that sometimes the abort handler may fail, =0D
> and we have to escalate?=0D
What I mean is, in fault injection, we need to set a timeout, and then we e=
xpect a successful aborting. On the other hand, we can make a failed aborti=
ng by injecting-fault.=0D
Before your modifications, the above objectives were achievable. The purpos=
e of my current modification is also to restore the previous functionality.=
