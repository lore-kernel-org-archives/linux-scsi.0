Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A6C3C76A6;
	Wed, 14 Oct 2026 03:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950237; cv=none; b=JQDz+UrzVVYZtwm8JTLL+d+NEKiRmVf5ss+uUICXe/DOi8E+YPywqUfdnEqrmfO5HNcHUkulxFcXDp25nd//RCGEMMkmMCiq0zh5W+wU/ZYwnX3D9dJxT81qxTO26OfVQ4vWO5TdBZmP6YKwG/ceGYb2XsIoE6x+5rf0puf91AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950237; c=relaxed/simple;
	bh=w28mzMK3TJ+8TiiTFZce0C6G3Rqi2NvyGijcQ9Mi67k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMlgAKZeGRUrsmzTpk1WmgYUMJihSQCPvLDsQOPMFW1EFVQuL8S1MDzl4vPFQ9s7jjOjsED+FyE9upSdoUvGDsTfBDjmvwIRaLC6kjXBfC/591EOlfDoBwmHZ/t9axOXP/BJSHOjMzHJbtZ/jy/kMTFXLrQood+QrDjcOeMLgHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SYXX/Wsd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SYXX/Wsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102431F00893;
	Wed, 14 Oct 2026 03:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950235;
	bh=AXt0D4G5Kz+Mx5MsjDSOtVyEHV8+gWXuqPzvituC/jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYXX/WsdJsCOmRWVQG1HTtsfbBE7q/ZKY9KwUd/bjz8RHD4yhJzDKpzA3GMk8sixL
	 t6luhAddQR7O1yeXpahsSPS/N2Fk+Cglg2EKK5RPsbZC3Ls07M8pUSnthPHBisU+Gr
	 nWCdFVKTFmWZBBMsMNrIchJEfmAtR7UPYEp0+Rzes77TLfW01jioiDU4a7IRFxsNJL
	 RmlUsCPBZ/h6dmsRiRqh49Qibm80OaKs3qmCW0/A+FLhGDCJ01ZZBKlZwMOCWHCp8o
	 GbIuvQ3Hd9D3zRPr2oD5VPe2bAsGV2/+6XMzGgXKcE/ZMTX6AIIifNMJNhnJ+TY4Rs
	 JpVwj//6KzIfA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: host: qcom: Enable MCQ support for sa8255p
Date: Tue, 13 Oct 2026 23:56:50 -0400
Message-ID: <179159633696.2229379.14995069149172467606.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
References: <20260728051104.675088-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 28 Jul 2026 13:11:04 +0800, Shawn Guo wrote:

> The sa8255p vops (fw-managed variant) was missing the MCQ hooks, causing
> the driver to silently fall back to SDB mode even when MCQ resource is
> available. Wire up the same MCQ ops used by the standard qcom vops,
> so that MCQ mode works on sa8255p.

Applied to 7.4/scsi-queue, thanks!

[1/1] ufs: host: qcom: Enable MCQ support for sa8255p
      https://git.kernel.org/mkp/scsi/c/55b6593276c8

-- 
Martin K. Petersen
