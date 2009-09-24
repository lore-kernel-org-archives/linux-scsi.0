From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC][PATCH v2]Add pm8001 SAS/SATA HBA driver
Date: Thu, 24 Sep 2009 14:04:02 -0700
Message-ID: <1253826242.5183.178.camel@mulgrave.site>
References: <9A9AF0C219C5433DB5A8D61D4914C599@usish.com.cn>
	 <200909150807.36222.eike-kernel@sf-tec.de>
	 <4E716EE5A6E14CBEB7C6A982E2347934@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33276 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbZIXVEQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 17:04:16 -0400
In-Reply-To: <4E716EE5A6E14CBEB7C6A982E2347934@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: 'Rolf Eike Beer' <eike-kernel@sf-tec.de>, matthew@wil.cx, linux-scsi@vger.kernel.org, lindar_liu@usish.com, tom_peng@usish.com, 'aoqingy' <aoqingyun@usish.com>, roy_wang@usish.com

On Wed, 2009-09-16 at 11:27 +0800, jack wang wrote:
> Here is an update of our driver patch that incorporates the latest review
> inputs from Eike.

I'm afraid this driver has a slightly more serious issue:  it uses
virt_to_bus() and therefore won't compile on a lot of non-x86 systems:

pm8001_hwi.c:           phys_addr = cpu_to_le64(virt_to_bus((void *)(ccb->buf_pr
pm8001_hwi.c:           phys_addr = cpu_to_le64(virt_to_bus((void *)(ccb->buf_pr

It' looks like MEM_CCB already has the physical address of this region,
so you don't need to use virt_to_bus, you can just compute the offset
from the MEM_CCB virt address and add the phys address.

James


