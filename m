From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Problem with aacraid driver in 2.5.63-bk-latest
Date: 13 Mar 2003 00:18:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1047514681.23725.35.camel@irongate.swansea.linux.org.uk>
References: <20030228133037.GB7473@jiffies.dk>
	 <1047510381.12193.28.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1047510381.12193.28.camel@markh1.pdx.osdl.net>
To: Mark Haverkamp <markh@osdl.org>
Cc: Christoffer Hall-Frederiksen <hall@jiffies.dk>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux aacraid devel <linux-aacraid-devel@dell.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2003-03-12 at 23:06, Mark Haverkamp wrote:
> During probe, scsi_alloc_sdev is called.  It calls
> scsi_adjust_queue_depth with the cmd_per_lun value. 
> scsi_adjust_queue_depth returns without doing anything if the tags value
> is greater than 256.  This leaves the Scsi_Device queue_depth at zero. 
> Later when an I/O is queued, scsi_request_fn checks for device_busy >=
> queue_depth.  If so, the function does a break and exits.  This is where
> it hangs.
> 
> To get things to load I set cmd_per_lun to 256.  I don't know if the is
> the correct way to deal with the problem.  Maybe someone else can say
> something about that.

If the SCSI layer is trying to be clever by ignoring the requested 512
then thats the actual problem. 512 is the right value because its not
really a disk you are talking to on the main channel. So the scsi layer
ought to honour it.
