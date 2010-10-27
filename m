From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] libsas: do not return error for table2table link
Date: Wed, 27 Oct 2010 10:19:03 +0800
Message-ID: <2AF74BBAE8444305AD20BDDDE344DC2A@usish.com.cn>
References: <646EF126DF5645B48AF69E3E459A1CB7@usish.com.cn> <1288121674.8283.476.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:34859 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab0J0CPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 22:15:55 -0400
In-Reply-To: <1288121674.8283.476.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>
Cc: 'tom_peng' <tom_peng@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'roy' <roy_wang@usish.com>, linux-scsi@vger.kernel.org, "'Darrick J. Wong'" <djwong@us.ibm.com>


On Wed, 2010-10-06 at 17:13 +0800, Jack Wang wrote:
> Hi, all
> 
> In SAS2 spec table to table link is allowed and useful in
self-configurable
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


Hi James

You are right, the right direction is to check the response of REPORT
GENERAL to see whether the expander is self-configuring and supports table
to table
attachment, and check the DISCOVER response to see the routing attribute of
each phy when check the topology. But I think this patch is a start point,
even in 
SAS-1 expander we also print some error message to inform the admin to check
the topology, and in SAS-2 expander can discover the topology not to hang
and give a oops!

Thanks!
Jack

