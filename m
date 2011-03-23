From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 21:04:09 +0900
Message-ID: <20110323210357P.fujita.tomonori@lab.ntt.co.jp>
References: <1300868790.21880.499.camel@haakon2.linux-iscsi.org>
	<20110323174843I.fujita.tomonori@lab.ntt.co.jp>
	<1300874403.21880.519.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:59386 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab1CWME0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 08:04:26 -0400
In-Reply-To: <1300874403.21880.519.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jlbec@evilplan.org

On Wed, 23 Mar 2011 03:00:03 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Wed, 2011-03-23 at 17:48 +0900, FUJITA Tomonori wrote:
> > On Wed, 23 Mar 2011 01:26:30 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > Demo-mode means that a struct se_node_acl will be dynamically allocated
> > > when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
> > > Initiator WWN in the process of creating a new I_T nexus (struct
> > > se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
> > > is set.
> > 
> > Again, acl is not irrelevant for ibmvscsis. So I shoundn't set up
> > it.
> > 
> > All I asking for is simply accepting any initiators and exporting all
> > the luns in a target.
> > 
> > 
> 
> Yes, I understand this.  But driving (from kernel-level) a default set
> of fabric TPG LUN exports for all available target_core_mod backend
> export is not a manageable way for /sys/kernel/config/target/$HBA/$DEV
> backend export.  This needs to be driven from python library code for
> userspace applications automatically without interaction from end user
> for ibmvscsis or any other fabric module.

Hmm, you still don't understand.

Again, there is no 'TPG' concept in SRP transport.

The current design strangely forces the TPG concept to SRP. Well, the
design is pretty tied to iSCSI.

We need to make TPG concept optional in configfs and the driver design.
