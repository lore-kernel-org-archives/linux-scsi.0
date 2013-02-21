From: Martin Svec <martin.svec@zoner.cz>
Subject: Re: Read I/O starvation with writeback RAID controller
Date: Thu, 21 Feb 2013 12:43:37 +0100
Message-ID: <51260869.20105@zoner.cz>
References: <5124EDF4.4010309@zoner.cz> <1361393295.3667.21.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1361393295.3667.21.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm sorry, I forgot to mention hardware details. It isn't aacraid, it
is megaraid-based Dell PERC H700 w/ 1GB NVRAM and 12x 450GB 15k SAS
drives in RAID-10. All in Dell R510 server.

Thanks,

Martin

Dne 20.2.2013 21:48, Nicholas A. Bellinger napsal(a):
> Hi Martin,
>
> CC'ing linux-scsi here, as aacraid doesn't have an official maintainer
> atm.
>
> --nab
>
> On Wed, 2013-02-20 at 16:38 +0100, Martin Svec wrote:
>> Hello,
>>
>> I've noticed read I/O starvation problems of LIO iSCSI target when
>> used on top of writeback-enabled HW RAID controller (PERC H700 with
>> 1GB cache). For intensive mixed read-write workload in virtualized
>> environments, writes are able to consume over 95% of the IOPS
>> throughput and cause starvation of reads.
>>
>> After a number of tests it seems to me it's a general issue of block
>> layer I/O scheduling when running on top of a writeback device. If
>> there is a write-intensive task, all writes go to the writeback cache
>> with near-zero latency. This allows writer to quickly saturate the
>> device with thousands of writes while using only a minimal fraction of
>> queue depth. However, non-cached reads depend on spinning drive
>> latencies which are orders of magnitude higher than writeback cache
>> latencies, and so readers cannot submit so many requests per second as
>> writers. Consequently, I guess the controller has totally wrong view
>> of the incoming workload pattern, tries to satisfy the write flood
>> first and the net result is inacceptable starvation of reads, with
>> latencies up to hundreds of milliseconds.
>>
>> A simple fio test with 1TiB block device where one thread does 4k
>> random sync writes with iodepth=32 and one thread does 4k random reads
>> with iodepth=32 shows that instead of the theoretical 50:50 IOPS
>> ratio, the block device runs with 95:5 ratio in favor of writes. In
>> fact, the imbalance is so high that even write iodepth=2 is enaugh to
>> achieve the same numbers.
>>
>> Real workloads that tend to exhibit this problem are: initial zeroing
>> of a virtual machine disk, virtual machine migration, virtual machine
>> cloning, intensive swapping of one virtual machine etc.
>>
>> I tried to set WCE=1 on target iblock device, played with queue
>> depths, tested all three I/O schedulers and their parameters,
>> controller's parameters, but with no luck. To achieve reasonably good
>> fairness, the only solution is to set nr_requests to 1 or disable
>> controller's writeback cache at all -- at the expense of degraded
>> overall performance :-(
>>
>> Regarding nr_requests, there's obvious relation between iodepths and
>> read starvation: if (nr_requests >= workload iodepth) then starvation
>> surely occurs. Lowering nr_requests below this threshold slowly starts
>> improving fairness and for every rd+wr iodepths pair, there exists
>> sufficiently low nr_requests value at which IOPS ratio is finally
>> balanced according to rd:wr iodepth ratio. Unfortunately it means
>> there is no minimal nr_requests value suitable for all workloads. For
>> iodepths around 2 to 8, only nr_requests=1 provides fair load balancing.
>>
>> Is this a known problem? Does anybody find block layer parameters that
>> elliminate this problem for iscsi-target storage in mixed random
>> read-write environments like virtualization? Or should I start writing
>> my own I/O scheduler? ;-)
>>
>> Update: I've just found https://lkml.org/lkml/2012/12/10/550 (Read
>> starvation by sync writes), where Jan Kara describes identical
>> symptoms. But setting nr_requests=10000 doesn't help in my case.
>> CC'ing LKML too (I'm not LKML subscriber).
>>
>> Thanks,
>>
>> Martin
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe target-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
