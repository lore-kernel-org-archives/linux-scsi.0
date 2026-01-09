Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C41335083;
	Fri,  9 Jan 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969520; cv=none; b=LUwnk5QtMZ4pYHY+62PF9Ulhre+nwEg565OP7H3jC3TckAUzDKM2lBXdmZAcwXqmoSR0veaY8z/8JY7OK0ewStM2oFTf9YmLd4pdmyTVqI5wKB9Aa3wc0ZpTgdBtBnBvBnuACTd5rWmfVvevCXpldqKPSsomREmpeMjlPsXFzPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969520; c=relaxed/simple;
	bh=mz9CIOeDx7tDlGV5jTs4HnrR4XfuKFkB3ExjztCHx2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RuCfL1HZqyTo+ZsxZ0UyYFYbq86Q/RIGBwfrYeB3AJc+jNB8jokviODlBHXFRoYmIhGZjHKbtT8syFHF3+PLaTuN5+u3DYk5+iMbweAmXuni3AAcl3x0/1sDagoxYrSycEOxhF320EuyJB57Gt7A9QiW31m9AFqVnsxCaq5wmzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbASOiSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbASOiSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4B7C4CEF1;
	Fri,  9 Jan 2026 14:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767969520;
	bh=mz9CIOeDx7tDlGV5jTs4HnrR4XfuKFkB3ExjztCHx2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fbASOiSgq2PTLPnHqOuUcdQ29rufvQW5tHMu+xfbSTNUpU0ghJ8Q0+PIL6rQHAyxM
	 3oLbRtPR8dByQsa/+voQ0ndjtQCVbBwnmW32UjFyO257UBi3tkxiolUAV37TkSzmU5
	 9Zcrx6cYROYsohDQ15hcjMWRWNewlfUR+byIR5rRiS2Z8FtnLas17DpUX07JFjt5vH
	 GuashWlG9a6YVWRBAY1Oxfq/buQBuZ7M1RVmncdXbvIUv5dXsytG4Cxwq6wL59ugAn
	 voZgIB+Nnl7cm+HLHVTR5kEZhebb1EYvdUDwhE0IwIbtDFI9/Wo38Jo3zVHTA0QS/U
	 twDxAq0skog2g==
Date: Fri, 9 Jan 2026 07:38:37 -0700
From: Keith Busch <kbusch@kernel.org>
To: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@infradead.org>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
	leonro@nvidia.com, kch@nvidia.com,
	LKML <linux-kernel@vger.kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
	ojaswin@linux.ibm.com
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Message-ID: <aWES7e7iB9DoZSg7@kbusch-mbp>
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org>
 <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
 <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
 <aWD7j3NR_m6EyZv1@fedora>
 <ab7635d7-70e7-4906-bdcf-90006d7edf85@linux.ibm.com>
 <aWELGGBf1Sl3RK6k@fedora>
 <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>

On Fri, Jan 09, 2026 at 07:53:00PM +0530, Venkat Rao Bagalkote wrote:
> On 09/01/26 7:35 pm, Ming Lei wrote:
> 
> Apologies for back and forth. But I did apply the whole patch. Below is the
> git diff from my machine. Let me know, if I am missing anything.

Are you saying that this bug is preventing you from even compiling the
requested kernel patches? If so, you need to revert to a kernel that was
successful, then recompile and install the new kernel with Ming's
suggestions.
