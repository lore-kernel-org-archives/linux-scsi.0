From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
	environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Mon, 20 Jan 2014 05:58:55 -0800
Message-ID: <20140120135855.GA26280@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
	<20140106201032.GA13491@quack.suse.cz>
	<20140107155830.GA28395@infradead.org>
	<CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
	<20140108140307.GA588@infradead.org>
	<CA+QCeVRuvNtZ8+9D-NtMOD=B9UEA5HMvKaGdXOQCjO-KTnZdbw@mail.gmail.com>
	<20140115220721.GY3469@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140115220721.GY3469@dastard>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Gluk <git.user@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Sergey Meirovich <rathamahata@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 16, 2014 at 09:07:21AM +1100, Dave Chinner wrote:
> Yes, I think it can be done relatively simply. We'd have to change
> the code in xfs_file_aio_write_checks() to check whether EOF zeroing
> was required rather than always taking an exclusive lock (for block
> aligned IO at EOF sub-block zeroing isn't required),

That's not even required for supporting aio appends, just a further
optimization for it.

> and then we'd
> have to modify the direct IO code to set the is_async flag
> appropriately. We'd probably need a new flag to say tell the DIO
> code that AIO beyond EOF is OK, but that isn't hard to do....

Yep, need a flag to allow appending writes and then defer them.

> Christoph, are you going to get any time to look at doing this in
> the next few days?

I'll probably need at least another week before I can get to it.  If you
wanna pick it up before than feel free.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
