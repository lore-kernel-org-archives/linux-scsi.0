From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [PATCH]: Flexible timeout infrastructure
Date: 16 Jun 2004 12:04:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087405441.2067.25.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF28034F94EE@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24995 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264270AbUFPREt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 13:04:49 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94EE@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-16 at 11:58, Smart, James wrote:
> So why increment the retries counter at all ? 

So drivers can't return EH_RESET_TIMER forever. This really ties the
handling into the behaviour the user has requested.  The only wrinkle
was the no retry streaming commands.  The assumption is that a retry
doesn't actually happen under eh_timed_out, but only an attempt to
collect an existing command which may be delayed because of transport or
other problems the host knows about.

James


