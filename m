From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore infrastructure
Date: Wed, 06 Oct 2010 16:13:55 +0400
Message-ID: <4CAC6803.9070609@vlnb.net>
References: <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>	<1286339442.5685.76.camel@haakon2.linux-iscsi.org>	<20101006155833G.fujita.tomonori@lab.ntt.co.jp> <20101006162018R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101006162018R.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com
List-Id: linux-scsi@vger.kernel.org

FUJITA Tomonori, on 10/06/2010 11:25 AM wrote:
>>> The main issue here is that the user still needs to know the $LPORT_WWPN
>>> before hand (either from looking at a sticker on the card, or via
>>> another method) in order to preform the initial TFO->fabric_make_wwn()
>>> -> $TCM_MOD_make_wwn() operation.  So what we need is a configfs attrib
>>> at the top level TCM fabric group in order to see a list of the
>>> available hardware ports from the specific $TCM_MOD.  What I was
>>> thinking for TCM HW fabric module ports would be to have something like:
>>>
>>> 	/sys/kernel/config/target/$TCM_MOD/hw_ports
>>>
>>> that would walk the struct pci_dev looking for fabric module specific HW
>>> target mode capabilities.  I assume this is what you had in mind for
>>> drivers/scsi/ibmvscsi as well, yes..?
>>
>> Doesn't sound so.
>>
>> I want the driver to create necessary target directories in
>> /sys/kernel/config/target/ibmvscsit/ automatically.
> 
> In addition, I also think that /sys/kernel/config/target/$TCM_MOD
> should show up automatically when I load the module.
> 
> vine:/home/fujita# modprobe iscsi_target_mod
> 
> Then why do I need to create iscsi directory by hand?

Hello Tomonori,

Welcome to the world of configfs-based SCSI target configuration
infrastructure!

Configfs is user space driven and only by user space. This is the main
reason why I from the very beginning have writing that it isn't suitable
for managing SCSI targets.

Needless to say that SCST's sysfs-based configuration infrastructure
doesn't suffer from this limitation and allows creation of entries from
both kernel and user spaces.

Vlad
