From: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>
Subject: RES: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 19:51:39 +0000
Message-ID: <175058921e084d26ba362fa6ecd7351c@serv030.corp.eldorado.org.br>
References: <1408972618.10300.35.camel@linux-fkkt.site>
	 <Pine.LNX.4.44L0.1408251021560.1385-100000@iolanthe.rowland.org>
	 <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
 <1408994897.3629.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.eldorado.org.br ([200.148.226.10]:59918 "EHLO
	smtp1.eldorado.org.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaHYTvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 15:51:45 -0400
In-Reply-To: <1408994897.3629.5.camel@HansenPartnership.com>
Content-Language: pt-BR
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Mon, 15 Aug 2014 James Bottomley wrote:

> So how did the partition get on there at the correct size in the first place?
> Even under windows partition managers believe the disk size they get from
> the system if the disk is blank.

The HDD can be partitioned outside the enclosure, when connected directly to one SATA port on motherboard. READ_CAPACITY(16) will return properly when talking directly to the HDD.

> I assume for those of us on linux-scsi who don't have the start of this thread,
> you already tried read capacity(16) and it has this same problem?

Sorry, I forgot to include linux-scsi. On this device, READ_CAPACITY_16 fails 100% of times as unsupported command, then  READ_CAPACITY_10 has a distinct behavior depending on HDD size:

1TB and 2TB: READ_CAPACITY_10 returns correct value
3TB and 4TB: READ_CAPACITY_10 returns in a 2TB modulus

> Hm, allowing users to set desired capacity by overriding the partition size ...
> I'm sure that's not going to cause support problems ...

Well, it is causing problems anyway... from user perspective, it's a Linux  compatibility issue, as it works "fine" on Windows. I'm not an expert, but I'm wondering that if usb-storage could set capacity as "UNDETERMINED"/ Zero  (or keep using the readcapacity_10 as it as with some flag signalizing it as inaccurate), EFI partition check would be able to ignore size and look for secondary GPT where it really is.

[]'s
Alfredo
