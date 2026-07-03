Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A5AC3BCD2C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075492; cv=none; b=ut8ziJYBWBe1yY0BCsQfHa501chhjQNsTCOn+BrBrTcCa39ANeLgtuhHxQWVHH7LoNkGcP+Z30brGPg4rqFNK52u75Y6TjQYA6e7+bqWOuBQEF7P/w8BPOdmut8hd6E2zmUj3AJ6ojlE2O7WLzSqnbaGp26k6X5qJCYFW7CXmQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075492; c=relaxed/simple;
	bh=c+zCa9CkU+kTSDpZSbqGGu4xZi0Sv6gBc7dZ83YNKW4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W+CyEzdX6JKtfeDF3iNgKufLuZp0OYTdobz5Hy028MNMFazjD3kcQjNdEwJa0djxoY9OWiBwaV8KVxMHPsUbqpCowcm0SF3YlJdVCu7J1wEcY34HRxtDtmhcC7d0Lfq5PuK4BVGTf2Kt+n+MSj840IhMWGWJsjXwBSfbu4gJRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jWlHXC1Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jWlHXC1Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAAF1F000E9;
	Fri,  3 Jul 2026 10:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075491;
	bh=W8O3xYy+ZxUH8FdLaJBo9quSTYsqyBpci2J9h/ZTCmM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jWlHXC1QTbpPZacTrBSceGjcIN2YQM/XMKLqDDiTKse8ifU2eBa/xY2btP+OvI2Cy
	 0BclZyg74Vb5TWF8+wX0lblkIORZVBRFOEggjpCZCO5fXw0bwwN134ofSlsGgHmuN7
	 e+QGbkg8CnQ0L9mcbQx+qMYzFAlyTBY/XFQPqFBAYavKPaXfJaK1HXlVh0X5OBXzjF
	 jwUqEb53PKHgB6nF0yi45KKP711Svm3AE9L53d3L+s2cVtqCggnIFXh+h8eK96nD8F
	 k2ktD0NxkPQze6qVwqYm2AGhttOaP/Id6niOAHkXhvaTFGC6VSJDjahZHNH3czN9MZ
	 izxRurzIl6XCg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/13] libmultipath: Add sysfs helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-9-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:44:50 +0000
Message-Id: <20260703104450.DEAAF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mpath_iopolicy_store() does not clear cached paths when the I/O po=
licy changes, contradicting the commit message and leaving stale I/O routin=
g state.
- [Low] Unused 'count' parameter in mpath_iopolicy_store().
--

commit e168713423f62d0ecfcf0e0b0c9ed72180e1f19b
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add sysfs helpers

This commit adds sysfs helpers for the libmultipath driver sysfs code. It
includes helpers to get/set I/O policies, show device paths per NUMA node,
and handle attribute groups.

>     Note that mpath_iopolicy_store() has a update callback to allow same
>     functionality as nvme_subsys_iopolicy_update() be run for clearing pa=
ths.

[Severity: High]
Does this description match the implementation? The code doesn't seem to pr=
ovide
the callback parameter mentioned here.


> diff --git a/lib/multipath.c b/lib/multipath.c
> index 6d2e1186a10f8..4945f2d847fbf 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
[ ... ]
> +static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
> +		int new)
> +{
> +	int old =3D READ_ONCE(*iopolicy);
> +
> +	if (old =3D=3D new)
> +		return;
> +
> +	WRITE_ONCE(*iopolicy, new);
> +
> +	pr_info("iopolicy changed from %s to %s\n",
> +		mpath_iopolicy_names[old],
> +		mpath_iopolicy_names[new]);
> +}
> +
> +bool mpath_iopolicy_store(enum mpath_iopolicy_e *iopolicy,
> +				const char *buf, size_t count)
                                                 ^^^^^^^^^^^^

[Severity: Low]
This isn't a bug, but is the count parameter needed here? It doesn't
appear to be used in the function body since sysfs_streq() is used for the
string comparison.

> +{
> +	int i;
> +
> +	for (i =3D 0; i < ARRAY_SIZE(mpath_iopolicy_names); i++) {
> +		if (sysfs_streq(buf, mpath_iopolicy_names[i])) {
> +			mpath_iopolicy_update(iopolicy, i);

[Severity: High]
Does changing the I/O policy via sysfs leave stale paths cached under the o=
ld
policy rules?

Neither mpath_iopolicy_store() nor mpath_iopolicy_update() accept a callback
function pointer, nor do they clear the paths themselves. As a result, driv=
ers
adopting this API have no mechanism to hook into the change to acquire
subsystem locks or clear active paths.

> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D8
