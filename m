From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Some fixes for the SRP driver
Date: Wed, 17 May 2006 07:54:13 -0700
Message-ID: <ada7j4k7ld6.fsf@cisco.com>
References: <20060513044445.GQ12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:64554 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S1750809AbWEQOyQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 10:54:16 -0400
In-Reply-To: <20060513044445.GQ12272@parisc-linux.org> (Matthew Wilcox's message of "Fri, 12 May 2006 22:44:45 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Thanks, I queued up most of this for 2.6.18.

 >  - You might consider moving this driver to drivers/scsi.  It's actually
 >    fairly small compared to most scsi drivers, and basically you've got
 >    two files plus Kbuild/Kconfig machinery.  Seems a bit silly, plus
 >    people would notice this scsi driver more readily.

Yeah, it's a valid point.  On the other hand, it's also an infiniband
driver.  It's kind of like the ieee1394 sbp2 driver -- both fish and
fowl ;)

 >  - I'm not convinced you need the target list/lock I mention above.
 >    The Scsi_Host structure has a list of associated targets, although
 >    I don't see a good iterator for them right now.

It's a little different than that.  Confusingly enough, the SRP driver
uses a scsi_host for each target port it connects to, and then has a
higher-level private structure for each host adapter with a list of
target ports.  That list is what's being protected.

The reason for using a full scsi_host for a target port is so that we
can limit the number of commands sent to a target port from the
midlayer (because the number of outstanding work requests on a given
connection is what is limited).

 - R.
