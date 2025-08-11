Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5368427450;
	Mon, 11 Aug 2025 15:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754925679; cv=none; b=OezQvZK9LS+yJUQFiLs797ZIFxiZDtWcTecNO8dmrcQHHLRFuVLnwxy1cEQUc++lWx03WX6h4YZVul6X5ZKKQIyuULO+y/B2Cms7KjZ5h7x6d+8EScrNCvhm/tsLcmpwOLuvkawdTSUGgBHggBBUMLUGf3Os2Z1+M21o7+CmTiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754925679; c=relaxed/simple;
	bh=g+RQRkkszfbdSg7213zDy1B4rHgKQs0ei2wUNx1J994=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/rxRsHMNwoOAHT9ZP+q23iK5k1QulQiq3dLejzhamT4IVbwiZlYOF5gqWOy+R7ts6QfbUZXZbDSyFZQrDgueMJukh/pIbatsgtugqGFplxRHppc3Y8AZuZZUMA1SzZlFMxhzWfAVyahtHD5g9fWFjH5AEMF69THL9FK7m74WI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sfFIOhQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sfFIOhQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8E3C4CEED;
	Mon, 11 Aug 2025 15:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754925679;
	bh=g+RQRkkszfbdSg7213zDy1B4rHgKQs0ei2wUNx1J994=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sfFIOhQ68/RAxqoFcR1zZbNQku8UP72P9pjySP0IjiVSnY7MKFBUBugXgxgc3Fz8/
	 0UYpCldrrlKvDpeEkYvhZIow5V509Quwx3W7IJk1ax85DZD62cisbiXNi/ci+5/uDi
	 XmPO1yx18aALQeyBbAI160eFIuAR+1CtJdUlKKNSs6BBEcPgG2L5gAwJ1Py65vKquo
	 DDznEZZaSeWZ3jN7MpUbh7XjbckgobZHx5Vr6EieDyM7l82HCtRMdi85lPm6vkpEDK
	 IX0OT5CyrVBdgctsCCL3JnPZBhtXcV6PaEj+olR8qxixrx/K70Cf8kVuZnE7lnK+Bh
	 CH6jZQjrRbgFw==
Date: Mon, 11 Aug 2025 17:21:12 +0200
From: Greg Kroah-Hartman <gregkh@kernel.org>
To: Li Lingfeng <lilingfeng3@huawei.com>
Cc: cve@kernel.org, linux-kernel@vger.kernel.org,
	linux-cve-announce@vger.kernel.org, lduncan@suse.com,
	cleech@redhat.com, Mike Christie <michael.christie@oracle.com>,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
	yangerkun <yangerkun@huawei.com>,
	"zhangyi (F)" <yi.zhang@huawei.com>, Hou Tao <houtao1@huawei.com>,
	"yukuai (C)" <yukuai3@huawei.com>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	liumingrui@huawei.com
Subject: Re: CVE-2022-50031: scsi: iscsi: Fix HW conn removal use after free
Message-ID: <2025081122-supernova-ointment-e379@gregkh>
References: <2025061839-CVE-2022-50031-f2bc@gregkh>
 <563d1da8-abd8-48e6-9aab-5a4f13859995@huawei.com>
 <2025070318-slinging-germproof-7da9@gregkh>
 <1b283ae6-d972-4b85-bd4c-bfbb58492914@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b283ae6-d972-4b85-bd4c-bfbb58492914@huawei.com>

On Thu, Aug 07, 2025 at 09:35:25AM +0800, Li Lingfeng wrote:
> Hi, Greg
> 
> 在 2025/7/3 22:33, Greg Kroah-Hartman 写道:
> > On Thu, Jul 03, 2025 at 10:16:58PM +0800, Li Lingfeng wrote:
> > > Hi, Greg
> > > 
> > > 在 2025/6/18 19:01, Greg Kroah-Hartman 写道:
> > > > From: Greg Kroah-Hartman <gregkh@kernel.org>
> > > > 
> > > > Description
> > > > ===========
> > > > 
> > > > In the Linux kernel, the following vulnerability has been resolved:
> > > > 
> > > > scsi: iscsi: Fix HW conn removal use after free
> > > > 
> > > > If qla4xxx doesn't remove the connection before the session, the iSCSI
> > > > class tries to remove the connection for it. We were doing a
> > > > iscsi_put_conn() in the iter function which is not needed and will result
> > > > in a use after free because iscsi_remove_conn() will free the connection.
> > > > 
> > > > The Linux kernel CVE team has assigned CVE-2022-50031 to this issue.
> > > > 
> > > > 
> > > > Affected and fixed versions
> > > > ===========================
> > > > 
> > > > 	Fixed in 5.19.4 with commit 0483ffc02ebb953124c592485a5c48ac4ffae5fe
> > > > 	Fixed in 6.0 with commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
> > > > 
> > > > Please see https://www.kernel.org for a full list of currently supported
> > > > kernel versions by the kernel community.
> > > > 
> > > > Unaffected versions might change over time as fixes are backported to
> > > > older supported kernel versions.  The official CVE entry at
> > > > 	https://cve.org/CVERecord/?id=CVE-2022-50031
> > > > will be updated if fixes are backported, please check that for the most
> > > > up to date information about this issue.
> > > > 
> > > > 
> > > > Affected files
> > > > ==============
> > > > 
> > > > The file(s) affected by this issue are:
> > > > 	drivers/scsi/scsi_transport_iscsi.c
> > > > 
> > > > 
> > > > Mitigation
> > > > ==========
> > > > 
> > > > The Linux kernel CVE team recommends that you update to the latest
> > > > stable kernel version for this, and many other bugfixes.  Individual
> > > > changes are never tested alone, but rather are part of a larger kernel
> > > > release.  Cherry-picking individual commits is not recommended or
> > > > supported by the Linux kernel community at all.  If however, updating to
> > > > the latest release is impossible, the individual changes to resolve this
> > > > issue can be found at these commits:
> > > > 	https://git.kernel.org/stable/c/0483ffc02ebb953124c592485a5c48ac4ffae5fe
> > > > 	https://git.kernel.org/stable/c/c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
> > > > 
> > > Based on the details described in the linked discussion, I have concerns
> > > that this patch may not fully resolve the Use-After-Free vulnerability.
> > > Instead, it appears the changes could potentially introduce memory leak
> > > issues.
> > Great, then that is a different type of issue, and when fixed, would get
> > a different CVE assigned to it.
> > 
> > > Given these concerns, I'd recommend ​rejecting this CVE until we can
> > > thoroughly investigate and validate the complete solution.
> > This fixes a known issue, why would it be rejected as such?  The only
> > way we would reject this is if the upstream commit is reverted because
> > it was deemed to not be correct at all.  If you feel this is the case,
> > please work to get that commit reverted there first.
> Since it has been reverted by commit 7bdc68921481 ("scsi: Revert "scsi:
> iscsi: Fix HW conn removal use after free""), can this CVE be rejected
> now?
> 
> Links:
> https://lore.kernel.org/all/20250715073926.3529456-1-lilingfeng3@huawei.com/

Yes it can, it just got caught by my "find_reverts" script which I run
every so often:
	CVE-2022-50031 with sha c577ab7ba5f3bf9062db8a58b6e89d4fe370447e has been reverted, check to see if this is still a valid CVE

Will go reject it now, thanks!

greg k-h
