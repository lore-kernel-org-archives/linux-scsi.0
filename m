From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.5 patch] remove an unused function from wd7000.c
Date: 22 Jun 2003 12:26:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056281197.2075.12.camel@dhcp22.swansea.linux.org.uk>
References: <20030622000538.GM23337@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:39372
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S264854AbTFVLPm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jun 2003 07:15:42 -0400
In-Reply-To: <20030622000538.GM23337@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, trivial@rustcorp.com.au

On Sul, 2003-06-22 at 01:05, Adrian Bunk wrote:
> The patch below removes an unused function from drivers/scsi/wd7000.c .
> 
> I've tested the compilation with 2.5.72-mm2.

What you actually need to do for wd7000 is to make that a new_eh abort
handler. The card every so often loses an IRQ (or we do something that
upsets it - who knows). In that situation we fake an IRQ event which
causes the card to recover and life to continue happily.

Providing you hold the lock all will then untangle.

