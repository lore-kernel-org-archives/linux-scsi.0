From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Thu, 24 Mar 2011 00:29:08 -0700
Message-ID: <1300951748.18039.252.camel@haakon2.linux-iscsi.org>
References: <1300874403.21880.519.camel@haakon2.linux-iscsi.org>
	 <20110323210357P.fujita.tomonori@lab.ntt.co.jp>
	 <1300915030.18039.66.camel@haakon2.linux-iscsi.org>
	 <20110324105422K.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54502 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab1CXHgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2011 03:36:20 -0400
In-Reply-To: <20110324105422K.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jlbec@evilplan.org

On Thu, 2011-03-24 at 10:54 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 14:17:10 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2011-03-23 at 21:04 +0900, FUJITA Tomonori wrote:
> > > On Wed, 23 Mar 2011 03:00:03 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > On Wed, 2011-03-23 at 17:48 +0900, FUJITA Tomonori wrote:
> > > > > On Wed, 23 Mar 2011 01:26:30 -0700
> > > > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > > > 
> > > > > > Demo-mode means that a struct se_node_acl will be dynamically allocated
> > > > > > when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
> > > > > > Initiator WWN in the process of creating a new I_T nexus (struct
> > > > > > se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
> > > > > > is set.
> > > > > 
> > > > > Again, acl is not irrelevant for ibmvscsis. So I shoundn't set up
> > > > > it.
> > > > > 
> > > > > All I asking for is simply accepting any initiators and exporting all
> > > > > the luns in a target.
> > > > > 
> > > > > 
> > > > 
> > > > Yes, I understand this.  But driving (from kernel-level) a default set
> > > > of fabric TPG LUN exports for all available target_core_mod backend
> > > > export is not a manageable way for /sys/kernel/config/target/$HBA/$DEV
> > > > backend export.  This needs to be driven from python library code for
> > > > userspace applications automatically without interaction from end user
> > > > for ibmvscsis or any other fabric module.
> > > 
> > > Hmm, you still don't understand.
> > > 
> > > Again, there is no 'TPG' concept in SRP transport.
> > > 
> > 
> > Yes, I understand that there is no hard requirement for a fabric level
> > concept of a TPG in SRP.
> 
> Hard requirement? No, please read SRP spec? There is not such thing.
>
> So forcing TPG is the wrong desing. Requirements must be in all the
> transport specs. Transport specific things such as TPG shouldn't be
> exported to every transports.
> 

I have already explained why this was chosen as the default for the
target_core_fabric_configfs.c design, and that I am open to abstracting
this away from the fabric module control plane for non iSCSI fabrics.

> Again, the point is that the current design is pretty tied to
> iSCSI. Other transports are forced to handle iSCSI specific stuff
> strangely.

This has not been a limiting factor for any of non iSCSI fabric code
that I have developed or seen yet.  I would rather have
target_core_fabric_config.c logic handle a default 'tgpt_1'
transparently for a non iSCSI struct se_wwn->wwn_group registration,
than provide two modes of I/O path target endpoint reference for struct
se_wwn and struct se_portal_group.

I am happy to consider patches to address this.

--nab

