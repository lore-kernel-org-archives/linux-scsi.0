From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 06:03:07 -0800
Message-ID: <20140108140307.GA588@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 07, 2014 at 08:37:23PM +0200, Sergey Meirovich wrote:
> Actually my initial report (14.67Mb/sec  3755.41 Requests/sec) was about ext4
> However I have tried XFS as well. It was a bit slower than ext4 on all
> occasions.

I wasn't trying to say XFS fixes your problem, but that we could
implement appending AIO writes in XFS fairly easily.

To verify Jan's theory, can you try to preallocate the file to the full
size and then run the benchmark by doing a:

# fallocate -l <size> <filename>

and then run it?  If that's indeed the issue I'd be happy to implement
the "real aio" append support for you as well.
