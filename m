From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V6 08/10] [SCSI] aacraid: Send commit-config to
 controller firmware
Date: Tue, 25 Aug 2015 08:11:14 -0700
Message-ID: <20150825151114.GA25134@infradead.org>
References: <1439272701-15344-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1439272701-15344-9-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <55DC8256.4060102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51344 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbbHYPLR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2015 11:11:17 -0400
Content-Disposition: inline
In-Reply-To: <55DC8256.4060102@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, JBottomley@Parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

On Tue, Aug 25, 2015 at 04:57:26PM +0200, Tomas Henzl wrote:
> On 11.8.2015 07:58, Mahesh Rajashekhara wrote:
> > +#if defined(__powerpc__) || defined(__PPC__) || defined(__ppc__)
> > +	aac_get_config_status(aac, 1);
> > +#else
> >  	aac_get_config_status(aac, 0);
> > +#endif
> 
> If we use instead
> +	aac_get_config_status(aac, 1);
> on all archs will it make problems ?

Yes, that should be our first choice.  If that doesn't work it should
be a #ifndef CONFIG_X86 with a comment explaining it.
