From: Mikael Pettersson <mikpe@csd.uu.se>
Subject: [BUG?] 2.5.71 removed request_module("scsi_hostadapter")
Date: Wed, 16 Jul 2003 13:45:36 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200307161145.h6GBjaSi025681@harpo.it.uu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from meryl.it.uu.se ([130.238.12.42]:11259 "EHLO meryl.it.uu.se")
	by vger.kernel.org with ESMTP id S271065AbTGPLaq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2003 07:30:46 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

While trying to figure out why my SCSI modules don't autoload
properly in 2.6.0-test1 and late 2.5 kernels, I found that
patch-2.5.71 removed scsi.c's request_module("scsi_hostadapter").
It seems that some driver model conversion changed scsi_register_device()
to scsi_register_{driver,interface}(), but the latter don't do
anything wrt autoloading the host adapter.

Is this an oversight or is it intensional?

I can probably work around this through "install" command
kludgery in /etc/modprobe.conf, but that's (a) is ugly, and
(b) probably won't work for configs with built-in SCSI core
but modular host adapter.

/Mikael
