From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: thin provisioned LUN support & file system allocation policy
Date: Fri, 07 Nov 2008 11:06:25 -0500
Message-ID: <49146781.3020802@redhat.com>
References: <Pine.LNX.4.64.0811061519350.3431@Nokia-N800-26>	<20081107120534.GO21867@kernel.dk> <49143142.4010809@redhat.com>	<20081107121934.GP21867@kernel.dk> <49145029.4040900@redhat.com>	<20081107144311.GE9543@mit.edu> <4914568A.7090307@redhat.com>	<49145E0C.4030705@hp.com>	<Pine.LNX.4.64.0811071528190.8115@Nokia-N800-26>	<49146031.70003@hp.com> <20081107154655.GH9543@mit.edu> <yq1y6zva61e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <yq1y6zva61e.fsf@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, jim owens <jowens@hp.com>, David Woodhouse <dwmw2@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Chris Mason <chris.mason@oracle.com>, Dave Chinner <david@fromorbit.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Black_David@emc.com, Tom Coughlan <coughlan@redhat.com>, Matthew Wilcox <matthew@wil.cx>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Ted" == Theodore Tso <tytso@mit.edu> writes:
>>>>>>             
>
> Ted> How much of a disk wear factor is there with modern disk drives?
> Ted> The heads aren't touching the disk, and we have plenty of sectors
> Ted> which are constantly getting rewritten with traditional
> Ted> filesystems, with no ill effects as far as I know.
>
> Modern disk firmware maintains a list of write hot spots and will
> regularly rewrite adjacent sectors to prevent bleed.
>
>   
This is my understanding (based on looking at lots of disks from my EMC 
days).  Again, this is not an issue for a Symm/Hitachi/Shark class array 
since they all abstract away this kind of hot spotting.

Where it is an issue with local drives is when you constantly (like 
every 20ms) try to update the same sector and that triggers the kind of 
adjacent track erasure issues you mention here.  Disk block allocation 
policies that reuse blocks will update the same sectors are orders of 
magnitude less than this (and much less than we rewrite block allocation 
bitmaps, etc).

ric

