From: Grant Grundler <iod00d@hp.com>
Subject: Re: convert 520 byte sector disk to 512 byte sector?
Date: Wed, 18 Jun 2003 13:19:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030618201915.GG23761@cup.hp.com>
References: <20030609174647.GB29808@cup.hp.com> <20030609122907.A16169@beaverton.ibm.com> <20030609223905.GH29808@cup.hp.com> <3EE53A34.7070503@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:42963 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S265410AbTFRUFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 16:05:15 -0400
Content-Disposition: inline
In-Reply-To: <3EE53A34.7070503@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2003 at 11:53:56AM +1000, Douglas Gilbert wrote:
> www.seagate.com have a tool called "seatool" that may
> do the trick for you.

Douglas,
I don't recall if I followed up - "st" in fact did work on ia64.
The FC drives are now 512 byte sector. The "read_capacity" call
to monitor FORMAT_UNIT progress fails even though the FORMAT_UNIT
seems to complete successfully.

I also wrote a script (attached) to identify the block size of each
"sg" device.

In the interest of writing a "generic" tool, can someone decode the
SG command below?

I'm using the 2.4 SG interface and still haven't found any decent
description how the 2.2 SG kernel interface works.

open("/dev/sg26", O_RDWR)               = 7
write(7, "\x00\x00\x00\x00\x24\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x15\x11\x00\x00\x0c\x00\x00\x00\x00\x08\x04\x2c\x1d\x80\x00\x00\x02\x00", 54) = 54
read(7, "\x24\x00\x00\x00\x24\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00", 36) = 36

(After logging the entry in stlog.txt, "st" sends a FORMAT_UNIT.)

thanks,
grant

--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=list_sg

for i in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
do echo -n "sg$i	"
scsiinfo -i /dev/sg$i | gawk '/Product/ {printf $2 "\t"}'
scsiinfo -f /dev/sg$i | gawk '/Bytes per sector/ {print $4}'
done

--n8g4imXOkfNTN/H1--
