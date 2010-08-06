From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [RFC] relaxed barrier semantics
Date: Fri, 06 Aug 2010 22:38:46 +0400
Message-ID: <4C5C56B6.9020309@vlnb.net>
References: <4C4FECFE.9040509@kernel.org> <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100802173930.GP16630@think> <4C5AB89C.5080700@vlnb.net> <20100805133225.GF29846@think> <4C5B1583.6070706@vlnb.net> <20100805195048.GA19030@lst.de> <4C5B19A0.9070200@vlnb.net> <4C5C22B8.9040109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4C5C22B8.9040109@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Chris Mason <chris.mason@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, tytso@mit.edu, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke, on 08/06/2010 06:56 PM wrote:
> But I can do bonnie runs in no time.
> I have done some preliminary benchmarks by just enable ordered
> queueing in sd.c and no other changes.
> Bonnie says:
>
> Writing intelligently: 115208 vs.  82739
> Reading intelligently: 134133 vs. 129395
>
> putc() performance suffers, though:
> I get 52M vs 90M writing and 50M vs. 65M reading.
> No idea why; shouldn't be that harmful here.
>
> But in any case there is some speed improvement
> to be had from using ordered tags.
>
> Oh, and that was against an EVA 6400.

Here are my numbers. They are taken using:

fio --bs=X --ioengine=aio --buffered=0 --size=128M --rw=read --thread 
--numjobs=1 --loops=100 --group_reporting --gtod_reduce=1 --name=AAA 
--filename=/dev/sdc --iodepth=Y

/dev/sdc is 1GbE iSCSI device with on the other side iSCSI-SCST with a 
single 15K RPM Wide SCSI HDD. All values are in MB/s. The system 
(initiator) is pretty old 1.7GHz Xeon.

     Y |	1	2	4	8	32
----------------------------------------------------------------------
X     |
4K    |	16	25	32	34	34  (initiator CPU overloaded)
16K   |	25	57	72	85	85  (initiator CPU overloaded)
32K   |	44	72	97	106	106 (initiator CPU overloaded)
64K   |	65	95	114	115	115 (max of 1GbE)
128K  |	80	112	115	115	115 (max of 1GbE)

Are there still any people thinking that tagged queuing doesn't have any 
meaningful use?

Or 350% performance increase doesn't matter? (If the system was more 
powerful, the difference would be even bigger.)

As you can see on external storage even with 128K commands the queue 
should have at least 2 entries queued to go with full performance.

Vlad
