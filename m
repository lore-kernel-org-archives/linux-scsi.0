From: "Jun'ichi Nomura" <jnomura@mtc.biglobe.ne.jp>
Subject: Re: megaraid driver always fails to reset adapter
Date: Tue, 01 Mar 2005 15:50:23 -0500
Message-ID: <4224D58F.6060400@mtc.biglobe.ne.jp>
References: <0E3FA95632D6D047BA649F95DAB60E570230CBE1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Received: from mx1.redhat.com ([66.187.233.31]:52958 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262072AbVCAUuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 15:50:40 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CBE1@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: linux-scsi@vger.kernel.org

Hi,
thanks for the info.

Adding one more 'F' to the loop counter works.
i.e. 0xFFFFFF.

Just adding rmb() didn't solve the problem though it
may decrease the necessary counter value.

I don't know this value is ok for environments other than mine.

Bagalkote, Sreenivas wrote:
> Please try:
> 
> In mbox_post_sync_cmd_fast(...) replace
> 
> for (i = 0; i < 0xFFFFF; i++) {
> 	if (mbox->numstatus != 0xFF) break;
> }
> 
> with
> 
> for (i = 0; i < 0xFFFFF; i++) {
> 	if (mbox->numstatus != 0xFF) break;
> 	rmb();
> } 
> 
> Additionally, increase the loop counter to a bigger value.
> 
> Thanks,
> Sreenivas
> LSI LOGIC Corporation 
> 
> 
>>-----Original Message-----
>>From: Jun'ichi Nomura [mailto:jnomura@mtc.biglobe.ne.jp] 
>>Sent: Tuesday, March 01, 2005 1:36 PM
>>To: linux-scsi@vger.kernel.org
>>Subject: megaraid driver always fails to reset adapter
>>
>>Hello,
>>
>>I found that the megaraid driver always fails to reset the
>>adapter with the following message:
>>   megaraid: resetting the host...
>>   megaraid mbox: reset sequence completed successfully
>>   megaraid: fast sync command timed out
>>   megaraid: reservation reset failed
>>when the "Cluster mode" of the adapter BIOS is enabled.
>>So, whenever the reset occurs, the adapter goes to
>>offline and just become unavailable.
>>
>>Is this a known problem?
>>
>>I tried 2.6.9 and 2.6.11-rc5 and the results were the same.
>>I used sg_reset to invoke reset artificially to test this.
>>
>>The problem doesn't occur if I disabled the "Cluster mode"
>>parameter in the adapter BIOS.
>>
>>I'm not sure how well the currenet megaraid driver supports
>>the "Cluster mode".
>>I appreciate if you have any idea.
>>
>>Thanks,
>>Jun'ichi Nomura
