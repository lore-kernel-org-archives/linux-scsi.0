Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB994A24
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2024 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713144806; cv=none; b=UTkQ4v+Qft186noSnCJJHEdLXNidXtJhb2ZiMqnacj6Chxrqgu8XVYHiUCjs7zz8ZxlOPsBKugrQhi2o9ZOirdnPFUnmg3ZtkFhmlApmT7WgotYuRrTFnNDAKlS8T0bPTQHGlLJvfGxS9g3lCEuwv7d3CoOAc6+cAHaMAdRy+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713144806; c=relaxed/simple;
	bh=F2rIAoTp54Qmq7emZuYcIm67C5QoCkZGgLnae8WK4zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTq8Su2ySmDPXuxB7SWSTVotAl86aM6BOrO8KD2tLsMiAh+zlY/GlCfgbTxJ27e2Wd4ox4gYTCTzbMqaT9+h+L4IjzMASyt4xd9tQNkX7cZjyTr7IdtQxZiPES7z0g+wFTDqtn+tSWQVL0WnUesAU45roBoyJI8uCbOrTa//qhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpddOXyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpddOXyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97BEC072AA;
	Mon, 15 Apr 2024 01:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713144805;
	bh=F2rIAoTp54Qmq7emZuYcIm67C5QoCkZGgLnae8WK4zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SpddOXyPm6hBrY/qUsoG+sbj1n9P4L3IKjXgGybPNI5dQWv8bOFhvpk9TkmBOnWMU
	 845RO2pJBgWiWQMh0UYp1I9r2zxWmJPdQ7qMCDswwCnkg623LMgdrC1zPPBgKAtd3s
	 Smy2AByQYqaFb5CjSbilJrRGMtDR2tsOpk2vTCuvOTgdluANXv/YVmMg9teC7BjpNs
	 VGq+9v5bUv/FvTu/lr9KeSMxpxDx6ZcXmjhdegbTx4a9Vt0BYltmlixTsCqBFaJTjk
	 kKttFBMl55sIvJkUI1tJ6aFsaLDWCn/H+Rs98iFCoeIRsIl8fIKq0ARHqCxh6UFy4C
	 BMHIn1xc0NpQw==
Date: Sun, 14 Apr 2024 20:33:21 -0500
From: Bjorn Andersson <andersson@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	Peter Wang <peter.wang@mediatek.com>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Stanley Jhu <chu.stanley@gmail.com>, 
	Can Guo <quic_cang@quicinc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Po-Wen Kao <powen.kao@mediatek.com>, ChanWoo Lee <cw9316.lee@samsung.com>, 
	Yang Li <yang.lee@linux.alibaba.com>, Keoseong Park <keosung.park@samsung.com>, 
	zhanghui <zhanghui31@xiaomi.com>, Bean Huo <beanhuo@micron.com>, 
	Maramaina Naresh <quic_mnaresh@quicinc.com>, Akinobu Mita <akinobu.mita@gmail.com>, 
	Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH] scsi: ufs: Remove .get_hba_mac()
Message-ID: <ozm4y6q7r7ikwrtffgslxvw45ok625r5gjvdbgiyegrzavd2xe@45jyef4lfp4b>
References: <20240412174158.3050361-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412174158.3050361-1-bvanassche@acm.org>

On Fri, Apr 12, 2024 at 10:41:29AM -0700, Bart Van Assche wrote:
> Simplify the UFSHCI core and also the UFSHCI host drivers by removing
> the .get_hba_mac() callback and by reading the NUTRS register field
> instead.
> 

This quite clearly states that the change is merely a cleanup. Can you
confirm that (capabilities & 0xff) + 1 read back as 64 on both Mediatek
and Qualcomm platforms? Such that this indeed is merely a cleanup...

If not, please split the change in two; one that drops the callback in
favor of always using MAX_SUPP_MAC, and a separate change that instead
reads the value back.


Please provide a clear problem description in your commit messages.

Regards,
Bjorn
