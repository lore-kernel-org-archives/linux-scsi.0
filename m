From: Michal Marek <mmarek@suse.cz>
Subject: Re: aicasm: fix kbuild for separated build directories
Date: Wed, 2 Mar 2016 17:25:11 +0100
Message-ID: <56D713E7.5060703@suse.cz>
References: <1455316946.2396.65.camel@HansenPartnership.com>
 <20160217234604.GA16500@pobox.suse.cz>
 <1456935443.2406.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbcCBQZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 11:25:13 -0500
In-Reply-To: <1456935443.2406.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 2016-03-02 17:17, James Bottomley wrote:
> On Thu, 2016-02-18 at 00:46 +0100, Michal Marek wrote:
>> On Fri, Feb 12, 2016 at 02:42:26PM -0800, James Bottomley wrote:
>>> I've recently been experimenting with building in emulated 
>>> architecture containers which allow me to build natively on my 
>>> laptop a kernel for any architecture which qemu will emulate.  To 
>>> do this, I've been building into build/$(uname -m) and this caused 
>>> the aicasm stuff to fail to build (using CONFIG_AIC7XXX_BUILD_FIRMW
>>> ARE=y).  I think this patch corrects the problem, but I'm not 
>>> hugely familiar with the kbuild infrastructure so I cc'd an expert
>>> for a second opinion.
>>
>> Hi James,
>>
>> Sorry for the late reply. Letting kbuild handle the aicasm directory 
>> is a step in the right direction. However, it still failed for me and
>> instead of trying to understand how the rules work, I removed them 
>> and used the existing kbuild infrastructure. Please try the patch 
>> below on top of yours.
> 
> Sorry for the late testing.  This patch causes the build to fail again
> for me:
> 
> make[5]: *** No rule to make target
> 'drivers/scsi/aic7xxx/aicasm/aicasm_scan.lex.c', needed by
> 'drivers/scsi/aic7xxx/aicasm/aicasm_scan.lex.o'.  Stop.
> /home/jejb/git/scsi-misc/drivers/scsi/aic7xxx/Makefile:85: recipe for
> target 'drivers/scsi/aic7xxx/aicasm/aicasm' failed
> make[4]: *** [drivers/scsi/aic7xxx/aicasm/aicasm] Error 2
> /home/jejb/git/scsi-misc/scripts/Makefile.build:407: recipe for target
> 'drivers/scsi/aic7xxx' failed
> make[3]: *** [drivers/scsi/aic7xxx] Error 2
> make[3]: *** Waiting for unfinished jobs....
> /home/jejb/git/scsi-misc/scripts/Makefile.build:407: recipe for target
> 'drivers/scsi' failed
> 
> I think the problem is simply that we now have two separate options for
> building the firmware: REGENERATE_PARSERS and
>  CONFIG_AIC7XXX_BUILD_FIRMWARE and the latter needs to be eliminated. 
>  I'll see if I can work out what's missing.

Did you run the build with REGENERATE_PARSERS=1? It needs to be done
once and the _shipped files need to be added to git. I did not include
them in my patch for the sake of brevity.

Michal
