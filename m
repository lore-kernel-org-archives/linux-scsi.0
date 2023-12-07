Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0604F5E9
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSHtWm6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B45C433C8;
	Thu,  7 Dec 2023 20:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701980684;
	bh=vIdTI1AF7m9ejqb1K8c1DTCDmELr7eIlklPYyn98FgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=eSHtWm6xyyMVr3FzNufT/zDQRwQi10Zg5Pyjf3kmGp3ur3e4LSAbSGNm549kVUbcY
	 bzjoOLKyYKHeVJAui/cJK1zSDGcTUnKqoTAzj+PLSdKEfVwsQHZbRMucgV6QC0wGA2
	 7HT4GMHKYNsrgLRNFzRA1Z1UmzNxVHy+R1oS3rlYzyEpl/BtjZkNgtmqBXJgvEYU2v
	 5C4k6ZUm8E3UPhO61TyvehTuYzso4uxIHymmnsR6rUPicMXjyOM5XbVfnVxjlODYyy
	 05S9XTnfhWOE4NbIfbT7HbXbF6+3jBrxPfDF77JWMHzntOimFGdOR+vLs/hfo/AruZ
	 ER2UFqk4pKHqg==
Date: Thu, 7 Dec 2023 14:24:42 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com, rajsekhar.chundru@broadcom.com,
	sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com
Subject: Re: [PATCH v1 2/4] mpi3mr: Support PCIe Error Recovery callback
 handlers
Message-ID: <20231207202442.GA764233@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFdVvOyCCEOLs4z-aOnuEdcnak52HqvNMUOQfv-6OwMTSkaGBg@mail.gmail.com>

On Thu, Dec 07, 2023 at 09:55:09AM -0700, Sathya Prakash Veerichetty wrote:
> On Wed, Dec 6, 2023 at 9:56 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
> > On Wed, Dec 06, 2023 at 08:55:11PM +0530, Ranjan Kumar wrote:
> ...

> > >  static int __maybe_unused
> > >  mpi3mr_suspend(struct device *dev)
> > >  {
> > >       struct pci_dev *pdev = to_pci_dev(dev);
> > > -     struct Scsi_Host *shost = pci_get_drvdata(pdev);
> > > +     struct Scsi_Host *shost;
> > >       struct mpi3mr_ioc *mrioc;
> > >
> > > -     if (!shost)
> > > -             return 0;
> > > +     if (mpi3mr_get_shost_and_mrioc(pdev, &shost, &mrioc))
> > > +             return -1;
> >
> > Is -1 really the best return value here?  It seems like usually a
> > negative errno is returned.
>
> The __suspend_report_result just prints the return value, so i thought
> -1 is fine as we already print a error message. Do you recommend to
> use another negative (non -1) number for differentiation between
> generic error and this?

In addition to being printed by __suspend_report_result() (if the
return value is non-zero), the return value is returned up the chain
by legacy_suspend(), pci_pm_suspend(), etc.

I would probably make mpi3mr_get_shost_and_mrioc() return an errno
like -ENODEV and then have mpi3mr_suspend() capture that and return
it.

These function pointers go in struct dev_pm_ops, and these functions
are documented as returning "error codes", which I interpret as errno
values:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/pm.h?id=v6.6#n258

Bjorn
