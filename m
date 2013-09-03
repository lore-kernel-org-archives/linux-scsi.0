From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Tue, 03 Sep 2013 11:13:30 +0200
Message-ID: <5225A83A.7090700@acm.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <1378105985-79686-4-git-send-email-hare@suse.de> <52248882.7060109@acm.org> <52248E6C.2060105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:33874 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3ICJNe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2013 05:13:34 -0400
In-Reply-To: <52248E6C.2060105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Mike Christie <michaelc@cs.wisc.edu>

On 09/02/13 15:11, Hannes Reinecke wrote:
> On 09/02/2013 02:45 PM, Bart Van Assche wrote:
>> This patch adds several new calls to LLD EH handlers. Is it
>> guaranteed that these will only be invoked before scsi_remove_host()
>> has finished ? For more background information, see also "[PATCH]
>> Make scsi_remove_host() wait until error handling finished"
>> (http://thread.gmane.org/gmane.linux.scsi/82572/focus=82779).
>>
> Well, that depends how scsi_remove_host() handles outstanding
> commands. What happens if you call scsi_remove_host() and there is
> still I/O in flight? I would assume that any HBA would have to kill
> any outstanding I/O prior to calling scsi_remove_host() (FC most
> certainly does this).
> Which would mean that it'll have to wait for scsi_put_command() to
> be called for all outstanding commands. And as scsi_put_command()
> will be called only _after_ our routine runs (see the reasoning
> above) we should be safe.

Hello Hannes,

Since fc_remove_host() has to be invoked before scsi_remove_host() and 
since fc_remove_host() changes the port state into FC_PORTSTATE_DELETED 
this means that fc_remote_port_chkready() will return DID_NO_CONNECT 
while scsi_remove_host() is in progress. I think this prevents that the 
SYNCHRONIZE CACHE command submitted by sd_remove() reaches SCSI disks 
over FC since sd_remove() is invoked from inside scsi_remove_host(). The 
SRP transport patch I had posted recently makes sure that the 
SYNCHRONIZE CACHE command submitted by sd_remove() reaches the target 
SCSI disk. This makes me wonder what the correct behavior is for SCSI 
transport drivers - disabling I/O before scsi_remove_host() starts or 
ensuring that I/O is still possible while scsi_remove_host() is in 
progress ? I think the call chain is as follows: scsi_remove_host() -> 
device_del() -> bus_remove_device() -> device_release_driver() -> 
__device_release_driver() -> sd_remove() -> sd_shutdown() -> 
sd_sync_cache().

Bart.
