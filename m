From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Patch?: linux-2.5.45/drivers/scsi/hosts.[ch] - Eliminate scsi_host_tmpl_list
Date: Thu, 7 Nov 2002 12:00:45 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107120045.A14136@eng2.beaverton.ibm.com>
References: <200211060051.QAA27231@adam.yggdrasil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211060051.QAA27231@adam.yggdrasil.com>; from adam@yggdrasil.com on Tue, Nov 05, 2002 at 04:51:56PM -0800
List-Id: linux-scsi@vger.kernel.org
To: "Adam J. Richter" <adam@yggdrasil.com>
Cc: James.Bottomley@HansenPartnership.com, hch@lst.de, linux-scsi@vger.kernel.org

On Tue, Nov 05, 2002 at 04:51:56PM -0800, Adam J. Richter wrote:
> 	Although I haven't tested it, Christoph's version of my
> patch to remove Scsi_Host_Name looks OK to me.
> 

OK, I ran some more tests.

strpbrk() returns a pointer to the char searched for, so using
a command line like: 

	scsihosts=aic7xxx,ips,scsi_debug

Hangs in scsi_host_hn_init, as we keep getting a pointer back from
strpbrk() pointing to ",ips,scsi_debug". And a similiar problem with
scsi_alloc_host_num.

I fixed that, and added code in scsi_alloc_host_num to reuse empty
slots (if no match on scsihosts or scsihosts is empty).

But, there is no way to match the previous functionallity without having
a host name list.

That is before the patch we can do this:

	insmod foo; insmod bar

And foo gets scsi4, bar scsi5. And then:

	rmmod foo; rmmod bar
	insmod bar; insmod foo

And foo should still be scsi4, bar scsi5.

Without the host name list, the best we can do is have
foo become scsi5, and bar scsi4.

I think we should forget about this patch for now, and at some time in
the future after we have some device naming persistence drop the name
list and scsihosts option.

-- Patrick Mansfield
