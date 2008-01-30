From: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: Re: [BUG] The kernel thread for md RAID1 could cause a
 md RAID1 array deadlock
Date: Wed, 30 Jan 2008 11:02:16 +0900
Message-ID: <479FDAA8.3030409@ce.jp.nec.com>
References: <478C240F.8070004@ce.jp.nec.com>
	<18328.1473.26122.647283@notabene.brown>
	<47985B37.9000503@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <47985B37.9000503@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

>Also, md raid10 seems to have the same problem.
>I will test raid10 applying this patch as well.

Sorry for the late response. I had a trouble with reproducing the problem,
but it turns out that the 2.6.24 kernel needs the latest (possibly testing)
version of systemtap-0.6.1-1 to run systemtap for the fault injection tool.

I've reproduced the stall on both raid1 and raid10 using 2.6.24.
Also I've tested the patch applied to 2.6.24 and confirmed that
it will fix the stall problem for both cases.

K.Tanaka wrote:
> Hi,
> 
> Thank you for the patch.
> I have applied the patch to 2.6.23.14 and it works well.
> 
> - In case of 2.6.23.14, the problem is reproduced.
> - In case of 2.6.23.14 with this patch, raid1 works well so far.
>   The fault injection script continues to run, and it doesn't deadlock.
>   I will keep it running for a while.
> 
> Also, md raid10 seems to have the same problem.
> I will test raid10 applying this patch as well.
> 
> 
> Neil Brown wrote:
>> On Tuesday January 15, k-tanaka@ce.jp.nec.com wrote:
>>> This message describes the details about md-RAID1 issue found by
>>> testing the md RAID1 using the SCSI fault injection framework.
>>>
>>> Abstract:
>>> Both the error handler for md RAID1 and write access request to the md RAID1
>>> use raid1d kernel thread. The nr_pending flag could cause a race condition
>>> in raid1d, results in a raid1d deadlock.
>> Thanks for finding and reporting this.
>>
>> I believe the following patch should fix the deadlock.
>>
>> If you are able to repeat your test and confirm this I would
>> appreciate it.
>>
>> Thanks,
>> NeilBrown
>>
>>
>>
>> Fix deadlock in md/raid1 when handling a read error.
>>
>> When handling a read error, we freeze the array to stop any other
>> IO while attempting to over-write with correct data.
>>

-- 
---------------------------------------------------------
Kenichi TANAKA    | Open Source Software Platform Development Division
                  | Computers Software Operations Unit, NEC Corporation
                  | k-tanaka@ce.jp.nec.com
