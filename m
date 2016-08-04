From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 37/45] drivers: use req op accessor
Date: Thu, 4 Aug 2016 11:32:16 -0500
Message-ID: <CAJVOszAqEw3UK6HV4bPvYfHeO6jvP0d-OtfXxRuve=5-Kmaokw@mail.gmail.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
	<CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
	<87fbe31f-27b3-ff7a-e381-34fc1aad337e@redhat.com>
	<CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
	<20160804154622.GB15656@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <20160804154622.GB15656@infradead.org>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: Christoph Hellwig <hch@infradead.org>
Cc: philipp.reisner@linbit.com, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, konrad.wilk@oracle.com, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, osd-dev@open-osd.org, Ross Zwisler <zwisler@gmail.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, ocfs2-devel@oss.oracle.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 4, 2016 at 10:46 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Aug 03, 2016 at 07:30:29PM -0500, Shaun Tancheff wrote:
>> I think the translation in loop.c is suspicious here:
>>
>>     "if use DIO && not (a flush_flag or discard_flag)"
>> should translate to:
>>     "if use DIO && not ((a flush_flag) || op == discard)"
>>
>> But in the patch I read:
>>     "if use DIO && ((not a flush_flag) || op == discard)
>>
>> Which would have DIO && discards follow the AIO path?
>
> Indeed.  Sorry for missing out on your patch, I just sent a fix
> in reply to Dave's other report earlier which is pretty similar to
> yours.

No worries. I prefer your switch to a an if conditional here.

-- 
Shaun Tancheff
