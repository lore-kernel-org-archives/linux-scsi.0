From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 12:08:42 -0400
Message-ID: <yq1hcsqa1h1.fsf@sermon.lab.mkp.net>
References: <45F48809.2060908@emc.com>
	<20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
	<45F4A268.3000405@garzik.org>
	<20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
	<45F5565E.7010104@emc.com> <45F57000.8030604@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <45F57000.8030604@torque.net> (Douglas Gilbert's message of "Mon, 12 Mar 2007 11:21:36 -0400")
Sender: linux-fsdevel-owner@vger.kernel.org
To: dougg@torque.net
Cc: ric@emc.com, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dougg@torque.net> writes:

Doug> SAT is now a standard and an agenda item for SAT-2 is to wire
Doug> ATA8-ACS's large sector size support to the additions to SBC-3
Doug> mentioned above.

Doug> I'm not sure how this stuff plays with end to end data
Doug> protection :-) 

The proposal you forwarded talks about "transformed protection
information" but doesn't go into details.  

Assuming the drive has 4KB physical blocks and receives 512 byte
logical blocks, it's easy to verify the integrity of the 512 byte
sector and then do R-M-W on the physical.  Similarly, on the way out
logical guard and ref tags could be generated after integrity of the
physical has been verified.

The only thing that really bites is that the app tag will be per
physical block and not per logical (unless the drive leaves enough
space to store 8 tags per 4KB sector).

-- 
Martin K. Petersen	Oracle Linux Engineering

