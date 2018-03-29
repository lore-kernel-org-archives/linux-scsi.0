From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: SCSI generic (sg) regression in stable kernels
Date: Thu, 29 Mar 2018 07:06:59 +0200
Message-ID: <20180329050659.GA11743@kroah.com>
References: <f0c7acd8-42e4-1896-6323-7807ff4f8007@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f0c7acd8-42e4-1896-6323-7807ff4f8007@cybernetics.com>
Sender: stable-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@microsoft.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>, Bart Van Assche <bart.vanassche@wdc.com>, Eric Dumazet <edumazet@google.com>, Andrey Konovalov <andreyknvl@google.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 28, 2018 at 05:37:24PM -0400, Tony Battersby wrote:
> The SCSI generic driver is currently broken in the 3.18, 4.1, 4.4, and
> 4.9 stable kernels.  This is the problematic commit:
> 
> 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
> 
> (all commit ids are from upstream git, not stable.git)
> 
> There have already been a number of fixes backported to -stable to fix
> problems introduced by that commit:
> 
> bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()")
> 4759df905a47 ("scsi: sg: factor out sg_fill_request_table()")
> 3e0097499839 ("scsi: sg: fixup infoleak when using SG_GET_REQUEST_TABLE")
> 587c3c9f286c ("scsi: sg: Re-fix off by one in sg_fill_request_table()")
> 
> I am not sure why 109bade9c625 was added to -stable to begin with.  My
> guess is that the "infoleak" fix was flagged as being appropriate for
> -stable, and it depended on the original commit 109bade9c625.  But if
> you take a close look, the original commit 109bade9c625 is what
> introduced the infoleak in the first place.  Or maybe there was some
> other reason.  But I digress.
> 
> There is one more fix for 109bade9c625 that has not yet been backported:
> 
> 48ae8484e9fc ("scsi: sg: don't return bogus Sg_requests")
> 
> Without the fix above, sg oopses as soon as I try to use it.  So please
> add 48ae8484e9fc to -stable.
> 
> The following -stable kernels already have 48ae8484e9fc:
> 4.14.31
> 4.15.14
> 
> The following -stable kernels need 48ae8484e9fc:
> 3.18.102
> 4.1.51
> 4.4.125
> 4.9.91

Now queued up for 4.9.y, 4.4.y, and 3.18.y, thanks!

greg k-h
