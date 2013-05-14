From: ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: SCSI testing/USB devices are amazing
Date: Mon, 13 May 2013 19:36:59 -0700
Message-ID: <CAN05THQ3ugPcgz7obJZKc=c6uGY47KTKahcxrAG9RW=sRn4yoQ@mail.gmail.com>
References: <CAN05THR+P7nzzTe6FCmG+F8_frkL=z-PS1GvoBVn57EyDMo-dw@mail.gmail.com>
	<yq1k3n7eer4.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62323 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3ENCg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 22:36:59 -0400
Received: by mail-pd0-f176.google.com with SMTP id x10so13898pdj.21
        for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 19:36:59 -0700 (PDT)
In-Reply-To: <yq1k3n7eer4.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Hi Martin,

Thanks for your input, and for the link to your nice writeup.

On Thu, May 9, 2013 at 7:43 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Ronnie" == ronnie sahlberg <ronniesahlberg@gmail.com> writes:
>
> Ronnie> * please have a look at the tests and the test results I linked
> Ronnie>   to above. I currently have quite a few tests but am happy to
> Ronnie>   add more.
>
> Aside from issuing commands with various bits set, I'd like to see some
> more sanity checking. Mainly to see whether it responds correctly to the
> features is claims to support.

I will start to add such. I think your document will provide ideas on
what to start writing tests for.

>
> I.e. do the values reported in the Block Limits VPD look sane given what
> we know about the device in general (SCSI level, capacity, PI supported,
> discard supported, etc.)?

I have added tests for the block limits VPD as SCSI.Inquiry.InquiryBlockLimits.
It checks that the pagelength is valid. 3C if SBC3 is claimed  and 0C
if prior to SBC3.
It then validates that the UNMAP counts are sane.
Sane being that if LBPU==0 then these must be 0, and if LBPU==1 then
these must be >1, must be >than 2**LBPPBE and either 0xffffffff
or <1M. (1M is arbitrary for "crazy large" number of blocks)

The other fields I had a hard time to come up with good sanity tests
for. Any suggestions ?
Do you have examples of things that vendors get wrong here ?


>
> Right now you always expect RDPROTECT/WRPROTECT > 0 to fail, but they
> should succeed if the device is formatted with PI.

I have added a check so that the tests are skipped if the device does not
support protection information or if it supports protection
information but but it is not enabled.

I will add tests for when protection information is enabled in the
future, I will need to find time to add it to tgt first.


>
> FWIW, my slightly outdated document is here:
>
>         https://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf

Very nice document.
Section 1.3 could update though. READCAPACITY16 is only mandatory in
SBC-2 IF the device supports protection information, but optional if
it does not.
In SBC-3 it is always mandatory though. Thin provisioning and
different logical/physical block sizes were only added to this command
in SBC-3 not SBC-2.


I have thus updated my READCAPACITY16 tests so that IF SBC-3 is
claimed, or if IQN->PROTECT is set
then the device must support this opcode or the test will fail.
Otherwise, if it is not SBC-3  and if PROTECT is clear, then the test
will be skipped but not fail if the opcode is missing.


If you want to, have time and if you have specific opcodes/features
that vendors get wrong,  I am happy to add tests if you point me in
the right direction for what you want me to add tests for.

regards
ronnie sahlberg


>
> --
> Martin K. Petersen      Oracle Linux Engineering
