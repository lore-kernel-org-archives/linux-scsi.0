Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F040433B97B
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763032995; cv=none; b=crAfcjScgmFxuhS+IoKlpSKZEc5NY6NNdKraS2Q64gqHYOA0fL0B+MQ51h8jh5763UUORzGE3I9IPTEkc3rqYRMmJYRMNb1MS9sF7cLon5KLIkvRcHscEK59TDaRxQXeAhAFPaTC/ycg2VbZjB19qrLV3Bz7MCQzLoeNpEtj5rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763032995; c=relaxed/simple;
	bh=u7TKs2VTuTIiLfjFapRdkjlbd3F+l67KNWnJB7oH1Q8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QIR2mMvZEBCPN9TdsO9Gc10D5Jv7E2X83HCgxCMSKVcOS7IpfzPdTlVGWyLdLacmDADJEBx+ITh9XGdr4wQN6AVoWtTSq8Klsn9g173lHYd4u4qy//l+2n0JlQdyhzOnoywzAs6xct1oviaUvdsocHDHcT5IPFe6G1qbVdMf/Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=j6/nwZ/m; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="j6/nwZ/m"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=u7TKs2VTuTIiLfjFapRdkjlbd3F+l67KNWnJB7oH1Q8=;
	b=j6/nwZ/mcXoYR0RwzBmbKj+0M75FXmJsMxPhRSgIdA71juQaLvvPaGo8QfahdEu1n2dEJjiAX
	baC8ovIjJI3ZiI8LjV71wxcqsC4yeOhcAv2LvIZVVg1t/UnbgSQtI0qO7B7rwSqPwAFQMVCPzzW
	3UAoRlx0f0eo7R5vzdWAOBc=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d6dBS60Blz1cyNs;
	Thu, 13 Nov 2025 19:21:20 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 50FA81401F3;
	Thu, 13 Nov 2025 19:23:01 +0800 (CST)
Received: from DESKTOP-4VUP2L6.china.huawei.com (10.174.187.123) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Nov 2025 19:23:00 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Thu, 13 Nov 2025 19:22:58 +0800
Message-ID: <20251113112258.367-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <7b020e5f-3fca-48eb-bd20-cb0521120f5b@oracle.com>
References: <7b020e5f-3fca-48eb-bd20-cb0521120f5b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk500001.china.huawei.com (7.202.194.86)

> The concern which I mentioned before was that we would have competing =0D
> and potentially conflicting methods to trigger and handle errors.=0D
>=0D
> This specifically is a change from Bart to fix my code. However I added =
=0D
> the change to check the abort result.=0D
> =0D
> I think previously scsi_debug_abort() would just always report success, =
=0D
> even if scsi_debug_abort_cmnd() possibly fails, right?=0D
> =0D
> Now for a fake timeout, there seems to be a problem in =0D
> scsi_debug_stop_cmnd() that we abort depending on the deferred type, but =
=0D
> this is not set for any fake timeout. Or - more specifically - it is not =
=0D
> reset for when the scmd is recycled. I think that we should just allow =0D
> the abort to be successful for that case.=0D
=0D
I think your design is rational.=0D
=0D
I think the method of simulating timeout is rational because discard-comman=
d is=0D
equivalent to the queuecommand executing but returning a success status, wh=
ich=0D
is clearly not what this interface expects. It is also within expectation t=
hat=0D
such an unrational approach might conflict with subsequent changes.=0D
=0D
So, I tend to change the discard-command to setting a very much long delay =
for=0D
schedule.=0D
=0D
