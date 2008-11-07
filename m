From: Theodore Tso <tytso@mit.edu>
Subject: Re: thin provisioned LUN support
Date: Fri, 7 Nov 2008 16:13:47 -0500
Message-ID: <20081107211347.GM29717@mit.edu>
References: <1226078535.15281.63.camel@think.oraclecorp.com> <4914846C.5060103@redhat.com> <20081107183636.GB29717@mit.edu> <49148BDF.9050707@redhat.com> <20081107193503.GG29717@mit.edu> <yq1iqqz9uqt.fsf@sermon.lab.mkp.net> <20081107201913.GI29717@mit.edu> <20081107202149.GJ15439@parisc-linux.org> <4914A492.4080009@redhat.com> <1226090910.15281.84.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1226090910.15281.84.camel@think.oraclecorp.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jens.axboe@oracle.com>, David Woodhouse <dwmw2@infradead.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2008 at 03:48:30PM -0500, Chris Mason wrote:
> 
> * Fast
> * Crash safe
> * Bounded ram usage
> * Accurately deliver the trims
> 
> Pick any three ;)  

Actually, if you move this responsibility into the FS block allocator,
I think you can get all four.  You might pay a slight CPU cost for
determining whether the aligned region is free, depending on how the
filesystem's block allocation data structures are structured, but the
more I think about it, the more I like it.  

It only has the downside that it would have to be implemented in every
filesystem separately, but hey, it's the block array vendors who would
be getting the big bucks from having this feature, so they should have
no problem putting up some bucks to make sure the OS implements so
their users can take advantage of *their* feature.  :-)

      	    	     	       	  	  	    - Ted
