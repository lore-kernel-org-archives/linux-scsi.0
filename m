From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated
	SCSI hosts
Date: 22 Apr 2003 12:37:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051033033.1768.65.camel@mulgrave>
References: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:775 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263264AbTDVRZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 13:25:22 -0400
In-Reply-To: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, mike@hingston.demon.co.uk, torvalds@transmeta.com, usb-storage@one-eyed-alien.net

On Tue, 2003-04-22 at 12:22, Andries.Brouwer@cwi.nl wrote:
[...]

Actually, could this

> Apr  9 17:34:55 lemon: usb-storage: Invoking Mode Translation

Be the root cause?  It indicates that usb storage modified the command.

In 2.5.68 that's doing a translation from MODE SENSE(6) to MODE
SENSE(10) inside the driver.

But the odd thing in usb/storage/protocol.c is this (about line 354):

                case MODE_SENSE:
                case MODE_SELECT:
                        srb->cmd_len = 12;
                        srb->cmnd[11] = 0;
                        srb->cmnd[10] = 0;

Why is a 10 byte command given a command length of 12?

James

