From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Sun, 05 Apr 2009 13:22:08 +0300
Message-ID: <49D88650.9050400@panasas.com>
References: <20090402015455.GA14087@havoc.gtf.org> <49D4AF12.40708@panasas.com> <49D5D921.6080904@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49D5D921.6080904@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: open-osd mailing-list <osd-dev@open-osd.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On 04/03/2009 12:38 PM, Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> I have taken that to my heart and will submit patches for that, next week.
>> Including a complimentary patch to this driver. These changes are only
>> intended for 2.6.31 though.
> 
> Consolidation of common code should occur after osdblk is in one of: 
> open-osd.git, scsi-misc.git, or linux-2.6.git.
> 
> That way, the code movement can be consolidated into a single changeset, 
> touching exofs, osdblk and libosd all at the same time...
> 	-exofs code
> 	-osdblk code
> 	+libosd code
> 
> 

Yes my plan exactly. I'll do it on my linux-open-osd tree and push it
through the exofs branch in the next Kernel (2.6.31)

>> I also want to add a small utility that can manage objects, create, size,
>> remove, and mount as a complimentary wrapper for this driver is "osdblk"
>> a good name for such utility?
> 
> osdblk intentionally maintains -zero- metadata on its own.  Therefore, 
> this utility you propose can be completely generic.  You could call it 
> "osdobjutil", because it need not be tied to the osdblk driver.
> 
> The osdblk driver needs the following from the utility:
> 
> - create object of specified size
> 
> - delete object
> 
> and optionally:
> - resize object to new size
> 

In that case then I have on Q, an "osd" application that will support
the full osd API set through command line, like:
usage: osd create|remove|read|write|append|flush... \
	--obj=par_id,obj_id \
	[--set_attr=page_no,attr_no,set_attr_file] \
	[--get_attr=page_no,attr_no,set_attr_file] \
	[--file=in_out_file] \
	...

I intend to fully support any functionality available by the library.
the osd_ktests should be duplicatable in bash

> There is no need for a mount operation, because this is handled through 
> class_osdblk_add()
> 
> 
<snip>
>>> +static void osdblk_osd_complete(struct osd_request *or, void *private)
>>> +{
>>> +	struct osdblk_request *orq = private;
>>> +	struct osd_sense_info osi;
>>> +	int ret = osd_req_decode_sense(or, &osi);
>>> +
>>> +	if (ret)
>>> +		ret = -EIO;
>>> +
>>> +	osd_end_request(or);
>>> +	osdblk_end_request(orq->osdev, orq, ret);
>> should be reversed, very bad things will happen otherwise
>>
>> +	osdblk_end_request(orq->osdev, orq, ret);
>> +	osd_end_request(or);
> 
> Perhaps you are confusing two different 'struct request' in use?
> 
> 	- struct request, passed to osdblk for execution
> 	- struct request, used by libosd to pass commands
> 
> The object lifetime of the struct request stored in 'orq' is longer than 
> the lifetime of the osd_request:
> 
> 	1) block layer passes 'rq' to osdblk
> 	2) osdblk creates new 'or', passes 'or' to libosd
> 	3) libosd calls osdblk completion function
> 	4) osdblk completes 'or'
> 	5) osdblk completes 'rq'
> 
> As you can see, the object lifetime of 'or' is entirely within 'rq'.
> 
> 

Yes I was confused exactly as you described, thanks grate stuff.

> 
> 
>> What can I say, great stuff.
>>
>> OSD is a very clean API, that makes whole subsystems look trivial.
> 
> I appreciate it, thanks for the review.
> 
> 	Jeff

Thank you Jeff for doing this
Boaz
