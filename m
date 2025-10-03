Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BF1DE4E1
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 04:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759465503; cv=none; b=e3SnBl6j4LSnBHtLWcnA9x5JyDo1qtI5h2GpvvFtzm5hiK5uNxIoJqLQrzzBBE34hN59PPHX/nPxJMIHmGCDi7VlViwt56quka2UIw0/iTqkLBmERLXHvHJYVVARX6NZmYBDv5ULArMQCGu+4qwJ+lSl6xEovpcRKEkmR4QwVHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759465503; c=relaxed/simple;
	bh=R5Qrc3ZLY09xTdji9PTXY/QfyRW/LYbPp2uqFd4dPMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E6xFAZt3VpLkfc2ZBvaGCcba1C+IN8KrYOAOU9iXl/KA3IpKEy/jizEZMw7NmPeeKOBBmQwkWOFvLQsGsz2XLNrIWtDE/BD11/DFXrK2oZlC5826vRkHWrDp/RvR2IiSnUN8azdXgMuWghgPVCfS2vEwJm+RtWAXepbM6OwyRIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fMbjbiWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fMbjbiWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9486EC4CEF5;
	Fri,  3 Oct 2025 04:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759465503;
	bh=R5Qrc3ZLY09xTdji9PTXY/QfyRW/LYbPp2uqFd4dPMs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fMbjbiWT8wAoT5hqFyzlyjreVYRTfutdfhpfb3DYJcQ13zzXFkgLxHDzEt3YmITVN
	 2+B5JrRjb89paP7fP5bXFG57vJBkKzmN8sdOf86KaD8Vp2hAbvNuZ803X3rRpmuHGl
	 tS8pWWeI57LKalZw5TfSs9J4lh4sAAes7nWDo5lRyj/SaBbXiM4c6qb1PgJ0rU+qHV
	 SAoFA7N71UL99YCEZvSGmnXEmMathRyvcuGAJgd+t5ndAY0VUKL2v9I4LuNkeM9kNF
	 XLLH9kF70ic2apUO27SYGOT1TzaeMCgv8qwsemU+itwvr+WhPbMsrmETDXbQynyBfT
	 dBSr4LcXIsZEw==
Message-ID: <3557e8e8-398b-4b81-97af-36d0a93633ea@kernel.org>
Date: Fri, 3 Oct 2025 13:24:59 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] scsi: Explicitly specify .ascq = 0x00 for ASC
 0x28/0x29 scsi_failures
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com, bvanassche@acm.org,
 hare@suse.de
References: <20251002192510.1922731-1-emilne@redhat.com>
 <20251002192510.1922731-2-emilne@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251002192510.1922731-2-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/3/25 04:25, Ewan D. Milne wrote:
> This does not change any behavior (since .ascq was initialized to 0 by
> the compiler) but makes explicit that the entry in the scsi_failures
> array does not handle cases where ASCQ is nonzero, consistent with other
> usage.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
