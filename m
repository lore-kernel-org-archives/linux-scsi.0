Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26059C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6E520FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 02:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgG3CKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 22:10:46 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41145 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgG3CKq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 22:10:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D394B20418F;
        Thu, 30 Jul 2020 04:10:44 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Aig1UmfqWtPd; Thu, 30 Jul 2020 04:10:43 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id B0F3920417C;
        Thu, 30 Jul 2020 04:10:42 +0200 (CEST)
To:     Alan Stern <stern@rowland.harvard.edu>,
        SCSI development list <linux-scsi@vger.kernel.org>
Reply-To: dgilbert@interlog.com
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: UAS-3 and the removable bit (RMB)
Message-ID: <74a8caf7-710c-45f1-5b9d-3661ccc50815@interlog.com>
Date:   Wed, 29 Jul 2020 22:10:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
T10 are working on a new UAS-3 standard. It is not that ambitious
with no ability to exploit USB4 capabilities (e.g. 40 Gbps (for
a few inches)). They are setting the bar at about the USB-3
level (i.e. about 10 years old). One thing that has been discussed
recently on the T10 reflector is the RMB (removable device) bit in
the INQUIRY response of USB devices.

There is agreement of what RMB means in the case of tape systems:
it has a tape cartridge that can be removed _and_ the tape _drive_
can still respond to SCSI commands. So it can set RMB=1 .

So what about USB memory keys? Well the USB mass storage default
seems to be to set it.

                 /*
                  * Handle those devices which need us to fake
                  * their inquiry data
                  */
                 else if ((srb->cmnd[0] == INQUIRY) &&
                             (us->fflags & US_FL_FIX_INQUIRY)) {
                         unsigned char data_ptr[36] = {
                             0x00, 0x80, 0x02, 0x02,
                             0x1F, 0x00, 0x00, 0x00};

                         usb_stor_dbg(us, "Faking INQUIRY command\n");
                         fill_inquiry_response(us, data_ptr, 36);
                         srb->result = SAM_STAT_GOOD;
                 }

That is from usb_stor_control_thread() in drivers/usb/storage/usb.c .
That seems to be for the case in which the USB storage device doesn't
supply any INQUIRY response data.

Grabbing the nearest USB stick on my desk I see:

# sg_inq /dev/sg4
invalid VPD response; probably a STANDARD INQUIRY response
standard INQUIRY:
   PQual=0  Device_type=0  RMB=1  LU_CONG=0  version=0x00  [no conformance claimed]
   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=1
   SCCS=0  ACC=1  TPGS=3  3PC=0  Protect=1  [BQue=0]
   EncServ=1  MultiP=0  [MChngr=1]  [ACKREQQ=1]  Addr16=1
   [RelAdr=0]  WBus16=1  Sync=0  [Linked=1]  [TranDis=0]  CmdQue=0
     length=36 (0x24)   Peripheral device type: disk
  Vendor identification: Lexar
  Product identification: JD FireFly
  Product revision level: 1100


There was a T10 proposal today (20-082r0) saying that if a device
server in the target (i.e. logic in the USB storage device) can't
answer a TEST UNIT READY (TUR) appropriately when the "medium" is
absent then that device should _not_ be setting the RMB bit.

If that gets approved, what are the ramifications in changing USB
mass storage, UAS(-1) and UAS-3 code be to RMB=0 for most of its
cases? A USB SD card reader might validly set RMB=1 as it
could (should) respond with NOT READY, MEDIUM NOT PRESENT to TUR
when there is no SD card in the addressed slot.

Thoughts?

Doug Gilbert


BTW A recent approved addition to SPC-6 is to allow a device (disk)
that responds to a TUR with NOT READY, "in process of becoming ready",
to place an estimate (in milliseconds) in the INFO field of how
long before it will first respond to a TUR with GOOD status.

