From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: extfs reliability
Date: Thu, 29 Jul 2010 22:20:57 +0400
Message-ID: <4C51C689.9020300@vlnb.net>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <20100729083142.GA30077@lst.de> <4C517B5A.3020905@vlnb.net> <20100729130852.GA11852@lst.de> <4C518C4D.6050607@vlnb.net> <20100729143456.GB12690@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100729143456.GB12690@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jan Kara, on 07/29/2010 06:34 PM wrote:
> On Thu 29-07-10 18:12:29, Vladislav Bolkhovitin wrote:
>>
>> Christoph Hellwig, on 07/29/2010 05:08 PM wrote:
>>> On Thu, Jul 29, 2010 at 05:00:10PM +0400, Vladislav Bolkhovitin wrote:
>>>> You can find full kernel logs starting from iSCSI load in the attachments.
>>>>
>>>> I already reported such issues some time ago, but my reports were not too much welcomed, so I gave up. Anyway, anybody can easily do my tests at any time. They don't need any special hardware, just 2 Linux boxes: one for iSCSI target and one for iSCSI initiator (the test box itself). But they are generic for other transports as well. You can see there's nothing iSCSI specific in the traces.
>>>
>>> I was only talking about ext3.
>>
>> Yes, now ext3 is a lot more reliable. The only how I was able to confuse it was:
>>
>> ...
>> (2197) nb_write: handle 4272 was not open size=65475 ofs=0
>> (2199) nb_write: handle 4272 was not open size=65475 ofs=65534
>> (2201) nb_write: handle 4272 was not open size=65475 ofs=131068
>> (2203) nb_write: handle 4272 was not open size=65475 ofs=196602
>> (2205) nb_write: handle 4272 was not open size=65475 ofs=262136^C
>> ^C
>> root@ini:/mnt/dbench-mod# ^C
>> root@ini:/mnt/dbench-mod# ^C
>> root@ini:/mnt/dbench-mod# cd
>> root@ini:~# umount /mnt
>>
>> <- recover device
>>
>> root@ini:~# mount -t ext3 -o barrier=1 /dev/sdb /mnt
>> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>>         missing codepage or helper program, or other error
>>         In some cases useful info is found in syslog - try
>>         dmesg | tail  or so
>>
>> Kernel log: "Jul 29 22:05:32 ini kernel: [ 2905.423092] JBD: recovery failed"
>    Hmm, this is strange. Are there more messages around this one?

Rather none:

Jul 29 22:02:05 ini kernel: [ 2698.488446] sd 7:0:0:0: [sdb] CDB: Read(10): 28 00 00 07 88 69 00 00 01 00
Jul 29 22:02:05 ini kernel: [ 2698.505470] sd 7:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 29 22:02:05 ini kernel: [ 2698.505480] sd 7:0:0:0: [sdb] Sense Key : Illegal Request [current]
Jul 29 22:02:05 ini kernel: [ 2698.505488] sd 7:0:0:0: [sdb] Add. Sense: Logical unit not supported
Jul 29 22:02:05 ini kernel: [ 2698.505497] sd 7:0:0:0: [sdb] CDB: Read(10): 28 00 00 07 88 69 00 00 01 00
Jul 29 22:02:05 ini kernel: [ 2698.555147] sd 7:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 29 22:02:05 ini kernel: [ 2698.555157] sd 7:0:0:0: [sdb] Sense Key : Illegal Request [current]
Jul 29 22:02:05 ini kernel: [ 2698.555165] sd 7:0:0:0: [sdb] Add. Sense: Logical unit not supported
Jul 29 22:02:05 ini kernel: [ 2698.555175] sd 7:0:0:0: [sdb] CDB: Read(10): 28 00 00 07 88 69 00 00 01 00
Jul 29 22:02:05 ini kernel: [ 2698.582241] sd 7:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 29 22:02:05 ini kernel: [ 2698.582251] sd 7:0:0:0: [sdb] Sense Key : Illegal Request [current]
Jul 29 22:02:05 ini kernel: [ 2698.582259] sd 7:0:0:0: [sdb] Add. Sense: Logical unit not supported
Jul 29 22:02:05 ini kernel: [ 2698.582268] sd 7:0:0:0: [sdb] CDB: Read(10): 28 00 00 07 88 69 00 00 01 00
Jul 29 22:02:05 ini kernel: [ 2698.614789] sd 7:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jul 29 22:02:05 ini kernel: [ 2698.614799] sd 7:0:0:0: [sdb] Sense Key : Illegal Request [current]
Jul 29 22:02:05 ini kernel: [ 2698.614807] sd 7:0:0:0: [sdb] Add. Sense: Logical unit not supported
Jul 29 22:02:05 ini kernel: [ 2698.614817] sd 7:0:0:0: [sdb] CDB: Read(10): 28 00 00 07 88 69 00 00 01 00
Jul 29 22:02:45 ini kernel: [ 2738.474386] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474529] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474536] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474570] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474583] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474603] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474615] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474621] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474633] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:02:45 ini kernel: [ 2738.474659] __journal_remove_journal_head: freeing b_committed_data
Jul 29 22:05:32 ini kernel: [ 2905.423092] JBD: recovery failed
Jul 29 22:05:54 ini kernel: [ 2927.832893] kjournald starting.  Commit interval 5 seconds
Jul 29 22:05:54 ini kernel: [ 2927.833430] EXT3 FS on sdb, internal journal
Jul 29 22:05:54 ini kernel: [ 2927.833499] EXT3-fs: sdb: 1 orphan inode deleted
Jul 29 22:05:54 ini kernel: [ 2927.833503] EXT3-fs: recovery complete.
Jul 29 22:05:54 ini kernel: [ 2927.838122] EXT3-fs: mounted filesystem with ordered data mode.
