From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 1/3] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Thu, 28 Jan 2016 19:00:28 +0200
Message-ID: <56AA492C.2080301@dev.mellanox.co.il>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com>
 <1453513067-23169-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35974 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966744AbcA1RAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 12:00:34 -0500
Received: by mail-wm0-f53.google.com with SMTP id p63so33889706wmp.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 09:00:33 -0800 (PST)
In-Reply-To: <1453513067-23169-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>


> +		sess = cmd->se_sess;
> +		if (WARN_ON_ONCE(!sess))
> +			continue;
> +
> +		spin_lock(&sess->sess_cmd_lock);
> +		rc = __target_check_io_state(cmd);
> +		spin_unlock(&sess->sess_cmd_lock);
> +		if (!rc) {
> +			printk("LUN_RESET I/O: non-zero kref_get_unless_zero\n");

Is this message always correct? __target_check_io_state() will return
false for commands that were completed..
