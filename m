Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [107.191.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6BB5380B
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2024 19:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kevinlocke.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kevinlocke.name
Received: from kevinolos.kevinlocke.name (071-015-196-093.res.spectrum.com [71.15.196.93])
	(Authenticated sender: kevin@kevinlocke.name)
	by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 2F26F40C6835;
	Mon,  8 Jan 2024 19:42:29 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
	id 391331300449; Mon,  8 Jan 2024 10:56:30 -0700 (MST)
Date: Mon, 8 Jan 2024 10:56:30 -0700
From: Kevin Locke <kevin@kevinlocke.name>
To: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
Subject: [Regression] Hang deleting ATA HDD device for undocking
Message-ID: <ZZw3Th70wUUvCiCY@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
the process freezes in an unterruptible sleep.  Specifically, if I run

    echo 1 >/sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/delete

The shell process hangs in the write(2) syscall.  The last dmesg
entries post hang are:

    sd 1:0:0:0: [sda] Synchronizing SCSI cache
    ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
    ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
    ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
    ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
    ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
    ata2.00: configured for UDMA/133
    ata2.00: retrying FLUSH 0xea Emask 0x0

On kernel versions prior to 6.5-rc1, dmesg would subsequently contain:

    sd 1:0:0:0: [sda] Stopping disk
    ata2.00: disable device

Note that the hang only occurs when deleting a hard disk drive.  It
does not occur when deleting an optical disk drive.

I bisected the regression to 8b566edbdbfb5cde31a322c57932694ff48125ed.

I know very little about the SCSI/ATA subsystems or the internals of
ATA hotswapping/undocking.  I'd appreciate any help investigating the
issue, or properly undocking.

Thanks,
Kevin

[1]: https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices
