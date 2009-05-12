From: Tejun Heo <tj@kernel.org>
Subject: Re: Re: [PATCH 1/3] block: add alt_size
Date: Tue, 12 May 2009 09:53:05 +0900
Message-ID: <4A08C871.9000100@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org>
	<1241828002-12742-2-git-send-email-tj@kernel.org>
	<ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
	<4A058D5C.6030206@kernel.org>
	<20090511134534.GA32678@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090511134534.GA32678@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: jens.axboe@oracle.com, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mauelshagen@redhat.com
List-Id: linux-scsi@vger.kernel.org

Konrad Rzeszutek wrote:
> .. snip ..
>>> Also, values with magic block counts, while there is no way to get the
>>> blocksize with the same interface, are pretty weird. I think the
>>> current "size" attribute is just a bug.
>> Logical block size is fixed at 512 bytes.  Offset and size are always
>> represented in multiples of 512 bytes and only get converted to
>> hardware block size in the lld.
> 
> That interpretation is at odds with the work that Martin Peterson is
> doing with the 4K support. In the e-mail titled: "Re: [PATCH 4 of 8] sd:
> Physical block size and alignment support",
> Message-ID:<yq1ab67b51p.fsf@sermon.lab.mkp.net> he says:
> 
> "
> 	Konrad> about what a 'logical block', and 'physical block' is
> 	Konrad> vs. 'hardware sector' ?
> 
> 	Well, another item on my todo list is to kill the notion of hardware
> 	sector completely.  The protocols have been referring to logical blocks
> 	for ages.
> 
> 	It hasn't been a big problem until now because logical block size has
> 	been equal to the hardware sector size.  That's no longer a valid
> 	assumption.
> "
> 
> Are the ATA/SCSI/etc specs at odds with each other about this?

Hardware specs aren't of concern here.  The logical block concept is
there simply to give 9 bit addressing advantage, nothing more, nothing
less.  If hardware's sector size doesn't match it, the lld should be
mapping the sector addresses and sizes and cdrom and a few other
drives have been doing that for ages.  There's nothing new about
devices with sectors larger than 512 bytes.

Thanks.

-- 
tejun
