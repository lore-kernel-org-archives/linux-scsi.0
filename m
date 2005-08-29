From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [RFC] SCSI EH document
Date: Mon, 29 Aug 2005 18:27:25 -0400
Message-ID: <43138BCD.7060106@pobox.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431358FB.6050005@pobox.com> <4313803B.3060703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:62402 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751367AbVH2W1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 18:27:39 -0400
In-Reply-To: <4313803B.3060703@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> 
>  Hi, Jeff.
> 
> Jeff Garzik wrote:
> 
>> Tejun Heo wrote:
>>
>>>> Both all the list-heads need to be cleared, otherwise there may be 
>>>> list corruption next time the element is added to the list_head.
>>>>
>>>
>>>  scmd->eh_entry is never used as list head.  It's always used as list 
>>> entry.  So, technically, it needs not be cleared, I think.  No?  The 
>>> problem we had was w/ shost->eh_cmd_q not being cleared.
>>
>>
>>
>> Every node is a list_head.  You want all pointers for all nodes 
>> pointing to something useful, even if they are not actively present on 
>> a list, so that they may be easily and corrected added to a list at a 
>> later time. Read list_del_init() for example.
>>
>>     Jeff
>>
> 
>  Okay... to make things clearer.  A struct list_head can have two roles.
> 
>  list head  : other list_head gets added to it
>  list entry : gets added to other list_head
> 
>  When a struct list_head acts as list head, it always needs to be in 
> clean (pointing to valid things) state before being used.  When a struct 
> list_head acts as list entry, its current content doesn't matter.
> 
>  AFAICS, scmd->eh_entry is currently not used as list head in any place, 
> neither do we use list_empty() test on it to determine whether or not 
> it's on a list.  The original code does clear scmd->eh_entry all the 
> time and I am very okay with that.  I just wanted to make sure that I 
> didn't miss something regarding scmd->eh_entry's usage.
> 
>  If I'm missing such a usage, can you please point out?


I'm mainly talking at a higher level.  While it strictly doesn't matter 
in this instance, in general its a bad idea to clear a list using a

	list = (null)

operation.  Its a good way to leak references, leak memory, etc.

In this specific case it seems to be OK.

	Jeff


