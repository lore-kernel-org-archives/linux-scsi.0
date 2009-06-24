From: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to do fc_remote_port_delete correctly
Date: Wed, 24 Jun 2009 13:43:41 -0400
Message-ID: <4A4265CD.70509@emulex.com>
References: <4A4172FA.70008@cisco.com> <4A423ADE.80306@emulex.com>
	<4A425DF1.30005@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4A425DF1.30005-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Joe Eykholt wrote:
> James Smart wrote:
> That sounds doable.  One thing I'm wondering about is what if I
> re-discover the same remote port before devloss timeout.
>
> I'll create new context, but then when I do fc_remote_port_add()
> I'll find that the fc_rport already has a dd_data.   Now I have
> two contexts for the same rport.  I guess I could switch over to
> the old one, but it's a bit awkward.
>
> One aspect is that the newly discovered rport may have the same port_id
> but different port_name and/or node_name.  Since libfc shouldn't be
> concerned about what the binding method is, it may or may not be the
> same fc_rport as before.  So fc_remote_port_add should not be called
> until all three items are known, it seems to me.
>
> It would be nice if there was a way for scsi_transport_fc to allow
> creating the fc_rport with only port_id known and add functions to
> change port_name and/or node_name later.  However, that just passes
> the problem up to the transport.  It would be possible but unlikely
> for a new remote port to have the same port_name as an old one, and
> if that's the binding method, it's messy to handle.
>
>   

This is all a repeat of the discussion we had back in Sept 08 on "rogue" 
rports, which included a patch to add a routine fc_remote_port_alloc(), 
that essentially does everything you describe above.
http://www.open-fcoe.org/pipermail/devel/2008-September/000760.html
http://www.open-fcoe.org/pipermail/devel/2008-September/000837.html

What confuses me - I thought you were already using this, and that it 
was to be merged into the kernel tree when fcoe was merged. I don't know 
that it went anywhere, and if you're not using it, then we are where we 
should be I guess.


> BTW, why is it possible to bind by node_name?  It seems useless to me.
> If we made node_name just an attribute and not something that could
> be used for binding, it makes the problem slightly easier.  At least
> we could then create fc_rports before knowing the node name.
>   

I don't know why node name is interesting - this was something left in 
for compatibility reasons (I know our driver had this option before we 
introduced transport support).   I agree, no one in their sane mind 
should be doing it, but not everyone is sane (or one mans sanity is 
anothers madness).

node_name isn't the hiccup here.  We really need 2 elements - port_id, 
wwpn  - although we usually include wwnn as well as we treat the "name" 
as the <wwnn,wwpn> pair.  One without the other doesn't help.  The 
notion of the rogue rport was - you had an rport structure with nothing 
in it - so you could use the context for anything and at the time 
fc_remote_port_add() was called, you would either get the rport back 
(its new) or you would get the existing structure and the driver would 
have to resolve its internal state structures then throw away the rogue.

-- james s
