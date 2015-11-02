From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RESEND PATCH v3] scsi: stex: Remove use of struct timeval
Date: Mon, 2 Nov 2015 08:49:56 +0100
Message-ID: <563715A4.5030400@suse.de>
References: <20151030083040.GA31741@tina-laptop> <56335B69.4010502@suse.de>
 <5927653.jpoZ2K5FqB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbbKBHt6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:49:58 -0500
In-Reply-To: <5927653.jpoZ2K5FqB@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, y2038@lists.linaro.org, linux-kernel@vger.kernel.org

On 10/30/2015 01:45 PM, Arnd Bergmann wrote:
> On Friday 30 October 2015 12:58:33 Hannes Reinecke wrote:
>>> @@ -1076,7 +1069,7 @@ static int stex_ss_handshake(struct st_hba *hba)
>>>       h->req_cnt = cpu_to_le16(hba->rq_count+1);
>>>       h->status_sz = cpu_to_le16(sizeof(struct status_msg));
>>>       h->status_cnt = cpu_to_le16(hba->sts_count+1);
>>> -     stex_gettime(&h->hosttime);
>>> +     h->hosttime = cpu_to_le64(ktime_get_real_seconds());
>>>       h->partner_type = HMU_PARTNER_TYPE;
>>>       h->extra_offset = h->extra_size = 0;
>>>       scratch_size = (hba->sts_count+1)*sizeof(u32);
>>>
>> Just remove 'hosttime' altogether. It serves no purpose whatsoever.
>>
>>
> 
> Are you sure? It is defined in a struct that is shared with the HBA
> as part of hba->dma_mem, so unless you have access to the firmware,
> it's hard to guess what it might be used for inside of the firmware.
> 
Ah, you're right. Okay, so we'll need to convert it.

Cheers,

Hannes
