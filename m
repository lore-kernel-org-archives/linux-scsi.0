From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Mon, 13 Jan 2003 16:30:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E232FDD.5000906@splentec.com>
References: <3E1ADC9A.6090800@splentec.com> <20030107102127.B15528@beaverton.ibm.com> <3E1B2934.8060805@splentec.com> <20030107123301.A16378@beaverton.ibm.com> <3E1B513B.2090409@splentec.com> <20030107173633.A17825@beaverton.ibm.com> <20030111181224.B3178@infradead.org> <20030113123306.A16718@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
 >
> This is _not_ just for multi-path. The current scsi code does not properly
> size the target and lun based on the transport. For SPI the target and lun
> need only be one byte; for FCP they are 4 and 8 bytes; for iSCSI I don't
> know what. (Our current four byte host-ordered lun does not match anything
> in any SCSI spec.)

I brought this up last year sometime, either privately or here (search
the archives if anyone is interested) and the idea of using a 64-bit LUN
was shot down as in ``we don't need so many bits''.

The problem is that due to its hierarchical structure all 64 bits are
used. If SPI wants to use 5 bits, let it use 5 bits, if iSCSI wants
to use 64, we've got this covered too.

But it would not be interpreted by SCSI Core, i.e. SCSI Core will simply
copy around the LUN.

BTW, a LUN is a well defined object, cf. SAM-3, 4.9.

> Having a scsi_nexus or such that is host adapter specific (something like
> Mike A. posted about) possibly with common transport code (for FCP, SPI,
> and iSCSI) would be useful, and would make it easier to add multi-pathing
> or support for future transports. The scsi_device current_tag, sdtr, wdtr,
> and ppr would be moved to a scsi_nexus since they are SPI specific.

SCSI Core should know as little as possible about the transport, IMHO.

Also I'd get rid of ``current_tag'', and leave only information as to
what kind of task management the device supports (BQue and CmdQue bits
in INQUIRY data). Also see:

http://MARC.10East.com/?l=linux-scsi&m=103488799412511&w=2

-- 
Luben



