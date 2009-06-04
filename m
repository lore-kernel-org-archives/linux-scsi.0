From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: blk_abort_queue on failed paths?
Date: Thu, 04 Jun 2009 13:09:35 -0500
Message-ID: <4A280DDF.7070205@cs.wisc.edu>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
	<4A26ED7D.1010203@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A26ED7D.1010203@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Mike Christie wrote:
> adding linux-scsi and Mike Anderson
> 
> David Strand wrote:
>> After updating to kernel 2.6.28 I found that when I performed some
>> cable break testing during device i/o, I would get unwanted device or
>> host resets. Ultimately I traced it back to this patch:
>>
>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2 
>>
>>
>> The call to blk_abort_queue causes the block layer to call
>> scsi_times_out for pending i/o, which can (or will) ultimately lead to
>> device, and/or bus and/or host resets, which of course cause all the
>> other devices significant disruption.
>>
> 
> What driver were you using? 

Oh yeah, I do not think this should happen in new kernels if the driver 
is failing the IO with DID_TRANSPORT_DISRUPTED when it is deleting the 
rport. That should cause the IO to requeue and wait for fast io fail to 
fire.

Maybe we just need to convert some more drivers?
