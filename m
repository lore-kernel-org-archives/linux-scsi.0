Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788FF2580C8;
	Mon, 10 Feb 2025 16:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739204480; cv=none; b=r3a9tMyy43VEyQJmvejrGDJoUlLg1KB6XRTDgE4DfgsFMgoyYNNKzJpu0DgxHVsZz3XTkLDyVwuKTEShar9hw4bX7OntSSfjZHLIkQCiNPFKxEX1eAvdgdXoKceHdOr6YtbzfweOe2PaeQ1+Qo2WTanYbaUfoK8club6BQxaBn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739204480; c=relaxed/simple;
	bh=5++DRPtjlCi7ZJ3996a5DU7AlRL4Wwr6fONkKsNrvYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CU8jEGxGxTytF501lwsTgzdZn+PGH3V1ILEqRPzkCuUQkE8bdpu7Bqgq2KO9lyQvKxXktOn1xwyy+okGjmZ839yLOdPYXXwHxgjlwYjv1ZzzDjBrcRTo9H4JOnX9elSammW91m2xdaxyIqP8NvQEZr9xIWrTBGOqqB3GRYjk8rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cT/Q/dKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cT/Q/dKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C0C4CED1;
	Mon, 10 Feb 2025 16:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739204479;
	bh=5++DRPtjlCi7ZJ3996a5DU7AlRL4Wwr6fONkKsNrvYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cT/Q/dKPzg28EGcuwFNm43LidbMhaOZqlgxL/+PZcdPr4ZhIKze03vCiu5nYolRJM
	 +OyOGW4mYwe5ZsNssqW8upQYNQrIR6pZWGdEEmQBkDzAK+HqC/CBXMfrLvDM6epGvM
	 3ZUX1LPdyV76barsmmrp7Zifm9M610I1rUFmZ4ufHmS7Bg44wZ5lsQJCl/sC8OpWBk
	 XtNFImcQeuEh1hxIO4YYYO70mhaCySycvnHkxFCofag6cVIkUxt+rfkequnBpn/hsI
	 UYbXukxfyCv3t4llQ3jxOFaWJVfgxqfjKSzMYL7lsR3adGIhPE7U/ifuDzFhO8m9QV
	 jbLsQxgZc5YMA==
Date: Mon, 10 Feb 2025 08:21:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>,
	linux-fscrypt@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH v11 7/7] ufs: qcom: add support for wrapped keys
Message-ID: <20250210162118.GA1264@sol.localdomain>
References: <20250204060041.409950-1-ebiggers@kernel.org>
 <20250204060041.409950-8-ebiggers@kernel.org>
 <20250210044445.vmtfhqjibonhi6j2@thinkpad>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210044445.vmtfhqjibonhi6j2@thinkpad>

On Mon, Feb 10, 2025 at 10:14:45AM +0530, Manivannan Sadhasivam wrote:
> On Mon, Feb 03, 2025 at 10:00:41PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Wire up the wrapped key support for ufs-qcom by implementing the needed
> > methods in struct blk_crypto_ll_ops and setting the appropriate flag in
> > blk_crypto_profile::key_types_supported.
> > 
> > For more information about this feature and how to use it, refer to
> > the sections about hardware-wrapped keys in
> > Documentation/block/inline-encryption.rst and
> > Documentation/filesystems/fscrypt.rst.
> > 
> > Based on patches by Gaurav Kashyap <quic_gaurkash@quicinc.com>.
> > Reworked to use the custom crypto profile support.
> > 
> 
> Instead of mentioning the contribution in description, you should use relevant
> tags IMO.

I had to rewrite this patch from scratch, and it is a much simpler
implementation of what was originally 6 patches.  So in this case I don't think
it would make sense to keep authorship or co-developed-by.

- Eric
