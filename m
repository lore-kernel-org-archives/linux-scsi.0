Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8333E31A07F;
	Thu, 15 Oct 2026 11:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792065051; cv=none; b=nsT6UcAA00M1s5doY8crVSeV1CZIS3jZwoX6mqWHu5OEFg6e5ktfsUFkPPDb4jBmjr4IZEc2nXrKKFkclfRwSZ5dH1wGYkdwNZpBRzztJ/UWT8JuallUO9/JX/EDZFJbruA1fVj6cIfbmm1dByDfPNzgRmEVmfVuXAM+aav5m1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792065051; c=relaxed/simple;
	bh=VSdHStomVn46F4ewruQ4QMhJT/fq+4WwDnwnLS9gKzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQidKskCANqX3kYyjE4UceRtoSby4SInsDTw56DONwP6cM8wJ/F218H9tqgqaV+slJB7G9WWYsz8pF24s8SAHuQIVgBLrdLV7KYeYKJ5e3fiDG91utjztFUi1CXPbCybYKsA/2yYPsXQ6PxZqhL7uL+FcyZ9DNaHB/W7DeyKC8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUK8s7P7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUK8s7P7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689D31F000C4;
	Thu, 15 Oct 2026 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792065049;
	bh=dJ4bhnxKo74R9ZM5Fm1e/unKSpya17F001qaVop7plU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JUK8s7P7SnzLUBf/a2RN7iwciGazWHAl6KIKTZSh0ogwXl/sONhLL19yeNbCXj73U
	 Kph3yZqY+JtINzB5/rRsBt4YdaYRMCxYibSRNUSxkkdmu/ZZ7rxXV/q9In60IzD54I
	 h2mOf3fnsmUUevoooPcGwe31+DnXRSJPHcByif53gioY31ZOC6gDtITC1ncPwI8+ar
	 3WCAr5FiUsfd+XbPx3Y88FId02tLGUs18oqCoj/rqia+m+ABHG+TYN4DsY/NIaynD7
	 zrctA26cKfHMMxd3T84Y9T+erE++R17oJswtkauKi0AVriBH96kcIryCUJJB+LTTXI
	 DW1q/6OqHovlA==
Date: Thu, 15 Oct 2026 12:50:43 +0100
From: Lee Jones <lee@kernel.org>
To: Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Marco Scardovi <scardracs@disroot.org>
Subject: Re: [RFC v9 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Message-ID: <20261015115043.GA1863739@google.com>
References: <20260925134010.2815025-1-nbg2974@gmail.com>
 <20260925134010.2815025-2-nbg2974@gmail.com>
 <179198503855.839288.7797731903424311774@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179198503855.839288.7797731903424311774@kernel.org>

On Fri, 25 Sep 2026, Lee Jones wrote:

> --- checkpatch.pl: clean (0 issues) ---
> 
> On Fri, 25 Sep 2026, Liang Haowen wrote:
> 
> > ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
> > plain USB mass-storage devices with no HID interface: the Aura LEDs
> > hang off an ENE controller driven by vendor SCSI commands on the same
> > LUN as the disk. The enclosure has 4 independently addressable LEDs,
> > verified on hardware.
> >
> > Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
> > model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
> > disk) and exposes each LED as a multicolor LED class device,
> > /sys/class/leds/asus-arion-0-0-0-0::led-0 through led-3. The
> > H:C:T:L part of the sdev name keeps the names unique when more than
> > one enclosure is connected, with its colons flattened to dashes. The
> > color section stays empty, since multicolor LEDs enumerate their
> > palette via multi_intensity, and the four identical zones use the
> > function name with a "-N" ordinal, as the naming section in
> > Documentation/leds/leds-class.rst asks for.
> >
> > Protocol: a 16-byte vendor CDB (opcode 0xec, 'A' 'S' signature,
> > BE16 register index, argument count in byte 13), modelled by
> > struct ene_cdb. MODE 0x8021 (Static) must be written first in every
> > sequence or the device ignores it; colours go to 0x8160 + 3 * led
> > and 0x8100 + 3 * led (3 bytes, wire order R, B, G; both tables are
> > written because firmware revisions pull from one or the other);
> > APPLY 0x80a0 takes 0x01 to apply; the controller also accepts 0xaa
> > to save the state to its flash, which this driver never sends: the
> > LED class interface is runtime state and does not promise persistence
> > across power cycles, and a save on every update would wear the
> > controller flash. The colour reverts to the stored default on power
> > cycle, like any other runtime-only LED.
> >
> > The CDB cannot go through scsi_execute_cmd(): it sizes the command
> > via scsi_command_size(opcode), which maps vendor opcode 0xec to
> > 10 bytes, so byte 13 is dropped and the device silently ignores the
> > write (GOOD status, no error). scsi_execute_cmd() also offers no way
> > to override the derived length. The request is therefore built with
> > scsi_alloc_request(), which initializes the scsi_cmnd parts a
> > passthrough needs, with cmd_len set to the CDB size, mirroring what
> > SG_IO does from userspace. A 5 s timeout and a single retry-less
> > quiet submission cover the register writes.
> >
> > The write payload is copied into a per-device buffer before it is
> > mapped with blk_rq_map_kern(), so no stack memory is ever mapped for
> > DMA (VMAP_STACK).
> >
> > brightness_set only caches the colour and marks the LED pending
> > under a spinlock; led_mc_calc_color_components() runs under that
> > lock too, because it writes the shared subled_info array and
> > trigger events call led_set_brightness() without the led_access lock
> > that serializes sysfs stores. A single work item per enclosure then
> > snapshots the pending LEDs and runs one ENE sequence for all of
> > them. Funneling every update through one work item keeps the
> > sequences from interleaving between concurrent LED updates and
> > batches multi-LED updates into a single APPLY. A re-queued run
> > with nothing pending returns before touching the device, so it
> > cannot wear the flash with a pointless SAVE, and the lock keeps a
> > colour write from being reordered after its pending flag on weakly
> > ordered architectures.
> >
> > This is the monolithic out-of-tree version as verified on hardware;
> > the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
> > into a SCSI transport helper and a shared ASUS Aura LED interface.
> >
> > Signed-off-by: Liang Haowen <nbg2974@gmail.com>
> > ---
> >  drivers/leds/rgb/leds-asus-aura-scsi.c | 404 +++++++++++++++++++++++++
> >  1 file changed, 404 insertions(+)
> >  create mode 100644 drivers/leds/rgb/leds-asus-aura-scsi.c
> 
> A driver source file without 'Kconfig' or 'Makefile' integration is dead code in
> the tree.  Either wire it up now or hold off on submitting until the rest of the
> pieces are ready.

Also:

Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
- [Low] leds: asus-aura-scsi: undefined function kzalloc_obj() causes build failure       
- [Low] leds: asus-aura-scsi: blk_rq_map_kern() missing required request_queue argument   
- [Low] leds: asus-aura-scsi: strscpy() called with missing size argument

Was this even tested?

-- 
Lee Jones
