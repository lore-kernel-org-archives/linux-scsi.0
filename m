From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: If abort request comes in for command not known to LLD?
Date: Sun, 04 Mar 2012 04:25:52 -0600
Message-ID: <4F534330.10505@cs.wisc.edu>
References: <20120302154438.GE17975@beardog.cce.hp.com> <4F51372A.8080309@cs.wisc.edu> <20120302230156.GN17975@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40319 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab2CDK3W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2012 05:29:22 -0500
In-Reply-To: <20120302230156.GN17975@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org

On 03/02/2012 05:01 PM, scameron@beardog.cce.hp.com wrote:
> On Fri, Mar 02, 2012 at 03:10:02PM -0600, Mike Christie wrote:
>> On 03/02/2012 09:44 AM, scameron@beardog.cce.hp.com wrote:
>>>
>>> What should the LLD do if an abort request comes into the
>>> abort error handler from the midlayer for a command which is
>>> not known to the LLD?
>>>
>>> I see aic7xxx_osm.c handles it in this way in ahc_linux_queue_recovery_cmd():
>>>
>>> no_cmd:
>>>         /*
>>>          * Our assumption is that if we don't have the command, no
>>>          * recovery action was required, so we return success.  Again,
>>>          * the semantics of the mid-layer recovery engine are not
>>>          * well defined, so this may change in time.
>>>          */
>>>         retval = SUCCESS;
>>>
>>> Is that the right thing to do?  Seems a bit weird, but if that's
>>> the right thing to do, I can do that too.
>>>
>>
>> How do you hit this case?
> 
> I'm not quite sure.  I haven't hit it, but have a report of it on RHEL5u5
> with XFS filesystem under heavy load.  As a guess, I'd say a race between
> driver completing the command and a timeout in the mid layer.  In any
> case, it'd be nice to know what the kernel expects a driver to do if
> it should encounter that situation.
> 
>>
>> I think it is ok. The reasons I have seen drivers hit it this is that
>> race where the driver is completing a command while the timer code is
>> starting to go off, or the cmd has timed out then the driver completes
>> the command before the abort code is run.
>>
>> In those cases the driver has cleaned up its internal accounting because
>> the command has completed. At that point there is not much it can do
>> even if it wanted to. It does not have away to look up things like
>> internal tags/ids for the command.
> 
> Right, but it just seems weird for the driver to effectively say, "Sure,
> I aborted that command", when it did no such thing.  If the driver tells
> the kernel that a write got aborted when really it was completed, that
> seems like it could be kind of bad.

I see what you are saying. Yeah, it would be better if we had a new
error code for this, so we could return it from the abort handler. Then
scsi_error.c could also skip retrying it.

