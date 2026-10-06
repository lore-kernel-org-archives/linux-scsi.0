Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC42547068
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 02:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254557; cv=none; b=uk+MWP95goJE3CZsId4kjOUjjduTRk/S/GqgNaMfWe0/4xwTYjZaGfz5Lk5c0El76/4Sw3TqUKKGJz2XqV4tCHPTE8tS/PLONvL6VxpZ0qftM3oBU/53dnrVU0HpZse1h4GbL2meyo3yNLEGztwSmRGEMVVJLVVWYv9eXJA6Tjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254557; c=relaxed/simple;
	bh=dxf5Shj84QO2jNXuUuiuhQRO+DUtHv6ODXr61vk8G5E=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=W+3Zt47Kjl9MUr7RvfoBGwmyVekRRh1gQ+F5W20wmIsOQ3ZoUIkoIFtCRoSqf9BmCjS1fXFypaociPqbn85TjRnw13PQUUuZyJTYkXex4SOS++oyJQQ8+JC8nrKNvNYTba22lM+QnL0qNqCRUuTawD7vzxznVrpX0S10U7s9IjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0BdGj6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0BdGj6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4A81F000FF;
	Tue,  6 Oct 2026 02:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254555;
	bh=UqSzphL/B2G51xbd5d08UxQzg64DGWrIWeuZEENfUTw=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=E0BdGj6aJh9tiWoTLbiFqMbcg5GEYafztt1so8p4/pLaVhu9HtF95zhrYK0qeSOgB
	 1uvahyvdMkunLGE60mo2AyEYGWY+kG7L6GL5iuxht4Z4lzzlDPkphaH7oAIkeENjM4
	 3O0f1pyu1SZzdXbcHKSfBAb/0pKg87DXuz9KmelH356Tzskmc/zQ1I8p7McKVLPThy
	 2hc+TRIyhCMROLMbLQCfRmtMfqJvkGxRvqb8JNZVmZpREEies96QPbw0vq2tGTV+Mo
	 LY52zBJhFnHo4/LXwc4Gn8BluKmrJiseKaeJgfYXXux6UADPJmIhISHd6RlrO6+qUL
	 WCes/LhH626kg==
To: Sandeep Dhavale <dhavale@google.com>
Cc: "Martin K. Petersen (Oracle)" <mkp@kernel.org>,
  peter.wang@mediatek.com,  linux-scsi@vger.kernel.org,
  martin.petersen@oracle.com,  avri.altman@sandisk.com,
  alim.akhtar@samsung.com,  bvanassche@acm.org,  santosh.sy@samsung.com,
  h.vinayak@samsung.com,  wsd_upstream@mediatek.com,
  linux-mediatek@lists.infradead.org,  chun-hung.wu@mediatek.com,
  alice.chao@mediatek.com,  cc.chou@mediatek.com,
  chaotian.jing@mediatek.com,  tun-yu.yu@mediatek.com,
  naomi.chu@mediatek.com,  ed.tsai@mediatek.com
Subject: Re: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race
 condition
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <CAB=BE-QT1oy=XD_MFWaR+VvKG_Kpk3jszDpAtUy=EyK9uU5fbQ@mail.gmail.com>
Message-ID: <yq1se2jim7z.fsf@mail.kernel.org>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
	<yq1jyo8pwwc.fsf@mail.kernel.org>
	<CAB=BE-QT1oy=XD_MFWaR+VvKG_Kpk3jszDpAtUy=EyK9uU5fbQ@mail.gmail.com>
Date: Mon, 05 Oct 2026 22:42:34 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Sandeep,

> I don't see this series in in 7.4/scsi-staging at [1], or perhaps just
> push is missing?

Just pushed.

-- 
Martin K. Petersen
