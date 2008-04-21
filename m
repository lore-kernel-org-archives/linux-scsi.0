From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Mon, 21 Apr 2008 11:19:44 -0700
Message-ID: <20080421181944.GF45789@plap4.qlogic.org>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local> <20080419175207.GK27459@ZenIV.linux.org.uk> <20080419201205.GM27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:21542 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbYDUSTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 14:19:47 -0400
Content-Disposition: inline
In-Reply-To: <20080419201205.GM27459@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

On Sat, 19 Apr 2008, Al Viro wrote:

> ... and while we are at it,
>                         for (miter = 0, s = optrom, d = dwptr;
>                             miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
>                                 *s = cpu_to_le32(*d);
> 
>                         ret = qla2x00_load_ram(ha, optrom_dma,
>                             flash_data_to_access_addr(faddr),
>                             OPTROM_BURST_DWORDS);
> 
> in qla24xx_write_flash_data() looks bloody odd.  We have dwptr pointing
> to fixed-endian data, so conversion gets us host-endian and then we pass
> the area filled with results of conversion for DMA?
> 
> And yes, dwptr points to fixed-endian - it comes from
> qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
>     uint32_t offset, uint32_t length)
> {
> ...
>         rval = qla24xx_write_flash_data(ha, (uint32_t *)buf, offset >> 2,
>             length >> 2);
> 
> Comments?

Sure, you're not understanding the format of the various pieces of
data as they flow through the driver (often times opaquely)...

Look at this code from qla_init.c:qla24xx_load_risc_flash():

	...
	qla24xx_read_flash_data(ha, dcode, faddr, dlen);
	for (i = 0; i < dlen; i++)
		dcode[i] = swab32(dcode[i]);

	rval = qla2x00_load_ram(ha, ha->request_dma, risc_addr, dlen);
	...

why the explicit swab32()?  Because at production time the data was
written in big-endian format.  Yet, when the driver used to carry the
firmware within the driver, the FW folks built the corresponding .C
file of the array of 32-bit words in little-endian format...  There's
a similar case for the code in qla24xx_load_risc() where the .bin file
read via request_firmware() was generated in big-endian format...
Why?  Well...sometimes "stuff" happens and we accept things...

Look, rather than pick apart (the rat hole) each access-region within
flash and determine which endian-format is used during read and
write, let me just say that we'll continue to be extra-cautious when
adding features which interact with the ISPs little-endian RISC and
various BE/LE regions of flash...

Thanks again for your endianess-scrubbing of qla2xxx, I do appreciate
your time and efforts and should have patches submitted shortly for
much of the 'badness' reported.

Thanks,
Andrew Vasquez
