From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] target: Fix LUN_RESET active I/O handling for
 ACK_KREF
Date: Tue, 12 Jan 2016 08:32:48 -0800
Message-ID: <56952AB0.1070806@sandisk.com>
References: <1452594245-921-1-git-send-email-nab@daterainc.com>
 <1452594245-921-2-git-send-email-nab@daterainc.com>
 <20160112152059.GB2294@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:48212
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761454AbcALQcy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 11:32:54 -0500
In-Reply-To: <20160112152059.GB2294@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

On 01/12/2016 07:20 AM, Christoph Hellwig wrote:
>> It also introduces SCF_ACK_KREF to determine when
>> transport_cmd_finish_abort() needs to drop the second
>> extra reference, ahead of calling target_put_sess_cmd()
>> for the final kref_put(&se_cmd->cmd_kref).
>
> It would be really useful to have all drivers follow that
> ACK KREF model instead of needing to deal with driver
> differences everywhere..

Hello Christoph,

How about eliminating the TARGET_SCF_ACK_KREF flag ? If a command would 
only be freed upon the last target_put_sess_cmd() call then I think that 
the check_stop_free() callback wouldn't have to call 
target_put_sess_cmd() and hence that the TARGET_SCF_ACK_KREF flag could 
be removed.

Bart.
