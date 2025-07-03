Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3A2ED143;
	Thu,  3 Jul 2025 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553219; cv=none; b=OLl+qz3ty5tQDnRUhBydu/g7RJX7lN3cbtYs+9OkCvaZLBhDVPslxofHRW1g5ivSl5vUN8QDbWr4rBASepuw8NRcCYoDWzs5WEnzkKG/Z15V6VX50Acyx/dARSZtjfVLRRSPN4Cn1KmPJwahNGfojPTouMdWzuctkGgZwYgYW3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553219; c=relaxed/simple;
	bh=r+0LQd+oT2vuY1QRIL0S0Y0f1ro4e0oSw7pF1tUqdJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9C8au7dOepnvmUq63FQ1vrDOpDBqVm6PLemlvzDNO1azUFnvbOX2diaWllKaWQOmcWLVejy3RSPJd2c4xYGwxJ4gTsG472HogAuRVGyH4uoDotF0FYSeZgsbFQnsxeQL7ctsWgb2GJv8IkMZy7ln4MHYVGPL9HKsmQ46zSOWw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFrRFAVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFrRFAVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9F7C4CEE3;
	Thu,  3 Jul 2025 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751553219;
	bh=r+0LQd+oT2vuY1QRIL0S0Y0f1ro4e0oSw7pF1tUqdJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NFrRFAVOCDiI+We352nHXLqRlAVp/XhGsjkgvW8LMVkrFyK700j0C5LDmEtw4cAM1
	 6bFJF1WKgetZ3ETh97t14gKbBImZuR+a1KH/BwB5AXu3hWsIyF32SMSuvD0Hj9zcNJ
	 +wHeqZAt7bazuBvxGrwMjspRwdKlRXhBjSXF3aaH4qHFNwmTW96yRPjVsKHif7lbTG
	 yY1VouGC51MWwX5QtzYXy+Tp6wllRKRwwUmbXZR0RCVHCcFr8ZbQz8aLy2yAPMRfJ4
	 1blkSi0iGmf55l9CASp8ygczj8prsraTlhLmZ5M/e4aVXtc09gvVZjRgVYkPI2rxvi
	 lC5Br2izen5xw==
Date: Thu, 3 Jul 2025 16:33:34 +0200
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
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>
Subject: Re: CVE-2022-50031: scsi: iscsi: Fix HW conn removal use after free
Message-ID: <2025070318-slinging-germproof-7da9@gregkh>
References: <2025061839-CVE-2022-50031-f2bc@gregkh>
 <563d1da8-abd8-48e6-9aab-5a4f13859995@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <563d1da8-abd8-48e6-9aab-5a4f13859995@huawei.com>

On Thu, Jul 03, 2025 at 10:16:58PM +0800, Li Lingfeng wrote:
> Hi, Greg
> 
> 在 2025/6/18 19:01, Greg Kroah-Hartman 写道:
> > From: Greg Kroah-Hartman <gregkh@kernel.org>
> > 
> > Description
> > ===========
> > 
> > In the Linux kernel, the following vulnerability has been resolved:
> > 
> > scsi: iscsi: Fix HW conn removal use after free
> > 
> > If qla4xxx doesn't remove the connection before the session, the iSCSI
> > class tries to remove the connection for it. We were doing a
> > iscsi_put_conn() in the iter function which is not needed and will result
> > in a use after free because iscsi_remove_conn() will free the connection.
> > 
> > The Linux kernel CVE team has assigned CVE-2022-50031 to this issue.
> > 
> > 
> > Affected and fixed versions
> > ===========================
> > 
> > 	Fixed in 5.19.4 with commit 0483ffc02ebb953124c592485a5c48ac4ffae5fe
> > 	Fixed in 6.0 with commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
> > 
> > Please see https://www.kernel.org for a full list of currently supported
> > kernel versions by the kernel community.
> > 
> > Unaffected versions might change over time as fixes are backported to
> > older supported kernel versions.  The official CVE entry at
> > 	https://cve.org/CVERecord/?id=CVE-2022-50031
> > will be updated if fixes are backported, please check that for the most
> > up to date information about this issue.
> > 
> > 
> > Affected files
> > ==============
> > 
> > The file(s) affected by this issue are:
> > 	drivers/scsi/scsi_transport_iscsi.c
> > 
> > 
> > Mitigation
> > ==========
> > 
> > The Linux kernel CVE team recommends that you update to the latest
> > stable kernel version for this, and many other bugfixes.  Individual
> > changes are never tested alone, but rather are part of a larger kernel
> > release.  Cherry-picking individual commits is not recommended or
> > supported by the Linux kernel community at all.  If however, updating to
> > the latest release is impossible, the individual changes to resolve this
> > issue can be found at these commits:
> > 	https://git.kernel.org/stable/c/0483ffc02ebb953124c592485a5c48ac4ffae5fe
> > 	https://git.kernel.org/stable/c/c577ab7ba5f3bf9062db8a58b6e89d4fe370447e
> > 
> Based on the details described in the linked discussion, I have concerns
> that this patch may not fully resolve the Use-After-Free vulnerability.
> Instead, it appears the changes could potentially introduce memory leak
> issues.

Great, then that is a different type of issue, and when fixed, would get
a different CVE assigned to it.

> Given these concerns, I'd recommend ​rejecting this CVE until we can
> thoroughly investigate and validate the complete solution.

This fixes a known issue, why would it be rejected as such?  The only
way we would reject this is if the upstream commit is reverted because
it was deemed to not be correct at all.  If you feel this is the case,
please work to get that commit reverted there first.

Otherwise just fix the new bug :)

thanks,

greg k-h
