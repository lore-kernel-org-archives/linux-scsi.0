From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Xen-devel] [PATCH V5 2/5] Add XEN pvSCSI protocol description
Date: Fri, 22 Aug 2014 05:04:30 -0700
Message-ID: <20140822120430.GA28916@infradead.org>
References: <1408354310-6362-1-git-send-email-jgross@suse.com>
 <1408354310-6362-3-git-send-email-jgross@suse.com>
 <20140820132503.GE3120@laptop.dumpdata.com>
 <53F4AA55.3030004@suse.com>
 <20140821192626.GC18662@laptop.dumpdata.com>
 <53F6C47B.5010900@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53F6C47B.5010900@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 22, 2014 at 06:18:03AM +0200, Juergen Gross wrote:
> >>The resulting number of struct scsiif_request_segment is the sum of
> >>seg[0..nr_segments-1].length / sizeof(struct scsiif_request_segment).
> >>
> >
> >Where the nr_segments can only go Up to VSCSIIF_SG_TABLESIZE, so the max
> >total SG entries you can is 13312 ( 4096 / 8 = 512 max per page, times
> >26).
> 
> In theory, yes. SG_ALL (being 128 today) is limiting this value.

Note that SG_ALL (or SCSI_MAX_SG_SEGMENTS which is a better name for it)
is only the maximum if your driver doesn't support S/G chaining.  Given
that it and the Xen infrastructure seems to use the proper s/g list
helpers it should support SCSI_MAX_SG_CHAIN_SEGMENTS easily.
