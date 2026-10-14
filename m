Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D868E363090;
	Wed, 14 Oct 2026 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791946143; cv=none; b=qfc2V361cLIEiXJ00ujDFkGXB4vpgH/y957oubGB4zrpYX8R8m+7ls5JWJp+XMxx48j2KXgif4oqBA8uBUHO6ctdne8dgJ1WqAhftMAYRdIUUCwjlFMLcRrzVUKFrNJ+80X6O8VTqNp2E0t2NGZk4fr1Vm1N88eeJjsDswNApdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791946143; c=relaxed/simple;
	bh=RNbKNRS527FLzE3xL8s+PwAPD/cNMkxUwLI3NRRTkxs=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=GO30A9VFSvunm3bCTHlFRuuUIiTebaIhYnEmBXnUu6AJvFnadS7+wr1+AtM8beYJZasrbWQe/inOgiofIeVQ88J5Mw+hWBqNabPzskGy7R9+MEuFt/4AbcD6wBUeXw0Zexu/lhfmRDxd/So9AMw7w+jK4P5ekMGlGPT0mJPTkMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBfw1nxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBfw1nxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D34E1F000FF;
	Wed, 14 Oct 2026 02:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791946142;
	bh=VhItWomDTz+JfgqkqvE4Z8m4XK0vlJdjPRhQGuVtbE8=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=YBfw1nxekSA90YNOSggNZ0nNtfcZ6BtZw4MYYld3cnps0sT4lZZ0FU403OsZfUL72
	 p0Tm5GTBHwSQbEXP+386yyYGOeZ9UrE12eW+CuvDJlAs+28Q9hUQAxV3oLnuBTot8w
	 3/rt0Wa4SDOpoKoVhJn1eqK2lzK7ONxycIEfQS65bDIuzj+5ITIGl8i6i0AbduuIsD
	 /Lu48u9IF+O7+rJqsduqrGfq0iYtuZnVGyzlUJBu4CMstuu2DQTj3pzjnBDw5tTFYy
	 OyqRAVR26Uh2YLDgILl6FvHCMsC20ZT4ZAWTv50adWaQvOjeqCGNHDsAKPck9ZuhHm
	 KEXn9ho15Df5w==
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K. Petersen (Oracle)" <mkp@kernel.org>,  Can Guo
 <can.guo@oss.qualcomm.com>,  linux-arm-msm@vger.kernel.org,
  linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,  Manivannan
 Sadhasivam <mani@kernel.org>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: ufs: ufs-qcom: Don't define variable in
 the middle of the code
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
Message-ID: <yq1pkxdf148.fsf@mail.kernel.org>
References: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
Date: Tue, 13 Oct 2026 22:49:00 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Andy,

> While the C11 allows us to define variables in the code, we do not
> do this style (see more at [1]). Move the declaration to the top of
> the function.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
