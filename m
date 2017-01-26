From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 0/2] scsi: storvsc: Add support for FC lightweight
 host.
Date: Thu, 26 Jan 2017 06:51:59 -0800
Message-ID: <20170126145159.GA29683@infradead.org>
References: <1485437940-18706-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485437940-18706-1-git-send-email-cavery@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cathy Avery <cavery@redhat.com>
Cc: kys@microsoft.com, hch@infradead.org, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, famz@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2017 at 08:38:58AM -0500, Cathy Avery wrote:
> Included in the current storvsc driver for Hyper-V is the ability
> to access luns on an FC fabric via a virtualized fiber channel
> adapter exposed by the Hyper-V host. This was done to provide an
> interface for existing customer tools that was more consistent with
> a conventional FC device. The driver attaches to the FC transport 
> to allow host and port names to be published under 
> /sys/class/fc_host/hostX.
> 
> A problem arose when attaching to the FC transport. The scsi_scan code
> attempts to call fc_user_scan which has basically become a no-op 
> due to the virtualized nature of the FC host 
> ( missing rports, vports, etc ). At this point you cannot refresh
> the scsi bus after mapping or unmapping luns on the SAN without
> a reboot.

I don't think a device without rports or vports is a FC device, plain and
simple.  So as far as I'm concerned we should remove the code from storvsc
that pretends to be FC, and not add it to virtio to start with.

And again I think leightweight is a very confusing name -
what exactly is leight or heavy?   It's really fake or dummy
in the current version.

> 
> 2) Removes an original workaround dealing with replacing
> the eh_timed_out function. Patch 1 will not set the 
> scsi_transport_template.eh_timed_out function directly during
> lightweight fc_attach_transport(). It instead relies on
> whatever was indicated as the scsi_host_template timeout handler
> during scsi_times_out() scsi_error.c. So the workaround is 
> no longer necessary.

Can you send a patch that gets rid of the transport class timeout handler
entirely?  I think it's simply the wrong layering we have here - the
driver needs to be in control of timeouts, and if it wants it can
optionally call into library code in the transport class.


FYI, all the long-term relevant explanation need to go into the patches
themselves (patch description or code comments), not in the cover
letter.
