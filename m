From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 10:07:43 -0400
Message-ID: <1301493824-sup-9308@think>
References: <1301373398.2590.20.camel@mulgrave.site> <4D91BF90.8070909@redhat.com> <1301445210.2731.14.camel@mingming-laptop> <20110330021742.GL3008@dastard> <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu> <4D9313E2.6080006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:63011 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1C3OJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2011 10:09:04 -0400
In-reply-to: <4D9313E2.6080006@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>, lsf <lsf@lists.linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ric Wheeler <rwheeler@redhat.com>

Excerpts from Ric Wheeler's message of 2011-03-30 07:28:34 -0400:
> On 03/30/2011 07:13 AM, Theodore Tso wrote:
> > On Mar 29, 2011, at 10:17 PM, Dave Chinner wrote:
> >
> >> Direct IO semantics have always been that the application is allowed
> >> to overlap IO to the same range if it wants to. The result is
> >> undefined (just like issuing overlapping reads and writes to a disk
> >> at the same time) so it's the application's responsibility to avoid
> >> overlapping IO if it is a problem.
> > Even if the overlapping read/writes are taking place in different processes?
> >
> > DIO has never been standardized, and was originally implemented as gentleman's agreements between various database manufacturers and proprietary unix vendors.  The lack of formal specifications of what applications are guaranteed to receive is unfortunate....
> >
> > -- Ted
> 
> What possible semantics could you have?
> 
> If you ever write concurrently from multiple processes without locking, you 
> clearly are at the mercy of the scheduler and the underlying storage which could 
> fragment a single write into multiple IO's sent to the backend device.
> 
> I would agree with Dave, let's not make it overly complicated or try to give 
> people "atomic" unbounded size writes just because they set the O_DIRECT flag :)

We've talked about this with the oracle database people at least, any
concurrent O_DIRECT ios to the same area would be considered a db bug.
As long as it doesn't make the kernel crash or hang, we can return
one of these: http://www.youtube.com/watch?v=rX7wtNOkuHo

IBM might have a different answer, but I don't see how you can have good
results from mixing concurrent IOs.

-chris
