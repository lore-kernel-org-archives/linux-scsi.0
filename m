From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 03/15] be2iscsi: Link Wrb with next Wrb
Date: Thu, 10 Dec 2009 11:16:42 -0600
Message-ID: <1260465402.2457.101.camel@mulgrave.site>
References: <20091204031848.GA6035@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761231AbZLJRQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 12:16:42 -0500
In-Reply-To: <20091204031848.GA6035@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Fri, 2009-12-04 at 08:48 +0530, Jayamohan Kallickal wrote:
> This patch will link the current allocated wrb with the next
>  wrb that will be allocated. This is a requirement from the chip.

This patch breaks bisectability:

  CC [M]  drivers/scsi/be2iscsi/be_main.o
drivers/scsi/be2iscsi/be_main.c:635: error: conflicting types for 'alloc_wrb_handle'
drivers/scsi/be2iscsi/be_main.h:654: error: previous declaration of 'alloc_wrb_handle' was here
make[3]: *** [drivers/scsi/be2iscsi/be_main.o] Error 1

To be bisectable, a patch series must compile at every point of application.

James


