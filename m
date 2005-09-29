From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: RE: [RFC PATCH 4/4] convert scsi to blkerr error v
	alues
Date: Wed, 28 Sep 2005 21:54:33 -0500
Message-ID: <433B5769.3050304@cs.wisc.edu>
References: <C2EEB4E538D3DC48BF57F391F422779321ACE4@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <C2EEB4E538D3DC48BF57F391F422779321ACE4@SRMANNING.eng.emc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: axboe@suse.de, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

goggin, edward wrote:
>  
> 
> 
>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org 
>>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
>>Sent: Wednesday, September 28, 2005 10:29 PM
>>To: device-mapper development
>>Cc: axboe@suse.de; linux-scsi@vger.kernel.org
>>Subject: Re: [dm-devel] RE: [RFC PATCH 4/4] convert scsi to 
>>blkerr error values
>>
>>goggin, edward wrote:
>>
>>>Mike,
>>>
>>>I don't think it is reasonably possible to anticipate
>>>all possible parsing requirements for the asc and ascq
>>>portions of SCSI sense information across all device
>>>models.  I'm in favor of having a "small" framework in
>>>SCSI where a SCSI sense interpreter module (per
>>>vendor & model possibly) could be registered
>>>dynamically, by dm-emc.c for instance.
>>>
>>>The extended error interpreter callout would be
>>>triggered indirectly by a call from
>>>__end_that_request_first to a extended error parser
>>>associated with the io request's queue whenever it
>>>sees a non-zero sense field of the io request.
>>>Perhaps the sense and sense_len fields in the
>>>request structure should be changed to not be
>>>SCSI specific.
>>>
>>>Also, in order to allow for more variation and detail
>>>in the interpretation of device specific SCSI asc and
>>>ascq values, the results of the interpretation should
>>>not be required to be block layer generic, but instead
>>>are saved in something like a void *bi_extended_error
>>>field of the bio.  __end_that_request_first would push
>>>the results of the extended_error interpretation to the
>>>bi_extended_error field of each bio in the request,
>>>similar to how Jens's code currently works.
>>>
>>
>>I have been working on this but a issue I was wondering about 
>>is what to 
>>do when someone other than dm-multipath wants to know about 
>>this special 
>>error value. For example when we first discover devices if it 
>>is passive 
>>path, we have to go through the pain of the regular setup and any 
>>retires that arise from it. If people are not going to complain about 
>>this anymore then you can ignore this mail :) But the problem 
>>(or issue 
>>people gripe about) is that if there is a magic ASC/ASCQ value for 
>>vendor XYZ that indicates we are sending requests to a 
>>passive path then 
>>who decodes the bi_extended_error value when dm-mutliapth is 
>>not used? 
>>Will we have to have a vendor specific bi_extended_error decoder for 
>>dm-mpath, filesystems and buffer head code,
> 
> 
> Yes, that is what I was thinking anyway.
> 
> 
>>and what about SCSI?
> 
> 
> Not clear why scsi would need a decoder.
> 

If during scsi device setup we could continue to send something like a 
read capacity command to a passive path since scsi-ml does not have a 
way to tell that we are sending the command to a passive path and that 
it is better to not retry the command in this case.
