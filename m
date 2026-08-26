Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8759041F379;
	Wed, 26 Aug 2026 15:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787757622; cv=none; b=k/fQzFL6JpU6geZ8NzLfsWkzHMoN4B4O4HSxUhgnn+cQRb4wCm/3l4p/BEEcCQtRydvYKq/2yFS8fHGjYtx+e4ZxYfMcl0DeBQHQWvkFPs1Lnn9OacQyXaPKAVTNR0g7CftuL0Z9HT4OH7sZEdi/EsKfdQWyrFigRaXXxL4OpWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787757622; c=relaxed/simple;
	bh=GlfRbGpSaCwTmZ3K3htlCuFGI1P2KRvd8usvu5L3ECs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lVF5TdW5LVZs3XXHM1K78szttw2DKc0h8RgeS5dKDpaCN1WvXNCFGNdciOt4Nnn6kEyVtijtAv826ELiTF63O0MPBiV5+ZjYR/Sefpi3VxW1o1V+LCFj62Bzjbi+wGn3DhhSeUvi9exKXgFgRys8YwiyUOGvdZiZbP3kLqgzX7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mEghI8Od; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mEghI8Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25FC51F000E9;
	Wed, 26 Aug 2026 15:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787757621;
	bh=HY0Nq4Dk9W6qBW+Wto9OVo+1ivrnbP2+p7GtqZ8aUes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEghI8Od5UArT0aXr77hYbQnzYjpiJRStu4Y82ldBJY24l3ZTn94qT8WFmQ7g6wrw
	 aeGv1ItGnwclFZ6KymM+vfpWyFmJ7gwjeU2HqJfQs2itubHFsatxxPeowq9Z2/YLfR
	 up9z+J96eaQaSoOpIkNuIUx62CahPRUxgU0RsjPbTDhc+lTTw59TBt2lxGcQyu8taa
	 0pEoTMOZ4VFIb3aJvsNAN6ustuTB7kowvCG3O9o1Ug8oZo+8dVJm2sDIACSN1LjcjE
	 ITHd4APm31578WYN85dV9/sXyt9IlylVhf3/5w71bukHu4srka9NUAi51jGwn5IO4g
	 k9i1bS5kpamNA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: kartilak@cisco.com,
	nmusini@cisco.com,
	sebaddel@cisco.com,
	ames.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ccc194101@163.com
Subject: Re: [PATCH] scsi: snic: Fix scsi host leak on workqueue allocation failure
Date: Wed, 26 Aug 2026 11:20:08 -0400
Message-ID: <178775714081.3862282.6855986330540890481.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
References: <20260727073438.209673-1-chenchangcheng@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 27 Jul 2026 15:34:38 +0800, Chen Changcheng wrote:

> In snic_add_host(), if scsi_add_host() succeeds but
> alloc_ordered_workqueue() fails, the function returns -ENOMEM
> with shost->work_q left as NULL. The caller's error path then
> calls snic_del_host(), which returns early when !shost->work_q
> without calling scsi_remove_host(). The Scsi_Host remains
> registered in sysfs as a zombie device even after the probe
> has failed. This causes:
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: snic: Fix scsi host leak on workqueue allocation failure
      https://git.kernel.org/mkp/scsi/c/12e67eb89eb2

-- 
Martin K. Petersen
