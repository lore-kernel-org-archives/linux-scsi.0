From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 17:00:52 +0200
Message-ID: <519CDDA4.2050100@redhat.com>
References: <1360163761-8541-1-git-send-email-pbonzini@redhat.com> <519C674A.50700@redhat.com> <20130522093249.GC3466@mtj.dyndns.org> <519C959A.3090100@redhat.com> <20130522100212.GE3466@mtj.dyndns.org> <519C9CBC.3050003@redhat.com> <20130522134134.GA15189@mtj.dyndns.org> <519CD234.40608@redhat.com> <20130522143019.GA18541@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130522143019.GA18541@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 22/05/2013 16:30, Tejun Heo ha scritto:
> * Separate fixes from additions.  Transform existing code so that the
>   visible behavior doesn't change but the required fix can be
>   implemented on top.  Explicitly note what's going on in the commit
>   messages.

Been there, done that.  Have you read the commit messages *at all*?

Patch 2: "Right now, there is still just one bitmap and the mask is
ignored, so there is no semantic change yet".

Patch 3: "This patch already introduces some semantic change, albeit
very limited; [...] a few commands are now forbidden for devices of type
other than TYPE_ROM, where they are reserved or vendor-specific".

> * Fix the frigging CVE bug that you've been waving around and do
>   *just* that.

Perhaps you've missed that this is v2, not v27.  Tell me a place in the
original review where you've told me to split the series.

> * Add the frigging "count me out" feature that you want for your use
>   case.  It isn't controversial and is what you need and the
>   maintainer can apply to the point where [s]he thinks acceptable.

Sure.  Except I had sent it six months ago, and it lied unreviewed
despite your acks for two months.  It is in the archives waiting to be
picked up.

> * If for whatever reason you have to add more command codes to the
>   exception table, do them with explicit justifications.  How the hell
>   "the vast majority of the commands are added because Linux itself is
>   using them" a proper justification?   How are they used for what
>   reason and why is adding them beneficial?

For example, WRITE SAME is used to discard blocks.  If a Linux guest
wants to discard blocks, it may send WRITE SAME.  If a disk advertises
support for WRITE SAME, it is not nice if WRITE SAME then fails because
of a stupid whitelist that was designed for CD-ROMs.

And another disk instead works because it uses UNMAP instead of WRITE
SAME.  It's a support nightmare, perhaps the cause is obvious to me by
the time it reaches me, but that takes time---which is wasted time for
everyone involved.

>   How many times have I
>   asked you to give at least some useful use cases?  And WTF is "vast
>   majority", what about others then?

The others are not in v2, or are sent by udev, or were added to the
standard for a reason and applications are using them (e.g. COMPARE AND
WRITE).

>   Why do you need this at all if
>   you have the "count me out" knob in the first place?

Because the "count me out" knob needs privileges.  It opens up way, way
more than what these patches do.

And the frigging patch to make the whole whitelisting
userspace-configurable with finer-grain (but still with appropriate
capabilities) was nacked.  By you, for God's sake.

http://permalink.gmane.org/gmane.linux.kernel/1378071

>   You first
>   built that command list by scanning the spec and just adding the
>   commands that seemed "right" to you.

And then in v2 I stated that I removed some disk commands because of
discussion with you.  But of course you don't know, because you've not
read the damn commit messages.

>   I have near-zero confidence in
>   your perception of the relationship between the specs and actual
>   world.

Thankyouverymuch.  Perhaps you should have read the commit messages (oh
sorry, have I said it already?) and seen that it's not about commands
that seemed "right":

   Only commands that affect the medium are added.
   Commands that affect other state of the LUN are all privileged, with
   the sole exception of START STOP UNIT (which has always been
   allowed for all file descriptors.  I do not really agree with that
   and it's probably an artifact of when /dev/cdrom had
   r--r--r-- permissions, but I'm not trying to change that.

> So, stop quoting and repeating yourself.  You're overdoing yourself on
> that department already.  Try to listen and understand for a change.

Guy, calm down.  We're two.

Paolo
