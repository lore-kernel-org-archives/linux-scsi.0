From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem
 readonly
Date: Fri, 27 Nov 2009 12:58:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0911271248210.30903-100000@netrider.rowland.org>
References: <20091127094339.GA9047@roll>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091127094339.GA9047@roll>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Kernel development list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Nov 2009 tmhikaru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> It is important to me to know exactly how the failure path operates. Please
> explain to me what I will see happen. - Not knowing is driving me nuts.

It goes like this.  The computer sends a lot of READ commands to the
drive.  (For all we know the same thing might happen with WRITEs, but
you didn't do any writing in the test data you sent.)  Every now and
then the drive fails to carry out a READ, for no apparent reason.

Normally the computer then retries, and the READ succeeds the second
time.  But of course, success isn't guaranteed.  When the retry does
succeed, no error messages are printed in the log and everything
continues normally.

Occasionally the computer does not retry the READ -- in circumstances
where it doesn't really need the data (optimistic readahead).  When 
this happens, the failed READ does cause an error message to appear.  
The same thing would happen if the attempted retries were to fail.

Whether or not this would result in lost or corrupted data, or
remounted readonly filesystems, depends on the kind of data being read.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
