Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097FE2BE7B5
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753961897; cv=none; b=CbOZs2UO2aOYwBNtLf+gX8TMseWn0gMq+y3wWDkIl4jGpAvstl1Vc7gD4v6uAeAa/MGaMHxflZH8cYL0hBT/h/usib3Bm2hIfDmyyEEn8ms4zam8U1Mm+4W9eHL+ihC2/lk6V/xsCLX0nwmWg5ZBvyd0ILY6CWN83esUj/Ky0V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753961897; c=relaxed/simple;
	bh=La6ASoKbnM7gCONd6Jles0Bbr1D1puW7YQESsVGvuNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EkH3dG7jR4Q+DKW38d3nGZ/R6ILfvRGavCO+W8zsL535aBBLuymTax2j1WKVWky4R85IxlmiR0YPZIEpSasQbkdbjzTriiPRFLN28NswhUEbHpxIbrGsi3a7BTLOdCKlv6VQ6UXOFKfN09vehzCClSyyEl00M9eDgMn5wmWv9p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=gOIO+gTb; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="gOIO+gTb"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4229326f89so583212a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1753961894; x=1754566694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QfpXHN/rRfW/b/OZlccdPUXGnOVSsrqDdFA3CD40bmg=;
        b=gOIO+gTb+WAjnAA6Z3Uph6/H/LFMW1sfTly7dojpSUEXQ0ytJarGOqixfLkjZQB61z
         EL6aAFOkskMZwezzRxCB3WG8oYiVPGkWijnvJW089AW8dF4B0k8Lf7SymdrgI5O2dX8Z
         ysrPEgr8lG87hO+wBAtJbulfhRxdzJV5XFlcyYuQDGo5FG509cqCTH6fnWZicQzRoFdJ
         jwWh9dVz62MA/EU31q32Gzbjh2Ep3r2/El8OqL/Ta0fB+SleQhUkGfTc3yceJvkDOqYx
         4JwZkqH9QDc5xMpGVMpCGqeAvFsava5MD50TWFoLm3eHBiVBZKzYAG8dtGOCU5wG9MTH
         iMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753961894; x=1754566694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfpXHN/rRfW/b/OZlccdPUXGnOVSsrqDdFA3CD40bmg=;
        b=ik0odaayL+VuXbzO0kiHXj1Dks/xSzTAzMhySSGGOtgEi5W5qY6SZcRpt6HZUf8kZk
         98CArNz+P019Gz2s1dLAxgmZBvLpl/pmoYbhoU10XgywpSiQN/WRUTV0y7sFWUqZDV6B
         f8svw2iFf5wzet/AgQNIlbzLJtUtU3Bn5hfUzdvRRaumpcDavicvzVnugo5KFV/Whqal
         sv7VvTIpt91xi+PRrx7ByrZZQWsrgYucEvUTWrVx03l+KPRxaT7N2xIkey4Mgz+Kk0N+
         Vqssd+pYCK/abkypV1MYIqQhU9ruEKtxhFsEfATFTJoKT1NC+ZR50G2/P07ishk0S8cB
         utGQ==
X-Forwarded-Encrypted: i=1; AJvYcCV71zLYHapY579buopgBtIlQqcm37a6CsBK/jrJzxYxkEhJykJmfQvwD3DEezjCA9BxxTlhjm/3Vkxh@vger.kernel.org
X-Gm-Message-State: AOJu0Yzex0njst+k0H0ltNYr5LIwjSH6lDJBTHL3644WneWQBjnXxejX
	HXjPRqC/SsvNMuwWUicJ0KeLtbVj3o0r9ZC2uV6hWCRLiXYP8dJnPb6Vw4DzpThF6q0=
X-Gm-Gg: ASbGncv10rRrrzbCxDOoQQCNBGjvJhdvwAib248yUHJaQl2CK72L2YEdrQQxxn/tiED
	/iTNEqCA2usYdd5Vv1zlusUVE72i1kaT/NnB1pOQcpBVLbSgEk8e7qdjqaNfZ0/YNHDRcZIYb9N
	RvYUVAupQqDjMIlkyNw6HoerPKeFDE3++nITa4V+hF91HUBMlUdaKwV0shEoNTxqEtfdh6y9QMl
	GHm82RlZlNHBC3jWaqmcfOLTLhMiQyRfydZFZfoMrRahC81QYLOHwnP8KDpev7jKNEOpemz180R
	1Ks0DHHJKpPromNRcqeGJvFhrGQBEr8BwF19QlJIgQQiVwywcnegNrZXhG/W5/6dkSPRik+kExz
	BB/ENYVLFAYENDkgapNY0N5B/LsYNZj6xOnklCrnJhQZZ
X-Google-Smtp-Source: AGHT+IFjag3lKOQ5jbjPM5jDtQ9uzMkIfjGq19I+XWX/cE5onrXQT76qV6SFNNV75XpseJSHBmS/Ug==
X-Received: by 2002:a17:902:d486:b0:23f:f39b:eae4 with SMTP id d9443c01a7336-24200a7e75bmr28121135ad.9.1753961894094;
        Thu, 31 Jul 2025 04:38:14 -0700 (PDT)
Received: from H7GWF0W104 ([139.177.225.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8ab38b4sm15662515ad.181.2025.07.31.04.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 04:38:13 -0700 (PDT)
Date: Thu, 31 Jul 2025 19:38:06 +0800
From: Diangang Li <lidiangang@bytedance.com>
To: Friedrich Weber <f.weber@proxmox.com>
Cc: Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Mira Limbeck <m.limbeck@proxmox.com>
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
Message-ID: <20250731113806.GA93929@bytedance.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>

On Wed, Apr 30, 2025 at 02:13:53PM +0200, Friedrich Weber wrote:
> Hi,
> 
> One of our users reports that, in their setup, hotplugging new disks doesn't
> work anymore with recent kernels (details below). The issue appeared somewhere
> between kernels 6.4 and 6.5, and they bisected the change to this patch:

Hi Friedrich,

I would like to confirm the hotplugging method used here. Is it the logical operation using the following commands:

- echo 1 > /sys/block/sdX/device/delete
- echo - - - > /sys/class/scsi_host/host5/scan

or does it refer to physical hotplugging (physically removing and reinserting the drive)?

I have tested both the 3008 and 9500 HBAs using the delete and scan method, and both worked fine.

> 
>   624885209f31 (scsi: core: Detect support for command duration limits)
> 
> The issue is also reproducible on a mainline kernel 6.14.4 build from [1]. When
> hotplugging a disk under 6.14.4, the following is logged (I've redacted some
> identifiers, let me know in case I've been too overzealous with that):
> 
> Apr 28 16:41:13 pbs-disklab kernel: mpt3sas_cm0: handle(0xa) sas_address(0xREDACTED_SAS_ADDR) port_type(0x1)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Direct-Access     WDC      REDACTED_SN  C5C0 PQ: 0 ANSI: 7
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: SSP: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR), phy(2), device_name(REDACTED_DEVICE_NAME)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure logical id (REDACTED_LOGICAL_ID), slot(0) 
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: enclosure level(0x0000), connector name(     )
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: qdepth(254), tagged(1), scsi_level(8), cmd_que(1)
> Apr 28 16:41:13 pbs-disklab kernel: scsi 5:0:1:0: Power-on or device reset occurred
> Apr 28 16:41:16 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31110e05): originator(PL), code(0x11), sub_code(0x0e05)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: log_info(0x31130000): originator(PL), code(0x13), sub_code(0x0000)
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: Attached scsi generic sg1 type 0
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test Unit Ready failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(16) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Read Capacity(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Sense not available.
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] 0-byte physical blocks
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Test WP failed, assume Write Enabled
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Asking for cache data failed
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Assuming drive cache: write through
> Apr 28 16:41:18 pbs-disklab kernel:  end_device-5:1: add: handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: handle(0x000a), ioc_status(0x0022) failure at drivers/scsi/mpt3sas/mpt3sas_transport.c:225/_transport_set_identify()!
> Apr 28 16:41:18 pbs-disklab kernel: sd 5:0:1:0: [sdb] Attached SCSI disk
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: mpt3sas_transport_port_remove: removed: sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: removing handle(0x000a), sas_addr(0xREDACTED_SAS_ADDR)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure logical id(REDACTED_LOGICAL_ID), slot(0)
> Apr 28 16:41:18 pbs-disklab kernel: mpt3sas_cm0: enclosure level(0x0000), connector name(     )
> 
> and the block device isn't accessible afterwards. It does seem to be visible
> after a reboot.
> 
> lspci on this host shows:
> 
> 02:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS3008 PCI-Express Fusion-MPT SAS-3 [1000:0097] (rev 02)
> 	Subsystem: Broadcom / LSI SAS9300-8i [1000:30e0]
> 	Kernel driver in use: mpt3sas
> 	Kernel modules: mpt3sas
> 
> The HBA is placed on a PCIe 3.0 x8 slot (not bifurcated) and connected via
> SFF-8643 to a simple 2U 12xLFF SAS3 Supermicro box. The user can also reproduce
> the issue with other HBAs with e.g. the SAS3108 and SAS3816 chipsets.
> 
> The device doesn't seem to support CDL. So if I see correctly, the only
> effective change introduced by the patch are the four scsi_cdl_check_cmd (and
> thus scsi_report_opcode) calls to check for CDL support. Hence we wondered
> whether may be the cause of the issue. We ran a few tests to verify:
> 
> - disabling "REPORT SUPPORTED OPERATION CODES" by passing
>   `scsi_mod.dev_flags=WDC:REDACTED_SN:536870912` (the flag being
>   BLIST_NO_RSOC) resolves the issue (hotplug works again), but I imagine
>   disabling RSOC altogether isn't a good workaround. This test was not done
>   on a mainline kernel, but I don't think it would make a difference.
> 
> - we patched out the four calls to scsi_cdl_check_cmd and unconditionally set
>   cdl_supported to 0, see [2] for the patch (on top of 6.14.4). This resolves
>   the issue.
> 
> - I suspected that particularly the two latter scsi_cdl_check_cmd calls with a
>   nonzero service action might be problematic, so we patched them out
>   specifically but kept the other two calls without a service action, see [3]
>   for the patch (on top of 6.14.4). But with this patch, hotplug still does
>   not work.
> 
> - the RSOC commands themselves don't seem to be problematic per se. We asked
>   the user to boot a (non-mainline) kernel with the `scsi_mod.dev_flags`
>   parameter to disable RSOC as above, hotplug the disk (this succeeds), and
>   then query the four opcodes/service actions using `sg_opcodes`, and this
>   looks okay [4] (reporting that CDL is not supported).
> 
> I wonder whether these results might suggest the RSOC queries are problematic
> not in general, but at this particular point (during device initialization) in
> this particular hardware setup? If this turns out to be the case -- would it be
> feasible to suppress these RSOC queries if CDL is not enabled via sysfs?
> 
> If you have any ideas for further troubleshooting, we're happy to gather more
> data. I'll be AFK for a few weeks, but Mira (in CC) will take over in the
> meantime.
> 
> Thanks!
> 
> Friedrich
> 
> [1] https://kernel.ubuntu.com/mainline/v6.14.4/
> 
> [2]
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a77e0499b738..022b2f9706a4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -658,11 +658,7 @@ void scsi_cdl_check(struct scsi_device *sdev)
>         }
> 
>         /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
> -       cdl_supported =
> -               scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
> +       cdl_supported = 0;
>         if (cdl_supported) {
>                 /*
>                  * We have CDL support: force the use of READ16/WRITE16.
> 
> [3]
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a77e0499b738..6b0f36f5415e 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -660,9 +660,8 @@ void scsi_cdl_check(struct scsi_device *sdev)
>         /* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
>         cdl_supported =
>                 scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
> -               scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
> +               scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf);
> +       cdl_supported = 0;
>         if (cdl_supported) {
>                 /*
>                  * We have CDL support: force the use of READ16/WRITE16.
> 
> [4]
> 
> root@pbs-disklab:~# sg_opcodes -o 0x88 /dev/sdb
> 
> Opcode=0x88
> Command_name: Read(16)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 88 fe ff ff ff ff ff ff ff ff ff ff ff ff 00 00
> 
> root@pbs-disklab:~# sg_opcodes -o 0x8a /dev/sdb
> 
> Opcode=0x8a
> Command_name: Write(16)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 8a fa ff ff ff ff ff ff ff ff ff ff ff ff 00 00
> 
> root@pbs-disklab:~# sg_opcodes -o 0x7f,0x9 /dev/sdb
> 
> Opcode=0x7f  Service_action=0x0009
> Command_name: Read(32)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 7f 00 00 00 00 00 00 ff 00 09 fe 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
> root@pbs-disklab:~# sg_opcodes -o 0x7f,0xb /dev/sdb
> 
> Opcode=0x7f  Service_action=0x000b
> Command_name: Write(32)
> Command is supported [conforming to SCSI standard]
> No command duration limit mode page
> Multiple Logical Units (MLU): not reported
> Usage data: 7f 00 00 00 00 00 00 ff 00 0b fa 00 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> 
