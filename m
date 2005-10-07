From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Thu, 06 Oct 2005 20:07:14 -0500
Message-ID: <1128647235.4623.28.camel@mulgrave>
References: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:64679 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030254AbVJGOrj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2005 10:47:39 -0400
In-Reply-To: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On Wed, 2005-10-05 at 16:19 -0700, Luben Tuikov wrote:
> I'd like to move sas_do_lu_discovery(struct domain_device *dev)
> into SCSI Core (as the comment therein says), for _new_ (non-legacy)
> devices, i.e. with newer FW.

Initially my reaction is not for the time being, for two reasons

1. The domain device as you have implemented it requires a lot of
infrastructure support.  I'd like to see this refined in the transport
classes to hone it before considering pulling it into the mid-layer
2. sas_do_lu_discovery() duplicates a lot of existing functionality, but
also lacks a lot of quirk processing.  I know the argument is that SAS
won't have any quirks, but I'd like to have this proven in the field
before I take it as read.

> It also handles devices who do not even respond
> to REPORT LUNS on either LU 0 or RL WLUN (like early prototype
> SES FW), in which case it would register LU 0 for them since
> this is where tasks are sent.

I'm sure you're aware that not responding on either LUN 0 or the report
luns WLUN is a violation of SAM  ... however, if we really already have
broken SAS devices with this problem, then you're welcome to expand
scsi_scan_target() to cope.

WLUN support is really the only piece that scsi_scan_target() doesn't
currently possess and, as has been discussed before, that only really
matters if we get a target that's not going to respond to an INQUIRY on
LUN0 (I expect most of them, even if they have no LUN0 will respond with
PQ 3 to the inquiry and thus be caught by scsi_scan_target() anyway).

However, to add WLUN support to scsi_scan_target() looks pretty simple:
If the transport supports > 256 LUNs and the initial INQUIRY comes back
SCSI_SCAN_NO_RESPONSE then fire off a WLUN report lun scan anyway.  By
all means, submit a patch to do this.

> P.S. REPORT LUNS is Mandatory as per SPC, so newer devices
> (SAS) support it.  Furthermore if their LUs are sparse they
> (really) support REPORT LUNS.

Actually, it's optional per SPC; it's mandatory in SPC-2 but *only* if
your device is multi-LUN; and it finally became mandatory for everything
in SPC-3 (or I should say "becomes" since SPC-3 isn't ratified yet).

James


