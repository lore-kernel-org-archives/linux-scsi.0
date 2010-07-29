From: Jan Kara <jack@suse.cz>
Subject: Re: extfs reliability
Date: Thu, 29 Jul 2010 16:34:56 +0200
Message-ID: <20100729143456.GB12690@quack.suse.cz>
References: <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729083142.GA30077@lst.de>
 <4C517B5A.3020905@vlnb.net>
 <20100729130852.GA11852@lst.de>
 <4C518C4D.6050607@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C518C4D.6050607@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org, kernel-bugs@lists.ubuntu.com
List-Id: linux-scsi@vger.kernel.org

On Thu 29-07-10 18:12:29, Vladislav Bolkhovitin wrote:
> 
> Christoph Hellwig, on 07/29/2010 05:08 PM wrote:
> > On Thu, Jul 29, 2010 at 05:00:10PM +0400, Vladislav Bolkhovitin wrote:
> >> You can find full kernel logs starting from iSCSI load in the attachments.
> >>
> >> I already reported such issues some time ago, but my reports were not too much welcomed, so I gave up. Anyway, anybody can easily do my tests at any time. They don't need any special hardware, just 2 Linux boxes: one for iSCSI target and one for iSCSI initiator (the test box itself). But they are generic for other transports as well. You can see there's nothing iSCSI specific in the traces.
> > 
> > I was only talking about ext3.
> 
> Yes, now ext3 is a lot more reliable. The only how I was able to confuse it was:
> 
> ...
> (2197) nb_write: handle 4272 was not open size=65475 ofs=0
> (2199) nb_write: handle 4272 was not open size=65475 ofs=65534
> (2201) nb_write: handle 4272 was not open size=65475 ofs=131068
> (2203) nb_write: handle 4272 was not open size=65475 ofs=196602
> (2205) nb_write: handle 4272 was not open size=65475 ofs=262136^C
> ^C
> root@ini:/mnt/dbench-mod# ^C
> root@ini:/mnt/dbench-mod# ^C
> root@ini:/mnt/dbench-mod# cd
> root@ini:~# umount /mnt
> 
> <- recover device
> 
> root@ini:~# mount -t ext3 -o barrier=1 /dev/sdb /mnt
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so
> 
> Kernel log: "Jul 29 22:05:32 ini kernel: [ 2905.423092] JBD: recovery failed"
  Hmm, this is strange. Are there more messages around this one?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
