From: Steven Dake <sdake@mvista.com>
Subject: Re: why store the search type in the ieee name field?
Date: Tue, 11 Feb 2003 10:38:59 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E493533.7000508@mvista.com>
References: <3E482B9E.40803@mvista.com>	<1044918776.1776.257.camel@mulgrave> 	<20030211082039.A27630@beaverton.ibm.com> <1044981839.1774.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1044981839.1774.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

When I looked at this code originally, it looked correct, I was just 
wondering why have an identifier field. I understand the reasoning now.

Thanks
-steve

James Bottomley wrote:

>On Tue, 2003-02-11 at 10:20, Patrick Mansfield wrote:
>  
>
>>On Mon, Feb 10, 2003 at 05:12:54PM -0600, James Bottomley wrote:
>>    
>>
>>>Erm, it's appending the type to the beginning of the name string
>>>(although it does seem to be relying on the sysfs name field being zero
>>>filled).  I don't see any corruption since the inquiry fields and unique
>>>name name follows this byte.
>>>      
>>>
>>It should fill in the rest of the 'name' and append a '\0', or return a
>>failure.
>>    
>>
>
>No, look at the code.  After doing name[0] = hex_str[...
>it then does a strcat.  If name is full of junk, strcat will append
>after the first \0 it finds (which may be off the end of the name
>field).  It only works because name[1] is zero but nothing seems to
>clear it.  I'm hoping it's being cleared in a piece of code I haven't
>found yet...
>
>James
>
>
>
>
>
>  
>

