From: Madhavi Manchala <madhavi.lscsi@gmail.com>
Subject: when the eh_strategy_handler function gets invoked
Date: Thu, 2 Jul 2009 13:26:31 +0530
Message-ID: <97a757510907020056o302aa969xf6f11198d47fde43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-px0-f190.google.com ([209.85.216.190]:52616 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZGBH42 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 03:56:28 -0400
Received: by pxi28 with SMTP id 28so1367580pxi.33
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2009 00:56:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear All,

I'm developing a USB class driver for UAS device. I have modified the
storage driver code as per my custom driver requirements. As a part of
this, I have registered to the SCSI layer through following snippet in
the storage_probe function. I have seen the code in one of the SAS
driver's implementation.

/*
 * Attach transport template to SCSI layer
 * which shall be used for executing tasks and
 * task management functions.
 */
transport_template = domain_attach_transport(&transport_functions);
if (!transport_template)
       goto BadDevice;
	
struct scsi_transport_template *
domain_attach_transport(struct domain_function_template *dft)
{
       struct scsi_transport_template *stt = attach_transport();

       if (!stt)
               return stt;

       i = to_uas_internal(stt);
       i->dft = dft;
       stt->create_work_queue = 1;
       stt->eh_timed_out = uas_scsi_timed_out;
       stt->eh_strategy_handler = uas_scsi_recover_host;

       return stt;
}

I would like to know when the eh_strategy_handler
(uas_scsi_recover_host) function gets invoked.

When I canceled the read/write operation from/to host to the device or
vice-versa. Still, the function, eh_strategy_handler
(uas_scsi_recover_host), is not invoked.

Thanks and Regards,
Madhavi M
