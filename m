From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 6 Nov 2002 15:50:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106205050.GG22177@redhat.com>
References: <20021105202417.A26520@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021105202417.A26520@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 08:24:17PM -0800, Patrick Mansfield wrote:
> +void scsi_slave_detach(struct scsi_device *sdev)
> +{
> +	if (--sdev->attached == 0) {
> +		if (sdev->host->hostt->slave_detach != NULL)
> +			sdev->host->hostt->slave_detach(sdev);
> +		scsi_release_commandblocks(sdev);
> +	}
> +}
> +/*

Hmmm...either this needs to implement what I alluded to in my writeup a 
couple weeks ago and add the lines:

if(sdev->hostdata)
  kfree(sdev->hostdata);
sdev->hostdata = NULL;

after the slave_detach call.  The other option is to slightly refine the 
slave_attach/slave_detach API to specificy that if your attach routine 
allocates and hangs memory off of sdev->hostdata, then you *must* 
implement a slave_detach() routine and you must free said memory yourself 
(and NULL out the pointer to be safe).

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
