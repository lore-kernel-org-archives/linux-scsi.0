Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F9437160
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761154325; cv=none; b=s981XzMthmKWoh43rHbRzWbGquzsbSBgCSyXkkLJjbgzgcu3oC9YBrg1j92DL3u2Ngr0lZ/6JIe5bnHmqL1m6qoUQnBrQveVzIit+hYn6zTeUuC5muuevvvY/CPAHqr/PoJXqzPo6LP4XE2F/v9k3WO/aISHWB64H7wuN0N6pqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761154325; c=relaxed/simple;
	bh=eVgz5jQ/wbiiOwcuz0UkuxdrKa82hfDgahqc2cnD/IM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZd27h6uFhugpbXS3+ubgVZy+YBcioeu0oPLa0aVFRDZghzPcRjMID7sXJLT1bPIA9JMOdudGKjVFpRi9FR68JblHdPRoKGUZIBgqNo1IBSpBqL7xkuLpC/3p4wbag8pwOOh611cNy9hLvMaXfVYy3mu31xcUbp5D41/2PdSmsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKKW58GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKKW58GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58168C4CEE7;
	Wed, 22 Oct 2025 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761154325;
	bh=eVgz5jQ/wbiiOwcuz0UkuxdrKa82hfDgahqc2cnD/IM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DKKW58GWOk/upPo/eEIMMmtqNPULo7HDpuhA0wWgLexAKoG70mzBOHpdoUveEkAhg
	 PQ3kfa4JBoRgUqU4dSgF8ghT57+CmyLtKlmPKot6lOFJuhvVGlZ7HEuiP6snAOGjhP
	 AcLZSgHT5UNWWZ1dcCph+tmcBE3AG9PLz6FfL1HhSHkbK/kp9EDDazERcY0BWof6W3
	 8YvHPMi8Lh2ewfnVh1ir40VZATO2n1tesxB5uaB4bLmIR3M6ifj7/aV4oHIgi9nVqv
	 JaQfgFwpb831IRRAJcfzc5USnl1m+uZxx+qOMYEG4osZwvlJTX/RO0ObJDJRyKwSbT
	 PYElvV0NNFmJQ==
Date: Wed, 22 Oct 2025 23:01:57 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/8] Eight small UFS patches
Message-ID: <b5rfpnuhhewqmnaqa2uzivmo3byzommrjeanoawn5x5vargt2y@7vl7r2uw7kjo>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <yq1ms5j4raz.fsf@ca-mkp.ca.oracle.com>
 <ueff6kzx4imwyz4bqxgls34lg7mw6oyi73yyyyiqtitbxu7p2v@rhlok6yvytj7>
 <f761feb4-6b58-4778-9417-067993a484fd@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f761feb4-6b58-4778-9417-067993a484fd@acm.org>

On Wed, Oct 22, 2025 at 09:59:09AM -0700, Bart Van Assche wrote:
> On 10/22/25 4:04 AM, Manivannan Sadhasivam wrote:
> > On Tue, Oct 21, 2025 at 10:13:39PM -0400, Martin K. Petersen wrote:
> > > > This patch series includes two bug fixes for this development cycle
> > > > and six small patches that are intended for the next merge window. If
> > > > applying the first two patches only during the current development
> > > > cycle would be inconvenient, postponing all patches until the next
> > > > merge window is fine with me.
> > > > 
> > > > Please consider including these patches in the upstream kernel.
> > > 
> > > Applied to 6.19/scsi-staging, thanks!
> > 
> > Martin, could you please apply the first two patches to scsi-fixes? They are
> > fixing bugs introduced in v6.18-rc1.
> 
> I'm not sure that's the best approach. The more patches that are moved
> from scsi-staging into scsi-fixes, the more likely it becomes that Linus
> will have to resolve a merge conflict during the next merge window.
> 

I don't see how there will be merge conflict unless the remaining patches (3-8)
depend on fixes 1-2. In the cover letter, you also mentioned that the first two
patches are bug fixes targeted for v6.18-rc1.

I echoed the same thing since without these fixes, boards running v6.18-rc1 are
throwing a bunch of warnings making it inconvenient to use.

Ideally, we should try to fix the newly introduced warnings in the current
release itself without relying on stable maintainers to backport the fixes.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
