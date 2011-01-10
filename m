From: "Karen Xie" <kxie-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: RE: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info
Date: Mon, 10 Jan 2011 14:57:16 -0800
Message-ID: <8A71B368A89016469F72CD08050AD33408D574F5@maui.asicdesigners.com>
References: <201101072245.p07MjdBm027576@localhost6.localdomain6> <4D27A500.2020009@cs.wisc.edu> <4D27A628.7040008@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D571D6@maui.asicdesigners.com> <4D27E6AA.5010304@cs.wisc.edu> <8A71B368A89016469F72CD08050AD33408D5743D@maui.asicdesigners.com> <4D2B6494.8070406@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCNvLk8fsDxC_na7pBBoEtdOYiQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-class: urn:content-classes:message
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Yes, that's bug this patch is fixing too. The current implementation
does not replenish the gl_skb after the initial allocation.

I am working on an update which utilizing a pool of skbs, and those skbs
would be used not only for the ddp setups (like the current gl_skb) but
also for the connection management like the rx credit returns. So this
skb pool will not reside in cxgbi_ddp_info, so still need to get rid of
gl_skb. I guess this patch can be viewed as an interim fix.

-----Original Message-----
From: Mike Christie [mailto:michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org] 
Sent: Monday, January 10, 2011 11:57 AM
To: Karen Xie
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org; linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Subject: Re: [PATCH 2/2] cxgbi: get rid of gl_skb in cxgbi_ddp_info

On 01/10/2011 11:52 AM, Karen Xie wrote:
> Hi, Mike,
>
> What I mean is even if cxgb3i maintains a pool of skbs (equivalent of
> gl_skbs). Once they are handed down to the network layer cxgb3 they
will
> still be freed by the network driver (on the tx path).
>

So hows does it work now? It seems ddp_alloc_gl_skb is called at device 
setup time, then when IO is queued/xmited we run ddp_set_map which 
allocates from gl_skbs. If when you transmit the IO, the driver frees 
the skb, how does gl_skb get replenished?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
