Received: from s113.resellerdesktop.de (s113.resellerdesktop.de [83.246.80.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C981CC8BA
	for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 12:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.246.80.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732020781; cv=none; b=MgX4T0RP/XBjqx6omfbkt05A3QJztgag8+/HceKxsKlLWw3E+RjxNmk5QTF/gPM/W7ho4pu811nal9dUf0HMk/y1qXBRNv6BnpsQLZniRO34+1vcWijpOGAKCrH6rRSV2k25PQ8GZowBf2yld1KtHJM5QeD6YHICFP9ppJ8oWKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732020781; c=relaxed/simple;
	bh=usUDcpK7zLKpHzPAo+aWYJGpHgCb+w0qdSeidBJGEt0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=BG75HVU4UiG+tujm2aQZ3RXg9rqUD8kuPCtOz2Micle8GqkTlQNuNTUMOWZm1hyUTfW8tRw6Kfou711rC9h06L8v9iec1vQc7gdZQMxc68tO4CEsQpCk5m0S2dI2bU1/r4b4M8kGNkwDcC4jqlaw1JkdzqMck+S/0LR3rvfsPq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de; spf=pass smtp.mailfrom=cloud-foo.de; dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b=SjXReX8L; arc=none smtp.client-ip=83.246.80.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud-foo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud-foo.de header.i=@cloud-foo.de header.b="SjXReX8L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cloud-foo.de; s=dkim; h=Content-Transfer-Encoding:Content-Type:To:Subject:
	From:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UuHUBepFGRwpoU+EjS89JS76iCtmVwMeeQcbzMSpXsA=; b=SjXReX8L/e9BUCXEfpmvs16tm9
	xY+W9AytNealqVq+Wktz6exKsZAh05xFXc57Dj+xTVZUnouqXBaS8eETpMlfvJyAaW/uuoBTloYr7
	F5nJdfhiaXQq/e/jfrxNXFc0HWTv09x2Wugn/4+pUa9UJbBWPrnrWTjbmKW07YqpWt4o=;
Received: from i577b018a.versanet.de ([87.123.1.138] helo=[192.168.0.34])
	by s113.resellerdesktop.de with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98)
	(envelope-from <fedoradev@cloud-foo.de>)
	id 1tDNiv-0000000Cveq-1ORA
	for linux-scsi@vger.kernel.org;
	Tue, 19 Nov 2024 13:52:53 +0100
Message-ID: <3a274d9a-8ff9-4cc8-8f4f-fd4cf98c3a14@cloud-foo.de>
Date: Tue, 19 Nov 2024 13:52:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Marius Schwarz <fedoradev@cloud-foo.de>
Subject: scsi bus disconnect on high load in qemu kvm anno 2024
To: linux-scsi@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score:  ()
X-Spam-Report: 

Hi,

a bug in the scsi subsystem has been discovered in conjunction with 
Fedora 40, that can&will destroy data:

https://bugzilla.redhat.com/show_bug.cgi?id=2326393

Every  available information has been added to that ticket, here a short 
summery:

Host OS: Proxmox / Debian
Guest-OS: Fedora 40
When: right after upgrade to Fedora 40 from 39.
Type: QEMU
Storage IO Cap: 7 GB/s read ( GigaByte, not Gb/s ;) )

Issue:  High Performance SCSI Bus crash in SCSI Subsystem,

BUT: it's not only the kernel, the trigger MUST be a difference in the 
distribution between F39 and F40,

BECAUSE: after the upgrade to F40, the F39 kernel, which worked for 6 
months, had the same issues.

The FIX was, to switch the VM to use SATA connections to the drives.(dd 
copy of entire disks required)

...[REPEATING over and over again]...
Nov14 23:49] sd 2:0:0:0: [sda] tag#76 ABORT operation started
[  +4,898867] sd 2:0:0:0: ABORT operation timed-out.
[  +0,000008] sd 2:0:1:0: [sdb] tag#383 ABORT operation started
[  +4,914194] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000014] sd 2:0:1:0: [sdb] tag#322 ABORT operation started
[  +4,916147] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000007] sd 2:0:1:0: [sdb] tag#321 ABORT operation started
[  +4,914256] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000009] sd 2:0:1:0: [sdb] tag#320 ABORT operation started
[  +4,915142] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000006] sd 2:0:1:0: [sdb] tag#323 ABORT operation started
[  +4,915177] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000007] sd 2:0:1:0: [sdb] tag#324 ABORT operation started
[  +4,915221] sd 2:0:1:0: ABORT operation timed-out.
[  +0,000007] sd 2:0:1:0: [sdb] tag#325 ABORT operation started
[Nov14 23:50] sd 2:0:1:0: ABORT operation timed-out.
[  +0,009594] scsi target2:0:0: TARGET RESET operation started
[  +4,905550] scsi target2:0:0: TARGET RESET operation timed-out.
[  +0,000005] scsi target2:0:1: TARGET RESET operation started
[ +34,407328] scsi target2:0:1: TARGET RESET operation timed-out.
[  +9,829432] sd 2:0:0:0: [sda] tag#76 ABORT operation started
[  +0,002336] sym0: SCSI BUS reset detected.
[  +0,002062] sd 2:0:0:0: ABORT operation complete.
[  +0,005062] sym0: SCSI BUS has been reset.
[  +3,193215] sd 2:0:1:0: Power-on or device reset occurred
[  +0,000057] sd 2:0:0:0: [sda] tag#76 BUS RESET operation started
[  +0,002319] sd 2:0:0:0: BUS RESET operation complete.
[  +0,000008] sym0: SCSI BUS reset detected.
[  +0,006945] sym0: SCSI BUS has been reset.
...[REPEATING over and over again]...


There is a longer list in the ticket and in the fedora dev mailinglist, including
write errors:

[  +0,000000] I/O error, dev sdb, sector 41792 op 0x1:(WRITE) flags 0xc800 phys_seg 96 prio class 2
[  +0,000001] I/O error, dev sdb, sector 41792 op 0x1:(WRITE) flags 0xc800 phys_seg 96 prio class 2
[  +0,000002] sd 2:0:1:0: [sdb] tag#395 timing out command, waited 180s

The disconnects happend as soon as the io system got under high pressure:

- Tar Backups
- database upgrades on the low level structure
- database access that generated a lot of disk io.

The drives returned after 5-10 minutes of reseting the drives.

O== Solution for VM users:

Copy data to virtual SATA controller bases harddrives and delete the old scsi ones. Solved the issue on the spot.

O== Informed

Fedora Dev ML
Fedora Kernel Team
Proxmox Forum
You



