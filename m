From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Tue, 19 Oct 2004 16:57:44 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4174BAE8.50103@torque.net>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave> <4173C8DB.8030009@torque.net> <20041018183747.GA3530@us.ibm.com> <41743E41.8020707@torque.net> <20041018232352.GA4747@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:53127 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268049AbUJSG6a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 02:58:30 -0400
In-Reply-To: <20041018232352.GA4747@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org

Nishanth Aravamudan wrote:
> On Tue, Oct 19, 2004 at 08:05:53AM +1000, Douglas Gilbert wrote:
> 
>>Nishanth Aravamudan wrote:
>>
>>>On Mon, Oct 18, 2004 at 11:44:59PM +1000, Douglas Gilbert wrote:
>>>
>>>
>>>>James Bottomley wrote:
>>>>
>>>>
>>>>>On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
>>>>>
>>>>>
>>>>>
>>>>>>So this problem seems related to highmem.
>>>
>>>
>>><snip>
>>>
>>>>The above required a fair few changes to scsi_debug.
>>>>Attached is a patch that rolls "kmap" changes with
>>>>patches I have sent recently for scsi_debug.
>>>>Attachment is gzipped (due to size) and applies against
>>>>lk 2.6.8.1 -> lk 2.6.9-rc4 .
>>>>
>>>>Nishanth, could you test this with highmem?
>>>
>>>
>>>Doug,
>>>
>>>I ran 2.6.9-rc4 with your patch applied and had several dump_stack()s
>>>occur (complaining about sleeping in an invalid context) and a final
>>>panic during mkfs :) I think something is still wrong... ;) Output is
>>>below and attached.
>>
>>Ok, it looks like kmap_atomic() is needed.
>>Could you try this additional patch.
> 
> 
> Great! That patch seems to have fixed it. I am able to vi files, sync
> the scsi_debug 'disks' and not have any hangs. It is noticeably slower,
> though, it seems. Might that just be a side effect of the atomic calls?

One would expect it to be pretty fast since only a
ram copy is involved.

Perhaps James can comment on this strategy:

   if (( kaddr = page_address(scatp->page)) {
         kaddr += scatp->offset;
	memcpy(....);
   } else {
	kaddr = kmap_atomic(scatp->page) + scatp-offset;
	memcpy(....);
	kunmap_atomic(scatp->page);
   }

	
Doug Gilbert
