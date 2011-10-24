From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 8/9] ib_srpt: Convert srp_max_rsp_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 13:05:23 -0700
Message-ID: <1319486723.17450.59.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-9-git-send-email-nab@linux-iscsi.org>
	 <CAO+b5-p24uYKbwqCRWVik63gL-ZABgcJrqAi7ULJZEP+CK1WEg@mail.gmail.com>
	 <1319485752.17450.57.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-qVEOEQ=Y_NCYJejjag=mgrGutpHLTVOKFTRsxR623tEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAO+b5-qVEOEQ=Y_NCYJejjag=mgrGutpHLTVOKFTRsxR623tEg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 21:58 +0200, Bart Van Assche wrote:
> On Mon, Oct 24, 2011 at 9:49 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > On Mon, 2011-10-24 at 21:44 +0200, Bart Van Assche wrote:
> >> On Mon, Oct 24, 2011 at 7:33 AM, Nicholas A. Bellinger
> >> <nab@linux-iscsi.org> wrote:
> >> > +static ssize_t srpt_tpg_attrib_store_srp_max_rsp_size(
> >> > +       struct se_portal_group *se_tpg,
> >> > +       const char *page,
> >> > +       size_t count)
> >> > +{
> >> > +       struct srpt_port *sport = container_of(se_tpg, struct srpt_port, port_tpg_1);
> >> > +       unsigned long val;
> >> > +       int ret;
> >> > +
> >> > +       ret = strict_strtoul(page, 0, &val);
> >>
> >> If the data "page" points at only consists of digits, the above
> >> strict_strtoul() call will trigger a past-end-of-buffer read.
> >
> > I don't understand what you mean here.  Can you provide a test case to
> > demonstrate please..?
> 
> echo -n "345" >$configfs_path_of_parameter.
> 

Still not sure what your getting at here..?

root@tifa:/sys/kernel/config/target/srpt/0x00000000000000000002c903000e8acd/tpgt_1/attrib# ls -la
total 0
drwxr-xr-x 2 root root    0 Oct 24 13:01 .
drwxr-xr-x 7 root root    0 Oct 24 12:58 ..
-rw-r--r-- 1 root root 4096 Oct 24 12:58 srp_max_rdma_size
-rw-r--r-- 1 root root 4096 Oct 24 13:01 srp_max_rsp_size
-rw-r--r-- 1 root root 4096 Oct 24 12:58 srp_sq_size

root@tifa:/sys/kernel/config/target/srpt/0x00000000000000000002c903000e8acd/tpgt_1/attrib# cat srp_max_rsp_size
256
root@tifa:/sys/kernel/config/target/srpt/0x00000000000000000002c903000e8acd/tpgt_1/attrib# echo -n "240" > srp_max_rsp_size
root@tifa:/sys/kernel/config/target/srpt/0x00000000000000000002c903000e8acd/tpgt_1/attrib# cat srp_max_rsp_size
240
