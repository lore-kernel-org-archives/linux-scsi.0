From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 13:19:29 -0700
Message-ID: <1319487569.17450.67.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-9-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg@mail.gmail.com>
	 <1319485752.17450.57.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qVEOEQ=Y_NCYJejjag=mgrGutpHLTVOKFTRsxR623tEg@mail.gmail.com>
	 <1319486723.17450.59.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qXTPNQH1xdjciT+oR0GyJT_nHiP4G_6bL1UWi4rOim5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qXTPNQH1xdjciT+oR0GyJT_nHiP4G_6bL1UWi4rOim5w@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 22:11 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 10:05 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > On Mon, 2011-10-24 at 21:58 +0200, Bart Van Assche wrote:
> >> On Mon, Oct 24, 2011 at 9:49 PM, Nicholas A. Bellinger
> >> <nab@linux-iscsi.org> wrote:
> >> > On Mon, 2011-10-24 at 21:44 +0200, Bart Van Assche wrote:
> >> >> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> >> >> <nab@linux-iscsi.org> wrote:
> >> >> > +static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
> >> >> > +       struct se_portal_group *se_tpg,
> >> >> > +       const char *page,
> >> >> > +       size_t count)
> >> >> > +{
> >> >> > +       struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
> >> >> > +       unsigned long val;
> >> >> > +       int ret;
> >> >> > +
> >> >> > +       ret = strict_strtoul(page, 0, &val);
> >> >>
> >> >> If the data "page" points at only consists of digits, the above
> >> >> strict_strtoul() call will trigger a past-end-of-buffer read.
> >> >
> >> > I don't understand what you mean here.  Can you provide a test case to
> >> > demonstrate please..?
> >>
> >> echo -n "345" >$configfs_path_of_parameter.
> >
> > Still not sure what your getting at here..?
> 
> Only the data in page[0..count-1] is guaranteed to be initialized.
> strict_strtoul() will read until it either finds whitespace or a
> binary zero, so if the data in page[] does neither contain whitespace
> nor a binary zero then strict_strtoul() will read past the end of the
> data in page[]. There may be any data at page[count], including a
> valid digit.
> 

That is part obvious.  The point your missing is that configfs is
already sanitizing the the incoming buffer in fs/configfs/file.c to work
with strict_strtoul() here:

static int
fill_write_buffer(struct configfs_buffer * buffer, const char __user * buf, size_t count)
{
        int error;

        if (!buffer->page)
                buffer->page = (char *)__get_free_pages(GFP_KERNEL, 0);
        if (!buffer->page)
                return -ENOMEM;

        if (count >= SIMPLE_ATTR_SIZE)
                count = SIMPLE_ATTR_SIZE - 1;
        error = copy_from_user(buffer->page,buf,count);
        buffer->needs_read_fill = 1;
        /* if buf is assumed to contain a string, terminate it by \0,
         * so e.g. sscanf() can scan the string easily */
        buffer->page[count] = 0;
        return error ? -EFAULT : count;
}
