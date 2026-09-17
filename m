Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAA8367295
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612142; cv=none; b=ukgup1RwvXl6wXQ57i0q5isXl4QXI+jFcka+zKANBwTSblXYBuqRUD3MgxPaaiLGgPW2+ZJyIVNl/Zq0MFZGedN2J5uersGdB29eG6ztEHrYv5FSv+5kp5UiQrfJIR6VlSvcIVL7QfCqJzdGKddkG7bUWuN5IFLEnyZIv+5vnqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612142; c=relaxed/simple;
	bh=eqzKbbmV77Aah72ej0wfW94eFu5tw1f8DgVFPnXuMwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCobckyIFVGXTaA7N1X2/rmZmIXahpK8thcfVk97rw5XlHRKOfY1K3Jd4qVGfagQkDTy+eg1IbTZc3WkJApj341zA17A28Y7j2uvs6tSrABvFBPGk2snui8bNRE+02s814W7fl7TLQOs8+DKpFnASHW5R1oeNr1OQuXJeRPt3xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BBU1Cfm0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BBU1Cfm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517EC1F0089A;
	Thu, 17 Sep 2026 02:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612113;
	bh=1HWPEA+5CqWtOnsnZep+r+0qwHgc88lBEdjtvCHg+dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BBU1Cfm0309jwsXql+MsYppnEuZrUH9RwmzpN/J+CnXUgWMomnuWB5PPYV5LVKXsq
	 KT4SwNY374qRzrcd6Cc+LBnrxzkPqDDoedvxBnavfbSLNNFE0FvrYe+yuZboM5RsY8
	 L1D1tXVEBUSdcBODRzzzakrCy4jQ38lBmen6SSb9qzsNCihdGU7opwaLwORS501lIU
	 CDTKn2BwiY4WYp58ZHvRzTOv8li/G3TRm1P7JbvDHSnEkrQYus0xOCoxVMcxNAkzgc
	 Gg5tDz34yKKD72W9W8EeCha4xEnrIZ8SRkzH/sQe3UJq1UXh+/4q4IRPHIXwxmUCNy
	 wAVYueNuEEWSw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Wed, 16 Sep 2026 22:28:15 -0400
Message-ID: <178961190606.3672510.12229874119838839211.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org>
References: <f06b5ee432b21cf293f0663e15b64f75a84b9fd5.1788204406.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 12:27:20 -0700, Bart Van Assche wrote:

> Protect the megasas_get_ctrl_info() call in megasas_resume() with
> instance->reset_mutex using scoped_guard().
> 
> megasas_get_ctrl_info() may release and reacquire instance->reset_mutex.
> Hence, calling this function without holding instance->reset_mutex is not
> safe.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
      https://git.kernel.org/mkp/scsi/c/42d1221d321e

-- 
Martin K. Petersen
