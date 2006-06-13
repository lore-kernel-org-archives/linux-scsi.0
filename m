From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 16:44:16 -0500
Message-ID: <448F31B0.5000104@sgi.com>
References: <448DF5DA.3070800@sgi.com>	 <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com>	 <448EDCEB.50702@sgi.com>	 <1150221599.3441.54.camel@mulgrave.il.steeleye.com>	 <448F1403.6090903@sgi.com> <1150228960.3441.72.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:28827 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932340AbWFMVo2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 17:44:28 -0400
In-Reply-To: <1150228960.3441.72.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



James Bottomley wrote:
> On Tue, 2006-06-13 at 14:37 -0500, Michael Reed wrote:
>> Not really true as the transport holds off the error handler until the
>> transport dev loss timer expires.
>>
>> And afterwards, commands are returned immediately with DID_NO_CONNECT.
>> The device is never offlined (with my patch applied).
> 
> That was just a general examination of the options for retaining contact
> with the target.
> 
> It seems we both agree that returning an error is about the only viable
> option, in which case the user or application has to take a recovery
> action anyway, so there's no logical difference between what you propose
> and what we currently do as far as the application or filesystem is
> concerned.
> 
> The only difference is what happens if the device reappears.  However,
> since the application has to be modified in either case:  your patch to
> continually probe with I/O to see if the device has returned, 

I'm not suggesting that any application would probe with i/o, though
it may or may not be doing that today.  If it is, the difference is
that the i/o will have the possibility of success when the target
ultimately returns.  With the current code, the i/o will never, ever,
succeed.  (Without app change, of course.)

or the
> existing case to wait out the udev event that says the device is back it
> doesn't really buy us anything for the application.  

BTW, I consider "application" to include kernel code such as volume
managers and file systems.  The applications don't require any modifications
with the new patch.  They still get failure notification in either case.
They still fail to work while the target is disconnected.  They can choose
to terminate or not.

> Since the rest of
> our infrastructure is already event driven, or migrating that way, I
> really don't see value in introducing an anomaly like this purely for
> fibre channel.

It's tough on fibre channel, being first.  :)

Among the benefits of this patch is the purchase of time.  With the fc
infrastructure the way it is, you're assured of forcing developers to
"publish or perish".  That may be the intended desire.  It just doesn't
seem fair to the users who have to deal with this.  It makes sense to
me to implement the event driven infrastructure in such a way that
it's more complete when released.  If infrastructure is going to be
removed, then "applications" have to be adjusted to accommodate this.
It shouldn't be, oh by the way, your driver/app is now broken, hurry up
and fix it or your users will complain.  [End Of Rant].  My patch
buys time.  Change the default so that the remove on disconnect has
to be consciously overridden.  Remove the variable when the supporting
infrastructure is in place.  Put out a message indicating that the
option of not removing the infrastructure is "going away" in a future
release.  Provide an orderly transition.  Insure domestic tranquility.
Promote the general welfare.  :)  I'm happy to adjust the patch
to accommodate any of these suggestions if they are deemed acceptable.

Thanks for taking the time to consider and discuss this issue.  I see
your point and I've made mine.  I trust your judgment.

Thanks,
 Mike

> 
> James
> 
> 
