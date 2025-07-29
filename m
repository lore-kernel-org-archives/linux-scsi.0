Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2BC26A0E7
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 07:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=85.215.255.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775442; cv=pass; b=bG2vwckhL/5lJEuMLYFjz4CvX+u8n3L04WgSnyu8X8SwXQ6oth5SeU5t9Yx9EUnl6NASQhTtVndPqNjKPxTQqnrppH71Vq56bl89UbIkxIUhE2wPO+fqIPy1Cl17ALoyIMyuIC0ePtknG4XkwzCvdHstMDiEh5UmdfMjt70SL9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775442; c=relaxed/simple;
	bh=tSuP/QghxMmufoBRv0tWteKNA+o0USdId8gMfdBz0Uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKYfATFOGDsJb237z4f78vdpHXJD7zSDyPMNljLOeXtqpOoCvR6Z1xiQFy47a3ELnOpqyjkx9/Yle8OCnJr+tTN6/RRSBm594NmfL8JPGHx9CbaaYFEZqGb0Qcf7FusOPG8h/2mT945elyB0J16O6VXWFI0B5ykISk0/GZ5Md4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de; spf=none smtp.mailfrom=garloff.de; dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b=Wjvlq3/7; dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b=ZKT0bLI3; arc=pass smtp.client-ip=85.215.255.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=garloff.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=garloff.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=garloff.de header.i=@garloff.de header.b="Wjvlq3/7";
	dkim=permerror (0-bit key) header.d=garloff.de header.i=@garloff.de header.b="ZKT0bLI3"
ARC-Seal: i=1; a=rsa-sha256; t=1753774350; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=s5M1FZFyxCsEhKFCF2pNfUkYHWn1V28GidyR5QOS3xgT6qwXc/RJ4McQ7VEmFqc+0V
    bmQ455AR4jUdo4Z1IsQh8aaER55el8aIVDip/CDbIOj1/STjaebEUpRoGi3YKO98lbpl
    ISM5jfZrmZZyce1B7Un/b3CRg7rUiKLEB9xKKgwUm1frj0NH1sPr/oWMqWz/Y5Nu6A90
    6RJ9/27Qe0tGpziRHOyKxxb1Yyo2IDOSFwgEUW1/KblIf8HYML0UTOWsQRaVlkSA8++/
    hHRr/rRSmhefBzw+jFF5PjRszLh1KXsDSeTz0JEiv6W06R1kPlkXv5vzaCMgBDk3G/ks
    1MFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1753774350;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eDdGrnqFT7izU5JS0+nvREv5vjZI14ATlu8gL/cbSD0=;
    b=FJMUhzH2NCsWqS1Y0ittoyEQwl+MM8rmbeLKfatoDsU1o3ZYG4Pu9x9x1SJKWHB0Ne
    WsLMrrXCWvDMLe/BaCHAVJJbSI/VL62KyS/Re8eoR2AMjVuKr8pwDMhMl+F3U7EK3Fyl
    EN2eLbFyK00LC+7K8BOT73TgK88nCR6SuurMXfU9xSw1UWWLOrLWfgZ1xZfCao+DrNfY
    SAK49BNf1fS0Pn6XmgMCzfGLm6TTys7junrCP9DHd/NGfvvP9O4TLUmr/aiwV2zcc6zf
    Y7sGKq9hCEPlYWoMNSw5c4yO8J/dajCd8IZLuKlQk/wK2aBhi1guH0Pytku8unaHNw6x
    8JGg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753774350;
    s=strato-dkim-0002; d=garloff.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eDdGrnqFT7izU5JS0+nvREv5vjZI14ATlu8gL/cbSD0=;
    b=Wjvlq3/7Ru3uaMyM9VLMODIcUWuLGIpGa6smHx+C2Y27lcTzCVB8E5ySDf6nFqCAtJ
    fqySF2dZpqq04DnDTElV7cLE5PirtUyn8WLvwx4sXitJAm4StMVYliw17iRwMt3MskB7
    xvqbBwiiYY9SigPqVO4ze1A0fDzV9XmJiHHZTxrzzCdsp1/lLjqs6ST5rhlFFoTzJ5Lv
    OcY0p8A6y/r9Sm/ppRuYsYYpAvT7PhMnrurRc5dVJhJCl7vCtoFALOQ1RMM1/8+E1c5G
    WMJcclbL86ROVL30uvwW7zWUwGJtSxQBmN3oQgaLMoPKNUFZaNKJHiBSBX1jj3rI4PQg
    /1dg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753774350;
    s=strato-dkim-0003; d=garloff.de;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eDdGrnqFT7izU5JS0+nvREv5vjZI14ATlu8gL/cbSD0=;
    b=ZKT0bLI3kCKxr1NdKV1HXmvfnWr9zqe2r6C/7MtkwepHnXPmVjlQauAAaUWQAuYfUU
    zqof/uouO1WJQ8MdCCAg==
X-RZG-AUTH: ":J3kWYWCveu3U88BfwGxYwcN+YZ41GOdzUdLW+J8VEEt2iJSgSWY4hojoXxE="
Received: from mail.garloff.de
    by smtp.strato.de (RZmta 52.1.2 DYNA|AUTH)
    with ESMTPSA id L60c3716T7WUgwU
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
    Tue, 29 Jul 2025 09:32:30 +0200 (CEST)
Received: from [192.168.155.137] (ap5.garloff.de [192.168.155.10])
	by mail.garloff.de (Postfix) with ESMTPSA id B69A562481;
	Tue, 29 Jul 2025 09:32:29 +0200 (CEST)
Message-ID: <ccc3be81-1c8a-4960-a340-bd424749de55@garloff.de>
Date: Tue, 29 Jul 2025 09:32:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch [0/3] Support eager_unmap for non ldpme sd devs
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <936a460e-eacd-40a8-834a-76021bf3ce8c@garloff.de>
 <yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Kurt Garloff <kurt@garloff.de>
Autocrypt: addr=kurt@garloff.de; keydata=
 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
In-Reply-To: <yq1ms8nlhtk.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Martin,

On 29.07.25 07:09, Martin K. Petersen wrote:
>> The SCSI disk driver (sd_mod) would just claim that discard is not
>> supported. It's not true. The NVMes support it as do the enclosures.
> For some definition of support at least. If they can't figure out how to
> set a single bit flag to enable the feature, then maybe their "support"
> is not entirely trustworthy. But great that it works...
>
> What are your devices actually reporting in:
>
>    # sg_readcap -l /dev/sdN
Read Capacity results:
    Protection: prot_en=0, p_type=0, p_i_exponent=0
    Logical block provisioning: lbpme=0, lbprz=0
    Last LBA=3907029167 (0xe8e088af), Number of logical blocks=3907029168
    Logical block length=512 bytes
    Logical blocks per physical block exponent=0
    Lowest aligned LBA=0
Hence:
    Device size: 2000398934016 bytes, 1907729.1 MiB, 2000.40 GB, 2.00 TB

Yes, lbpme is 0.

>    # sg_vpd -p bl /dev/sdN
Block limits VPD page (SBC):
   Write same non-zero (WSNZ): 0
   Maximum compare and write length: 0 blocks [Command not implemented]
   Optimal transfer length granularity: 1 blocks
   Maximum transfer length: 65535 blocks
   Optimal transfer length: 65535 blocks
   Maximum prefetch transfer length: 0 blocks [ignored]
   Maximum unmap LBA count: 20971520
   Maximum unmap block descriptor count: 1
   Optimal unmap granularity: 1 blocks
   Unmap granularity alignment valid: false
   Unmap granularity alignment: 0 [invalid]
   Maximum write same length: 0 blocks [not reported]
   Maximum atomic transfer length: 0 blocks [not reported]
   Atomic alignment: 0 [unaligned atomic writes permitted]
   Atomic transfer length granularity: 0 [no granularity requirement
   Maximum atomic transfer length with atomic boundary: 0 blocks [not 
reported]
   Maximum atomic boundary size: 0 blocks [can only write atomic 1 block]

Max 10GiB unmap at a time.

>    # sg_vpd -p lbpv /dev/sdN

Logical block provisioning VPD page (SBC):
   Unmap command supported (LBPU): 1
   Write same (16) with unmap bit supported (LBPWS): 0
   Write same (10) with unmap bit supported (LBPWS10): 0
   Logical block provisioning read zeros (LBPRZ): 0
   Anchored LBAs supported (ANC_SUP): 0
   Threshold exponent: 0 [threshold sets not supported]
   Descriptor present (DP): 0
   Minimum percentage: 0 [not reported]
   Provisioning type: 0 (not known or fully provisioned)
   Threshold percentage: 0 [percentages not supported]

LBPU is 1.

>> I have a few, though all have variants of RTL9210 chips.
>>
>> But sd was too conservative to let me do it.
> Why not just have a udev rule which does:
>
>    echo unmap > /sys/class/scsi_disk/H:C:T:L/provisioning_mode
>
> ?
>
> Substitute "writesame_10" or "writesame_16" depending on what is
> actually implemented.

It does the job.

Question, as you say, is whether supporting unmap (LBPU=1) is
something to be trusted when the device says that Logical Block
Provisioning Management Enable is off.

Some docs mention LBPME in context of thin provisioning, which
is not a good description of what SSDs/NVMes do.

Using sg_readcap on a PCIe attached NVMe indeed does not result
in LBPME being set either.

root@framekurt(//):~ [0]# sg_readcap -l /dev/nvme0n1
Read Capacity results:
    Protection: prot_en=0, p_type=0, p_i_exponent=0
    Logical block provisioning: lbpme=0, lbprz=0
    Last LBA=8001573551 (0x1dcee52af), Number of logical blocks=8001573552
    Logical block length=512 bytes
    Logical blocks per physical block exponent=0
    Lowest aligned LBA=0
Hence:
    Device size: 4096805658624 bytes, 3907018.3 MiB, 4096.81 GB, 4.10 TB

Actually, here's the fun parts:
- The enclosures do not seem to set the LBPME bit when doing the
   translation to SCSI's READ_CAPACITY_16 command, as far as I
   can see. The Linux nvme driver does not do it either nor does the
   NVMe SCSI translation guide[*] even mention it.
- The nvme driver just relies on the dataset management bit (which the
   SCSI translation guide 1:1 relates to LBPU from VPD 0x82 lbpv).
- Attaching the same PCIe device in a USB enclosure of course results in
   the SD driver being used who does not see LBPME being set.
- An old SATA NVMe in the same enclosure actually does report LBPME=1
   and the (unpatched) SD driver happily uses the advertised unmap.

[*] 
https://www.nvmexpress.org/wp-content/uploads/NVM-Express-SCSI-Translation-Reference-1_1-Gold.pdf

My conclusion:
- Neither the Linux nvme driver nor USB enclosure firmware nor the
   NVMe-SCSI translation guide seem to emulate the LBPME bit for
   devices with unmap/ws/ws10 support.
- SATA NVMEs do seem to set LBPME=1 and the SD driver requires it.

One could argue that the NVMe-SCSI translation is incomplete and
should be fixed, but that discussion is now many years late.
I guess that other OS drivers do not require LBPME=1, which is
why the translation guide and subsequently firmwares and even the
Linux nvme driver don't care about LBPME. The SD driver probably
should be told to not care either ...

Remaining question is whether we'd recommend users to use a set of udev 
rules to fix up or whether we have a sd_mod parameter to ignore LBPME 
(if LBPU/LBPWS/LBPWS10 are set) or even ignore it by default (and only 
provide an opt-out parameter).

Best,

-- 
Kurt Garloff <kurt@garloff.de>, Cologne

