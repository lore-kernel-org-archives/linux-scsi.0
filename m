Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4D3A1695;
	Wed, 14 Oct 2026 03:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791950253; cv=none; b=K2F9Bzb+/pY+/XB++fUYD0k9h7z6DZkKCs/LbEkiV62xouG4aiuXZy2OshspfRjIEP996HMO7djIwa37OtbgWn0hjwywVkgN9QBJlFaO0ahasBxrOE8F0A5MxzSPVuDjsSaENLhc5vJygeC3jfspEi99AzYUe9j44WjYk8A6C20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791950253; c=relaxed/simple;
	bh=jlzwa3F5ldCf6FM7IJom26Zk3dCY1OueBjdVELslbj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t5UIRz2JiDuJqa0/IxhajaDmtdlHoyCwqR4k9k4RbNOefXs8Aw4QTMRuRTZUzfk5LLzHpSGa4siT3HUvtsHBiTJ8yz8iMRHSy1ypcJF034EHotIe8VjT/rzHIIjT6OBDgVAz0Zt8+5t22UgramTBfpJjcP5FnnNXafWY707dsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+0kiPo2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+0kiPo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD01A1F00893;
	Wed, 14 Oct 2026 03:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791950252;
	bh=h4LMCGfzVlZwem4BbFvTFgMCjtImsRe9+KMEooMPZhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+0kiPo2Ops5GDFDlCRo5tWIZb/bzOtJsvHjxdFuudfjBDj1lkfTgo/bjlRwgdQkW
	 GiX8cuaVECRmhKVxH/x8bygS9OfmjMb617UFS2EeSm3pjL5hBGRbYZlDlygtgQJTXl
	 ZDDeOL5H7BDjtpTBwvpDL//FjXW0NchQCRxgY7gPAbw2hme+63ISnGmitCZWkITPm1
	 rYnGHCzr0lSIiMxNw7Kyp5jRKsgdzFQ5XuWL5QGtAcClVG18A+I+fqscpvx03lhYYm
	 5ueSmLwwXhYNdyBqtsL2yPWT/IjaInEQpXyMMTYy8YmVrHvqDj7M8SembuaAAVYaFY
	 Gl0aQRn+FSU/A==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <mkp@kernel.org>,
	loberman@redhat.com
Cc: James.Bottomley@HansenPartnership.com,
	Kai.Makisara@kolumbus.fi,
	jmeneghi@redhat.com,
	dingiso.kernel@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: st: Fix use-after-free race between st_remove() and st_open()
Date: Tue, 13 Oct 2026 23:57:23 -0400
Message-ID: <179194999400.3016381.14718973129990578742.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013202548.249628-1-loberman@redhat.com>
References: <20261013202548.249628-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 13 Oct 2026 16:25:48 -0400, loberman@redhat.com wrote:

> st_remove() drops the probe reference on the scsi_tape with kref_put()
> and only afterwards removes its index from st_index_idr. If that was the
> last reference, scsi_tape_release() frees the structure while it is
> still published in the idr.
> 
> scsi_tape_get(), called from st_open(), looks up the tape in
> st_index_idr and takes a reference under st_ref_mutex and
> st_index_lock. remove_cdevs() does not wait for opens that are already
> past chrdev_open(), so an open that is blocked on st_ref_mutex while
> st_remove() holds it can take the mutex as soon as st_remove() drops
> it, find the freed tpnt in the idr and call kref_get() on it:
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: st: Fix use-after-free race between st_remove() and st_open()
      https://git.kernel.org/mkp/scsi/c/71caf7f84bd6

-- 
Martin K. Petersen
