From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Sun, 08 Nov 2009 11:19:45 +0200
Message-ID: <4AF68D31.4000403@panasas.com>
References: <4A92BE18.50208@gmail.com>	 <1251416731.27356.8.camel@mulgrave.site>  <4A9A6676.8050304@panasas.com>	 <1251642902.10135.4.camel@mulgrave.site>	 <1257273187.9427.22.camel@mulgrave.site>  <4AF14147.4050102@panasas.com>	 <1257347360.2697.20.camel@mulgrave.site>  <4AF1A941.3080808@panasas.com>	 <1257357013.10416.8.camel@mulgrave.site>  <4AF28CCF.8020605@panasas.com> <1257450093.10355.28.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:54142 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753318AbZKHJTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Nov 2009 04:19:43 -0500
In-Reply-To: <1257450093.10355.28.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 11/05/2009 09:41 PM, James Bottomley wrote:
> On Thu, 2009-11-05 at 10:29 +0200, Boaz Harrosh wrote:
>> On 11/04/2009 07:50 PM, James Bottomley wrote:
>>> On Wed, 2009-11-04 at 18:18 +0200, Boaz Harrosh wrote:
>>>
>>> The point of checking is not to send a VPD inquiry to USB devices that
>>> don't support it.  These have a very limited range of supported VPD
>>> pages.
>>>
>>
>> OK thanks. But maybe just define a MIN_INQUIRY_SIZE instead of hard
>> coded 32 everywhere, and use that. So in future if such a device is
>> found we can easily change it.
> 
> So the minimum inquiry size would actually be 36 ... from
> scsi_scan.c ... and that's hard coded to a value too.
> 

two wrongs don't make a right ;-) But yes, sorry, that's a wrong name.
I meant minimum-vpd-page-inquiry, a specifc constant for that function
we are talking about.

>> (Never say never ;-))
> 
> I'm hoping that by the time USB devices get complex enough to need more
> than 28 VPD pages, they've actually discovered what conforming to the
> standards means.
> 

I don't understand what your saying. I'm making a simple and sane point.
A new comer, from looking at the API, will say "Haa I only need 12 bytes
lets set that". But no the buffer has dual purpose, one get the page I want,
but zero check these crap USB devices. (And all those other subtle things)
So you are actually going to argue that a patch should introduce an
hard coded 32 unexplained, and refuse a constant that actually communicates
the issue, which also covers our asses from the hopes we make.
Because I sure hope so too, but I'm also 48 years old.

> James
> 
> 

Boaz
