From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros	for	accessing	3-byte
 arrays as integers
Date: Thu, 11 Sep 2008 11:30:04 +0300
Message-ID: <48C8D70C.7090908@panasas.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>	 <20080910140712.GA12280@infradead.org>	 <1221061241.27385.14.camel@norville.austin.ibm.com>	 <48C7F19D.3080507@panasas.com> <1221074409.27385.39.camel@norville.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5444 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbYIKIhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2008 04:37:48 -0400
In-Reply-To: <1221074409.27385.39.camel@norville.austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Leech <christopher.leech@intel.com>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org

Dave Kleikamp wrote:
> On Wed, 2008-09-10 at 19:11 +0300, Boaz Harrosh wrote:
>> Dave Kleikamp wrote:
> 
>>> @@ -62,7 +60,7 @@ struct timestruc_t {
>>>   */
>>>  typedef struct {
>>>  	unsigned len:24;
>>> -	unsigned off1:8;
>>> +	u8 off1;
>>>  	u32 off2;
>>>  } lxd_t;
>>>  
>> Why is the difference from below definition. That is the
>> use/not of __le24? 
> 
> Answered elsewhere, but this is host-endian.  I plan to kill this
> structure soon.
> 
>>> @@ -90,8 +88,8 @@ struct lxdlist {
>>>   *	physical xd (pxd)
>>>   */
>>>  typedef struct {
>>> -	unsigned len:24;
>>> -	unsigned addr1:8;
>>> +	__le24 len;
>> Is this stuff on-the-wire?
> 
> Written to disk, so basically, yeah.
> 
>> Do you need a:
>> +	__le24 len __packed;
>>
>>> +	u8 addr1;
>>>  	__le32 addr2;
>>>  } pxd_t;
>> and:
>>   } pxd_t __packed ;
> 
> I'm not convinced that this is needed.  Does the compiler do any padding
> for alignment when it only contains char types (or structs of chars)?
> 
>> Note that before the :24 bit-field was kept packed but now
>> with the use of struct at the __le24 definition it might
>> choose to pad them.
> 
> Maybe, but I can't get the compiler to add any padding playing around
> with variants of these structures.  I've tested a simple program on both
> x86 and ppc64, but I'm not sure what would happen on, say, arm.
> 

You have an "__le32 addr2" followed, it might want too in rare cases.
But for me this is also a a declaration issue and a readability issue.

I'm telling the compiler, don't mess with my structure, this needs
to be constant whatever the compiler is. In C the compiler is even
allowed to change fields order if it wants to. Why the guess work,
__packed and be done with it.

And it's also a readability issue. Look above lxd_t vs pxd_t. I can't
know that one is in memory and one is on disk. I have to ask questions
and make wrong remarks. But if the later had a __packed on it, then
there are no more questions.

__packed for me is a statement for both the programmer and compiler
that says: "This stuff will be seen externally of the machine. It must
be universally constant"

>> Chris you might want to change the definitions at linux/types.h
>> to:
>>
>> typedef struct { __u8 b[3]; } __be24, __le24 __packed;
>>
>> With gcc it will not help with the proceeding fields, and the
>> containing struct will need it's own "__packed" declaration
>> but it will keep it packed with previous fields.
>>
>> Just my $0.017
>> Boaz
> 
> Shaggy

Boaz
