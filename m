Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA9C13B7A3;
	Thu, 23 May 2024 13:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469922; cv=none; b=nDPR/fJaD7EhYT0d/u4GTo+HpahvF8aRQBI1rihMi6Zm4tVVM/tdWVOrNRon9wgBJ6hCz3sAxdRoCiOtuJ8Z8DUqFwaGT5J4ickUIDk6ydMTgtBGAINoOAUUFY9MaQeeLWlqfU0hJypilzVEtL61D30wUaQtNW5kqUweGmj5qQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469922; c=relaxed/simple;
	bh=JAmwFzaap5dwtS2u3r9geyzuit74wHFIxsZmOJaqogw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDI9mOHQdmhr+vSiWcboS62cDW7Nrnkr2PNjSeofK1z0zIdTfkz1f0vRDhTRA3NqwZ31NOzoyfzTdQ5hGv1TPNFYEawDwiKjEv/hrNoxNLzRUKJ82UzRhlGfMAZ9wRXJu8obuKmoiG6zEnZtjeN5EZEuxGyRx1E+PYgwgBEhQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mz6JoNKO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mz6JoNKO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=y3A5uP3BduosUmrB0oOd18fdwRFowHv9bErt+acue+U=; b=mz6JoNKOCDr0sfQgIl6SGaeMIA
	6B71/oSjeqMU2CQhIRk9A9vYqd8EqHn5C/vJlhU9L1NOEEIvGvLzcs/BAnCYepF8Zsc6RWehe9UX5
	35PAO4JsocluGqaNDNP8fn6wRe2/U6szcsMZhghsXhCN/g0KRNDDrd4PE8aY+KO3Xn0hlsU23HvEI
	bYZ+5bMPVPtu6/JkGqRlFFFGaKPT+6/KhFNYBSers8IinQPtTgO8nNlB7nXwz3y4Vf4TiRDQ6dxMh
	k6Q9ZBsxRBArtKOKWtH+dsbL5tAbnoyUs5f+eP+obLeMnmQ6ZF1OQELYvrl57Tf8hcw44Jnp4MuA6
	F0HLL4+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sA8Eh-00000006KDs-0AvN;
	Thu, 23 May 2024 13:11:59 +0000
Date: Thu, 23 May 2024 06:11:59 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Avri Altman <Avri.Altman@wdc.com>
Cc: "hch@infradead.org" <hch@infradead.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] scsi: ufs: Allow platform vendors to set rtt
Message-ID: <Zk9Anwk1HEjUzSxc@infradead.org>
References: <20240523125827.818-1-avri.altman@wdc.com>
 <20240523125827.818-3-avri.altman@wdc.com>
 <Zk8-rwjFvgP714Mn@infradead.org>
 <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR04MB65758584960580363D43AED4FCF42@DM6PR04MB6575.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 23, 2024 at 01:09:25PM +0000, Avri Altman wrote:
> > On Thu, May 23, 2024 at 03:58:25PM +0300, Avri Altman wrote:
> > > Allow platform vendors to take precedence having their own rtt
> > > negotiation mechanism.  This makes sense because the host controller's
> > > nortt characteristic may vary among vendors.
> > 
> > Platform vendors have absolutelyt no business saying anything.
> > 
> > Fortunately that's not what you're actually doing, but I really don't understand
> > your vendor fetish.
> It was a specific request from MTK to allow override their host controller capabilities.

Then they need to submit a patch just like anyone who wants to improve
Linux.  And not trick their NAND supplier into adding an unused hook…
