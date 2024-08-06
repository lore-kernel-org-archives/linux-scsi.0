Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA00E15B147
	for <linux-scsi@vger.kernel.org>; Tue,  6 Aug 2024 06:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722927429; cv=none; b=BzfdmMXeZtsmDRKY2Bif72MxpW9wWiXUFIn+tMa8WAr6kbaW4gr6Lg81VDMxlbqEFdulsSj0iVgqoUEYEYMUnicJ5H7FnyotkSONc8Grs0t08amGql9lhCm/tzdwvBUuShinSKpSRB1u+KwVGc+chjHoTl9nxbBp9Ro8fAGbagA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722927429; c=relaxed/simple;
	bh=Uo0vXR/5IbrWF6KtQRi0/14jKeUl0skCCNvbL4uRVf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMsSrJr3Kbi3aKiLe+Py6rdqBdgm85ANQe+yxFlk2LVCM0fjcRCOSgq5q8tpMdFqj03rWlRmtgKG9NXuscutLDAtc7CJtTWbSnNtDU+UugyYamWCnCXwnbM2zEH9bWwbY2C9rw4mbyxd6/Q8NPDozo6CoAJu2ljmZWX/1/0R07E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkdF52zN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkdF52zN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F097C32786;
	Tue,  6 Aug 2024 06:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722927429;
	bh=Uo0vXR/5IbrWF6KtQRi0/14jKeUl0skCCNvbL4uRVf0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tkdF52zN8gDaG3l5lsGzpxWx54P46NGvJaqrALTRkpEXwGmrZC9vLo497uUNk4aIM
	 IYrKG6fCo81gYSrUXvaOS8Dwo2n6RTq7y5kxA+2nt3hujQPGSJuPX6ocRMWsqqpU9G
	 OkpJjnlKTtSPy43HvPsc4cKDxJI5jV9qoJfOICh8=
Date: Tue, 6 Aug 2024 08:57:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Sumit Garg <sumit.garg@linaro.org>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH 2/2] mips: sgi-ip22: Fix the build
Message-ID: <2024080603-buffed-choosy-a04b@gregkh>
References: <20240805232026.65087-1-bvanassche@acm.org>
 <20240805232026.65087-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240805232026.65087-3-bvanassche@acm.org>

On Mon, Aug 05, 2024 at 04:20:21PM -0700, Bart Van Assche wrote:
> Fix a recently introduced build failure.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Fixes: d69d80484598 ("driver core: have match() callback in struct bus_type take a const *")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  arch/mips/sgi-ip22/ip22-gio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks for this, and the other, fix, I'll queue them up to my local
trees soon.  Odd that these two targets do not seem to get any testing
in that I never was able to see them in the 0-day or other testing bots
out there.  How did you find them?

thanks,

greg k-h
