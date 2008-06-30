From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: fcoe cleanups and fcoe TODO
Date: Mon, 30 Jun 2008 16:47:17 -0500
Message-ID: <48695465.1010401@cs.wisc.edu>
References: <1214763843-5548-1-git-send-email-michaelc@cs.wisc.edu>
	<10A7D0016239E24092DEF05CCC582E4303FE4B55@fmsmsx411.amr.corp.intel.com>
	<4869539F.3070605@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <4869539F.3070605-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
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

Mike Christie wrote:
>>> - In general without knowing how hardware is really going to hook into
>>> the lib it is hard to say how the rearch is going :) If we cannot
>>> move more of the fc_remote_port to the rport (or if we just do not
>>> want to move it all there because other drivers like lpfc and qla2xxx
>>> will never use it) then we might want to rename the fc_remote_port
>>> to avoid confusion with the rport and make it clear that the libfc
>> remote
>>> port is only needed for libfc operations.
>>>
>> We'd like to reduce fc_remote_port to nothing and only use fc_rport.
>> We're still not sure we can completely achieve this without either
>> having some private data or adding fields to the fc_rport.
> 
> 
> 
> On a related note, are there going to be values that we need to export 
> in sysfs that are specific to fcoe? For remote port values are we going 
> to export them on the fc_rport (is the fc_rport for anything and 
> everything related to FC) or some new struct?
> 
> If it is a new struct, what if a driver does not use any 
> fc_transport_template callouts and does not hook into libfc?
> 
>>
>>> Should the fc_transport_template be merged with the
>> fc_function_template?
>>> The function callouts to do things lke abort IO or cleanup commands
>> look
>>> similar. But in general should the fc_function_template be common for
>> all
>>> fc drivers and should the fc_transport_template be just for the ones
>> that
>>> are
>>> going to hook into the libfc? If the latter maybe we want to rename
>> this to
>>> make the visibility clear.
>>>
>> So something like libfc_transport_template?
> 
> 
> That makes it clear, but I do not know if it is a good name. It sounds 
> ugly like something I would name it (I am not good at naming as you can 
> tell from some of the iscsi function names). All I know is that the 
> original is not so clear :)
> 

Oh yeah, sorry I did not give a good answer to this. I was thinking if 
we are thowing everything (fcoe specific attrs) on the scsi_transport_fc 
fc_rport or fc_host then we might as well throw the callouts on 
fc_function_template.
