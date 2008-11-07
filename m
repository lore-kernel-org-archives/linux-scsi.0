From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 7 Nov 2008 10:36:24 -0500
Message-ID: <20081107153624.GG9543@mit.edu>
References: <4913028B.6010405@redhat.com> <1225984628.4703.80.camel@localhost.localdomain> <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26> <20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com> <20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com> <20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com> <49145E0C.4030705@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49145E0C.4030705@hp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: jim owens <jowens@hp.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>, Eyal Shani <Eyal.Shani@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2008 at 10:26:04AM -0500, jim owens wrote:
> Ric Wheeler wrote:
>
>> The type of allocation that would help most is something that tries to  
>> keep the lower block ranges "hot" for allocation, second best policy  
>> would simply keep the allocated blocks in each block group hot and  
>> re-allocate them.
>
> This block reuse policy ignores the issue of wear leveling...
> as in most design things, trading one problem for another.
>

The discussion here has been around Intel-style SSD's, which
apparently have a log-structured filesystem in the device, such that
wear leveling is done automatically, and in fact it is *better* for
these devices if we reuse the same block since then the SSD
automatically knows that contents at the old location is logically
"gone".  (I don't believe, or at least don't see, why there would be
any benefit of reusing block ranges versus explicitly using a TRIM
command to tell the SSD that the old block was no longer being used;
it should have the same effect as far as the SSD is concerned.)

The one thing which I am somewhat concerned about is whether all SSD's
will be doing things the Intel way, or whether other SSD's might not
be willing to license some Intel patents (for example) and will end up
doing things some other way, where they aren't using a log-structured
filesystem under the covers and might be more succeptible to
wear-leveling concerns.

It would perhaps be unfortunate if we were to tune Linux filesystems
to be optimal for Intel-style SSD's, to the point where we can't
support other implementation strategies for SSD's where wear-leveling
might be more important.

OTOH, if Intel has lots of people engaging Linux, and helping to
provide code, benchmarking tools, etc., some bias towards SSD's as
designed and implemented by Intel is probably inevitable.  (And it's
an incentive for other SSD vendor's to do the same.  :-)

   	     	       	   	       	      - Ted
