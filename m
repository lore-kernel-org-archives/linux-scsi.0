From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Date: Wed, 13 Oct 2010 21:35:37 -0700
Message-ID: <1287030937.9909.30.camel@haakon2.linux-iscsi.org>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org>
	 <20101013110653.GA26366@lst.de>
	 <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
	 <20101014000421.GB15583@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.207]:30596 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754502Ab0JNEkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Oct 2010 00:40:22 -0400
In-Reply-To: <20101014000421.GB15583@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>

On Thu, 2010-10-14 at 02:04 +0200, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 01:19:49PM -0700, Nicholas A. Bellinger wrote:
> > I should point out that the majority of values mentioned here (other
> > than the two INQUIRY strings) are already present in struct
> > se_dev_attrib and which appear as configfs attributes under
> > under /sys/kernel/config/target/core/$HBA/$DEV/attrib/.  This means that
> > the struct se_subsystem_api calls only really used by during init
> > target_core_device.c:se_dev_set_default_attribs() and
> > DEV_ATTRIB(dev)->block_size, etc are used in TCM Core code.
> > 
> > I am happy to include the two INQUIRY strings needed for emulation into
> > struct se_subsystem_api directly, but I would still prefer to keep the
> > function pointers for extracting values from subsystem specific code for
> > the initial device attribute setup.
> 
> What's the point?  It's a lot of boilerplate code that does nothing
> but obsfucating what's actually going on there.
> 

So you would rather have struct se_device attributes set in TCM
subsystem specific ->create_virtdevice() code directly after
transport_add_device_to_core_hba() -> se_dev_set_default_attribs(),
right..?

Performing the assignment of these attribute values from the same local
functions and dropping the extra struct se_subsystem_api callers would
be fine with me, but I honestly don't see how these handful of subsystem
API callers with obvious names adds obsfucation while TCM code is using
struct se_device->$ATTR_NAME to enforce device limits in I/O path
code...?

Thanks for your comments.. ;)

--nab

