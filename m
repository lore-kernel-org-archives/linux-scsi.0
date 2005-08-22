From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] minimal SAS transport class
Date: Mon, 22 Aug 2005 17:08:33 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C03B21627@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60372 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932312AbVHVXI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 19:08:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, jejb@steeleye.com, ltuikov@yahoo.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

On Sunday, August 21, 2005 10:53 AM, Christoph Hellwig wrote:
> This is just a brindup helper because the Fusion hardware does a SAS
> remote port to target ID mapping in firmware, in fact the firmware
> interface only addresses them using this assigned ID, which is a big
> shortcoming in the Fusion interface.  Once the more basic things are
> dealt with that will go away, similarly to how Fusion won't be able
> to use their firmware mapping for FC once they fully support the FC
> transport class.
>

Thats incorrect about the Fusion Firmware Interface.

The Sas Device Config pages offers three ways to access this config page.
They are:  (1) GetNextHandle (2) BusTargetID (3) Handle.
This is set in config page pageAddr field - bits 28-31.  Lets say you want
to know all the devices out in the sas domain that is discovered by
this HBA, you do the GetNextHandle method.  Bits 0-27 is the FormSpecific.
In FormSpecific, you pass 0xFFFF for the first request, then you pass the
devHandle for the previous config page to get the next.  The 3.02.55 code
I sent you did this discovery in mptbase.c, in a function called
mpt_sas_get_info.
All this info is stored in a link list, that currently is used for CSMI.

Eric Moore
 
