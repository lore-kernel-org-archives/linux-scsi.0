From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Using sg_ses to change cooling element rpm speed
Date: Fri, 15 Mar 2013 13:18:22 -0700
Message-ID: <5143820E.4010902@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52457 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3COUS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Mar 2013 16:18:26 -0400
Received: by mail-oa0-f52.google.com with SMTP id k14so3922361oag.11
        for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2013 13:18:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Greetings,

I'm beating my head against the desk trying to use sg_ses to change the 
cooling control element requested speed code for a fan connected to an 
LSI SAS2X36 SAS expander.

I have tried the raw->edit<-raw method and tried the 
--data/--index/--control method and neither seems to work.

Polling status for the cooling element (--index=26) gets me:

Element 26 descriptor:
         Predicted failure=0, Disabled=0, Swap=0, status: OK
         Ident=0, Hot swap=0, Fail=0, Requested on=1, Off=0
         Actual speed=4920 rpm, Fan at lowest speed

Issuing the following command doesn't change the rpm speed:
'sg_ses --page=0x2 /dev/sg1 --index=26 --control --data=70,00,00,27'

Per the SES spec that string should select "Fan at highest speed".

I have also tried taking the raw output, editing the bytes for the 
element and sending it back and it also does nothing. The sg_ses command 
succeeds but there are no intended results.

Am I using the command syntax correctly? I want to be sure before I go 
after the vendor for improper support of the SES specification.


Thanks!

--Jeff

-- 
------------------------------
Jeff Johnson
Co-Founder

Aeon Computing, Inc
High-performance computing / Lustre filesystems

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845

4170 Morena Boulevard, Suite D - San Diego, CA 92117

