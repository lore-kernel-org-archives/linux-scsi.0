From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: fcoe cleanups and fcoe TODO
Date: Mon, 30 Jun 2008 16:43:59 -0500
Message-ID: <4869539F.3070605@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4303FE4B55-6O2ePOu3Gqekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "Love, Robert W" <robert.w.love-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Love, Robert W wrote:
>> Hey,
>>
>> Following are some cleanup patches for things I found while trying
>> to get setup. I did not get to test the patches well, because
>> the rearch code does not seem to work every well the software
>> target. I basically loaded the driver and made sure I could login
>> and find storage. Trying to do heavy READ and WRITE IO lead to
> problems.
>> The patches are made over the re-arch git tree.
>>
> Awesome, I've reviewed a few and will get them in shortly.


Oh yeah, I just rebased my tree and saw all the checkins from the 
weekend so my patches do not apply from a tree that is pulled today. Are 
you going to fix that for me, or do you want me to rediff and resend 
when you are done reviewing. I heard the iscsi maintainer is really nice 
and will rediff for you :)


>> - I am not sure if the setup functions like fc_lport_init are nice
>> in how it sets the transport functions pointers for you or if it will
> lead
>> to problems for drivers that want to partially hook in, but find
>> out that the lib has set some functions it did not want. Maybe we want
>> to set the libfc functions in the LLD like is done for the
>> scsi_host_template.
>>
> Yeah, we've debated whether we should have the lib init the pointers and
> then have the LLD override them or have the LLD set them first and have
> the lib fill in the un-initialized ones. The current design allows a LLD
> to override the default functions with its own. Is your suggestion to
> expose all of the functions that could satisfy the tt
> (fc_transport_template) pointers through the libfc API and have the LLD
> set them all? 


It was, but for now we probably do not need to change it unless someone 
cares. I think it is best to do this last since it is not a big deal and 
we still do not know what drivers are using and things are more stable.


> 
> Throughout this re-architecture the tt and libfc API have grown and
> shrunk. Lately we've bloated the tt to expose functions that were
> previously called directly from one UL system (fc_scsi, fc_lport,
> fc_rport or fc_disc) to another. The number of functions needed in the
> tt and also required in the libfc API seemed like too much and having a
> little _init() function for each UL system seemed cleaner. We're getting
> closer to having a cleaner API between each UL system so maybe we can
> move the assignment of tt pointers back to the LLD.
> 
>> I think we need to see more hardware in the end. For now since there is
>> only
>> software fcoe that is out, this could probably be ok and as we see more
>> drivers we can evolve the split for the hardware like was done with
> iscsi.
>> For iscsi we ended up with 4 different offload modules so there was no
> way
>> we could have designed for all of them and the hardware/firmware
>> guys's quirks :)
>>
> We definitely expect this library to evolve as more LLDs use it. 
> 
>> - In general without knowing how hardware is really going to hook into
>> the lib it is hard to say how the rearch is going :) If we cannot
>> move more of the fc_remote_port to the rport (or if we just do not
>> want to move it all there because other drivers like lpfc and qla2xxx
>> will never use it) then we might want to rename the fc_remote_port
>> to avoid confusion with the rport and make it clear that the libfc
> remote
>> port is only needed for libfc operations.
>>
> We'd like to reduce fc_remote_port to nothing and only use fc_rport.
> We're still not sure we can completely achieve this without either
> having some private data or adding fields to the fc_rport.



On a related note, are there going to be values that we need to export 
in sysfs that are specific to fcoe? For remote port values are we going 
to export them on the fc_rport (is the fc_rport for anything and 
everything related to FC) or some new struct?

If it is a new struct, what if a driver does not use any 
fc_transport_template callouts and does not hook into libfc?


> 
>> Should the fc_transport_template be merged with the
> fc_function_template?
>> The function callouts to do things lke abort IO or cleanup commands
> look
>> similar. But in general should the fc_function_template be common for
> all
>> fc drivers and should the fc_transport_template be just for the ones
> that
>> are
>> going to hook into the libfc? If the latter maybe we want to rename
> this to
>> make the visibility clear.
>>
> So something like libfc_transport_template?


That makes it clear, but I do not know if it is a good name. It sounds 
ugly like something I would name it (I am not good at naming as you can 
tell from some of the iscsi function names). All I know is that the 
original is not so clear :)
