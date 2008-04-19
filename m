From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Sat, 19 Apr 2008 21:12:05 +0100
Message-ID: <20080419201205.GM27459@ZenIV.linux.org.uk>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local> <20080419175207.GK27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:60853 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYDSUMH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 16:12:07 -0400
Content-Disposition: inline
In-Reply-To: <20080419175207.GK27459@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

... and while we are at it,
                        for (miter = 0, s = optrom, d = dwptr;
                            miter < OPTROM_BURST_DWORDS; miter++, s++, d++)
                                *s = cpu_to_le32(*d);

                        ret = qla2x00_load_ram(ha, optrom_dma,
                            flash_data_to_access_addr(faddr),
                            OPTROM_BURST_DWORDS);

in qla24xx_write_flash_data() looks bloody odd.  We have dwptr pointing
to fixed-endian data, so conversion gets us host-endian and then we pass
the area filled with results of conversion for DMA?

And yes, dwptr points to fixed-endian - it comes from
qla24xx_write_optrom_data(struct scsi_qla_host *ha, uint8_t *buf,
    uint32_t offset, uint32_t length)
{
...
        rval = qla24xx_write_flash_data(ha, (uint32_t *)buf, offset >> 2,
            length >> 2);

Comments?
