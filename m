From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: PROBLEM: <AACRAID SCSI RAID DRIVER> in 2.6.25.3 -- reply to your
 suggestions
Date: Wed, 14 May 2008 17:13:29 +0900
Message-ID: <482A9F29.3040805@oss.ntt.co.jp>
References: <4828E995.3080509@oss.ntt.co.jp> <2EB68762-7B3A-4E0E-A1AB-4581C6011E10@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35571 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761635AbYENINZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 May 2008 04:13:25 -0400
In-Reply-To: <2EB68762-7B3A-4E0E-A1AB-4581C6011E10@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, AACRAID <AACRAID@adaptec.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= <fernando@oss.ntt.co.jp>

Reply to your suggestions,

1. with the kernel parameters, **aacraid.expose_physicals=0, 
aacraid.dacmode=0**:
I tried both parameters, but failed.

2. about "[PATCH] Stop using num_physpages in aacraid":
I am not using this patch: I saw drivers/scsi/aacraid/aachba.c 
(kernel-2.6.25.3)

3. about other kernels
Our machine normally runs with kernel-2.6.24 and
this failure occurs only with kernel-2.6.25 and later, including 2.6.26-rc1

Sincerely,
-------------------------------------------------------------
Takuya Yoshikawa @ NTT Open Source Software Center
e-mail: yoshikawa.takuya@oss.ntt.co.jp
-------------------------------------------------------------


> Not a panic, merely a problem probing the physical devices. It may 
> seem 'forever' but that is what happens when it must issue commands to 
> every target and lun on two physical busses. You may be able to 
> mitigate this with the kernel parameter aacraid.expose_physicals=0, or 
> aacraid.dacmode=0
>
> Status 8193 (0x2003) is not a known valid response code from the 
> Firmware, it is a result of the Firmware not processing the command in 
> the first place.
>
> Could be a result of 'Subject: Re: [PATCH] Stop using num_physpages in 
> aacraid '? Could you revert that one out to see? Could you instrument 
> the return value to the new referenced function 
> dma_get_required_mask(&dev->pdev->dev) that is incorporated in that 
> patch?
>
> Sincerely -- Mark Salyzyn
