From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Thu, 24 Mar 2011 10:54:22 +0900
Message-ID: <20110324105422K.fujita.tomonori@lab.ntt.co.jp>
References: <1300874403.21880.519.camel@haakon2.linux-iscsi.org>
	<20110323210357P.fujita.tomonori@lab.ntt.co.jp>
	<1300915030.18039.66.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:60848 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1CXCCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 22:02:00 -0400
In-Reply-To: <1300915030.18039.66.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jlbec@evilplan.org

On Wed, 23 Mar 2011 14:17:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Wed, 2011-03-23 at 21:04 +0900, FUJITA Tomonori wrote:
> > On Wed, 23 Mar 2011 03:00:03 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > On Wed, 2011-03-23 at 17:48 +0900, FUJITA Tomonori wrote:
> > > > On Wed, 23 Mar 2011 01:26:30 -0700
> > > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > > 
> > > > > Demo-mode means that a struct se_node_acl will be dynamically allocated
> > > > > when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
> > > > > Initiator WWN in the process of creating a new I_T nexus (struct
> > > > > se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
> > > > > is set.
> > > > 
> > > > Again, acl is not irrelevant for ibmvscsis. So I shoundn't set up
> > > > it.
> > > > 
> > > > All I asking for is simply accepting any initiators and exporting all
> > > > the luns in a target.
> > > > 
> > > > 
> > > 
> > > Yes, I understand this.  But driving (from kernel-level) a default set
> > > of fabric TPG LUN exports for all available target_core_mod backend
> > > export is not a manageable way for /sys/kernel/config/target/$HBA/$DEV
> > > backend export.  This needs to be driven from python library code for
> > > userspace applications automatically without interaction from end user
> > > for ibmvscsis or any other fabric module.
> > 
> > Hmm, you still don't understand.
> > 
> > Again, there is no 'TPG' concept in SRP transport.
> > 
> 
> Yes, I understand that there is no hard requirement for a fabric level
> concept of a TPG in SRP.

Hard requirement? No, please read SRP spec? There is not such thing.

So forcing TPG is the wrong desing. Requirements must be in all the
transport specs. Transport specific things such as TPG shouldn't be
exported to every transports.

Again, the point is that the current design is pretty tied to
iSCSI. Other transports are forced to handle iSCSI specific stuff
strangely.
