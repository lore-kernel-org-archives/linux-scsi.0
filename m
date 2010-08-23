From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
Date: Mon, 23 Aug 2010 12:52:02 -0700
Message-ID: <1282593122.25074.40.camel@haakon2.linux-iscsi.org>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
	 <4C71752E.50203@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:45634 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754286Ab0HWTzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2010 15:55:50 -0400
In-Reply-To: <4C71752E.50203@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-iscsi-target-dev@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>

On Sun, 2010-08-22 at 22:06 +0300, Boaz Harrosh wrote:
> On 08/20/2010 01:45 AM, Nicholas A. Bellinger wrote:
> > Greetings mnc and tomo,
> > 
> > So as per our discussions last week, I will be moving forward with the
> > conversion of the LIO-Target iSCSI fabric module v4 to use protocol and
> > PDU include/scsi/iscsi_proto.h.  As mnc and I agreed privately, this is
> > going to the right level of integration for v2.6.37, as making libiscsi
> > target mode aware does not really make for a target mode iSCSI stack
> > sense due to the amount of logic in place for kernel <-> user with the
> > Open-iSCSI initiator.
> > 
> > So aside from the main tedious work that will be involved in actually
> > producing a patch for this on my end, I did notice one immediate item
> > that will cause an extra headache..  This involves the struct
> > iscsi_init_* and struct iscsi_target* structure definitions in:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob;f=drivers/target/lio-target/iscsi_protocol.h;hb=refs/heads/lio-4.0
> > 
> > namely that they all have trailing 'u32 header_digest' member that a
> > decent amount of utility code in iscsi_target.c and iscsi_target_util.c
> > currently depends upon.
> > 
> > So, assuming that the conversion of all struct iscsi_init_* and struct
> > iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
> > checking structure size and renaming the member use in
> > drivers/target/lio-target, would it be acceptable to do something like:
> > 
> > /* iSCSI PDU Header */
> > struct iscsi_cmd {
> >         uint8_t opcode;
> >         uint8_t flags;
> >         __be16 rsvd2;
> >         uint8_t hlength;
> >         uint8_t dlength[3];
> >         uint8_t lun[8];
> >         itt_t    itt;   /* Initiator Task Tag */
> >         __be32 data_length;
> >         __be32 cmdsn;
> >         __be32 exp_statsn;
> >         uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
> >         /* Additional Data (Command Dependent) */
> > #ifdef ISCSI_TARGET_MODE
> >         __be32 header_digest;
> > #endif
> > };
> > 
> 
> No, Nic that will not work. struct iscsi_cmd is just part of a full header
> that can have additional AHSs before the final header_digest that
> signs them all. Here above is just the common first part.
> (We will need these AHSs support sooner then later in LIO as well ;-))
>
> There are other structs that do include the above + header_digest
> as an aggregate that you can use.
> 

Hmmm good point..  Perhaps the choice of using struct iscsi_cmd as the
example w/ __be32 header_digest was made a little hastely on my part.
8-)

So in that case, I can focus making this struct iscsi_cmd function W/O
the header_digest member first, and have the temporary stubs in the
lio-core-2.6.git tree for the other PDUs as required until the other non
SCSI PDU handlers can be converted and the stubs removed.

> two things:
> 1. Still jet-lagged / summer vacation family duties. Let me get
>    up to speed, I'll even send some ruff sketches for you.
> 

Great!  I am looking forward to those.

> 2. Please get me up to speed with a ruff code map (Which files?
>    where?) for the iscsi code. I can do both the bidi and the AHSs
>    for you, which are very related. Actually AHSs is the harder part
>    (which is simple really).

<nod> I would like to start adding BIDI into TCM Core + TCM_Loop very
soon (mabye by this weekend..?)  Ditto on the extended > 16-byte CDB
support bit, which should be straight-forward enough in TCM Core, and on
the backend for the TCM/pSCSI using struct request passthrough..

>    a. Any high level documentation.

Ok, I need start to putting this together in Documentation/target/ for
the lio-target iSCSI specific pieces..  My plan is to start working on
the struct target_core_fabric_ops API documentation first to go with
this tcm_mod_builder.py configfs skeleton fabric module generation
script that I am considering.

>From there, it would next make sense to produce high level docs for
struct se_subsystem_api and primary Linux storage subsystem plugins eg:
IBLOCK, pSCSI, FILEIO for folks interested in that area.

I will be sure to CC you for input on these doc commits.

>    b. The best code for review. Both git-tree to pull, and git-web
>       if available.
> 

This is the lio-core-2.6.git/lio-4.0 branch which is currently still at
v2.6.35.  Just FYI I plan to jump to .36-rc2 at some point during the
week.

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=shortlog;h=refs/heads/lio-4.0

Thanks for your comments Boaz!

--nab


