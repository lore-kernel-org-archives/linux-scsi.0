From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 04 Nov 2009 02:23:58 +0100
Message-ID: <4AF0D7AE.200@s5r6.in-berlin.de>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8572@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN> <1257259243.2728.4.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48140 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZKDBYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 20:24:03 -0500
In-Reply-To: <1257259243.2728.4.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

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
