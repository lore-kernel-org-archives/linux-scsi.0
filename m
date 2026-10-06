Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52684325701;
	Tue,  6 Oct 2026 02:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254644; cv=none; b=Cd8Lr0SL0NLXyIRwD+g9sXBJlKoeUkd2n1j+t72kLc2cJGye3RwP8tSiyEKwiO8/X7Y/rnIQRv/bcGusSJTaAvCY5AAosl8mPs9rVISL93pFOMiby1SF011P86Qz3JvAEOVO/BvdDd3CJfeHsBrOf5f/6SpNNx+EBuD3dQgRfWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254644; c=relaxed/simple;
	bh=xfUorRESUVdLXo/p1V2ZH5t7T2dM+PyNtczHARbKOE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JyC8lKIfRW5MLKLZkO6QKKPEpAbjfrxdRpMsOg6onevjOv9HO/SZh8pPNP9EAYZrOF5ga/tnPTITWTYoShmuaGGgaagfereKWZ+xn8gkStYFzoChF4/Io+aInuZ7lN5z9cSQsetiCDP/5PMotpDhFJBAHlSAwRQnaKQh1u/OAoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzJWEbhm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzJWEbhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A6B1F000FF;
	Tue,  6 Oct 2026 02:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254642;
	bh=MwukY5BBBFb9QnB0ZWWDlgkctU+6sRsAhDNo+GjaFVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hzJWEbhmlQBtB7IusngodC08WXl7MrQzvmPVthFTKMD+NLwSjPOd+vP8csyBeMKN+
	 j+viNQ2ULU+Ayp9zrhSjPuCU8v1VUaMyZS4uRJ/qlDTz6HGB1OxXQZo13nOEnCM3jG
	 YARMLKworNqE67y1bxeuX29vJVkHe0dlWJ8wvw7r+tQTiPWGtaXkEONQ5Ce6zkDHck
	 97ZgPODpxETSDOYJypriFZcykZuPKJm4FCZhj8k2G5HOczOp3rzdrtvIKpqsPf2A/E
	 sMsqzF0udOWx9ouMJnrYtXa66p45qiVhs0sJQSit6B13ehKaVM/OQJO5oF2zGB+c1S
	 OjDwVnkxXz5TQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: qedi: Initialize callback state before registration
Date: Mon,  5 Oct 2026 22:43:53 -0400
Message-ID: <179125457802.2089616.2646253319409561790.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910092405.1300129-1-runyu.xiao@seu.edu.cn>
References: <20260910092405.1300129-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 10 Sep 2026 17:24:05 +0800, Runyu Xiao wrote:

> qedi_get_protocol_tlv_data() can be called asynchronously by QED after
> qedi_ops->register_ops(). It takes stats_lock and reads ll2_mtu, but
> __qedi_probe() currently registers the callback before initializing the
> mutex and assigning the default MTU on the normal probe path.
> 
> Initialize the callback-visible state before registering qedi_cb_ops. Keep
> the recovery path from reinitializing state because it reuses the existing
> qedi context.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: qedi: Initialize callback state before registration
      https://git.kernel.org/mkp/scsi/c/85de8b3a5eaa

-- 
Martin K. Petersen
