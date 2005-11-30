From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/5] aacraid: update dma mapping
Date: Wed, 30 Nov 2005 14:23:32 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E3E12D@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:64660 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751562AbVK3TXe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 14:23:34 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Mark Haverkamp <markh@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Cool ... Simpler is *always* better! We got a code inspection that
indicated that memory above 4G would be accessed inefficiently using
pci_map_single. Sounds like the IO-Perf howto needs modernization.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Wednesday, November 30, 2005 1:45 PM
> To: Mark Haverkamp
> Cc: linux-scsi; Salyzyn, Mark
> Subject: Re: [PATCH 3/5] aacraid: update dma mapping
> 
> 
> On Wed, 2005-11-30 at 10:36 -0800, Mark Haverkamp wrote:
> > This patch changes map_single to map_page in compliance with
> > recommendations made in the IO-Perf howto document to prevent bounce
> > buffering of DMA requests.
> 
> Erm, there's a misunderstanding somewhere.  You're replacing correct
> pci_map_single calls with its more difficult to use 
> pci_map_page.  This
> has absolutely zero performance impact and adds the risk that because
> pci_map_page is more complex to use, someone gets it wrong somewhere.
> Really, for block devices pci_map_single is the absolutely correct
> interface.  pci_map_page should really only be used by the 
> net stack for
> packet fragment mapping.
> 
> James
> 
> 
> 
