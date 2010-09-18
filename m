From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2 01/11] scsi: Convert struct Scsi_Host->cmd_serial_number
 to atomic_t
Date: Fri, 17 Sep 2010 21:45:10 -0500
Message-ID: <4C9427B6.9050404@cs.wisc.edu>
References: <1284747709-20862-1-git-send-email-nab@linux-iscsi.org> <4C93BB8E.2080501@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C93BB8E.2080501@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 09/17/2010 02:03 PM, Joe Eykholt wrote:
>
> How about instead of adding use_serial_number, let's just have the
> drivers that want a serial number call scsi_cmd_get_serial()

I think this sounds better.

You could also convert drivers to the host tagging if you needed a 
unique id for each command sent to a host.

> and stop calling it from scsi_dispatch_cmd()?   AFAICT, it's only
> used in debug messages in some drivers.  I didn't find other usages
> but didn't do an exhaustive search.

The comments for serial_number say that it is only supposed to be used 
for debugging printks and most drivers use it for that. However, it 
looks like mpt and dpt_i2o are using it for error handling and/or lookup 
type of operations. I think the mpt* uses are not needed in the abort 
checks.

And eata is using it for ordering and tracking or something. It could 
probably be converted to the host tagging if or what you suggested if it 
needs the uniqueue id.

zfcp looks like it copies it. It does not look like the driver needs it.

scsi_error.c uses it in scsi_try_to_abort_cmd to check if a command has 
completed, but I think that can be done by checking if REQ_ATOM_COMPLETE 
is set.
