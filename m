Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE1649B5A7;
	Wed, 23 Sep 2026 10:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160379; cv=none; b=nhgW23bK1a4clbQ3wh7xceIOOxaTYMKrub03AMXhcLFiAGqYgxBWYi0Vg1AY6tHKFDKs6OCmxhJsPYjV3ae7uHifmietEpNtCt63ZrSnjyHM27b9rDhmX58wTxIpOqwQ5gpUgq467CGBsS89o9LMGR57+JQmsnOD1yJGZrOiOjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160379; c=relaxed/simple;
	bh=zDpAXKywWj0CeIgSPsdqwqYzEKxLMJzvx/VQ6zhQi5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LcFepxDihJCww8jpI30VQVuSMRCZxtji1KsdkP1CtY4AknhPtZQrd9cf/Lqfmrij5KBjfOmukR/0chACt5px6yzyDUVJLZY+QYoA/3m+aM8VJmvmchuJ4k7RdiwiqJQrU3BlptKEbs63mbXHCm3WyCj8ln4FNNzwuggKyUXpoT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9wwoWf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9wwoWf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9A01F000FF;
	Wed, 23 Sep 2026 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160364;
	bh=avQvkl7s471m9YzAiZ0aOxUkynPxRjA0cpoopenOUeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g9wwoWf77TbsWX9wRO/ihI0CejOz4hXcaxSvPUFrGvt3SzGZM7ccxod1AuHJ3zvE7
	 Xaa3xPMJ3KRa33s48tnWNdKZ+K1NgetlUh9qYEUlNhQqbCwjs6LABeef079KpnA6gC
	 IwGP8FHwnYh3xbOIz72QiRLH+mrk9qloMvy5igKRJHIDG41tzeJR6BxOUeOkiFxL6P
	 qLorL4EvkMDxVRS8F8dY2bVFY7Assrx8rr9QkTldrbtO/8/X7ePU5rMxAvr/eNM234
	 PN8fF6kNvK7LjxpwQLBn7rB+l+u4On5nKjECcoM9fk6xtCwJRx/8BU37pHYnMqZnix
	 hFUiN6SGOUKqw==
Date: Wed, 23 Sep 2026 11:45:59 +0100
From: Lee Jones <lee@kernel.org>
To: Liang Haowen <nbg2974@gmail.com>
Cc: linux-leds@vger.kernel.org, Pavel Machek <pavel@kernel.org>,
	"Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
	Denis Benato <denis.benato@linux.dev>, Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Subject: Re: [RFC v7 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED driver
 for ROG NVMe enclosures
Message-ID: <20260923104559.GF3864833@google.com>
References: <20260923103015.2365773-1-nbg2974@gmail.com>
 <20260923103015.2365773-2-nbg2974@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923103015.2365773-2-nbg2974@gmail.com>

On Wed, 23 Sep 2026, Liang Haowen wrote:

> ASUS ROG external NVMe enclosures (ROG STRIX Arion, USB 0b05:1932) are
> plain USB mass-storage devices with no HID interface: the Aura LEDs
> hang off an ENE controller driven by vendor SCSI commands on the same
> LUN as the disk. The enclosure has 4 independently addressable LEDs,
> verified on hardware.
> 
> Register a scsi_device_handler matched by INQUIRY (vendor "ROG",
> model "ESD-S1C"); it does not claim the sdev (sd keeps owning the
> disk) and exposes each LED as a multicolor LED class device,
> /sys/class/leds/asus-arion-0-0-0-0::led-0 through led-3. The
> H:C:T:L part of the sdev name keeps the names unique when more than
> one enclosure is connected, with its colons flattened to dashes. The
> color section stays empty, since multicolor LEDs enumerate their
> palette via multi_intensity, and the four identical zones use the
> function name with a "-N" ordinal, as the naming section in
> Documentation/leds/leds-class.rst asks for.
> 
> Protocol: a 16-byte vendor CDB (opcode 0xec, 'A' 'S' signature,
> register index, argument count in cdb[13]). MODE 0x8021 (Static) must
> be written first in every sequence or the device ignores it; colours
> go to 0x8160 + 3 * led and 0x8100 + 3 * led (3 bytes, order R, B, G;
> both tables are written because firmware revisions pull from one or
> the other); APPLY 0x80a0 takes 0x01 to apply and 0xaa to save.
> 
> The CDB cannot go through scsi_execute_cmd(): it sizes the command
> via scsi_command_size(opcode), which maps vendor opcode 0xec to
> 10 bytes, so cdb[13] is dropped and the device silently ignores the
> write (GOOD status, no error). The request is built with
> scsi_alloc_request() instead, which initializes the scsi_cmnd parts a
> passthrough needs (command buffer, lengths, rcu head), with cmd_len
> forced to 16, mirroring what SG_IO does from userspace.
> 
> brightness_set only caches the colour and marks the LED in a per-zone
> dirty mask under a spinlock; led_mc_calc_color_components() runs under
> that lock too, because it writes the shared subled_info array and
> trigger events call led_set_brightness() without the led_access lock
> that serializes sysfs stores. A single work item per zone then
> snapshots the mask and colours and runs one ENE sequence for all
> pending LEDs (MODE, colour slots, APPLY, SAVE). Funneling every
> update through one work item keeps the sequences from interleaving
> between concurrent LED updates and batches multi-LED updates into a
> single APPLY/SAVE. A re-queued run with nothing pending returns
> before touching the device, so it cannot wear the flash with a
> pointless SAVE, and the lock keeps a colour write from being
> reordered after its dirty bit on weakly ordered architectures.
> 
> This is the monolithic out-of-tree version as verified on hardware;
> the Kconfig/Makefile/MAINTAINERS wiring lands with the agreed split
> into a SCSI transport helper and a shared ASUS Aura LED interface.
> 
> Signed-off-by: Liang Haowen <nbg2974@gmail.com>
> ---
>  drivers/leds/rgb/leds-asus-aura-scsi.c | 392 +++++++++++++++++++++++++
>  1 file changed, 392 insertions(+)
>  create mode 100644 drivers/leds/rgb/leds-asus-aura-scsi.c

Many (if not all?) of my review comments from v6 still stand.

I will not be reviewing this submission.

-- 
Lee Jones
