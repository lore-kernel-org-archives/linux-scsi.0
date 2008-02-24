From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: scsi_execute_req return 80002 in ses_match_to_enclosure.
Date: Sat, 23 Feb 2008 23:42:38 -0800
Message-ID: <86802c440802232342y467f8843oac46ca09c0128338@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:26903 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbYBXHmj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 02:42:39 -0500
Received: by rv-out-0910.google.com with SMTP id k20so680041rvb.1
        for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:42:38 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James,

i tried some sas disks in my system with expander with SES.

seagate and fuji disk can not get the VPD 0x83. and scsi_execute_req
got 0x80002.

but hitachi disk works well.

with lsscsi all disk can get sas address correctly.

so wonder if there is some other way to get the SAS address..

YH

static void ses_match_to_enclosure(struct enclosure_device *edev,
                                   struct scsi_device *sdev)
{
        unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
        int result;
        unsigned char *desc;
        int len;
        struct efd efd = {
                .addr = 0,
        };
        unsigned char cmd[] = {
                INQUIRY,
                1,
                0x83,
                VPD_INQUIRY_SIZE >> 8,
                VPD_INQUIRY_SIZE & 0xff,
                0
        };

        if (!buf)
                return;

        scsi_test_unit_ready(sdev, SD_TIMEOUT, SD_MAX_RETRIES, NULL);

        result = scsi_execute_req(sdev,  cmd, DMA_FROM_DEVICE, buf,
                        VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES);
        if (result) {
                sdev_printk(KERN_INFO, sdev, "ses_match_to_enclosure:
inquiry VPD page 0x83 failed with %x\n", result);
                goto free;
        }
