Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB39D1D4340;
	Thu,  5 Dec 2024 09:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390496; cv=none; b=rfev1Y7k4oyD3/lAeTogRhJ+wHFQThoE5YyjDVYzVQfTyvMGZQDPBRv8n3jZdvOpTVT9ImBXjvlTL6D3roW4iEkBrsc8IPQvPrQdJgmw98x0dyqO/1THlzCOELkjVLNVUjzvThfbTILJp9AncOGnvei5N5tmVJLOSCfsp3Au3FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390496; c=relaxed/simple;
	bh=0NtFK3oCzvBSihoOheuwFu9KzJvVPyvwejVb22YMDX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VS0XelSj88p/W3qjWuam62Ds/D/TqFKBHWR4EN/2af2Y+uh6xt6IxBcu6xz7z9uS1rG9l16PN67aTaLB0NYE/C6eKtTcHW1bkIt0OWm8s3xmvqj8wi7K1sFVF8HXY6+tu85cbn6b9YL4IygQ7UYAs2+F2P3ADs/18l3KWX5j4/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bO+iAcht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bO+iAcht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DA0C4CEDE;
	Thu,  5 Dec 2024 09:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733390495;
	bh=0NtFK3oCzvBSihoOheuwFu9KzJvVPyvwejVb22YMDX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bO+iAchtJ2xcasBhdzF+wbKSTg19ybb/JAHkdXYvclcrjO0D4X8bJ3DeLNUn2bEFa
	 77lJpJ0g3Pajml0kav68z3LlmOMFTdeTXhAtjxYw8F+oAacKePbD0UKw9UHzIMcqev
	 TvabFo0KBg2gviCqTfvyVJSA7M+9v5w237FTHKikw8hH5q8K4tncW5uvC4zwyHnzys
	 BtHac/HZX0UM+Kf69TC/JMuKcpkf83Lj3DCfPhTjX05rh/Eqn77fFYUts72J6jyaa8
	 29bEH6HxVThRRTUJK7Rj24nbhs18WAgJ6WPlYn9cXFCYWYTBplwHLHRuLnes8eWfid
	 QmTznu7igjaEA==
Date: Thu, 5 Dec 2024 09:21:30 +0000
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
Subject: Re: [PATCH 5/5] scsi: arcmsr: Use BIN_ATTR_ADMIN_WO() for
 bin_attribute definitions
Message-ID: <Z1FwmmFEDKeEgNRO@google.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
 <20241202-sysfs-const-bin_attr-admin_wo-v1-5-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-5-f489116210bf@weissschuh.net>

On Mon, Dec 02, 2024 at 08:00:40PM +0100, Thomas Weiﬂschuh wrote:
> Using the macro saves some lines of code and prepares the attributes for
> the general constifications of struct bin_attributes.
> 
> While at it also constify the callback parameters.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
