From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSI commands order when using scsi_do_req
Date: Thu, 02 Jun 2005 12:54:46 -0500
Message-ID: <1117734886.5025.55.camel@mulgrave>
References: <OFE0914CA0.DA8D0415-ONC2257014.004F2855-C2257014.00603EFB@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:63903 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261215AbVFBRyz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2005 13:54:55 -0400
In-Reply-To: <OFE0914CA0.DA8D0415-ONC2257014.004F2855-C2257014.00603EFB@il.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Liran Schour <LIRANS@il.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-06-02 at 20:31 +0300, Liran Schour wrote:
> I am developing a new SCSI upper layer driver. (Object based SCSI device)
> I noticed that scsi_do_req execute commands in LIFO order (add new commands
> to the head of the Q).
> This behavior can cause a starvation of commands (or at least long delays).
> What is the proper solution to this?

Well, to use the proper interfaces.

scsi_do_req is deprecated, so don't use it.  scsi_wait_req is its
replacement.  Note: they're only really intended to allow ULDs to
execute commands that are necessary for controlling the device (that's
why they go at the head of the queue).  Block commands are executed in
order using ULD init_command() (or REQ_BLOCK_PC).

James


