From: Ben Collins <benmcollins13@gmail.com>
Subject: Re: [scsi:pending 3/3] drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type
Date: Wed, 20 Jun 2012 14:58:43 -0500
Message-ID: <E1F9A14B-1D4A-4784-8C2C-A69B211C9368@gmail.com>
References: <20120620171239.GB5512@localhost> <9F0D52A8-D4E0-40C9-8619-6802A1378C16@ubuntu.com> <69598C04-83AA-4F1F-AFB5-666838371CEF@gmail.com> <1340215362.13180.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39699 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2FTT6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jun 2012 15:58:47 -0400
Received: by gglu4 with SMTP id u4so6023272ggl.19
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jun 2012 12:58:46 -0700 (PDT)
In-Reply-To: <1340215362.13180.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "wfg@linux.intel.com" <wfg@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Jun 20, 2012, at 1:02 PM, James Bottomley wrote:

> On Wed, 2012-06-20 at 12:52 -0500, Ben Collins wrote:
>> On Jun 20, 2012, at 12:44 PM, Ben Collins wrote:
>> 
>>> On Jun 20, 2012, at 12:12 PM, wfg@linux.intel.com wrote:
>>> 
>>>> Hi Ben,
>>>> 
>>>> There are new compile warnings show up in
>>>> 
>>>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git pending
>>>> head:   e766db42f45c7685fce5c0d48ba74eaa97e6d715
>>>> commit: e766db42f45c7685fce5c0d48ba74eaa97e6d715 [3/3] [SCSI] aacraid: Fix endian issues in core and SRC portions of driver
>>>> 
>>>> All warnings:
>>>> 
>>>> drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
>>>> drivers/scsi/aacraid/src.c:425:2: warning: right shift count >= width of type [enabled by default]
>>> 
>>> Hrmm, pretty innocuous, but I guess it could be rewritten as:
>>> 
>>> #if BITS_PER_LONG > 32
>>>        src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
>>> #else
>>>        src_writel(dev, MUnit.IQ_H, 0);
>>> #endif
>> 
>> Actually, this is wrong too, since it's a dma_addr_t, not an unsigned long, so:
>> 
>> #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>        src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
>> #else
>>        src_writel(dev, MUnit.IQ_H, 0);
>> #endif
> 
> Heh, three strikes and you're out.  To forestall this, the actual answer
> is
> 
> src_writel(dev, MUnit.IQ_H, upper_32_bits(address));

Saved by the misfortune of others it appears. Then I guess changing the next line to lower_32_bits() would be in order as well.

--
Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

