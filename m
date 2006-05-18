From: Jens Axboe <axboe@suse.de>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Thu, 18 May 2006 09:21:35 +0200
Message-ID: <20060518072134.GX4197@suse.de>
References: <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org> <20060517073701.GE4197@suse.de> <446B3BE0.8040806@garzik.org> <20060517173729.GS4197@suse.de> <446B9C88.4030005@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <446B9C88.4030005@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 17 2006, Jeff Garzik wrote:
> Jens Axboe wrote:
> >I think we have a different opinion on what 'optional' is then - because
> >things can certainly work just fine the way they current do. And it's
> >faster, too.
> >
> >>infrastructure, you inevitably wind up with the following code pattern:
> >>
> >>	infrastructure code
> >>	send fully prepared request to hardware
> >>	infrastructure code
> >
> >But yes, you can make the code nicer for _some_ things with a
> >->queueone() type setup.
> 
> That ->queueone() maps the closest to what most hardware appears to 
> want: "attempt to push request onto an async hardware queue".
> 
> It also enables additional entry points for returning 'device busy' or 
> (in SCSI lingo) 'host busy'.  The ability to signal and handle random 
> transient conditions like that when hardware resources disappear is easy 
> to overlook, but its really powerful.

'queue a request' is certainly how most hardware works. The fact is that
->queueone() doesn't enable _anything_ that you cannot already do. In
fact it takes information _away_ from you, since you can no longer peek
at the queue and see if there's one more there for you to issue. The
only selling point for ->queueone() is that it makes it more logical to
structure the code layout for handling the issue.

Which is why I never added this helper. From the block layer
perspective, the driver can only really tell you three things:

- request issued, give me another one
- request not issued, transient error (meaning, call me with this
  request again in the future).
- request not issued, permanent error. kill this request.

A ->queueone() setup deals with returning the right issue error code, a
->queuemany() setup deals with calling the right function for the
condition.

-- 
Jens Axboe

