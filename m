From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] results of endianness review of qla2xxx
Date: Sat, 19 Apr 2008 18:52:07 +0100
Message-ID: <20080419175207.GK27459@ZenIV.linux.org.uk>
References: <20080416055458.GC27459@ZenIV.linux.org.uk> <20080418181758.GJ22973@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:46759 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbYDSRwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 13:52:09 -0400
Content-Disposition: inline
In-Reply-To: <20080418181758.GJ22973@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Seokmann Ju <seokmann.ju@qlogic.com>

	More of that stuff (added by [SCSI] qla2xxx: Add hardware
trace-logging support):
                        qla24xx_write_flash_dword(ha, faddr++,
                            cpu_to_le32(jiffies));
                        qla24xx_write_flash_dword(ha, faddr++, 0);
                        qla24xx_write_flash_dword(ha, faddr++, *fdata++);
                        qla24xx_write_flash_dword(ha, faddr++, *fdata);
in qla2xxx_hw_event_store().  All other callers pass host-endian last
argument and function sure as hell looks like it's expecting one...
