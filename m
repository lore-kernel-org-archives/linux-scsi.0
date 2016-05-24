From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Tue, 24 May 2016 09:50:06 -0700
Message-ID: <20160524165006.GA28021@kroah.com>
References: <1464097978-88457-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <3303bc98-ade7-62f0-71c7-11e7ef42b42d@sandisk.com>
 <20160524163411.GA21800@kroah.com>
 <05554b20-46af-5298-e822-9d8bcba6b096@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <05554b20-46af-5298-e822-9d8bcba6b096@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "JBottomley@odin.com" <JBottomley@odin.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "tyreld@linux.vnet.ibm.com" <tyreld@linux.vnet.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kvalo@codeaurora.org" <kvalo@codeaurora.org>, "davem@davemloft.net" <davem@davemloft.net>, "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>, "jslaby@suse.com" <jslaby@suse.com>, "joe@perches.com" <joe@perches.com>, "bp@suse.de" <bp@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, bgly <bgly@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24, 2016 at 09:44:43AM -0700, Bart Van Assche wrote:
> On 05/24/2016 09:34 AM, Greg KH wrote:
> > On Tue, May 24, 2016 at 09:25:05AM -0700, Bart Van Assche wrote:
> > > > +static inline long h_send_crq(struct ibmvscsis_adapter *adapter,
> > > > +			u64 word1, u64 word2)
> > > > +{
> > > > +	long rc;
> > > > +	struct vio_dev *vdev = adapter->dma_dev;
> > > > +
> > > > +	pr_debug("ibmvscsis: ibmvscsis_send_crq(0x%x, 0x%016llx, 0x%016llx)\n",
> > > > +			vdev->unit_address, word1, word2);
> > > > +
> > > 
> > > As Joe Perches already asked, please define pr_fmt() instead of including
> > > the kernel module name in every pr_debug() statement.
> > 
> > Even better, as this is a driver, it should be using dev_*() calls
> > instead of pr_*() calls to properly identify the device and driver that
> > is making the message.  No driver should be using pr_*() except in
> > _very_ limited usages.
> 
> Hi Greg,
> 
> The reason I recommended pr_debug() is because ibmvscsis is a LIO target
> driver and I don't think a struct device is associated with a LIO target
> driver. See e.g. target_register_template() in
> drivers/target/target_core_configfs.c.

That seems messed up, there should be a struct device somewhere to
use...
