From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
Date: Mon, 30 Mar 2009 22:33:58 +0400
Message-ID: <49D11096.3070804@vlnb.net>
References: <49D10256.8030307@vlnb.net> <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757137AbZC3Se1@vger.kernel.org>
In-Reply-To: <e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stgt@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche, on 03/30/2009 10:06 PM wrote:
> On Mon, Mar 30, 2009 at 7:33 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> As part of 1.0.1 release preparations I made some performance tests to make
>> sure there are no performance regressions in SCST overall and iSCSI-SCST
>> particularly. Results were quite interesting, so I decided to publish them
>> together with the corresponding numbers for IET and STGT iSCSI targets. This
>> isn't a real performance comparison, it includes only few chosen tests,
>> because I don't have time for a complete comparison. But I hope somebody
>> will take up what I did and make it complete.
>>
>> Setup:
>>
>> Target: HT 2.4GHz Xeon, x86_32, 2GB of memory limited to 256MB by kernel
>> command line to have less test data footprint, 75GB 15K RPM SCSI disk as
>> backstorage, dual port 1Gbps E1000 Intel network card, 2.6.29 kernel.
>>
>> Initiator: 1.7GHz Xeon, x86_32, 1GB of memory limited to 256MB by kernel
>> command line to have less test data footprint, dual port 1Gbps E1000 Intel
>> network card, 2.6.27 kernel, open-iscsi 2.0-870-rc3.
>>
>> The target exported a 5GB file on XFS for FILEIO and 5GB partition for
>> BLOCKIO.
>>
>> All the tests were ran 3 times and average written. All the values are in
>> MB/s. The tests were ran with CFQ and deadline IO schedulers on the target.
>> All other parameters on both target and initiator were default.
> 
> These are indeed interesting results. There are some aspects of the
> test setup I do not understand however:
> * All tests have been run with buffered I/O instead of direct I/O
> (iflag=direct / oflag=direct). My experience is that the results of
> tests with direct I/O are easier to reproduce (less variation between
> runs). So I have been wondering why the tests have been run with
> buffered I/O instead ?

Real applications use buffered I/O, hence it should be used in tests. It 
  evaluates all the storage stack on both initiator and target as a 
whole. The results are very reproducible, variation is about 10%.

> * It is well known that having more memory in the target system
> improves performance because of read and write caching. What did you
> want to demonstrate by limiting the memory of the target system ?

If I had full 2GB on the target, I would have to spend on the 
measurements 10 times more time, since the data footprint should be at 
least 4x of the cache size. For sequential read/writes 256MB and 2GB of 
the cache are the same.

Where it did matter (io_trash) I increased memory size to full 2GB.

> * Which SCST options were enabled on the target ? Was e.g. the
> NV_CACHE option enabled ?

Defaults, i.e. yes, enabled. But it didn't matter, since all the 
filesystems where mounted on the initiator without data barriers enabled.

Thanks,
Vlad

P.S. Please don't drop CC.
