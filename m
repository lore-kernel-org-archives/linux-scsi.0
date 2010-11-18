From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 12/16] BNX2I: Added feature to silently drop NOPOUT request
Date: Thu, 18 Nov 2010 14:04:38 -0600
Message-ID: <4CE586D6.3060803@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-13-git-send-email-eddie.wai@broadcom.com> <4CE4A030.7080004@cs.wisc.edu> <1290108358.6191.124.camel@ltirv-waie-lx1> <4CE584C6.7070300@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <open-iscsi+bncCLPJla3WGRD8iZbnBBoEdS26uA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4CE584C6.7070300-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Eddie Wai <waie-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, James Bottomley <JBottomley-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/18/2010 01:55 PM, Mike Christie wrote:
> On 11/18/2010 01:25 PM, Eddie Wai wrote:
>>
>> On Wed, 2010-11-17 at 19:40 -0800, Mike Christie wrote:
>>> On 11/10/2010 05:04 PM, Eddie Wai wrote:
>>>> In the case the chip is undergoing different invasive operation
>>>> which requires a chip reset, all NOPOUT request during this period
>>>
>>> For these invasive operations that reset the chip, do we always end up
>>> having to relogin the connection/session or once the reset is done are
>>> we able to just go on happily like nothing ever happened?
>> Operations like mtu change/ifupdown/etc will require the chip to undergo
>> reset. Prior to this, the connections will be cleaned up via the
>> conn_failure->ep_disconnect path and eventually put into the reopen
>> recovery path. During this period, we must disallow any send pdu
>> requests to be queued to the chip for a more immediately connection tear
>> down time (so we don't have to wait for the pdu's completion).
>>
>> We had to treat NOPOUT requests differently as the routine in libiscsi
>> would continuously loop until the NOPOUT send request returns with
>> success. This is the why we added the NOPOUT workaround.
>
> At this time, have you already called iscsi_conn or session failure? If
> so then I think it sounds like there is bug in iscsi_send_nopout or
> __iscsi_conn_send_pdu. If the conn/session has been failed, I think we
> want to add a check in __iscsi_conn_send_pdu where if the conn/session
> is down then we do not send NOPs. There is no point iSCSI RFC wise and
> it screws up drivers.

We actually have a check in __iscsi_conn_send_pdu. There is the 
session->state == ISCSI_STATE_LOGGED_IN, so I guess you have not called 
one of the iscsi failure functions.

At this time, is just the apdater_state getting changed? What code path 
is that?

Maybe related... For bnx2i_get_link_state ADAPTER_STATE_LINK_DOWN, I 
think you will want to call the iscsi_suspend_queue function discussed 
in the other mail. When the link state comes back up though, do we 
always have to reconnect and relogin to the target or are their cases 
where we can just restart the queues?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
