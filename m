From: Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH] target/file: fix inclusive vfs_fsync_range() end
Date: Tue, 7 Oct 2014 12:12:44 -0700
Message-ID: <20141007191244.GA10366@lenny.home.zabbo.net>
References: <1412638813-13285-1-git-send-email-zab@zabbo.net>
 <20141007063945.GA4185@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141007063945.GA4185@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 06, 2014 at 11:39:45PM -0700, Christoph Hellwig wrote:
> On Mon, Oct 06, 2014 at 04:40:13PM -0700, Zach Brown wrote:
> > Both of the file target's calls to vfs_fsync_range() got the end offset
> > off by one.  The range is inclusive, not exclusive.  It would sync a bit
> > more data than was required.
> > 
> > The sync path already tested the length of the range and fell back to
> > LLONG_MAX so I copied that pattern in the rw path.
> > 
> > This is untested. I found the errors by inspection while following other
> > code.
> 
> Maybe it's time to move vfs_fsync_range to a more normal calling
> convention?

Yeah, I wanted to just fix the bugs before going too far.  

The current interface does seem like a bad fit.  3 of the 5 non-core
callers got it wrong.  They all generate start,end from off,count and
fall back to LLONG_MAX.

I'll put something together if no one beats me to it.

- z
