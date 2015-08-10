From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Mon, 10 Aug 2015 08:30:35 -0700
Message-ID: <55C8C39B.1010000@sandisk.com>
References: <55C8C0DC.7070505@clodo.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:10560
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751551AbbHJPam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Aug 2015 11:30:42 -0400
In-Reply-To: <55C8C0DC.7070505@clodo.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kkv@clodo.ru, linux-scsi@vger.kernel.org

On 08/10/2015 08:18 AM, Konstantin Krotov wrote:
> I was faced with the following problem:
>
> Im exported to compute-node scsi disks through ib_srp from storages. And
> if reconnect occurs for any reason, eg
>
> "[1201117.626498] scsi host62: ib_srp: REJ received
> [1201117.626507] scsi host62: ib_srp: SRP LOGIN from
> fe80:0000:0000:0000:0002:c903:0009:1796 to
> fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
> [1201117.626656] scsi host62: ib_srp: Connection 0/8 failed"
>
> i find threads in output ps:
> "root     28047  0.0  0.0      0     0 ?        S    18:04   0:00
> [scsi_eh_62]
> root     28048  0.0  0.0      0     0 ?        S<   18:04   0:00
> [scsi_tmf_62]"
>
> Each reconnect generates two thread, which do not die.
>
> kernel version 3.19.1
>
> modinfo ib_srp
> filename:       /lib/modules/3.19-3-amd64/updates/dkms/ib_srp.ko
> release_date:   Apr 09 2015
> version:        2.0.32#in-tree

Hello Konstantin,

Does the above output mean that you are using the ib_srp-backport driver 
? If so, please upgrade to version v2.0.34. That version includes all 
SRP initiator fixes that have been posted on the linux-rdma and 
linux-scsi mailing lists for inclusion in Linux kernel v4.3.

Bart.

