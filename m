From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Thu, 28 Jun 2007 17:40:59 +0200
Message-ID: <4683D68B.5080702@s5r6.in-berlin.de>
References: <419361.83440.qm@web31812.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56254 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764329AbXF1PlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jun 2007 11:41:11 -0400
In-Reply-To: <419361.83440.qm@web31812.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Swen Schillig <swen@vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, Mike Anderson <andmike@us.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> In fact, I'd do
>   typedef __u8 lun_t[8];
> and then define the macro
>   #define LUN_TO_U64(_lun) ((unsigned long long) be64_to_cpu(*(__be64 *)(_lun)))

Don't forget __attribute__((aligned(8))) on lun_t then.  Some
architectures need it.

The macro should perhaps be called LUN_TO_ULL, as there is also an u64
type in the kernel.

> This way one could do stuff like:*
>   printk(KERN_NOTICE "problem xyz with LUN:%016llx\n", LUN_TO_U64(sdev->LUN));

How about:

union scsi_lun {
	__u8	lun[8];
	__be64	lun64;
	__be16	lun16;
};

This will also be sufficiently aligned.

[...]
> * It is in fact more correct to do, at the _transport_ layer:
> 
>   printk(... "problem xyz with %016llx:%016llx\n",
>          sdev->target->tpid, sdev->LUN);
> 
> Here, it is explicitly shown that sdev (/dev/sdXYZ) is a child of
> a target, having a tpid attribute, and the sdev has a property
> of lun_t called LUN.
> 
> So, for example, for SAS, the message would print like this:
> 
> problem xyz with 5000a50000f13427:0000000000000000
> 
> which uniquely identifies the device and then the sysadmin
> can go to the storage farm, find it and replace it if need be.

There are two things to consider:
  - Is ->target representing a Target Device?  Then it could have more
    than one port, each one with a different identifier.  Or is it
    representing a Target Port?  Or is it representing a Target Device
    with the twist that we instantiate as many ->target objects as the
    device is showing ports to us?
  - If the identifier is stored in ->target, and is an object known to
    mid-layer, then we need a datatype for ->target->tpid which is
    flexible enough for all flavors of TPID.

So, if tpid ends up in objects seen by mid-layer, the datatype of ->tpid
could be either

    __u8 target_port_identifier[233];  /* enough for all */

or
    __u8 target_port_identifier[0];  /* variable length */

or
    struct scsi_target_port_identifier {
	enum transport_protocol {
		SCSI_TRANSPORT_UNKNOWN = 0,
		SCSI_TRANSPORT_SPI,
		SCSI_TRANSPORT_FCP,
		SCSI_TRANSPORT_SRP,
		SCSI_TRANSPORT_ISCSI,
		SCSI_TRANSPORT_SBP,
		SCSI_TRANSPORT_SAS,
	} format;
	union {
		unsigned spi_tpid:4;

		__u8 fcp_tpid[3];  /* or __be32 fcp_tpid:24; ? */

		struct {
			__be64 eui64;
			__be64 extension;
		} srp_tpid;

		struct {
			__u8 name[224];
			__32 tpgt;
		} iscsi_tpid;

		struct {
			__be64 eui64;
			__be32 directory_id:24;
			/* SAM calls this mistakenly "Discovery ID" */
		} sbp_tpid;

		__be64 sas_tpid;
	} value;
    };

or something else.

The former two require that print functions reside in transport layer
implementations.  Note, the transport layer can easily make these print
functions available to mid-layer so that mid-layer can print TPIDs too,
without knowing what's in a TPID.  I.e. transport layer hands out string
representations of TPIDs to mid-layer.

The third variant allows to put the print function into mid-layer.
Before you call it a heresy:  SAM says how many bits or bytes are in the
identifiers, hence a generic SAM implementation can know how to print
them.  It only doesn't know how the values get in there.

PS:  Sorry that I continue to drag TPID into the discussion about LUN,
but in the end you need both to identify hardware.
-- 
Stefan Richter
-=====-=-=== -==- ===--
http://arcgraph.de/sr/
