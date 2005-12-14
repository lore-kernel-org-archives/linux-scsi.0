From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: stgt a new version
 of iscsi target?
Date: Wed, 14 Dec 2005 18:09:51 +0300
Message-ID: <43A035BF.1020304@vlnb.net>
References: <43987F75.2000301@vlnb.net>	<4398850D.8070102@cs.wisc.edu>	<4399A2BA.1070505@vlnb.net> <20051210174658I.fujita.tomonori@lab.ntt.co.jp> <439AF51E.1080509@vlnb.net> <439B19CD.7020308@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <439B19CD.7020308@cs.wisc.edu>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Vladislav Bolkhovitin wrote:
> 
>> FUJITA Tomonori wrote:
>>
>>> From: Vladislav Bolkhovitin <vst@vlnb.net>
>>> Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new 
>>> version of iscsi target?
>>> Date: Fri, 09 Dec 2005 18:28:58 +0300
>>>
>>>
>>>>> Also is the page cache comment in reference to us using the page 
>>>>> cache for our reads and writes or I am not sure why you wrote that 
>>>>> if you do not do it right now.
>>>>
>>>>
>>>>
>>>> Hm, at first, the page cache already used somehow in fileio dev 
>>>> handler (though, with additional mem copy). At the second, fully 
>>>> utilize the page cache is one of two major improvements that are 
>>>> pending in scst, because it is required changing the kernel, which 
>>>> until some moment try to avoid. Although I prepared what is 
>>>> necessary for that.
>>>>
>>>> The idea basically is the following. When READ operation arrives, 
>>>> pages for all requested blocks are at first searched in the page 
>>>> cache (probably, in SIRQ context, because it isn't expensive 
>>>> operation) and if all pages are found, they are referenced and the 
>>>> result will be sent to the initiator. Then the pages will be 
>>>> dereferenced (so, no pages allocation will be done at all). 
>>>> Otherwise, the missed pages will be allocated and the command will 
>>>> be rescheduled to the thread, which will read them. Then, after the 
>>>> response is sent, the pages will remain in the page cache for future 
>>>> accesses. For WRITEs the processing is the similar, the pages with 
>>>> the data will be put in the page cache.
>>>
>>>
>>>
>>> The Ardis iSCSI target code does the same thing.
>>
>>
>>
>> Perfectly. So, why don't do it on the mid-layer level where all 
>> targets can benefit from it?
>>
> 
> Any target can hook into stgt too? What is your point since neither of
> us are in mainline or even close given the scsi guy's veiwpoint on where 
> to do reads and writes?

My point is to show one of the benefits of the kernel side 
implementation. Any target driver (of scst or stgt, doesn't matter) 
should benefit from it. Obviously, there is no point to overcomplicate 
any target driver with the functions of the the mid-level.

Vlad


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
