From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] do we really need PG_error at all?
Date: Mon, 27 Feb 2017 20:11:48 -0500
Message-ID: <1488244308.7627.5.camel@redhat.com>
References: <1488120164.2948.4.camel@redhat.com>
	 <1488129033.4157.8.camel@HansenPartnership.com>
	 <877f4cr7ew.fsf@notabene.neil.brown.name>
	 <1488151856.4157.50.camel@HansenPartnership.com>
	 <874lzgqy06.fsf@notabene.neil.brown.name>
	 <1488208047.2876.6.camel@redhat.com>
	 <DC27F5BA-BCCA-41FF-8D41-7BB99AA4DB26@dilger.ca>
	 <87varvp5v1.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <87varvp5v1.fsf@notabene.neil.brown.name>
Sender: owner-linux-mm@kvack.org
To: NeilBrown <neilb@suse.com>, Andreas Dilger <adilger@dilger.ca>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, lsf-pc <lsf-pc@lists.linuxfoundation.org>, Neil Brown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-mm <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-02-28 at 10:32 +1100, NeilBrown wrote:
> On Mon, Feb 27 2017, Andreas Dilger wrote:
> 
> > 
> > My thought is that PG_error is definitely useful for applications to get
> > correct errors back when doing write()/sync_file_range() so that they know
> > there is an error in the data that _they_ wrote, rather than receiving an
> > error for data that may have been written by another thread, and in turn
> > clearing the error from another thread so it *doesn't* know it had a write
> > error.
> 
> It might be useful in that way, but it is not currently used that way.
> Such usage would be a change in visible behaviour.
> 
> sync_file_range() calls filemap_fdatawait_range(), which calls
> filemap_check_errors().
> If there have been any errors in the file recently, inside or outside
> the range, the latter will return an error which will propagate up.
> 
> > 
> > As for stray sync() clearing PG_error from underneath an application, that
> > shouldn't happen since filemap_fdatawait_keep_errors() doesn't clear errors
> > and is used by device flushing code (fdatawait_one_bdev(), wait_sb_inodes()).
> 
> filemap_fdatawait_keep_errors() calls __filemap_fdatawait_range() which
> clears PG_error on every page.
> What it doesn't do is call filemap_check_errors(), and so doesn't clear
> AS_ENOSPC or AS_EIO.
> 
> 

I think it's helpful to get a clear idea of what happens now in the face
of errors and what we expect to happen, and I don't quite have that yet:

--------------------------8<-----------------------------
void page_endio(struct page *page, bool is_write, int err)
{
        if (!is_write) {
                if (!err) {
                        SetPageUptodate(page);
                } else {
                        ClearPageUptodate(page);
                        SetPageError(page);
                }
                unlock_page(page);
        } else {
                if (err) {
                        SetPageError(page);
                        if (page->mapping)
                                mapping_set_error(page->mapping, err);
                }
                end_page_writeback(page);
        }
}
--------------------------8<-----------------------------

...not everything uses page_endio, but it's a good place to look since
we have both flavors of error handling in one place.

On a write error, we SetPageError and set the error in the mapping.

What I'm not clear on is:

1) what happens to the page at that point when we get a writeback error?
Does it just remain in-core and is allowed to service reads (assuming
that it was uptodate before)?

Can I redirty it and have it retry the write? Is there standard behavior
for this or is it just up to the whim of the filesystem?

I'll probably have questions about the read side as well, but for now it
looks like it's mostly used in an ad-hoc way to communicate errors
across subsystems (block to fs layer, for instance).
--
Jeff Layton <jlayton@redhat.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
