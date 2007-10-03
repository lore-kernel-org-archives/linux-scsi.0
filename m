From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 4/5] qla2xxx: add target mode support
Date: Wed, 03 Oct 2007 12:47:26 -0700
Message-ID: <4703F1CE.3020803@qlogic.com>
References: <46FBBF8C.80409@qlogic.com>	<20070929151608P.fujita.tomonori@lab.ntt.co.jp>	<470135CC.4080101@qlogic.com> <20071003214933Y.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:57076 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbXJCTr6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 15:47:58 -0400
In-Reply-To: <20071003214933Y.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: fujita.tomonori@lab.ntt.co.jp, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, michaelc@cs.wisc.edu, hare@suse.de

FUJITA Tomonori wrote:
> On Mon, 01 Oct 2007 11:00:44 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>> atl-01:/lib/modules/2.6.23-rc3-smp-tgt/kernel/drivers/scsi/qla2xxx # tgtadm --lld fc --mode target --op show
>> Target 1: volume1
>>     System information:
>>         Driver: fc
>>         Status: running
>>     I_T nexus information:
>>     LUN information:
>>         LUN: 0
>>             Type: controller
>>             SCSI ID: deadbeaf1:0
>>             SCSI SN: beaf10
>>             Size: 0
>>             Online: No
>>             Poweron/Reset: Yes
>>             Removable media: No
>>             Backing store: No backing store
>>     ACL information:
> 
> You successfully created a new target but failed to add a new logical
> unit (#1) to it (note that lun 0 was created automatically).
Yes, I have noticed it.

>>> ./tgt/usr/tgtadm --lld fc --mode logicalunit --op new --tid 1 --lun 1 -b /var/tmp/lun1
> 
> We are try to add a regular file (/var/tmp/lun1) to the target and
> export it as a logical unit to initiators. Do you have /var/tmp/lun1?
With the creation of an empty file, it started to display the lun1.
---
atl-01:~ # tgtadm --lld fc --mode target --op show
Target 1: tgt-vol1
    System information:
        Driver: fc
        Status: running
    I_T nexus information:
        I_T nexus: f6fb6000
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: deadbeaf1:0
            SCSI SN: beaf10
            Size: 0
            Online: No
            Poweron/Reset: Yes
            Removable media: No
            Backing store: No backing store
        LUN: 1
            Type: disk
            SCSI ID: deadbeaf1:1
            SCSI SN: beaf11
            Size: 0
            Online: Yes
            Poweron/Reset: Yes
            Removable media: No
            Backing store: /var/tmp/lun1
    ACL information:
atl-01:~ #
---

However, from the initiator, still not be able to see the target - from the lsscsi, no other devices (controller/virtual-disk) than those physical devices available on the fabric.
Instead, the host with target-mode displays following messages,
---
Oct 3 11:21:13 atl-01 kernel: q2t_it_nexus_response 1191:  dff46400 0
Oct 3 11:21:13 atl-01 kernel: q2t_it_nexus_response 1191:  dff46400 0
---

If I understood correctly, the F/W on the host with target-mode should have gotten some SCSI commands from the host with initiator-mode by now.
And those commands should have been forwarded to the target driver via the interrupt handler (qla24xx_intr_handler()).

Just for my learning, could you share with me which of the F/W version (on the target-mode QLogic FC HBA) you are using?

Thank you,
Seokmann

> 
> fujita@arbre:/var/tmp$ ls -l lun1
> -rw-r--r-- 1 fujita fujita 67108864 2007-06-14 22:01 lun1

