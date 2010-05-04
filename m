From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: SYNCHRONIZE_CACHE command is not retried
Date: Tue, 04 May 2010 10:33:47 -0400
Message-ID: <1272983627.5255.10.camel@mulgrave.site>
References: <4BE011AF.7010509@suse.de>
	 <201005041453.11308.bernd.schubert@fastmail.fm>  <4BE01C0E.6010501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43077 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932575Ab0EDOdw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 10:33:52 -0400
In-Reply-To: <4BE01C0E.6010501@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2010-05-04 at 15:07 +0200, Hannes Reinecke wrote:
> Let's see what the powers that be say to this reasoning.

The actual powers that be are on holiday at the moment, I'm just the dog
sitter.  However, I don't think looping forever on unit attention is a
good idea (there are known error cases where devices return unit
attention forever).  If the device has device mapper stuff, there should
already be a device_handler module intercepting this sense code, so we
shouldn't switch paths because of it.  If there's no device mapper, I
think I'd really rather just add the usual number of retries to the sync
cache command.

I already said I'd be happy with a patch adding this, as well as one
allowing a user configurable timeout for the suspend problem.

James


