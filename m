Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447811B4F3E;
	Thu,  5 Dec 2024 09:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733390439; cv=none; b=Q21FrdbIQXufUGXZKClTsbXExscV50vwU9kz4sBUdyayKFVYHmgTysK/NAggHn/fx7cg859/hZls8EekqdgU7N91WgN7BuCgccmRICUQrl1KpGUi3acMPuZHixjjjaAjx7E7BvvGtsQd36AKDfyB88ExS78wrlmSTCchElly+Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733390439; c=relaxed/simple;
	bh=QjLPaoFnOl8nQT0shBLP2oEUk6t3cO+Cr9MiwxrNv90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ufBbHetuqIsEhDCpSQ96d24bZcsojR8qQQ26DI0viB+k4d42ExVShe2e330aDhxezyLDgWc2FKw7j/ie9D916hsZZ4QHdyxahg3tYhjfakLRERZzqK4I5j0P605R7rSuy9KCqsgRjowta/VYMdDHLmb2nMG5xLtOp5uiIuDVLuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyjoR7Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyjoR7Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC96AC4CED1;
	Thu,  5 Dec 2024 09:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733390438;
	bh=QjLPaoFnOl8nQT0shBLP2oEUk6t3cO+Cr9MiwxrNv90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eyjoR7Hvl58VxupQPMKipr4q/IRsG8OVhqhhDLhHOzE3PPmRHst2FDPTTYBPyHxuK
	 9YPu9FHKegN1u3QsVfQON/ctQlWbl20Ax/DtT6KBgsvaiqDbdgszm2m8tkmQvxp/j6
	 KttXSDrjW8lXJXusvIx0Z1eN51OoVMusSh8IXWnOmajNfnZaiHfqoWztzb37E7Wqfv
	 F2iY+V6PBxFNpywM9ba5jqmoFCsCVFYASHJvk0QLe++6Chglo09h5/ETr0sBMnMQ8m
	 YAQxGoH+qdMK1tfct7nTzvcxtevJ/DPYHwXPFAnVQF0ZpOYZ41OIgwst1LzyRqelMd
	 l88ABA/G7o2cA==
Date: Thu, 5 Dec 2024 09:20:33 +0000
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
Subject: Re: [PATCH 1/5] sysfs: add macro BIN_ATTR_ADMIN_WO()
Message-ID: <Z1FwYQFCK_eRkcRD@google.com>
References: <20241202-sysfs-const-bin_attr-admin_wo-v1-0-f489116210bf@weissschuh.net>
 <20241202-sysfs-const-bin_attr-admin_wo-v1-1-f489116210bf@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241202-sysfs-const-bin_attr-admin_wo-v1-1-f489116210bf@weissschuh.net>

On Mon, Dec 02, 2024 at 08:00:36PM +0100, Thomas Weiﬂschuh wrote:
> The macros BIN_ATTR_RO/BIN_ATTR_WO/BIN_ATTR_WR and
> BIN_ATTR_ADMIN_RO/BIN_ATTR_ADMIN_RW already exist.
> To complete the collection also add BIN_ATTR_ADMIN_WO.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
