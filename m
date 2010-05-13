From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 20:40:02 +0200
Message-ID: <4BEC4782.7010109@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org>	 <1273768687.4353.235.camel@mulgrave.site>  <4BEC2ED7.9080001@kernel.org> <1273771131.4353.300.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1273771131.4353.300.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

Hello, James.

On 05/13/2010 07:18 PM, James Bottomley wrote:
> So I think the bit I missed was you're trying to do this programatically
> from boot time partition read to detect if the user previously disabled
> the HPA and partitioned the device?  In which case you still have user
> context, you can call BLKRRPART here too.

Yeah, that's what I'm trying to do but the functionality is already in
the block layer and has been used by IDE layer for a long time.  We
just forgot to implement it for libata.  The only thing I did was
fixing up corner case handling in block layer a bit and adding a
callback to sd so that the block layer call can be passed down to
libata.  So, it doesn't have anything to do with sysfs attributes,
block or libata.

We sure can trigger the rescan by invoking BLKRRPART from inside the
partition scan code but I'm afraid that would be more convoluted than
the currently existing implementation of restarting the scan inside
the scan function.

The only thing is that the existing block method is somewhat overly
generic without any good reason, so simplifying that would be a good
idea.

Thanks.

-- 
tejun
