From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 07 Sep 2007 19:00:40 -0400
Message-ID: <46E1D818.4080608@garzik.org>
References: <BC382691D59EC94C8E57543C47EF8ED55B20C0@aime2k302.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37994 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXIGXAl (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 7 Sep 2007 19:00:41 -0400
In-Reply-To: <BC382691D59EC94C8E57543C47EF8ED55B20C0@aime2k302.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

Wu, Gilbert wrote:
> HI Jeff,
> 
>   I was thinking the checking "READ/WRITE" command table is larger than
> my current table. This does not cover vendor-specific command. 

You can implement the check in a _far_ more optimal manner:

Possibility 1:

	static const u8 ata_rw_command_table[256] = {
		[ATA_CMD_READ]		= 1,
		[ATA_CMD_READ_EXT]	= 1,
		... other READ/WRITE commands here, always value==1 ...
	};

	...

	u8 ata_command = ... ;

	if (ata_rw_command_table[ata_command]) {
		/* it is a read/write command */
	} else {
		/* it is NOT a read/write command */
	}

Possibility 2:

	static inline int is_ata_rw_cmd(u8 ata_cmd)
	{
		switch (ata_cmd) {
		case ATA_CMD_READ:
		case ATA_CMD_READ_EXT:
		... other READ/WRITE commands here ...
			return 1;
		}

		return 0;
	}

Either way you avoid the iteration, and simplify things down to a single 
test.

Once that is done, it should be self-evident that testing -any- list of 
commands is O(1), rather than O(n) for the case of table iteration.  And 
therefore, the cost of checking "is it a READ/WRITE command?" is equal 
to the cost of checking for any other commands.


> Do you wan me just check READ/WRITE command? 

Yes, please.


> The aic94xx default implementation is all ATA command will be returning
> ATA output register if the command did not succeed.

Great!

	Jeff



