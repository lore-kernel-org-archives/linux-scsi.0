From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: Thu, 13 Mar 2003 09:55:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6FC8D6.7090005@torque.net>
References: <20030228133037.GB7473@jiffies.dk>	 <1047510381.12193.28.camel@markh1.pdx.osdl.net> <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Haverkamp <markh@osdl.org>, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>

Alan Cox wrote:
> On Wed, 2003-03-12 at 23:06, Mark Haverkamp wrote:
> 
>>During probe, scsi_alloc_sdev is called.  It calls
>>scsi_adjust_queue_depth with the cmd_per_lun value. 
>>scsi_adjust_queue_depth returns without doing anything if the tags value
>>is greater than 256.  This leaves the Scsi_Device queue_depth at zero. 
>>Later when an I/O is queued, scsi_request_fn checks for device_busy >=
>>queue_depth.  If so, the function does a break and exits.  This is where
>>it hangs.
>>
>>To get things to load I set cmd_per_lun to 256.  I don't know if the is
>>the correct way to deal with the problem.  Maybe someone else can say
>>something about that.
> 
> 
> If the SCSI layer is trying to be clever by ignoring the requested 512
> then thats the actual problem. 512 is the right value because its not
> really a disk you are talking to on the main channel. So the scsi layer
> ought to honour it.

Here is the relevant code snippet in scsi.c around line
930:


void scsi_adjust_queue_depth(Scsi_Device *SDpnt, int tagged, int tags)
{
         static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
         unsigned long flags;

         /*
          * refuse to set tagged depth to an unworkable size
          */
         if(tags <= 0)
                 return;
         /*
          * Limit max queue depth on a single lun to 256 for now.  Remember,
          * we allocate a struct scsi_command for each of these and keep it
          * around forever.  Too deep of a depth just wastes memory.
          */
         if(tags > 256)
                 return;
....

[pardon the wrap]
Now scsi_device::queue_depth is an unsigned short so that
is not a problem. Also the comment prior to the
"if (tags > 256)" is no longer correct (I think). So
perhaps it can be changed to "if (tags > 65535) ..."

Doug Gilbert

