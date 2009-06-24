From: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: Re: how to do fc_remote_port_delete correctly
Date: Wed, 24 Jun 2009 10:40:30 -0400
Message-ID: <4A423ADE.80306@emulex.com>
References: <4A4172FA.70008@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4A4172FA.70008-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
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
> This seems pretty basic, but I'm having trouble with it.
>
> The current libfc code has a private structure called fc_rport_libfc_priv
> that gets allocated along with the fc_rport structure.
>
> I'm working on patches that restructure this to be separately allocated,
> since we need a the private structure to be around before we can do
> fc_remote_port_add().  It's a long story, but my question applies to
> any FC driver that wants to allocate its rport private data separately.
>   
Most of the other fc drivers are in this position already, and always 
have been. They've been the reverse - they desire a position where they 
could move to rport data, but you seem to always need a context before 
you know what it is enough to talk to the transport.
> How should rport->dd_data be set to NULL before/after calling
> fc_rport_delete().
>   
You never do set it to NULL. This is the role of the transport, and it 
will do so after calling the devloss_tmo_callbk(), which is the 
"end-of-life" indicator for the rport.

If you are changing it - it can cause problems as the transport still 
has the rport active, may make other calls, etc until 
devloss_tmo_callbk() would occur.

> I used to set it to NULL before, but figure it's safer to clear it after
> terminate_io has been called.  I did a get_device(&rport->dev) first
> to be sure the rport doesn't get freed in the meantime.
>   
terminate_io is one of those calls the transport tries to make before 
the rport truly dies.

> However, other threads may be in queuecommand already and already
> beyond their call to fc_remote_port_chkready() and will reference dd_data.
> Maybe they just aren't allowed do that?
>
> Or maybe dd_data isn't allowed to go NULL until the rport times
> out and is getting deleted?
>   
Yes. This last point.

> Maybe we need a small private rport data with just enough info for the I/O
> that's already in progress, or I can recode the I/O path to not use
> dd_data (it's mostly stuff that can be gotten through scsi_host instead).
>   
have it be whatever you need it to be. You can always maintain your own 
state flag in your own structure.

> Or maybe we need to do more in our fc_rport_terminate_io callback
> from fc_remote_port_delete() to be sure that all I/O really ceases.
> We currently do an exch_mgr_reset(), but perhaps some I/O thread hasn't
> allocated an exchange yet.
>   
Sounds like race conditions within all the library routines.   The 
transport has some simple expectations, and really doesn't care how many 
internal states the LLDD has. fc_rport_terminated_io() should terminate 
(or at least initiate termination) of anything within the driver (in a 
path post queuecommand()). Fc_remote_port_delete() is really just a 
notifier to the transport that connection to the rport has gone away and 
to start the devloss timers and block/reject new io requests - so it's 
too early in the process. I/O may or may not be killed as of 
rport_delete, as that's somewhat a LLDD policy (depends on FCP-2 
Recovery desires and how discovery engines work).

The devloss_tmo_callbk(), which is the "end-of-life" indicator for the 
rport, should never return from the LLDD until anything referencing the 
rport (a if you're using it's dd_data, that too), has been killed - as 
the transport may immediately "free" the rport after it's return.   Do 
you have a devloss_tmo_callbk() ?   

-- james

> Ideas?
>
> 	Thanks,
> 	Joe
>
>
>
> _______________________________________________
> devel mailing list
> devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
> http://www.open-fcoe.org/mailman/listinfo/devel
>
>   
