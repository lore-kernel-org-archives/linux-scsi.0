From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fwd: Kernel Oops with Adaptec 1460D (PCMCIA SCSI-Controller)
	and Kernel 2.6.0
Date: 08 Jan 2004 13:05:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073585142.2915.31.camel@mulgrave>
References: <20040108112905.B14674@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:64983 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265880AbUAHSFw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 13:05:52 -0500
In-Reply-To: <20040108112905.B14674@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-01-08 at 06:29, Russell King wrote:
> Could someone look into this - it seems that it's more of a scsi
> bug than a pcmcia bug.

The problem seems to be this code in aha152x.c:

#ifndef PCMCIA
#define driver_template aha152x_driver_template
#include "scsi_module.c"
#endif

Since it's still behaving as a legacy driver (by calling
register_scsi()), it needs the aha152x_driver_template.legacy_hosts list
initialised (which is done in scsi_module.c).

The true fix would be to convert aha152x to the new API.  However, a
quick fix is probably to add

	INIT_LIST_HEAD(&s.legacy_hosts);

just before the call to aha152x_probe_one() in aha152x_stub.c

James


