From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Add SG_GET_SG_MAX_SEGMENT_SIZE ioctl to sg device
Date: Tue, 03 Jul 2012 12:01:12 +0400
Message-ID: <1341302472.3319.26.camel@dabdike>
References: <1341220857-1205-1-git-send-email-mc@linux.vnet.ibm.com>
	 <1341227897.2987.15.camel@dabdike.int.hansenpartnership.com>
	 <1341302003.17396.20.camel@mengcong>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341302003.17396.20.camel@mengcong>
Sender: linux-kernel-owner@vger.kernel.org
To: mc@linux.vnet.ibm.com
Cc: stefanha@linux.vnet.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, senwang@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 2012-07-03 at 15:53 +0800, Cong Meng wrote:
> On Mon, 2012-07-02 at 12:18 +0100, James Bottomley wrote:
> > On Mon, 2012-07-02 at 17:20 +0800, Cong Meng wrote:
> > > Add a new ioctl cmd to get the max segment size. It's useful in
> > > virtualization environment for guest to know the queue limits, so
> > > that the guest kicks off legal scsi command to a sg device.
> > 
> > What's wrong with simply looking in the /sys for this? Plus, if you can
> 
> Adding this ioctl is a big convenience for the programs, qemu 
> in my case, to which parameter that likes '/dev/sgX' is given. 
> With this ioctl, those programs only need to issue an ioctl to 
> get the queue limit.

I don't need to know why you need the information, I accept that it's
useful

>  Otherwise, 'dev/sgX' is needed to convert 
> to /sys path, then open and read it. 

Well, yes, what's the problem?

> In addition, the potential variation and exceptional situation 
> of sys FS, EX mount path, are needed to consider as well.
> Is my justification acceptable? 

No. I need to know why you can't get it out of sysfs.  We put a whole
lot of stuff into sysfs to avoid the need to add extra ioctls.  There
need to be a really good reason why /sys doesn't work.

James

> > come up with a justifiable reason, this needs to be in block as well so
> > we can send it to all SCSI devices regardless of what ULD people use.
> I can do it.
> 
> Thanks.
> Cong.
> > 
> > James
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
