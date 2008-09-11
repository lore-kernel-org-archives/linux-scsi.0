From: "Chris Leech" <christopher.leech@intel.com>
Subject: Re: [PATCH 1/3] 24-bit types: typedef and macros for accessing 3-byte arrays as integers
Date: Wed, 10 Sep 2008 18:51:37 -0700
Message-ID: <41b516cb0809101851p79f73499vbd10dec4f6bdeccb@mail.gmail.com>
References: <20080905165732.16689.50256.stgit@localhost.localdomain>
	 <20080910140712.GA12280@infradead.org>
	 <1221061241.27385.14.camel@norville.austin.ibm.com>
	 <48C7F19D.3080507@panasas.com>
Reply-To: chris.leech@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:8331 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbYIKBvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2008 21:51:39 -0400
Received: by yx-out-2324.google.com with SMTP id 8so52319yxm.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2008 18:51:38 -0700 (PDT)
In-Reply-To: <48C7F19D.3080507@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org

On Wed, Sep 10, 2008 at 9:11 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Chris you might want to change the definitions at linux/types.h
> to:
>
> typedef struct { __u8 b[3]; } __be24, __le24 __packed;
>
> With gcc it will not help with the proceeding fields, and the
> containing struct will need it's own "__packed" declaration
> but it will keep it packed with previous fields.

I haven't seen padding added simply because of a nested structure
boundary, but I'm not up on all the ABIs for the different
architectures.  Obviously a containing structure would want to have
the 24-bit type adjacent to an 8-bit type, or have it's own packed
attribute if needed.

It shouldn't hurt, in this case the members shouldn't be expected to
have more than byte alignment anyway, but I can't see how it would
help.

If there's a particular arch that might be a problem I'm happy to look
into it, but I don't want to start throwing packed attributes around
just in case.

Chris
