From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 30 Oct 2003 12:06:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067540819.4199.23.camel@pathost1.iomegacorp.com>
References: <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:61149 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262772AbTJ3THX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 14:07:23 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310301351380.1440-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: patmans@us.ibm.com, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> If in the future other routines decide to call __scsi_mode_sense(), they
> might not appreciate having len changed out from under them.

I concur.

I vote we make patch drivers/scsi/ to always calculate the op x5A
MODE_SENSE_10 length in the caller, so that __scsi_mode_sense only ever
reduces len by the 4 missing bytes of header, and never increases the
len.

Also I vote we execute the { memset(buffer, 0, len); } of
__scsi_mode_sense before it reduces len, so that we never introduce
indeterminacy by reducing len.

> I am very doubtful that this will work, or rather that it will work with
> all devices.  I've seen _lots_ of reports of USB devices that can't handle
> page 8, with all sorts of combinations of values for len attempted.

Are we confident that back then we tried the Win value for len?

Are we confident the Win value is x1C = header + optional block
descriptor + page?

Win may have logic different than sd for whether to bother trying page
x08.  Indeed, Win may often assume writable by default, and wait to go
boom later if a disk turns out to be read-only.

Pat LaVarre


