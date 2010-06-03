From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] scsi: fix scsi_get_lba helper function for pc command
Date: Thu, 3 Jun 2010 20:18:53 +0900
Message-ID: <20100603201825C.fujita.tomonori@lab.ntt.co.jp>
References: <20100602163313S.fujita.tomonori@lab.ntt.co.jp>
	<1275487628.2799.18.camel@mulgrave.site>
	<4C0670D5.3050409@interlog.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40047 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab0FCLTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 07:19:13 -0400
In-Reply-To: <4C0670D5.3050409@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp, jaxboe@fusionio.com, linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com

On Wed, 02 Jun 2010 10:55:17 -0400
Douglas Gilbert <dgilbert@interlog.com> wrote:

> Is it so important to have scsi_get_lba() for "PC" commands?
> Why not just return 0 or MAX_UINT and be done with it.

Might not be so important. However, as I wrote to Martin, we already
have duplicated code that does the same thing. It's nice if we can
clean them up.


> A "PC" command might be lots of things. For example:
>    - a tunnelled ATA command
>    - a non SCSI protocol
>    - a SCSI vendor specific or obsolete command
>      (e.g. some SCSI PRINTER commands share opcodes with
>       READ and WRITE)
>    - from a lesser used command set (e.g. OSD or SSC)
> 
> A LLD may well be able to narrow the field if it has a
> reason to decode the command to find a LBA or other info.

Yeah, but it would be better to set such info in the common place?
If a LLD likes, it gets such info again in any way for itself.
