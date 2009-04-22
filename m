From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: The order of generating sd name
Date: Wed, 22 Apr 2009 08:24:40 -0400
Message-ID: <1240403080.3431.7.camel@mulgrave.int.hansenpartnership.com>
References: <d364733c0904210226i2b48ae21pb5c39f338f53194b@mail.gmail.com>
	 <20090421144313.GA313@mars.virtualiron.com>
	 <d364733c0904210801n2d317adeh1978d71c35741c0b@mail.gmail.com>
	 <d364733c0904220409g4a86cf54k82ab3b7afdbcb8a2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52422 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751468AbZDVMYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 08:24:42 -0400
In-Reply-To: <d364733c0904220409g4a86cf54k82ab3b7afdbcb8a2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?=E8=B0=A2=E7=BA=B2?= <xiegang112@gmail.com>
Cc: Konrad Rzeszutek <konrad@virtualiron.com>, linux-scsi@vger.kernel.org

On Wed, 2009-04-22 at 19:09 +0800, =E8=B0=A2=E7=BA=B2 wrote:
> I found that, my my kernel version is 2.6.16 (SUSE10). And the HBA
> driver are qla. The scsi async scan is not supported in this version.
> And It seems that,  if the scan starts at scsi_scan_host, the naming
> order is ensured.  Did the qla driver scan the lun in the thread
> qla2x00_do_dpc itself?  To generate the sd name, sd_probe need to be
> invoked. I can not find the invokation in the qla driver.

This is business as usual.  The discovery order isn't guaranteed.
Without async scan it depends on machine deterministic things like the
order the bios lays out the PCI bus, but that's not going to be constan=
t
across machines.  Async scanning just makes reordering less machine
hardware dependent.

The way to cope with this is to mount devices by device id or uuid.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
