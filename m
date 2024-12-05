Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043271D278A;
	Thu,  5 Dec 2024 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390452; cv=none; b=evwYjYzVHC0PBXkyJ9bHi04FIXL/AxXjS/9B9Swg9WMyip/vkfEYiI5a2cFsuoanEf0soPAFkulkmPk/Z+4hTv0kiibDGheF1tzrlqeqTLwK5ZtiL2FMbxLBgVQu48L79uboEKY1FcqMOZi2Zz/gdSofUZgax5jUPReIceNoQMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390452; c=relaxed/simple;
	bh=nTGcyP5TWqKkb/7pYPENZ/fK1fUzm0PIWV3HS1RjUT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e85QGQ+GRPnCSgqZD9bvuIT3WHGG753Igp5FkMqJG9Z0sHjvMFTyQ8J60ASaiTvzjlIFAUePp9b/YBbDi07nUUbWHZL80npE2pgyZSLstLD6ulA0zCAT/WLVmpbl41f73uSRN61fMYOim2xOWZzj/I4g1x2o+MJoESG+susfpzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FckA/XhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FckA/XhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F67C4CED1;
	Thu,  5 Dec 2024 09:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733390451;
	bh=nTGcyP5TWqKkb/7pYPENZ/fK1fUzm0PIWV3HS1RjUT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FckA/XhEBXlPxwegqKxBpM73IRBGuzt3kdUlQ7UoVpM0uuErWu2SLF/Om7q/p3TN6
	 QxPlg5gtraLnA4s9WR7YAm8Xi306+PDHTC8201ZTUbWILRnpUwz2vqO6PUqTyjFV4B
	 WrXxEprcUM/0qUJYoGNXDwiZuVM83peC0iPSPZTiauumz6YExWKVXeeJYDq/gUuAye
	 h0CmJPcpU7MYrbp8daUSViMGem8rdaO5IXqMlt7ML1E6K8kuK4ipneTX8n0XHKB8PS
	 eL/m2waMKSo4x9+GkJylk0Z1GP4/FpgZ1kiZfZQnygKw2s8+NSyeqlihLdhPCAW8Mc
	 jPF+61mADDk7A==
Date: Thu, 5 Dec 2024 09:20:46 +0000
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Brian Norris <briannorris@chromium.org>,
	Julius Werner <jwerner@chromium.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, chrome-platform@lists.linux.dev,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/5] s390/sclp_config: use BIN_ATTR_ADMIN_WO() for
 bin_attribute definition
Message-ID: <Z1FwbmLjJVBAfK5l@google.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
 <20241202-sysfs-const-bin_attr-admin_wo-v1-2-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-2-f489116210bf@weissschuh.net>

On Mon, Dec 02, 2024 at 08:00:37PM +0100, Thomas Weiﬂschuh wrote:
> Using the macro saves some lines of code and prepares the attribute for
> the general constifications of struct bin_attributes.
> 
> While at it also constify the callback parameter.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
