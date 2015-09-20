From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: Fix a bdi reregistration race
Date: Sun, 20 Sep 2015 06:49:27 -0700
Message-ID: <55FEB967.7040500@acm.org>
References: <55FCAB0E.3020707@sandisk.com>
	<55FE8324.9000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:57909 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbbITOPl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Sep 2015 10:15:41 -0400
In-Reply-To: <55FE8324.9000604@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: James Bottomley <jbottomley@odin.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/20/15 02:57, Sagi Grimberg wrote:
> On 9/19/2015 3:23 AM, Bart Van Assche wrote:
>> Unregister and reregister BDI devices in the proper order. This patch
>> avoids that the following kernel warning can get triggered:
>
> Can you share the scenario that reproduced this? I think I might
> have seen this before.

Hello Sagi,

The details of the setup on which I can reproduce the reported behavior 
easily are as follows:
* Several kernel debugging options were enabled on the initiator system
   (PROVE_LOCKING, SLUB_DEBUG, KMEMLEAK, ...).
* srp_daemon and multipathd were running on the initiator system.
* Four IB ports were present the initiator system.
* Eight IB ports were present the target system.
* 100 LUNs were defined on the target system.
* As a result, 3200 /dev/sd* device nodes were created on the
   initiator system by the SRP initiator driver.
* The following command was run on the initiator system:
   for p in /sys/class/srp_remote_ports/*; do echo 1 >$p/delete & done;
   wait; dmsetup remove_all

Bart.
