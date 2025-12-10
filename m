Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834892EC56D
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348748; cv=none; b=pXhjRBYLsCux9svX9LAm4g/MktFdlDT8ZHnKaOjpJf4ixJetgKMySkoYbB1deEj5M91faPDkBjiM9cogcT68XaV3bkDBGRA67HQhSviJUNeGs/VGNTB6Je51NSHZxRrLwqc+MLpCDYloGxmAKoL5MZhfo4fpFw20g00tQ7zxpFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348748; c=relaxed/simple;
	bh=ccLwWU5ITaOH+kNNsuC+H/BQ9YGPw6HqbTJ5cvJz9/g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 References; b=G7P7G8KG7F/MXerEFfg3L47zaI7glw8xYL4HFFnyCkBXZUWqLOosysD8JUmh4+34bzf1K+MCMAjg4dG5OeoeVcxFLElQ+m6zJDBfA79oz5e9DPgYMoNrazn7/iqBqTpr6n4YsvVn5Pqb1v6phx59ZDK6myV1dzKHfMbRO06nqKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gQV8bQmI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gQV8bQmI"
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251210063902epoutp047176058d506540f384e58b3230044029~-x1P1Nn0G1158611586epoutp04i
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 06:39:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251210063902epoutp047176058d506540f384e58b3230044029~-x1P1Nn0G1158611586epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1765348742;
	bh=i8KuVC8C0CfDnwvTQyw9DvO8qy7Uv6L4ynZJD7L/NqE=;
	h=From:To:Subject:Date:References:From;
	b=gQV8bQmIgUVodZlh1M8Jcq4cOpK8GxewzvS873yaGu6vG/ohX0flcLEaZTpGBAt+5
	 Gk6fV2NzqiUYy7nl/u3tHodU+SwZ/XZWWw9GMaXfg+im9HQw5DbKYuadgCaJq48k9i
	 ndhhsgJ+GA/BQORrjqV5ydZ0h958dRm9/Go0t+i8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPS id
	20251210063901epcas1p4032e8c924b06fed470ae126188d4024a~-x1PHPi1m1730117301epcas1p46;
	Wed, 10 Dec 2025 06:39:01 +0000 (GMT)
Received: from epcas1p1.samsung.com (unknown [182.195.38.119]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dR5fF3bxdz3hhT9; Wed, 10 Dec
	2025 06:39:01 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20251210063900epcas1p2d70b81b127dcf2435d2028fca70ba6af~-x1Oi3vld2571125711epcas1p2S;
	Wed, 10 Dec 2025 06:39:00 +0000 (GMT)
Received: from baek-500TGA-500SGA.. (unknown [10.253.99.239]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251210063900epsmtip26e8800f6c1606d4759ba6f84dd879448~-x1OczfGF0423904239epsmtip2p;
	Wed, 10 Dec 2025 06:39:00 +0000 (GMT)
From: Seunghwan Baek <sh8267.baek@samsung.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
	peter.wang@mediatek.com, beanhuo@micron.com, adrian.hunter@intel.com,
	quic_nguyenb@quicinc.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, sh8267.baek@samsung.com
Subject: [PATCH v1 0/1] Add code for ufs suspend error.
Date: Wed, 10 Dec 2025 15:38:53 +0900
Message-ID: <20251210063854.1483899-1-sh8267.baek@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251210063900epcas1p2d70b81b127dcf2435d2028fca70ba6af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251210063900epcas1p2d70b81b127dcf2435d2028fca70ba6af
References: <CGME20251210063900epcas1p2d70b81b127dcf2435d2028fca70ba6af@epcas1p2.samsung.com>

Add ufshcd_update_evt_hist to record ufs suspend error event history.

Seunghwan Baek (1):
  scsi: ufs : core: Add ufshcd_update_evt_hist for ufs suspend error.

 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.43.0

