From: Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: build failure of drivers/scsi/gdth.c
Date: Thu, 20 Jan 2011 12:56:36 +0200
Message-ID: <4D3814E4.3090703@voltaire.com>
References: <Pine.LNX.4.64.1101121217090.6323@zuben.voltaire.com>	<20110112083919.494a7404.rdunlap@xenotime.net>	<AANLkTikmygrH_W=nTB2ERPjUETVNzW=8n7VL9Jf6DLu3@mail.gmail.com>	<20110113091127.dcdd3105.rdunlap@xenotime.net>	<4D3543A6.8040909@voltaire.com> <20110118084601.ad10d7ac.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:29692 "EHLO
	Exil2010.voltaire.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755210Ab1ATK4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Jan 2011 05:56:40 -0500
In-Reply-To: <20110118084601.ad10d7ac.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org

Randy Dunlap wrote:
> What shell are you using?
> Are you using any other build scripts that set an variable named VERSION ?
> See https://bugzilla.kernel.org/show_bug.cgi?id=16510

Thanks for the bz pointer, this happens as I wanted to change the kernel version
and added something for sublevel instead for extraversion, I can build 
drivers/scsi/gdth.c fine now, 

so with 

> VERSION = 2
> PATCHLEVEL = 6
> SUBLEVEL = 37
> EXTRAVERSION = -dd
> NAME = Flesh-Eating Bats with Fangs

include/linux/version.h has

> #define LINUX_VERSION_CODE 132645
> #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))

and with 

> VERSION = 2
> PATCHLEVEL = 6
> SUBLEVEL = 37-dd
> EXTRAVERSION =
> NAME = Flesh-Eating Bats with Fangs


include/linux/version.h has

> #define LINUX_VERSION_CODE
> #define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))

and whoever is addressing LINUX_VERSION_CODE fails to get built

