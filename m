From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx problems
Date: Thu, 20 Sep 2007 09:01:53 -0500
Message-ID: <1190296913.3360.9.camel@localhost.localdomain>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:46328 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbXITOB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 10:01:57 -0400
In-Reply-To: <20070920130440.GE1606@loop.mdy.univie.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Boresch <stefan@mdy.univie.ac.at>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-09-20 at 15:04 +0200, Stefan Boresch wrote:
> So, if anyone is willing to take a look, here are some facts (again,
> please let me know whatever other info you need!). I have put the output of
> lspci, dmesg and cat /proc/scsi/aic79xx/0 of the system running a
> default Ubuntu dapper installation (2.6.15 based kernel) on
>  
> http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.lspci.output
> http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.dmesg.output

This gives you your answer:

> [  104.075410]  target0:0:1: Wide Transfers Fail

That's a hardware or cabling issue.

> http://www.mdy.univie.ac.at/de/people/boresch/privat/dapper.proc_aic79xx.output
> 
> respectively.
> 
> Hardware:
> 
> * Supermicro H8DAR-8 motherboard with two dual-core Opterons
> * Two Seagate Cheetahs (ST373207LC) attached to the onboard Super
>   Micro (Adaptec) AIC 7902B U320 controller
> * There is also a LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT
>   Dual Ultra320 SCSI (rev 08) controller, to which an external RAID is
>   connected. This part of the system seems to be working flawlessly!!
> 
> The problem(s):
> 
> With the kernels 2.6.x (x < 20) I have tried so far the system boots,
> but there are many warnings during the boot when loading the aic79xx
> controller and the result to me seems nowhere near the speed which the
> disks should be capable of.

Wide transfers are required by the spec for periods lower than 25ns so
the driver in all cases does the very best it can for you until you can
fix the hardware problem.

James


