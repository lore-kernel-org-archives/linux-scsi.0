From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second
 generation of APM X-Gene SoC
Date: Wed, 1 Apr 2015 19:28:11 +0100
Message-ID: <20150401182811.GD10578@leverpostej>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
 <1427899682-10912-2-git-send-email-stripathi@apm.com>
 <20150401161336.GS9974@htj.duckdns.org>
 <20150401163116.GT9974@htj.duckdns.org>
 <20150401163956.GE24899@n2100.arm.linux.org.uk>
 <20150401170032.GC28616@e104818-lin.cambridge.arm.com>
 <20150401173029.GF24899@n2100.arm.linux.org.uk>
 <20150401181819.GD28616@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:38754 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbbDAS2R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2015 14:28:17 -0400
Content-Disposition: inline
In-Reply-To: <20150401181819.GD28616@e104818-lin.cambridge.arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "mlangsdo@redhat.com" <mlangsdo@redhat.com>, Suman Tripathi <stripathi@apm.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "olof@lixom.net" <olof@lixom.net>, "patches@apm.com" <patches@apm.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <tj@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>

On Wed, Apr 01, 2015 at 07:18:19PM +0100, Catalin Marinas wrote:
> On Wed, Apr 01, 2015 at 06:30:30PM +0100, Russell King - ARM Linux wrote:
> > On Wed, Apr 01, 2015 at 06:00:33PM +0100, Catalin Marinas wrote:
> > > The driver in general should not be ARM specific, though it runs on an
> > > ARMv8 platform. But looking at the patch it has some errata workarounds
> > > triggered based on the CPU id (MIDR). That looks dodgy as it doesn't
> > > even check the full ID, only the variant part.
> > 
> > Okay, it's not ARM but an ARM64 driver, so that's your territory, not
> > mine. :)
> 
> Well, feel free to enter this territory ;).
> 
> Anyway, what I meant is that such driver should not rely on CPU
> identification at all, especially since it does not require some
> specific CPU features but it tries to guess which SoC revision it is and
> which device (not CPU) bugs have been fixed. Better if they follow Mark
> R's idea to pass such information in DT for the device.
> 
> So maybe the revert is not too bad an idea.

The revert is completely sane.

FWIW, NAK to the original patch using the MIDR, or any other patch which
uses the MIDR for device (not CPU) errata workarounds.

Mark.
