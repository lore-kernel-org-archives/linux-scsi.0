From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Wed, 23 Mar 2011 14:37:34 -0700
Message-ID: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
	 <20110323175451J.fujita.tomonori@lab.ntt.co.jp>
	 <1300875726.21880.542.camel@haakon2.linux-iscsi.org>
	 <20110323200722G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41630 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1CWVoq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 17:44:46 -0400
In-Reply-To: <20110323200722G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Wed, 2011-03-23 at 20:07 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 03:22:06 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2011-03-23 at 17:54 +0900, FUJITA Tomonori wrote:
> > > I've not looked at the code yet but...
> > > 
> > > On Tue, 22 Mar 2011 20:06:31 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > Nicholas Bellinger (14):
> > > >   iscsi: Resolve iscsi_proto.h naming conflicts with
> > > >     drivers/target/iscsi
> > > >   iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
> > > >   target: Convert REPORT_LUNs to use int_to_scsilun
> > > >   iscsi-target: Add iSCSI fabric support for target v4
> > > >   iscsi-target: Add TCM v4 compatiable ConfigFS control plane
> > > >   iscsi-target: Add configfs fabric dependent statistics
> > > >   iscsi-target: Add TPG and Device logic
> > > >   iscsi-target: Add iSCSI Login Negotiation and Parameter logic
> > > >   iscsi-target: Add CHAP Authentication support using libcrypto
> > > >   iscsi-target: Add Sequence/PDU list + DataIN response logic
> > > >   iscsi-target: Add iSCSI Error Recovery Hierarchy support
> > > >   iscsi-target: Add support for task management operations
> > > >   iscsi-target: Add misc utility and debug logic
> > > >   iscsi-target: Add Makefile/Kconfig and update TCM top level
> > > > 
> > > >  drivers/infiniband/ulp/iser/iser_initiator.c      |    2 +-
> > > >  drivers/scsi/be2iscsi/be_main.h                   |    4 +-
> > > >  drivers/scsi/bnx2i/bnx2i_hwi.c                    |    8 +-
> > > >  drivers/scsi/bnx2i/bnx2i_iscsi.c                  |    2 +-
> > > >  drivers/scsi/libiscsi.c                           |   22 +-
> > > >  drivers/target/Kconfig                            |    2 +
> > > >  drivers/target/Makefile                           |    3 +
> > > >  drivers/target/iscsi/Kconfig                      |   17 +
> > > >  drivers/target/iscsi/Makefile                     |   20 +
> > > >  drivers/target/iscsi/iscsi_target.c               | 5017 +++++++++++++++++++++
> > > >  drivers/target/iscsi/iscsi_target.h               |   32 +
> > > >  drivers/target/iscsi/iscsi_target_auth.c          |  496 ++
> > > >  drivers/target/iscsi/iscsi_target_auth.h          |   32 +
> > > >  drivers/target/iscsi/iscsi_target_configfs.c      | 1914 ++++++++
> > > >  drivers/target/iscsi/iscsi_target_configfs.h      |    7 +
> > > >  drivers/target/iscsi/iscsi_target_core.h          |  881 ++++
> > > >  drivers/target/iscsi/iscsi_target_datain_values.c |  531 +++
> > > >  drivers/target/iscsi/iscsi_target_datain_values.h |   15 +
> > > >  drivers/target/iscsi/iscsi_target_debug.h         |  113 +
> > > >  drivers/target/iscsi/iscsi_target_device.c        |  108 +
> > > >  drivers/target/iscsi/iscsi_target_device.h        |    9 +
> > > >  drivers/target/iscsi/iscsi_target_erl0.c          | 1005 +++++
> > > >  drivers/target/iscsi/iscsi_target_erl0.h          |   17 +
> > > >  drivers/target/iscsi/iscsi_target_erl1.c          | 1305 ++++++
> > > >  drivers/target/iscsi/iscsi_target_erl1.h          |   28 +
> > > >  drivers/target/iscsi/iscsi_target_erl2.c          |  483 ++
> > > >  drivers/target/iscsi/iscsi_target_erl2.h          |   18 +
> > > >  drivers/target/iscsi/iscsi_target_login.c         | 1245 +++++
> > > >  drivers/target/iscsi/iscsi_target_login.h         |   13 +
> > > >  drivers/target/iscsi/iscsi_target_nego.c          | 1068 +++++
> > > >  drivers/target/iscsi/iscsi_target_nego.h          |   19 +
> > > 
> > > Why do we need to do the pre-nexus operations such as login,
> > > authentication, negotiation, etc in kernel?
> > > 
> > 
> > Because defining an API for this type of userspace code is an
> > unnecessary overhead that iscsi_target_mod does not require.  I really
> > don't want to add any type of C level interface/API and C userspace code
> > for fabric level login logic that is intended to be transparent to the
> > actual iscsi-target configfs control plane.  It's just unnecessary
> > complexity and C userspace code for a kernel-level implementation with
> > no obvious benefit.
> 
> Removing several thousand lines from kernel isn't benefit?
> 
> 

No, not when it adds complexity without benefit for the default case and
introduces unnecessary userspace C code.

At this point in lio-utils.git for target v4 code, we require zero C
userspace code for the default operation of iscsi-target, and I want to
keep it this way.  

Maintaining backwards compatibility with interpreted script code for the
fabric control plane makes life so much eaiser than any kernel <-> user
C API that I have ever encountered.

> > The area where some form of userspace passthrough specific to iSCSI
> > login negotiation in CURRENT_STAGE=0 would be useful is for userspace
> > authentication support beyond the built-in kernel-level CHAP code for
> > extending AuthMethod to support Kerberos, SRP, etc.  This should be
> > limited to the AuthMethod state and keys, and the rest of fabric login
> > should still reside in-kernel.
> 
> I don't see what you mean. Why the negotiation should be in kernel?
> 
> In other words, what the approach to do the pre-nexus operations like
> IET (or SCST) can't do?

Because it does not makes sense for the default case, and adds
unnecessary complexity to the iscsi-target login process.

Using mainline libcrypto for CHAP works as expected and allows us to
provide one-way and mutual authentication for iSCSI discovery and
explict initiator NodeACLs via configfs attributes without any userspace
C dependcies.

Like I said, I don't have an issue with adding some form of userspace
passthrough in iscsi_target_auth.c:iscsi_handle_authentication() in
order to support other types of iSCSI authentication methods.  But
changing iscsi-target to require that every single iSCSI login to every
iSCSI target endpoint needs to go through a userspace daemon, we when
can currently configure 10K -> 100K -> and upwards of individual
/sys/kernel/config/target/iscsi/$TARGETNAME/ endpoints, this seems like
an unnecessary bottleneck to me.

--nab

