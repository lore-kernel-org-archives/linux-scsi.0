From: "Grant Grundler" <grundler@google.com>
Subject: Re: [patch 13/17] drivers/scsi/initio.c: suppress compile warning
Date: Fri, 4 Apr 2008 00:05:01 -0700
Message-ID: <da824cf30804040005w7ae131c5he1248462041a658a@mail.gmail.com>
References: <200803282148.m2SLmfg7012252@imap1.linux-foundation.org>
	 <da824cf30803281455g22334554y8cb3887beec951a@mail.gmail.com>
	 <1206743181.3662.55.camel@localhost.localdomain>
	 <20080328224335.1f14cf6a@core>
	 <1206748313.3662.66.camel@localhost.localdomain>
	 <da824cf30803281749l614c3592t89cce073c9b043c8@mail.gmail.com>
	 <1206760156.3662.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:62426 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbYDDHFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2008 03:05:11 -0400
Received: from zps76.corp.google.com (zps76.corp.google.com [172.25.146.76])
	by smtp-out.google.com with ESMTP id m34753sv003878
	for <linux-scsi@vger.kernel.org>; Fri, 4 Apr 2008 08:05:04 +0100
Received: from wf-out-1314.google.com (wff29.prod.google.com [10.142.6.29])
	by zps76.corp.google.com with ESMTP id m34751OC001076
	for <linux-scsi@vger.kernel.org>; Fri, 4 Apr 2008 00:05:01 -0700
Received: by wf-out-1314.google.com with SMTP id 29so3757704wff.8
        for <linux-scsi@vger.kernel.org>; Fri, 04 Apr 2008 00:05:01 -0700 (PDT)
In-Reply-To: <1206760156.3662.79.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, Grant Grundler <grundler@parisc-linux.org>

On Fri, Mar 28, 2008 at 8:09 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
...
>  If you can verify my analysis of the way the driver works, then the
>  complete fix should be pretty simple: just remove the cpu_to_le32 from
>  everywhere except the sg list construction.

When I started striping out cpu_to_le32, I found one more nit:
        if (cmnd->SCp.ptr) {
                dma_unmap_single(&pci_dev->dev,
                                 (dma_addr_t)((unsigned long)cmnd->SCp.ptr),
                                 SENSE_SIZE, DMA_FROM_DEVICE);
                cmnd->SCp.ptr = NULL;
        }

cmnd->SCp.ptr can be assigned a NULL value that is a perfectly valid
DMA address (possibly from an IOMMU). I'm not going to attempt to fix
this since it's obviously working....just want to point it out.

grant
