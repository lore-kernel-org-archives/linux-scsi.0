From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Thu, 6 Sep 2007 11:33:21 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20C0@aime2k302.adaptec.com>
References: <20070906100602.GA22773@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:37030 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754709AbXIFSdb convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 6 Sep 2007 14:33:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070906100602.GA22773@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux-scsi@vger.kernel.org

HI Jeff,

  I was thinking the checking "READ/WRITE" command table is larger than
my current table. This does not cover vendor-specific command. 
Do you wan me just check READ/WRITE command? 
The aic94xx default implementation is all ATA command will be returning
ATA output register if the command did not succeed.

Thanks!
Gilbert

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Thursday, September 06, 2007 3:06 AM
To: Wu, Gilbert
Cc: Linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem

On Wed, Sep 05, 2007 at 03:25:55PM -0700, Gilbert Wu wrote:
>    Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
does not work on SATA device.
>    ( The smartctl v5.38 does need "-d ata" option.)
>    The root cause is the aic94xx driver does not return ATA output
register due to performance reason.
>    The aic94xx need check ATA command which need ATA output register
and turn on internal flag to
>    enable firmware to return ATA output register to top layer.
>    It also add new ATA commands to ata.h sush as
ATA_CMD_CHK_MEDIA_TYPE and ATA_CMD_SMART.
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

All commands except for hot path READ/WRITE should be returning ATA
output registers.

Additionally, READ/WRITE should be returning ATA output registers,
if the READ/WRITE command did not succeed.

Any code that requires an "accepted list of commands" is problematic,
because it does not take into account vendor-specific commands.

	Jeff



