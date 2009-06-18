From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] tmscsim: Fix big left-shifts of unsigned char
Date: Thu, 18 Jun 2009 16:27:37 +0300
Message-ID: <4A3A40C9.9020900@panasas.com>
References: <4A3A2FA2.60005@gmail.com> <1245330204.4773.10.camel@mulgrave.site> <20090618131632.GZ19977@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:55762 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZFRN1l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2009 09:27:41 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1114639fga.17
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 06:27:41 -0700 (PDT)
In-Reply-To: <20090618131632.GZ19977@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Roel Kluin <roel.kluin@gmail.com>, garloff@suse.de, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On 06/18/2009 04:16 PM, Matthew Wilcox wrote:
> On Thu, Jun 18, 2009 at 09:03:24AM -0400, James Bottomley wrote:
>> On Thu, 2009-06-18 at 14:14 +0200, Roel Kluin wrote:
>>> -           dc390_laststatus |= bval << 24;
>>> +           dc390_laststatus |= (unsigned)bval << 24;
>> bval is already u8, thus unsigned, so the cast is a nop.
> 
> Err ... I believe you're pedantically uncorrect, though right in practice.
> 
> The (unsigned) cast is short for (unsigned int) -- it doesn't mean
> 'cast to an unsigned version of the type that it already has'.
> 
> Now, in practice what happens is:
> 
> 6.5.7:
> 
> The integer promotions are performed on each of the operands. The type
> of the result is that of the promoted left operand.
> 

Note the left operand, not the lvalue.

> so bval would be promoted from an unsigned char to a signed int, and
> then shifted left by 24 bits, resulting in a potentially negative number.
> But dc390_laststatus is an u32, so the |= converts this negative number
> into a positive one, leading to the same answer that would have been
> carried out in unsigned arithmetic.
> 

It could get dangerous in 64bit integer machines if the negative number
gets truncated to 32bit while converted. So if the bval was > 127
and we get a 64bit signed negative number what will happen then?

> So you're right (the cast isn't needed) for the wrong reason ;-)
> 

Are you sure. It looks we need the cast
Boaz
