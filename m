From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFC] SCSI EH document
Date: Tue, 30 Aug 2005 06:38:03 +0900
Message-ID: <4313803B.3060703@gmail.com>
References: <20050826035326.GA13392@htj.dyndns.org> <430F8AE0.7080806@pobox.com> <4312D213.9000402@gmail.com> <431358FB.6050005@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.192]:24287 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1751137AbVH2ViI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 17:38:08 -0400
Received: by rproxy.gmail.com with SMTP id r35so1074163rna
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 14:38:08 -0700 (PDT)
In-Reply-To: <431358FB.6050005@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@steeleye.com, luben_tuikov@adaptec.com, albertcc@tw.ibm.com, linux-scsi@vger.kernel.org


  Hi, Jeff.

Jeff Garzik wrote:
> Tejun Heo wrote:
> 
>>> Both all the list-heads need to be cleared, otherwise there may be 
>>> list corruption next time the element is added to the list_head.
>>>
>>
>>  scmd->eh_entry is never used as list head.  It's always used as list 
>> entry.  So, technically, it needs not be cleared, I think.  No?  The 
>> problem we had was w/ shost->eh_cmd_q not being cleared.
> 
> 
> Every node is a list_head.  You want all pointers for all nodes pointing 
> to something useful, even if they are not actively present on a list, so 
> that they may be easily and corrected added to a list at a later time. 
> Read list_del_init() for example.
> 
>     Jeff
> 

  Okay... to make things clearer.  A struct list_head can have two roles.

  list head  : other list_head gets added to it
  list entry : gets added to other list_head

  When a struct list_head acts as list head, it always needs to be in 
clean (pointing to valid things) state before being used.  When a struct 
list_head acts as list entry, its current content doesn't matter.

  AFAICS, scmd->eh_entry is currently not used as list head in any 
place, neither do we use list_empty() test on it to determine whether or 
not it's on a list.  The original code does clear scmd->eh_entry all the 
time and I am very okay with that.  I just wanted to make sure that I 
didn't miss something regarding scmd->eh_entry's usage.

  If I'm missing such a usage, can you please point out?

  Thanks. :-)

-- 
tejun
