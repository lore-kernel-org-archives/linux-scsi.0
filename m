From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: 03 Dec 2003 11:32:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070472758.1984.39.camel@mulgrave>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
	<1070464184.1771.33.camel@mulgrave>
	<yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:36615 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262965AbTLCRea (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 12:34:30 -0500
In-Reply-To: <yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Wed, 2003-12-03 at 11:03, Clay Haapala wrote:
> James, et al, do the SCSI layers retry on COMMAND ABORT?

Not at the moment.  We don't have a complex sense processing engine.
What we use is in scsi_error.c:scsi_check_sense(), but it's geared
towards codes usually returned from everyday devices.

If I were you, I'd have the driver return DID_PARITY (or, more simply
DID_ERROR, which will cause a (counted) retry.

> I don't believe the SCSI layers retry on HARDWARE ERROR -- this is a
> difference between how Solaris and Linux operate, for example, unless
> I am misunderstanding or have obsolete information.

That depends on how the error is signalled, but if we think a retry to
be futile, it won't be retried (although there isn't really a DID_ for
hardware error that we don't retry).

James


