Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251D4133286
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708010320; cv=none; b=EifIM8A1od0VAbKXUvJipHHR/W5K1Oo5SxFHOUEkWJZ0M2D98kI/tentsiH51wC+nuclYfm/m9kKJ89SJ73GHqbyeTZ+7o7DhiIbJFK4dwd24cGubbYg+RPAFR9xA8D9h40FYBuqNL6qavWkQSXC4kLb+fh6syqy/dMqnWxyDww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708010320; c=relaxed/simple;
	bh=19ctJ6tpw9FTjJaUlOrYShKM2wHyAali4GAIClMZQuA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrBZhjEv37jfR5HdMlLpAtBNoFcTIP1glmQy4u8TgfnuxgYrPmkY2j6W4rAPAiIz8YEBpJwMvqDY87iNad5yDF+HlbnNO8pvr1Qy9jxdCKhlnnqHBUk/zFg8/PAGIo5Fxl1zE2AjmGtmw4VBE5LUJmPwRVY5DiOEhlsyopljyYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 9935272C8F5;
	Thu, 15 Feb 2024 18:18:29 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 9564136D016B;
	Thu, 15 Feb 2024 18:18:29 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id 671F7360AE29; Thu, 15 Feb 2024 18:18:29 +0300 (MSK)
Date: Thu, 15 Feb 2024 18:18:29 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
Message-ID: <64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm>
References: <20240210011831.47f55oe67utq2yr7@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240210011831.47f55oe67utq2yr7@altlinux.org>

Hi,

On Sat, Feb 10, 2024 at 04:18:31AM +0300, Vitaly Chikunov wrote:
> 
> We started to get timeouts and controller resets since 5.19.5 (vanilla
> v5.19 is not tested, tests below are on 6.6.15) when several ioctl
> FALLOC_FL_ZERO_RANGE are issued into device consequentially without
> delay between them (3-5 is enough to trigger condition). Because of
> this, for example, mkfs.ext4 extremely slows down when initializing
> filesystem. This happens on aarch64 (Kunpeng-920) server.

I am reported that bisect found this commit to cause above mentioned
problem:

  commit c92a6b5d63359dd6d2ce6ea88ecd8e31dd769f6b
  Author:     Martin K. Petersen <martin.petersen@oracle.com>
  AuthorDate: Wed Mar 2 00:35:47 2022 -0500

      scsi: core: Query VPD size before getting full page

When from v5.19 this commit is reverted the problem disappears.

Thanks,

> 
> Reproducer:
> 
>   # for ((i=0;i<5;i++)); do echo $i; fallocate -z -l 2097152 /dev/sdc; done
> 
> Example of dmesg messages after problematic ioctl calls:
> 
>   Feb 06 19:44:07 host-226 kernel: sd 0:2:4:0: [sdc] tag#4752 Abort request is for SMID: 4753
>   Feb 06 19:44:07 host-226 kernel: sd 0:2:4:0: attempting task abort! scmd(0x00000000d51beacc) tm_dev_handle 0x4
>   Feb 06 19:44:07 host-226 kernel: megaraid_sas 0000:01:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
>   Feb 06 19:44:07 host-226 kernel: megaraid_sas 0000:01:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
>   Feb 06 19:44:07 host-226 kernel: sd 0:2:4:0: [sdc] tag#4752 task abort FAILED!! scmd(0x00000000d51beacc)
>   Feb 06 19:44:07 host-226 kernel: sd 0:2:4:0: [sdc] tag#4752 CDB: Write(10) 2a 00 00 00 00 00 00 00 08 00
>   Feb 06 19:45:04 host-226 kernel: sd 0:2:4:0: [sdc] tag#8292 Abort request is for SMID: 8293
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: attempting task abort! scmd(0x00000000d9406c9c) tm_dev_handle 0x4
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: [sdc] tag#4752 BRCM Debug mfi stat 0x2d, data len requested/completed 0x1000/0x0
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: [sdc] tag#8292 task abort SUCCESS!! scmd(0x00000000d9406c9c)
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: [sdc] tag#8292 CDB: Write Same(10) 41 00 03 4c 00 10 00 10 00 00
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: attempting target reset! scmd(0x00000000d51beacc) tm_dev_handle: 0x4
>   Feb 06 19:45:06 host-226 kernel: megaraid_sas 0000:01:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
>   Feb 06 19:45:06 host-226 kernel: megaraid_sas 0000:01:00.0: megasas_enable_intr_fusion is called outbound_intr_mask:0x40000000
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: [sdc] tag#4752 target reset SUCCESS!!
>   Feb 06 19:45:06 host-226 kernel: sd 0:2:4:0: Power-on or device reset occurred
> 
> Excerpt from the controller events log (from storli):
> 
>   Event Description: PD 05(e0xfb/s4) Path 5e8b4700e35e2004  reset (Type 03)
>   Event Description: Drive PD 05(e0xfb/s4) link speed changed
>   Event Description: Unexpected sense: Encl PD fb Path 5e8b4700e35e201e, CDB: 3c 01 05 00 00 00 00 00 10 00, Sense: b/4b/05
>   Event Description: Unexpected sense: Encl PD fb Path 5e8b4700e35e201e, CDB: 3c 01 05 00 00 00 00 00 10 00, Sense: b/4b/05
>   Event Description: PD 05(e0xfb/s4) Path 5e8b4700e35e2004  reset (Type 03)
>   Event Description: Drive PD 05(e0xfb/s4) link speed changed
>   Event Description: Unexpected sense: PD 05(e0xfb/s4) Path 5e8b4700e35e2004, CDB: 41 00 00 00 00 00 00 10 00 00, Sense: 6/29/00
> 
> Tests was on the latest firmware (at the moment):
> 
>   Product Name = MegaRAID 9560-8i 4GB
>   Serial Number = SKC4006982
>   Firmware Package Build = 52.28.0-5305
>   Firmware Version = 5.280.02-3972
>   PSOC FW Version = 0x001A
>   PSOC Hardware Version = 0x000A
>   PSOC Part Number = 29211-260-4GB
>   NVDATA Version = 5.2800.00-0752
>   CBB Version = 28.250.04.00
>   Bios Version = 7.28.00.0_0x071C0000
>   HII Version = 07.28.04.00
>   HIIA Version = 07.28.04.00
>   Driver Name = megaraid_sas
>   Driver Version = 07.725.01.00-rc1
> 
> I tried also latest available megaraid_sas driver (07.728.04.00) which is not
> yet merged into mainline but the problems are not resolved with it.
> 
> Thanks,
> 
