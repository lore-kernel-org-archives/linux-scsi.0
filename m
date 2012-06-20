From: Ben Collins <benmcollins13@gmail.com>
Subject: Re: [scsi:pending 3/3] drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type
Date: Wed, 20 Jun 2012 12:52:11 -0500
Message-ID: <69598C04-83AA-4F1F-AFB5-666838371CEF@gmail.com>
References: <20120620171239.GB5512@localhost> <9F0D52A8-D4E0-40C9-8619-6802A1378C16@ubuntu.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42183 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab2FTRwP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2012 13:52:15 -0400
Received: by yhmm54 with SMTP id m54so6035782yhm.19
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jun 2012 10:52:15 -0700 (PDT)
In-Reply-To: <9F0D52A8-D4E0-40C9-8619-6802A1378C16@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wfg@linux.intel.com
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org


On Jun 20, 2012, at 12:44 PM, Ben Collins wrote:

> On Jun 20, 2012, at 12:12 PM, wfg@linux.intel.com wrote:
> 
>> Hi Ben,
>> 
>> There are new compile warnings show up in
>> 
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git pending
>> head:   e766db42f45c7685fce5c0d48ba74eaa97e6d715
>> commit: e766db42f45c7685fce5c0d48ba74eaa97e6d715 [3/3] [SCSI] aacraid: Fix endian issues in core and SRC portions of driver
>> 
>> All warnings:
>> 
>> drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
>> drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type [enabled by default]
> 
> Hrmm, pretty innocuous, but I guess it could be rewritten as:
> 
> #if BITS_PER_LONG > 32
>         src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
> #else
>         src_writel(dev, MUnit.IQ_H, 0);
> #endif

Actually, this is wrong too, since it's a dma_addr_t, not an unsigned long, so:

#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
        src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
#else
        src_writel(dev, MUnit.IQ_H, 0);
#endif



> I'm assuming the compiler can optimize line 426 to skip the masking in such a case.
> 
>> drivers/scsi/aacraid/src.c:425:
>>  422		if (address & (ALIGN32 - 1))
>>  423			return -EINVAL;
>>  424		address |= fibsize;
>>> 425		src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
>>  426		src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
>>  427	
>>  428		return 0;
>> 
>> ---
>> 0-DAY kernel build testing backend         Open Source Technology Centre
>> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
>> <0001-SCSI-aacraid-Fix-endian-issues-in-core-and-SRC-porti.patch><src.c>
> 
> --
> Bluecherry: http://www.bluecherrydvr.com/
> SwissDisk : http://www.swissdisk.com/
> Ubuntu    : http://www.ubuntu.com/
> My Blog   : http://ben-collins.blogspot.com/
> 

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

