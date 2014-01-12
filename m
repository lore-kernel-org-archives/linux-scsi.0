From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 13/14] target/rd: Add DIF protection into rd_execute_rw
Date: Sun, 12 Jan 2014 13:53:28 +0200
Message-ID: <52D28238.5010903@dev.mellanox.co.il>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>	 <1389212157-14540-14-git-send-email-nab@daterainc.com>	 <52CE7ABA.9080403@mellanox.com> <1389336761.5567.403.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:55203 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaALLxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jan 2014 06:53:32 -0500
Received: by mail-ee0-f42.google.com with SMTP id e49so928716eek.29
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jan 2014 03:53:31 -0800 (PST)
In-Reply-To: <1389336761.5567.403.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>

<SNIP>

>> I wander how we can skip  sbc_dif_verify_xxxx if the transport already
>> offloaded DIF verify.
>> I think that the transport should signal the core layer that it is able
>> to offload DIF (ADD/STRIP/PASS/VERIFY), in which case the core should
>> turn off the backstore DIF verify emulation to sustain performance.
> So IBLOCK + PSCSI backends will need to be a non interleaved protection
> PASS for fast path operation, and backend protection emulation is
> reserved for RAMDISK and perhaps a special FILEIO full emulation mode.

But can't we avoid that if transport already verified? This will kill 
performance.

