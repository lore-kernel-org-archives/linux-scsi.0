From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v2 1/1] sd: add missing scenario for sd_config_write_same
Date: Sat, 27 Feb 2016 09:46:06 +0800
Message-ID: <CAGnHSE=3gkawOPpHWfxwZ64U8pjLLzVDr3-kWN0c_d7TJDA2WA@mail.gmail.com>
References: <56d0c09d.5a46620a.e4c6.0855@mx.google.com>
	<yq1ziunf7e3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33979 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbcB0B6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 20:58:31 -0500
Received: by mail-yw0-f194.google.com with SMTP id f6so5033272ywa.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 17:58:31 -0800 (PST)
In-Reply-To: <yq1ziunf7e3.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 27 February 2016 at 06:12, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> "A MAXIMUM WRITE SAME LENGTH field set to zero indicates that the device
> server does not report a limit on the number of logical blocks that it
> allows to be unmapped or written in a single WRITE SAME command."
>
> I.e. that parameter says nothing about whether WRITE SAME is supported
> or not.
>

Fair enough.

>
> Do you have a particular drive that is causing problems? We could quirk
> it or add additional heuristics in addition to the ATA Information VPD.
>

Nah so far the device never showed any problems. It's actually a
SATA/USB adapter with UAS support. In fact it is seemingly coherent to
the heuristics:

[tom@localhost ~]$ sudo sg_vpd /dev/sdb
Supported VPD pages VPD page:
  Supported VPD pages [sv]
  Unit serial number [sn]
  Device identification [di]
  Block limits (SBC) [bl]

[tom@localhost ~]$ sudo sg_vpd -p bl /dev/sdb
Block limits VPD page (SBC):
  Write same non-zero (WSNZ): 0
  Maximum compare and write length: 0 blocks
  Optimal transfer length granularity: 1 blocks
  Maximum transfer length: 65535 blocks
  Optimal transfer length: 65535 blocks
  Maximum prefetch length: 65535 blocks
  Maximum unmap LBA count: 0
  Maximum unmap block descriptor count: 0
  Optimal unmap granularity: 0
  Unmap granularity alignment valid: 0
  Unmap granularity alignment: 0
  Maximum write same length: 0x0 blocks
  Maximum atomic transfer length: 0
  Atomic alignment: 0
  Atomic transfer length granularity: 0
  Maximum atomic transfer length with atomic boundary: 0
  Maximum atomic boundary size: 0

Since you've mentioned it, why do we disable write same for all
devices with a ATA Information VPD?
