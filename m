From: William Breathitt Gray <vilhelm.gray@gmail.com>
Subject: Re: [PATCH 0/4] Decouple X86_32 dependency from the ISA Kconfig
 option
Date: Wed, 13 Apr 2016 08:15:15 -0400
Message-ID: <20160413121515.GA23870@sophia>
References: <cover.1460379702.git.vilhelm.gray@gmail.com>
 <20160413072602.GA7629@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36118 "EHLO
	mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbcDMMPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2016 08:15:24 -0400
Content-Disposition: inline
In-Reply-To: <20160413072602.GA7629@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org

On Wed, Apr 13, 2016 at 09:26:02AM +0200, Ingo Molnar wrote:
>What's the practical motivation of this? What exact hardware is this for?
>
>Thanks,
>
>	Ingo

The PC/104 bus is equivalent to the ISA bus regarding software
communication. Many small form factor systems have a PC/104 bus where
PC/104 cards may be stacked. Nowadays, these systems are commonly
running 64-bit processors such as the Intel Atom.

I would like to utilize the ISA bus driver to support these PC/104
devices (see http://lkml.org/lkml/2016/4/7/418), but the ISA
configuration option has an arbitrary X86_32 dependency. Decoupling the
X86_32 dependency from the ISA configuration option will allow these
PC/104 drivers to build for 64-bit architectures.

The existing kernel drivers which I intend to utilize the ISA bus driver
in a X86_64 architecture for PC/104 support are the ACCES 104-DIO-48E
GPIO driver, the ACCES 104-IDI-48 GPIO driver, the ACCES 104-IDIO-16
GPIO driver, and the Apex Embedded Systems STX104 DAC driver. I have
several more PC/104 devices for which I wish to write drivers, but I
would like to resolve this ISA bus driver situation before submitting
new code.

William Breathitt Gray
