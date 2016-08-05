From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 00/22] FCoE VN2VN fixes
Date: Fri, 5 Aug 2016 08:33:17 -0700
Message-ID: <a0c55b8f-7ab3-28f5-a95c-aa83fd94c88a@sandisk.com>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <3fbe8456-182a-d7da-068d-28866aef5314@sandisk.com>
 <46f7c046-3ed7-d087-6fcf-2f92d8167fde@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:31330
	"EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759938AbcHEPd0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 11:33:26 -0400
In-Reply-To: <46f7c046-3ed7-d087-6fcf-2f92d8167fde@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On 08/05/2016 12:43 AM, Hannes Reinecke wrote:
> On 08/04/2016 04:59 PM, Bart Van Assche wrote:
>> On 08/03/16 06:13, Hannes Reinecke wrote:
>>> As usual, comments and reviews are welcome.
>>
>> Great work :-) Have you been testing these patches against the LIO FCoE
>> target driver? In that case you might need to port the following patch
>> to LIO, a patch that fixes a subtle data corruption issue:
>> https://sourceforge.net/p/scst/svn/4969.
>>
> Indeed I have. With this patchset I've managed to run FCoE over virtio
> with LIO running on the host. Quite cool, methinks :-)
>
> And indeed, your patch seem to be helping with the issues I've seen
> (mysterious out-of-order frames and wireshark complaining about invalid
> frames).
> Still a bit hackish, though. Can't we move the data destructor into the
> skb itself and not free the data in the target core?

Hello Hannes,

Several LIO drivers already support sending data asynchronously to the 
initiator, e.g. the ib_srpt and qla2x00t drivers. These drivers avoid 
that struct se_cmd and its data buffer are freed before sending finished 
by passing the TARGET_SCF_ACK_KREF flag to target_submit_cmd_map_sgls() 
and by calling target_put_sess_cmd() after the data transfer has 
finished. Since the tcm_fc driver already specifies TARGET_SCF_ACK_KREF 
when submitting commands to the LIO core I think what's needed to make 
use_sg=1 safe in the tcm_fc driver is for use_sg=1 to move the 
target_put_sess_cmd() call from ft_queue_status() into a callback 
function that is called when transmitting data has finished. Maybe the 
SKBTX_DEV_ZEROCOPY flag can be used to make the network stack invoke an 
appropriate callback function. See e.g. xenvif_zerocopy_callback() in 
the xen-netback driver.

Bart.
