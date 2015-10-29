From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1 10/25] hpsa: correct check for non-disk devices
Date: Thu, 29 Oct 2015 15:37:56 +0100
Message-ID: <56322F44.4030402@redhat.com>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220530.5323.72852.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757316AbbJ2OiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 10:38:00 -0400
In-Reply-To: <20151028220530.5323.72852.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 28.10.2015 23:05, Don Brace wrote:
> The driver is using two MACROs which seemingly are looking in
> the wrong location for the device_flags returned from
> CISS_REPORT_PHYS. Both MACROs, NON_DISK_PHYS_DEV and
> PHYS_IOACCEL, are using the pointer returned from figure_lunaddrbytes
> which is the address of the LUN.lunid element in
> the extended CISS_REPORT_PHYS.  But the MACROS are using offsets
> beyond the range of the element (offset 17 of an 8 byte element).
>
> These MACROs actually are looking at the correct location but
> they fail static checker analysis. It also will not work
> if any new elements are added to the extended LUN structure.
>
> Change the code to use the structure elements directly
> since this MACRO is only used in one location.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

