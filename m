From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sun, 22 May 2005 15:08:06 +1000
Message-ID: <429013B6.3010505@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>	 <1116687698.4999.3.camel@mulgrave> <428F55F1.3090006@pobox.com>	 <1116691256.4999.16.camel@mulgrave>	 <20050521162220.GU29811@parcelfarce.linux.theplanet.co.uk> <1116699144.4999.37.camel@mulgrave> <428FB0FA.7040302@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <428FB0FA.7040302@torque.net>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> James Bottomley wrote:
> 
>> On Sat, 2005-05-21 at 17:22 +0100, Al Viro wrote:
>>
>>> Tell that to firmware authors, why don't you?
>>
>>
>>
>> I do ... but they don't listen ...
>>  
>>
>>>> Does anyone actually have one of these RBC devices and does it reject
>>>> the six byte mode sense commands?
>>>
>>>
>>> Yes, will check and do not expect the results to apply to other 
>>> devices...
>>
>>
>>
>> Thanks ... I'd be surprised if the entire class of RBC devices simply
>> ignored the standard; I wouldn't be surprised to find one or two that
>> are out of spec.
>>
>> James
> 
> James,
> Perhaps __scsi_mode_sense() could do a simple sanity
> check: for any valid mode page [after the header and
> block descriptor(s) are stepped over]:
>      ((mpage[0] & 3f) == page_num)
> 
> If a response fails that test, we don't believe it.

A bit more accurate sanity check:
     if ((page_num > 0) && (page_num < 0x3f) &&
         ((mpage[0] & 3f) == page_num))
	// page looks ok (even if subpage_num was 0xff)
     else
	// nah

Mode page number 0 is the unit attention vendor specific
page which is not necessarily in "mode page format".
The vendor that I know does use it, does at least follow
mode page format.
A requested page_num of 0x3f and a requested subpage_num
of 0xff are wildcards.

Doug Gilbert



-------------------------------------------------------
This SF.Net email is sponsored by Oracle Space Sweepstakes
Want to be the first software developer in space?
Enter now for the Oracle Space Sweepstakes!
http://ads.osdn.com/?ad_id=7412&alloc_id=16344&op=click
