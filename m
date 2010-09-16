From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand()
	caller
Date: Thu, 16 Sep 2010 16:01:43 -0700
Message-ID: <1284678103.13344.111.camel@haakon2.linux-iscsi.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This series contains the first round of a whole-sale conversion for droping
> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
> that is protected by host_lock is scsi_cmd_get_serial)_.
> 
> The patches #2 -> #8 converts libiscsi, libsas, lpfc, qla4xxx, qla2xxx,
> TCM_Loop, and libfc code to drop their own SHT->queuecommand() internal
> host_lock unlock() + lock() optimization that certain high performance libs
> and LLDs have adopted over the years.  The changes involved here are really
> quite straight forward, but please note that none of this code has been tested
> with actual hardware yet, and is intended for generating comments for the relivent
> SCSI LLD driver maintainers and other interested folks.
> 
> There are probably still be more LLDs which use this optimization, so please
> let me know if there is another piece of SHT->queuecommand() caller code that
> does this legacy optimization and needs to be updated.  I will be sure to
> CC the right driver maintainers and CC linux-scsi as I come across any more
> conversions.

Hi Guys,

drivers/scsi/fnic needs the conversion as well..  Here is that patch;

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=3c886b2ab6faccbe2803094deb7a9647199e5118

Thanks!

--nab
