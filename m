From: "Penchala Narasimha Reddy Chilakala, TLS-Chennai"
	<narasimhareddyc@hcl.in>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 4 Nov 2009 12:14:40 +0530
Message-ID: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C87D8@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
References: <4AF0D7AE.200@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws08.mail.hcl.in ([203.105.186.28]:57889 "EHLO gws08.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZKDGpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 01:45:09 -0500
In-Reply-To: <4AF0D7AE.200@s5r6.in-berlin.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>, James Bottomley <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Hi Stefan,

Thanks a lot for your nice feedback. 
I hope that James will agree with Stefan's explanation.

Expression before the patch:	a > (b & c) ? d : e
Expression after the patch:	a > ((b & c) ? d : e)

The expression after the patch is transparent and right one.

Thanks,
Narasimha Reddy

-----Original Message-----
From: Stefan Richter [mailto:stefanr@s5r6.in-berlin.de] 
Sent: Wednesday, November 04, 2009 6:54 AM
To: James Bottomley
Cc: Penchala Narasimha Reddy Chilakala, TLS-Chennai; 'linux-scsi@vger.kernel.org'; ServeRAID Driver
Subject: Re: [PATCH ] scsi-misc-2.6: File System going into read-only mode

James Bottomley wrote:
> On Tue, 2009-11-03 at 15:47 +0530, Penchala Narasimha Reddy Chilakala,
> TLS-Chennai wrote:
>> This is all spurious bracket addition; it doesn't really have any place
>> in a code fix.
>>
>> <Narasimha Reddy>: As we know that if we do not keep bracket
>> appropriately, some times compilers will behave differently and it may
>> use different instructions and evaluate differently. So to avoid those
>> kinds of issues, we added those brackets. It is not a code fix, but it
>> is compiler fix (compilers should not interpret differently). If
>> compiler interprets differently then the logic may behave differently
>> as against to your intentional behavior.  I hope you agree with me.
> 
> Not really ... in principle we try to fix the compilers rather than work
> around their bugs.  Which compilers are exhibiting the problem? ...
> because they'll affect more than just aacraid.

Huh?

Expression before the patch:	a > (b & c) ? d : e
Expression after the patch:	a > ((b & c) ? d : e)

That's clearly different; a C compiler would have to be extremely buggy
to get such expressions wrong.  So which is really the right one; before
or after?

Before:

if (upsg->sg[i].count > (dev->adapter_info.options & AAC_OPT_NEW_COMM)
        ? (dev->scsi_host_ptr->max_sectors << 9) : 65536) {

After:

if (upsg->sg[i].count > (
          (dev->adapter_info.options & AAC_OPT_NEW_COMM)
                 ? (dev->scsi_host_ptr->max_sectors << 9) : 65536
    )) {
-- 
Stefan Richter
-=====-==--= =-== --=--
http://arcgraph.de/sr/

DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
