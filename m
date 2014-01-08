From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 06:03:43 -0800
Message-ID: <20140108140343.GB588@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <20140108011713.GA5212@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140108011713.GA5212@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Sergey Meirovich <rathamahata@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 08, 2014 at 02:17:13AM +0100, Jan Kara wrote:
>   Well, I was specifically worried about i_mutex locking. In particular:
> Before we report appending IO completion we need to update i_size.
> To update i_size we need to grab i_mutex.
> 
> Now this is unpleasant because inode_dio_wait() happens under i_mutex so
> the above would create lock inversion. And we cannot really do
> inode_dio_done() before grabbing i_mutex as that would open interesting
> races between truncate decreasing i_size and DIO increasing it.

Yeah, XFS splits this between the ilock and iolock, which just makes
life in this area a whole lot easier.
