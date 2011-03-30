From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 07:28:34 -0400
Message-ID: <4D9313E2.6080006@gmail.com>
References: <1301373398.2590.20.camel@mulgrave.site>	<4D91BF90.8070909@redhat.com>	<1301445210.2731.14.camel@mingming-laptop>	<20110330021742.GL3008@dastard> <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <E32BEFA9-15DE-4169-B313-095920A4DF7A@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, lsf@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ric Wheeler <rwheeler@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 03/30/2011 07:13 AM, Theodore Tso wrote:
> On Mar 29, 2011, at 10:17 PM, Dave Chinner wrote:
>
>> Direct IO semantics have always been that the application is allowed
>> to overlap IO to the same range if it wants to. The result is
>> undefined (just like issuing overlapping reads and writes to a disk
>> at the same time) so it's the application's responsibility to avoid
>> overlapping IO if it is a problem.
> Even if the overlapping read/writes are taking place in different processes?
>
> DIO has never been standardized, and was originally implemented as gentleman's agreements between various database manufacturers and proprietary unix vendors.  The lack of formal specifications of what applications are guaranteed to receive is unfortunate....
>
> -- Ted

What possible semantics could you have?

If you ever write concurrently from multiple processes without locking, you 
clearly are at the mercy of the scheduler and the underlying storage which could 
fragment a single write into multiple IO's sent to the backend device.

I would agree with Dave, let's not make it overly complicated or try to give 
people "atomic" unbounded size writes just because they set the O_DIRECT flag :)

Ric

