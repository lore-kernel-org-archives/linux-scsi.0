From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: how to do fc_remote_port_delete correctly
Date: Wed, 24 Jun 2009 12:33:55 -0700
Message-ID: <4A427FA3.3050409@cisco.com>
References: <4A4172FA.70008@cisco.com> <4A423ADE.80306@emulex.com>
	<4A4254BC.6090302@emulex.com> <4A426698.3@cisco.com>
	<4A427107.6060303@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4A427107.6060303-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: James Smart <James.Smart-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

James Smart wrote:
> 
> 
> Joe Eykholt wrote:
>> It seems like there are two slightly different sets of rules depending
>> on whether dd_fcrport_size is zero or not, as specified by the LLDD.
>>
>> In the first model, where dd_fcrport_size is zero, the transport
>> never sets dd_data at all.  My understanding now is that its OK
>> for the LLDD to set it non-NULL, but not OK to change it after that.
>> I guess it would be OK but unnecessary to NULL it at dev_loss timeout
>> just before freeing the attached context.  These are the usage rules
>> I didn't fully understand. These rules are really established by
>> how the LLDDs I/O routines use dd_data.
> 
> No. In all cases where you see dd_data, the dd_data field is a transport 
> owned field.  The LLDD can change the contents of data pointed to by 
> dd_data, but an LLDD  is not supposed to change the dd_data field itself.

I didn't know that was the intent.  The comment "exported data" seems
to indicate the LLDD can use it.

In that case, there is no other good hook the LLDD could use for its
private data and this model would never be used.  Since the transport
never sets dd_data to anything (except NULL on initial allocation) in
this model, I think it would be OK for the LLDD to set it once, but it
does cause usage problems for the I/O routines.  I think most/all
LLDDs have non-zero dd_fcrport_size so this model isn't used.

>> In the second model, it doesn't seem like the LLDD has full control over
>> the contents pointed to by dd_data either, since when the remote
>> port is re-added the area pointed to by dd_data is cleared by the
>> transport, so we always start fresh.  This is fine, but has
>> implications on how the context is used during devloss.  For example,
>> it shouldn't be used for list linkage unless it's unlinked
>> before fc_remote_port_add.  All that's in the LLDDs control, so it's OK.
> 
> The only place the transport should be zero'ing the contents are:
> a) when it's allocated
> b) when it was deleted but kept around to hold the target id binding, then
>    reallocated. Note: by deleted, I mean it fully transitioned through
>    devloss_tmo_callbk() so for all intents and purposes, its as if it was
>    freed and realloc'd.
> 
> If there's another case, it's bug and we should be fixing it.

I didn't see any other case, and didn't mean to imply that there was.

>> For libfc, I'm leaning towards continuing to use a non-zero 
>> dd_fcrport_size
>> and the fc_rport_libfc_priv struct.   libfc could use a separately
>> allocated struct like fc_disc_rport for the discovery and
>> rport (PLOGI, PRLI, etc.) state machines.
> 
> makes sense
> 
>>
>> This is all an effort to clean up some issues caused by creating "rogue"
>> fc_rports in libfc so that we would always have both an 
>> fc_rport_libfc_priv
>> and an fc_rport allocated together, even before fc_remote_port_add().
>> It causes issues when we do remote_port_add and have to transition
>> the state from the rogue to the "real" rport.
>> In the meantime, the rogue could still be accessed by incoming requests,
>> or new RSCNs, and those changes wouldn't get reflected to the real rport.
>> It's messy, and hard to analyze all the potential problems, so I'm
>> trying to fix that.
>>
>> I really appreciate your help!  Thanks a bunch!
>>
>>     Joe
> 
> Ok..  Good Luck.
> 
> -- james

Thanks again.

	Joe
