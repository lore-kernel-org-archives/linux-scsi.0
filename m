From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Mon, 21 Apr 2008 10:38:04 -0700
Message-ID: <20080421173804.GD45789@plap4.qlogic.org>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local> <20080419175207.GK27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11227 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYDURiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Apr 2008 13:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20080419175207.GK27459@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

On Sat, 19 Apr 2008, Al Viro wrote:

> 	More of that stuff (added by [SCSI] qla2xxx: Add hardware
> trace-logging support):
>                         qla24xx_write_flash_dword(ha, faddr++,
>                             cpu_to_le32(jiffies));
>                         qla24xx_write_flash_dword(ha, faddr++, 0);
>                         qla24xx_write_flash_dword(ha, faddr++, *fdata++);
>                         qla24xx_write_flash_dword(ha, faddr++, *fdata);
> in qla2xxx_hw_event_store().

The data portions of 'fdata[]' are composites of:

	#define QMARK(a, b, c, d) \
	    cpu_to_le32(LSB(a) << 24 | LSB(b) << 16 | LSB(c) << 8 | LSB(d))
	...
	/* Create marker. */
	marker[0] = QMARK('L', ha->fw_major_version,
	    ha->fw_minor_version, ha->fw_subminor_version);
	marker[1] = QMARK(QLA_DRIVER_MAJOR_VER, QLA_DRIVER_MINOR_VER,
	    QLA_DRIVER_PATCH_VER, QLA_DRIVER_BETA_VER);

and:

        /* Store error.  */
        fdata[0] = cpu_to_le32(code << 16 | d1);
        fdata[1] = cpu_to_le32(d2 << 16 | d3);
        rval = qla2xxx_hw_event_store(ha, fdata);

> All other callers pass host-endian last
> argument and function sure as hell looks like it's expecting one...

I'm not entirely clear on what you are driving at here...  The data in
question is written to flash in little-endian format...
