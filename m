From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Fri, 1 Apr 2011 14:49:23 -0700
Message-ID: <20110401214923.GD25355@noexit>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <1301445210.2731.14.camel@mingming-laptop>
 <20110330021742.GL3008@dastard>
 <1301521798.7449.65.camel@mingming-laptop>
 <20110331010049.GA7794@noexit>
 <1301693666.2720.257.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:57213 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab1DAVti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 17:49:38 -0400
Content-Disposition: inline
In-Reply-To: <1301693666.2720.257.camel@mingming-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>, Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Fri, Apr 01, 2011 at 02:34:26PM -0700, Mingming Cao wrote:
> > > I was thinking along the line to provide finer granularity lock to allow
> > > concurrent direct IO to different offset/range, but to same offset, they
> > > have to be serialized. If it's undefined behavior, i.e. overlapping is
> > > allowed, then concurrent dio implementation is much easier. But not sure
> > > if any apps currently using DIO aware of the ordering has to be done at
> > > the application level. 
> > 
> > 	Oh dear God no.  One of the major DIO use cases is to tell the
> > kernel, "I know I won't do that, so don't spend any effort protecting
> > me."
> > 
> > Joel
> > 
> 
> Looks like so -
> 
> So I think we could have a mode to turn on/off concurrent dio if the non
> heavy duty applications relies on filesystem to take care of the
> serialization.

	I would prefer to leave this complexity out.  If you must have
it, unsafe, concurrent DIO must be the default.  Let the people who
really want it turn on serialized DIO.

Joel

-- 

"Get right to the heart of matters.
 It's the heart that matters more."

			http://www.jlbec.org/
			jlbec@evilplan.org
