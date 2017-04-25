From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v2 3/7] sd: Cleanup sd_done sense data handling
Date: Tue, 25 Apr 2017 10:54:11 +0900
Message-ID: <a9fecd09-3f80-f26c-eb33-cdb5a3ea3734@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
 <20170424075115.30337-4-damien.lemoal@wdc.com> <20170424153535.GE895@lst.de>
 <yq14lxdh04k.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:49273 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969834AbdDYByV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 21:54:21 -0400
In-Reply-To: <yq14lxdh04k.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Martin,

On 4/25/17 08:11, Martin K. Petersen wrote:
> 
> Christoph,
> 
>> Use a switch for the sense key, and remove two pointless variables
>> that are only used once.
> 
>> -				if (unmap)
> 
> The rationale behind the unmap variable was clarity and avoiding magic
> values.
> 
> I'm OK with this, however:
> 
>> +				if (SCpnt->cmnd[1] & 8) { /* UNMAP */
> 
> So I committed with that change.

Thank you for the commit.

Just one remark:
You left the "good_bytes = 0;" in the else statement of the
ILLEGAL_REQUEST && asc == 0x24 && command == WRITE_SAME case. Is it
really necessary ?

good_bytes is already set to 0 at the beginning of sd_done() when result
!= 0 and again within the initial switch-case for REQ_OP_DISCARD and
REQ_OP_WRITE_SAME cases, which are the only commands that can lead to
hitting that "else" part in the sense data processing.
I may be missing something, but I think that that assignment is redundant.

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Research Group,
Western Digital Corporation
Damien.LeMoal@wdc.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa,
Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
