Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67149335082
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 10:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762858752; cv=none; b=g3UDgAUl6507vb0BpkamCtccvxkredAa9qmyzZ/LPs5K4JksNNu526qqesIJrfnzQtByrfHyVN6vn/gbMwRZys8EvIWICSktxGjFLmD4IOSp3L2CxAxlRLovOPwlGgikjOxM7FoFJLNn8uCQXvN3e74BBVpwZtnaMd+w0gAj73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762858752; c=relaxed/simple;
	bh=sYNfEoUS7sSDXQ8zdsFMzxBlnAiXPYxjwvlJPpw3Xak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/YZ3BqXoEg2CzQO3R+Yr11z5fmAE3VK/NzUehtiORGD2Mylah/sH07iSoG/JAtgXxLh8rSaBKmVk8YHEAZ/zVGkgFe19GTbS6wruvp8gKTK/1v6A6zVTOrqsZQP2TZZJoqD6vW/OWZq0tjLuKf1HKgyFi7+xTGckFbK8bC3+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=aBb0VnZr; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="aBb0VnZr"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=q9WDOKbzii3Ed0xLhN6nfr95InKHbM4RNlruNcRx91U=;
	b=aBb0VnZrJwye1q2GBied5SRy9K5tFzbKKFNrqTFkmFyT3XYfIzkF+vvHKd9h490NT3/A2xzHP
	V6PF0hhJE/PKcj2jeRDPEAYEDOVpbqPEdC2nEpUt3knGmxINFGOb9OSr+QDaMzOqtX4PFXsVonc
	N7awIMdp53t4RXbqMIUc6zA=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d5Nlp39S2z1cyQD;
	Tue, 11 Nov 2025 18:57:26 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id B00071A0188;
	Tue, 11 Nov 2025 18:59:05 +0800 (CST)
Received: from DESKTOP-4VUP2L6.china.huawei.com (10.174.187.123) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 18:59:04 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <bvanassche@acm.org>, <john.g.garry@oracle.com>, <hewenliang4@huawei.com>,
	<yangyun50@huawei.com>, <wuyifeng10@huawei.com>
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum value
Date: Tue, 11 Nov 2025 18:59:02 +0800
Message-ID: <20251111105902.277-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.43.0.windows.1
In-Reply-To: <da25e95c-8895-4a0b-ad7d-9f88f58a91e0@oracle.com>
References: <da25e95c-8895-4a0b-ad7d-9f88f58a91e0@oracle.com>
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

> I don't think that you can always expect successful aborting.=0D
If scsi_debug has been load, and scsi device id is "3:0:0:0", then we can=0D
inject io-timeout:=0D
    echo '0 -1 0x2a' > /sys/kernel/debug/scsi_debug/3:0:0:0/error=0D
First dispatched WRITE-command will be timeout, after timeout scsi middle=0D
layer will abort this command. This abort-operation will success.=0D
IF we want make it fail, we can inject abort-fail: =0D
    echo '3 -1 0x2a' > /sys/kernel/debug/scsi_debug/3:0:0:0/error=0D
So we can control the result of abort-opation.=0D
> Which modifications are you specifically referring to?=0D
This feature was able to achieve the expected results before you made any=0D
changes. Additionally, I didn't change your logic; I was just restoring thi=
s=0D
feature.=0D
=0D
