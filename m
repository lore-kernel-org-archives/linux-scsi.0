From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Thu, 19 Jun 2014 10:33:51 -0400
Message-ID: <20140619143351.GE26904@htj.dyndns.org>
References: <1403160654-31612-1-git-send-email-stripathi@apm.com>
 <20140619141047.GA26904@htj.dyndns.org>
 <CAOHikRAX1NfeCRWVJtv_FTHHheYxU5uKVk_hytdEmb_j-5_wnA@mail.gmail.com>
 <20140619142148.GD26904@htj.dyndns.org>
 <CAOHikRAaMaMc1zHU3B_Qqg8fRndCqHQTDR7wpCoaS_kafkgzdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:59678 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420AbaFSOdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 10:33:55 -0400
Content-Disposition: inline
In-Reply-To: <CAOHikRAaMaMc1zHU3B_Qqg8fRndCqHQTDR7wpCoaS_kafkgzdw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, patches@apm.com, Loc Ho <lho@apm.com>

Hello,

On Thu, Jun 19, 2014 at 07:57:33PM +0530, Suman Tripathi wrote:
> [suman] : Are you ok if I make ahci_qc_issue in the ahci.h as not static
> and make it as EXPORT_SYMBOL_GPL ? Currenty ahci_qc_issue is static.
> If you take the current case , I only had to make  ahci_sw_activity as non
> static and use it. So both the intention is same.

Yeah, sure.  We end up having to export a function anyway.  Better to
avoid duplicating the function body.

> So, it's just ATA_CMD_ID_ATA and ATA_CMD_ID_ATAPI is okay?  That's
> kinda weird.
> 
> [suman] : Not tested for ATA_CMD_ID_ATAPI. It's just for ATA_CMD_ID_ATA for
> now.

Can you give it a test?  The two commands are really similar, so it'd
be surprising if the controller only chokes on one of them.  Another
thing worthwhile testing is "libata.force=noncq,pio0" so that you can
be sure other pio commands are okay.

Thanks.

-- 
tejun
