From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.2
Date: 01 Dec 2003 09:40:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070293210.1778.25.camel@mulgrave>
References: <002b01c3b7f8$5e6fbf20$a0074d0a@apac.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:4101 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263506AbTLAPkw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Dec 2003 10:40:52 -0500
In-Reply-To: <002b01c3b7f8$5e6fbf20$a0074d0a@apac.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: "Surekha.PC" <surekhap@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, 'Naveen Burmi' <naveenb@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Mon, 2003-12-01 at 04:46, Surekha.PC wrote:
> Our driver has lot of user space attributes. Making each attribute as a
> separate file will endup with lots of files. So we want to have all
> target specific attributes together in one file and lun specific
> attributes in another file for convinience. find_keyword() will help
> search for these keys from the cmdline specified.
> 
> Pls let me know your suggestions.

I count 35 total (for both host and target); that's well within the
range of the sysfs single file per value.  A lot of them also seem to be
debug attributes, so won't they go away (or at least only compile in
under a DEBUG #define) with the released product?

The idea behind sysfs is easily and uniformly to export data to the
user, and to import it from the user.  You could separate the properties
out into those which are useful to the end user, and those which are for
developers only.  If there's enough of the latter, we could ask the
sysfs people for a more flexible interface.

James


