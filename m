From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] add ssleep(), kill scsi_sleep()
Date: Wed, 18 Aug 2004 22:58:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040818225853.183b9696.akpm@osdl.org>
References: <412431D2.5080904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:4575 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265943AbUHSGAf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 02:00:35 -0400
In-Reply-To: <412431D2.5080904@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Jeff Garzik <jgarzik@pobox.com> wrote:
>
> So, the kernel needs a 'sleep', but that token is far too common, so I 
>  chose ssleep().

Dorky name, but whatever.

>  scsi_sleep() is a manually implemented msleep(), so I remove it.

scsi_sleep() was buggy anyway: the CPU running scsi_sleep_done() could
still be dinking with the semaphore when it goes out of scope on the CPU
running scsi_sleep().  That's why struct completion was added.

