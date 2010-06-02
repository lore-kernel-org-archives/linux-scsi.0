From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Wed, 02 Jun 2010 09:17:56 -0400
Message-ID: <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
References: <1275398876.21962.6.camel@mulgrave.site>
	<20100601133341.GK8980@think>
	<1275399637.21962.11.camel@mulgrave.site>
	<20100601134951.GM8980@think>
	<20100601162929.GC32708@parisc-linux.org>
	<20100601164750.GQ8980@think>
	<1275411293.21962.387.camel@mulgrave.site>
	<20100601180905.GR8980@think> <20100601184649.GE9453@laptop>
	<20100601193528.GV8980@think> <20100602032030.GF9453@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100602032030.GF9453@laptop> (Nick Piggin's message of "Wed, 2
	Jun 2010 13:20:30 +1000")
Sender: linux-fsdevel-owner@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

>> 1) filesystem changed it
>> 2) corruption on the wire or in the raid controller
>> 3) the page was corrupted while the IO layer was doing the IO.
>> 
>> 1 and 2 are easy, we bounce, retry and everyone continues on with
>> their lives.  With #3, we'll recrc and send the IO down again
>> thinking the data is correct when really we're writing garbage.
>> 
>> How can we tell these three cases apart?

Nick> Do we really need to handle #3? It could have happened before the
Nick> checksum was calculated.

Reason #3 is one of the main reasons for having the checksum in the
first place.  The whole premise of the data integrity extensions is that
the checksum is calculated in close temporal proximity to the data
creation.  I.e. eventually in userland.

Filesystems will inevitably have to be integrity-aware for that to work.
And it will be their job to keep the data pages stable during DMA.

-- 
Martin K. Petersen	Oracle Linux Engineering
