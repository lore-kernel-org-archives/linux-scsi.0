From: Tommaso Moroni <tommaso.m@tiscalinet.it>
Subject: extracting infos from struct scsi_cmnd
Date: Sat, 27 Nov 2004 13:42:22 +0100
Message-ID: <20041127124222.GA1200@abulafia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vsmtp3alice.tin.it ([212.216.176.143]:63360 "EHLO vsmtp3.tin.it")
	by vger.kernel.org with ESMTP id S261203AbUK0MmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Nov 2004 07:42:24 -0500
Received: from hope.hyperuranous (80.180.121.150) by vsmtp3.tin.it (7.0.027)
        id 41A03E2F0029F5E7 for linux-scsi@vger.kernel.org; Sat, 27 Nov 2004 13:42:24 +0100
Received: from tommaso by hope.hyperuranous with local (Exim 4.34)
	id 1CY1uA-0000Jy-AF
	for linux-scsi@vger.kernel.org; Sat, 27 Nov 2004 13:42:22 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi!

I'm writing a module for the 2.6.9 kernel which tracks accesses on a usb-storage device;
in particular I'm interested in extracting from a struct scsi_cmnd the data read/written 
and the associated sector. 


The code I'vr written till now looks like the following:


struct scsi_cmnd * cmd;
[...]
if (cmd->use_sg == 0)
{
	buf = cmd->buffer;
	buflen = cmd->bufflen;
	sector = cmd->request->sector;
} else {
	struct scatterlist * sl = (struct scatterlist *) cmd->buffer;
	for (i = 0; i < cmd->use_sg; i++)
	{
		buf = page_address(sl[i].page) + sl[i].offset;
                buflen = sl[i].length;
		/* sector? */
	}
}


Is it correct?
Where can I find the sector involved in the operation if the scatter-gather is used?


Thank you in advance
-- 
Tommaso Moroni <tommaso.m@tiscalinet.it>
