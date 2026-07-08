Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA63F410E
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 07:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783495427; cv=none; b=E7A6eauNNv1y/WYsltjNWujns+km4AbLzRsB0bioUYtI+llLVPRgB7vGFSWAqUdKwRx4x4K2/gZ60JARi2so60bPw8H8hKyZrSUWk71VRQlWqrI8MjCwqtYV01+PFmKoS0dhhZyBn2CeZAMQdAlHfAMo14j5Y5emXEfgcwmv/As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783495427; c=relaxed/simple;
	bh=tmNahjfoNoaAyHErBXtSPhq9R392O945ucHcRR+4bNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BBL2OBqyMbpPsJMRLAmra9QDPc/B3RRI/+iNPTKGjFAVdH0dEd5nnd3aIVVehoAzdW42yVVpLZk2rfxbGV/p3Oqg9G6XK1qPJD0HghGOAX6/XlGFGdHHIcyvWBjYzROrbFOPQJZX7nMDgq4rfHfppXpbrBg7USD/gZiNmldHi68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RQA3pUgZ; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RQA3pUgZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=tmNahjfoNoaAyHErBXtSPhq9R392O945ucHcRR+4bNY=;
	b=RQA3pUgZdpEdf+tck1xQ/7+cXLHM5NjhqZ8nsPNaK+1U1XHiX+vfIEZNbX/1Px
	a4F8cUuTdQcqIHmv8qj67r6GDKlDVQNMWq1v0RsSh4mr4JiOyTs7vpsy68SvQ+O2
	eWoCXuKI38cnIxAvYEfN9m7Rtya0OSPnJWglJZawWAaDo=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgB33inM+k1qRWDqGA--.62464S2;
	Wed, 08 Jul 2026 15:22:53 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: john.g.garry@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: Re: [PATCH v2 1/3] scsi: sd: fix error handling in sd_probe() after large pool creation failure
Date: Wed,  8 Jul 2026 15:22:49 +0800
Message-Id: <20260708072249.264705-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <26757492-f9e0-49bf-bc77-4a6f3ae64276@oracle.com>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn> <20260707030333.22245-2-yangxiuwei@kylinos.cn> <26757492-f9e0-49bf-bc77-4a6f3ae64276@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgB33inM+k1qRWDqGA--.62464S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrCw4rGr1xKr18KFykWF13CFg_yoWxXrcEkw
	s3K3ykZw1agrsrWF1UAF4Yvrs5GFZ3urWqgrW5ur13tryDJ3y3WF4vk34fAw18tan7WFnx
	Aw4DXrW7Cry5WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjT5l7UUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6g7fcGpN+s5ZwgAA3D

Hi John,

On Wed, 08 Jul 2026, John Garry wrote:
> However, would it be simpler to always create this pool for LBS enabled
> (and not just when we probe some disk which has sector size > PAGE_SIZE)?

Yeah — same idea as sd_page_pool at init. sd_probe already has quite a
few error paths; I had a go at consolidating them in v1 but dropped it.
Moving the pool to init seems like a cleaner approach.

> On another topic, sd_large_page_pool_users does not need to be atomic as
> it is always read/written under the mutex (so can be a regular int).

Agreed on the atomic; an init-time pool would drop the users counter as
well.

Thanks,
Yang Xiuwei

