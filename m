From: Andrew Morton <akpm@osdl.org>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Wed, 2 Feb 2005 18:08:17 -0800
Message-ID: <20050202180817.47db64c2.akpm@osdl.org>
References: <001001c508d9$d97a17f0$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fw.osdl.org ([65.172.181.6]:60553 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262977AbVBCCIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Feb 2005 21:08:22 -0500
In-Reply-To: <001001c508d9$d97a17f0$9300a8c0@erich2003>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: erich <erich@areca.com.tw>
Cc: linux-scsi@vger.kernel.org

"erich" <erich@areca.com.tw> wrote:
>
> I have contact with Andrew Morton about ARECA RAID Linux scsi driver release
>  issue.
>  I hope this package is as look like a Linux driver.

No, it doesn't look anything like a Linux driver :(

I fed the patch through scripts/Lindent.  There's a copy at
http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
 I'll include it -mm kernels.

>From a very quick look, I'd say that the driver needs quite a bit of work:

- Remove Documentation/scsi/arcmsr.txt - none of it is relevant

- Use named structure initialisers:

	struct foo bar = {
		.name1 = value1,
		.name2 = value2,
	};

- Remove all the LINUX_VERSION_CODE tests

- The kernel thread stopping/starting stuff is old fashioned.  Use the
  kthread API.

- I suspect it is using old-fashioned SCSI APIs too.


