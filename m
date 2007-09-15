From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 16/22] advansys: Eliminate prototypes
Date: Sat, 15 Sep 2007 09:39:05 -0500
Message-ID: <1189867145.3339.3.camel@localhost.localdomain>
References: <20070909145358.GG6809@parisc-linux.org>
	 <11893498072821-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:53518 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527AbXIOOjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 10:39:09 -0400
In-Reply-To: <11893498072821-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sun, 2007-09-09 at 08:56 -0600, Matthew Wilcox wrote:
> Rearrange a lot of the functions in the file to get rid of all the
> forward
> declarations.

I get a compile failure at this point in your patch sequence:

  CC [M]  drivers/scsi/advansys.o
drivers/scsi/advansys.c:72:2: warning: #warning this driver is still not
properly converted to the DMA API
drivers/scsi/advansys.c: In function 'AscGetChipBiosAddress':
drivers/scsi/advansys.c:11536: error: implicit declaration of function
'AscGetEisaChipCfg'
drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:11555: error: conflicting types for
'AscGetEisaChipCfg'
drivers/scsi/advansys.c:11536: error: previous implicit declaration of
'AscGetEisaChipCfg' was here
drivers/scsi/advansys.c: In function 'AscSetIsaDmaSpeed':
drivers/scsi/advansys.c:11750: error: implicit declaration of function
'AscGetIsaDmaSpeed'
drivers/scsi/advansys.c: At top level:
drivers/scsi/advansys.c:11754: error: conflicting types for
'AscGetIsaDmaSpeed'
drivers/scsi/advansys.c:11750: error: previous implicit declaration of
'AscGetIsaDmaSpeed' was here
make[2]: *** [drivers/scsi/advansys.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

I've put 1-15 in .. could you rebase against scsi-misc and eliminate
this problem?

Thanks,

James


