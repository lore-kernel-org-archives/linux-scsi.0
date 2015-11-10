From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Tue, 10 Nov 2015 20:13:30 +0100
Message-ID: <6333643.g8NiezT8gD@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <4982446.ZlJVrezq1Y@wuerfel> <564222CB.3000701@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564222CB.3000701@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tuesday 10 November 2015 11:00:59 Timur Tabi wrote:
> On 11/10/2015 10:47 AM, Arnd Bergmann wrote:
> > What BenH was worried about here is that the driver sets different masks
> > for streaming and coherent mappings, which is indeed a worry that
> > could hit us on ARM as well, but I suppose we'll have to deal with
> > that in platform code.
> >
> > Setting both masks to 32-bit is something that a lot of drivers do,
> > and without IOMMU enabled, you'd hit the same bug on all of them.
> 
> Also note that I think that on PowerPC, the mask is set to 32 by default 
> for all devices.  I don't think we do that on ARM64.  So on PowerPC, 
> some drivers get away with not explicitly setting the mask.
> 

If the mask is 64-bit by default on ARM64, that is a bug that we need
to fix urgently. Can you verify this?

A lot of PCI devices can only do 32-bit DMA, and we have plenty
of drivers that don't bother setting a mask at all because the 32-bit
mask is the default on all other architectures.

	Arnd
