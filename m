From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA passthrough
 CDBs
Date: Thu, 22 Dec 2005 10:24:04 +0100
Message-ID: <43AA70B4.2050509@gmx.de>
References: <20051221122442.GA16571@porkrind.org>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:22919 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S965125AbVLVJYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Dec 2005 04:24:09 -0500
In-Reply-To: <20051221122442.GA16571@porkrind.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

David Caldwell wrote:
> This patch does 2 things. It reimplements the SG_FLAG_LUN_INHIBIT flag
> in the SG_IO ioctl which stops the scsi subsystem from overwriting the
> 2nd byte of the CDB with the LUN. It also doesn't guess the CDB length
> when sending the SG_IO ioctl to the sg device (the main scsi_ioctl
> already did this).
> 
> This is for the Cypress CY7C68310 USB to ATA bridge chip (and most
> likely other USB to ATA chips from Cypress), which implements an ATA
> passthrough command that is 16 bytes long and starts with the bytes
> 0x24 0x24. (Not vendor unique, weird length for opcode 0x24, and
> misuse of the LUN area all at the same time--Lovely).

thx, hm, that chip is that old that datasheet is available no more...

i test it as soon as i get my 68300A changed with the new -B- type back from lab.

anyway, i see the first ATACB enabled (guaranteed) announced chip should be 
the 683xxB types. maybe they have the correct behaviour (16Bytes, opccode length 
problem), so maybe the last part of above functionality could interfere.

interesting is the lately errata sheet for -B-:

-some atacb functionality not availlable if in udma mode
-high order bits of error sector not returned at atacb

