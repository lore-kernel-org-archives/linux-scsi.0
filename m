From: James Smart <james.smart-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Fri, 19 Mar 2010 08:56:30 -0400
Message-ID: <4BA3747E.4020104@emulex.com>
References: <20100317180647.GA25863@serverengines.com>	<20100318225808Z.fujita.tomonori@lab.ntt.co.jp>	<4BA294FC.3030400@cs.wisc.edu> <20100319081016W.fujita.tomonori@lab.ntt.co.jp>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <3iXSjSwsKCuwXOaSg.gaOfhSaiZSl.QcacdSb-WgQgWUccUZSUfcidg.Qca-WNnxsJb2WYALHLMFiseIBxPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
In-Reply-To: <20100319081016W.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org" <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org" <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James.Bottomley-l3A5Bk7waGM@public.gmane.org" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



FUJITA Tomonori wrote:
> On Thu, 18 Mar 2010 16:02:52 -0500
> Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> wrote:
> 
>> On 03/18/2010 08:58 AM, FUJITA Tomonori wrote:
>>> - You invent your hardware specific data structure for the simplest
>>>    operation such as setting IP address.
>> I think this is what Jay is not trying to do. I think the patch has some 
>> extra code like the ISCSI_BSG_HST_VENDOR parts that makes it confusing - 
>> it got me too. The ISCSI_BSG_HST_VENDOR code in be2iscsi looks like it 
>> is basically disabled (should remove for a formal patch when he sends 
>> for merging).
>>
>> It looks like there is a common struct iscsi_bsg_common_format that is 
>> getting passed around, and then in be2iscsi the driver is using that 
>> info to make a be2iscsi specific command. So scsi_transport_iscsi / 
>> ISCSI_SET_IP_ADDR / iscsi_bsg_common_format  gets translated by b2iscsi 
>> to b2iscsi / OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR / be_modify_ip_addr.
> 
> Yeah, seems you are right. But looks like this patchset also adds the
> vendor specific message support (ISCSI_BSG_HST_VENDOR)?
> 
> I still want to know why vendors can't do this via the existing
> netlink interface. open-iscsi uses the netlink interface for some pdu
> so I guess that having a different channel for management might be a
> good idea.

Separate this request into two needs:

The first need is for the iscsi driver to have some kind of entry point to 
kick off a vendor specific thing - primarily diagnostics and internal f/w and 
flash mgmt items. Here, using the same mechanism that we had on the FC side, 
which also supports dma payloads, made a lot of sense. I like and prefer the 
symmetry.

The second need is for "common iscsi link/stack mgmt". All vendors would be 
expected to implement the same items the same way - thus the formalization of 
the api in the transport.  It also makes sense that all use of these common 
interfaces comes via the open-iscsi mgmt utilities.  Given the data set, it 
could be done by netlink or bsg.  I gave some pros/cons on the interfaces in 
(http://marc.info/?l=linux-scsi&m=124811693510903&w=2). In my mind, the main 
reason these settings ended up in bsg vs netlink is - the functionality is 
typically migrating from a vendor-specific ioctl set, which maps rather easily 
to the bsg model. Not that netlink is that more difficult (although to NLA_ or 
not may confuse some of the contributors). And, if you already had the bsg 
infrastructure for the first need, you had to add very little to support it.

Thus, the main reason they are together is one of expediency. The first had to 
be done, so it was very easy to use the same methodology for the second.

-- james s

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
