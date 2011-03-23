From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 14:17:10 -0700
Message-ID: <1300915030.18039.66.camel@haakon2.linux-iscsi.org>
References: <1300868790.21880.499.camel@haakon2.linux-iscsi.org>
	 <20110323174843I.fujita.tomonori@lab.ntt.co.jp>
	 <1300874403.21880.519.camel@haakon2.linux-iscsi.org>
	 <20110323210357P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51861 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab1CWVYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 17:24:21 -0400
In-Reply-To: <20110323210357P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jlbec@evilplan.org

On Wed, 2011-03-23 at 21:04 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 03:00:03 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2011-03-23 at 17:48 +0900, FUJITA Tomonori wrote:
> > > On Wed, 23 Mar 2011 01:26:30 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > Demo-mode means that a struct se_node_acl will be dynamically allocated
> > > > when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
> > > > Initiator WWN in the process of creating a new I_T nexus (struct
> > > > se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
> > > > is set.
> > > 
> > > Again, acl is not irrelevant for ibmvscsis. So I shoundn't set up
> > > it.
> > > 
> > > All I asking for is simply accepting any initiators and exporting all
> > > the luns in a target.
> > > 
> > > 
> > 
> > Yes, I understand this.  But driving (from kernel-level) a default set
> > of fabric TPG LUN exports for all available target_core_mod backend
> > export is not a manageable way for /sys/kernel/config/target/$HBA/$DEV
> > backend export.  This needs to be driven from python library code for
> > userspace applications automatically without interaction from end user
> > for ibmvscsis or any other fabric module.
> 
> Hmm, you still don't understand.
> 
> Again, there is no 'TPG' concept in SRP transport.
> 

Yes, I understand that there is no hard requirement for a fabric level
concept of a TPG in SRP.  But the main reason why this has been done in
target_core_fabric_config.c is to present a single configfs group layout
for userspace code to follow using fabric dependent WWN naming, with an
optional unlimited set fabric dependent attributes hanging off thse
default set of target fabric groups.

I don't have an issue with a fabric module connecting directly to a
struct se_wwn->se_group, but you do realize that this would require both
WWN and TPGT access modes in exported target I/O path code, yes..?

> The current design strangely forces the TPG concept to SRP. Well, the
> design is pretty tied to iSCSI.
> 
> We need to make TPG concept optional in configfs and the driver design.

I think abstracting away target_core_fabric_ops->[make,drop]_tpg() makes
sense for the long term for these types of fabric modules.  But I would
much rather put a struct se_portal_group into the fabric dependent wwn
structure and do both WWN and tpgt_1 setup from ->[make,drop]_wwn() than
requring WWN and TPG access modes for target core I/O path fabric code.

A good first step would be for modules to signal they are only
interested in a single 'tpgt_1' per target/$FABRIC/$TARGET_WWN/, and
enforce this in target_core_fabric_configfs.c instead of in fabric
module control plane code.  From there we can see if it makes sense to
setup tpgt_1 as a default_group for these fabrics, or if just doing it
transparent in target_fabric_make_wwn() is a possibility.

--nab

