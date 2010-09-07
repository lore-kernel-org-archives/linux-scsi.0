From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: Why is AHA152X_CS !64BIT?
Date: Tue, 7 Sep 2010 17:12:54 -0400
Message-ID: <201009071712.54867.konrad@darnok.org>
References: <4C72D310.4040004@suse.cz> <4C7B924D.6030703@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:53222 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab0IGV0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 17:26:18 -0400
In-Reply-To: <4C7B924D.6030703@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jiri Slaby <jslaby@suse.cz>, fischer@linux-buechse.de, linux-scsi@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>

On Monday 30 August 2010 07:13:17 Boaz Harrosh wrote:
> On 08/23/2010 10:59 PM, Jiri Slaby wrote:
> > Hi,
> >
> > I see that the aha152x driver for pcmcia is marked as unsupported on
> > 64bit. But I also see a patch [1] which removes the restriction based on
> > user's testing in bugzilla [2].
> >
> > Is there a reason why it would have to be marked as !64BIT? I'm asking
> > because there is an opensuse user with this card who updated to 64-bit
> > distro and lost this driver thereafter.
> >
> > [1] http://kerneltrap.org/mailarchive/linux-scsi/2010/3/6/6832393
> > [2] https://bugzilla.kernel.org/show_bug.cgi?id=14333
> >
> > thanks,
>
> If memory serves correctly, it might be that you need more then 4 Gbyte
> of memory installed to exercise the bug, something about IO bouncing
> addresses > 4G.

If the machine is using SWIOTLB, then the bounce buffer would be activated. By 
default if your machine has more than 4GB compiled under x86_64 the SWIOTLB 
is turned on - but if you have an Intel/AMD IOMMU it gets turned off. Which 
is OK as the Intel/AMD IOMMUs would handle the 4GB restricted devices. So as 
long as the driver has pci_dma_mask_set.

Looking at the git gui blame tool history, the reason that was added was 
for 'allow drivers to be built non-modular'.

So, does this driver build if you make it non-modular?
