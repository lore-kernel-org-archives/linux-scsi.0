From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 20/30] blk_end_request: changing xsysace
	(take 4)
Date: Wed, 12 Dec 2007 20:12:27 +0200
Message-ID: <4760248B.6010904@panasas.com>
References: <20071211.174946.85815368.k-ueda@ct.jp.nec.com>	<475FA538.7000609@panasas.com>
	<20071212.120648.71084437.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071212.120648.71084437.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 12 2007 at 19:06 +0200, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:
> Hi,
> 
> On Wed, 12 Dec 2007 11:09:12 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> Index: 2.6.24-rc4/drivers/block/xsysace.c
>>> ===================================================================
>>> --- 2.6.24-rc4.orig/drivers/block/xsysace.c
>>> +++ 2.6.24-rc4/drivers/block/xsysace.c
>>> @@ -703,7 +703,7 @@ static void ace_fsm_dostate(struct ace_d
>>>  
>>>  		/* bio finished; is there another one? */
>>>  		i = ace->req->current_nr_sectors;
>>> -		if (end_that_request_first(ace->req, 1, i)) {
>>> +		if (__blk_end_request(ace->req, 0, i)) {
>> end_that_request_first() took sectors __blk_end_request() now takes
>> bytes
> 
> Thank you for pointing it out!  And I'm very sorry for the bug.
> I have checked all conversions between sectors and bytes through
> all patches again, and I found no other miss conversions.
> 
> Below is the revised patch for xsysace.
> 
> Thanks,
> Kiyoshi Ueda
> 
> 
NP, I know how it is, after you rebased your work for the 
"who's counting" times, you become blind. You need fresh
eyes to look at it. Thanks for doing all this.

Boaz
