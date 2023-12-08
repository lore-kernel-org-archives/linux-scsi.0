Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CF44A32
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 05:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lcp0z1Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9013DC433C7;
	Fri,  8 Dec 2023 05:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702013798;
	bh=mVdL+hSiaypb7UZGEHfzAERRsf1Q9lNQPKgfGI436YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lcp0z1Qb7IPGjoLbqhT/1+AY8NP2B3KEY8SYOxcERtQmtI3oawnnpVLkFoQ4PBXAh
	 9qo8WOkKvDm2pTlX3UJVEcgKyUwejH+tOcUTOeZMmfhk3nSXk0OmMbIgKRtoxauHJf
	 1EurDlePYZ96dK4qUPLbXUiDsnM4mW+ULyWE2vdg=
Date: Fri, 8 Dec 2023 06:36:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, rafael@kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers: base: Introduce a new kernel parameter
 driver_sync_probe=
Message-ID: <2023120856-empathy-debtless-06b2@gregkh>
References: <20231206115355.4319-1-laoar.shao@gmail.com>
 <2023120644-pry-worried-22a2@gregkh>
 <CALOAHbDtFKDh7C0NYeZ0xBV1z3AsNBDdnL7qRtWOrGbaU7W9VQ@mail.gmail.com>
 <2023120724-overstep-gesture-75be@gregkh>
 <CALOAHbAbU8At_iPVCiz9M8=jiGQ_BYFupCbVwsm=d9te85pAyg@mail.gmail.com>
 <2023120704-conducive-junkman-2e3f@gregkh>
 <CALOAHbBUu-oa_wb-PCBdn+vs1k1ZddGhVJg2UuVx912wGWoLkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbBUu-oa_wb-PCBdn+vs1k1ZddGhVJg2UuVx912wGWoLkQ@mail.gmail.com>

On Thu, Dec 07, 2023 at 08:36:56PM +0800, Yafang Shao wrote:
> On Thu, Dec 7, 2023 at 8:12 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Dec 07, 2023 at 07:59:03PM +0800, Yafang Shao wrote:
> > > On Thu, Dec 7, 2023 at 6:19 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > On Wed, Dec 06, 2023 at 10:08:40PM +0800, Yafang Shao wrote:
> > > > > On Wed, Dec 6, 2023 at 9:31 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > > >
> > > > > > On Wed, Dec 06, 2023 at 11:53:55AM +0000, Yafang Shao wrote:
> > > > > > > After upgrading our kernel from version 4.19 to 6.1, certain regressions
> > > > > > > occurred due to the driver's asynchronous probe behavior. Specifically,
> > > > > > > the SCSI driver transitioned to an asynchronous probe by default, resulting
> > > > > > > in a non-fixed root disk behavior. In the prior 4.19 kernel, the root disk
> > > > > > > was consistently identified as /dev/sda. However, with kernel 6.1, the root
> > > > > > > disk can be any of /dev/sdX, leading to issues for applications reliant on
> > > > > > > /dev/sda, notably impacting monitoring systems monitoring the root disk.
> > > > > >
> > > > > > Device names are never guaranteed to be stable, ALWAYS use a persistant
> > > > > > names like a filesystem label or other ways.  Look at /dev/disk/ for the
> > > > > > needed ways to do this properly.
> > > > >
> > > > > The root disk is typically identified as /dev/sda or /dev/vda, right?
> > > >
> > > > Depends on your system.  It can also be identified, in the proper way,
> > > > as /dev/disk/by-uuid/eef0abc1-4039-4c3f-a123-81fc99999993 if you want
> > > > (note, fake uuid, use your own disk uuid please.)
> > > >
> > > > Why not do that?  That's the most stable and recommended way of doing
> > > > things.
> > >
> > > Adapting to this change isn't straightforward, especially for a large
> > > fleet of servers. Our monitoring system needs to accommodate and
> > > adjust accordingly.
> >
> > Agreed, that can be rough.  But as this is an issue that was caused by a
> > scsi core change, perhaps the scsi developers can describe why it's ok.
> >
> > But really, device naming has ALWAYS been known to not be
> > deterministic, which is why Pat and I did all the driver core work 20+
> > years ago so that you have the ability to properly name your devices in
> > a way that is deterministic.  Using the kernel name like sda is NOT
> > using that functionality, so while it has been nice to see that it has
> > been stable for you for a while, you are playing with fire here and will
> > get burned one day when the firmware in your devices decide to change
> > response times.
> 
> I agree that using UUID is a better approach. However, it's worth
> noting that the widely used IO monitoring tool 'iostat' faces
> challenges when working with UUIDs. This indicates that there's a
> significant amount of work ahead of us in this aspect.

That indicates that iostat needs to be fixed as this has been an option
that people rely on for 20+ years now.  Or use a better tool :)

thanks,

greg k-h
