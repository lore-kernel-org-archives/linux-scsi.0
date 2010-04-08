From: "Anil Veerabhadrappa" <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: PATCH] BNX2I : Bug fixes related to MTU change issue when
 there are active iscsi sessions
Date: Thu, 8 Apr 2010 15:45:20 -0700
Message-ID: <1270766720.28522.109797.camel@anilgv-desktop>
References: <1270761372.28522.109699.camel@anilgv-desktop>
 <4BBE592A.2070202@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCOOx4c-cFBD0uPndBBoEM9hn8A-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <4BBE592A.2070202-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "James.Bottomley-l3A5Bk7waGM@public.gmane.org" <James.Bottomley-l3A5Bk7waGM@public.gmane.org>, linux scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-04-08 at 15:31 -0700, Mike Christie wrote:
> On 04/08/2010 04:16 PM, Anil Veerabhadrappa wrote:
> > +	/* Wait for all endpoints to be torn down, Chip will be reset once
> > +	 *  control returns to network driver. So it is required to cleanup and
> > +	 * release all connection resources before returning from this routine.
> > +	 */
> > +	wait_event_interruptible_timeout(hba->eh_wait,
> > +					 (hba->ofld_conns_active == 0),
> > +					 hba->hba_shutdown_tmo);
> 
> 
> Hey, I just noticed this (sorry I should have seen this earlier), but 
> there is no wake_up(hba->eh_wait). Do you want one in bnx2i_free_ep when 
> ofld_conns_active goes to 0?

Thanks Mike. Missed this bit while merging. It is better to call
wake_up() at the end of bnx2i_ep_disconnect() after bnx2i driver
unregisters the device. I will resend the patch.

Thanks again.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
