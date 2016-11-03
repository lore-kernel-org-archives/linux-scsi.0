From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/3] scsi_dh_rdac: switch to scsi_execute_req_flags()
Date: Thu, 3 Nov 2016 23:06:21 +0100
Message-ID: <c2a84586-0623-a01a-4691-af9096c1f700@suse.com>
References: <1478036978-30583-1-git-send-email-hare@suse.de>
 <1478036978-30583-2-git-send-email-hare@suse.de>
 <1478101469.1001.9.camel@localhost.localdomain>
 <6bb2b352-d137-a9da-2f35-e6b0cdef4774@suse.com>
 <1478189499.1001.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:54803 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755409AbcKCWGt (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Thu, 3 Nov 2016 18:06:49 -0400
In-Reply-To: <1478189499.1001.26.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 11/03/2016 05:11 PM, Ewan D. Milne wrote:
> On Wed, 2016-11-02 at 22:27 +0100, Hannes Reinecke wrote:
>> On 11/02/2016 04:44 PM, Ewan D. Milne wrote:
>>> In this and other places the patch changes the code from submitting the
>>> INQUIRY/EVPD command for the page it wants, to calling scsi_get_vpd_page().
>>> scsi_get_vpd_page() will return -EINVAL if the device did not report in
>>> VPD page 0 that the requested page is in the list of supported pages.
>>> Did you actually verify that the RDAC returns all of these VPD pages in
>>> its VPD page 0 list?
>>>
>>> I mean, I know it's supposed to, but these are old devices.
>>>
>> Errm.
>>
>> Old? Don't tell that to the E-Series folk; you'll never again get
>> something sponsored :-)
>>
>> No, seriously: RDAC mode is continued to be supported even on the latest
>> models, and all firmware revisions I've got support VPD page 0x0.
>> And incidentally, this is the very same method we're using for basically
>> all tools accessing VPD page 0x83, be it in the kernel or something like
>> sg3_utils.
>> _Not_ asking for page 0x0 lead to crashes on several older devices.
>
> You're right, I was curious, so I resurrected our old RDAC, and it does
> in fact report the necessary supported VPD pages:
>
> # sg_vpd -H /dev/sg4
> Supported VPD pages VPD page:
>  00     20 00 00 12 00 80 83 85  86 87 b0 b1 c0 c1 c2 c3     ...............
>  10     c4 c8 c9 ca d0 e0                                   ......
>
> My concern was that older devices might not do this, I think there have
> been some arrays that had hidden commands/pages.
>
The original mpp_rdac (ie the multipath software from 
Engenio/LSI/NetApp) was using the 'C?' pages to identify the array, so 
they most certainly are present on all arrays.
And to properly (and safely :-) identify you have to query page 0 to 
figure out if those pages are supported.
Hence we're safe here.

I could ask NetApp, though, for a final confirmation if required.

Cheers,

Hannes

