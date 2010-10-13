From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/5] tcm: Unify INQUIRY subsystem plugin handling
Date: Wed, 13 Oct 2010 13:19:49 -0700
Message-ID: <1287001189.7334.47.camel@haakon2.linux-iscsi.org>
References: <1286959681-3445-1-git-send-email-nab@linux-iscsi.org>
	 <20101013110653.GA26366@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101013110653.GA26366@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-10-13 at 13:06 +0200, Christoph Hellwig wrote:
> On Wed, Oct 13, 2010 at 01:48:01AM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the following two struct se_subsystem_api function pointer
> > ops for INQUIRY emulation reponse payload Product and Product Rev:
> 
> FYI, I'd wonder if it wouldn't be easier to store this and the number
> of blocks data directly in struct se_device instead of adding methods.
> 
> That means they just need to be initialized once at device creation time
> and the code in the backends becomes simpler again.  This also applies
> to many of the get_ prefix methods, e.g. get_max_cdb_len, get_blocksize,
> etc.

I should point out that the majority of values mentioned here (other
than the two INQUIRY strings) are already present in struct
se_dev_attrib and which appear as configfs attributes under
under /sys/kernel/config/target/core/$HBA/$DEV/attrib/.  This means that
the struct se_subsystem_api calls only really used by during init
target_core_device.c:se_dev_set_default_attribs() and
DEV_ATTRIB(dev)->block_size, etc are used in TCM Core code.

I am happy to include the two INQUIRY strings needed for emulation into
struct se_subsystem_api directly, but I would still prefer to keep the
function pointers for extracting values from subsystem specific code for
the initial device attribute setup.

--nab
