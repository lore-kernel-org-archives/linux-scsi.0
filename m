Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 742F91BF3F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2024 10:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708078133; cv=none; b=WYaoGUD8Yl8BEnsPxMkvq22Pzeo4fWLgsyqu+RufLPxPCNYb6y+VlDXgw8bbsMHvBIyaJJZeXJR1qxAXRcmIRtrFiti0X8TgIBRceQ6Z+j0W8lFS8WTKXjB5DYoT9AfXmpxWTv77IMOADURWHftSPh9Qjrv2hQ30N3mBQR96nro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708078133; c=relaxed/simple;
	bh=+Rfwn9UC3HmIm/IJOIia+EdNSWg9lxlPMGFinlFOXU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aymMGX/3DQvuOKIPZ37CLtKbHPxNlnOy3j6xUzyGAfEePTHzhom1Ty9WM+CjDka6ZLAg7blIy3w5vT0dO9eDtHprf5F65PXc6EQUMI+68eF8l62cS2Nl0ax2AeHZXY+ehTMbtAvU1wrJuZgi08m/w6tG9jBvnFBXksXZBO4vYZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 2EB6372C981;
	Fri, 16 Feb 2024 13:08:45 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id 203F636D016B;
	Fri, 16 Feb 2024 13:08:45 +0300 (MSK)
Date: Fri, 16 Feb 2024 13:08:44 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Subject: Re: megaraid_sas: multiple FALLOC_FL_ZERO_RANGE causes timeouts and
 resets on MegaRAID 9560-8i 4GB since 5.19
Message-ID: <20240216100844.aabjlexbwq6ggzs2@altlinux.org>
References: <20240210011831.47f55oe67utq2yr7@altlinux.org>
 <64phxapjp742qob7gr74o2tnnkaic6wmxgfa3uxn33ukrwumbi@cfd6kmix3bbm>
 <yq18r3lful5.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <yq18r3lful5.fsf@ca-mkp.ca.oracle.com>

Martin,

On Thu, Feb 15, 2024 at 01:42:35PM -0500, Martin K. Petersen wrote:
> 
> I'd appreciate it if you could test the patch Bart referred you to.
> 
> > I am reported that bisect found this commit to cause above mentioned
> > problem:
> 
> Also, I would like to understand why things fail as a result of the
> original change.
> 
> Could you please send me the output of:
> 
> # sg_readcap -l /dev/sdc
> # sg_vpd -l /dev/sdc
> # sg_vpd -p 0xb0 /dev/sdc
> # sg_vpd -p 0xb1 /dev/sdc
> # sg_vpd -p 0xb2 /dev/sdc

Here it is:

  # sg_readcap -l /dev/sdc
  Read Capacity results:
     Protection: prot_en=0, p_type=0, p_i_exponent=0
     Logical block provisioning: lbpme=0, lbprz=0
     Last LBA=3907029167 (0xe8e088af), Number of logical blocks=3907029168
     Logical block length=512 bytes
     Logical blocks per physical block exponent=0
     Lowest aligned LBA=0
  Hence:
     Device size: 2000398934016 bytes, 1907729.1 MiB, 2000.40 GB, 2.00 TB

  # sg_vpd -l /dev/sdc
  Supported VPD pages VPD page:
     [PQual=0  Peripheral device type: disk]
    0x00  Supported VPD pages [sv]
    0x80  Unit serial number [sn]
    0x83  Device identification [di]
    0x87  Mode page policy [mpp]
    0x89  ATA information (SAT) [ai]
    0x8a  Power condition [pc]
    0xb0  Block limits (SBC) [bl]
    0xb1  Block device characteristics (SBC) [bdc]
    0xb2  Logical block provisioning (SBC) [lbpv]
    0xb6  Zoned block device characteristics [zbdch]

  # sg_vpd -p 0xb0 /dev/sdc
  Block limits VPD page (SBC):
    Write same non-zero (WSNZ): 1
    Maximum compare and write length: 0 blocks [Command not implemented]
    Optimal transfer length granularity: 0 blocks [not reported]
    Maximum transfer length: 0 blocks [not reported]
    Optimal transfer length: 0 blocks [not reported]
    Maximum prefetch transfer length: 0 blocks [ignored]
    Maximum unmap LBA count: 0 [Unmap command not implemented]
    Maximum unmap block descriptor count: 0 [Unmap command not implemented]
    Optimal unmap granularity: 0 blocks [not reported]
    Unmap granularity alignment valid: false
    Unmap granularity alignment: 0 [invalid]
    Maximum write same length: 0xffff blocks
    Maximum atomic transfer length: 0 blocks [not reported]
    Atomic alignment: 0 [unaligned atomic writes permitted]
    Atomic transfer length granularity: 0 [no granularity requirement
    Maximum atomic transfer length with atomic boundary: 0 blocks [not reported]
    Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

  # sg_vpd -p 0xb1 /dev/sdc
  Block device characteristics VPD page (SBC):
    Nominal rotation rate: 7200 rpm
    Product type: Not specified
    WABEREQ=0
    WACEREQ=0
    Nominal form factor: 3.5 inch
    MACT=0
    ZONED=0
    RBWZ=0
    BOCS=0
    FUAB=0
    VBULS=0
    DEPOPULATION_TIME=0 (seconds)

  # sg_vpd -p 0xb2 /dev/sdc
  Logical block provisioning VPD page (SBC):
    Unmap command supported (LBPU): 0
    Write same (16) with unmap bit supported (LBPWS): 0
    Write same (10) with unmap bit supported (LBPWS10): 0
    Logical block provisioning read zeros (LBPRZ): 0
    Anchored LBAs supported (ANC_SUP): 0
    Threshold exponent: 0 [threshold sets not supported]
    Descriptor present (DP): 0
    Minimum percentage: 0 [not reported]
    Provisioning type: 0 (not known or fully provisioned)
    Threshold percentage: 0 [percentages not supported]

About the patch it will be tested later today.

Thanks,

> 
> Thanks!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
