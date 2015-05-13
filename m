From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 05/12] target: Convert transport_lookup_*_lun to RCU
 reader
Date: Wed, 13 May 2015 00:42:43 -0700
Message-ID: <1431502963.26897.63.camel@haakon3.risingtidesystems.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
	 <1431422736-29125-6-git-send-email-nab@daterainc.com>
	 <20150513055550.GD20825@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56003 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbbEMHmp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 03:42:45 -0400
In-Reply-To: <20150513055550.GD20825@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>

On Wed, 2015-05-13 at 07:55 +0200, Christoph Hellwig wrote:
> > +	rcu_read_lock();
> > +	deve = target_nacl_find_deve(nacl, unpacked_lun);
> > +	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
> > +		/*
> > +		 * Make sure that target_enable_device_list_for_node()
> > +		 * has not already cleared the RCU protected pointers.
> > +		 */
> > +		if (!deve->se_lun) {
> 
> Just move the hlist_del_rcu in core_disable_device_list_for_node before
> clearing se_lun and this check won't be needed.
> 
> And if you need ny check here just add it to the if so that there is
> no need for the goto.  Same for the TMR path.
> 

Done.

> As for the locking changes:  I'd rather have the change to a mutex
> as a separate patch as that's different from the data structure
> changes.

Fair enough.

--nab

