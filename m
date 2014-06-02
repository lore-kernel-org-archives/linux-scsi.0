From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 1/1] drivers/scsi/bfa/bfad_debugfs.c: replace 2
 kzalloc/copy_from_user to memdup_user
Date: Mon, 2 Jun 2014 15:53:40 +0100
Message-ID: <20140602155340.0814cf04@alan.etchedpixels.co.uk>
References: <1401469656-10332-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401469656-10332-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 30 May 2014 19:07:36 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> (memdup_user can be used to replace kmalloc/copy_from_user. Not sure if it's ok with kzalloc ...)


> +	kern_buf = memdup_user((void __user *)buf, nbytes);

> +	if (IS_ERR(kern_buf)) {
> +		printk(KERN_INFO "bfad[%d]: Failed to copy buffer\n",
> +		       bfad->inst_no);

While you are tidying up lose the printk KERN_INFO stuff here, it really
isn't needed.

Looks good to me and it also fixes the incorrect return of -ENOMEM the
old code had on a copy_from_user failing.

Alan
