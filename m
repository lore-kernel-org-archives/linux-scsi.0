From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a memory leak in scsi_host_dev_release()
Date: Fri, 20 Nov 2015 09:49:42 -0800
Message-ID: <564F5D36.8010402@sandisk.com>
References: <564D0224.9040001@sandisk.com>
 <20151120115212.GA23875@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151120115212.GA23875@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On 11/20/2015 03:52 AM, Christoph Hellwig wrote:
> the memory leak looks real, and your fix looks corret, but I still
> don't like it.
>
> I think it's reasonable for SCSI to assume that the final put_device
> fully frees the struct device including the name pointer that is
> assigned entirely behind the back of the caller.
>
> So I think the fix for this probably should be in the driver core.

Hello Christoph,

Thanks for the feedback. However, I'm not sure this can be fixed by 
modifying the driver core. If scsi_host_remove() is not called the SCSI 
core doesn't call put_device(&shost->shost_dev). I will post a second 
version of this patch that ensures that the SCSI core always calls 
put_device(&shost->shost_dev).

Bart.
