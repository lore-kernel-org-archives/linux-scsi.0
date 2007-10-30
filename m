From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/scsi/dpt_i2o: Convert to generic boolean
Date: Tue, 30 Oct 2007 21:52:41 +0100
Message-ID: <47279999.6090002@student.ltu.se>
References: <20071030104806.30936.13253.sendpatchset@thinktank.campus.ltu.se> <20071030145155.GL32359@parisc-linux.org> <47274781.3030606@student.ltu.se> <20071030151121.GM32359@parisc-linux.org> <47275FD0.4010400@student.ltu.se> <20071030173828.GB15111@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:50001 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXJ3U7J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 16:59:09 -0400
In-Reply-To: <20071030173828.GB15111@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Tue, Oct 30, 2007 at 05:46:08PM +0100, Richard Knutsson wrote:
>   
>> I just don't see the reason why expressing a boolean as an integer. Some 
>> advantage?
>>     
>
> This is C, not Java, or some other highly-typed language.
> if (int) and if (ptr) are perfectly acceptable in C.
>   
Yes, and it has been "corrected" in the C99-standard (which we are using 
since the Linux support for the the 2.95 compiler stopped). Is there 
something wrong in actually typing the variable to the type we want it 
to be? Or would it be better to regress (becoming like Perl or PHP)[1][2]?
Btw, I am all for 'if (ptr)' since it rarely (if ever) makes any sense 
to do 'if (ptr == 0x1234)', which evaluates to ptr == NULL is invalid 
and otherwise valid. Is it really the same for integers? ;)
(also just want to add: to the "this is not a highly-typed language" 
that I have heard many times, it theory, I think it would suffice with 
just the void-pointer)
>   
>> (also helps us if someone does: 'if (var == true)', even thou we should 
>> try to avoid them)
>>     
>
> I have no idea what you mean.
>   
There is some places where things like 'if (var == true)' is done, but 
what happens when var is not the same number as 'true' (and still != 0)? 
It is a potential bug if 'var' is an integer and expected to be a 
boolean in this case. Like in a case of "var = some_var & some_flag;"

Best regards
Richard Knutsson
[1] Nothing wrong with Perl or PHP, they are suited for the tasks they 
are meant to solve.
[2] If I recall correctly, the predecessor 'B' did not have any types.
