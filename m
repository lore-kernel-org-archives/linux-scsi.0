Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D12017729
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 04:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBJ1OglH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D1C8C433CA
	for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2023 04:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702699679;
	bh=ha+L+ht1t24VDcgTirqqDExmS/8OqUjpSbqahaKLP2g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IBJ1OglHGO3KHYX4SokjqvdB3OtvkR7CC8G2le75y+EC4q4I42xFPnNpaPgHik4mI
	 9KSGi62iifOk1WTPX5NEjuLUx5zyzymW22wiBd2g1Ntyp7gmD8jV921vqbfQHmqcKK
	 VKP9OUUXOYfonIz5UsjNw5buIzxj0i5o+4+0b6Y8trorHAI2p/iiiAO5HcxDt5ahiY
	 7bdXgzMLXSLWsROSK0zVLUReaoOJgvhs+/3D90nRttlyYHAgNgeXc5YpMNulSKXlxw
	 2IkelYfUU1C7jJpCObqHYxGGRKkuM8M8XKfk3FyV8jUjhWmyU6tp92VmlgT59P+xP1
	 Y3ROvzoBaBz5g==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
	id 1BC57C53BCD; Sat, 16 Dec 2023 04:07:59 +0000 (UTC)
From: bugzilla-daemon@kernel.org
To: linux-scsi@vger.kernel.org
Subject: [Bug 217599] Adaptec 71605z hangs with aacraid: Host adapter abort
 request after update to linux 6.4.0
Date: Sat, 16 Dec 2023 04:07:58 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: AACRAID
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: sagar.biradar@microchip.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: scsi_drivers-aacraid@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217599-11613-zAmoaiVt9I@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217599-11613@https.bugzilla.kernel.org/>
References: <bug-217599-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

https://bugzilla.kernel.org/show_bug.cgi?id=3D217599

--- Comment #47 from Sagar (sagar.biradar@microchip.com) ---
Hi Joop, Maxim et all,
I have been trying to duplicate this issue on two different machines with 2
CPUs and little luck. I was curious to know the magic ingredient that is
missing in the setup.

I have series-7 controllers on both machines, 3 drives attached to both the
controllers, with four Raid-5 arrays created on these drives.
I am running fio on all the arrays (/dev/sdb to /dev/sde).

Could you share the details of tool (or any script?) that is being run on t=
he
system when you see the issue?

I am mentioning both the configs here, for your reference, and please let me
know if something seems conspicuous to you. Also it would really help me if=
 you
give similar details other than what has already been mentioned.

Thanks
Sagar



Config-1 Details
System Information
        Manufacturer: Supermicro
        Product Name: SYS-220U-TNR
        Version: 0123456789
        Serial Number: S411795X2826083

BIOS Information
        Vendor: American Megatrends International, LLC.
        Version: 1.4
        BIOS Revision: 5.22

System Slot Information
        Designation: RSC-W2-8888G4 SLOT3 PCI-E 4.0 X8
        Type: x8 PCI Express 4 x8
        Current Usage: In Use
        Length: Short
        ID: 3
        Characteristics:
                3.3 V is provided
                PME signal is supported
        Bus Address: 0000:4b:00.0

Processor Information
        Socket Designation: CPU1
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel(R) Corporation
        ID: A6 06 06 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 106, Stepping 6
        Version: Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
        Core Count: 12
        Core Enabled: 12
        Thread Count: 24

        Socket Designation: CPU2
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel(R) Corporation
        ID: A6 06 06 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 106, Stepping 6
        Version: Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
        Core Count: 12
        Core Enabled: 12
        Thread Count: 24


Controller Details
Controller                      : ASR71605
BIOS                            : 7.6-0 (32136)
Firmware                        : 7.6-0 (32136)
Driver                          : 1.2-1 (50983)
Boot Flash                      : 2.57-0 (432)
CPLD (Load version/ Flash version)      : 8/ 8
SEEPROM (Load version/ Flash version)   : 1/ 1


uname -r
6.4.0


lscpu

Architecture:           x86_64
CPU op-mode(s): 32-bit, 64-bit
Address sizes:          46 bits physical, 57 bits virtual
Byte Order:             Little Endian
CPU(s):                 48
On-line CPU(s) list:    0-47
Vendor ID:              GenuineIntel
BIOS Vendor ID:         Intel(R) Corporation
Model name:             Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
BIOS Model name:        Intel(R) Xeon(R) Silver 4310 CPU @ 2.10GHz
CPU family:             6
Model:                  106
Thread(s) per core:     2
Core(s) per socket:     12
Socket(s):              2
Stepping:               6
NUMA node(s):           2
NUMA node0 CPU(s):      0-11,24-35
NUMA node1 CPU(s):      12-23,36-47


lspci -s 4b:00.0 -k
4b:00.0 RAID bus controller: Adaptec Series 7 6G SAS/PCIe 3 (rev 01)
        Subsystem: Adaptec Series 7 - ASR-71605 - 16 internal 6G SAS Port/P=
CIe
3.0
        Kernel driver in use: aacraid
        Kernel modules: aacraid



Config-2 Details
System Information
        Manufacturer: HPE
        Product Name: ProLiant DL380 Gen11
        Version: Not Specified
        Serial Number: CNX2070BND

BIOS Information
        Vendor: HPE
        Version: 1.40
        Release Date: 06/01/2023


CPU Information
Processor Information
        Socket Designation: Proc 1
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel(R) Corporation
        Signature: Type 0, Family 6, Model 143, Stepping 6
        Version: Intel(R) Xeon(R) Platinum 8454H
        Core Count: 32
        Core Enabled: 32
        Thread Count: 64


        Socket Designation: Proc 2
        Type: Central Processor
        Family: Xeon
        Manufacturer: Intel(R) Corporation
        ID: F6 06 08 00 FF FB EB BF
        Signature: Type 0, Family 6, Model 143, Stepping 6
        Version: Intel(R) Xeon(R) Platinum 8454H
        Core Count: 32
        Core Enabled: 32
        Thread Count: 64


Controller Information
Controller                              : ASR7805
BIOS                                    : 7.5-0 (32118)
Firmware                                : 7.5-0 (32118)
Driver                                  : 1.2-1 (50983)
Boot Flash                              : 7.5-0 (32118)
CPLD (Load version/ Flash version)      : 7/ 10
SEEPROM (Load version/ Flash version)   : 0/ 1

uname -r
6.4.0


Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         46 bits physical, 57 bits virtual
  Byte Order:            Little Endian
CPU(s):                  128
  On-line CPU(s) list:   0-127
Vendor ID:               GenuineIntel
  BIOS Vendor ID:        Intel(R) Corporation
  Model name:            Intel(R) Xeon(R) Platinum 8454H
    BIOS Model name:     Intel(R) Xeon(R) Platinum 8454H
    CPU family:          6
    Model:               143
    Thread(s) per core:  2
    Core(s) per socket:  32
    Socket(s):           2
NUMA:
  NUMA node(s):          2
  NUMA node0 CPU(s):     0-31,64-95
  NUMA node1 CPU(s):     32-63,96-127


lspci -s 23:00.0 -k
23:00.0 RAID bus controller: Adaptec Series 7 6G SAS/PCIe 3 (rev 01)
        Subsystem: Adaptec Series 7 - ASR-7805 - 8 internal 6G SAS Port/PCIe
3.0
        Kernel driver in use: aacraid
        Kernel modules: aacraid

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
