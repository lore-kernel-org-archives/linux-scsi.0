Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83561B644;
	Wed, 30 Apr 2025 21:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746048783; cv=none; b=F3f9bg2SWAbJebpiZV5vWOr3L9jIMLc1qOo6iyUXvK5EkBbd3mm0lMBARa5Pza7bEhl/QxznuGFIOU2TkNcrXNJoXVZau01CsdiP0UhbjXo7FcwBWBxbcPEU1B/3tQEj3srGzj7Ix0fk7rX8Hu5D6YFKr8kx8DCD0Hm9Mnq0D0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746048783; c=relaxed/simple;
	bh=VsGVHtp+9q6RGn5BQWuGa91tLEpsT3A6cFMcod1nM8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRnuBYxwL2kIwfL1nelZgGwBdX0gwfs2L8tHIBXCUUgZBV0zIQdwsDTJUa0BVOTPDg49KwqIelLcvoarsKl11GgM14swnrrjOPYPOxA14+ciBHyU6M8UQfE0w6I9ZCIY6VIeMs2/lTpIK9WCLB9QgpD7UOf9RXh9WhCHK7PEw7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M8n0hbSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M8n0hbSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A49C4CEE7;
	Wed, 30 Apr 2025 21:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746048783;
	bh=VsGVHtp+9q6RGn5BQWuGa91tLEpsT3A6cFMcod1nM8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M8n0hbSSdpyf1eIRlQ4DZlDTX6/nX9eZuzO5RwegBTytZUR5gsvTB0LhZE3b2zArW
	 2/atCY8Al5muERExki99lrnsZE5ErgoFDPKO4PsKYJC8zeN3c0NsdG6xF2EKvko4LV
	 ggqL1QW+jfBfJgQLc8jqwjfKiOi7V2P675phjacsVMCCh/Zqbz4UZ7fjeNUzO7cFqC
	 JAfarQ2JPYoTIy0nIiFdIWUSKnWWhOOrTZ79VV85VdrEy1c23r0qkScFmu6sTqnLX6
	 uxTcaXn4wGqf7zul7MtQ/nzfj4fH2yEe5oAZi9Pd0Jes1G+PFdLGWufvLqfpLwQKWa
	 QhHToo1n4o3WQ==
Date: Wed, 30 Apr 2025 14:32:59 -0700
From: Kees Cook <kees@kernel.org>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: sd: Avoid -Wflex-array-member-not-at-end
 warning
Message-ID: <202504301432.3A737A3B8F@keescook>
References: <aAwos0mLxneG9R_t@kspp>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAwos0mLxneG9R_t@kspp>

On Fri, Apr 25, 2025 at 06:28:35PM -0600, Gustavo A. R. Silva wrote:
> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
> getting ready to enable it, globally.
> 
> Use the `DEFINE_RAW_FLEX()` helper for on-stack definitions of
> a flexible structure where the size of the flexible-array member
> is known at compile-time, and refactor the rest of the code,
> accordingly.
> 
> Also, there is no need to use the DECLARE_FLEX_ARRAY() helper.
> Replace it with a regular flexible-array member declaration
> instead.
> 
> So, with these changes, fix the following warning:
> 
> drivers/scsi/sd.c:3195:50: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Looks good; thanks!

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
