From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [LSF/MM TOPIC] SCSI referrals support
Date: Thu, 20 Jan 2011 10:36:01 -0600
Message-ID: <1295541361.3014.8.camel@mulgrave.site>
References: <4D385C0A.3000901@suse.de>  <4D385F69.5060209@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1ATQgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2011 11:36:07 -0500
In-Reply-To: <4D385F69.5060209@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2011-01-20 at 17:14 +0100, Douglas Gilbert wrote:
> On 11-01-20 05:00 PM, Hannes Reinecke wrote:
> > Agenda topic proposal:
> >
> > SCSI referrals support has already been discussed at last year's LSF
> > conference. However, the solution proposed there would not support
> > failover and would require quite a lot of changes to multipathing.
> >
> > To enable failover it might be an idea to handle the LUN directly in
> > multipathing. This would require eg:
> > - request splitting
> > - I/O alignment handling
> > - SCSI unit attention handling
> >
> > I would be giving a short overview/presentation of the current
> > state of the art, the shortcomings on the original proposal,
> > and would like to invite a discussion on how to best support
> > SCSI referrals.
> 
> IMO a worrying aspect of the changes associated with SCSI
> referrals is that sense data can now be returned with any
> SCSI status (i.e. not just CHECK CONDITION). How well would
> the SCSI subsystem cope with that? I know that the sg driver
> (and probably bsg) would need changes, as would my libsgutils
> library used by sg3_utils.

Well, not necessarily.  It scuppers plans to try to use the sense buffer
more efficiently, but right at the moment, we can receive sense for any
command.  We only actually look at it on a check condition return, but
that's easily updated.

As I read the standard, referrals sense data on successfully completed
commands is only really relevant to mp implementations, so it looks like
the mid-layer should ignore it anyway (as it would now) but provide a
hook for the device handlers to see it if they wanted.

James


