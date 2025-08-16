Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666C34A00
	for <linux-scsi@vger.kernel.org>; Sat, 16 Aug 2025 00:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305069; cv=none; b=tDxR9rBOpwgPIC9/XtVnV1uUogvpyJ+Q92wqQnTJsFDOYsUDQVEHMV9CnN89Hbp4Bh9r5StJL7ChXRWzTIg+Ft0OAQIeBgo3f25KfmIAmEi3C5yeA4JNKZJtaErMDUuOILdAhh4/4V2iIIR48ce7WlkctjlF93WAhLFOR7OSUac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305069; c=relaxed/simple;
	bh=QgB5XNVGBBk63SVPEIlKByq6wlpXk7MI4VcUdOZ0sJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZNvBXX4HgJGkStbHWhQHbaglwwDJpg9tQg9N4jlJHKhpT2dRnJpGlTFD0rM/F3JWgqNE0w4abuTmw+pnPIbHu/U+F4P8yJuCanIjBQTv1LL2eCw49JnnNtPda8YZIThbFEIsklXiFV3Rb1AU++f3l5gQdsJ69HI88RG4Ogrm47E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzbyXQpS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzbyXQpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22575C4CEEB;
	Sat, 16 Aug 2025 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305068;
	bh=QgB5XNVGBBk63SVPEIlKByq6wlpXk7MI4VcUdOZ0sJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DzbyXQpSy6Y6qjYITmElJWtbJOFRSihe2CF672atjK8RBeEyutb/vfQviIdhEDHUM
	 RZCG0v5PLLklWc+dLOUlmHBcxsFBk90pLjSOt8YTQk9ZObYmPOTUrYmUyloFvI66hp
	 rkHs+guj0WeWtHsJ4bwhz0/r4JJEF47ASF37HJlkDomyU2bBBoDurfezbBoDSHJ5Me
	 58rCZpQxfLrbDKaqgrj40JVs/tNvVmWlD8v+RDiS6CMmP6td7pFJHLNPK/+enIAul5
	 Mgkya1RNz8hrV2n/TymJa3I6GgHDmmYQ0aswizbjBsYspl7coEWp+EOT7YVkU21QAQ
	 m6SbxxmL0zB2w==
Message-ID: <1b8c0005-5862-4b5a-b0ab-98e4a1a2d655@kernel.org>
Date: Sat, 16 Aug 2025 09:44:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] scsi: sd: Avoid passing potentially uninitialized
 "sense_valid" to read_capacity_error()
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org
References: <20250815211525.1524254-1-emilne@redhat.com>
 <20250815211525.1524254-5-emilne@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250815211525.1524254-5-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 06:15, Ewan D. Milne wrote:
> read_capacity_10() sets "sense_valid" in a different conditional statement prior to
> calling read_capacity_error(), and does not use this value otherwise.  Move the call
> to scsi_sense_valid() to read_capacity_error() instead of passing it as a parameter
> from read_capacity_16() and read_capacity_10().
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Does this maybe need a Fixes tag ?

Regardless, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
