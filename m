From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 00/10] target: se_node_acl + se_lun RCU conversions
Date: Mon, 01 Jun 2015 01:32:27 -0700
Message-ID: <1433147547.3170.29.camel@haakon3.risingtidesystems.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
	 <55643FB6.1080301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49387 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbbFAIc3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2015 04:32:29 -0400
In-Reply-To: <55643FB6.1080301@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

On Tue, 2015-05-26 at 11:41 +0200, Hannes Reinecke wrote:
> On 05/26/2015 08:25 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi all,
> > 
> > Here is -v3 series for converting LIO target se_node_acl + se_lun
> > mapping tables from fixed size arrays to dynamic RCU hlist_heads.
> > 
> > This turns fast-path I/O into a lock-less RCU reader using existing
> > percpu based se_lun->lun_ref logic, and converts the RCU updater
> > path to allow for an arbitrary number of LUNs for both types of
> > mappings within target-core.
> > 
> > As per this afternoon's email thread, the se_dev_entry->pr_comp
> > has been left in place for se_dev_entry shutdown within patch #1.
> > This completion is still required in order to prevent the configfs
> > se_lun_acl->se_lun_group from being removed from out below the
> > core_scsi3_lunacl_depend_item() caller during the special-case PR
> > ALL_TG_PT=1 registration handling.
> > 
> > The changes based on -v2 series feedback from HCH & Co include:
> > 
> >   - Remove unused se_dev_entry->se_node_acl
> >   - Drop unnecessary check in lunacl_undepend_item
> >   - target: Drop bogus mutex_unlock in core_disable_device_list_for_node
> >   - Drop left-over se_lun->lun_status
> >   - target: Rename ->pr_regs to ->deve_flags + add bit definitions
> >   - target: Convert se_dev_entry stats to atomic_long_t
> >   - Avoid unnecessary PR target_nacl_find_deve() lookup in registration
> >   - Add se_lun->lun_index for RCU dev->dev_index usage in stat.c
> >   - Add various rcu_dereference and lockless_dereference RCU notation
> > 
> > Please review.
> > 
> > --nab
> > 
> For the whole series:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Thanks for reviewing.  8-)

> 
> Do you have a git tree for these changes?
> As mentioned earlier, it should be fairly trivial to convert
> LIO target to use 64-bit LUNs with this patchset.
> 

The latest -v4 + -v3 series changes from this morning have been pushed
to target-pending/for-next.

Thank you,

--nab

