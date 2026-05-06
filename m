Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5FB35A397;
	Wed,  6 May 2026 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778102697; cv=none; b=rbKjt7M5DWcm9060+asM8o10Fg9Yjbv68IIEzYJ4s3YjeESzOI25NHMbIGwwXmSCxn+ZM6M6pHx6A4H4Tx1ieLMW2BpJQr+B9j03u6I3BlOWQnOz3+Z9Xf6tc5xjQMrwDXmRY3Ih5hw5cF6W7F+k5QdWgfhs/dOy2QYzGlhUEOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778102697; c=relaxed/simple;
	bh=XyPxJfPyf0GdPyGr96MwQqjICS2aXF/AB6T7qNKrr/8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=Ifl2q614fGAiI/d3ysBTAEe2WLVMqExCEBgWqngpCMujhDJXBQyr/ncrOKUFKcrSWJvLQkBP+xIM5F+mwDoIgJ+N1qjL2e9MUNozFZEzoDzTrDs6QuZz+j+97iST/oIVgswgwnYf691hj3EBg/rOh7c6gz5msowYTO/7b7rMS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N6v0d4sH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N6v0d4sH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63937C2BCB0;
	Wed,  6 May 2026 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778102697;
	bh=XyPxJfPyf0GdPyGr96MwQqjICS2aXF/AB6T7qNKrr/8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=N6v0d4sHE8VSxC7zqCPU8NvyAVWyDGStGcQnoBbIYY/vKFrk6WWUlIxHmpnRdEA/V
	 +poSMbxdBaPJy2dg8IIYv4WmkKYp9Ttib05o9yudzRJE8g0a256xWfqqRUcwDqGe3O
	 ucClFN+6obVGZThlSsczy23T2ML9VhtxaG+c0D1yb8Is36jmYbuggq5P3f5gkXj902
	 pbkTW/LIUk3SdssbTNQQ4E1lGYBwwUtowyNxFff/G7y10PhhKkMYM+wXKd7PuIybaX
	 rdS+3yGXD0cKFtY7KQ+m1bNF5rURA5i6oBY3wjxo/LVjqc1u3qL3lV/PqxXjHbY6hQ
	 +QkcVfbIH8oLA==
Date: Wed, 6 May 2026 16:24:56 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Jeffery <djeffery@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Tarun Sahu <tarunsahu@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	=?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Jordan Richards <jordanrichards@google.com>,
	Ewan Milne <emilne@redhat.com>,
	John Meneghini <jmeneghi@redhat.com>,
	"Lombardi, Maurizio" <mlombard@redhat.com>,
	Stuart Hayes <stuart.w.hayes@gmail.com>,
	Laurence Oberman <loberman@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>, kexec@lists.infradead.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: Re: [PATCH 4/5] PCI: Enable async shutdown support
Message-ID: <20260506212456.GA880761@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+-xHTFj_J4r2oqG8cPOU_wx7pChjHt9SgyHzKbTD8+KgeSFXw@mail.gmail.com>

On Wed, May 06, 2026 at 05:10:19PM -0400, David Jeffery wrote:
> On Wed, May 6, 2026 at 2:28 PM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Wed, Apr 29, 2026 at 01:50:15PM -0400, David Jeffery wrote:
> > > Like its async suspend support, allow PCI device shutdown to be performed
> > > asynchronously to reduce shutdown time.
> > >
> > > Signed-off-by: David Jeffery <djeffery@redhat.com>
> > > Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> > > Tested-by: Laurence Oberman <loberman@redhat.com>
> > > Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> > > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >
> > Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> >
> > I'm concerned about tripping over driver issues, but it's a pretty big
> > benefit.  I think it's worth mentioning the "async_shutdown" module
> > parameter somewhere in the commit logs and putting an example in
> > Documentation/admin-guide/kernel-parameters.txt.
> 
> Sure, I can see about adding a document patch to it.
> 
> > Might even consider keeping in -next for a cycle+ and targeting v7.3.
> 
> I would be happy for it to spend as much time in linux-next as needed
> for people to be comfortable with the risk of odd interactions with
> all the pci drivers it will indirectly impact.
> 
> But I must admit my ignorance with some of the details of linux-next.
> Looking at the main code changes, the patchset would seem to want to
> go through driver-core to get to linux-next. But as far as indirect
> impact, it is the diverse collection of devices and drivers under PCI
> which are most affected by the changes. Is there a consensus on how to
> steward a patchset like this one into linux-next?

My guess is it should all go via the driver-core tree, given acks or
reviewed-by from the other subsystems it touches.
