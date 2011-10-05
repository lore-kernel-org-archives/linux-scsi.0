From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Re: Re: Re: BUG in kernel: Wrong Handling of USB
 =?UTF-8?Q?HDD=E2=80=99s?= in scsiglue(slave_configure) and
 scsi/sd(sd_read_cache_ =?windows-1252?Q?type=29
Date: Wed, 05 Oct 2011 08:17:11 -0700
Message-ID: <1317827831.7238.2.camel@dabdike>
References: <Pine.LNX.4.44L0.1110051014590.2289-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1110051014590.2289-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-10-05 at 10:17 -0400, Alan Stern wrote:
> On Wed, 5 Oct 2011, Amit Sahrawat wrote:
> 
> > Hi,
> > 
> > In order to verify the SYNC_CACHE command being passed.
> > First I checked on the USB HDD(Seagate - Free Agent) which is gettind
> > properly identified on linux. I performed - copy of a file and then
> > did 'Safely Remove Hardware" - this resulted in SYNC_CACHE command
> > being passed - All logs are captured for this.
> > 
> > Then, for the same Hard Disk - I checked for the behaviour on Windows.
> > There is no SYNC CACHE command being passed in this case.
> > 
> > Again, checked for a different hard disk(Seagate) - which has cache
> > but not shown in Linux. In that case also, there is no SYNC CACHE
> > command.
> > 
> > Please find the logs for the '3' cases attached.
> 
> This is a little disappointing.  If Windows doesn't use the SYNCHRONIZE 
> CACHE command, it's quite likely that some USB drives will crash when 
> they receive it.
> 
> This strongly suggests that we should not change the current code.

I agree ... it means they go by the SCSI mode pages too, so we'll be no
worse than they are.  Plus we don't risk upsetting the rest of the USB
device universe.

James
