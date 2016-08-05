From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/22] FCoE VN2VN fixes
Date: Fri, 5 Aug 2016 18:16:53 +0200
Message-ID: <9c092661-141b-f6bc-a8dc-872faaf128b4@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <3fbe8456-182a-d7da-068d-28866aef5314@sandisk.com>
 <46f7c046-3ed7-d087-6fcf-2f92d8167fde@suse.de>
 <a0c55b8f-7ab3-28f5-a95c-aa83fd94c88a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51930 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbcHEQQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 12:16:56 -0400
In-Reply-To: <a0c55b8f-7ab3-28f5-a95c-aa83fd94c88a@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On 08/05/2016 05:33 PM, Bart Van Assche wrote:
> On 08/05/2016 12:43 AM, Hannes Reinecke wrote:
>> On 08/04/2016 04:59 PM, Bart Van Assche wrote:
>>> On 08/03/16 06:13, Hannes Reinecke wrote:
>>>> As usual, comments and reviews are welcome.
>>>
>>> Great work :-) Have you been testing these patches against the LIO FCoE
>>> target driver? In that case you might need to port the following patch
>>> to LIO, a patch that fixes a subtle data corruption issue:
>>> https://sourceforge.net/p/scst/svn/4969.
>>>
>> Indeed I have. With this patchset I've managed to run FCoE over virtio
>> with LIO running on the host. Quite cool, methinks :-)
>>
>> And indeed, your patch seem to be helping with the issues I've seen
>> (mysterious out-of-order frames and wireshark complaining about invalid
>> frames).
>> Still a bit hackish, though. Can't we move the data destructor into the
>> skb itself and not free the data in the target core?
>
> Hello Hannes,
>
> Several LIO drivers already support sending data asynchronously to the
> initiator, e.g. the ib_srpt and qla2x00t drivers. These drivers avoid
> that struct se_cmd and its data buffer are freed before sending finished
> by passing the TARGET_SCF_ACK_KREF flag to target_submit_cmd_map_sgls()
> and by calling target_put_sess_cmd() after the data transfer has
> finished. Since the tcm_fc driver already specifies TARGET_SCF_ACK_KREF
> when submitting commands to the LIO core I think what's needed to make
> use_sg=1 safe in the tcm_fc driver is for use_sg=1 to move the
> target_put_sess_cmd() call from ft_queue_status() into a callback
> function that is called when transmitting data has finished. Maybe the
> SKBTX_DEV_ZEROCOPY flag can be used to make the network stack invoke an
> appropriate callback function. See e.g. xenvif_zerocopy_callback() in
> the xen-netback driver.
>
Well, Johannes and me looked into that a bit closer; there actually _is_ 
a destructor callback in the sk_buff, so in theory we could hook into 
that. However, I'm not sure if that's working as intended; the FCoE 
stack does a lot of skb_clone(), and my setup even more so (tcm_fc over 
vlan over veth over bridge over tap into the guest).
So it's anyones guess at which point of the chain the original data will 
be freed. And whether the 'netdev' point still points to tcm_fcs netdev ...
Debugging continues.

Cheers,

Hannes


-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
