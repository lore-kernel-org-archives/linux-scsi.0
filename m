From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Question about scsi_host_alloc
Date: Wed, 18 Jul 2007 05:26:29 -0600
Message-ID: <20070718112628.GM14791@parisc-linux.org>
References: <4104961b0707180400l62a7eda7p5ec0770ddb69651b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48449 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbXGRL0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 07:26:30 -0400
Content-Disposition: inline
In-Reply-To: <4104961b0707180400l62a7eda7p5ec0770ddb69651b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2007 at 07:00:01PM +0800, jidong xiao wrote:
> I see this function,struct Scsi_Host *scsi_host_alloc(struct
> scsi_host_template *, int), I am wondering what does the second
> parameter used for?Say,
> 
> I mean the privsize, i.e. extra bytes, why do we need such extra
> bytes?Who will use it?

It's for the use of the driver.  Many drivers have a struct containing
additional information, such as:

struct scsi_qla_host {
        /* Linux adapter configuration data */
        struct Scsi_Host *host; /* pointer to host data */
        struct scsi_qla_host *next;
        struct device_reg __iomem *iobase;      /* Base Memory-mapped I/O addres
s */
[....]
        struct nvram nvram;
        int nvram_valid;
};

...
        struct scsi_qla_host *ha;
        host = scsi_host_alloc(&qla1280_driver_template, sizeof(*ha));
        ha = (struct scsi_qla_host *)host->hostdata;

It means the driver doesn't need to allocate the private data separately,
so it's a little more efficient.  You also don't need to worry about
reference counting it; it will be freed when the Scsi_Host is freed.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
