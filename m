From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: memory-barriers.txt again (was Re: [PATCH 4/9] firewire: don't
 use PREPARE_DELAYED_WORK)
Date: Mon, 24 Feb 2014 08:27:28 -0800
Message-ID: <20140224162728.GN8264@linux.vnet.ibm.com>
References: <5307DAC9.2020103@hurleysoftware.com>
 <1393094608.11497.1.camel@dabdike.int.hansenpartnership.com>
 <5308F0E2.3030804@hurleysoftware.com>
 <1393095138.11497.5.camel@dabdike.int.hansenpartnership.com>
 <5308F48C.8080609@hurleysoftware.com>
 <20140223022303.3240093c@stein>
 <20140223163743.GU4250@linux.vnet.ibm.com>
 <530A5B93.7010304@hurleysoftware.com>
 <20140223235012.GB8264@linux.vnet.ibm.com>
 <20140224013254.5004c4fb@stein>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140224013254.5004c4fb@stein>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Peter Hurley <peter@hurleysoftware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Feb 24, 2014 at 01:32:54AM +0100, Stefan Richter wrote:
> On Feb 23 Paul E. McKenney wrote:
> >>> Please see below for a patch against the current version of
> >>> Documentation/memory-barriers.txt.  Does this update help?
> 
> Thank you, this clarifies it.
> 
> [...]
> A new nit:
> > +The operations will always occur in one of the following orders:
> >  
> > -	STORE *A, RELEASE, ACQUIRE, STORE *B
> > -	STORE *A, ACQUIRE, RELEASE, STORE *B
> > +	STORE *A, RELEASE, ACQUIRE, smp_mb__after_unlock_lock(), STORE *B
> > +	STORE *A, ACQUIRE, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> > +	ACQUIRE, STORE *A, RELEASE, smp_mb__after_unlock_lock(), STORE *B
> >  
> > -If the RELEASE and ACQUIRE were instead both operating on the same lock
> > -variable, only the first of these two alternatives can occur.
> > +If the RELEASE and ACQUIRE were instead both operating on the
> > +same lock variable, only the first of these two alternatives can
> > +occur.
>                                                ^^^
> ...these {,three} alternatives...

Good catch!  I chose the empty string.

							Thanx, Paul
