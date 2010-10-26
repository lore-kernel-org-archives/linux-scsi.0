From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsas: do not return error for table2table link
Date: Tue, 26 Oct 2010 14:34:34 -0500
Message-ID: <1288121674.8283.476.camel@mulgrave.site>
References: <646EF126DF5645B48AF69E3E459A1CB7@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab0JZTeo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2010 15:34:44 -0400
In-Reply-To: <646EF126DF5645B48AF69E3E459A1CB7@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'tom_peng' <tom_peng@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>, linux-scsi@vger.kernel.org, "'Darrick J. Wong'" <djwong@us.ibm.com>

On Wed, 2010-10-06 at 17:13 +0800, Jack Wang wrote:
> Hi, all
> 
> In SAS2 spec table to table link is allowed and useful in self-configurable
> topology, so we should not return error for this.
> 
> Jack

So I'm not against this type of patch in principle ... we do need to add
support for SAS-2 expanders.  However, the table to table configuration
is illegal and non-functional for SAS-1 expanders, so we can't just drop
it globally; it's also optional in SAS-2 not mandatory.  We can tell if
an expander supports table to table routing from byte 10 in the report
general response ... this type of check should be keyed off that.  [As
should probably a whole host of other things, such as not trying to
construct the routing table if the expander is self configuring].

James


