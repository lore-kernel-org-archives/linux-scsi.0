From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Wed, 22 May 2013 16:07:41 +0200
Message-ID: <519CD12D.3040805@acm.org>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47988 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3EVOHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 10:07:45 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so5214353iej.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 May 2013 07:07:45 -0700 (PDT)
In-Reply-To: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-scsi@vger.kernel.org

On 04/28/13 18:19, ronnie sahlberg wrote:
> Hi List,
>
> Interested in SCSI tests?
>
> I have a reasonable SCSI (mainly SBC) testsuite at
> https://github.com/sahlberg/libiscsi
> while I am mainly interested in testing of iSCSI targets, most of my
> tests so far are for the SCSI protocol
> so they work quite well on devices connected to any kind of transport,
> as long as you re-export them via iSCSI.
> (For example using a simple passthrough device with TGT.)
> At some stage I will redo some of the framework so that it can
> optionally talk directly to a /dev/sg* device, but reexporting via TGT
> works well enough for now.

Hello Ronnie,

Thanks for making this software publicly available. I have a question 
about one particular test though. In the output of the test suite I 
found the following: <quote>Test READ16 with non-zero RDPROTECT. Device 
does not support/use protection information. All commands should 
fail.</quote>

However, in SBC-3 I found the following: <quote>If type 0 protection is 
enabled and the RDPROTECT field, the WRPROTECT field, the VRPROTECT 
field, or the ORPROTECT field is set to a non-zero value, then medium 
access commands are invalid and may be terminated by the device server 
with CHECK CONDITION status with the sense key set to ILLEGAL REQUEST
and the additional sense code set to INVALID FIELD IN CDB.</quote>

Apparently your test suite considers not failing READ16 with non-zero 
RDPROTECT field as an error. However, if I interpret the above paragraph 
from SBC-3 correctly that behavior seems compliant to me ?

Bart.

