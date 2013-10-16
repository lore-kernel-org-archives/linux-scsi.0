From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Is there any plan to support 64bit lun in mainline?
Date: Tue, 15 Oct 2013 21:11:11 -0700
Message-ID: <525E11DF.3040004@vlnb.net>
References: <FD44589ECFC0AF44ABFD421806CAB1F081EC2FEA@SZXEMA502-MBX.china.huawei.com>  <525BC836.2030306@suse.de> <1381775449.3752.9.camel@dabdike.lan> <525CDA2A.2060308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3JPELv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2013 00:11:51 -0400
In-Reply-To: <525CDA2A.2060308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Hannes Reinecke, on 10/14/2013 11:01 PM wrote:
> And HBAs like lpfc or qla2xxx even have a fast command abort built
> into the firmware, where the firmware will not even wait for a
> command abort to hit the wire but rather just disable the exchange
> internally and return.

Doing so is asking for data corruption. Aborts intended to cleanup commands on the
target, so they could not anyhow badly interact with future commands. Otherwise it is
possible that an old WRITE command stuck in some deep corner inside the target, be
bypassed by such pseudo-abort and then got released AFTER its LBAs written by newer
data, hence overwrite new data by old data.

Vlad
