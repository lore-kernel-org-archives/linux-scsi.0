From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 28 Nov 2013 07:59:53 -0500
Message-ID: <yq1iovclm0m.fsf@sermon.lab.mkp.net>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
	(Justin Piszcz's message of "Mon, 25 Nov 2013 17:01:12 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: open list <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Justin> Relevant logs: [178339.353519] 3w-sas: scsi0: ERROR:
Justin> (0x03:0x0101): Invalid command opcode:opcode=0x41.
Justin> [178339.353565] sda2: WRITE SAME failed. Manually zeroing.

Justin> Is this something I should be worried about? 

No, it just means that your 3ware controller does not handle the WRITE
SAME command and we fall back to manually writing out zeroes.

I posted a patch a while back that prevents WRITE SAME being issued for
controllers that do not pass the commands through to disk directly:

	http://marc.info/?l=linux-scsi&m=138252394614920&w=2

-- 
Martin K. Petersen	Oracle Linux Engineering
