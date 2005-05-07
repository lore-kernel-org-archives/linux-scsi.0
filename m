From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aha2940 on 2.6.9
Date: Sat, 07 May 2005 10:30:39 -0500
Message-ID: <1115479839.5094.2.camel@mulgrave>
References: <20041117.142325.74756248.chamas@h4.dion.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:65005 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262614AbVEGPao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 May 2005 11:30:44 -0400
In-Reply-To: <20041117.142325.74756248.chamas@h4.dion.ne.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-11-17 at 14:23 +0900, Ken-ichirou MATSUZAWA wrote:
>  Hello, I'm using kernel-2.6 with aha2940.
> until 2.6.8.1 it works fine but since 2.6.9, I've been getting message:
> 
>   Nov 17 13:45:48 plath kernel: FAILED
>   Nov 17 13:45:48 plath kernel:   status = 1, message = 00, host = 0, driver = 08
>   Nov 17 13:45:48 plath kernel:   Current sd: sense = 70  5
>   Nov 17 13:45:48 plath kernel: ASC=20 ASCQ= 0
>   Nov 17 13:45:48 plath kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 

The error is coming from the device, and has nothing to do with the
driver.  It's ILLEGAL REQUEST, INVALID COMMAND OPERATION CODE.

That means that something sent the device a SCSI command it didn't
understand.  Without knowing what the command was it's hard to say, but
my best guess would be that some userland program is sending commands to
the device and got one wrong.

James


