From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH] drivers/scsi/aic7xxx_old: Convert to generic boolean-values
Date: Fri, 16 Feb 2007 20:10:53 +0100
Message-ID: <45D601BD.6010709@student.ltu.se>
References: <20070210174628.3764.89569.sendpatchset@thinktank.campus.ltu.se>	 <1171132062.3373.31.camel@mulgrave.il.steeleye.com>	 <20070212122738.b5e9a8af.akpm@linux-foundation.org>	 <1171644132.3443.27.camel@mulgrave.il.steeleye.com>	 <45D5F21B.2010804@student.ltu.se> <1171650214.3443.41.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:57366 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946225AbXBPTLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 14:11:04 -0500
In-Reply-To: <1171650214.3443.41.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2007-02-16 at 19:04 +0100, Richard Knutsson wrote:
>   
>> James Bottomley wrote:
>>     
>>> On Mon, 2007-02-12 at 12:27 -0800, Andrew Morton wrote:
>>>   
>>>       
>>>> Given that we now have a standard kernel-wide, c99-friendly way of
>>>> expressing true and false, I'd suggest that this decision can be revisited.
>>>>
>>>> Because a "true" is significantly more meaningful (and hence readable)
>>>> thing than a bare "1".
>>>>     
>>>>         
>>> OK, I'm really not happy with doing this for three reasons:
>>>
>>> 1. It's inviting huge amounts of driver churn changing bitfields to
>>> booleans
>>>   
>>>       
>> Have been some work done already. Has there been any problems?
>>     
>
> There's always an issue when two people work on the same driver ... it
> causes patch conflicts, which is why we try to avoid it where we can.
>   
But it is (hopefully) a one-time change.
>>> 2. I do find it to be a readability issue.  Like most driver writers,
>>> I'm used to register layouts, and those are simple bitfields, so I don't
>>> tend to think true and false, I think 1 and 0.
>>>   
>>>       
>> It is a fundamental difference between an integer and a boolean. Have 
>> you seen anyone trying to do "bool var = true + true;"? ;)
>>     
>
> I don't quite see how this is relevant to the readability issue?
>   
Your "simple bitfields" :)
But on the note of readability; there is in no way any constraints to 
only use 'false'/'true'. Right now I'm converting some files who already 
uses FALSE/TRUE and may change 0/1 for consitency.
But I think it all boils down to what people are used to (I don't think 
there are any C++/Java-developers who complains about boolean and 
false/true). I am not too concerned about 0/1 being used or false/true, 
but the proper use of booleans and values.
>   
>>> 3. Having a different, special, type for single bit bitfields (while
>>> still using u<n> for multi bit bitfields) is asking for confusion, and
>>> hence trouble at the driver level.
>>>   
>>>       
>> I don't think a boolean should be view as a single bit bitfield. Ex:
>> u8 a:1;
>> ...
>> int b = 4 + a;
>> is obviously not a boolean, while:
>> u8 a:1;
>> ...
>> if (a)
>> is, and a should be "bool a:1;" (imho)
>>     
>
> This again, doesn't really address the argument.  I'm saying I'd rather
> not have confusion over what types to use in the driver.  You're saying
> that if you only check the value for truth or falsehood it should be a
> boolean.  That's actually worse than I was anticipating because you're
> now saying that single bit bitfields may or may not be booleans
> depending on use.  This looks like worse potential for confusion than
> before.
>   
Actually I find it to be simpler. Which would you chose?:
u8 a:1;
or
int a:1;
for a value? But if 'a' is a statement, then we just use:
bool a:1 (if the size of the variable is of relevance, otherwise just 
"bool a"). (You know what the variables are going to be used for when 
declaring them, right??)
Btw, how do you know if "a += 1" is just used to flip 'a's value or if 
it is a bug (in the case of boolean)?

Richard "come over to the dark side" Knutsson

