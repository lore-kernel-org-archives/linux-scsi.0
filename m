Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E024C133
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755304604; cv=none; b=Jwke5LiLJJHJlrz9kkiJlQ27S9fOSP9tEWx4O55P2odlf4DvMS664SyZwNBIOY7li726C8dFzOhoPTTYaC/5qTcYRK+Mqimcfadq3jmJdWq+Wcys56ZCDmyhLFl4YStYuQ3Gqo/jW2GRbam13GsYiCvuHMxe4BUh0XiCEkxpFpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755304604; c=relaxed/simple;
	bh=AaWYekHFCE6ZiKPNyGUccdzdkEzpLkPEP+jhAvOewuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bXAhG97jTwgKMuDCLd0EMJEurtNy9DqC1vIid5E3vtEzj1HdHiuMs6CFA57gE2VU9sju/wwCmt3B/uc53/Az8xbdSgp0bdZyT2HjntDgSNZS9Ct2JQTGskLoiCvl1YFGnQdP0yXroUJFaO6qWD5ITPgaVpGJ/gkLKVGJGq6Jxgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hy64L3oS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hy64L3oS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB2FC4CEEB;
	Sat, 16 Aug 2025 00:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755304602;
	bh=AaWYekHFCE6ZiKPNyGUccdzdkEzpLkPEP+jhAvOewuM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hy64L3oSCJJB0adbuLxtvtlvfAiqeS8FFkrfJsSrI1yO2twPd3c4OY9P6gwIxhGhL
	 gPzC7Qzn7w8vjyQlHPLh+HyBP+WYGOs8VRXQvBWl9KipOlfwurY59ulqTQgA1k8Fcx
	 UYVf2DWq4WgLWb0dG9ivNdpfy+VVAQ6An77X5aRQoj8vu6T5H3Vu2FCNJfIU4K9Yzp
	 0S/zEYue6RwzY15EAxsvRz9zdL6TS0VyyB/C1mkde0Glhk5DXonaGZe4i/1uxBvZ9t
	 pmLLBFQgYqb2bMb+eV3Fx9lPs09FdDF/NnBM4XXPUpR1KMsLR/zFRTlUmD0mCTlZnX
	 2/h1+/ewj3VLg==
Message-ID: <f8ef3a17-30c0-4199-b5cd-6bc751878c89@kernel.org>
Date: Sat, 16 Aug 2025 09:36:40 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] scsi: Explicitly specify .ascq = 0x00 for ASC
 0x28/0x29 scsi_failures
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-2-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> This does not change any behavior (since .ascq was initialized to 0 by
> the compiler) but makes explicit that the entry in the scsi_failures
> array does not handle cases where ASCQ is nonzero, consistent with other
> usage.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Looks goo to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
