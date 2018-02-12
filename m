From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] libata: remove WARN() for DMA or PIO command without data
Date: Mon, 12 Feb 2018 09:21:00 -0800
Message-ID: <20180212172100.GC695913@devbig577.frc2.facebook.com>
References: <001a11425956f5f3d0055c82f08d@google.com>
 <20180204043327.16760-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180204043327.16760-1-ebiggers3@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, syzkaller-bugs@googlegroups.com, Eric Biggers <ebiggers@google.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 03, 2018 at 08:33:27PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> syzkaller hit a WARN() in ata_qc_issue() when writing to /dev/sg0.  This
> happened because it issued a READ_6 command with no data buffer.
> 
> Just remove the WARN(), as it doesn't appear indicate a kernel bug.  The
> expected behavior is to fail the command, which the code does.
> 
> Here's a reproducer that works in QEMU when /dev/sg0 refers to a disk of
> the default type ("82371SB PIIX3 IDE"):
> 
>     #include <fcntl.h>
>     #include <unistd.h>
> 
>     int main()
>     {
>             char buf[42] = { [36] = 0x8 /* READ_6 */ };
> 
>             write(open("/dev/sg0", O_RDWR), buf, sizeof(buf));
>     }
> 
> Fixes: f92a26365a72 ("libata: change ATA_QCFLAG_DMAMAP semantics")
> Reported-by: syzbot+f7b556d1766502a69d85071d2ff08bd87be53d0f@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org> # v2.6.25+
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to libata/for-4.16-fixes.

Thanks.

-- 
tejun
