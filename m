From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Sat, 30 Jun 2007 12:07:29 -0700 (PDT)
Message-ID: <712635.96237.qm@web31801.mail.mud.yahoo.com>
References: <4683D68B.5080702@s5r6.in-berlin.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:35649 "HELO
	web31801.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750742AbXF3THa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jun 2007 15:07:30 -0400
In-Reply-To: <4683D68B.5080702@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

--- Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> How about:
> 
> union scsi_lun {
> 	__u8	lun[8];
> 	__be64	lun64;
> 	__be16	lun16;
> };

I'd rather not even hint that a LUN is to be viewed
as anything integer-like.  Just use u8[8] aligned.

(I.e. it is u64 only at the time when printing it,
but no one really needs to know this. It is u8[8].
Not sure why this is hard to understand.)
 
> There are two things to consider:
>   - Is ->target representing a Target Device?  Then it could have more
>     than one port, each one with a different identifier.  Or is it
>     representing a Target Port?  Or is it representing a Target Device
>     with the twist that we instantiate as many ->target objects as the
>     device is showing ports to us?

Target port.  SCSI Core has no business in multi-pathing.  MP is another
layer on top of SCSI.

>   - If the identifier is stored in ->target, and is an object known to
>     mid-layer, then we need a datatype for ->target->tpid which is
>     flexible enough for all flavors of TPID.

This isn't object oriented.  See below.

> So, if tpid ends up in objects seen by mid-layer, the datatype of ->tpid
> could be either
> 
>     __u8 target_port_identifier[233];  /* enough for all */
> 
> or
>     __u8 target_port_identifier[0];  /* variable length */
> 
> or
>     struct scsi_target_port_identifier {
> 	enum transport_protocol {
> 		SCSI_TRANSPORT_UNKNOWN = 0,
> 		SCSI_TRANSPORT_SPI,
> 		SCSI_TRANSPORT_FCP,
> 		SCSI_TRANSPORT_SRP,
> 		SCSI_TRANSPORT_ISCSI,
> 		SCSI_TRANSPORT_SBP,
> 		SCSI_TRANSPORT_SAS,
> 	} format;
> 	union {
> 		unsigned spi_tpid:4;
> 
> 		__u8 fcp_tpid[3];  /* or __be32 fcp_tpid:24; ? */
> 
> 		struct {
> 			__be64 eui64;
> 			__be64 extension;
> 		} srp_tpid;
> 
> 		struct {
> 			__u8 name[224];
> 			__32 tpgt;
> 		} iscsi_tpid;
> 
> 		struct {
> 			__be64 eui64;
> 			__be32 directory_id:24;
> 			/* SAM calls this mistakenly "Discovery ID" */
> 		} sbp_tpid;
> 
> 		__be64 sas_tpid;

Is it possible to stop with the u64 and its derivatives?
__u8 sas_tpid[8] __aligned(8) would do just fine.

> 	} value;
>     };
> 
> or something else.

Neither. Inevitably a SCSI Core representation of a target
port would contain a transport's layer opaque token (void* for
example). That opaque token uniquely identifes a target's
representation in the transport layer (target port), whose
structure stores the tpid in protocol dependent form.

SCSI Core gives you /dev/sdXYZ, that's all. It needs to get
out of knowing particulars of protocols.  This is the object
oriented approach.

> The former two require that print functions reside in transport layer
> implementations.  Note, the transport layer can easily make these print
> functions available to mid-layer so that mid-layer can print TPIDs too,
> without knowing what's in a TPID.  I.e. transport layer hands out string
> representations of TPIDs to mid-layer.

Something like that.

Imagine you could say in SCSI Core:
transport->printf("I see a problem with %T:%016llx\n", sdev->target-><name of opaque token>,
                   dev->LUN);

Where %T will be "filled" with the tpid after the opaque token has been
resolved by the transport protocol layer.

> The third variant allows to put the print function into mid-layer.

Sorry, no.

> Before you call it a heresy:  SAM says how many bits or bytes are in the

No, it does NOT.  The transport protocol does. SAM merely reproduces
this information, in an _Annex_, for informational purposes to the
reader. I.e. so that you don't have to hunt out the transport protocol
spec and search for it there yourself.

> identifiers, hence a generic SAM implementation can know how to print
> them.  It only doesn't know how the values get in there.

Hmm, this is a weak argument: "... know how to print... doesn't know
how the values get in there."

Ask yourself these questions: "What does SCSI Core provide?", "What should
SCSI Core provide?", "What should SCSI Core not provide?", "Why?".
Give good justifications to your answers.

    Luben


