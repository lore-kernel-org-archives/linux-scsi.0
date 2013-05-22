From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Wed, 22 May 2013 10:05:50 -0700
Message-ID: <CAN05THTKUkMWwd_aMjDWRCh1beP2WO=a1NFewJC5GqH+KvHfCA@mail.gmail.com>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
	<519CD12D.3040805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51501 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3EVRFu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 May 2013 13:05:50 -0400
Received: by mail-pa0-f54.google.com with SMTP id kx1so2002295pab.27
        for <linux-scsi@vger.kernel.org>; Wed, 22 May 2013 10:05:50 -0700 (PDT)
In-Reply-To: <519CD12D.3040805@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hi Bart,

Thanks for trying the test tool.



You have a more detailed description furhter down at the definition of
READ10. Look there instead.


Looking at sbc3r35b.pdf  5.13 for READ16 it refers to READ10 for the
bits in the CDB.

Looking at 5.11 READ10 : Table 59 RDPROTECT field we have all non-zero
codes footnoted with b) that says :

   If the logical unit does not support protection information, then
the device server should terminate the
   command with CHECK CONDITION status with the sense key set to
ILLEGAL REQUEST and the
   additional sense code set to INVALID FIELD IN CDB.

which covers the case where the device does not support PI.

In that table we also have that when "Logical unit formatted with
protection information" is set to No for all non-zero RDPROTECT values
footnoted by a) which says

  If a logical unit supports protection information (see 4.22) butand
has not been formatted with
  protection information, then the device server shall terminate a
command specifying a verify medium
  operation to the logical unit with CHECK CONDITION status with the
sense key set to ILLEGAL
  REQUEST and the additional sense code set to INVALID FIELD IN CDB.

which covers the cases where the devices does support protection
information  but the device is not formatted with it.



So I think these two together mean that the only time a device may not
fail a request with non-zero RDPROTECT field is for the case where
1, the device does support PI
2, the medium is formatted with type!=0 protection




The READ16 RDPROTECT checks are conditional on :
   if (!inq->protect || (rc16 != NULL && !rc16->prot_en)) {

I.e. if the device said it does not support protection   or if the
device iether did not support READCAPACITY16  or if RC16 said that the
medium is not formatted with protection information.


(The check also means that if a device does not support the
READCAPACITY16 opcode then I assume that
it can not use PI either, or that the protection type == 0.  I think
that is a reasonable extra condition outside of what SBC3 technically
requires)


regards
ronnie sahlberg

On Wed, May 22, 2013 at 7:07 AM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> On 04/28/13 18:19, ronnie sahlberg wrote:
>>
>> Hi List,
>>
>> Interested in SCSI tests?
>>
>> I have a reasonable SCSI (mainly SBC) testsuite at
>> https://github.com/sahlberg/libiscsi
>> while I am mainly interested in testing of iSCSI targets, most of my
>> tests so far are for the SCSI protocol
>> so they work quite well on devices connected to any kind of transport,
>> as long as you re-export them via iSCSI.
>> (For example using a simple passthrough device with TGT.)
>> At some stage I will redo some of the framework so that it can
>> optionally talk directly to a /dev/sg* device, but reexporting via TGT
>> works well enough for now.
>
>
> Hello Ronnie,
>
> Thanks for making this software publicly available. I have a question about
> one particular test though. In the output of the test suite I found the
> following: <quote>Test READ16 with non-zero RDPROTECT. Device does not
> support/use protection information. All commands should fail.</quote>
>
> However, in SBC-3 I found the following: <quote>If type 0 protection is
> enabled and the RDPROTECT field, the WRPROTECT field, the VRPROTECT field,
> or the ORPROTECT field is set to a non-zero value, then medium access
> commands are invalid and may be terminated by the device server with CHECK
> CONDITION status with the sense key set to ILLEGAL REQUEST
> and the additional sense code set to INVALID FIELD IN CDB.</quote>
>
> Apparently your test suite considers not failing READ16 with non-zero
> RDPROTECT field as an error. However, if I interpret the above paragraph
> from SBC-3 correctly that behavior seems compliant to me ?
>
> Bart.
>
