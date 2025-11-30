Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9858A1B81D3;
	Sun, 30 Nov 2025 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764495569; cv=none; b=c7Kqxjkn2ZZVEkE1aIBuQ5sI5vgpcGe+G5YEH0mYprFU/r4fHSJGNsqgEfO/MkCidyw4jV+ONy146nuF19bMhsWWT+yDAO1UodO7Ecrla3i7KGDkTw80qyCBas4ZLyW+M3DhOh+SALkDtZ0k9NaGU/BECcScUX+v9tXsK2uD0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764495569; c=relaxed/simple;
	bh=mQbQ2cZmFxszuRclgqXAXnQ+uqiuaRYG92tj8MasWco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EwRA6FCNeB1fAWdX7YHLagCYl5Wk4zHeVC9jcOSCsBxJjGH90LP0hd+YdhKQhagTPw4QTzDCid8Deg9ElKlTqsqs1mmDeNc+pUJz58FXU98T/Wd9vA+u/izUmKe0TW5zlpqPJnv8L5yICEoUB7p5KnmFd4PRMvQhH95KqGspR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jVUPMoME; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jVUPMoME"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=fn+UgMy5samCTakK7kGqcHPeI7Vh0MMuflOrj65j4fI=; b=jVUPMoMEXNYUwTbCpRddcHUd9w
	BmuURHMWcmbFvpRMXwZm5M964wUL3bVISFQ5WNHCBdCcX8Uc79B/VeAOew4ddc3bmi23CaWtItMUy
	tCjTICeXrYhZSAIPmBKR/5KbXWveFiH19fXAnRxr5GUh5JT/+/tgvw5r4Z/M3iKS4sSHwXC8g9ypv
	1OVY1SMLOuNDHDzdfxRbM49BgSKh+y+ckE2nyhFu4e3b7o3Q6AYJHAKMdrgKrlD6AvJqZ816tUsO4
	aPsNQeTWzTsL8HrwrbitC+HUOmS56fWPwHkjE8MuTEhEwE1hLb3Fa4C69q+0DmqKzptPmUdfjmqG7
	pH1lSH2g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1vPdtK-007NLZ-Tc; Sun, 30 Nov 2025 09:38:51 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id CD63BBE2EE7; Sun, 30 Nov 2025 10:38:49 +0100 (CET)
Date: Sun, 30 Nov 2025 10:38:49 +0100
From: Salvatore Bonaccorso <carnil@debian.org>
To: yukuai@fnnas.com, 1121006@bugs.debian.org, colyli@kernel.org,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: Filippo Giunchedi <filippo@debian.org>, linux-block@vger.kernel.org
Subject: Re: Bug#1121006: raid10 and component devices optimal_io_size
 0xFFF000 results in array optimal_io_size 0xFFF00000
Message-ID: <aSwQqV2sEHaxQMVg@eldamar.lan>
References: <aR3KLd0kR43NeuwT@esaurito.net>
 <aR33hJMYzJOXUhgp@eldamar.lan>
 <aR8pDIXtWf+kPfO9@esaurito.net>
 <aSBGfk4C0gQPca0P@esaurito.net>
 <aR3KLd0kR43NeuwT@esaurito.net>
 <a89ad1f4-f961-4913-910e-39f2cc6ee925@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a89ad1f4-f961-4913-910e-39f2cc6ee925@fnnas.com>
X-Debian-User: carnil

Hi Yu,

[apologies for the maybe overlong list of recipients, reason see below]

On Sun, Nov 23, 2025 at 10:54:55AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2025/11/21 19:01, Filippo Giunchedi 写道:
> > Hello linux-raid,
> > I'm seeking assistance with the following bug: recent versions of mpt3sas
> > started announcing drive's optimal_io_size of 0xFFF000 and when said drives are
> > part of a mdraid raid10 the array's optimal_io_size results in 0xFFF000.
> >
> > When an LVM PV is created on the array its metadata area by default is aligned
> > with its optimal_io_size, resulting in an abnormally-large size of ~4GB. During
> > GRUB's LVM detection an allocation is made based on the metadata area size
> > which results in an unbootable system. This problem shows up only for
> > newly-created PVs and thus systems with existing PVs are not affected in my
> > testing.
> >
> > I was able to reproduce the problem on qemu using scsi-hd devices as shown
> > below and on https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1121006. The bug
> > is present both on Debian' stable kernel and Linux 6.18, though I haven't yet
> > determined when the change was introduced in mpt3sas.
> >
> > I'm wondering where the problem is in this case and what could be done to fix
> > it?
> 
> You can take a look at the following thread.
> 
> Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt - Yu Kuai <https://lore.kernel.org/all/a3a98a81-16e9-2f3c-b6e5-c83a0055c784@huaweicloud.com/>

Thanks for pointing that out, I will leave context further down as
well intact.

mpt3sas folks, block-layer experts the above thread seems to have been
stalled recently, do you have any input on the way forward or if
indeed mpt3sas driver is behaving as expected here as well?

Filippo recently reported an issue while setting up a system at
wikimedia, https://bugs.debian.org/1121006 and
https://phabricator.wikimedia.org/T407586 for full context.

Regards,
Salvatore

> 
> > thank you,
> > Filippo
> >
> > On Thu, Nov 20, 2025 at 02:43:24PM +0000, Filippo Giunchedi wrote:
> >> Hello Salvatore,
> >> Thank you for the quick reply.
> >>
> >> On Wed, Nov 19, 2025 at 05:59:48PM +0100, Salvatore Bonaccorso wrote:
> >> [...]
> >>>>          Capabilities: [348] Vendor Specific Information: ID=0001 Rev=1 Len=038 <?>
> >>>>          Capabilities: [380] Data Link Feature <?>
> >>>>          Kernel driver in use: mpt3sas
> >>> This sounds like quite an intersting finding but probably hard to
> >>> reproduce without the hardware if it comes to be specific to the
> >>> controller type and driver.
> >> That's a great point re: reproducibility, and it got me curious on something I
> >> hadn't thought of testing. Namely if there's another angle to this: does any
> >> block device with the same block I/O hints exhibit the same problem? The answer is
> >> actually "yes".
> >>
> >> I used qemu 'scsi-hd' device to set the same values to be able to test locally.
> >> On an already-installed VM I added the following to present four new devices:
> >>
> >> -device virtio-scsi-pci,id=scsi0
> >>
> >> -drive file=./workdir/disks/disk3.qcow2,format=qcow2,if=none,id=drive3
> >> -device scsi-hd,bus=scsi0.0,drive=drive3,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> >>
> >> -drive file=./workdir/disks/disk4.qcow2,format=qcow2,if=none,id=drive4
> >> -device scsi-hd,bus=scsi0.0,drive=drive4,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> >>
> >> -drive file=./workdir/disks/disk5.qcow2,format=qcow2,if=none,id=drive5
> >> -device scsi-hd,bus=scsi0.0,drive=drive5,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> >>
> >> -drive file=./workdir/disks/disk6.qcow2,format=qcow2,if=none,id=drive6
> >> -device scsi-hd,bus=scsi0.0,drive=drive6,physical_block_size=4096,logical_block_size=512,min_io_size=4096,opt_io_size=16773120
> >>
> >> I used 10G files with 'qemu-img create -f qcow2 <file> 10G' though size doesn't
> >> affect anything in my testing.
> >>
> >> Then in the VM:
> >>
> >> # cat /sys/block/sd[cdef]/queue/optimal_io_size
> >> 16773120
> >> 16773120
> >> 16773120
> >> 16773120
> >> # mdadm --create /dev/md1 --level 10 --bitmap none --raid-devices 4 /dev/sdc /dev/sdd /dev/sde /dev/sdf
> >> mdadm: Defaulting to version 1.2 metadata
> >> mdadm: array /dev/md1 started.
> >> # cat /sys/block/md1/queue/optimal_io_size
> >> 4293918720
> >>
> >> I was able to reproduce the problem with src:linux 6.18~rc6-1~exp1 as well as 6.12.57-1.
> >>
> >> Since it is easy to test this way I tried with a few different opt_io_size values and
> >> was able to reproduce only with 16773120 (i.e. 0xFFF000).
> >>
> >>> I would like to ask: Do you have the possibility to make an OS
> >>> instalaltion such that you can freely experiment with various kernels
> >>> and then under them assemble the arrays? If so that would be great
> >>> that you could start bisecting the changes to find where find changes.
> >>>
> >>> I.e. install the OS independtly on the controller, find by bisecting
> >>> Debian versions manually the kernels between bookworm and trixie
> >>> (6.1.y -> 6.12.y to narrow down the upsream range).
> >> Yes I'm able to perform testing on this host, in fact I worked around the
> >> problem for now by disabling LVM's md alignment auto detection and thus we have
> >> an installed system.
> >> For reference that's "devices { data_alignment_detection = 0 }" in lvm's
> >> config.
> >>
> >>> Then bisect the ustream changes to find the offending commits. Let me
> >>> know if you need more specific instructions on the idea.
> >> Having pointers on how the recommended way to build Debian kernels would be of
> >> great help, thank you!
> >>
> >>> Additionally it would be interesting to know if the issue persist in
> >>> 6.17.8 or even 6.18~rc6-1~exp1 to be able to clearly indicate upstream
> >>> that the issue persist in upper kernels.
> >>>
> >>> Idealy actually this goes asap to upstream once we are more confident
> >>> ont the subsystem to where to report the issue. If we are reasonably
> >>> confident it it mpt3sas specific already then I would say to go
> >>> already to:
> >> Given the qemu-based reproducer above, maybe this issue is actually two bugs:
> >> raid10 as per above, and mpt3sas presenting 0xFFF000 as optimal_io_size. While
> >> the latter might be suspicious maybe it is not wrong per-se though?
> >>
> >> best,
> >> Filippo
> 
> -- 
> Thanks,
> Kuai
