From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 2/4] ib_srpt: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Wed, 13 Jan 2016 18:39:20 +0200
Message-ID: <56967DB8.5000401@dev.mellanox.co.il>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
 <1452457724-10629-3-git-send-email-nab@daterainc.com>
 <56941FF6.5090003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34098 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbcAMQjY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 11:39:24 -0500
Received: by mail-wm0-f46.google.com with SMTP id u188so305559532wmu.1
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 08:39:23 -0800 (PST)
In-Reply-To: <56941FF6.5090003@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>


>
> The "goto try_again" statement is executed at most once. Since the above loop
> can be unfolded with only a very minor code duplication I think it should
> be unfolded, e.g. as follows:
>
> 	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name);
> 	if (!se_acl)
> 		se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name + strlen("0x"));
> 	if (!se_acl) {
> 		pr_info("Rejected login because no ACL has been"
> 			" configured yet for initiator %s.\n",
> 			ch->sess_name);
> 		[ ... ]
> 	}
>

I tend to agree, and it would be a bit cleaner to hide this behind
srpt_get_initiator_node_acl wrapper.
