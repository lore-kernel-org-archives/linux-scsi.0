From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less	w/	interrupts
 disabled internally
Date: Sun, 26 Dec 2010 21:44:58 -0600
Message-ID: <4D180BBA.3050709@cs.wisc.edu>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>	 <20101219233835.GJ1263@parisc-linux.org>	 <1292807703.20840.29.camel@haakon2.linux-iscsi.org>	 <1292808126.20840.33.camel@haakon2.linux-iscsi.org>	 <20101220020758.GK1263@parisc-linux.org>	 <1292837413.20840.47.camel@haakon2.linux-iscsi.org>	 <4D0FF6A5.9040209@cs.wisc.edu> <1293139434.4649.122.camel@haakon2.linux-iscsi.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRCcmeDoBBoEdJBm1g-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1293139434.4649.122.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 12/23/2010 03:23 PM, Nicholas A. Bellinger wrote:
> On Mon, 2010-12-20 at 18:36 -0600, Mike Christie wrote:
>> On 12/20/2010 03:30 AM, Nicholas A. Bellinger wrote:
>>> After a quick audit of iscsi_session->lock usage, and I see that
>>> iscsi_complete_pdu(), iscsi_tmf_timedout(), iscsi_eh_cmd_timed_out(),
>>> iscsi_check_transport_timeouts() are using spin_lock(), and
>>> iscsi_session_failure() and iscsi_conn_failure() are using
>>> spin_lock_irqsave().
>>>
>>> Mike and Hannes, would you guys mind commenting on this..?  From what I
>>> can determine these should all be converted to use spin_lock_bh(),
>>> yes..?
>>>
>>
>> Yeah, they can use _bh locking. I was going to use them for qla4xxx eh,
>> which does iscsi processing in its irq, but we never did.
>
> Thanks for the clarification.  I would be happy to submit a patch next
> week for this seperately from the host_lock-less conversion pieces, or
> would you prefer handle this yourself..?
>

I am testing something now. Do not worry about it. Thanks for the work 
on this.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
