From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Fw: Need correction for Acard SCSI Linux driver posted on
	Linuxwebsite. v2.6.12
Date: Sun, 18 Feb 2007 09:57:56 -0600
Message-ID: <1171814276.3423.16.camel@mulgrave.il.steeleye.com>
References: <048701c750fa$fcf13220$6200a8c0@jameshsu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34505 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbXBRP6A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Feb 2007 10:58:00 -0500
In-Reply-To: <048701c750fa$fcf13220$6200a8c0@jameshsu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jameshsu <jameshsu@acard.com>
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>

On Thu, 2007-02-15 at 20:15 +0800, jameshsu wrote:
> Resend

I'm afraid you can't send something of this size to linux-scsi ...
there's a 100k limit on the mail reflector; that's why people tend to do
smaller sizes or multiple patches.

> Please let me know if this submition is proper.
> appreciate for your help!

It would still be nice to have a diff rather than the actual files.

However, looking through there are still one or two fundamental
problems:

	mDelay(3000);				// wait for some ATAPI device ready

Can't be in the driver ... that's a busy wait for 3s which will trip all
of the soft lockup detectors if we ever hit it.  Since this is supposed
to be a SCSI driver, what ATAPI devices are you thinking of?  There's
only one SCSI<->ATA bridge I know and it was used for an obscure DVD
device.

Also, the type Obfuscation:

typedef unsigned char    	UCHAR;
typedef unsigned short   	USHORT;
typedef unsigned int     	UINT;
typedef unsigned long    	ULONG;
typedef unsigned char *  	PUCHAR;
typedef unsigned short * 		PUSHORT;
typedef unsigned int *   	PUINT;
typedef unsigned long *  	PULONG;
typedef void *           	PVOID;
typedef unsigned long    	ULONG_PTR;
typedef unsigned short		IOPORT;

is really contrary to the linux coding style, particularly when it buys
nothing other than a bigger diff in the driver.

Most of this is covered in the Documentation/CodingStyle file in the
kernel tree.

James



