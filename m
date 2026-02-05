Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBED308F23;
	Thu,  5 Feb 2026 20:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770324891; cv=none; b=VBwXh+DaV1E+jCkHqeJg+8nEwMf7ldhtDzZqU4K0VsAUWcC8gAbFsoqtcnyoTGIcPSG/lVYl3/VmebThPc2aQyudJrQotkXWpMlCvYnqKIkV282xUYIGiP+F+nh+hQjpzoFu7bXXeCyRw2ez2jkssRISwKqnOJXjaTtU72xDtEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770324891; c=relaxed/simple;
	bh=QCGEePM51IFrGcckX9+zNaK04MVj1phQo6eD/w44ZIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDDXDIAKTVg8E2Y6UQ9LZ+D8DIbfskqft1zjisiNqiLwn6GtFwG2iDHmW9Kn39LxJTBODOSuzJiy/8Wa7b6C23fJNv0E272yA41VwZp/mjgXMPYCm8SB1GKBNuzibzKHYUjaAybwNaonZVY15VZM2mPSxooX8tRaXb+30GogxgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DUEBxaH5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DUEBxaH5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9WkNCDLjrKmOzJKlCZsKv6sJAcu+pisPBJ2qYlKWt80=; b=DUEBxaH58hijGXYwfyIuTAfjiM
	iTCzQRgrTueOgAKWrcS3F6Lsm7CqGYvifruBqEZtf2Pt9iSWZtwap4jIvgszczMefPg4GtTQcwzce
	9+NpU1qd3beHwrG+j+aOPZk9yjEHPjPnpYTOhaT+RSaJHFHPfb2OYalmoI0Xr6XXZ6dajEZlRLRDi
	I0cW9+mFtHCDf9SIikZGcaF+OmgQooSLrOIV7H4uRYxPy/J+Q0DJyVaW0YCPg+HP+yRSgSSZKtAE8
	QEIAVarurLon0oCsNYty+QC2JAcvuzBNMpkA0rpSyl0g2v7/Sh3OsHaAVbDu+rozADefCVvPqbvJy
	+Sx076ag==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vo6N5-000000049Xj-2zqu;
	Thu, 05 Feb 2026 20:54:39 +0000
Date: Thu, 5 Feb 2026 20:54:39 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Documenting the correct pushback on AI
 inspired (and other) fixes in older drivers
Message-ID: <aYUDj5zge6amIkTv@casper.infradead.org>
References: <32e620691c0ecf76f469a21bffaba396f207ccb9.camel@HansenPartnership.com>
 <8075dab2-49db-408e-bff6-5de6b0b372cd@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8075dab2-49db-408e-bff6-5de6b0b372cd@acm.org>

On Thu, Feb 05, 2026 at 08:30:53AM -0800, Bart Van Assche wrote:
> We don't want to forbid tree-wide API changes, isn't it? See also
> Documentation/process/stable-api-nonsense.rst.

That's plainly not what James was talking about.  Tree-wide API changes
have an obvious benefit (... or if not, they'll be rejected).  The
question is what benefit does anyone receive from fixing an unlikely
memory leak in the ncr53c8xx driver?

