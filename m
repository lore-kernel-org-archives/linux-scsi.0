From: Grant Grundler <iod00d@hp.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Mon, 9 Jun 2003 17:36:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030610003637.GI29808@cup.hp.com>
References: <20030609174647.GB29808@cup.hp.com> <20030609122907.A16169@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:23712 "EHLO palrel13.hp.com")
	by vger.kernel.org with ESMTP id S262316AbTFJAXB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 20:23:01 -0400
Content-Disposition: inline
In-Reply-To: <20030609122907.A16169@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 12:29:07PM -0700, Patrick Mansfield wrote:
> Are you sure the mode select is really working in your code?

Short answer, i don't think so.

I found a SCSI IBM "DGHS09Y  CLAR09" still formatted to 520 byte.
I've twiddled the code a bit so the output isn't identical to
previous FC runs. But my main goal is to show the format mode
page "Mask" isn't all zero's for this drive and blk512-linux.c
doesn't work for a "regular" SCSI drive either.

The DGHS09Y drive is behind 53c1030 (built-in) using mpt v2.03.00 driver.

thanks,
grant


iota:/home/grundler/Src/blk512# scsiinfo -i /dev/sg0

Inquiry command
---------------
Relative Address                   0
Wide bus 32                        0
Wide bus 16                        1
Synchronous neg.                   1
Linked Commands                    1
Command Queueing                   1
SftRe                              0
Device Type                        0
Peripheral Qualifier               0
Removable?                         0
Device Type Modifier               0
ISO Version                        0
ECMA Version                       0
ANSI Version                       3
AENC                               0
TrmIOP                             0
Response Data Format               2
Vendor:                    IBM     
Product:                   DGHS09Y  CLAR09 
Revision level:            HP1A68007236GAGSPDH01A  DG11802742000
iota:/home/grundler/Src/blk512# ./blk512-linux -s 512 -c 17916240  /dev/sg0

Mode Sense Current:

0x0000:   23 00 10 08 00 ff ff ff  00 00 02 08 83 16 00 0a
0x0010:   00 02 00 00 00 00 01 13  02 08 00 01 00 1c 00 47
0x0020:   40 00 00 00

Mode Sense Default:

0x0000:   23 00 10 08 00 ff ff ff  00 00 02 08 83 16 00 0a
0x0010:   00 02 00 00 00 00 01 13  02 08 00 01 00 1c 00 47
0x0020:   40 00 00 00

Mode Select Data:

0x0000:   00 00 00 08 01 11 61 50  00 00 02 00
        mlen 0xc  resid 0xb duration 0  info 0x0
Done setting /dev/sg0 to 17916240 blocks/512 bytes_per_block
iota:/home/grundler/Src/blk512# scsiinfo -f /dev/sg0

Data from Format Device Page
----------------------------
Removable Medium                   0
Supports Hard Sectoring            1
Supports Soft Sectoring            0
Addresses assigned by surface      0
Tracks per Zone                    10
Alternate sectors per zone         2
Alternate tracks per zone          0
Alternate tracks per lun           0
Sectors per track                  275
Bytes per sector                   520
Interleave                         1
Track skew factor                  28
Cylinder skew factor               71

iota:/home/grundler/Src/blk512# ./blk512-linux -M -s 512 -c 17916240  /dev/sg0

Mode Sense Mask:

0x0000:   23 00 10 08 00 ff ff ff  00 00 02 08 83 16 ff ff
0x0010:   ff ff 00 00 00 00 00 00  ff ff ff ff 00 00 00 00
0x0020:   00 00 00 00

Mode Sense Current:

0x0000:   23 00 10 08 00 ff ff ff  00 00 02 08 83 16 00 0a
0x0010:   00 02 00 00 00 00 01 13  02 08 00 01 00 1c 00 47
0x0020:   40 00 00 00

Mode Sense Default:

0x0000:   23 00 10 08 00 ff ff ff  00 00 02 08 83 16 00 0a
0x0010:   00 02 00 00 00 00 01 13  02 08 00 01 00 1c 00 47
0x0020:   40 00 00 00

Mode Select Data:

0x0000:   00 00 00 08 01 11 61 50  00 00 02 00 03 16 00 0a
0x0010:   00 02 00 00 00 00 01 13  02 00 00 01 00 1c 00 47
0x0020:   40 00 00 00
        mlen 0x24  resid 0x23 duration 0  info 0x0
Done setting /dev/sg0 to 17916240 blocks/512 bytes_per_block

