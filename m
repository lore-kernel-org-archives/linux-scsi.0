Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D309328F53F;
	Wed, 30 Jul 2025 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753871961; cv=none; b=l8Lm1rD7OsLnD7OKythpuOeT2clbvfEtUPdLcHkY20jtsI70uIqyQh+5pWelHAhMR5JMiL9JQDb64EmHdGOfe68jLqIoJndv3B/elWUa08QN/y3n/G379APJVLyiODfb4IuIiZZXP1HwtqOqg5yI2evx/BOq5gLwmz83VV3jfFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753871961; c=relaxed/simple;
	bh=rtzzsmNzU4zF0q2gmv4mrW/ufT3SCoQxzBgQbLbYheo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ifueawlzCOyqdyqiXXHfT+Ut2hU/gf1vSbq46GNM0gu23YdFAzzBNZ1zPhwpbyWe/dB+lx8A/zVG5QaBVA58eSisACLUco0jo8atJhq6j/cHr1RZ6CiVFQ7c2urWaEh6aInLXUKoVCQ+j7IaIMBDH6zsD+hndatb96asQ8r1L0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 5E0FC459F3;
	Wed, 30 Jul 2025 12:39:09 +0200 (CEST)
Message-ID: <eb3778e5-dfdb-4382-8cc6-da6459f14a46@proxmox.com>
Date: Wed, 30 Jul 2025 12:39:05 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Damien Le Moal <dlemoal@kernel.org>, Mira Limbeck
 <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
 <9e85be51-a44e-42a4-bc48-74d6375c70fd@kernel.org>
Content-Language: en-US
From: Friedrich Weber <f.weber@proxmox.com>
In-Reply-To: <9e85be51-a44e-42a4-bc48-74d6375c70fd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1753871935222

On 10/07/2025 12:32, Damien Le Moal wrote:
> On 7/10/25 5:41 PM, Friedrich Weber wrote:
>> [...]
>> But we might be able to run some tests with a Supermicro
>> AOC-S3816L-L16iT (so Broadcom SAS3816?) soon where the hotplug issue
>> apparently also happens. We'll make sure to update to the latest
>> firmware and I'll do my best to collect relevant logs. If you can think
>> of anything specific we should collect, feel free to let me know.
> 
> See above. With such old HBA, there is no FW update.

FWIW, we performed the same test with the AOC-S3816L-L16iT [1], shown in
lspci as:

85:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI Fusion-MPT 12GSAS/PCIe Secure SAS38xx [1000:00e6]
        Subsystem: Super Micro Computer Inc AOC-S3816L-L16iT (NI22) Storage Adapter [15d9:1b65]
        Kernel driver in use: mpt3sas
        Kernel modules: mpt3sas

If I understand the Broadcom website correctly, this one is not EOL? It has
Lifecycle Status "Active" [2].

Firmware is reported as:

kernel: mpt3sas_cm0: FW Package Ver(33.00.00.01)
kernel: mpt3sas_cm0: SAS 3816: FWVersion(33.00.00.00), ChipRevision(0x00)

Also here, hotplug fails with the following message:

kernel: mpt3sas_cm0: handle(0x001a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!

As in all the previous tests, the hotplugged disk is a SAS disk (as
discussed in [4]).

This time we tried to collect debug logs:

  echo 0xfffff > /sys/module/mpt3sas/parameters/logging_level

As expected, the logs are quite verbose, but I think the following is the
relevant portion. If a bigger excerpt would be helpful, please let me know.

> kernel: scsi 18:0:3:0: tag#2560 CDB: Inquiry 12 00 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2561 CDB: Inquiry 12 00 00 00 a4 00
> kernel: scsi 18:0:3:0: Direct-Access     WDC      REDACTED_SERIAL  C5C0 PQ: 0 ANSI: 7
> kernel: scsi 18:0:3:0: SSP: handle(0x001a), sas_addr(REDACTED_SAS_ADDR), phy(37), device_name(REDACTED_DEVICE_NAME)
> kernel: scsi 18:0:3:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(5) 
> kernel: scsi 18:0:3:0: enclosure level(0x0000), connector name( C0.1)
> kernel: scsi 18:0:3:0: qdepth(64), tagged(1), scsi_level(8), cmd_que(1)
> kernel: scsi 18:0:3:0: tag#2562 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: scsi 18:0:3:0: tag#2562 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001a), ioc_status(scsi data underrun)(0x0045), smid(2563)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x06,0x29,0x02], count(96)
> kernel: scsi 18:0:3:0: tag#2562 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001a), ioc_status(scsi data underrun)(0x0045), smid(2563)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x06,0x29,0x02], count(96)
> kernel: scsi 18:0:3:0: Power-on or device reset occurred
> kernel: scsi 18:0:3:0: tag#1874 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: scsi 18:0:3:0: tag#1874 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001a), ioc_status(scsi data underrun)(0x0045), smid(1875)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: scsi 18:0:3:0: tag#1874 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001a), ioc_status(scsi data underrun)(0x0045), smid(1875)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: scsi 18:0:3:0: tag#2563 CDB: Inquiry 12 01 00 00 04 00
> kernel: scsi 18:0:3:0: tag#2564 CDB: Inquiry 12 01 00 00 15 00
> kernel: scsi 18:0:3:0: tag#2565 CDB: Inquiry 12 01 00 00 04 00
> kernel: scsi 18:0:3:0: tag#2566 CDB: Inquiry 12 01 00 00 15 00
> kernel: scsi 18:0:3:0: tag#2567 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2568 CDB: Inquiry 12 01 80 00 04 00
> kernel: scsi 18:0:3:0: tag#2569 CDB: Inquiry 12 01 80 00 14 00
> kernel: scsi 18:0:3:0: tag#2570 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2571 CDB: Inquiry 12 01 83 00 04 00
> kernel: scsi 18:0:3:0: tag#2572 CDB: Inquiry 12 01 83 00 4c 00
> kernel: scsi 18:0:3:0: tag#2573 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2574 CDB: Inquiry 12 01 b0 00 04 00
> kernel: scsi 18:0:3:0: tag#2575 CDB: Inquiry 12 01 b0 00 40 00
> kernel: scsi 18:0:3:0: tag#2576 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2577 CDB: Inquiry 12 01 b1 00 04 00
> kernel: scsi 18:0:3:0: tag#2578 CDB: Inquiry 12 01 b1 00 40 00
> kernel: scsi 18:0:3:0: tag#2579 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 18:0:3:0: tag#2580 CDB: Inquiry 12 01 b2 00 04 00
> kernel: scsi 18:0:3:0: tag#2581 CDB: Inquiry 12 01 b2 00 08 00
> kernel: scsi 18:0:3:0: tag#2582 CDB: Report supported operation codes a3 0c 01 88 00 00 00 00 00 14 00 00

I think this is scsi_cdl_check's first RSOC command scsi_cdl_check_cmd(sdev,
READ_16, 0, buf)?

> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: Enable tm_busy flag for handle(0x001a)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: Disable tm_busy flag for handle(0x001a)
> kernel: scsi 18:0:3:0: tag#2582 CDB: Report supported operation codes a3 0c 01 88 00 00 00 00 00 14 00 00
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: Discovery: (stop)
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: Discovery: (start)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: Enable tm_busy flag for handle(0x001a)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: scsi 18:0:3:0: tag#2582 CDB: Report supported operation codes a3 0c 01 88 00 00 00 00 00 14 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: Disable tm_busy flag for handle(0x001a)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001a), ioc_status(scsi ioc terminated)(0x004b), smid(2583)
> kernel: mpt3sas_cm0:         request_len(20), underflow(0), resid(20)
> kernel: mpt3sas_cm0:         tag(2771), transfer_count(0), sc->result(0x000b0000)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0:         scsi_status(good)(0x00), scsi_state(state terminated no status )(0x0c)
> kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)
> kernel: scsi 18:0:3:0: tag#2582 CDB: Report supported operation codes a3 0c 01 88 00 00 00 00 00 14 00 00
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: SAS Broadcast Primitive
> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: Enable tm_busy flag for handle(0x001a)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: Device Status Change
> kernel: mpt3sas_cm0: Disable tm_busy flag for handle(0x001a)
> kernel: scsi 18:0:3:0: tag#2582 CDB: Report supported operation codes a3 0c 01 88 00 00 00 00 00 14 00 00
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: Discovery: (stop)
> kernel: mpt3sas_cm0: Discovery: (start)
> kernel: mpt3sas_cm0: SAS Topology Change List
> kernel: mpt3sas_cm0: setting delete flag: handle(0x001a), sas_addr(REDACTED_SAS_ADDR)
> kernel: mpt3sas_cm0: setting delete flag:enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: setting delete flag: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0: tr_send:handle(0x001a), (open), smid(6636), cb(23)
> kernel: mpt3sas_cm0: Discovery: (stop)
> kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
> kernel: scsi 18:0:3:0: tag#2583 CDB: Report supported operation codes a3 0c 01 8a 00 00 00 00 00 14 00 00
> kernel: mpt3sas_cm0: tr_complete:handle(0x001a), (open) smid(6636), ioc_status(0x0000), loginfo(0x00000000), completed(1)
> kernel: scsi 18:0:3:0: tag#2584 CDB: Report supported operation codes a3 0c 03 7f 00 09 00 00 00 10 00 00
> kernel: mpt3sas_cm0: sc_send:handle(0x001a), (open), smid(6652), cb(21)
> kernel: scsi 18:0:3:0: tag#2585 CDB: Report supported operation codes a3 0c 03 7f 00 0b 00 00 00 10 00 00
> kernel: mpt3sas_cm0: sc_complete:handle(0x001a), (open) smid(6652), ioc_status(0x0000), loginfo(0x00000000)
> kernel: sd 18:0:3:0: [sda] tag#1875 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: sd 18:0:3:0: Attached scsi generic sg0 type 0
> kernel: ses 18:0:1:0: tag#2586 CDB: Receive Diagnostic 1c 01 0a 03 c8 00
> kernel: ses 18:0:1:0: tag#2587 CDB: Receive Diagnostic 1c 01 07 00 20 00
> kernel: sd 18:0:3:0: [sda] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> kernel: ses 18:0:1:0: tag#2588 CDB: Receive Diagnostic 1c 01 07 04 21 00
> kernel: sd 18:0:3:0: [sda] tag#1876 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
> kernel: sd 18:0:3:0: [sda] tag#1877 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
> kernel: ses 18:0:2:0: tag#2589 CDB: Receive Diagnostic 1c 01 0a 02 00 00
> kernel: sd 18:0:3:0: [sda] tag#1878 CDB: Read capacity(16) 9e 10 00 00 00 00 00 00 00 00 00 00 00 20 00 00
> kernel: sd 18:0:3:0: [sda] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> kernel: ses 18:0:2:0: tag#2590 CDB: Receive Diagnostic 1c 01 07 00 20 00
> kernel: sd 18:0:3:0: [sda] Sense not available.
> kernel: sd 18:0:3:0: [sda] tag#1879 CDB: Read Capacity(10) 25 00 00 00 00 00 00 00 00 00
> kernel: ses 18:0:2:0: tag#2591 CDB: Receive Diagnostic 1c 01 07 02 a1 00
> kernel: sd 18:0:3:0: [sda] tag#1880 CDB: Read Capacity(10) 25 00 00 00 00 00 00 00 00 00
> kernel: sd 18:0:3:0: [sda] tag#1881 CDB: Read Capacity(10) 25 00 00 00 00 00 00 00 00 00
> kernel: sd 18:0:3:0: [sda] tag#1882 CDB: Read Capacity(10) 25 00 00 00 00 00 00 00 00 00
> kernel: sd 18:0:3:0: [sda] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> kernel: sd 18:0:3:0: [sda] Sense not available.
> kernel: sd 18:0:3:0: [sda] tag#2592 CDB: Report luns a0 00 00 00 00 00 00 00 10 00 00 00
> kernel: sd 18:0:3:0: [sda] 0 512-byte logical blocks: (0 B/0 B)
> kernel: sd 18:0:3:0: [sda] tag#2593 CDB: Report luns a0 00 00 00 00 00 00 00 10 00 00 00
> kernel: sd 18:0:3:0: [sda] 0-byte physical blocks
> kernel: sd 18:0:3:0: [sda] tag#2594 CDB: Report luns a0 00 00 00 00 00 00 00 10 00 00 00
> kernel: sd 18:0:3:0: [sda] tag#1883 CDB: Mode Sense(6) 1a 00 3f 00 04 00
> kernel: sd 18:0:3:0: [sda] tag#2595 CDB: Report luns a0 00 00 00 00 00 00 00 10 00 00 00
> kernel: sd 18:0:3:0: [sda] tag#1884 CDB: Mode Sense(6) 1a 00 00 00 04 00
> kernel: sd 18:0:3:0: [sda] tag#1885 CDB: Mode Sense(6) 1a 00 3f 00 ff 00
> kernel: sd 18:0:3:0: [sda] Test WP failed, assume Write Enabled

Compare with hotplug on a kernel with [3] applied (which disables the CDL
checks) where hotplug works:

> kernel: scsi 6:0:2:0: Direct-Access     WDC      REDACTED_SERIAL  C5C0 PQ: 0 ANSI: 7
> kernel: scsi 6:0:2:0: SSP: handle(0x001b), sas_addr(REDACTED_SAS_ADDR), phy(37), device_name(REDACTED_DEVICE_NAME)
> kernel: scsi 6:0:2:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(5) 
> kernel: scsi 6:0:2:0: enclosure level(0x0000), connector name( C0.1)
> kernel: scsi 6:0:2:0: qdepth(64), tagged(1), scsi_level(8), cmd_que(1)
> kernel: scsi 6:0:2:0: tag#194 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: scsi 6:0:2:0: tag#194 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(scsi data underrun)(0x0045), smid(195)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x06,0x29,0x01], count(96)
> kernel: scsi 6:0:2:0: tag#194 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(scsi data underrun)(0x0045), smid(195)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x06,0x29,0x01], count(96)
> kernel: scsi 6:0:2:0: Power-on or device reset occurred
> kernel: scsi 6:0:2:0: tag#3456 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: scsi 6:0:2:0: tag#3456 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(scsi data underrun)(0x0045), smid(3457)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: scsi 6:0:2:0: tag#3456 CDB: Mode Sense(6) 1a 00 19 00 40 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(scsi data underrun)(0x0045), smid(3457)
> kernel: mpt3sas_cm0:         request_len(64), underflow(0), resid(64)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: scsi 6:0:2:0: tag#3457 CDB: Inquiry 12 01 00 00 04 00
> kernel: scsi 6:0:2:0: tag#3458 CDB: Inquiry 12 01 00 00 15 00
> kernel: scsi 6:0:2:0: tag#3459 CDB: Inquiry 12 01 00 00 04 00
> kernel: scsi 6:0:2:0: tag#3460 CDB: Inquiry 12 01 00 00 15 00
> kernel: scsi 6:0:2:0: tag#3461 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 6:0:2:0: tag#3462 CDB: Inquiry 12 01 80 00 04 00
> kernel: scsi 6:0:2:0: tag#3463 CDB: Inquiry 12 01 80 00 14 00
> kernel: scsi 6:0:2:0: tag#3464 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 6:0:2:0: tag#3465 CDB: Inquiry 12 01 83 00 04 00
> kernel: scsi 6:0:2:0: tag#3466 CDB: Inquiry 12 01 83 00 4c 00
> kernel: scsi 6:0:2:0: tag#3467 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 6:0:2:0: tag#3468 CDB: Inquiry 12 01 b0 00 04 00
> kernel: scsi 6:0:2:0: tag#3469 CDB: Inquiry 12 01 b0 00 40 00
> kernel: scsi 6:0:2:0: tag#3470 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 6:0:2:0: tag#3471 CDB: Inquiry 12 01 b1 00 04 00
> kernel: scsi 6:0:2:0: tag#3472 CDB: Inquiry 12 01 b1 00 40 00
> kernel: scsi 6:0:2:0: tag#3473 CDB: Inquiry 12 01 00 00 24 00
> kernel: scsi 6:0:2:0: tag#3474 CDB: Inquiry 12 01 b2 00 04 00
> kernel: scsi 6:0:2:0: tag#3475 CDB: Inquiry 12 01 b2 00 08 00
> kernel: sd 6:0:2:0: Attached scsi generic sg2 type 0
> kernel: sd 6:0:2:0: [sda] tag#6336 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: ses 6:0:0:0: tag#3476 CDB: Receive Diagnostic 1c 01 0a 03 c8 00
> kernel: sd 6:0:2:0: [sda] tag#6336 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: ses 6:0:0:0: tag#3477 CDB: Receive Diagnostic 1c 01 07 00 20 00
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(6337)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: ses 6:0:0:0: tag#3478 CDB: Receive Diagnostic 1c 01 07 04 21 00
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: ses 6:0:1:0: tag#3479 CDB: Receive Diagnostic 1c 01 0a 02 00 00
> kernel: sd 6:0:2:0: [sda] tag#6336 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: ses 6:0:1:0: tag#3480 CDB: Receive Diagnostic 1c 01 07 00 20 00
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(6337)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: ses 6:0:1:0: tag#3481 CDB: Receive Diagnostic 1c 01 07 02 a1 00
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: sd 6:0:2:0: [sda] tag#3482 CDB: Report luns a0 00 00 00 00 00 00 00 10 00 00 00
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3904 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel:  end_device-6:0:1: add: handle(0x001b), sas_addr(REDACTED_SAS_ADDR)
> kernel: sd 6:0:2:0: [sda] tag#3904 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3905)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3904 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3905)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3905 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: sd 6:0:2:0: [sda] tag#3905 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3906)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3905 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3906)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3906 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: sd 6:0:2:0: [sda] tag#3906 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3907)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000000)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] tag#3906 CDB: Test Unit Ready 00 00 00 00 00 00
> kernel: mpt3sas_cm0:         sas_address(REDACTED_SAS_ADDR), phy(37)
> kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(5)
> kernel: mpt3sas_cm0: enclosure level(0x0000), connector name( C0.1)
> kernel: mpt3sas_cm0:         handle(0x001b), ioc_status(success)(0x0000), smid(3907)
> kernel: mpt3sas_cm0:         request_len(0), underflow(0), resid(0)
> kernel: mpt3sas_cm0:         tag(0), transfer_count(0), sc->result(0x00000002)
> kernel: mpt3sas_cm0:         scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
> kernel: mpt3sas_cm0:         [sense_key,asc,ascq]: [0x02,0x04,0x01], count(96)
> kernel: sd 6:0:2:0: [sda] Spinning up disk...

[1] https://www.supermicro.com/products/accessories/addon/AOC-S3816L-L16iT_S3808L-L8iT.php
[2] https://www.broadcom.com/products/storage/sas-sata-controllers/sas-3816
[3] https://lore.kernel.org/all/3b2a6cfe-5bf3-4818-8633-c200d8e6f122@kernel.org/
[4] https://lore.kernel.org/all/ad96bacd-5337-4ac4-8848-0310c7671f61@kernel.org/

