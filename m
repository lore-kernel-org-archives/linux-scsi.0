From: Zwane Mwaikambo <zwane@holomorphy.com>
Subject: Re: inquiry in scsi_scan.c
Date: Sun, 5 Jan 2003 15:54:46 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0301051548150.15466-100000@montezuma.mastecende.com>
References: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <UTC200301051307.h05D7da08203.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: mdharm-kernel@one-eyed-alien.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Sun, 5 Jan 2003 Andries.Brouwer@cwi.nl wrote:

> The SCSI code has no means of knowing the actual length transferred,
> so has no choice but to believe the length byte in the reply.
> But the USB code does the transferring itself, and knows precisely
> how many bytes were transferred. If 36 bytes were transferred and
> the additional length byte is 0, indicating a length of 5, then the
> USB code can fix the response and change the additional length byte
> to 31, indicating a length of 36. That way the SCSI code knows that
> not 5 but 36 bytes are valid, and it gets actual vendor and model strings.

This looks related to something i also bumped into;

scsi scan: host 2 channel 0 id 0 lun 0 identifier too long, length 60, max
50. Device might be improperly identified.

The 'HBA' is idescsi with a memorex cdrw with an inquiry returning a
length value of 34

scsi_check_fill_deviceid:
...
	if (scsi_check_id_size(sdev, 26 + id_page[3]))

I wrote up an ugly hack to truncate the length in idescsi_transform_pc2,
but i don't know SCSI and it doesn't seem right.

> [the code I showed does the right things; will submit actual diffs
> sooner or later]

Thanks,
	Zwane
-- 
function.linuxpower.ca
