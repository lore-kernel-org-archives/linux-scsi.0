From: Doug Ledford <dledford@redhat.com>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: Thu, 13 Mar 2003 18:17:40 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3E711194.9010505@redhat.com>
References: <20030228133037.GB7473@jiffies.dk>	 <1047510381.12193.28.camel@markh1.pdx.osdl.net>	 <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>	 <3E6FC8D6.7090005@torque.net>	 <1047517604.23902.39.camel@irongate.swansea.linux.org.uk> <1047570132.30105.7.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1047570132.30105.7.camel@markh1.pdx.osdl.net>
To: Mark Haverkamp <markh@osdl.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, dougg@torque.net, Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

Mark Haverkamp wrote:

> Does the cmd_per_lun element of the Scsi_Host_Template structure serve
> more than one purpose? 

Only when inappropriately abused by LLDD authors.  The cmd_per_lun value 
is suppossed to be for untagged devices only!  If you have a tape drive 
that doesn't support tagged commands but you want to be able to 
internally have the next command queued up and ready to go when the 
current command completes (in order to keep it streaming better), then 
you can set cmd_per_lun to 2 and you will get two outstanding commands 
for this device at a time.  I used that so that in my interrupt handler 
I could send the next command to the device before I passed the 
completed command up to the SCSI layer.

> In scsi_alloc_sdev it is passed into
> scsi_adjust_queue_depth.  In the aacraid case this is 512.  Later the
> aacraid driver (in aac_slave_configure) sets the queue depth to either
> 128 for tagged or 1 if not.

That's where you are suppossed to set the queue depth on tagged devices.


-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
          Red Hat, Inc.
          1801 Varsity Dr.
          Raleigh, NC 27606
