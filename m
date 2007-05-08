From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM
Date: Tue, 8 May 2007 17:11:05 +0100
Message-ID: <20070508171105.053d0286@the-village.bc.nu>
References: <20070508170335.1b1f844c@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49054 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754570AbXEHQG4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 12:06:56 -0400
In-Reply-To: <20070508170335.1b1f844c@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org

On Tue, 8 May 2007 17:03:35 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> nor should it). However they get injected into the SCSI layer via
> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> along to a device with unchecked_isa_dma set which either panics or
> truncates the buffer to 24bits.

Umm duh there's a memory leak in an error case there still. Please
discard and I'll post a new one shortly
