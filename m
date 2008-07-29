From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: tools support for non-512 byte sector sizes
Date: Tue, 29 Jul 2008 19:21:26 +0100
Message-ID: <20080729192126.7261318b@lxorguk.ukuu.org.uk>
References: <488F524F.6020905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53141 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbYG2SjI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2008 14:39:08 -0400
In-Reply-To: <488F524F.6020905@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Jim Meyering <jim@meyering.net>

On Tue, 29 Jul 2008 13:24:31 -0400
Ric Wheeler <rwheeler@redhat.com> wrote:

> 
> Jim pinged me about the use case for having our tool chain (parted 
> specifically) support devices with non-512 bytes sectors.
> 
> Off the top of my head, the following is the list of existing or soon to 
> appear devices that could use this (taken from our thread last year, at
> http://kerneltrap.org/mailarchive/linux-fsdevel/2007/3/11/317183):
> 
>     (1) R/W optical drives

Magneto opticals for years. 640MB M/O is 2K sector size. There are two
different partition table interpretations. One believes the table is 512
byte virtual sectors, the other believes the sectors are sectors. Welcome
to the PC nuthouse...


>     (2) S390 dasd devices have a 4096 byte sector
>     (3) new 4096 byte disks (which intend to export a virtual 512 byte 
> sector)

And which need a specific layout for performance - doubly so with raid
overlaid on it.

Also early SD type devices with 256 byte sectors simply don't work with
our scsi midlayer.

Alan
