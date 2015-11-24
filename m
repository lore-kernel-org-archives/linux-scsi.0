From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Tue, 24 Nov 2015 02:24:34 -0800
Message-ID: <1448360674.20113.5.camel@perches.com>
References: <1448353024.12861.56.camel@Centos6.3-64>
	 <1448357586.14504.12.camel@perches.com>
	 <1448358798.14472.3.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448358798.14472.3.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-11-24 at 17:53 +0800, Ching Huang wrote:
> On Tue, 2015-11-24 at 01:33 -0800, Joe Perches wrote:
> > On Tue, 2015-11-24 at 16:17 +0800, Ching Huang wrote:
> > > From: Ching Huang <ching2048@areca.com.tw>
> > > 
> > > Support areca new PCIe to SATA RAID adapter ARC1203
> > 
> > Why add the dma_free_coherent to an old data path?
> > Is that a general bug fix that should be backported?
> 
> That's right. It's need to release the allocated resource for failed
> condition.

Then the dma_free_coherent addition should be a separate patch.

Style trivia:

The goto to another error path like that is odd and
the label is unintelligible.

Ideally error condition handling would use a goto and
a separate and obviously named label.  Use multiple
labels for cases with more complicated unwinding.

Dan Carpenter has written about this several times.

For this use, something like:

	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
		logging_message(...);
		goto
err_free_resource;
	}
	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
		logging_message(...);
		goto err_free_resource;
	}

	[success path...]

	return true;

err_free_resource:
	dma_free_coherent(...);

	return false;
}
