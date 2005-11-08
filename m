From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] [Merging ATA passthru] on  integratingSMART/ATA-Security in usb-storage driver
Date: Tue, 8 Nov 2005 05:51:20 -0800
Message-ID: <464EE07F-3B48-4AD5-9F01-3B51EE0E3E5C@ieee.org>
References: <20051107185718.GA16791@us.ibm.com><Pine.LNX.4.44L0.051107144956 0.5078-100000@iolanthe.rowland.org> <20051107204720.GA18608@us.ibm.com>
Mime-Version: 1.0 (Apple Message framework v746.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051107204720.GA18608@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, linux-ide@vger.kernel.org, Patrick Mansfield <patmans@us.ibm.com>, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org

> ... is usb-storage forcing scsi-2 when the device tells us it is
> scsi-3 compliant, or is the hardware reporting devices are scsi-2, yet
> requiring non-LUN value in cdb[1]?

The very newest devices that pass info thru mask xE0 of cdb[1] may be  
reporting SCSI zero, especially when the cable is not SPI &  
especially when Peripheral Device Type (mask x1F of byte 0 of Inquiry  
data) is nonzero.

> We were told in prior emails that it actually reports a level of zero
> (i.e. no compliance with any SCSI standard)

People dispute what zero means in byte 2 of SCSI Inquiry data.  Here  
are five widely disseminated opinions:

a) T10 s1-r17b: "Version is unspecified.  (Use this code if you are  
implementing to this document - it is not published, yet.)"

b) T10 s1-r17b: "does not claim compliance to the ISO or ECMA  
versions of SCSI".

c) T10 s2-r10l.pdf: "might or might not comply to an ANSI-approved  
standard"

d) T10 s2-r10l.pdf: "does not claim compliance to the ISO or ECMA  
versions of SCSI".

e) SFF sff8020i.pdf: [mask x07] "must contain a zero to comply with  
this version of the Specification"

See that?  Often, the very same document disagrees with itself.

Nowadays, the SFF heresy has grown to where T10 simultaneous  
publishes two or more distinct definitions of Inquiry - the SPC  
definition and the MMC definition.

SPC Inquiry data bytes 58 and following now have "version descriptor"  
definitions that let a device that zeroes byte 2 say more, in  
theory.  I haven't actually seen anyone populate those fields in a  
mass market product?

> ...

I'd think that everyone should accept that trying to reclaim mask xFF  
in the last CDB byte and mask xE0 of CDB byte 1 is rude ... I'm not  
sure what rationally motivates those movements in device design that  
demand greater transparency of a pass thru SCSI host.
