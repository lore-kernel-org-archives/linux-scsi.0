From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [ANNOUNCE] Adaptec SAS/SATA device driver [17/27]
Date: Thu, 17 Feb 2005 16:16:44 -0500
Message-ID: <421509BC.3090708@adaptec.com>
References: <4214D645.60709@adaptec.com> <m14qgadhdg.fsf@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from magic.adaptec.com ([216.52.22.17]:4776 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261151AbVBQVQt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Feb 2005 16:16:49 -0500
In-Reply-To: <m14qgadhdg.fsf@muc.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>
Cc: linux-scsi@vger.kernel.org

On 02/17/05 16:08, Andi Kleen wrote:
> Luben Tuikov <luben_tuikov@adaptec.com> writes:
> 
> 
> 
>>+/********************************** Misc Macros *******************************/
> 
> 
> [... lots of code...]
> 
> What are they all good for? As far as I can see every one of them
> duplicates or wraps something Linux already has.
> 
> How about you just use the native Linux functions directly?
> 
>  +
> 
>>+#if KDB_ENABLE
>>+#define ASSERT(expression)						\
>>+	if (!(expression)) {						\
>>+		printk("assertion failed: %s, file: %s, line: %d\n",	\
>>+			#expression, __FILE__, __LINE__);		\
>>+		KDB_ENTER();						\
>>+	}
>>+#else
>>+#define ASSERT(expression)						\
>>+	if (!(expression)) {						\
>>+		panic("assertion failed: %s, file: %s, line: %d\n",	\
>>+			#expression, __FILE__, __LINE__);		\
>>+	}
>>+#endif
> 
> 
> That's called BUG_ON in Linux land.

Hi Andi,

Yes I agree.  As I didn't write this code I hadn't noticed this.
 
> 
>>+#ifndef list_for_each_entry_safe
> 
> 
> [...]
> 
> Such compat code does not really belong into a 2.6 driver.

Yes, that's true.  The driver was written to compile for 2.4 as well
as for 2.6.
 
> 
>>+
>>+#define list_move_all(to_list, from_list)				\
> 
> 
> [...]
> 
> And this should be put into list.h

Yes, I agree.

	Luben

 
