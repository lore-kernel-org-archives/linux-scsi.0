Received: from vulcan.kevinlocke.name (vulcan.kevinlocke.name [107.191.43.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF78ECE
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jan 2024 06:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kevinlocke.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kevinlocke.name
Received: from kevinolos.kevinlocke.name (unknown [172.56.200.202])
	(Authenticated sender: kevin@kevinlocke.name)
	by vulcan.kevinlocke.name (Postfix) with ESMTPSA id 5447C40D1FC1;
	Wed, 10 Jan 2024 06:44:28 +0000 (UTC)
Received: by kevinolos.kevinlocke.name (Postfix, from userid 1000)
	id A12231300672; Tue,  9 Jan 2024 23:44:24 -0700 (MST)
Date: Tue, 9 Jan 2024 23:44:24 -0700
From: Kevin Locke <kevin@kevinlocke.name>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Message-ID: <ZZ48yBm1yOEDv3ST@kevinlocke.name>
Mail-Followup-To: Kevin Locke <kevin@kevinlocke.name>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
	Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <a6d89569-8369-4550-83da-d63afdab579d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6d89569-8369-4550-83da-d63afdab579d@kernel.org>

On Wed, 2024-01-10 at 11:18 +0900, Damien Le Moal wrote:
> On 1/9/24 02:56, Kevin Locke wrote:
>> On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
>> device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
>> the process freezes in an unterruptible sleep.  Specifically, if I run
>> 
>>     echo 1 >/sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/delete
>> 
>> The shell process hangs in the write(2) syscall.  The last dmesg
>> entries post hang are:
>> 
>>     sd 1:0:0:0: [sda] Synchronizing SCSI cache
>>     ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>>     ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>>     ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>>     ata2.00: configured for UDMA/133
> 
> It looks like the device was sleeping or was in standby state.
> If that is the case, then we may be deadlocking with the scsi revalidate done
> when waking up a drive. Can you confirm what the power state of the drive was
> when you ran this ? Do you see an issue if you first make sure that the drive is
> spun-up ?

Bingo!  I can confirm that I do not experience the issue when the
drive is in the active/idle state, nor in standby (hdparm -y).  I only
experience the issue if the drive is in the sleep (hdparm -Y) state.

Thanks for the incisive suggestion,
Kevin

P.S. The Ultrabay eject script[1] runs `hdparm -Y` before delete.
Should that be removed (or changed to standby) to avoid unnecessary
revalidation?  For both HDD and SSD?

[1]: https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices#Script_for_Ultrabay_eject
