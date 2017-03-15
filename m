From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Getting "Wrong diagnostic page; asked for 7 got 0" error
 message on HBA's virtual SES device
Date: Wed, 15 Mar 2017 07:51:15 -0700
Message-ID: <1489589475.2387.7.camel@HansenPartnership.com>
References: <CAK=zhgq-yhHigXp4gT26KSCtUu7_HhWgzkSR3PEKM7g4g_4KLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51976 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751920AbdCOOvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 10:51:19 -0400
In-Reply-To: <CAK=zhgq-yhHigXp4gT26KSCtUu7_HhWgzkSR3PEKM7g4g_4KLw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Caleb Randall <caleb.randall@broadcom.com>, wasim.qureshi@broadcom.com, Sayantan Bhattacharya <sayantan.bhattacharya@broadcom.com>

On Mon, 2017-03-13 at 12:13 +0530, Sreekanth Reddy wrote:
> Hi,
> 
> Our LSI(Broadcom) SAS3.5 HBA device's support virtual SES device.
> 
> Whenever we load the mpt3sas driver then we are observing below error
> message,
> 
> "Wrong diagnostic page; asked for 7 got 0"
> 
> Our virtual SES device doesn't support Diagnostic page 7, it supports
> only below diagnostic pages,
> 
> • 00h List of Supported Diagnostic Pages
> • 01h SES Configuration Diagnostic Page
> • 02h SES Enclosure Control/Enclosure Status Diagnostic Page
> • 0Ah SES Additional Element Status Diagnostic Page
> 
> Page Code 07 is Element Descriptor Diagnostic Page
> Per SES3 spec (see table 10) this page is optional and not supported
> by our internal VSES.
> 
> But 'ses' kernel module is issuing a RECEIVE_DIAGNOSTIC command for
> diagnostic page 7 without checking whether target device supports
> this
> page or not (i.e. without looking into 00h page) as shown below,
> 
> result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
>         if (result)
>                 goto simple_populate;
> 
> As the virtual SES devices doesn't support this page 7, so it has
> failed this RECEIVE_DIAGNOSTIC command with illegal request sense key
> as shown below,
> 
> ses 11:0:0:0: tag#0 Send: scmd 0xffff883fee898000
> ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
> ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
> mpt3sas_cm1:    sas_address(0x510600b012345600), phy(16)
> mpt3sas_cm1:    enclosure_logical_id(0x500605b012345600),slot(16)
> mpt3sas_cm1:    enclosure level(0x0000), connector name(     )
> mpt3sas_cm1:    handle(0x0011), ioc_status(success)(0x0000), smid(1)
> mpt3sas_cm1:    request_len(32), underflow(0), resid(32)
> mpt3sas_cm1:    tag(0), transfer_count(0), sc->result(0x00000002)
> mpt3sas_cm1:    scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> mpt3sas_cm1:    [sense_key,asc,ascq]: [0x05,0x26,0x00], count(18)
> mpt3sas_cm1: log_info(0x31200205): originator(PL), code(0x20),
> sub_code(0x0205)
> ses 11:0:0:0: tag#0 Done: SUCCESS Result: hostbyte=DID_TARGET_FAILURE
> driverbyte=DRIVER_OK
> ses 11:0:0:0: tag#0 CDB: Receive Diagnostic 1c 01 07 00 20 00
> ses 11:0:0:0: tag#0 Sense Key : Illegal Request [current]
> ses 11:0:0:0: tag#0 Add. Sense: Invalid field in parameter list
> ses 11:0:0:0: tag#0 scsi host busy 1 failed 0
> ses 11:0:0:0: Notifying upper driver of completion (result 8100002)
> ses 11:0:0:0: tag#0 0 sectors total, 32 bytes done.
> ses 11:0:0:0: Wrong diagnostic page; asked for 7 got 0
> 
> As the command is failed with illegal request sense key, so the
> buffer
> used In function 'ses_recv_diag' will be not updated and so it will
> have all zero's. so the page_code will be zero and we observe below
> wrong error message even though vSES device has failed the command
> with illegal request error message and it has not returned any wrong
> diagnostic page.
> 
> sdev_printk(KERN_ERR, sdev,
>                     "Wrong diagnostic page; asked for %d got %u\n",
>                     page_code, recv_page_code);

But this should all work, correct?  It was tested with an EMC array
that likewise didn't support the controller electronics page.

The odd thing about this trace is that the failure result didn't get
returned to scsi_execute_req() (is that a driver issue?) so the ses
driver actually saw a success value but then changed it to failure
anyway when the diagnostic page mismatch was detected.

Usually the illegal request is invisible unless tracing is active, and
everything supporting SES seems to be nicely standards compliant, which
is why we just ask for page 7.

James
