Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1818E77D;
	Tue,  3 Sep 2024 19:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725392565; cv=none; b=D3x8P2fz/499RSNbjXvjTx6ZagLB/6mwOrHYipSkeMOtBUm9v3ZvuCT+aUaplZe45aqCEtp0yLO+AUIMmATwzNUhdR/4QxTxxSXgazGE/6kbCSH3/2Anav2Xn8g51J97QThakyyahWwKgI3C7BN/9R7CziPMn8B07hMFnjoyjgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725392565; c=relaxed/simple;
	bh=zmMDKLJ+pb/N6z6OdKFlaVSX9l23YNKVttSAfF1rbKc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Gize3HO+YB8c1ZwqHJzAJs6+entNDBz0OxNkFzgYZzCVYxCRajv+uzoTa7hCMvpOvvyfNvoyqgvvno7tF6qZlz9p+JUlXSeCLJy5GWw4FTdnlLU+8gxOphO2fHBPMeweYvMF02J9F5YeRzYLGYD6/fy2DqZO1CfjvQ8stJjpBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pl7wJjOy; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pl7wJjOy"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WywyC0TZ5z6ClY96;
	Tue,  3 Sep 2024 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725392557; x=1727984558; bh=zmMDKLJ+pb/N6z6OdKFlaVSX
	9l23YNKVttSAfF1rbKc=; b=Pl7wJjOyBf2C6NwwwRmYCiWPUbT0wcfOv3r4nkMw
	Kl24j1Bg21mx1xUae1XF/jmCoPLJPu/upwVjXLJZhsfiP6udCHlqJW9mqINffSFo
	J/IJElTjRBeKeQZffmyzC5igkwYZ+oZ2PRLto/3Bkjxk4Jk/+SXrjt7MIzuNMuAR
	bakLHIMDoiFOCX6bVlBXRpgMBsbu+UoU4Bf3u6zhqFCr6YsevJloFIEFVt6WR9+W
	42/sJ+j/03293urPdouOzKY1ZiOyZ1vhHGT2jRTHqfA2gYGeQokTAyQ+1E6PrGBk
	1N+kWCb+UFbaqg76RrGfITvViWJMI449w93Jy8Sbq9ZLtQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uDglJ5ZjXDBW; Tue,  3 Sep 2024 19:42:37 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wywy30rTqz6ClY95;
	Tue,  3 Sep 2024 19:42:34 +0000 (UTC)
Message-ID: <7734408c-82e0-4b4a-930b-401bfa26161f@acm.org>
Date: Tue, 3 Sep 2024 12:42:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v2 2/2] scsi: ufs: ufs-exynos: implement
 override_cqe_ocs
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, huobean@gmail.com, alim.akhtar@samsung.com,
 avri.altman@wdc.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
 beanhuo@micron.com, adrian.hunter@intel.com, h10.kim@samsung.com,
 hy50.seo@samsung.com, sh425.lee@samsung.com, kwangwon.min@samsung.com,
 junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <cover.1725251103.git.kwmad.kim@samsung.com>
 <CGME20240902041755epcas2p316730258dc0c2ed2b3f9744722dcde9c@epcas2p3.samsung.com>
 <041c7204703ed2ee7563344e935921dffa34ccfb.1725251103.git.kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <041c7204703ed2ee7563344e935921dffa34ccfb.1725251103.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/24 9:26 PM, Kiwoong Kim wrote:
> Exynos host reports OCS_ABORT when a command is nullifed
> or cleaned up with MCQ enabled.

That is the behavior that is required by the UFSHCI 4.0 standard. Hence,
handling the OCS_ABORTED response should be the same for all host
controllers and no new callback function should be introduced to handle
nullified commands.

> I think the command in those
> situations should be issued again, rather than fail, because
> when some conditions that caused the nullification or cleaning up
> disppears after recovery, the command could be processed.

ufshcd_mcq_nullify_sqe() is called by ufshcd_mcq_sqe_search() and the
latter function is called by ufshcd_mcq_abort(). It is up to the SCSI
core to decide whether or not commands aborted by ufshcd_mcq_abort()
should be resubmitted. This is not something the host driver should
decide about.

Thanks,

Bart.
