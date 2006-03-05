From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [RFC] first cut at infrastructure for handling different device types in the sas class
Date: Sat, 4 Mar 2006 19:42:39 -0800 (PST)
Message-ID: <20060305034239.19084.qmail@web31812.mail.mud.yahoo.com>
References: <1141497236.9895.2.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:14502 "HELO
	web31812.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751100AbWCEDmk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Mar 2006 22:42:40 -0500
In-Reply-To: <1141497236.9895.2.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
>  Then the phy can have a simple link to the port it's a
> member of.

This is already the case in the SAS stack.  Here is an example of wide and
narrow ports. The wide port in this example connects to a domain with
three cascaded expanders; the narrow port to a SAS disk.

$tree -d /sys/devices/pci0000\:01/0000\:01\:04.0/host11/sas/ha 

/sys/devices/pci0000:01/0000:01:04.0/host11/sas/ha
|-- phys
|   |-- 0
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/0
|   |-- 1
|   |-- 2
|   |-- 3
|   |-- 4
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   |-- 5
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   |-- 6
|   |   `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
|   `-- 7
|       `-- port -> ../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/ports/1
`-- ports
    |-- 0
    |   |-- domain
    |   |   `-- 500000e000031c12
    |   |       `-- LUNS
    |   |           `-- 0000000000000000
    |   `-- phys
    |       `-- 0 ->
../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/0
    `-- 1
        |-- domain
        |   `-- 50001c1716010600
        |       |-- 50001c1071609c00
        |       |   |-- 50001c1071609c02
        |       |   |-- 5000c50000102a65
        |       |   |   `-- LUNS
        |       |   |       `-- 0000000000000000
        |       |   `-- 5005076a000001e0
        |       |       |-- 5000c50000513385
        |       |       |   `-- LUNS
        |       |       |       `-- 0000000000000000
        |       |       |-- 5005076a000001ed
        |       |       |   `-- LUNS
        |       |       |       `-- 0000000000000000
        |       |       `-- 5c50000000409c11
        |       |           `-- LUNS
        |       |               `-- 0000000000000000
        |       |-- 50001c1716010603
        |       |-- 50001c171601060d
        |       |   `-- LUNS
        |       |       `-- 0000000000000000
        |       `-- 5000c50000513329
        |           `-- LUNS
        |               `-- 0000000000000000
        `-- phys
            |-- 4 ->
../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/4
            |-- 5 ->
../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/5
            |-- 6 ->
../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/6
            `-- 7 ->
../../../../../../../../../devices/pci0000:01/0000:01:04.0/host11/sas/ha/phys/7

