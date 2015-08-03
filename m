From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/6] libata: Do not retry commands with valid autosense
Date: Mon, 3 Aug 2015 13:01:59 -0400
Message-ID: <20150803170159.GB24594@mtj.duckdns.org>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
 <1438347728-106434-2-git-send-email-hare@suse.de>
 <20150802154415.GA31100@mtj.duckdns.org>
 <55BF18ED.3000002@suse.de>
 <20150803150428.GE32599@mtj.duckdns.org>
 <20150803151826.GG32599@mtj.duckdns.org>
 <1438616563.2173.16.camel@HansenPartnership.com>
 <20150803155513.GI32599@mtj.duckdns.org>
 <55BF9B32.6030304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f172.google.com ([209.85.160.172]:32907 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbHCRCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 13:02:01 -0400
Content-Disposition: inline
In-Reply-To: <55BF9B32.6030304@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Hello, Hannes.

On Mon, Aug 03, 2015 at 06:47:46PM +0200, Hannes Reinecke wrote:
> At the moment NCQ autosense is mostly used to provide the host with more
> details for a failed I/O. The typical case here is (no small surprise)
> ZAC disks, which use autosense to inform the host about
> a malformed I/O.
>
> It is _not_ being used as a replacement for existing error behaviour,
> (ie link errors are not being signalled with that; how could they
> if there is no link?); in fact, during testing I"ve seen both, autosense

Hmmm?  Devices can report link error via TF bits and you're bypassing
TF analysis completley if sense data is present.

> I/O failures and normal I/O failures for which autosense is
> not set, and the normal error handling kicks in.
> 
> It's not that I've disable the original error handler completely,
> it's only bypassed for I/O failure where a sense code is provided.
> And the drive surely knows which error occurs, so we'd be daft not be
> using that.

The patches are altering EH actions in a very subtle way depending on
*how* an error is reported, not *what* is reported, which is a pretty
silly thing to do.  It makes things a lot more confusing to follow and
predict.  I really don't think this is an acceptable behavior.

> So I think disabling autosense completely is a bit extreme...

Please restructure the feature so that it doesn't interfere with the
usual EH behavior.  e.g. leave the EH actions alone unless explicitly
necessary but report detailed error information upwards.  If the extra
error information can be helpful in determining what EH actions to
take, factoring in that information can be helpful too but I'm not too
convinced that'd make a huge difference.

Also, please consider that ATA_QCFLAG_SENSE_VALID handling assumes
that the reporting device is an ATAPI device and the command in
question is not a regular IO one.  That's why EH ignores AC_ERR_DEV or
AC_ERR_OTHER if ATA_QCFLAG_SENSE_VALID is set.  This doesn't work out
for the new ATA usage at all.

For now, I've reverted the changes as this is actively detrimental.

Thanks.

-- 
tejun
