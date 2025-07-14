Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CE42E371B;
	Mon, 14 Jul 2025 05:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752471128; cv=none; b=bW5X0zaP9GkrZt7pIo9kwnhvP9g03JudboF36THt0W7vVAbRa9JfXeK2zH2FyGg0zyijZaxhUSJAz0bvaqh8zovS03yTcrZbErhNDH2E19s00iRtdyqgrPYedS78pjHBkFAwM/V8ogmB+JvdQpIPmTIQYhJCGv5MfuTBANax7n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752471128; c=relaxed/simple;
	bh=yfaVU+lSpLlMuFlgrSfPg4gm6U5b74cQqwpMJk82EKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uTbRIZWN9+L4bhk80w/BNLw7KPMgiHMDhqsgAql9HGURUD7rXn880e3DnkWybT3Kn+QSWMFJl4eHBH4oW1iA43H/5bFtvUKIUaMYEPjFs289djGsOxQHDHG5t6YITO2m5TQYM2/Wjn8YExcX/OOOUwTTIkIFwOaXZBz5/PQus0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0coFcgs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0coFcgs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0E3C4CEED;
	Mon, 14 Jul 2025 05:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752471127;
	bh=yfaVU+lSpLlMuFlgrSfPg4gm6U5b74cQqwpMJk82EKc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0coFcgs/WskSg358Ev0+AeY5kJeOFchXOvcSYALbAyksoOF9mD0attL4oe/PqCh30
	 LN0GjfT6RIKEPendMZITARyuiCukzljLVJUw+VUkgbp6RRYejStbwUHCAKGSMYlRRR
	 GZvJB99NCQ56m8cyKcncSbsQI4emKoHQYAmqbLAA=
Date: Mon, 14 Jul 2025 07:32:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Khaled Elnaggar <khaledelnaggarlinux@gmail.com>, liyihang9@huawei.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-kernel-mentees@lists.linux.dev, shuah@kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi_sas: use sysfs_emit() in v3 hw show()
 functions
Message-ID: <2025071456-divisive-kindred-62f2@gregkh>
References: <20250712142804.339241-1-khaledelnaggarlinux@gmail.com>
 <2025071244-widely-strangely-b24c@gregkh>
 <3a88109e-25e4-4873-8143-242d24f2dfe0@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a88109e-25e4-4873-8143-242d24f2dfe0@acm.org>

On Sun, Jul 13, 2025 at 10:58:54AM -0700, Bart Van Assche wrote:
> On 7/12/25 7:43 AM, Greg KH wrote:
> > On Sat, Jul 12, 2025 at 05:28:03PM +0300, Khaled Elnaggar wrote:
> > > Replace scnprintf() with sysfs_emit() in several sysfs show()
> > > callbacks in hisi_sas_v3_hw.c. This is recommended in
> > > Documentation/filesystems/sysfs.rst for formatting values returned to
> > > userspace.
> > 
> > For new users, yes, but what's wrong with these existing calls?  They
> > still work properly, so why change them?
> 
> How about making this explicit in Documentation/filesystems/sysfs.rst?
> I think that would help to stop the steady stream of patches for
> converting existing sysfs show callbacks to sysfs_emit()/sysfs_emit_at().

Patches gladly accepted :)
