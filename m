From: Andreas Jellinghaus <aj@leogic.com>
Subject: Re: [PATCH 2.6 ] MPT Fusion driver 3.01.03 update
Date: Thu, 25 Mar 2004 15:54:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <pan.2004.03.25.14.54.52.188405@leogic.com>
References: <0E3FA95632D6D047BA649F95DAB60E57040DB6D7@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.224.249]:18338 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S263177AbUCYOyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Mar 2004 09:54:54 -0500
Received: from list by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1B6WFw-00083I-00
	for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 15:54:52 +0100
Received: from 62.245.182.10 ([62.245.182.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 15:54:52 +0100
Received: from aj by 62.245.182.10 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 25 Mar 2004 15:54:52 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

appart from using a lot of memory, is there any reason
not to compile the ISENSE option into the kernel?
will it work compiled it?

config FUSION_ISENSE
        tristate "Enhanced SCSI error reporting"
        depends on MODULES && FUSION && m
        ---help---
          The isense module (roughly stands for Interpret SENSE data) is
          completely optional.  It simply provides extra English readable
          strings in SCSI Error Report(s) that might be generated from the
          Fusion MPT SCSI Host driver, for example when a target device
          returns a SCSI check condition on a I/O.  Without this module
          loaded you might see:
...
          Say M for "Enhanced SCSI error reporting" to compile this optional mod
ule,
          creating a driver named: isense.

          NOTE: Support for building this feature into the kernel is not
          available, due to kernel size considerations.


changed to "depends on FUSION" this option compiles fine.

Could you messure once how much memory this option will consume,
put that into the configuration text, and only discourage users
to link it into the kernel, but not prevent them from doing so?

Sometimes security is more of an issue than a few kb of memory.
I don't want modules on server machines and if it works fine
compiled in, the Kconfig shouldn't prevent it.

Still if it works compiled in, and you don't want to change
the option, you could add a comment to the Kconfig like
	# don't change it, won't work compiled in.
or
	# if you change this and compile it into the kernel,
	# it will still work as far as we know. it will use
	# about 500MB of your precious ram.

Regards, Andreas

