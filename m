From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Getting "Wrong diagnostic page; asked for 7 got 0" error message on
 HBA's virtual SES device
Date: Mon, 13 Mar 2017 12:13:23 +0530
Message-ID: <CAK=zhgq-yhHigXp4gT26KSCtUu7_HhWgzkSR3PEKM7g4g_4KLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34957 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbdCMGnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2017 02:43:25 -0400
Received: by mail-pf0-f176.google.com with SMTP id j5so65688149pfb.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Mar 2017 23:43:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Caleb Randall <caleb.randall@broadcom.com>, wasim.qureshi@broadcom.com, Sayantan Bhattacharya <sayantan.bhattacharya@broadcom.com>

Hi,

Our LSI(Broadcom) SAS3.5 HBA device's support virtual SES device.

Whenever we load the mpt3sas driver then we are observing below error messa=
ge,

"Wrong diagnostic page; asked for 7 got 0"

Our virtual SES device doesn't support Diagnostic page 7, it supports
only below diagnostic pages,

=E2=80=A2 00h List of Supported Diagnostic Pages
=E2=80=A2 01h SES Configuration Diagnostic Page
=E2=80=A2 02h SES Enclosure Control/Enclosure Status Diagnostic Page
=E2=80=A2 0Ah SES Additional Element Status Diagnostic Page

Page Code 07 is Element Descriptor Diagnostic Page
Per SES3 spec (see table 10) this page is optional and not supported
by our internal VSES.

But 'ses' kernel module is issuing a RECEIVE_DIAGNOSTIC command for
diagnostic page 7 without checking whether target device supports this
page or not (i.e. without looking into 00h page) as shown below,

result =3D ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
        if (result)
                goto simple_populate;

As the virtual SES devices doesn't support this page 7, so it has
failed this RECEIVE_DIAGNOSTIC command with illegal request sense key
as shown below,

ses 11:0:0:0: tag#0 Send: scmd 0xffff883fee898000
ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
mpt3sas_cm1:    sas_address(0x510600b012345600), phy(16)
mpt3sas_cm1:    enclosure_logical_id(0x500605b012345600),slot(16)
mpt3sas_cm1:    enclosure level(0x0000), connector name(     )
mpt3sas_cm1:    handle(0x0011), ioc_status(success)(0x0000), smid(1)
mpt3sas_cm1:    request_len(32), underflow(0), resid(32)
mpt3sas_cm1:    tag(0), transfer_count(0), sc->result(0x00000002)
mpt3sas_cm1:    scsi_status(check condition)(0x02),
scsi_state(autosense valid )(0x01)
mpt3sas_cm1:    [sense_key,asc,ascq]: [0x05,0x26,0x00], count(18)
mpt3sas_cm1: log_info(0x31200205): originator(PL), code(0x20), sub_code(0x0=
205)
ses 11:0:0:0: tag#0 Done: SUCCESS Result: hostbyte=3DDID_TARGET_FAILURE
driverbyte=3DDRIVER_OK
ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
ses 11:0:0:0: tag#0 Sense Key : Illegal Request [current]
ses 11:0:0:0: tag#0 Add. Sense: Invalid field in parameter list
ses 11:0:0:0: tag#0 scsi host busy 1 failed 0
ses 11:0:0:0: Notifying upper driver of completion (result 8100002)
ses 11:0:0:0: tag#0 0 sectors total, 32 bytes done.
ses 11:0:0:0: Wrong diagnostic page; asked for 7 got 0

As the command is failed with illegal request sense key, so the buffer
used In function 'ses_recv_diag' will be not updated and so it will
have all zero's. so the page_code will be zero and we observe below
wrong error message even though vSES device has failed the command
with illegal request error message and it has not returned any wrong
diagnostic page.

sdev_printk(KERN_ERR, sdev,
                    "Wrong diagnostic page; asked for %d got %u\n",
                    page_code, recv_page_code);

Thanks,
Sreekanth
