From: "Jeff Mahoney" <jeffm@suse.com>
Subject: Re: [PATCH RFC] increase ST_MAX_TAPES from 128 to 1024
Date: Fri, 17 Aug 2012 15:35:43 -0600
Message-ID: <502E64D50200007E000C44DA@novprvoes0310.provo.novell.com>
References: <1345215024-5883-1-git-send-email-revers@redhat.com>
 <1345217873.2838.12.camel@dabdike.int.hansenpartnership.com>
 <502EB04D.2000007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from novprvoes0310.provo.novell.com ([137.65.248.74]:48217 "EHLO
	novprvoes0310.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757876Ab2HQVz7 convert rfc822-to-8bit
	(ORCPT <rfc822;groupwise-linux-scsi@vger.kernel.org:5:1>);
	Fri, 17 Aug 2012 17:55:59 -0400
In-Reply-To: <502EB04D.2000007@redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: revers@redhat.com
Cc: James.Bottomley@HansenPartnership.com, Kai.Makisara@kolumbus.fi, Lee Duncan <LDuncan@suse.com>, linux-scsi@vger.kernel.org

The preallocation of cdevs is also addressed in my patch set. I'll send it out as soon as I'm at my notebook again.

-Jeff

--
Jeff Mahoney
(apologies for the top post -- from my mobile)

On Aug 17, 2012, at 4:58 PM, "Rob Evers <revers@redhat.com>" <revers@redhat.com> wrote:

> On 08/17/2012 11:37 AM, James Bottomley wrote:
>> On Fri, 2012-08-17 at 10:50 -0400, Rob Evers wrote:
>>> Wondering if this would be an acceptable interim solution
>>> to increasing the limit on the number of tape drives
>>> while http://marc.info/?l=linux-scsi&m=134212042809524&w=2
>>> gets sorted out.
>>> 
>>> Signed-off-by: Rob Evers<revers@redhat.com>
>>> ---
>>>  drivers/scsi/st.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>> 
>>> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
>>> index b548923..408d24f 100644
>>> --- a/drivers/scsi/st.h
>>> +++ b/drivers/scsi/st.h
>>> @@ -76,7 +76,7 @@ struct st_modedef {
>>>  #define ST_MODE_SHIFT (7 - ST_NBR_MODE_BITS)
>>>  #define ST_MODE_MASK ((ST_NBR_MODES - 1)<<  ST_MODE_SHIFT)
>>> 
>>> -#define ST_MAX_TAPES 128
>>> +#define ST_MAX_TAPES 1024
>> This is going to cause an order 2 GFP_ATOMIC allocation (on 64 bit
>> platforms) for the contiguous scsi_tapes array ... if large numbers of
>> tapes are genuinely required, shouldn't we fix this first and then
>> expand the number quite a bit more?
>> 
>> James
>> 
> 
> Pre allocation of cdevs during init time needs addressing as well
> to increase ST_MAX_TAPES quite a bit more, right?
> 
> Would leaving out Lee's sysfs updates out be ok, if ST_MAX_TAPES were
> significantly increased?
> 
> Rob
> 
> 

