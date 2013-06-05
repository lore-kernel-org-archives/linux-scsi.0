From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Wed, 5 Jun 2013 17:55:34 -0400
Message-ID: <20130605215534.GB2737@logfs.org>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
 <1369389050-118628-5-git-send-email-hare@suse.de>
 <20130525050842.GA6973@infradead.org>
 <51A086AF.5050609@suse.de>
 <20130525084222.GA27576@infradead.org>
 <51A08AAE.1060501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59400 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079Ab3FEXYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 19:24:47 -0400
Content-Disposition: inline
In-Reply-To: <51A08AAE.1060501@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>

On Sat, 25 May 2013 11:55:58 +0200, Hannes Reinecke wrote:
> >
> It should be possible to move the code into scsi_lib and just have
> small hooks for the individual transports to use this.

We have done something a bit tasteless and unconditionally enabled
your new error handling for all scsi drivers.  That solved a rather
serious problem for us and the subset of scsi drivers we actually
exercise seems to be doing fine.  Maybe we could add a hook into
scsi_times_out() that does the unconditional thing if users opt-in by
setting CONFIG_I_MIGHT_BREAK_STUFF or so.

We also have a scsi error injector now that should allow testing your
patches on any hardware, including kvm.  On a trial run the system
eventually rebooted (likely through a hung task timeout, haven't
checked) with the old error handling and lost a single drive with your
new code.  Awesome!

So my vote is for ignoring the remaining bits and pushing forward.
Your code is too useful to wait another half year.

And we should brush up the error injector and send it out as well.
Testing your code on cheap hardware would be nice.

J=C3=B6rn

--
He who knows others is wise.
He who knows himself is enlightened.
-- Lao Tsu
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
