From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: RFC: move hosts.h, scsi.h
Date: Thu, 22 May 2003 23:04:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030522230414.A1916@pclin040.win.tue.nl>
References: <3ECD346D.2070302@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:7434 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S263268AbTEVUvL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 May 2003 16:51:11 -0400
Content-Disposition: inline
In-Reply-To: <3ECD346D.2070302@pobox.com>; from jgarzik@pobox.com on Thu, May 22, 2003 at 04:34:53PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 22, 2003 at 04:34:53PM -0400, Jeff Garzik wrote:

> I request permission to do the following:
> 
> 1) bk mv drivers/scsi/scsi.h include/linux
> 2) bk mv drivers/scsi/hosts.h include/linux/scsi_hosts.h
> 3) bk mv drivers/scsi/scsi_obsolete.h include/linux
> 4) create shell drivers/scsi/{...}.h that includes just-moved files, so 
> to preserve full driver source compatibility.
> 5) edit include/linux/scsi.h to include <linux/scsi_obsolete.h> not 
> "scsi_obsolete.h"
> 
> Objections/comments?

No doubt with the goal of removing all those ugly
	#include "../../scsi/hosts.h"

A good plan.

I think point 5) is superfluous.
(That is, I think by default "foo.h" is found in the directory
of the including file.)

Probably this would mean that usb/storage/Makefile no longer
needs -Idrivers/scsi, provided the "scsi.h" there is replaced
by <linux/scsi.h>.

Remains the vague objection: it is a bit confusing to have
several files of the same name. And in case some compilation
has both include/linux and include/scsi on the include path
there are ordering restraints. Maybe life will be easier
if you invent some other name like scsidefs.h.

Andries

