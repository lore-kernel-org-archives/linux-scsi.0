From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 0/8] Drop host_lock around LLD SHT->queuecommand() caller
Date: Fri, 17 Sep 2010 14:26:04 -0400
Message-ID: <4C93B2BC.8000404@garzik.org>
References: <1284676521-10737-1-git-send-email-nab@linux-iscsi.org> <1284686949.7280.99.camel@schen9-DESK> <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51658 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0IQS0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2010 14:26:10 -0400
In-Reply-To: <1284687070.13344.135.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>

On 09/16/2010 09:31 PM, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-16 at 18:29 -0700, Tim Chen wrote:
>> On Thu, 2010-09-16 at 15:35 -0700, Nicholas A. Bellinger wrote:
>>> From: Nicholas Bellinger<nab@linux-iscsi.org>
>>>
>>> Greetings all,
>>>
>>> This series contains the first round of a whole-sale conversion for droping
>>> struct Scsi_Host->host_lock around struct Scsi_Host->queuecommand() within
>>> scsi_dispatch_cmd().  So with this first patch the only part of scsi_dispatch_cmd()
>>> that is protected by host_lock is scsi_cmd_get_serial)_.
>>>
>>
>> Maybe we can change the host->cmd_serial_number to atomic and totally
>> avoid the need to take host_lock.
>
> Hmmmm good point, then we would also need an atomic_t for signaling
> (shost_state == SHOST_DEL) in scsi_dispatch_cmd() to be able to
> completly drop host_lock usage within scsi_dispatch_cmd().
>
> I can take a look at doing this specific part, if you would be willing
> to have a look at the host->cmd_serial_number conversion piece.  ;)

But that raises the familiar tale of:  using multiple atomics (w/ their 
locked instructions) may cost more than a spinlock.

	Jeff



