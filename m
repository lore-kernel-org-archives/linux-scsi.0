From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: megaraid driver always fails to reset adapter
Date: Tue, 1 Mar 2005 16:01:53 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570230CBE2@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Received: from mail0.lsil.com ([147.145.40.20]:59841 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262066AbVCAVCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 16:02:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jun'ichi Nomura' <jnomura@mtc.biglobe.ne.jp>
Cc: linux-scsi@vger.kernel.org

Great! Can you give us details about your environment? 
If it makes sense, we will increase the loop counter in the driver.

Thanks,
Sreenivas
LSI LOGIC Corporation

>-----Original Message-----
>From: Jun'ichi Nomura [mailto:jnomura@mtc.biglobe.ne.jp] 
>Sent: Tuesday, March 01, 2005 3:50 PM
>To: Bagalkote, Sreenivas
>Cc: linux-scsi@vger.kernel.org
>Subject: Re: megaraid driver always fails to reset adapter
>
>Hi,
>thanks for the info.
>
>Adding one more 'F' to the loop counter works.
>i.e. 0xFFFFFF.
>
>Just adding rmb() didn't solve the problem though it
>may decrease the necessary counter value.
>
>I don't know this value is ok for environments other than mine.
>
>Bagalkote, Sreenivas wrote:
>> Please try:
>> 
>> In mbox_post_sync_cmd_fast(...) replace
>> 
>> for (i = 0; i < 0xFFFFF; i++) {
>> 	if (mbox->numstatus != 0xFF) break;
>> }
>> 
>> with
>> 
>> for (i = 0; i < 0xFFFFF; i++) {
>> 	if (mbox->numstatus != 0xFF) break;
>> 	rmb();
>> } 
>> 
>> Additionally, increase the loop counter to a bigger value.
>> 
>> Thanks,
>> Sreenivas
>> LSI LOGIC Corporation 
>> 
>> 
>>>-----Original Message-----
>>>From: Jun'ichi Nomura [mailto:jnomura@mtc.biglobe.ne.jp] 
>>>Sent: Tuesday, March 01, 2005 1:36 PM
>>>To: linux-scsi@vger.kernel.org
>>>Subject: megaraid driver always fails to reset adapter
>>>
>>>Hello,
>>>
>>>I found that the megaraid driver always fails to reset the
>>>adapter with the following message:
>>>   megaraid: resetting the host...
>>>   megaraid mbox: reset sequence completed successfully
>>>   megaraid: fast sync command timed out
>>>   megaraid: reservation reset failed
>>>when the "Cluster mode" of the adapter BIOS is enabled.
>>>So, whenever the reset occurs, the adapter goes to
>>>offline and just become unavailable.
>>>
>>>Is this a known problem?
>>>
>>>I tried 2.6.9 and 2.6.11-rc5 and the results were the same.
>>>I used sg_reset to invoke reset artificially to test this.
>>>
>>>The problem doesn't occur if I disabled the "Cluster mode"
>>>parameter in the adapter BIOS.
>>>
>>>I'm not sure how well the currenet megaraid driver supports
>>>the "Cluster mode".
>>>I appreciate if you have any idea.
>>>
>>>Thanks,
>>>Jun'ichi Nomura
>
