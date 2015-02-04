From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 0/9] vhost/scsi: Add ANY_LAYOUT + VERSION_1 support
Date: Wed, 04 Feb 2015 00:51:01 -0800
Message-ID: <1423039861.28700.4.camel@haakon3.risingtidesystems.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
	 <20150203093522.GJ2830@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56373 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbbBDIvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2015 03:51:03 -0500
In-Reply-To: <20150203093522.GJ2830@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>

On Tue, 2015-02-03 at 11:35 +0200, Michael S. Tsirkin wrote:
> On Tue, Feb 03, 2015 at 06:29:54AM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi MST, Paolo, Al & Co,
> > 
> > Here is -v3 for adding vhost/scsi ANY_LAYOUT + VERSION_1 host feature
> > bit support.
> > 
> > It adds a new vhost_virtqueue ->handle_kick() callback to determine the
> > start of protection and data payloads iovecs past starting virtio-scsi
> > request and response headers, based upon data_direction using iov_iter
> > primitives.
> > 
> > It assumes request/CDB and response/sense_buffer headers may span more
> > than a single iovec using mm/iov_iter.c logic.
> > 
> > It also allows virtio-scsi headers + T10_PI + Data SGL payloads to span
> > the same iovec when pinning user-space memory via get_user_pages_fast()
> > code.  (Not tested yet)
> > 
> > Based upon Al & HCH's feedback, the patch series has been converted to
> > use copy_*_iter() for virtio-scsi header copy.  Also, patch #4 has been
> > updated to use iov_iter_npages() for sgl_count, and patch #5 updated to
> > use iov_iter_advance() for calculating prot_bytes offset to the start
> > of data_iter.
> > 
> > v3 changelog:
> >   - Convert memcpy_toiovecend -> copy_to_iter usage
> >   - Update vhost_scsi_mapal + friends to use iov_iter
> >   - Move iov_iter sanity checks into vhost_scsi_calc_sgls
> >   - Convert vhost_scsi_calc_sgls() to iov_iter_npages()
> >   - Convert to vhost_scsi_handle_vqal to copy_from_iter usage
> >   - Update vhost_scsi_handle_vqal comments for iov_iter usage
> >   - Convert prot_bytes offset to use iov_iter_advance
> >   - Drop max_niov usage in vhost_scsi_handle_vqal
> >   - Drop vhost_skip_iovec_bytes in favour of iov_iter
> > 
> > Note the one part that has been left unchanged is vhost_scsi_map_to_sgl()
> > into get_user_pages_fast(), for which existing iov_iter_get_pages() code
> > will need to allow for a callback to perform the associated scatterlists
> > setup from **pages for protection + data payloads.
> 
> I'm not sure it has to be a callback: maybe just add
> struct scatterlist *sg parameter and use it if set.
> 

Al, any preference on how this should work..?

--nab

