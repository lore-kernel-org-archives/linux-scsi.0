From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 7 Sep 2007 16:58:42 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20C6@aime2k302.adaptec.com>
References: <46E1D818.4080608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:52947 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751231AbXIGX6o convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 7 Sep 2007 19:58:44 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46E1D818.4080608@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux-scsi@vger.kernel.org

Hi Jeff,

 Thanks for your suggestions. I have done some experiment to return all
ATA output register except for Read/Write command. But the aic94xx
discovery machine just can not find the SATA device. Probably I will fix
the new issue by next week since I have the other hot issue here.

Thanks!
Gilbert

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Friday, September 07, 2007 4:01 PM
To: Wu, Gilbert
Cc: Linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem

Wu, Gilbert wrote:
> HI Jeff,
> 
>   I was thinking the checking "READ/WRITE" command table is larger
than
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


> The aic94xx default implementation is all ATA command will be
returning
> ATA output register if the command did not succeed.

Great!

	Jeff



