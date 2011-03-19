From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 00/10] isci: core
Date: Fri, 18 Mar 2011 23:19:32 -0700
Message-ID: <AANLkTimZ-=b3Ssu-1X6DVaPgJoUMYmbGUMr=LvLz67Yb@mail.gmail.com>
References: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
	<20110318155635.GA22514@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36095 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1CSGTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Mar 2011 02:19:33 -0400
Received: by fxm17 with SMTP id 17so4293979fxm.19
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2011 23:19:32 -0700 (PDT)
In-Reply-To: <20110318155635.GA22514@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

On Fri, Mar 18, 2011 at 8:56 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
[..]
> You absolutely have to fix it before it can be merged. =A0Gems like
> duplicating all wire level constants and structures for SCSI, SAS
> and ATA in your own headers is simply not acceptable.

Hence the comment "Many of these want to be deleted in favor of the
in-kernel equivalent." in "[RFC PATCH 10/10] isci/core: common
definitions and utility functions' [1].

> I'm not sure where you got the idea this could be remotely acceptable=
=2E

Never did.  We're reworking the driver that was handed to us.

To date fixing bugs in the current code (things like removing
phys_to_virt and virt_to_phys in favor of proper dma-api and kmap
usage) has delayed this rework... still plan to fix it.

> Also the source layout is a real mess, almost comparably to the broac=
ade
> FC driver - there really is no point in having a header for barely mo=
re
> than a structure or inline.

Agreed.  We consolidated the c files, now need to go back and do the
same for the headers.  There is also a namespacecheck driven cleanup
that needs to happen as well.

> Also care to explain the design rationale for all these specific
> semi-statemachines? =A0To my untrained eye they really looks like
> pointless obsfucation, but maybe there's a good reason that should be
> explained in long comments.

They model asynchronous hardware / protocol states and are loosely
analogous to the ata_sff_hsm implementation in libata in terms of
needing to handle transport layer details of sata, smp, and ssp.   The
hardware is focused on accelerating the fast paths and let's software
handle many slow path conditions, for example ata pio requests require
driver interaction to progress the request through several states at a
per frame level.  We'll put together some better documentation but
there are a lot of conditions and states that software is required to
handle and the state machines keep these organized.

There have been some patches to make them more readable (8e131f53,
ba647271, 03355704), but this work has not been completed across all
the state machines.  I will say I think the controller state machine
is one that could be eventually factored out / absorbed into the lldd
because there are no asynchronous hardware-event driven controller
state transitions.

> And please don't make the code like ACPICA, macro names like
> SCU_CONTEXT_COMMAND_REQUEST_POST_TC_ABORT or
> SCIC_SDS_STP_PACKET_REQUEST_STARTED_PACKET_PHASE_AWAIT_TC_COMPLETION_=
SUBSTATE
> just need to go.

Ok.

> Also please get rid of ALL UPPERCASE SCREAMING NAMES for structures.

Unfortunately, the automated scripts we developed at the beginning of
the cleanup effort only caught definitions of the form:

typedef struct UPPERCASE_STRUCT { } UPPERCASE_STRUCT_T;

=2E..and missed ones of the form:

struct UPPERCASE_STRUCT { };

=2E..so we need to manually handle these stragglers.

> FYI:
>
> =A0 =A0 =A0 =A0 u32 connection_inactivity_timeout:16;
>
> is a really dumb idea. =A0Please take the crackpipe away from whateve=
r
> idiot came up with junk like that and use the proper right sized inte=
ger
> types. =A0Also for sub-byte field please absolutely avoid bitfields.
> Their layout is unportable, and properly locking them is a nightmare.
> Just define a flags field and use bit operations on them.

Yeah. it does not make sense to define bitfields for things that are
correctly aligned base types.

--
Dan

[1]: http://marc.info/?l=3Dlinux-scsi&m=3D129975444506569&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
