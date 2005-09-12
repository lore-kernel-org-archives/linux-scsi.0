From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Mon, 12 Sep 2005 16:31:42 -0400
Message-ID: <4325E5AE.1080900@adaptec.com>
References: <20050910024454.20602.qmail@web51613.mail.yahoo.com>	 <1126368081.4813.46.camel@mulgrave>  <4325997D.3050103@adaptec.com> <1126547565.4825.52.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6029 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932121AbVILUbt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 16:31:49 -0400
In-Reply-To: <1126547565.4825.52.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/12/05 13:52, James Bottomley wrote:
> Well there is this in sas_discover.h:
> 
> struct scsi_core_mapping {
> 	int  channel;
> 	int  id;
> };
> 
> struct LU {
> [...]
> 	struct scsi_core_mapping map;
> 
> 
> so if you use channel, id and scsilun_to_int() (or your SCSI_LUN
> reimplementation of that) on your LUN structure, you have everything
> necessary to interface to scsi_scan_target, yes.
> 
> You have to have this, otherwise you wouldn't be able to use
> scsi_add_device in sas_scsi_host.c:sas_register_with_scsi().
> 
> Based on this it does look like your refusal to use scsi_scan_target is
> based on ideological rather than technical objections.

Hmm, no.

Channel and id are assigned _after_ the device has been scanned for
LUs.  So I cannot just call scsi_scan_target() and say: "here is
this SCSI Domain device, I know nothing about, other than
the fact that it has a Target port, scan it".

SCSI Core has no representation of a SCSI Target, it has
an HCIL representation.

> It also looks like you have a bug in your id mapping code: you allocate
> one id per lun, not per target, so you're going to run out pretty
> quickly when you meet a device with actual logical units, since you hard
> code max_ids to 128 in sas_port.c

Yes, this is a bit more involved (on a larger scale than per port).
The hard coding is intentional.

Ideally, I'd not have to generate Channel and Id to accomodate
SCSI Core's ancient SPI centric code.

Then I'd not need max_ids and/or the bitmap.

	Luben



