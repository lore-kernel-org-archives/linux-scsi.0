Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DAA374749
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061008; cv=none; b=GgKSC7+DbXqh2Zy90NKFI8FCNo8WGyNs8pB2yERhtVSLviFyKBIwl6zwJ2rsZiBiwfbRhIHd6nfOGxMxEHK3O1TH34zfs0RuDxw7lAdsocORULsxOrth6Tw292WvQJXSgQBUsuFi0R60Uryssc9qt9NlgZtyqpx+kGfv3G8g7Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061008; c=relaxed/simple;
	bh=cNyOVRUloWUWcFfU/vpMgD2WuulAqECCAiWa2kvDDyY=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=QDdDnu4XKOmP4B+DdBGD0sraBDrTbKL3fpblHdLskhk6ZC/wQgzXc34hIdzVIakeBVpW93Kz/gtTlLCSCHaSdOxaqrocEVKdURLmGf6nL7hsrGtDDVgbA/Wi6co6YUkxfAQoD0x83Jons7WaqtWzor/0GsacucM0vh80giizWw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDnaXfxg; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDnaXfxg"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cb5138df1aso15897685a.3
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 15:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772061005; x=1772665805; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSnRQptJOA2CM2+AkgLJkR/PdRC6f6Bu8BHgJUZ6o7Q=;
        b=CDnaXfxgHd9kr8WvLXf8kbTiNFheGmkWXzQnJIyJi+eQqURFZiB2HPBNzHkMMZoBML
         hBg9ehrATSZGmUtn6YBTV6ZEPcjxdWPDKIyP4yonXpxCLyQR71dTrycsJmqzrEOTVHZF
         2TP+E/TNlojrNW8tlHTPDVLifjg/PZ8eNl5N9ntvR4ASzqjyfQrapN91v/ZYUVoqbsG0
         l7VCwI1JtRTxVYU6qHrZOSZSJH/kBNP3mFu9lARSLIQe/XQiPOkNjFssOx6B99wfPzQg
         CwPQ1SBPtSy6i54O8qTE2yVNWXMcl0sPYWRMODYjs5hSjZCa3z1XG9Lrz2LwKlL4fDqt
         JtUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061005; x=1772665805;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cSnRQptJOA2CM2+AkgLJkR/PdRC6f6Bu8BHgJUZ6o7Q=;
        b=JSUWU5j3yii9as76/5hPDHr9DPTcQFbUBqQMzjmUJGAvMysb5d3jgaZDui040UvSae
         7DcU+C6Ms54RkeWM9YTzrRyiidTHeL1+pdxrS0/Ia5EQJq+qEzkQAA+rT9TgUMGs7mdk
         8ijfMbWG2U+1PUc/dfyRwVyqSHhavTzZdGHgKOmGFjS76M4L6O3v2VN6ptypqEOro+tO
         Da9WFPW0npAll9EyurLDXwuq9pxPJmH9wI+N9cyghExVXbn0mO77ukJUMQ2gzsJjs+4z
         G35a+SYdGlHxtimEc8tdr4qvTx8ryeNq+IHLvP/jfAFpPHtVRAf+QIFWV8HUaGd04qhz
         NtTg==
X-Gm-Message-State: AOJu0Yxphyz4e0JplbWUMFi9UR+eVZGULiKvq8sTHBOjTUURNOMjpJK7
	/7mphhc6GtwDNtUKorwrRlWvjSrothXJO4qKcODKZLkbQEM49EHcumDYcM5ekg==
X-Gm-Gg: ATEYQzzge3BjvIH6171Ae5akXldBDa4wS300voSlAZn28d5fv72C/H3/49brUaqdHv5
	Lwsuv8/4t5m8581Nia5NAgbbi9U2BL9liDAaKAMHyRw/kgnyiKS3mpRcSvL0cTBXhdQQuG6bxpR
	j0He9dIgnGvHmyut5tcdORuae5C8EXLqZP6oJDRUEPEzTZNgLqb9AhRBd5P58h+tXtKFvoGucHQ
	bi3lMy7do3CC+arlB12R+sAi+pKgL4CD0i+AKCfL8L9ocbOUk851+JnwKDg2Zy2CR5bRbBwTr4U
	OviFVdReO6B2DwmSkmhFP1f8wP37+LfPFyVJR6zBcKaGe58yLknINbK5honhC6M2Y8ijafQ/f6y
	B2GNLW1qnw/ZVAQfwNaD5T2Vgwv/OLoN64MdAiNlSayz19CvNU6nDQLWs6yY4SLoFnrkz+QqwsD
	utWE6CBvzaNwou6LYhQAXShXR7Frnknk6JcriNCHuhBqGJnor/m7IObOtBvpnzXQ0D3XQ=
X-Received: by 2002:a05:620a:2905:b0:8c7:b5b:cea7 with SMTP id af79cd13be357-8cbbcf2e9c6mr334974085a.12.1772061004823;
        Wed, 25 Feb 2026 15:10:04 -0800 (PST)
Received: from ?IPV6:2601:244:417c:14a0:214:15e2:6a74:6134? ([2601:244:417c:14a0:214:15e2:6a74:6134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c73a04f1sm2621356d6.48.2026.02.25.15.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 15:10:04 -0800 (PST)
Message-ID: <e1b5a5e3-7700-4799-affa-510b4be7d120@gmail.com>
Date: Wed, 25 Feb 2026 17:10:03 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, kylek389@gmail.com
From: Kamil Kaminski <kylek389@gmail.com>
Subject: Subject: [PATCH 0/2] Fix excessive I/O errors with locked
 hardware-encrypted USB drives
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

 From 4cf844d0840836e406e6eb1b65bd512b89fcdc20 Mon Sep 17 00:00:00 2001
From: Kamil Kaminski <kylek389@gmail.com>
Date: Wed, 25 Feb 2026 15:46:02 -0600
Subject: [PATCH 0/2] Fix excessive I/O errors with locked 
hardware-encrypted USB drives

SanDisk Extreme Portable SSD and similar hardware-encrypted USB drives
cause system instability when connected while locked. This patch series
fixes the issue by:

1. Teaching the SCSI error handler to treat "Logical unit access not
    authorized" as a permanent error (not retriable)

2. Making the sd driver detect locked drives early and treat them as
    "no media", preventing partition scanning

Example of dmesg before, plugging in SanDisk Extreme Portable SSD USB
Type-C drive crashed the xHCI controller making keyboard/mice inoperable:
[ 1741.608089] usb 3-5: new SuperSpeed USB device number 2 using xhci_hcd
[ 1741.619673] usb 3-5: New USB device found, idVendor=0781, 
idProduct=55ae, bcdDevice=30.00
[ 1741.619676] usb 3-5: New USB device strings: Mfr=2, Product=3, 
SerialNumber=1
[ 1741.619677] usb 3-5: Product: Extreme 55AE
[ 1741.619678] usb 3-5: Manufacturer: SanDisk
[ 1741.619679] usb 3-5: SerialNumber: 323132333257343033393335
[ 1741.639787] usbcore: registered new interface driver usb-storage
[ 1741.647953] scsi host9: uas
[ 1741.648006] usbcore: registered new interface driver uas
[ 1742.711720] scsi 9:0:0:0: Direct-Access     SanDisk  Extreme 55AE    
  3000 PQ: 0 ANSI: 6
[ 1742.713745] scsi 9:0:0:1: CD-ROM            SanDisk  Virtual CD 55AE  
3000 PQ: 0 ANSI: 6
[ 1742.714749] scsi 9:0:0:2: Enclosure         SanDisk  SES Device      
  3000 PQ: 0 ANSI: 6
[ 1742.716604] sd 9:0:0:0: [sdh] Unit Not Ready
[ 1742.716607] sd 9:0:0:0: [sdh] Sense Key : Data Protect [current]
[ 1742.716609] sd 9:0:0:0: [sdh] Add. Sense: Logical unit access not 
authorized
[ 1742.716648] sr 9:0:0:1: [sr1] scsi3-mmc drive: 51x/51x caddy
[ 1742.747056] sr 9:0:0:1: Attached scsi CD-ROM sr1
[ 1742.757113] sd 9:0:0:0: [sdh] 3906963617 512-byte logical blocks: 
(2.00 TB/1.82 TiB)
[ 1742.757188] sd 9:0:0:0: [sdh] Write Protect is off
[ 1742.757191] sd 9:0:0:0: [sdh] Mode Sense: 37 00 10 00
[ 1742.757345] sd 9:0:0:0: [sdh] Write cache: enabled, read cache: 
enabled, supports DPO and FUA
[ 1742.781101] sd 9:0:0:0: [sdh] Preferred minimum I/O size 512 bytes
[ 1742.781103] sd 9:0:0:0: [sdh] Optimal transfer size 1048576 bytes
[ 1742.789239] sd 9:0:0:0: [sdh] Unit Not Ready
[ 1742.789242] sd 9:0:0:0: [sdh] Sense Key : Data Protect [current]
[ 1742.789244] sd 9:0:0:0: [sdh] Add. Sense: Logical unit access not 
authorized
[ 1742.882127] sd 9:0:0:0: [sdh] tag#26 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[ 1742.882133] sd 9:0:0:0: [sdh] tag#26 Sense Key : Data Protect [current]
[ 1742.882137] sd 9:0:0:0: [sdh] tag#26 Add. Sense: Logical unit access 
not authorized
[ 1742.882140] sd 9:0:0:0: [sdh] tag#26 CDB: Read(10) 28 00 00 00 00 00 
00 00 01 00
[ 1742.882142] I/O error, dev sdh, sector 0 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.882416] Buffer I/O error on dev sdh, logical block 0, async page read
[ 1742.882676] sd 9:0:0:0: [sdh] tag#27 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[ 1742.882678] sd 9:0:0:0: [sdh] tag#27 Sense Key : Data Protect [current]
[ 1742.882682] sd 9:0:0:0: [sdh] tag#27 Add. Sense: Logical unit access 
not authorized
[ 1742.882684] sd 9:0:0:0: [sdh] tag#27 CDB: Read(10) 28 00 00 00 00 01 
00 00 01 00
[ 1742.882686] I/O error, dev sdh, sector 1 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.882936] Buffer I/O error on dev sdh, logical block 1, async page read
[ 1742.883123] sd 9:0:0:0: [sdh] tag#24 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[ 1742.883125] sd 9:0:0:0: [sdh] tag#24 Sense Key : Data Protect [current]
[ 1742.883127] sd 9:0:0:0: [sdh] tag#24 Add. Sense: Logical unit access 
not authorized
[ 1742.883128] sd 9:0:0:0: [sdh] tag#24 CDB: Read(10) 28 00 00 00 00 02 
00 00 01 00
[ 1742.883128] I/O error, dev sdh, sector 2 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.883292] Buffer I/O error on dev sdh, logical block 2, async page read
[ 1742.883452] sd 9:0:0:0: [sdh] tag#28 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[ 1742.883454] sd 9:0:0:0: [sdh] tag#28 Sense Key : Data Protect [current]
[ 1742.883456] sd 9:0:0:0: [sdh] tag#28 Add. Sense: Logical unit access 
not authorized
[ 1742.883457] sd 9:0:0:0: [sdh] tag#28 CDB: Read(10) 28 00 00 00 00 03 
00 00 01 00
[ 1742.883457] I/O error, dev sdh, sector 3 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.883615] Buffer I/O error on dev sdh, logical block 3, async page read
[ 1742.883773] sd 9:0:0:0: [sdh] tag#29 FAILED Result: 
hostbyte=DID_ERROR driverbyte=DRIVER_OK cmd_age=0s
[ 1742.883774] sd 9:0:0:0: [sdh] tag#29 Sense Key : Data Protect [current]
[ 1742.883775] sd 9:0:0:0: [sdh] tag#29 Add. Sense: Logical unit access 
not authorized
[ 1742.883776] sd 9:0:0:0: [sdh] tag#29 CDB: Read(10) 28 00 00 00 00 04 
00 00 01 00
[ 1742.883777] I/O error, dev sdh, sector 4 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.884074] Buffer I/O error on dev sdh, logical block 4, async page read
[ 1742.884369] sd 9:0:0:0: [sdh] tag#3 FAILED Result: hostbyte=DID_ERROR 
driverbyte=DRIVER_OK cmd_age=0s
[ 1742.884371] sd 9:0:0:0: [sdh] tag#3 Sense Key : Data Protect [current]
[ 1742.884373] sd 9:0:0:0: [sdh] tag#3 Add. Sense: Logical unit access 
not authorized
[ 1742.884375] sd 9:0:0:0: [sdh] tag#3 CDB: Read(10) 28 00 00 00 00 05 
00 00 01 00
[ 1742.884377] I/O error, dev sdh, sector 5 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.884675] Buffer I/O error on dev sdh, logical block 5, async page read
[ 1742.884975] sd 9:0:0:0: [sdh] tag#0 FAILED Result: hostbyte=DID_ERROR 
driverbyte=DRIVER_OK cmd_age=0s
[ 1742.884977] sd 9:0:0:0: [sdh] tag#0 Sense Key : Data Protect [current]
[ 1742.884979] sd 9:0:0:0: [sdh] tag#0 Add. Sense: Logical unit access 
not authorized
[ 1742.884981] sd 9:0:0:0: [sdh] tag#0 CDB: Read(10) 28 00 00 00 00 06 
00 00 01 00
[ 1742.884982] I/O error, dev sdh, sector 6 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.885286] Buffer I/O error on dev sdh, logical block 6, async page read
[ 1742.885588] sd 9:0:0:0: [sdh] tag#1 FAILED Result: hostbyte=DID_ERROR 
driverbyte=DRIVER_OK cmd_age=0s
[ 1742.885590] sd 9:0:0:0: [sdh] tag#1 Sense Key : Data Protect [current]
[ 1742.885593] sd 9:0:0:0: [sdh] tag#1 Add. Sense: Logical unit access 
not authorized
[ 1742.885594] sd 9:0:0:0: [sdh] tag#1 CDB: Read(10) 28 00 00 00 00 07 
00 00 01 00
[ 1742.885596] I/O error, dev sdh, sector 7 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.885906] Buffer I/O error on dev sdh, logical block 7, async page read
[ 1742.932093] sd 9:0:0:0: [sdh] tag#5 FAILED Result: hostbyte=DID_ERROR 
driverbyte=DRIVER_OK cmd_age=0s
[ 1742.932097] sd 9:0:0:0: [sdh] tag#5 Sense Key : Data Protect [current]
[ 1742.932100] sd 9:0:0:0: [sdh] tag#5 Add. Sense: Logical unit access 
not authorized
[ 1742.932101] sd 9:0:0:0: [sdh] tag#5 CDB: Read(10) 28 00 00 00 00 00 
00 00 01 00
[ 1742.932103] I/O error, dev sdh, sector 0 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.932302] Buffer I/O error on dev sdh, logical block 0, async page read
[ 1742.932940] sd 9:0:0:0: [sdh] tag#6 FAILED Result: hostbyte=DID_ERROR 
driverbyte=DRIVER_OK cmd_age=0s
[ 1742.932942] sd 9:0:0:0: [sdh] tag#6 Sense Key : Data Protect [current]
[ 1742.932943] sd 9:0:0:0: [sdh] tag#6 Add. Sense: Logical unit access 
not authorized
[ 1742.932944] sd 9:0:0:0: [sdh] tag#6 CDB: Read(10) 28 00 00 00 00 01 
00 00 01 00
[ 1742.932945] I/O error, dev sdh, sector 1 op 0x0:(READ) flags 0x0 
phys_seg 1 prio class 2
[ 1742.933127] Buffer I/O error on dev sdh, logical block 1, async page read
[ 1742.933342] ldm_validate_partition_table(): Disk read failed.
[ 1743.058294]  sdh: unable to read partition table
[ 1743.058310] sd 9:0:0:0: [sdh] Attached SCSI disk
[ 1743.083060] scsi 9:0:0:2: Failed to get diagnostic page 0x1
[ 1743.083271] scsi 9:0:0:2: Failed to bind enclosure -19
[ 1743.083463] ses 9:0:0:2: Attached Enclosure device

dmesg after:
[   88.808425] usb 4-5: new SuperSpeed USB device number 3 using xhci_hcd
[   88.820098] usb 4-5: New USB device found, idVendor=0781, 
idProduct=55ae, bcdDevice=30.00
[   88.820100] usb 4-5: New USB device strings: Mfr=2, Product=3, 
SerialNumber=1
[   88.820102] usb 4-5: Product: Extreme 55AE
[   88.820103] usb 4-5: Manufacturer: SanDisk
[   88.820104] usb 4-5: SerialNumber: 323132333257343033393335
[   88.823775] scsi host9: uas
[   89.886400] scsi 9:0:0:0: Direct-Access     SanDisk  Extreme 55AE    
  3000 PQ: 0 ANSI: 6
[   89.888370] scsi 9:0:0:1: CD-ROM            SanDisk  Virtual CD 55AE  
3000 PQ: 0 ANSI: 6
[   89.889289] scsi 9:0:0:2: Enclosure         SanDisk  SES Device      
  3000 PQ: 0 ANSI: 6
[   89.890989] sd 9:0:0:0: [sdh] Device is locked (hardware encryption) 
- treating as no media to prevent I/O errors
[   89.891091] sr 9:0:0:1: [sr1] scsi3-mmc drive: 51x/51x caddy
[   89.896380] sd 9:0:0:0: [sdh] Attached SCSI disk
[   89.920388] sr 9:0:0:1: Attached scsi CD-ROM sr1
[   89.920488] ses 9:0:0:2: Attached Enclosure device
[   89.928530] ses 9:0:0:2: Failed to get diagnostic page 0x1
[   89.928714] ses 9:0:0:2: Failed to bind enclosure -19

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216696
Tested-on: SanDisk Extreme 55AE 2TB

Kamil Kaminski (2):
   scsi: core: Treat "Logical unit access not authorized" as permanent
     error
   scsi: sd: Treat locked encrypted drives as "no media"

  drivers/scsi/scsi_error.c | 18 ++++++++++++++++++
  drivers/scsi/sd.c         | 34 ++++++++++++++++++++++++++++++++++
  2 files changed, 52 insertions(+)

-- 
2.53.0


