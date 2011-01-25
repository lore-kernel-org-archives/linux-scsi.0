From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3] target: Reaquire hba_lock + se_port_lock during
 se_clear_dev_ports continue
Date: Tue, 25 Jan 2011 15:39:26 +0100
Message-ID: <20110125153926.710639bd@stein>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	<1295901446-17089-3-git-send-email-nab@linux-iscsi.org>
	<20110125010817.2baee6cf@stein>
	<1295918416.24778.157.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:50043 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1AYOjh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2011 09:39:37 -0500
In-Reply-To: <1295918416.24778.157.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Jan 24 Nicholas A. Bellinger wrote:
> On Tue, 2011-01-25 at 01:08 +0100, Stefan Richter wrote:
> > void se_clear_dev_ports(struct se_device *dev)
[...]
> > Can this mess of releasing and reacquiring locks --- which looks all rather
> > dangerous --- be cleaned up if you move the logical units (?) to be deleted
> > over to a secondary list?
> 
> Fair point on this one.  Having to sleep in core_dev_del_lun() waiting
> for all outstanding struct se_cmd -> struct se_lun I/O descriptor
> mappings to be shutdown makes this look pretty ugly currently in
> se_clear_dev_ports().  However adding another list+lock to this mix
> really does not make it any less complex.

I meant an on-stack throwaway list which you can change inside
se_clear_dev_ports() without any lock.  But I didn't look whether this is
actually possible and beneficial.

> Looking at se_clear_dev_ports() again in the two usage contexts
> target_core_device.c:se_free_virtual_device() and
> target_core_hba.c:core_delete_hba(),
[...]
> config_group structures, I think se_clear_dev_ports() should be able to
> be dropped all together now.

That of course sounds great.

> I will take a deeper look and see if this
> is really in fact safe for v4.0/for-38 code.

As a thought from an outsider:  If drivers/target/ weren't entirely new in
2.6.38, then only a minimal cautious locking fix would be post -rc1
material.  Linus releases so frequently that anything beyond essential
fixes can easily wait for regular merge windows.  "Essential" = very low
risk : reward ratio && with reasonable reward.  Those who directly work
with the code tend to underestimate risk and to overestimate reward. ;-)
-- 
Stefan Richter
-=====-==-== ---= ==--=
http://arcgraph.de/sr/
