From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/8] target mode support
Date: Thu, 16 Nov 2006 12:56:57 -0600
Message-ID: <455CB479.4060702@cs.wisc.edu>
References: <20061116192358C.fujita.tomonori@lab.ntt.co.jp> <455C76D1.9050501@emulex.com> <455C9299.5010202@cs.wisc.edu> <455C9D78.7020400@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:10204 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1424342AbWKPS5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 13:57:24 -0500
In-Reply-To: <455C9D78.7020400@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, James Bottomley <James.Bottomley@SteelEye.com>

James Smart wrote:
> Ok.  My assumption is that it is preferred to be a single mode, but that
> dual mode should be supported.  Please note that dual mode may impact some
> of the feature set in the emulated target - and it'll be a trick to
> identify
> that.
> 
> Hmm... what this leads me to is - there is a difference between the
> pure SCSI behavior (performing a SCSI Read command), and the
> transport-level
> SCSI behavior (Mode Pages; FCP: Conf, Recovery; iSCSI CmdSN/StatSN
> progression,
> SNACK, RSP retransmission, etc). Although, these will be very tightly
> integrated.  How does this code account for this ?  Are there
> transport-level
> libraries in-between the LLDD and the SCSI Target ? Is it reflected in the

I do not think it is a layer like how you might think or want. It is
more of a library like how scsi-ml, the current transport classes or
libata is. I do not think we are submitting anything that works both in
initiator and target mode today, but the SCSI RDMA Protocol library is
an example of just a target library.

For a lib/class that works in both modes I will use iscsi as an example
even though we just threw that target to userspace. In the iscsi_tcp_tgt
patches where it was in the kernel that I sent a couple months ago

http://marc.theaimsgroup.com/?l=linux-scsi&m=115639258024577&w=2

Tomo modified the current iscsi transport class (iscsi class in upstream
kernel is a common code for all iscsi drivers) and libiscsi (libiscsi is
common code for just software iscsi and iser and partial iscsi offload
drivers) so that it could be used by a target mode driver. Common
components like the recv path which would take a network packet and
assemble it into a iscsi command were modified so they could be used by
a initiator or target and put in libiscsi. Same goes for the send path
as far as taking a iscsi packet and putting it on the network.

Then where an initiator and target would differ went into seperate
modules. For iscsi_tcp_tgt, the target code would maintain things needed
for its specific transport state model. To perform the common scsi
operations, the LLD would either call the scsi_tgt_lib function directly
and have its transfer_data or transfer_response callouts directly (this
would be the case like with qla4xxx where the card hides pretty much all
the iscsi details from the driver when in session mode), or the LLD
would call some transport specific lib function which would be a wrapper
around the scsi_tgt_lib function like is done with the transport classes
and libata today. The transport specific lib function would also call
into the LLD through some transport callout like with the initiators.

So for lpfc, I asked about your thoughts on how this would work for
scsi_transport_fc and if we should just make a completely seperate
module for the target, but I am not sure what we agreed on. For iscsi it
was possible to integrate initiator and target support in a lot of
places because a most of the code is in userspace and we have userspace
libraries as well as kernel ones so that is where most of those detailes
live :) And I have not got a chance to work on Fibre Channel for a long
time. Lots of iscsi initiator bugs :)

What are your thoughts? For a LLDs like lpfc or qla2xxx, I do not think
it is going to be best to seperate out things like the ineterrupt
processing into seperate modules like was done with software iscsi and I
am not sure FC drivers will be able to reuse structs like the rport for
both modes (we did this for iscsi with the iscsi_connecion/iscsi_session).

I have not done much work on lpfc for a long long time. For qla2xxx, we
just merged the target specifc interrupt handling and setup code into
the one driver. This was over a year ago so qla2xxx was not integrated
into the FC class and using rports like today so we did not have to
worry about that too. Should a single rport struct support both modes or
just one



> LLDD to SCSI Target messaging ?
> 
> -- james
> 
> 
> Mike Christie wrote:
>> James Smart wrote:
>>> One question....
>>>
>>> Does this assume that an hba is both initiator and target ?  target
>>> only ?
>>> Do we have any issues if a scsi_host is a target only ?
>>>
>>
>> I do not think that is fully worked out yet. The only target that is
>> done is the vscsi one which is a little different from something like
>> lpfc or qla*. I think some developers like Qlogic would prefer the
>> driver and card is only in one mode or the other to simplify things.
>> However, I think Tomo and users would like to be able to use a
>> card/driver in both modes at the same time.
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

