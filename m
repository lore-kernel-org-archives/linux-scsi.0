From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [usb-storage] Re: iRiver H100 series and usb-storage issues
Date: 08 Jun 2004 10:52:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086709937.2105.8.camel@mulgrave>
References: <Pine.LNX.4.44L0.0406081019281.1222-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:15510 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265229AbUFHPw1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 11:52:27 -0400
In-Reply-To: <Pine.LNX.4.44L0.0406081019281.1222-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Pat LaVarre <p.lavarre@ieee.org>, Philippe Troin <phil@fifi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net

On Tue, 2004-06-08 at 09:24, Alan Stern wrote:
> sd doesn't receive any error indication other than positive residue, and 
> it ignores the residue.

Erm, but sd doesn't expect a non zero residue (and producing one is
illegal) because it sets underflow to the exact size for all read and
write commands.

Usually HBAs ignore underflow, because it simply works correctly for all
SCSI devices I've ever come across.  However, if you're going to be
getting these problems, you really should be checking the underflow.

The meaning of this field is supposed to be "return an error if you
transfer fewer than underflow bytes".  The error's not specified, but
something like DID_ERROR with SUGGEST_RETRY should be fine.

James


