From: "Tony Luck" <tony.luck@intel.com>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Mon, 24 Jul 2006 10:27:55 -0700
Message-ID: <12c511ca0607241027y39498f37le4e5f2b320e01e4a@mail.gmail.com>
References: <20060603112610.GB17018@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:27936 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932236AbWGXR2F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 13:28:05 -0400
Received: by py-out-1112.google.com with SMTP id c39so2463881pyd
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 10:27:55 -0700 (PDT)
In-Reply-To: <20060603112610.GB17018@lst.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, fischer@norbit.de, linux-scsi@vger.kernel.org

On 6/3/06, Christoph Hellwig <hch@lst.de> wrote:
> Currently struct scsi_cmnd has various fields that are used to backup
> original data after the corresponding fields have been overridden for
> EH commands.  This means drivers can easily get at it and misuse it.
> Due to the old_ naming this doesn't happen for most of them, but two
> that have different names have been used wrong a lot (see previous
> patch).

I guess that I'm an abuser  :-(

> Index: scsi-misc-2.6/include/scsi/scsi_cmnd.h

> -       void *buffer;           /* Data buffer */

arch/ia64/hp/sim/simscsi.c is still using this (and so doesn't compile
now that this change has hit mainline).  It seems that simscsi.c is
expecting to find a "scatterlist" there ... but looking at the rest of
the patch that removed this element, it isn't obvious where it went.

-Tony
