Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CB2156F3B
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152593; cv=none; b=BB4B/NLYZd0UZogJc2bpB+0PPwN+XmXWxtxhkyeYdrHkgKuLzzWvvaRiov0su5Ow7dZg0D1GYMuQngALdyTUrOwuZaLipt77nz72NHMsw7W9SfdkEZGz8tcD3dkSFaFBibCbV4OGOymCf0d3+vcEzy68CotVoJ3fPknQ+0JeqXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152593; c=relaxed/simple;
	bh=7mStks36RWqI3qkwa9T/IeoxhBPwl6wnLq4xYtaNlVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=OFDmVNtiF2gx0bP0Qnnhj6oHHsRpz2PHByOA+WMrAevafhozoPbCZabGDbCA0gzlf18aLesFh/N2bF04sDRItEmfk6UbO7copv1GaFBvxPC1+P2/JHSflssdI/Z7ybUkxUzStjdwNbOZle65v+cMztiyGdyC3GevoxGiIayuO+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kizKn1jT; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kizKn1jT"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240531104949epoutp0296b38ccaf836257e3a853a367357651f~UjS7GIaNm2291222912epoutp02h
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240531104949epoutp0296b38ccaf836257e3a853a367357651f~UjS7GIaNm2291222912epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717152590;
	bh=uHe4lHWKM8hrsGb57PeAvfZQzle5G0HXraBJlb7Eicw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kizKn1jThcxeUO0KXrJeA5BCN1ay/4ZBkjQB2fv4m5yjM5iggPmkpUIJLmHneFe5N
	 a/fY/OWCfslBzKjm2yVDg08bqkqzbHn/SzmDe2PQXwFaWdxpY2dtZF0FpoF37FDq/L
	 hlNq8zlfNT9CgZL5KdOVY6I3yEjDUghE7VSoJN5U=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240531104949epcas2p3dc1dc2bec8419dd1bbce0e5129b5b7a1~UjS6f20Sm1766317663epcas2p3D;
	Fri, 31 May 2024 10:49:49 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VrKd83Sk9z4x9Q0; Fri, 31 May
	2024 10:49:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	7B.DC.09806.C4BA9566; Fri, 31 May 2024 19:49:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104948epcas2p1a70f31cd4a1aa5d36267b4187d75056b~UjS5Wu4tl1681016810epcas2p14;
	Fri, 31 May 2024 10:49:48 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240531104948epsmtrp22765271c56525eaa6a287314494c588e~UjS5V9eGO3112831128epsmtrp21;
	Fri, 31 May 2024 10:49:48 +0000 (GMT)
X-AuditID: b6c32a47-c6bff7000000264e-23-6659ab4c7e3b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	45.F1.18846.B4BA9566; Fri, 31 May 2024 19:49:48 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epsmtip1c63e4851994ea32a017f917a98adb709~UjS5JYUt-0934709347epsmtip1M;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im
	<minwoo.im@samsung.com>, gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH 3/3] ufs: mcq: Prevent no I/O queue case for MCQ
Date: Fri, 31 May 2024 19:38:21 +0900
Message-Id: <20240531103821.1583934-4-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531103821.1583934-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHJsWRmVeSWpSXmKPExsWy7bCmma7P6sg0g57J0hYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxsZ/D4v7Wa4wWl3fNYbPovr6DzWL58X9MFs9OH2B24PK4fMXbY9qkU2we
	H5/eYvHo27KK0ePzJjmP9gPdTAFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0
	ihNzi0vz0vXyUkusDA0MjEyBChOyM25N3sRU0MRZ8ePFLKYGxlXsXYycHBICJhJ9dy+xdjFy
	cQgJ7GCU6OluZ4FwPjFKHO5pZYJzVk98yAjT8mvTTKiWnYwSG2fPYoRwfjNKXF/6kwmkik1A
	XaJh6isWEFtEoFpic/tfNpAiZoE+Jon22fNZQRLCAg4Sp94tZwaxWQRUJRbevwTWwCtgIzFt
	z3kWiHXyEvsPngWr4RSwlWj5f5INokZQ4uTMJ2A1zEA1zVtnM4MskBD4yi6xfe1cqGYXiWct
	25ghbGGJV8e3QL0tJfH53V42CLtc4uebSVC/VUgcnHUbKM4BZNtLXHueAmIyC2hKrN+lDxFV
	ljhyC2orn0TH4b/sEGFeiY42IYgZyhIfDx2C2ikpsfzSa6g9HhIrb06Bhu4ERon5S44wTWBU
	mIXkmVlInpmFsHgBI/MqRrHUguLc9NRiowJjeAwn5+duYgQnVC33HYwz3n7QO8TIxMF4iFGC
	g1lJhPdXekSaEG9KYmVValF+fFFpTmrxIUZTYFBPZJYSTc4HpvS8knhDE0sDEzMzQ3MjUwNz
	JXHee61zU4QE0hNLUrNTUwtSi2D6mDg4pRqYzEScfym+/PpV7HdAVPc1toZl9xwan7wumHfq
	U0G3kcUyNhaBW/88t1YV/v9+6YTygpVzbY3+9lk7THZdf96if97r/QJH6lKFD+3I5nD69bzK
	IHEC1/otwb8u2/Tf+HhtxdOQ+GaWqD4Loz6Z27Yce2+oPqiV/xBz0vxFzIqUp5FKlhHdai+F
	wsOWrhEya11yl5lP2ZY17a7YAt3Tqww5fQRXBEvKyl3/LtrRYXsmo50t387Cck7Z+iV7mH5n
	Mmg+aj2+LjFRPLRFdP6fbb+/RvWpvbx+Jflb9oLi0pLD1zyzzRITXgVfepS7/vT639dVRCW7
	ZGM5721O0JFXOzc9XWjJ0sYVD3duTdh07Y2iEktxRqKhFnNRcSIA1n/f6jEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSnK7P6sg0gx8rGS0ezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgybk3exFTQxFnx48UspgbGVexd
	jJwcEgImEr82zWTtYuTiEBLYzihx8OB1NoiEpMS+0zdZIWxhifstR6CKfjJKrFn5igUkwSag
	LtEwFcIWEaiW2Nz+lw2kiFlgGpPEolkQ3cICDhKn3i1nBrFZBFQlFt6/BNbAK2AjMW3PeRaI
	DfIS+w+eBavhFLCVaPl/EuwKIaCa1ZdfQtULSpyc+QTMZgaqb946m3kCo8AsJKlZSFILGJlW
	MYqmFhTnpucmFxjqFSfmFpfmpesl5+duYgQHvVbQDsZl6//qHWJk4mA8xCjBwawkwvsrPSJN
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOK9yTmeKkEB6YklqdmpqQWoRTJaJg1OqgUmfseDuw9pl
	xhy885MYE6InrP/pqXBGOd5oh1nPz0+xBkovC1h4Lyj+FT3k71BzgTV5zws+iTu/XNmev2vL
	kKhICDdi0u/fpC72dm7u+oTrkj/PymhuFNqporXz/YmITZvdJE0P9lQy9G1OutZw6PMj564F
	Gayyi2UnheUVTDFnZDWtep9Rn+D7onheT2rb9uX9+1yatO4YRyp/4N4w64LIKalZHLNr4mVX
	rIuZ6t/qtTDFX2m9d4fMztdxETVb9k80E7jNu+K4mdbzaGH1sr0nJu3p/Oqu4LcmpmNKjpD5
	waLNrPePsWUGW3AZnD4ZE20rzX96T5/e9l13Wa/F7Iic6TsxetFTuaYAJ/GJSizFGYmGWsxF
	xYkArvWw5+kCAAA=
X-CMS-MailID: 20240531104948epcas2p1a70f31cd4a1aa5d36267b4187d75056b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104948epcas2p1a70f31cd4a1aa5d36267b4187d75056b
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
	<CGME20240531104948epcas2p1a70f31cd4a1aa5d36267b4187d75056b@epcas2p1.samsung.com>

If hba_maxq equals poll_queues, which means there are no I/O queues
(HCTX_TYPE_DEFAULT, HCTX_TYPE_READ), the very first hw queue will be
allocated as HCTX_TYPE_POLL and it will be used as the dev_cmd_queue.
In this case, device commands such as QUERY cannot be properly handled.

This patch prevents the initialization of MCQ when the number of I/O
queues is not set and only the number of POLL queues is set.

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 46faa54aea94..4bcae410c268 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -179,6 +179,15 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Device should support at least one I/O queue to handle device
+	 * commands via hba->dev_cmd_queue.
+	 */
+	if (hba_maxq == poll_queues) {
+		dev_err(hba->dev, "At least one non-poll queue required\n");
+		return -EOPNOTSUPP;
+	}
+
 	rem = hba_maxq;
 
 	if (rw_queues) {
-- 
2.34.1

